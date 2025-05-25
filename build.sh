#!/bin/bash

# imagifex Master Build Script
# Builds all WSL2 developer images using podman and exports them as tar files

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILDS_DIR="$SCRIPT_DIR/builds"
ARTIFACTS_DIR="$SCRIPT_DIR/artifacts"
IMAGE_PREFIX="imagifex"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if podman is installed
check_podman() {
    if ! command -v podman &> /dev/null; then
        log_error "podman is not installed. Please install podman first."
        log_info "On Ubuntu/Debian: sudo apt-get install podman"
        log_info "On RHEL/CentOS: sudo dnf install podman"
        exit 1
    fi
    log_success "podman is available"
}

# Function to create artifacts directory
setup_artifacts_dir() {
    log_info "Setting up artifacts directory..."
    mkdir -p "$ARTIFACTS_DIR"
    log_success "Artifacts directory ready: $ARTIFACTS_DIR"
}

# Function to build a single image
build_image() {
    local image_name="$1"
    local dockerfile_path="$2"
    local context_dir="$3"
    
    log_info "Building image: $image_name"
    log_info "Dockerfile: $dockerfile_path"
    log_info "Context: $context_dir"
    
    if podman build -t "$image_name" -f "$dockerfile_path" "$context_dir"; then
        log_success "Successfully built image: $image_name"
        return 0
    else
        log_error "Failed to build image: $image_name"
        return 1
    fi
}

# Function to export image to tar file
export_image() {
    local image_name="$1"
    local output_file="$2"
    
    log_info "Exporting image $image_name to $output_file"
    
    # Create a temporary container to export
    local container_id
    container_id=$(podman create "$image_name")
    
    if podman export "$container_id" > "$output_file"; then
        log_success "Successfully exported: $(basename "$output_file")"
        # Clean up temporary container
        podman rm "$container_id" > /dev/null
        return 0
    else
        log_error "Failed to export image: $image_name"
        # Clean up temporary container
        podman rm "$container_id" > /dev/null 2>&1 || true
        return 1
    fi
}

# Function to build all images
build_all_images() {
    local build_failed=0
    
    log_info "Starting imagifex build process..."
    echo "================================================="
    
    # Define build order (common base first, then derivatives)
    declare -A images=(
        ["${IMAGE_PREFIX}-common"]="$BUILDS_DIR/common"
        ["${IMAGE_PREFIX}-java"]="$BUILDS_DIR/java"
        ["${IMAGE_PREFIX}-fullstack"]="$BUILDS_DIR/fullstack"
        ["${IMAGE_PREFIX}-python"]="$BUILDS_DIR/python"
        ["${IMAGE_PREFIX}-datascience"]="$BUILDS_DIR/datascience"
    )
    
    # Build images in order
    for image_name in "${IMAGE_PREFIX}-common" "${IMAGE_PREFIX}-java" "${IMAGE_PREFIX}-fullstack" "${IMAGE_PREFIX}-python" "${IMAGE_PREFIX}-datascience"; do
        local build_dir="${images[$image_name]}"
        local dockerfile="$build_dir/Dockerfile"
        
        if [ ! -f "$dockerfile" ]; then
            log_error "Dockerfile not found: $dockerfile"
            build_failed=1
            continue
        fi
        
        echo ""
        log_info "================================================="
        log_info "Building: $image_name"
        log_info "================================================="
        
        if ! build_image "$image_name" "$dockerfile" "$build_dir"; then
            build_failed=1
            continue
        fi
        
        # Export image to tar file
        local tar_filename="${image_name}-${TIMESTAMP}.tar"
        local tar_path="$ARTIFACTS_DIR/$tar_filename"
        
        if ! export_image "$image_name" "$tar_path"; then
            build_failed=1
            continue
        fi
        
        # Create a symlink to the latest version
        local latest_link="$ARTIFACTS_DIR/${image_name}-latest.tar"
        ln -sf "$tar_filename" "$latest_link"
        log_info "Created symlink: $(basename "$latest_link") -> $tar_filename"
    done
    
    return $build_failed
}

