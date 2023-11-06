FROM debian:11-slim

# Artifact information
ARG sdkmanGraalJavaVersion="21-graal"

# User information
ARG username="builder"
ARG useruid=1000
ARG groupid=1000
ARG groupname="buildergroup"
ARG home="/home/$username"

SHELL ["/bin/bash", "-c"]

# Add a non-root user and specify dependencies needed for SDKMAN and GraalVM native image
RUN groupadd -g $groupid $username && \
	useradd -m -g $groupid -u $useruid $username && \
    apt-get update && \
    apt-get install -y curl zip build-essential libz-dev zlib1g-dev

# Switch to the user
USER $useruid:$groupid

# Install SDKMAN
RUN curl -s "https://get.sdkman.io" | bash && \
    source $home/.sdkman/bin/sdkman-init.sh && \
    sdk install java $sdkmanGraalJavaVersion && \
    sdk install sbt && \
    gu install native-image
