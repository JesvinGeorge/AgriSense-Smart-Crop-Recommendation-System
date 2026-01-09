# import os
# import joblib
# import numpy as np
# from fastapi import FastAPI, HTTPException
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel

# app = FastAPI(title="Karnataka Crop Recommendation API")

# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# MODEL_DIR = os.path.join(BASE_DIR, "models_15districts")

# selected_15 = [
#     "Mandya", "Vijayapura", "Bagalkote", "Gadag",
#     "Shivamogga", "Ramanagara", "Dharwad", "Belagavi",
#     "Hassan", "Mysuru", "Dakshina Kannada", "Kalaburagi",
#     "Haveri", "Udupi", "Chitradurga"
# ]

# district_map = {d.lower(): d for d in selected_15}

# models = {}
# for dist in selected_15:
#     models[dist] = {
#         "model": joblib.load(f"{MODEL_DIR}/{dist}_model.joblib"),
#         "le_crop": joblib.load(f"{MODEL_DIR}/{dist}_crop_encoder.pkl"),
#         "le_season": joblib.load(f"{MODEL_DIR}/{dist}_season_encoder.pkl"),
#         "scaler": joblib.load(f"{MODEL_DIR}/{dist}_scaler.pkl"),
#     }
#     print(f"✅ Loaded model for: {dist}")

# class InputData(BaseModel):
#     season: str
#     rainfall_mm: float
#     avg_temp_C: float
#     humidity: float
#     pH: float
#     N: float
#     P: float
#     K: float

# @app.post("/{district}/predict")
# def predict_crop(district: str, data: InputData):

#     district_key = district.lower().strip()
#     if district_key not in district_map:
#         raise HTTPException(404, "District not supported")

#     bundle = models[district_map[district_key]]

#     season_encoded = bundle["le_season"].transform(
#         [data.season.strip().title()]
#     )[0]

#     X = np.array([[season_encoded, data.rainfall_mm, data.avg_temp_C,
#                    data.humidity, data.pH, data.N, data.P, data.K]])

#     X_scaled = bundle["scaler"].transform(X)
#     probs = bundle["model"].predict_proba(X_scaled)[0]

#     top3 = np.argsort(probs)[::-1][:3]

#     return {
#         "district": district,
#         "top_3_crops": bundle["le_crop"].inverse_transform(top3).tolist(),
#         "probabilities": [round(float(probs[i]), 4) for i in top3]
#     }



# import os
# import joblib
# import numpy as np
# from fastapi import FastAPI, HTTPException
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
# from dotenv import load_dotenv
# from supabase import create_client

# # ----------------------------
# # LOAD ENV VARIABLES
# # ----------------------------
# load_dotenv()

# SUPABASE_URL = os.getenv("SUPABASE_URL")
# SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

# if not SUPABASE_URL or not SUPABASE_KEY:
#     raise RuntimeError("❌ Supabase env variables missing")

# supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# # ----------------------------
# # FASTAPI APP
# # ----------------------------
# app = FastAPI(title="AgriSense Crop Recommendation API")

# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# # ----------------------------
# # MODEL LOADING
# # ----------------------------
# BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# MODEL_DIR = os.path.join(BASE_DIR, "models_15districts")

# DISTRICTS = [
#     "Mandya", "Vijayapura", "Bagalkote", "Gadag",
#     "Shivamogga", "Ramanagara", "Dharwad", "Belagavi",
#     "Hassan", "Mysuru", "Dakshina Kannada", "Kalaburagi",
#     "Haveri", "Udupi", "Chitradurga"
# ]

# district_map = {d.lower(): d for d in DISTRICTS}

# models = {}

# for d in DISTRICTS:
#     models[d] = {
#         "model": joblib.load(f"{MODEL_DIR}/{d}_model.joblib"),
#         "le_crop": joblib.load(f"{MODEL_DIR}/{d}_crop_encoder.pkl"),
#         "le_season": joblib.load(f"{MODEL_DIR}/{d}_season_encoder.pkl"),
#         "scaler": joblib.load(f"{MODEL_DIR}/{d}_scaler.pkl"),
#     }
#     print(f"✅ Loaded model for {d}")

