# imagifex

A suite of scripts that builds custom WSL2 distributions for enterprise developers and data scientists.

## Overview

imagifex creates specialized WSL2 development environments using Docker/Podman containers that are exported as tar files for easy distribution and deployment. Each environment is tailored for specific development workflows while maintaining a common foundation.

## Quick Start

1. **Build the images:**
   ```bash
   ./build.sh
   ```

2. **Deploy on Windows:**
   - Copy the `artifacts` folder to your Windows machine
   - Open PowerShell as Administrator
   - Run the setup script:
   ```powershell
   .\Setup-WSL2-Imagifex.ps1 -Flavor python
   ```

## Available Environments

| Environment | Description | Key Technologies |
|-------------|-------------|------------------|
| **Common** | Base Ubuntu 24.04 LTS | Git, Vim, SSH, Essential dev tools |
| **Java** | Java development stack | OpenJDK 11/17/21, Maven, Gradle, PostgreSQL client |
| **Full-Stack** | Modern web development | Node.js, TypeScript, React, Vue, Angular, Docker CLI |
| **Python** | Python development | Python 3.9-3.12, Poetry, Virtual environments, Web frameworks |
| **Data Science** | ML/Analytics platform | Python, R, Jupyter Lab, TensorFlow, PyTorch, Conda |

## Architecture

### Layered Build System

```
imagifex-common (Ubuntu 24.04 LTS)
├── imagifex-java
├── imagifex-fullstack  
├── imagifex-python
└── imagifex-datascience
```

All specialized environments extend the common base layer, ensuring:
- Consistent core tooling across environments
- Efficient layer sharing and faster builds
- Standardized user setup and configuration

### Directory Structure

```
imagifex/
├── build.sh                    # Master build script
├── README.md                   # This file
├── builds/                     # Build specifications
│   ├── common/                 # Base layer
│   │   ├── Dockerfile
│   │   ├── setup-user.sh      # User account creation
│   │   └── setup-env.sh       # Environment configuration
│   ├── java/                  # Java development environment
│   │   ├── Dockerfile
│   │   └── java-setup.sh
│   ├── fullstack/             # Full-stack web development
│   │   ├── Dockerfile
│   │   └── fullstack-setup.sh
│   ├── python/                # Python development
│   │   ├── Dockerfile
│   │   └── python-setup.sh
│   └── datascience/           # Data science and ML
│       ├── Dockerfile
│       └── datascience-setup.sh
├── artifacts/                 # Generated outputs (created by build)
│   ├── imagifex-*-latest.tar  # WSL2 distribution files
│   ├── Setup-WSL2-Imagifex.ps1 # PowerShell deployment script
│   └── USAGE.md               # End-user documentation
└── scripts/                   # Additional utilities (for future use)
```

## Building Images

### Prerequisites

- **Linux host** with podman installed:
  ```bash
  # Ubuntu/Debian
  sudo apt-get install podman
  
  # RHEL/CentOS/Fedora
  sudo dnf install podman
  ```

### Build Process

The master build script orchestrates the entire process:

```bash
# Build all images
./build.sh

# Clean existing images and rebuild
./build.sh --clean

# Show help
./build.sh --help
```

**Build sequence:**
1. **Common base layer** - Ubuntu 24.04 with essential tools
2. **Specialized layers** - Each environment builds from the common base
3. **Export to tar files** - Using `podman export` for WSL2 compatibility
4. **Generate deployment scripts** - PowerShell script for Windows deployment

## Deployment on Windows

### Automated Setup (Recommended)

The generated PowerShell script handles the entire WSL2 setup:

```powershell
# Basic deployment
.\Setup-WSL2-Imagifex.ps1 -Flavor datascience

# Custom configuration
.\Setup-WSL2-Imagifex.ps1 -Flavor python -DistroName "my-python-env" -ProjectName "web-app"

# With environment variables
.\Setup-WSL2-Imagifex.ps1 -Flavor java -HostUser "developer" -HostWorkspace "C:\Projects"
```

### Manual Deployment

```cmd
# Import the distribution
wsl --import imagifex-python C:\WSL\imagifex-python imagifex-python-latest.tar

# Start the environment
wsl -d imagifex-python
```

## Environment Features

### First-Time Setup

Every imagifex environment provides:
- **Interactive user creation** - Prompts for username/password on first launch
- **Automatic environment configuration** - Sets up development directories and tools
- **Host integration** - Access to Windows environment variables and paths
- **Ready-to-use samples** - Example projects and configurations

### Common Features (All Environments)

- **Ubuntu 24.04 LTS** base with security updates
- **Essential development tools** - Git, Vim, curl, wget, build tools
- **SSH client** configured
- **Locale support** - UTF-8 encoding
- **User management** - Sudo access for development tasks

### Java Environment

