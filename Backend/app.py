# app.py - Backend TechStore S.A.C.
from flask import Flask, request, jsonify, render_template, redirect, session, url_for
from flask_cors import CORS
import sqlite3
import os


app = Flask(__name__)
app.secret_key = 'techstore_secret_2026'
CORS(app)  # Habilitar CORS para permitir peticiones desde Flutter


DB_PATH = os.path.join(os.path.dirname(__file__), 'database.db')


def get_db():
    """Retorna una conexión a la base de datos SQLite."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row  # Permite acceso por nombre de columna
    return conn


def init_db():
    """Crea las tablas e inserta datos iniciales si no existen."""
    conn = get_db()
    cursor = conn.cursor()


    # Crear tabla usuario
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS usuario (
            id       INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT    NOT NULL UNIQUE,
            password TEXT    NOT NULL,
            nombre   TEXT,
            activo   INTEGER DEFAULT 1
        )
    ''')


    # Crear tabla producto
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS producto (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            codigo      TEXT    NOT NULL UNIQUE,
            nombre      TEXT    NOT NULL,
            categoria   TEXT    NOT NULL,
            precio      REAL    NOT NULL,
            stock       INTEGER DEFAULT 0,
            descripcion TEXT
        )
    ''')


    # Insertar usuario administrador de prueba
    cursor.execute("SELECT COUNT(*) FROM usuario")
    if cursor.fetchone()[0] == 0:
        cursor.execute(
            "INSERT INTO usuario (username, password, nombre) VALUES (?,?,?)",
            ('admin', 'admin123', 'Administrador TechStore')
        )
        cursor.execute(
            "INSERT INTO usuario (username, password, nombre) VALUES (?,?,?)",
            ('vendedor1', 'pass123', 'Juan Pérez')
        )


    # Insertar productos de muestra
    cursor.execute("SELECT COUNT(*) FROM producto")
    if cursor.fetchone()[0] == 0:
        productos = [
            ('PROD-001', 'Laptop HP Pavilion 15', 'Laptops', 2899.90, 10, 'Procesador Intel i5 12va generación'),
            ('PROD-002', 'Mouse Logitech MX Master', 'Periféricos', 189.90, 25, 'Mouse inalámbrico ergonómico'),
            ('PROD-003', 'Teclado Mecánico Redragon', 'Periféricos', 249.90, 15, 'Switches rojos, retroiluminado RGB'),
            ('PROD-004', 'Monitor Dell 24 FHD', 'Monitores', 799.90, 8, 'Pantalla IPS 1920x1080 75Hz'),
            ('PROD-005', 'Auriculares Sony WH-1000XM5', 'Audio', 1299.90, 12, 'Cancelación de ruido activa'),
            ('PROD-006', 'Smartphone Samsung Galaxy A54', 'Smartphones', 1199.90, 20, '6.4 pulgadas, 128GB, 5G'),
            ('PROD-007', 'Tablet iPad Air 5ta Gen', 'Tablets', 2999.90, 5, '10.9 pulgadas, M1 chip, WiFi'),
            ('PROD-008', 'SSD Kingston 1TB', 'Almacenamiento', 299.90, 30, 'SATA III, lectura 550 MB/s'),
        ]
        cursor.executemany(
            'INSERT INTO producto (codigo, nombre, categoria, precio, stock, descripcion) VALUES (?,?,?,?,?,?)',
            productos
        )
        conn.commit()
        conn.close()
        print('[DB] Base de datos inicializada correctamente.')


# ─────────────────────────────────────────────────────────────
# ENDPOINT REST: Login (para consumo desde Flutter)
# POST /api/login
# Body JSON: { "username": "admin", "password": "admin123" }
# ─────────────────────────────────────────────────────────────
@app.route('/api/login', methods=['POST'])
def api_login():
    datos = request.get_json()
    if not datos or 'username' not in datos or 'password' not in datos:
        return jsonify({'ok': False, 'mensaje': 'Datos incompletos'}), 400


    conn = get_db()
    cursor = conn.cursor()
    cursor.execute(
        'SELECT id, username, nombre FROM usuario WHERE username=? AND password=? AND activo=1',
        (datos['username'].strip(), datos['password'])
    )
    usuario = cursor.fetchone()
    conn.close()


    if usuario:
        return jsonify({
            'ok': True,
            'mensaje': 'Acceso exitoso',
            'usuario': {
                'id': usuario['id'],
                'username': usuario['username'],
                'nombre': usuario['nombre']
            }
        }), 200
    else:
        return jsonify({'ok': False, 'mensaje': 'Credenciales incorrectas'}), 401


# ─────────────────────────────────────────────────────────────
# ENDPOINT: Listar todos los productos
# GET /api/productos
# ─────────────────────────────────────────────────────────────
@app.route('/api/productos', methods=['GET'])
def listar_productos():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM producto ORDER BY nombre')
    rows = cursor.fetchall()
    conn.close()
    productos = [dict(row) for row in rows]
    return jsonify(productos), 200


# ─────────────────────────────────────────────────────────────
# ENDPOINT: Buscar productos por código, nombre o categoría
# GET /api/productos/buscar?q=<termino>
# ─────────────────────────────────────────────────────────────
@app.route('/api/productos/buscar', methods=['GET'])
def buscar_productos():
    q = request.args.get('q', '').strip()
    if not q:
        return jsonify([]), 200
    conn = get_db()
    cursor = conn.cursor()
    termino = f'%{q}%'
    cursor.execute(
        '''SELECT * FROM producto
           WHERE codigo LIKE ? OR nombre LIKE ? OR categoria LIKE ?
           ORDER BY nombre''',
        (termino, termino, termino)
    )
    rows = cursor.fetchall()
    conn.close()
    return jsonify([dict(row) for row in rows]), 200


# ─────────────────────────────────────────────────────────────
# ENDPOINT: Registrar un nuevo producto
# POST /api/productos
# ─────────────────────────────────────────────────────────────
@app.route('/api/productos', methods=['POST'])
def registrar_producto():
    datos = request.get_json()
    campos = ['codigo', 'nombre', 'categoria', 'precio']
    if not all(k in datos for k in campos):
        return jsonify({'ok': False, 'mensaje': 'Campos incompletos'}), 400
    try:
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute(
            'INSERT INTO producto (codigo, nombre, categoria, precio, stock, descripcion) VALUES (?,?,?,?,?,?)',
            (datos['codigo'], datos['nombre'], datos['categoria'],
             datos['precio'], datos.get('stock', 0), datos.get('descripcion', ''))
        )
        conn.commit()
        new_id = cursor.lastrowid
        conn.close()
        return jsonify({'ok': True, 'mensaje': 'Producto registrado', 'id': new_id}), 201
    except sqlite3.IntegrityError:
        return jsonify({'ok': False, 'mensaje': 'El código ya existe'}), 409


# ─────────────────────────────────────────────────────────────
# ENDPOINT: Actualizar un producto existente
# PUT /api/productos/<id>
# ─────────────────────────────────────────────────────────────
@app.route('/api/productos/<int:prod_id>', methods=['PUT'])
def actualizar_producto(prod_id):
    datos = request.get_json()
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute(
        '''UPDATE producto SET nombre=?, categoria=?, precio=?, stock=?, descripcion=?
           WHERE id=?''',
        (datos.get('nombre'), datos.get('categoria'), datos.get('precio'),
         datos.get('stock', 0), datos.get('descripcion', ''), prod_id)
    )
    conn.commit()
    conn.close()
    return jsonify({'ok': True, 'mensaje': 'Producto actualizado'}), 200


# ─────────────────────────────────────────────────────────────
# ENDPOINT: Eliminar un producto
# DELETE /api/productos/<id>
# ─────────────────────────────────────────────────────────────
@app.route('/api/productos/<int:prod_id>', methods=['DELETE'])
def eliminar_producto(prod_id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM producto WHERE id=?', (prod_id,))
    conn.commit()
    conn.close()
    return jsonify({'ok': True, 'mensaje': 'Producto eliminado'}), 200
# ─────────────────────────────────────────────────────────────
# RUTAS WEB (interfaz de administración en el navegador)
# ─────────────────────────────────────────────────────────────
@app.route('/', methods=['GET', 'POST'])
def web_login():
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')
        conn = get_db()
        cur = conn.cursor()
        cur.execute('SELECT id FROM usuario WHERE username=? AND password=?', (username, password))
        u = cur.fetchone()
        conn.close()
        if u:
            session['usuario_id'] = u['id']
            session['username']   = username
            return redirect(url_for('web_principal'))
        return render_template('login.html', error='Credenciales incorrectas')
    return render_template('login.html')


@app.route('/principal')
def web_principal():
    if 'usuario_id' not in session:
        return redirect(url_for('web_login'))
    return render_template('principal.html', username=session.get('username'))


@app.route('/productos-web', methods=['GET', 'POST'])
def web_productos():
    if 'usuario_id' not in session:
        return redirect(url_for('web_login'))
    conn = get_db()
    cur  = conn.cursor()
    mensaje = None
    if request.method == 'POST':
        accion = request.form.get('accion')
        if accion == 'agregar':
            try:
                cur.execute(
                    'INSERT INTO producto (codigo, nombre, categoria, precio, stock) VALUES (?,?,?,?,?)',
                    (request.form['codigo'], request.form['nombre'],
                     request.form['categoria'], request.form['precio'],
                     request.form.get('stock', 0))
                )
                conn.commit()
                mensaje = 'Producto agregado exitosamente.'
            except sqlite3.IntegrityError:
                mensaje = 'Error: El código del producto ya existe.'
        elif accion == 'eliminar':
            cur.execute('DELETE FROM producto WHERE id=?', (request.form['prod_id'],))
            conn.commit()
            mensaje = 'Producto eliminado.'
    cur.execute('SELECT * FROM producto ORDER BY nombre')
    productos = cur.fetchall()
    conn.close()
    return render_template('productos.html', productos=productos, mensaje=mensaje)


@app.route('/salir')
def web_salir():
    session.clear()
    return redirect(url_for('web_login'))


# ─────────────────────────────────────────────────────────────
# PUNTO DE ARRANQUE
# ─────────────────────────────────────────────────────────────
if __name__ == '__main__':
    init_db()
    app.run(debug=True, host='0.0.0.0', port=5000)
