FROM openjdk:8-jdk-alpine AS build
RUN apk add --no-cache curl tar bash procps

# Downloading and installing Maven
ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && echo "Downloading maven" \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  \
  && echo "Checking download hash" \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  \
  && echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# Install project dependencies and keep sources
# Make source folder
RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

# install Maven dependency packages (keep in image)
COPY pom.xml /usr/src/app

# copy other source files (keep in image)
COPY src /usr/src/app/src

RUN echo "Packaging app" \
  && mvn -T 1C package

COPY target/java-maven-hellow-world.jar .

# Configure a container that will run as an executable. The exec form (between square brackets).
# See https://docs.docker.com/engine/reference/builder/#entrypoint
ENTRYPOINT ["java","-jar","java-maven-hellow-world.jar"]
CMD ["-c"]
