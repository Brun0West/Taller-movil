# models/product_model.py - Modelo de Producto
import sqlite3
from models.db import get_db


class ProductModel:
    """Gestiona las consultas relacionadas con la tabla producto."""

    @staticmethod
    def list_all():
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM producto ORDER BY nombre')
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def search(query):
        if not query:
            return []

        conn = get_db()
        cursor = conn.cursor()
        termino = f'%{query}%'
        cursor.execute(
            '''SELECT * FROM producto
               WHERE codigo LIKE ? OR nombre LIKE ? OR categoria LIKE ?
               ORDER BY nombre''',
            (termino, termino, termino)
        )
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def create(data):
        conn = get_db()
        cursor = conn.cursor()
        try:
            cursor.execute(
                '''INSERT INTO producto
                   (codigo, nombre, categoria, precio, stock, descripcion)
                   VALUES (?,?,?,?,?,?)''',
                (
                    data['codigo'],
                    data['nombre'],
                    data['categoria'],
                    data['precio'],
                    data.get('stock', 0),
                    data.get('descripcion', '')
                )
            )
            conn.commit()
            new_id = cursor.lastrowid
            return {'ok': True, 'id': new_id}
        except sqlite3.IntegrityError:
            return {'ok': False, 'error': 'duplicado'}
        finally:
            conn.close()

    @staticmethod
    def update(product_id, data):
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute(
            '''UPDATE producto
               SET nombre=?, categoria=?, precio=?, stock=?, descripcion=?
               WHERE id=?''',
            (
                data.get('nombre'),
                data.get('categoria'),
                data.get('precio'),
                data.get('stock', 0),
                data.get('descripcion', ''),
                product_id
            )
        )
        conn.commit()
        affected_rows = cursor.rowcount
        conn.close()
        return affected_rows > 0

    @staticmethod
    def delete(product_id):
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM producto WHERE id=?', (product_id,))
        conn.commit()
        affected_rows = cursor.rowcount
        conn.close()
        return affected_rows > 0
