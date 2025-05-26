#!/bin/bash

# imagifex Python Development Environment Setup

set -e

echo "Setting up Python development environment..."

# Create development directories
mkdir -p ~/workspace/python ~/projects/{django,flask,fastapi,data,scripts} ~/bin

# Initialize pyenv
export PYENV_ROOT=/opt/pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# Create sample Flask application
if [ ! -d ~/workspace/python/sample-flask-app ]; then
    mkdir -p ~/workspace/python/sample-flask-app
    cd ~/workspace/python/sample-flask-app
    
    # Create virtual environment
    python3 -m venv venv
    source venv/bin/activate
    
    # Install Flask and dependencies
    pip install flask python-dotenv
    
    # Create basic Flask app
    cat > app.py << 'EOF'
from flask import Flask, jsonify
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route('/')
def hello_world():
    return jsonify({
        'message': 'Hello from imagifex Flask app!',
        'environment': os.getenv('FLASK_ENV', 'development')
    })

@app.route('/health')
def health():
    return jsonify({'status': 'OK'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
EOF

    # Create .env file
    cat > .env << 'EOF'
FLASK_ENV=development
FLASK_DEBUG=true
EOF

    # Create requirements.txt
    cat > requirements.txt << 'EOF'
Flask==2.3.3
python-dotenv==1.0.0
EOF

    deactivate
    echo "Created sample Flask app at ~/workspace/python/sample-flask-app"
fi

# Create sample FastAPI application
if [ ! -d ~/workspace/python/sample-fastapi-app ]; then
    mkdir -p ~/workspace/python/sample-fastapi-app
    cd ~/workspace/python/sample-fastapi-app
    
    # Create virtual environment
    python3 -m venv venv
    source venv/bin/activate
    
    # Install FastAPI and dependencies
    pip install fastapi uvicorn python-dotenv
    
    # Create basic FastAPI app
    cat > main.py << 'EOF'
from fastapi import FastAPI
from pydantic import BaseModel
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="imagifex FastAPI Sample", version="1.0.0")

class Message(BaseModel):
    message: str
    environment: str

@app.get("/")
async def root():
    return Message(
        message="Hello from imagifex FastAPI app!",
        environment=os.getenv("ENV", "development")
    )

@app.get("/health")
async def health():
    return {"status": "OK"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF

    # Create .env file
    cat > .env << 'EOF'
ENV=development
EOF

    # Create requirements.txt
    cat > requirements.txt << 'EOF'
fastapi==0.104.1
uvicorn[standard]==0.24.0
python-dotenv==1.0.0
EOF

    deactivate
    echo "Created sample FastAPI app at ~/workspace/python/sample-fastapi-app"
fi

# Create Python development configuration files
if [ ! -f ~/.pylintrc ]; then
    cat > ~/.pylintrc << 'EOF'
[MASTER]
init-hook='import sys; sys.path.append(".")'

[FORMAT]
max-line-length=88

[MESSAGES CONTROL]
disable=C0114,C0115,C0116
EOF
fi

if [ ! -f ~/.flake8 ]; then
    cat > ~/.flake8 << 'EOF'
[flake8]
max-line-length = 88
extend-ignore = E203, W503
EOF
fi

if [ ! -f ~/.python-version ]; then
    echo "3.12" > ~/.python-version
fi

# Create a sample pyproject.toml for poetry projects
if [ ! -f ~/workspace/python/sample-poetry-project ]; then
    mkdir -p ~/workspace/python/sample-poetry-project
    cd ~/workspace/python/sample-poetry-project
    
    cat > pyproject.toml << 'EOF'
[tool.poetry]
name = "sample-poetry-project"
version = "0.1.0"
description = "Sample Python project using Poetry"
authors = ["Your Name <you@example.com>"]
readme = "README.md"

[tool.poetry.dependencies]
python = "^3.9"
requests = "^2.31.0"

[tool.poetry.group.dev.dependencies]
pytest = "^7.4.0"
black = "^23.0.0"
isort = "^5.12.0"
flake8 = "^6.0.0"
mypy = "^1.5.0"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"

[tool.black]
line-length = 88

[tool.isort]
profile = "black"

[tool.mypy]
python_version = "3.9"
warn_return_any = true
warn_unused_configs = true
EOF

    echo "# Sample Poetry Project" > README.md
    echo "Created sample Poetry project at ~/workspace/python/sample-poetry-project"
fi

# Display Python environment info
echo ""
echo "Python Development Environment Ready!"
echo "===================================="
echo "Available Python versions:"
ls /usr/bin/python* | grep -E "python[0-9].*[0-9]$" | sort
echo ""
echo "Default Python version:"
python3 --version
echo ""
echo "pip version:"
python3 -m pip --version
echo ""
echo "Poetry version:"
poetry --version 2>/dev/null || echo "Poetry not found in PATH (run: source ~/.bashrc)"
echo ""
echo "Installed packages:"
python3 -m pip list | head -10
echo ""
echo "Sample projects created:"
echo "- Flask app: ~/workspace/python/sample-flask-app"
echo "- FastAPI app: ~/workspace/python/sample-fastapi-app"
echo "- Poetry project: ~/workspace/python/sample-poetry-project"
echo ""
echo "To run the sample Flask app:"
echo "  cd ~/workspace/python/sample-flask-app && source venv/bin/activate && python app.py"
echo ""
echo "To run the sample FastAPI app:"
echo "  cd ~/workspace/python/sample-fastapi-app && source venv/bin/activate && uvicorn main:app --reload"
echo ""