# # ----------------------------
# # INPUT SCHEMA
# # ----------------------------
# class InputData(BaseModel):
#     season: str
#     rainfall_mm: float
#     avg_temp_C: float
#     humidity: float
#     pH: float
#     N: float
#     P: float
#     K: float

# # ----------------------------
# # PREDICTION API
# # ----------------------------
# @app.post("/{district}/predict")
# def predict_crop(district: str, data: InputData):

#     key = district.lower().strip()
#     if key not in district_map:
#         raise HTTPException(404, "District not supported")

#     district_name = district_map[key]
#     bundle = models[district_name]

#     season_clean = data.season.strip().title()
#     season_encoded = bundle["le_season"].transform([season_clean])[0]

#     X = np.array([[
#         season_encoded,
#         data.rainfall_mm,
#         data.avg_temp_C,
#         data.humidity,
#         data.pH,
#         data.N,
#         data.P,
#         data.K
#     ]])

#     X_scaled = bundle["scaler"].transform(X)
#     proba = bundle["model"].predict_proba(X_scaled)[0]

#     top_idx = np.argsort(proba)[::-1][:3]
#     crops = bundle["le_crop"].inverse_transform(top_idx)
#     probs = [round(float(proba[i]), 4) for i in top_idx]

#     # ----------------------------
#     # SAVE TO SUPABASE ✅
#     # ----------------------------
#     supabase.table("crop_predictions").insert({
#         "district": district_name,
#         "season": season_clean,
#         "rainfall_mm": data.rainfall_mm,
#         "avg_temp_c": data.avg_temp_C,   # 🔴 IMPORTANT (lowercase c)
#         "humidity": data.humidity,
#         "ph": data.pH,
#         "n": data.N,
#         "p": data.P,
#         "k": data.K,
#         "top_3_crops": crops.tolist(),
#         "probabilities": probs
#     }).execute()

#     return {
#         "district": district_name,
#         "top_3_crops": crops.tolist(),
#         "probabilities": probs
#     }




# import os
# import joblib
# import numpy as np
# from fastapi import FastAPI, HTTPException
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
# from dotenv import load_dotenv
# from supabase import create_client

# load_dotenv()

# SUPABASE_URL = os.getenv("SUPABASE_URL")
# SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

# supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# app = FastAPI(title="AgriSense API")

# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# MODEL_DIR = os.path.join(BASE_DIR, "models_15districts")

# DISTRICTS = [
#     "Mandya","Vijayapura","Bagalkote","Gadag","Shivamogga",
#     "Ramanagara","Dharwad","Belagavi","Hassan","Mysuru",
#     "Dakshina Kannada","Kalaburagi","Haveri","Udupi","Chitradurga"
# ]

# models = {}
# for d in DISTRICTS:
#     models[d.lower()] = {
#         "model": joblib.load(f"{MODEL_DIR}/{d}_model.joblib"),
#         "crop": joblib.load(f"{MODEL_DIR}/{d}_crop_encoder.pkl"),
#         "season": joblib.load(f"{MODEL_DIR}/{d}_season_encoder.pkl"),
#         "scaler": joblib.load(f"{MODEL_DIR}/{d}_scaler.pkl"),
#     }

# class InputData(BaseModel):
#     season: str
#     rainfall_mm: float
#     avg_temp_C: float
#     humidity: float
#     pH: float
#     N: float
#     P: float
#     K: float

# @app.post("/{district}/predict")
# def predict(district: str, data: InputData):
#     key = district.lower()
#     if key not in models:
#         raise HTTPException(404, "District not supported")

#     b = models[key]
#     s = b["season"].transform([data.season.title()])[0]

#     X = np.array([[s, data.rainfall_mm, data.avg_temp_C,
#                    data.humidity, data.pH, data.N, data.P, data.K]])

#     X = b["scaler"].transform(X)
#     probs = b["model"].predict_proba(X)[0]

#     idx = np.argsort(probs)[::-1][:3]
#     crops = b["crop"].inverse_transform(idx)
#     prob = [float(probs[i]) for i in idx]

