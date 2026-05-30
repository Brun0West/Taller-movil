# config.py - Configuración general del backend
import os


BASE_DIR = os.path.dirname(os.path.abspath(__file__))


class Config:
    """Configuración base de la aplicación Flask."""
    SECRET_KEY = 'techstore_secret_2026'
    DATABASE_PATH = os.path.join(BASE_DIR, 'database.db')
