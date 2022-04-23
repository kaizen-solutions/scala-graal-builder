# A Docker image to build Scala & Graal Native Image projects

This image relies on SDKMAN to provide the following:
* The latest version of SBT at the time of building
* A GraalVM CE flavour of the JVM (currently `22.0.0.2.r17`)
* Graal Native Image to build native image binaries.


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