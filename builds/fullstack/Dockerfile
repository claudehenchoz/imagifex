# imagifex Full-Stack/NodeJS Developer Environment
# Extends common base with Node.js, TypeScript, and modern web development tools

FROM imagifex-common:latest

LABEL maintainer="imagifex"
LABEL description="Full-stack developer environment with Node.js, TypeScript, and web development tools"
LABEL version="1.0"

# Install Node.js (using NodeSource repository for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# Install Yarn package manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn && \
    rm -rf /var/lib/apt/lists/*

# Install pnpm package manager
RUN npm install -g pnpm

# Install global npm packages for development
RUN npm install -g \
    # TypeScript and tools
    typescript \
    ts-node \
    @types/node \
    # Development servers and tools
    nodemon \
    concurrently \
    # Linting and formatting
    eslint \
    prettier \
    # Build tools
    webpack \
    webpack-cli \
    vite \
    # Framework CLIs
    @angular/cli \
    create-react-app \
    @vue/cli \
    nuxi \
    # Testing tools
    jest \
    cypress \
    # Utility CLIs
    http-server \
    live-server \
    json-server \
    # Package management
    npm-check-updates \
    # Database tools
    prisma

# Install additional development tools
RUN apt-get update && apt-get install -y \
    # Image processing (for web assets)
    imagemagick \
    # PDF tools
    poppler-utils \
    # Database clients
    postgresql-client \
    mysql-client \
    sqlite3 \
    redis-tools \
    # Development utilities
    httpie \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for containerized development)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Create Full-Stack development setup script
COPY fullstack-setup.sh /usr/local/bin/imagifex/
RUN chmod +x /usr/local/bin/imagifex/fullstack-setup.sh

# Add Node.js-specific environment setup to bashrc template
RUN echo '' >> /etc/skel/.bashrc && \
    echo '# Node.js Development Environment' >> /etc/skel/.bashrc && \
    echo 'export NODE_ENV=development' >> /etc/skel/.bashrc && \
    echo 'export NPM_CONFIG_PREFIX=~/.npm-global' >> /etc/skel/.bashrc && \
    echo 'export PATH=~/.npm-global/bin:$PATH' >> /etc/skel/.bashrc && \
    echo '' >> /etc/skel/.bashrc && \
    echo '# Node.js aliases' >> /etc/skel/.bashrc && \
    echo 'alias nls="npm list --depth=0"' >> /etc/skel/.bashrc && \
    echo 'alias nig="npm install -g"' >> /etc/skel/.bashrc && \
    echo 'alias nis="npm install --save"' >> /etc/skel/.bashrc && \
    echo 'alias nid="npm install --save-dev"' >> /etc/skel/.bashrc && \
    echo 'alias nrs="npm run start"' >> /etc/skel/.bashrc && \
    echo 'alias nrd="npm run dev"' >> /etc/skel/.bashrc && \
    echo 'alias nrb="npm run build"' >> /etc/skel/.bashrc && \
    echo 'alias nrt="npm run test"' >> /etc/skel/.bashrc && \
    echo 'alias yad="yarn add --dev"' >> /etc/skel/.bashrc && \
    echo 'alias yag="yarn global add"' >> /etc/skel/.bashrc

# Create npm global directory in skeleton
RUN mkdir -p /etc/skel/.npm-global

# Set working directory
WORKDIR /home

# Default command
CMD ["/bin/bash"]