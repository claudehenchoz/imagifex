# imagifex Java Developer Environment
# Extends common base with Java development tools and IDEs

FROM imagifex-common:latest

LABEL maintainer="imagifex"
LABEL description="Java developer environment with JDK, Maven, Gradle, and development tools"
LABEL version="1.0"

# Install OpenJDK (multiple versions for compatibility)
RUN apt-get update && apt-get install -y \
    # Java Development Kit
    openjdk-11-jdk \
    openjdk-17-jdk \
    openjdk-21-jdk \
    # Build tools will be installed separately for better version control
    && rm -rf /var/lib/apt/lists/*

# Set default Java version to 17 (LTS)
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Maven
ARG MAVEN_VERSION=3.9.6
RUN cd /tmp && \
    wget https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mv apache-maven-${MAVEN_VERSION} /opt/maven && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz

ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# Install Gradle
ARG GRADLE_VERSION=8.5
RUN cd /tmp && \
    wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip && \
    mv gradle-${GRADLE_VERSION} /opt/gradle && \
    rm gradle-${GRADLE_VERSION}-bin.zip

ENV GRADLE_HOME=/opt/gradle
ENV PATH=$GRADLE_HOME/bin:$PATH

# Install additional Java development tools
RUN apt-get update && apt-get install -y \
    # Database drivers and tools
    postgresql-client \
    mysql-client \
    sqlite3 \
    # Additional utilities
    graphviz \
    plantuml \
    # Performance profiling tools
    visualvm \
    && rm -rf /var/lib/apt/lists/*

# Create Java development setup script
COPY java-setup.sh /usr/local/bin/imagifex/
RUN chmod +x /usr/local/bin/imagifex/java-setup.sh

# Add Java-specific environment setup to bashrc template
RUN echo '' >> /etc/skel/.bashrc && \
    echo '# Java Development Environment' >> /etc/skel/.bashrc && \
    echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> /etc/skel/.bashrc && \
    echo 'export MAVEN_HOME=/opt/maven' >> /etc/skel/.bashrc && \
    echo 'export GRADLE_HOME=/opt/gradle' >> /etc/skel/.bashrc && \
    echo 'export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH' >> /etc/skel/.bashrc && \
    echo '' >> /etc/skel/.bashrc && \
    echo '# Java aliases' >> /etc/skel/.bashrc && \
    echo 'alias java11="export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"' >> /etc/skel/.bashrc && \
    echo 'alias java17="export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"' >> /etc/skel/.bashrc && \
    echo 'alias java21="export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64"' >> /etc/skel/.bashrc && \
    echo 'alias mvn-tree="mvn dependency:tree"' >> /etc/skel/.bashrc && \
    echo 'alias mvn-clean="mvn clean compile"' >> /etc/skel/.bashrc && \
    echo '' >> /etc/skel/.bashrc && \
    echo '# Run Java-specific setup if needed' >> /etc/skel/.bashrc && \
    echo 'if [ ! -f ~/.imagifex-java-setup-complete ]; then' >> /etc/skel/.bashrc && \
    echo '    /usr/local/bin/imagifex/java-setup.sh' >> /etc/skel/.bashrc && \
    echo '    touch ~/.imagifex-java-setup-complete' >> /etc/skel/.bashrc && \
    echo 'fi' >> /etc/skel/.bashrc

# Create Maven local repository directory
RUN mkdir -p /etc/skel/.m2

# Set working directory
WORKDIR /home

# Default command
CMD ["/bin/bash"]