# Function to create PowerShell setup script
create_powershell_script() {
    log_info "Creating PowerShell WSL2 setup script..."
    
    cat > "$ARTIFACTS_DIR/Setup-WSL2-Imagifex.ps1" << 'EOF'
# imagifex WSL2 Setup Script
# PowerShell script to easily set up WSL2 distros from imagifex tar files

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("common", "java", "fullstack", "python", "datascience")]
    [string]$Flavor,
    
    [Parameter(Mandatory=$false)]
    [string]$DistroName,
    
    [Parameter(Mandatory=$false)]
    [string]$InstallLocation,
    
    [Parameter(Mandatory=$false)]
    [string]$TarFile,
    
    [Parameter(Mandatory=$false)]
    [string]$HostUser = $env:USERNAME,
    
    [Parameter(Mandatory=$false)]
    [string]$HostWorkspace = $env:USERPROFILE,
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "default"
)

# Configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ArtifactsDir = $ScriptDir

# Set default values
if (-not $DistroName) {
    $DistroName = "imagifex-$Flavor"
}

if (-not $InstallLocation) {
    $InstallLocation = "$env:USERPROFILE\WSL\imagifex\$DistroName"
}

if (-not $TarFile) {
    $TarFile = "$ArtifactsDir\imagifex-$Flavor-latest.tar"
}

# Functions
function Write-ColoredOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Test-WSLInstalled {
    try {
        $wslVersion = wsl --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Test-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Main script
Write-ColoredOutput "=================================================" "Cyan"
Write-ColoredOutput "  imagifex WSL2 Setup Script" "Cyan"
Write-ColoredOutput "=================================================" "Cyan"
Write-ColoredOutput ""

Write-ColoredOutput "Configuration:" "Yellow"
Write-ColoredOutput "  Flavor: $Flavor" "White"
Write-ColoredOutput "  Distro Name: $DistroName" "White"
Write-ColoredOutput "  Install Location: $InstallLocation" "White"
Write-ColoredOutput "  Tar File: $TarFile" "White"
Write-ColoredOutput "  Host User: $HostUser" "White"
Write-ColoredOutput "  Host Workspace: $HostWorkspace" "White"
Write-ColoredOutput "  Project Name: $ProjectName" "White"
Write-ColoredOutput ""

# Check if WSL is installed
if (-not (Test-WSLInstalled)) {
    Write-ColoredOutput "ERROR: WSL is not installed or not available." "Red"
    Write-ColoredOutput "Please install WSL2 first:" "Yellow"
    Write-ColoredOutput "  1. Run as Administrator: wsl --install" "White"
    Write-ColoredOutput "  2. Restart your computer" "White"
    Write-ColoredOutput "  3. Run this script again" "White"
    exit 1
}

# Check if tar file exists
if (-not (Test-Path $TarFile)) {
    Write-ColoredOutput "ERROR: Tar file not found: $TarFile" "Red"
    Write-ColoredOutput "Available tar files in $ArtifactsDir:" "Yellow"
    Get-ChildItem -Path $ArtifactsDir -Filter "*.tar" | ForEach-Object { Write-ColoredOutput "  $($_.Name)" "White" }
    exit 1
}

# Check if distro already exists
$existingDistros = wsl --list --quiet
if ($existingDistros -contains $DistroName) {
    Write-ColoredOutput "WARNING: Distro '$DistroName' already exists." "Yellow"
    $response = Read-Host "Do you want to unregister it and continue? (y/N)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-ColoredOutput "Unregistering existing distro..." "Yellow"
        wsl --unregister $DistroName
    } else {
        Write-ColoredOutput "Aborted." "Red"
        exit 1
    }
}

# Create install directory
Write-ColoredOutput "Creating install directory..." "Green"
New-Item -ItemType Directory -Path $InstallLocation -Force | Out-Null

# Import the WSL distro
Write-ColoredOutput "Importing WSL distro (this may take a few minutes)..." "Green"
try {
    wsl --import $DistroName $InstallLocation $TarFile
    Write-ColoredOutput "Successfully imported distro: $DistroName" "Green"
} catch {
    Write-ColoredOutput "ERROR: Failed to import distro." "Red"
    Write-ColoredOutput $_.Exception.Message "Red"
    exit 1
}

# Set environment variables for the WSL distro
Write-ColoredOutput "Setting up environment variables..." "Green"
$env:IMAGIFEX_HOST_USER = $HostUser
$env:IMAGIFEX_HOST_WORKSPACE = $HostWorkspace
$env:IMAGIFEX_PROJECT_NAME = $ProjectName

# Start the distro for first-time setup
Write-ColoredOutput "Starting distro for first-time setup..." "Green"
Write-ColoredOutput "You will be prompted to create a user account." "Yellow"
Write-ColoredOutput ""

# Launch WSL with environment variables
$wslCommand = "wsl -d $DistroName"
Invoke-Expression $wslCommand

Write-ColoredOutput ""
Write-ColoredOutput "=================================================" "Cyan"
Write-ColoredOutput "  Setup Complete!" "Cyan"
Write-ColoredOutput "=================================================" "Cyan"
Write-ColoredOutput "Your imagifex $Flavor environment is ready!" "Green"
Write-ColoredOutput ""
Write-ColoredOutput "To access your distro:" "Yellow"
Write-ColoredOutput "  wsl -d $DistroName" "White"
Write-ColoredOutput ""
Write-ColoredOutput "To set as default distro:" "Yellow"
Write-ColoredOutput "  wsl --set-default $DistroName" "White"
Write-ColoredOutput ""
Write-ColoredOutput "To remove the distro later:" "Yellow"
Write-ColoredOutput "  wsl --unregister $DistroName" "White"
Write-ColoredOutput ""
EOF

    log_success "Created PowerShell setup script: Setup-WSL2-Imagifex.ps1"
}

