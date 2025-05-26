# imagifex Python Developer Environment
# Extends common base with Python development tools and frameworks

FROM imagifex-common:latest

LABEL maintainer="imagifex"
LABEL description="Python developer environment with multiple Python versions and development tools"
LABEL version="1.0"

# Install Python build dependencies
RUN apt-get update && apt-get install -y \
    # Python build essentials
    python3-dev \
    python3-pip \
    python3-venv \
    python3-wheel \
    # Additional Python versions via deadsnakes PPA
    software-properties-common \
    # Development libraries
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libopenjp2-7-dev \
    libtiff5-dev \
    libwebp-dev \
    # Database development libraries
    libpq-dev \
    libmysqlclient-dev \
    libsqlite3-dev \
    # Scientific computing libraries
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    # Other useful libraries
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Add deadsnakes PPA for additional Python versions
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3.9-venv \
    python3.10 \
    python3.10-dev \
    python3.10-venv \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    && rm -rf /var/lib/apt/lists/*

# Install pyenv for Python version management
RUN git clone https://github.com/pyenv/pyenv.git /opt/pyenv
ENV PYENV_ROOT=/opt/pyenv
ENV PATH=$PYENV_ROOT/bin:$PATH

# Install poetry for dependency management
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Install pipx for isolated CLI tool installation
RUN python3 -m pip install --user pipx
RUN python3 -m pipx ensurepath

# Upgrade pip and install essential Python packages
RUN python3 -m pip install --upgrade pip setuptools wheel

# Install popular Python development tools
RUN python3 -m pip install \
    # Code formatting and linting
    black \
    isort \
    flake8 \
    mypy \
    pylint \
    # Testing frameworks
    pytest \
    pytest-cov \
    pytest-mock \
    tox \
    # Development utilities
    ipython \
    jupyter \
    jupyterlab \
    # Web frameworks
    flask \
    fastapi \
    uvicorn \
    django \
    # HTTP clients
    requests \
    httpx \
    aiohttp \
    # Database libraries
    sqlalchemy \
    alembic \
    psycopg2-binary \
    pymongo \
    redis \
    # Data manipulation (basic)
    pandas \
    numpy \
    # Environment management
    python-dotenv \
    # Documentation
    sphinx \
    mkdocs

# Create Python development setup script
COPY python-setup.sh /usr/local/bin/imagifex/
RUN chmod +x /usr/local/bin/imagifex/python-setup.sh

# Add Python-specific environment setup to bashrc template
RUN echo '' >> /etc/skel/.bashrc && \
    echo '# Python Development Environment' >> /etc/skel/.bashrc && \
    echo 'export PYENV_ROOT=/opt/pyenv' >> /etc/skel/.bashrc && \
    echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> /etc/skel/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> /etc/skel/.bashrc && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> /etc/skel/.bashrc && \
    echo '' >> /etc/skel/.bashrc && \
    echo '# Python aliases' >> /etc/skel/.bashrc && \
    echo 'alias py="python3"' >> /etc/skel/.bashrc && \
    echo 'alias pip="python3 -m pip"' >> /etc/skel/.bashrc && \
    echo 'alias venv="python3 -m venv"' >> /etc/skel/.bashrc && \
    echo 'alias activate="source venv/bin/activate"' >> /etc/skel/.bashrc && \
    echo 'alias ipy="ipython"' >> /etc/skel/.bashrc && \
    echo 'alias jlab="jupyter lab --ip=0.0.0.0 --allow-root"' >> /etc/skel/.bashrc && \
    echo 'alias pytest-cov="pytest --cov=. --cov-report=html"' >> /etc/skel/.bashrc

# Set working directory
WORKDIR /home

# Default command
CMD ["/bin/bash"]