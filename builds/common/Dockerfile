# imagifex Common Base Layer
# Ubuntu 24.04 LTS with essential development tools and WSL2 optimizations
# This serves as the foundation for all specialized developer images

FROM ubuntu:24.04

LABEL maintainer="imagifex"
LABEL description="Common base layer for WSL2 developer environments"
LABEL version="1.0"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Set default locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create artifacts directory for scripts
RUN mkdir -p /usr/local/bin/imagifex

# Update package lists and install essential packages
RUN apt-get update && apt-get install -y \
    # Core system utilities
    curl \
    wget \
    unzip \
    zip \
    tar \
    gzip \
    # Development essentials
    build-essential \
    cmake \
    pkg-config \
    # Version control
    git \
    git-lfs \
    # Network tools
    openssh-client \
    rsync \
    # Text processing
    vim \
    nano \
    less \
    jq \
    # System monitoring
    htop \
    tree \
    # Locale support
    locales \
    # SSL/TLS support
    ca-certificates \
    gnupg \
    lsb-release \
    # Process management
    supervisor \
    # Additional utilities
    sudo \
    software-properties-common \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Generate locales
RUN locale-gen en_US.UTF-8

# Create user setup script that will prompt for user creation on first login
COPY setup-user.sh /usr/local/bin/imagifex/
RUN chmod +x /usr/local/bin/imagifex/setup-user.sh

# Create environment setup script
COPY setup-env.sh /usr/local/bin/imagifex/
RUN chmod +x /usr/local/bin/imagifex/setup-env.sh

# Add first-run setup to bashrc template
RUN echo '#!/bin/bash' > /etc/skel/.bashrc && \
    echo '# imagifex WSL2 Environment' >> /etc/skel/.bashrc && \
    echo '' >> /etc/skel/.bashrc && \
    echo '# Run first-time setup if needed' >> /etc/skel/.bashrc && \
    echo 'if [ ! -f ~/.imagifex-setup-complete ]; then' >> /etc/skel/.bashrc && \
    echo '    /usr/local/bin/imagifex/setup-env.sh' >> /etc/skel/.bashrc && \
    echo '    touch ~/.imagifex-setup-complete' >> /etc/skel/.bashrc && \
    echo 'fi' >> /etc/skel/.bashrc && \
    echo '' >> /etc/skel/.bashrc && \
    echo '# Standard bash configuration' >> /etc/skel/.bashrc && \
    echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /etc/skel/.bashrc && \
    echo 'export EDITOR=vim' >> /etc/skel/.bashrc && \
    echo 'alias ll="ls -alF"' >> /etc/skel/.bashrc && \
    echo 'alias la="ls -A"' >> /etc/skel/.bashrc && \
    echo 'alias l="ls -CF"' >> /etc/skel/.bashrc

# Set working directory
WORKDIR /home

# Default command
CMD ["/bin/bash"]