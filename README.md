# Notes for stream memes team:

We have made some core changes to this package from the original fork.  And building for node 22 runtime is different than other runtimes as far as we can tell.

Changes made to this package:

1. We have removed the libraries we have no need for.  This means we removed konva, chart.js, chart.js canvas, etc.
2. We have removed the associated tests with konva and now we just kept the test to verify canvas itself works.

How we built and probably how we can build in the future...

1. I created a fresh EC2 instance and scp'd this package over to it.
2. Then I ran commands to install docker and docker compose.
3. Then I created the following docker compose file:

version: "3.8"

services:
  amazonlinux:
    image: amazonlinux:latest
    container_name: amazonlinux_container
    stdin_open: true
    tty: true
    volumes:
      - /home/ec2-user/development/streammemes/lambda-layer-canvas-nodejs:/mnt/workdir
    working_dir: /mnt/workdir

4. Of course make sure the volume mapping is correct.
5. `docker pull amazonlinux`
6. Run `docker-compose up -d`
7. Hop inside the container to do the build `docker exec -it amazonlinux_container bash`
8. inside the container hop into the workdir `cd /mnt/workdir`
9. Then here we can run the commands that are commented out at the top of the build-layer.sh file.  This is the stuff to install nvm & node, and the system level libraries that are dependencies of canvas.
10. Once we see everything install successfully, we can run `bash build-layer.sh` and this will create a zip that should be ready to go for the latest nodejs and amazonlinux version.
11. IMPORTANT.  Whatever is going to use this layer MUST have the following environment variable set:
`LD_LIBRARY_PATH: "/opt/lib:/lib64:/usr/lib64:/var/lang/lib:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib"`
This is because the latest version of lambda nodejs 22 runtime wants to look at /lib64 directory FIRST for the system level dependencies.  What we want to make sure is that the runtime looks at the /opt/lib directory first for those deps and only if it cant find them there do we want it to look at /lib64.

Prior to this env var update we were seeing the following error:

```
{"errorType":"Error","errorMessage":"/opt/lib/libpango-1.0.so.0: undefined symbol: g_once_init_leave_pointer" ...
```

ends up that libpango has a dep on libglib-2.0.so.0 which is where g_once_init_leave_pointer should be defined, but when we run ldd, we saw it was loooking in the wrong place.  But after we updated the LD_LIBRARY_PATH it was fine.  We did investigation by building the layer, uploading it, creating a fresh lambda and then using the following code after adding this lambda layer on there to see how it was resolving the deps for the offending package.  This is what that code looked like:

```
import { execSync } from "child_process";
import fs from "fs";

export async function handler(event) {
    try {
        console.log("===== Lambda Environment Check =====");

        // Check if /opt/lib exists
        const optLibExists = fs.existsSync("/opt/lib");
        console.log(`✅ /opt/lib exists: ${optLibExists}`);

        // Run ldd to check linked libraries for libpango
        let libCheck = "";
        try {
            libCheck = execSync("ldd /opt/lib/libpango-1.0.so.0 || ldd /lib64/libpango-1.0.so.0", { encoding: "utf-8" });
            console.log("📌 ldd output for libpango-1.0.so.0:\n" + libCheck);
        } catch (error) {
            console.error("❌ Error running ldd on libpango-1.0.so.0:", error.message);
        }

        // Check for libglib specifically
        let glibCheck = "";
        try {
            glibCheck = execSync("ldd /opt/lib/libglib-2.0.so.0 || ldd /lib64/libglib-2.0.so.0", { encoding: "utf-8" });
            console.log("📌 ldd output for libglib-2.0.so.0:\n" + glibCheck);
        } catch (error) {
            console.error("❌ Error running ldd on libglib-2.0.so.0:", error.message);
        }

        // Get LD_LIBRARY_PATH to see where Lambda is looking for shared libraries
        let ldLibraryPath = execSync("echo $LD_LIBRARY_PATH", { encoding: "utf-8" }).trim();
        console.log(`📌 LD_LIBRARY_PATH:\n${ldLibraryPath}`);

        console.log("===== End of Lambda Check =====");

        return { statusCode: 200, body: "Check logs in CloudWatch for details." };

    } catch (error) {
        console.error("❌ Unexpected error:", error.message);
        console.error(error.stack);
        return { statusCode: 500, body: "Error occurred. Check CloudWatch logs." };
    }
}
```

The output we want to see looks like this:

