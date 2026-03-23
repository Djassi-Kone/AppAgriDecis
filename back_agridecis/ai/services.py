from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Dict, Optional

import json
import os
import urllib.request

try:  # l'import YOLO est optionnel
    from ultralytics import YOLO  # type: ignore[import-untyped]
except Exception:  # noqa: BLE001
    YOLO = None  # type: ignore[assignment]


@dataclass
class DiagnosisResult:
    label: str
    confidence: float
    details: Optional[Dict[str, Any]] = None


_YOLO_MODEL = None


def _get_yolo_model():
    """
    Charge le modèle YOLOv8 une seule fois.
    Utilise la variable d'env DIAG_MODEL_PATH (chemin vers le .pt) ou 'yolov8n.pt' par défaut.
    """
    global _YOLO_MODEL
    if _YOLO_MODEL is not None:
        return _YOLO_MODEL

    if YOLO is None:
        return None

    model_path = os.getenv("DIAG_MODEL_PATH", "yolov8n.pt")
    try:
        _YOLO_MODEL = YOLO(model_path)
    except Exception:  # noqa: BLE001
        _YOLO_MODEL = None
    return _YOLO_MODEL


def run_diagnosis(image_path: str) -> Dict[str, Any]:
    """
    Diagnostic basé sur YOLOv8 si disponible, sinon stub.
    """
    model = _get_yolo_model()
    if model is None:
        return {
            "model": "stub",
            "predictions": [
                {"label": "unknown", "confidence": 0.0},
            ],
        }

    results = model(image_path)
    preds = []
    for r in results:
        boxes = getattr(r, "boxes", None)
        if boxes is None:
            continue
        for b in boxes:
            cls_id = int(b.cls)
            label = r.names.get(cls_id, str(cls_id))
            conf = float(b.conf)
            xyxy = b.xyxy[0].tolist()
            preds.append({"label": label, "confidence": conf, "bbox": xyxy})

    return {
        "model": "yolov8",
        "predictions": preds,
    }


def generate_advice_reply(prompt: str) -> Dict[str, Any]:
    """
    Appel LLM via Ollama (optionnel) ou fallback stub.

    Env:
      - OLLAMA_BASE_URL (ex: http://localhost:11434)
      - OLLAMA_MODEL (ex: llama3.1)
    """
    base_url = os.getenv("OLLAMA_BASE_URL", "").rstrip("/")
    model = os.getenv("OLLAMA_MODEL", "llama3.1")
    if not base_url:
        return {"provider": "stub", "model": "stub", "content": "Service IA non configuré (OLLAMA_BASE_URL manquant)."}

    url = f"{base_url}/api/generate"
    payload = {"model": model, "prompt": prompt, "stream": False}
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers={"Content-Type": "application/json"}, method="POST")

    with urllib.request.urlopen(req, timeout=60) as resp:  # noqa: S310
        raw = resp.read().decode("utf-8")
    obj = json.loads(raw)
    return {"provider": "ollama", "model": model, "content": obj.get("response", "")}
