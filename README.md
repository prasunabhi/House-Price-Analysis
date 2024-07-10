# House Price Analysis - Machine Learning for Business

## Overview
This project conducted an in-depth analysis of U.S. house prices using advanced machine learning techniques. The aim was to identify key factors influencing house prices and provide actionable insights for decision-making in the real estate industry.

## Key Features
* Analyzed house prices based on various factors such as quality of the house, number of garage spaces, number of bathrooms, and square feet of living area.
* Utilized visualizations, Variance Inflation Factor (VIF) analysis, and neural networks to uncover influential factors.
* Achieved a high predictive accuracy in house price estimation, contributing valuable insights into house price dynamics.

## Methodology
* **Data Source:** Dataset containing factors influencing house prices, including attributes like quality, garage spaces, bathrooms, and living area from the USA-housing.xlsx spreadsheet (Kaggle dataset on U.S. house prices).
* **Data Processing:** Conducted exploratory data analysis (EDA) using pair panels and correlation matrices to identify key patterns and relationships.
* **Modeling Techniques:** Utilized Python with libraries such as Pandas, NumPy, and scikit-learn.
    * Variance Inflation Factor (VIF): Used to identify and handle multicollinearity among predictor variables.
    * Neural Networks: Employed for regression analysis with different configurations to achieve high accuracy.

## Key Findings
* **Correlations:**
    * Overall Quality (OverallQual): High correlation with sale price (0.80106).
    * Living Area (LivArea): Significant correlation with sale price (0.73891).
* **Model Performance:**
    * VIF Analysis: Ensured predictor variables were not highly correlated, addressing multicollinearity.
    * Neural Networks:
        * Neural network with one hidden layer and two nodes achieved the highest accuracy of 94.7%.
        * Models tested with varying configurations of hidden layers and nodes, using 70% training data and 30% testing data.

## Lessons Learnt
* **Visualization:**
    * Effective for identifying relationships or patterns when data has fewer attributes and is not too cluttered.
    * Useful for summarizing large datasets concisely and revealing patterns not immediately apparent in raw data.
    * Less effective with sparse, overly complex, or multicollinear data where patterns may not be clear.
* **Model Comparison:**
    * Neural networks with specific configurations (one hidden layer, two nodes) provided the highest accuracy.
    * Importance of handling multicollinearity and selecting significant predictors for accurate modeling.

## Conclusion
The project highlighted the significance of understanding key factors influencing house prices through predictive analytics. By leveraging VIF analysis and neural networks, the study provided critical insights into house price dynamics, aiding informed decision-making in the real estate industry.

## Reference
* Dataset: USA-housing.xlsx spreadsheet from Kaggle.
