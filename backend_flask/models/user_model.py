# models/user_model.py - Modelo de Usuario
from models.db import get_db


class UserModel:
    """Gestiona las consultas relacionadas con la tabla usuario."""

    @staticmethod
    def validate_login(username, password):
        """Valida usuario y contraseña contra la base de datos."""
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute(
            '''SELECT id, username, nombre
               FROM usuario
               WHERE username=? AND password=? AND activo=1''',
            (username.strip(), password)
        )
        usuario = cursor.fetchone()
        conn.close()

        if usuario:
            return {
                'id': usuario['id'],
                'username': usuario['username'],
                'nombre': usuario['nombre']
            }

        return None
