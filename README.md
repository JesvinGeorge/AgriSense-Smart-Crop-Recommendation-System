# 🌱 AgriSense – Smart Crop Recommendation System

AgriSense is an AI-based, district-specific smart crop recommendation system designed to assist farmers in selecting the most suitable crops based on soil nutrients and environmental conditions. The system focuses on Karnataka districts and provides data-driven crop suggestions to improve agricultural productivity.

---

## 📌 Problem Statement
Farmers often rely on traditional knowledge for crop selection, which may not consider changing climate conditions, soil health, or regional variations. This can lead to low yield and financial loss.

---

## ✅ Solution
AgriSense uses Machine Learning models trained on real agricultural data to recommend the **top 3 suitable crops** for a given district based on soil and climate parameters.

---

## 🚀 Key Features
- District-wise crop recommendation (15 districts of Karnataka)
- Uses soil and climate parameters:
  - Nitrogen (N)
  - Phosphorus (P)
  - Potassium (K)
  - Soil pH
  - Rainfall
  - Temperature
  - Humidity
  - Season
- Top-3 crop recommendations with probabilities
- REST API using FastAPI
- Mobile application built using Flutter
- Supabase integration for authentication and prediction history

---

## 🧠 Machine Learning Models Used
For each district, multiple models are trained and the best-performing one is selected:
- Random Forest Classifier
- Extra Trees Classifier
- XGBoost
- LightGBM
- CatBoost

Accuracy achieved ranges from **80% to 96%** depending on the district.

---

## 🏗️ System Architecture
1. Dataset preprocessing and cleaning  
2. District-wise dataset split  
3. Training multiple ML models per district  
4. Selecting best model based on accuracy  
5. Saving models, encoders, and scalers  
6. FastAPI backend for prediction  
7. Flutter mobile app for user interaction  
8. Supabase for database and authentication  

---

## 📁 Project Structure

```text
AgriSense_APP/
│
├── backend/
│   ├── app.py                     # FastAPI backend
│   ├── models_15districts/        # Trained ML models (15 districts)
│   └── requirements.txt           # Backend dependencies
│
├── agrisense_app/             # Flutter mobile application
│   ├── lib/                       # UI and application logic
│   ├── android/                   # Android configuration
│   ├── ios/                       # iOS configuration
│   └── pubspec.yaml               # Flutter dependencies
│
├── main.ipynb                     # Model training & experimentation
├── requirements.txt               # ML training dependencies
└── README.md                      # Project documentation

```
---

## 🛠️ Tech Stack
- **Programming Language:** Python, Dart
- **Machine Learning:** Scikit-learn, XGBoost, LightGBM, CatBoost
- **Backend:** FastAPI
- **Frontend:** Flutter
- **Database & Auth:** Supabase
- **Version Control:** Git & GitHub

---

## ▶️ How to Run Backend (Local)
```bash
cd backend
pip install -r requirements.txt
uvicorn app:app --reload
```

---
# 📱 Flutter App

- Built using Flutter
- Communicates with FastAPI backend
- Provides real-time crop recommendations to farmers
