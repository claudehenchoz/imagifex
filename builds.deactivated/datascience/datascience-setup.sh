#!/bin/bash

# imagifex Data Science Environment Setup

set -e

echo "Setting up Data Science environment..."

# Initialize conda for the user
source /opt/miniforge/etc/profile.d/conda.sh

# Create development directories
mkdir -p ~/workspace/datascience ~/notebooks ~/data ~/models ~/experiments ~/projects/{ml,analytics,research}

# Create sample Jupyter notebooks
if [ ! -d ~/notebooks/samples ]; then
    mkdir -p ~/notebooks/samples
    
    # Create sample Python data analysis notebook
    cat > ~/notebooks/samples/sample_data_analysis.ipynb << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Sample Data Analysis with imagifex\n",
    "\n",
    "This notebook demonstrates basic data analysis capabilities in the imagifex data science environment."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import pandas as pd\n",
    "import numpy as np\n",
    "import matplotlib.pyplot as plt\n",
    "import seaborn as sns\n",
    "from sklearn.datasets import load_iris\n",
    "from sklearn.model_selection import train_test_split\n",
    "from sklearn.ensemble import RandomForestClassifier\n",
    "from sklearn.metrics import classification_report\n",
    "\n",
    "print(\"imagifex Data Science Environment Ready!\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Load sample dataset\n",
    "iris = load_iris()\n",
    "df = pd.DataFrame(iris.data, columns=iris.feature_names)\n",
    "df['target'] = iris.target\n",
    "df['species'] = df['target'].map({0: 'setosa', 1: 'versicolor', 2: 'virginica'})\n",
    "\n",
    "print(f\"Dataset shape: {df.shape}\")\n",
    "df.head()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Basic visualization\n",
    "plt.figure(figsize=(12, 4))\n",
    "\n",
    "plt.subplot(1, 3, 1)\n",
    "sns.scatterplot(data=df, x='sepal length (cm)', y='sepal width (cm)', hue='species')\n",
    "plt.title('Sepal Dimensions')\n",
    "\n",
    "plt.subplot(1, 3, 2)\n",
    "sns.scatterplot(data=df, x='petal length (cm)', y='petal width (cm)', hue='species')\n",
    "plt.title('Petal Dimensions')\n",
    "\n",
    "plt.subplot(1, 3, 3)\n",
    "sns.boxplot(data=df, x='species', y='sepal length (cm)')\n",
    "plt.title('Sepal Length by Species')\n",
    "\n",
    "plt.tight_layout()\n",
    "plt.show()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Simple machine learning example\n",
    "X = df.drop(['target', 'species'], axis=1)\n",
    "y = df['target']\n",
    "\n",
    "X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)\n",
    "\n",
    "# Train model\n",
    "rf = RandomForestClassifier(n_estimators=100, random_state=42)\n",
    "rf.fit(X_train, y_train)\n",
    "\n",
    "# Evaluate\n",
    "y_pred = rf.predict(X_test)\n",
    "print(classification_report(y_test, y_pred, target_names=iris.target_names))"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.11.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF

    # Create sample R notebook
    cat > ~/notebooks/samples/sample_r_analysis.ipynb << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Sample R Analysis with imagifex\n",
    "\n",
    "This notebook demonstrates basic R data analysis capabilities."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "library(tidyverse)\n",
    "library(ggplot2)\n",
    "library(dplyr)\n",
    "\n",
    "cat(\"imagifex R Environment Ready!\\n\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Load and explore iris dataset\n",
    "data(iris)\n",
    "head(iris)\n",
    "summary(iris)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Data visualization with ggplot2\n",
    "ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +\n",
    "  geom_point(size = 3) +\n",
    "  theme_minimal() +\n",
    "  labs(title = \"Iris Dataset: Sepal Dimensions\",\n",
    "       x = \"Sepal Length (cm)\",\n",
    "       y = \"Sepal Width (cm)\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Data manipulation with dplyr\n",
    "iris_summary <- iris %>%\n",
    "  group_by(Species) %>%\n",
    "  summarise(\n",
    "    avg_sepal_length = mean(Sepal.Length),\n",
    "    avg_sepal_width = mean(Sepal.Width),\n",
    "    avg_petal_length = mean(Petal.Length),\n",
    "    avg_petal_width = mean(Petal.Width),\n",
    "    .groups = 'drop'\n",
    "  )\n",
    "\n",
    "print(iris_summary)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF

    echo "Created sample notebooks in ~/notebooks/samples/"
fi

# Create sample dataset
if [ ! -f ~/data/sample_data.csv ]; then
    python3 << 'EOF'
import pandas as pd
import numpy as np

# Generate sample dataset
np.random.seed(42)
n_samples = 1000

data = {
    'id': range(1, n_samples + 1),
    'age': np.random.randint(18, 80, n_samples),
    'income': np.random.normal(50000, 15000, n_samples),
    'education': np.random.choice(['High School', 'Bachelor', 'Master', 'PhD'], n_samples),
    'satisfaction': np.random.randint(1, 11, n_samples),
    'category': np.random.choice(['A', 'B', 'C'], n_samples)
}

df = pd.DataFrame(data)
df['income'] = df['income'].clip(lower=20000)  # Ensure positive income
df.to_csv('/home/claude/Code/imagifex/data/sample_data.csv', index=False)
print("Created sample dataset at ~/data/sample_data.csv")
EOF
fi

# Create conda environments for different use cases
echo "Creating specialized conda environments..."

# Create ML environment
if ! conda env list | grep -q "ml"; then
    conda create -n ml python=3.11 -y
    conda activate ml
    conda install -c conda-forge scikit-learn xgboost lightgbm pytorch tensorflow jupyter -y
    conda deactivate
    echo "Created 'ml' environment for machine learning"
fi

# Create deep learning environment
if ! conda env list | grep -q "dl"; then
    conda create -n dl python=3.11 -y
    conda activate dl
    conda install -c conda-forge pytorch torchvision tensorflow-gpu keras jupyter -y
    conda deactivate
    echo "Created 'dl' environment for deep learning"
fi

# Display environment info
echo ""
echo "Data Science Environment Ready!"
echo "==============================="
echo "Python version:"
python3 --version
echo ""
echo "R version:"
R --version | head -1
echo ""
echo "Conda version:"
conda --version
echo ""
echo "Available conda environments:"
conda env list
echo ""
echo "Installed Python packages (sample):"
python3 -c "import pandas, numpy, matplotlib, seaborn, sklearn, tensorflow, torch; print('✓ Core data science packages installed')"
echo ""
echo "Installed R packages (sample):"
R -e "library(tidyverse); library(ggplot2); cat('✓ Core R packages installed\n')" 2>/dev/null
echo ""
echo "Available Jupyter kernels:"
jupyter kernelspec list
echo ""
echo "Sample content created:"
echo "- Notebooks: ~/notebooks/samples/"
echo "- Sample data: ~/data/sample_data.csv"
echo ""
echo "To start Jupyter Lab:"
echo "  jupyter lab --ip=0.0.0.0 --allow-root --no-browser"
echo ""
echo "To activate environments:"
echo "  conda activate ml     # Machine learning environment"
echo "  conda activate dl     # Deep learning environment"
echo ""