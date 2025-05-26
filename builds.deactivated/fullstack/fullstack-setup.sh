#!/bin/bash

# imagifex Full-Stack Development Environment Setup

set -e

echo "Setting up Full-Stack development environment..."

# Create development directories
mkdir -p ~/workspace/{frontend,backend,fullstack} ~/projects/{react,vue,angular,node,api} ~/bin

# Set up npm global directory
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Create sample React project structure
if [ ! -d ~/workspace/frontend/sample-react-app ]; then
    echo "Creating sample React project..."
    cd ~/workspace/frontend
    npx create-react-app sample-react-app --template typescript
    echo "Created sample React TypeScript project at ~/workspace/frontend/sample-react-app"
fi

# Create sample Node.js/Express API
if [ ! -d ~/workspace/backend/sample-node-api ]; then
    mkdir -p ~/workspace/backend/sample-node-api
    cd ~/workspace/backend/sample-node-api
    
    # Initialize package.json
    npm init -y
    
    # Install common dependencies
    npm install express cors dotenv helmet morgan
    npm install -D @types/node @types/express @types/cors @types/morgan typescript ts-node nodemon
    
    # Create basic TypeScript config
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

    # Create basic Express server
    mkdir -p src
    cat > src/index.ts << 'EOF'
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

app.get('/api/hello', (req, res) => {
  res.json({ message: 'Hello from imagifex Node.js API!' });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

    # Update package.json scripts
    cat > package.json << 'EOF'
{
  "name": "sample-node-api",
  "version": "1.0.0",
  "description": "Sample Node.js API for imagifex",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "nodemon --exec ts-node src/index.ts",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "helmet": "^7.0.0",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/express": "^4.17.17",
    "@types/cors": "^2.8.13",
    "@types/morgan": "^1.9.4",
    "typescript": "^5.0.0",
    "ts-node": "^10.9.1",
    "nodemon": "^3.0.1"
  }
}
EOF

    echo "Created sample Node.js API at ~/workspace/backend/sample-node-api"
fi

# Create development configuration files
if [ ! -f ~/.eslintrc.js ]; then
    cat > ~/.eslintrc.js << 'EOF'
module.exports = {
  root: true,
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    // Add your custom rules here
  },
};
EOF
fi

if [ ! -f ~/.prettierrc ]; then
    cat > ~/.prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
EOF
fi

# Display environment info
echo ""
echo "Full-Stack Development Environment Ready!"
echo "========================================"
echo "Node.js version:"
node --version
echo ""
echo "npm version:"
npm --version
echo ""
echo "Yarn version:"
yarn --version
echo ""
echo "pnpm version:"
pnpm --version
echo ""
echo "TypeScript version:"
tsc --version
echo ""
echo "Global packages installed:"
npm list -g --depth=0 2>/dev/null | head -20
echo ""
echo "Sample projects created:"
echo "- React app: ~/workspace/frontend/sample-react-app"
echo "- Node.js API: ~/workspace/backend/sample-node-api"
echo ""
echo "To run the sample Node.js API:"
echo "  cd ~/workspace/backend/sample-node-api && npm run dev"
echo ""