# Function to create usage documentation
create_usage_docs() {
    log_info "Creating usage documentation..."
    
    cat > "$ARTIFACTS_DIR/USAGE.md" << 'EOF'
# imagifex WSL2 Distribution Usage Guide

## Quick Start

### Windows PowerShell (Recommended)

1. Open PowerShell as Administrator
2. Navigate to the artifacts directory
3. Run the setup script:

```powershell
# For Full-Stack development
.\Setup-WSL2-Imagifex.ps1 -Flavor fullstack

# For Java development
.\Setup-WSL2-Imagifex.ps1 -Flavor java

# For Python development
.\Setup-WSL2-Imagifex.ps1 -Flavor python

# For Data Science
.\Setup-WSL2-Imagifex.ps1 -Flavor datascience

# For custom distro name
.\Setup-WSL2-Imagifex.ps1 -Flavor python -DistroName "my-python-env"
```

### Manual Setup

If you prefer manual setup:

1. Import the distro:
```cmd
wsl --import imagifex-python C:\WSL\imagifex-python imagifex-python-latest.tar
```

2. Start the distro:
```cmd
wsl -d imagifex-python
```

3. Follow the user setup prompts

## Available Flavors

| Flavor | Description | Key Technologies |
|--------|-------------|------------------|
| `common` | Base Ubuntu 24.04 environment | Git, Vim, Essential tools |
| `java` | Java development environment | OpenJDK 11/17/21, Maven, Gradle |
| `fullstack` | Full-stack web development | Node.js, TypeScript, React, Vue, Angular |
| `python` | Python development environment | Python 3.9-3.12, Poetry, Virtual environments |
| `datascience` | Data science and ML environment | Python, R, Jupyter, TensorFlow, PyTorch |

## Environment Variables

The PowerShell script sets up these environment variables automatically:

- `IMAGIFEX_HOST_USER`: Your Windows username
- `IMAGIFEX_HOST_WORKSPACE`: Your Windows user profile path
- `IMAGIFEX_PROJECT_NAME`: Project identifier

## First-Time Setup

When you first start any imagifex distro:

1. You'll be prompted to create a user account
2. Enter your desired username (lowercase, alphanumeric)
3. Set a password for your user
4. The environment will be configured automatically

## Development Workflows

### Java Development
```bash
# Switch Java versions
java11  # Sets JAVA_HOME to Java 11
java17  # Sets JAVA_HOME to Java 17 (default)
java21  # Sets JAVA_HOME to Java 21

# Sample projects are in ~/workspace/java/
cd ~/workspace/java/sample-maven-project
mvn clean compile
```

### Full-Stack Development
```bash
# Sample projects are in ~/workspace/
cd ~/workspace/frontend/sample-react-app
npm start

cd ~/workspace/backend/sample-node-api
npm run dev
```

### Python Development
```bash
# Create virtual environment
python3 -m venv myproject
source myproject/bin/activate

# Sample projects are in ~/workspace/python/
cd ~/workspace/python/sample-flask-app
source venv/bin/activate
python app.py
```

### Data Science
```bash
# Start Jupyter Lab
jupyter lab --ip=0.0.0.0 --allow-root --no-browser

# Access at http://localhost:8888

# Activate specialized environments
conda activate ml  # Machine learning
conda activate dl  # Deep learning

# Sample notebooks are in ~/notebooks/samples/
```

## Troubleshooting

### WSL not installed
```powershell
# Run as Administrator
wsl --install
# Restart computer
```

### Distro import fails
- Ensure you have enough disk space
- Check that WSL2 is enabled
- Verify the tar file isn't corrupted

### Permission issues
- Ensure PowerShell is running as Administrator
- Check Windows Defender isn't blocking the files

### Environment setup fails
- Restart the WSL distro: `wsl --shutdown && wsl -d distro-name`
- Check that the setup scripts have execute permissions

## Advanced Usage

### Custom Environment Variables
```powershell
.\Setup-WSL2-Imagifex.ps1 -Flavor python -HostUser "custom-user" -ProjectName "my-project"
```

### Multiple Environments
```powershell
# Create multiple Python environments
.\Setup-WSL2-Imagifex.ps1 -Flavor python -DistroName "python-web"
.\Setup-WSL2-Imagifex.ps1 -Flavor python -DistroName "python-ml"
```

### Backup and Restore
```bash
# Export your customized distro
wsl --export my-distro C:\Backups\my-distro.tar

# Import backup
wsl --import my-distro-restored C:\WSL\restored C:\Backups\my-distro.tar
```

## Support

For issues and contributions, visit the imagifex project repository.
EOF

    log_success "Created usage documentation: USAGE.md"
}

