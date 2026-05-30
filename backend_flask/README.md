# BACKEND_FLASK - Arquitectura MVC

Proyecto backend desarrollado con **Flask**, **SQLite** y **Flask-CORS**, reorganizado bajo el patrón arquitectónico **MVC**.

## 1. Estructura del proyecto

```text
BACKEND_FLASK/
├── app.py
├── config.py
├── requirements.txt
├── database.db
├── controllers/
│   ├── __init__.py
│   ├── auth_controller.py
│   ├── product_controller.py
│   └── web_controller.py
├── models/
│   ├── __init__.py
│   ├── db.py
│   ├── user_model.py
│   └── product_model.py
├── views/
│   └── templates/
│       ├── login.html
│       ├── principal.html
│       └── productos.html
└── static/
    └── style.css
```

## 2. Distribución MVC

### Modelo
Contiene la conexión a SQLite y las consultas SQL.

- `models/db.py`
- `models/user_model.py`
- `models/product_model.py`

### Vista
Contiene las plantillas HTML que se muestran en el navegador.

- `views/templates/login.html`
- `views/templates/principal.html`
- `views/templates/productos.html`
- `static/style.css`

### Controlador
Contiene las rutas REST y web.

- `controllers/auth_controller.py`
- `controllers/product_controller.py`
- `controllers/web_controller.py`

## 3. Instalación

```bash
cd BACKEND_FLASK
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

En macOS/Linux:

```bash
source venv/bin/activate
python app.py
```

## 4. Usuario de prueba

```text
usuario: admin
clave: admin123
```

## 5. Endpoints REST para Flutter

```text
POST    /api/login
GET     /api/productos
GET     /api/productos/buscar?q=laptop
POST    /api/productos
PUT     /api/productos/<id>
DELETE  /api/productos/<id>
```

## 6. Rutas web

```text
GET/POST /
GET      /principal
GET/POST /productos-web
GET      /salir
```

## 7. Recomendación de seguridad

Este ejemplo conserva contraseñas en texto plano porque corresponde a un laboratorio académico.
En producción, se debe aplicar hashing de contraseñas con herramientas como `werkzeug.security`.
