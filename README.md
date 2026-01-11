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

<p align="center">
  <img src="images/system_architecture.png" width="650">
</p>

**Architecture Flow:**
1. Dataset preprocessing and cleaning  
2. District-wise dataset split  
3. Training multiple ML models per district  
4. Selecting best model based on accuracy  
5. Saving models, encoders, and scalers  
6. FastAPI backend for prediction  
7. Flutter mobile app for user interaction  
8. Supabase for database and authentication  

---

## 📊 Model Performance (Confusion Matrices)

### Mandya – LightGBM (Accuracy: 84.52%)
<p align="center">
  <img src="images/mandya_confusion.png" width="600">
</p>

### Vijayapura – CatBoost (Accuracy: 93.08%)
<p align="center">
  <img src="images/vijayapura_confusion.png" width="600">
</p>

### Belagavi – CatBoost (Accuracy: 96.65%)
<p align="center">
  <img src="images/belagavi_confusion.png" width="600">
</p>

---

## 📱 Flutter Mobile Application

### Input Screen
<p align="center">
  <img src="images/app_input.png" width="300">
</p>

### Filled Input Form
<p align="center">
  <img src="images/app_filled_input.png" width="300">
</p>

### Top-3 Crop Recommendation Output
<p align="center">
  <img src="images/app_output.png" width="300">
</p>

---

## 📁 Project Structure

```text
AgriSense_APP/
│
├── images/
│   ├── system_architecture.png
│   ├── mandya_confusion.png
│   ├── vijayapura_confusion.png
│   ├── belagavi_confusion.png
│   ├── app_input.png
│   ├── app_filled_input.png
│   └── app_output.png
│
├── backend/
│   ├── app.py
│   ├── models_15districts/
│   └── requirements.txt
│
├── agrisense_app/
│   ├── lib/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── main.ipynb
├── requirements.txt
└── README.md
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