# Function to display build summary
display_summary() {
    local build_status=$1
    
    echo ""
    echo "================================================="
    log_info "Build Summary"
    echo "================================================="
    
    if [ $build_status -eq 0 ]; then
        log_success "All images built successfully!"
    else
        log_warning "Some images failed to build. Check the output above."
    fi
    
    echo ""
    log_info "Generated artifacts in: $ARTIFACTS_DIR"
    ls -la "$ARTIFACTS_DIR"
    
    echo ""
    log_info "To use the WSL2 environments:"
    log_info "1. Copy the artifacts folder to your Windows machine"
    log_info "2. Open PowerShell as Administrator"
    log_info "3. Run: .\\Setup-WSL2-Imagifex.ps1 -Flavor <flavor>"
    log_info ""
    log_info "Available flavors: common, java, fullstack, python, datascience"
}

# Main execution
main() {
    log_info "Starting imagifex build process..."
    
    # Pre-flight checks
    check_podman
    setup_artifacts_dir
    
    # Build all images
    build_all_images
    local build_status=$?
    
    # Create PowerShell helper script
    create_powershell_script
    
    # Create usage documentation
    create_usage_docs
    
    # Display summary
    display_summary $build_status
    
    exit $build_status
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "imagifex Build Script"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --clean        Clean up existing images before building"
        echo ""
        echo "This script builds all imagifex WSL2 distributions and exports them as tar files."
        exit 0
        ;;
    --clean)
        log_info "Cleaning up existing images..."
        podman rmi -f $(podman images -q --filter "reference=${IMAGE_PREFIX}*" 2>/dev/null) 2>/dev/null || true
        log_success "Cleanup complete"
        ;;
esac

# Run main function
main