#     supabase.table("crop_predictions").insert({
#         "district": district.title(),
#         "season": data.season,
#         "rainfall_mm": data.rainfall_mm,
#         "avg_temp_c": data.avg_temp_C,
#         "humidity": data.humidity,
#         "ph": data.pH,
#         "n": data.N,
#         "p": data.P,
#         "k": data.K,
#         "top_3_crops": crops.tolist(),
#         "probabilities": prob
#     }).execute()

#     return {"top_3_crops": crops.tolist(), "probabilities": prob}



import os
import joblib
import numpy as np
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from supabase import create_client

# ----------------------------
# LOAD ENV
# ----------------------------
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise RuntimeError("Supabase env variables missing")

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# ----------------------------
# FASTAPI APP
# ----------------------------
app = FastAPI(title="AgriSense Crop Recommendation API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------
# LOAD MODELS
# ----------------------------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR, "models_15districts")

DISTRICTS = [
    "Mandya","Vijayapura","Bagalkote","Gadag","Shivamogga",
    "Ramanagara","Dharwad","Belagavi","Hassan","Mysuru",
    "Dakshina Kannada","Kalaburagi","Haveri","Udupi","Chitradurga"
]

models = {}
for d in DISTRICTS:
    models[d.lower()] = {
        "model": joblib.load(f"{MODEL_DIR}/{d}_model.joblib"),
        "crop": joblib.load(f"{MODEL_DIR}/{d}_crop_encoder.pkl"),
        "season": joblib.load(f"{MODEL_DIR}/{d}_season_encoder.pkl"),
        "scaler": joblib.load(f"{MODEL_DIR}/{d}_scaler.pkl"),
    }
    print(f"✅ Loaded model for {d}")

# ----------------------------
# INPUT SCHEMA
# ----------------------------
class InputData(BaseModel):
    season: str
    rainfall_mm: float
    avg_temp_C: float
    humidity: float
    pH: float
    N: float
    P: float
    K: float

# ----------------------------
# VALIDATION FUNCTION ✅
# ----------------------------
def validate(data: InputData):
    if not (0 <= data.rainfall_mm <= 5000):
        raise HTTPException(400, "Rainfall must be between 0 and 5000 mm")

    if not (0 <= data.avg_temp_C <= 60):
        raise HTTPException(400, "Temperature must be between 0 and 60 °C")

    if not (0 <= data.humidity <= 100):
        raise HTTPException(400, "Humidity must be between 0 and 100%")

    if not (3 <= data.pH <= 9):
        raise HTTPException(400, "Soil pH must be between 3 and 9")

    if not (0 <= data.N <= 300):
        raise HTTPException(400, "Nitrogen out of range")

    if not (0 <= data.P <= 200):
        raise HTTPException(400, "Phosphorus out of range")

    if not (0 <= data.K <= 300):
        raise HTTPException(400, "Potassium out of range")

# ----------------------------
# PREDICTION API
# ----------------------------
@app.post("/{district}/predict")
def predict(district: str, data: InputData):

    key = district.lower()
    if key not in models:
        raise HTTPException(404, "District not supported")

    validate(data)  # 🔥 IMPORTANT

    b = models[key]

    season_encoded = b["season"].transform([data.season.title()])[0]

    X = np.array([[ 
        season_encoded,
        data.rainfall_mm,
        data.avg_temp_C,
        data.humidity,
        data.pH,
        data.N,
        data.P,
        data.K
    ]])

    X = b["scaler"].transform(X)
    probs = b["model"].predict_proba(X)[0]

    idx = np.argsort(probs)[::-1][:3]
    crops = b["crop"].inverse_transform(idx)
    probabilities = [round(float(probs[i]), 4) for i in idx]

    # ----------------------------
    # SAVE TO SUPABASE (ONLY VALID DATA)
    # ----------------------------
    supabase.table("crop_predictions").insert({
        "district": district.title(),
        "season": data.season,
        "rainfall_mm": data.rainfall_mm,
        "avg_temp_c": data.avg_temp_C,
        "humidity": data.humidity,
        "ph": data.pH,
        "n": data.N,
        "p": data.P,
        "k": data.K,
        "top_3_crops": crops.tolist(),
        "probabilities": probabilities
    }).execute()

    return {
        "top_3_crops": crops.tolist(),
        "probabilities": probabilities
    }
