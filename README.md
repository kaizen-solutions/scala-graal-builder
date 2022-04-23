# A Docker image to build Scala & Graal Native Image projects

![Docker Image Size](https://flat.badgen.net/docker/size/rubixcubin/scala-graal-builder)
[![Chat on Discord](https://img.shields.io/discord/955126399100932106?label=chat%20on%20discord)](https://discord.gg/qw2nGFzU)

This image relies on SDKMAN to provide the following:
* The latest version of SBT at the time of building
* A GraalVM CE flavour of the JVM (currently `22.0.0.2.r17`)
* Graal Native Image to build native image binaries.

This [image](https://hub.docker.com/repository/docker/rubixcubin/scala-graal-builder/tags?page=1&ordering=last_updated) is built for Linux/AMD64 and Linux/ARM64 platforms thanks to Docker Buildx and GitHub Workflow

<img width="772" alt="image" src="https://user-images.githubusercontent.com/14280155/164943591-9d4a713b-95f5-475a-8152-9637d5d96db1.png">


## Building locally

1. `docker build -t rubixcubin/scala-graal-builder:local .`
2. `docker run -it rubixcubin/scala-graal-builder:local bash`


## Recommended usage
You can use a multi-stage build if you want to use this image to build your project
and leverage the artifacts produced by the build in a smaller image to package and serve your application.

For example, for a native-image build:
```Dockerfile
# Step 1: Use this image to build your project
FROM rubixcubin/scala-graal-builder:latest as builder
COPY . /build
WORKDIR /build

# This generates the binary that represents your application
RUN sbt graalvm-native-image:packageBin

# This is what you want to use to package and run your application
FROM gcr.io/distroless/base
COPY --from=builder /build/your-project/target/graalvm-native-image /app
CMD ["/app/your-app"]
```