```bash
# Multiple JDK versions available
java11  # Switch to OpenJDK 11
java17  # Switch to OpenJDK 17 (default)
java21  # Switch to OpenJDK 21

# Build tools ready
mvn --version
gradle --version

# Sample projects included
~/workspace/java/sample-maven-project
~/workspace/java/sample-gradle-project
```

### Full-Stack Environment

```bash
# Modern JavaScript ecosystem
node --version    # Latest LTS
npm --version
yarn --version
pnpm --version

# Framework CLIs available
npx create-react-app my-app
vue create my-app
ng new my-app

# Sample projects included
~/workspace/frontend/sample-react-app
~/workspace/backend/sample-node-api
```

### Python Environment

```bash
# Multiple Python versions
python3.9 --version
python3.10 --version
python3.11 --version
python3.12 --version  # default

# Package management
pip --version
poetry --version

# Virtual environments
python3 -m venv myproject
activate  # alias for source venv/bin/activate

# Sample projects included
~/workspace/python/sample-flask-app
~/workspace/python/sample-fastapi-app
~/workspace/python/sample-poetry-project
```

### Data Science Environment

```bash
# Multi-language support
python --version
R --version

# Package management
conda --version
pip --version

# Jupyter ecosystem
jupyter lab --ip=0.0.0.0 --allow-root --no-browser
# Access at http://localhost:8888

# Specialized environments
conda activate ml   # Machine learning packages
conda activate dl   # Deep learning packages

# Sample content
~/notebooks/samples/sample_data_analysis.ipynb
~/notebooks/samples/sample_r_analysis.ipynb
~/data/sample_data.csv
```

## Customization

### Modifying Environments

1. **Edit Dockerfiles** in `builds/*/Dockerfile`
2. **Update setup scripts** in `builds/*/setup-*.sh`
3. **Rebuild:** `./build.sh`

### Adding New Environments

1. **Create build directory:** `mkdir builds/myenv`
2. **Create Dockerfile:** Extend from `imagifex-common:latest`
3. **Add setup script:** `builds/myenv/myenv-setup.sh`
4. **Update build script:** Add to the images array in `build.sh`

### Example Custom Environment

```dockerfile
# builds/golang/Dockerfile
FROM imagifex-common:latest

LABEL description="Go development environment"

# Install Go
RUN wget -q https://go.dev/dl/go1.21.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz && \
    rm go1.21.4.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:$PATH"

COPY golang-setup.sh /usr/local/bin/imagifex/
RUN chmod +x /usr/local/bin/imagifex/golang-setup.sh
```

## Enterprise Features

### Security
- **Non-root containers** - User accounts created on first run
- **Minimal attack surface** - Only essential packages installed
- **Regular base updates** - Ubuntu 24.04 LTS security patches
- **No secrets in images** - All sensitive data handled at runtime

### Distribution
- **Portable tar files** - Easy to distribute via corporate networks
- **Offline deployment** - No internet required for WSL2 setup
- **Version control** - Timestamped artifacts for rollback capability
- **Standardized environments** - Consistent across development teams

### Integration
- **Host environment access** - Windows variables passed through
- **Corporate network** - Proxy and DNS settings inherited
- **File system mounting** - Access to Windows drives and network shares
- **Development workflows** - Git, Docker, and CI/CD tool integration

## Maintenance

### Updating Base Images

1. **Modify** `builds/common/Dockerfile`
2. **Rebuild all:** `./build.sh --clean`
3. **Test environments** before distribution

### Adding Security Updates

```dockerfile
# In any Dockerfile, add before the final cleanup:
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
```

### Monitoring Build Size

```bash
# Check image sizes
podman images | grep imagifex

# Check tar file sizes  
ls -lh artifacts/*.tar
```

## Troubleshooting

### Build Issues

- **Podman not found:** Install podman package
- **Permission denied:** Check file permissions on scripts
- **Network timeouts:** Configure proxy settings in Dockerfiles
- **Disk space:** Clean up with `podman system prune`

### WSL2 Issues

- **Import fails:** Ensure WSL2 is enabled and updated
- **Startup issues:** Check Windows Defender exclusions
- **Slow performance:** Allocate more WSL2 memory in `.wslconfig`

### Runtime Issues

- **User setup fails:** Restart WSL2 and try again
- **Missing packages:** Check if specialized setup script ran
- **Environment variables:** Verify PowerShell script parameters

## Contributing

1. **Fork** the repository
2. **Create feature branch:** `git checkout -b feature/new-env`
3. **Test thoroughly** with `./build.sh`
4. **Submit pull request** with environment description

## License

This project is designed for enterprise use. See LICENSE file for details.

## Support

For enterprise support and custom environment development, contact the imagifex team.

---

**imagifex** - Making developer environments simple, consistent, and enterprise-ready.