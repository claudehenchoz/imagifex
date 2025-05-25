# imagifex Data Science Environment
# Extends common base with Python, R, Jupyter, and data science tools

FROM imagifex-common:latest

LABEL maintainer="imagifex"
LABEL description="Data science environment with Python, R, Jupyter Lab, and ML/analytics tools"
LABEL version="1.0"

# Install system dependencies for data science
RUN apt-get update && apt-get install -y \
    # Python and R development
    python3-dev \
    python3-pip \
    python3-venv \
    r-base \
    r-base-dev \
    # Scientific computing libraries
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    # Graphics and visualization
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    libpng-dev \
    libtiff5-dev \
    libfreetype6-dev \
    # Database connectivity
    libpq-dev \
    libmysqlclient-dev \
    libsqlite3-dev \
    unixodbc-dev \
    # Additional scientific libraries
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    # LaTeX for publication-quality documents
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    pandoc \
    # Version control for data
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

# Install Miniforge (conda-forge based conda distribution)
RUN wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/miniforge && \
    rm /tmp/miniforge.sh

ENV PATH="/opt/miniforge/bin:$PATH"

# Initialize conda and create base environment
RUN conda init bash && \
    conda config --set auto_activate_base false && \
    conda update -n base -c conda-forge conda

# Install core Python data science packages via conda
RUN conda install -n base -c conda-forge \
    # Core scientific computing
    numpy \
    scipy \
    pandas \
    # Machine learning
    scikit-learn \
    xgboost \
    lightgbm \
    # Deep learning frameworks
    tensorflow \
    pytorch \
    # Visualization
    matplotlib \
    seaborn \
    plotly \
    bokeh \
    altair \
    # Jupyter ecosystem
    jupyterlab \
    jupyter \
    ipywidgets \
    # Data manipulation
    polars \
    pyarrow \
    # Statistics and modeling
    statsmodels \
    # Database connectors
    sqlalchemy \
    psycopg2 \
    pymongo \
    && conda clean -afy

# Install additional Python packages via pip
RUN pip install \
    # Advanced visualization
    streamlit \
    dash \
    gradio \
    # MLOps and experiment tracking
    mlflow \
    wandb \
    dvc \
    # Notebook extensions
    jupyterlab-git \
    jupyterlab-lsp \
    # Data validation
    great-expectations \
    # Feature engineering
    featuretools \
    # Model interpretation
    shap \
    lime \
    # Time series
    prophet \
    # Natural language processing
    spacy \
    nltk \
    # Computer vision
    opencv-python \
    pillow \
    # API development
    fastapi \
    uvicorn

# Install R packages
RUN R -e "install.packages(c(\
    'tidyverse', \
    'ggplot2', \
    'dplyr', \
    'tidyr', \
    'readr', \
    'purrr', \
    'tibble', \
    'stringr', \
    'forcats', \
    'lubridate', \
    'shiny', \
    'rmarkdown', \
    'knitr', \
    'devtools', \
    'roxygen2', \
    'testthat', \
    'caret', \
    'randomForest', \
    'xgboost', \
    'data.table', \
    'plotly', \
    'DT', \
    'reticulate' \
    ), repos='https://cran.rstudio.com/')"

# Install IRkernel for Jupyter R support
RUN R -e "install.packages('IRkernel', repos='https://cran.rstudio.com/'); IRkernel::installspec(user = FALSE)"

# Install additional Jupyter kernels
RUN pip install bash_kernel && python -m bash_kernel.install

# Create data science setup script
COPY datascience-setup.sh /usr/local/bin/imagifex/
RUN chmod +x /usr/local/bin/imagifex/datascience-setup.sh

# Add data science environment setup to bashrc template
RUN echo '' >> /etc/skel/.bashrc && \
    echo '# Data Science Environment' >> /etc/skel/.bashrc && \
    echo 'export PATH="/opt/miniforge/bin:$PATH"' >> /etc/skel/.bashrc && \
    echo '' >> /etc/skel/.bashrc && \
    echo '# Data science aliases' >> /etc/skel/.bashrc && \
    echo 'alias jlab="jupyter lab --ip=0.0.0.0 --allow-root --no-browser"' >> /etc/skel/.bashrc && \
    echo 'alias jnb="jupyter notebook --ip=0.0.0.0 --allow-root --no-browser"' >> /etc/skel/.bashrc && \
    echo 'alias py="python3"' >> /etc/skel/.bashrc && \
    echo 'alias ipy="ipython"' >> /etc/skel/.bashrc && \
    echo 'alias streamlit-run="streamlit run --server.address=0.0.0.0"' >> /etc/skel/.bashrc && \
    echo 'alias create-env="conda create -n"' >> /etc/skel/.bashrc && \
    echo 'alias activate-env="conda activate"' >> /etc/skel/.bashrc && \
    echo 'alias list-envs="conda env list"' >> /etc/skel/.bashrc

# Create directories for notebooks and data
RUN mkdir -p /etc/skel/notebooks /etc/skel/data /etc/skel/models /etc/skel/experiments

# Set working directory
WORKDIR /home

# Default command
CMD ["/bin/bash"]