from supabase import create_client
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
import os
# ----------------------------
# LOAD ENV VARIABLES
# ----------------------------
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")


print("SUPABASE_URL =", SUPABASE_URL)
print("SUPABASE_KEY LOADED =", bool(SUPABASE_KEY))
