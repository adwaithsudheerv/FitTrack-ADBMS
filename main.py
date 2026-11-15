"""
FitTrack Pro: Root Entrypoint for Cloud Deployment (Render / Railway / Heroku)
"""

import os
import sys

# Ensure FitTrack_ADBMS_Project/05_Web_Application is in Python path
base_dir = os.path.dirname(__file__)
app_dir = os.path.join(base_dir, "FitTrack_ADBMS_Project", "05_Web_Application")
if app_dir not in sys.path:
    sys.path.insert(0, app_dir)

from app import app

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port)