```
START RequestId: c94bddff-9ed8-45da-bca7-64cf8520b05b Version: $LATEST
2025-02-07T20:36:29.630Z	c94bddff-9ed8-45da-bca7-64cf8520b05b	INFO	===== Lambda Environment Check =====
2025-02-07T20:36:29.654Z	c94bddff-9ed8-45da-bca7-64cf8520b05b	INFO	✅ /opt/lib exists: true
2025-02-07T20:36:30.255Z	c94bddff-9ed8-45da-bca7-64cf8520b05b	INFO	📌 ldd output for libpango-1.0.so.0:
	linux-vdso.so.1 (0x00007ffd81bf4000)
	libm.so.6 => /opt/lib/libm.so.6 (0x00007fbdba756000)
	libglib-2.0.so.0 => /opt/lib/libglib-2.0.so.0 (0x00007fbdba604000)
	libgobject-2.0.so.0 => /opt/lib/libgobject-2.0.so.0 (0x00007fbdba5a1000)
	libgio-2.0.so.0 => /opt/lib/libgio-2.0.so.0 (0x00007fbdba3c3000)
	libfribidi.so.0 => /opt/lib/libfribidi.so.0 (0x00007fbdba3a3000)
	libthai.so.0 => /opt/lib/libthai.so.0 (0x00007fbdba396000)
	libharfbuzz.so.0 => /opt/lib/libharfbuzz.so.0 (0x00007fbdba298000)
	libc.so.6 => /opt/lib/libc.so.6 (0x00007fbdba090000)
	/lib64/ld-linux-x86-64.so.2 (0x00007fbdba89e000)
	libpcre2-8.so.0 => /opt/lib/libpcre2-8.so.0 (0x00007fbdb9ff2000)
	libffi.so.8 => /opt/lib/libffi.so.8 (0x00007fbdb9fe6000)
	libgmodule-2.0.so.0 => /opt/lib/libgmodule-2.0.so.0 (0x00007fbdb9fdf000)
	libz.so.1 => /opt/lib/libz.so.1 (0x00007fbdb9fc3000)
	libmount.so.1 => /opt/lib/libmount.so.1 (0x00007fbdb9f7e000)
	libselinux.so.1 => /opt/lib/libselinux.so.1 (0x00007fbdb9f51000)
	libdatrie.so.1 => /opt/lib/libdatrie.so.1 (0x00007fbdb9f48000)
	libfreetype.so.6 => /opt/lib/libfreetype.so.6 (0x00007fbdb9e72000)
	libgraphite2.so.3 => /opt/lib/libgraphite2.so.3 (0x00007fbdb9e50000)
	libblkid.so.1 => /opt/lib/libblkid.so.1 (0x00007fbdb9e15000)
	libbz2.so.1 => /opt/lib/libbz2.so.1 (0x00007fbdb9e01000)
	libpng16.so.16 => /opt/lib/libpng16.so.16 (0x00007fbdb9dc5000)
	libbrotlidec.so.1 => /opt/lib/libbrotlidec.so.1 (0x00007fbdb9db7000)
	libbrotlicommon.so.1 => /opt/lib/libbrotlicommon.so.1 (0x00007fbdb9d94000)

2025-02-07T20:36:30.375Z	c94bddff-9ed8-45da-bca7-64cf8520b05b	INFO	📌 ldd output for libglib-2.0.so.0:
	linux-vdso.so.1 (0x00007ffc68d91000)
	libpcre2-8.so.0 => /opt/lib/libpcre2-8.so.0 (0x00007f0aa762c000)
	libc.so.6 => /opt/lib/libc.so.6 (0x00007f0aa7424000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f0aa781e000)

2025-02-07T20:36:30.414Z	c94bddff-9ed8-45da-bca7-64cf8520b05b	INFO	📌 LD_LIBRARY_PATH:
/opt/lib:/lib64:/usr/lib64:/var/lang/lib:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib
2025-02-07T20:36:30.415Z	c94bddff-9ed8-45da-bca7-64cf8520b05b	INFO	===== End of Lambda Check =====
END RequestId: c94bddff-9ed8-45da-bca7-64cf8520b05b
REPORT RequestId: c94bddff-9ed8-45da-bca7-64cf8520b05b	Duration: 806.81 ms	Billed Duration: 807 ms	Memory Size: 128 MB	Max Memory Used: 77 MB	Init Duration: 166.73 ms	
```

previously, without the env var we were seeing lines like `	libglib-2.0.so.0 => /lib64/libglib-2.0.so.0`

Hopefully this helps with any future issues.

# Canvas Layer for AWS Lambda

![GitHub](https://img.shields.io/github/license/charoitel/lambda-layer-canvas-nodejs)

Canvas Layer for AWS Lambda is published and available on [AWS Serverless Application Repository](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:990551184979:applications~lambda-layer-canvas-nodejs), and GitHub at [charoitel/lambda-layer-canvas-nodejs](https://github.com/charoitel/lambda-layer-canvas-nodejs). The layer aims to provide a Cairo backed Mozilla Web Canvas API implementation layer for AWS Lambda, powered by [node-canvas](https://github.com/Automattic/node-canvas).

## About node-canvas

[node-canvas](https://github.com/Automattic/node-canvas) is a Cairo backed Canvas implementation for Node.js. It implements the [Mozilla Web Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) as closely as possible. For the latest API compliance, you may check [Compatibility Status](https://github.com/Automattic/node-canvas/wiki/Compatibility-Status).

## How this layer is built?

The layer is built from source of node-canvas npm package on [amazonlinux](https://hub.docker.com/_/amazonlinux) dev container instance, with following native dependencies installed. You may check the build layer script, ``` build-layer.sh ```, which is available in repository, for details.

```bash
gcc-c++ cairo-devel pango-devel libjpeg-turbo-devel giflib-devel librsvg2-devel pango-devel bzip2-devel jq python3
```

Since AWS Lambda is a secure and isolated runtime and execution environment, the layer aims to target AWS Lambda compatible and native build. As there are canvas libraries and frameworks relying on node-canvas running on Node.js runtime, this layer may also try to include and support those libraries and frameworks. Currently, following libraries and frameworks are included when building and packaging the layer:

- [Chart.js](#chartjs-support)
- [Fabric.js](#fabricjs-support)
- [Konva](#konva-support)

### Chart.js support

[Chart.js](https://github.com/chartjs/chart.js) provides a set of frequently used chart types, plugins, and customization options. In addition to a reasonable set of built-in chart types, there are also community-maintained chart types.

> Current supported version chart.js@3.9.1 with chartjs-node-canvas@4.1.6

### Fabric.js support

[Fabric.js](https://github.com/fabricjs/fabric.js) provides a missing and interactive object model for canvas, as well as an SVG parser, layer of interactivity, and a whole suite of other indispensable tools.

> Current supported version fabric@6.4.2

### Konva support

[Konva](https://github.com/konvajs/konva) enables high performance animations, transitions, node nesting, layering, filtering, caching, event handling for desktop and mobile applications, and much more.

> Current supported version konva@9.3.15
