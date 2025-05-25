#!/bin/bash

# imagifex Java Development Environment Setup

set -e

echo "Setting up Java development environment..."

# Create development directories
mkdir -p ~/workspace/java ~/projects/java ~/bin

# Create sample Maven project structure
if [ ! -d ~/workspace/java/sample-maven-project ]; then
    mkdir -p ~/workspace/java/sample-maven-project/src/{main,test}/java
    
    # Create basic pom.xml
    cat > ~/workspace/java/sample-maven-project/pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>sample-project</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
EOF

    echo "Created sample Maven project at ~/workspace/java/sample-maven-project"
fi

# Create sample Gradle project structure
if [ ! -d ~/workspace/java/sample-gradle-project ]; then
    mkdir -p ~/workspace/java/sample-gradle-project/src/{main,test}/java
    
    # Create basic build.gradle
    cat > ~/workspace/java/sample-gradle-project/build.gradle << 'EOF'
plugins {
    id 'java'
    id 'application'
}

group = 'com.example'
version = '1.0.0'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter:5.10.0'
}

test {
    useJUnitPlatform()
}

application {
    mainClass = 'com.example.Main'
}
EOF

    echo "Created sample Gradle project at ~/workspace/java/sample-gradle-project"
fi

# Display Java environment info
echo ""
echo "Java Development Environment Ready!"
echo "======================================"
echo "Java versions available:"
ls /usr/lib/jvm/ | grep openjdk
echo ""
echo "Current Java version:"
java -version
echo ""
echo "Maven version:"
mvn -version
echo ""
echo "Gradle version:"
gradle -version
echo ""
echo "Use 'java11', 'java17', or 'java21' aliases to switch Java versions"
echo "Sample projects created in ~/workspace/java/"
echo ""