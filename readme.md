# WSL + SSHFS: Trabajo con directorios remotos como si fueran locales

Este proyecto muestra cómo configurar un entorno de **WSL (Ubuntu)** para trabajar con directorios remotos de una máquina Linux usando **SSHFS** y **enlaces simbólicos**, ideal para desarrollo web.

---

## 🧩 Objetivo del proyecto

- Montar un directorio remoto (servidor Linux) dentro de WSL usando **SSHFS**.
- Crear un **punto de montaje** y un **enlace simbólico** cómodo para trabajar.
- Poder **montar sólo cuando se necesite** y **desmontar** fácilmente (por ejemplo, cuando desconectes de tu red doméstica/oficina).
- Compartir un flujo de trabajo reproducible para la comunidad, estudiantes y desarrolladores que usan WSL en Windows.

---

## 🏗️ Requisitos

#### Antes de comenzar, asegúrate de tener:

- Windows 10/11 con **WSL2** instalado y una distrbución basada en Ubuntu.
- Acceso SSH a una máquina Linux remota (usuario, IP/host, ruta del proyecto).
- Paquetes instalados en WSL: 
    - sudo apt update
    - sudo apt install git sshfs
- Grupo `fuse` creado y usuario agregado:
    - sudo groupadd -f fuse
    - sudo usermod -aG fuse $USER
    - newgrp fuse 
    - Puedes verificar tus grupos con: 
        - groups $USER
        - Deberías ver `fuse` en la lista.

## 📂 Estructura básica del entorno

#### El proyecto asume una estructura similar a:

- /home/tu_usuario/
    - montar_proyecto.sh
    - desmontar_proyecto.sh
    - proyecto_remoto/ # punto de montaje SSHFS
    - proyecto_web/ # enlace simbólico hacia proyecto_remoto
        - `proyecto_remoto/`: directorio donde se monta el proyecto remoto vía SSHFS.
        - `proyecto_web/`: enlace simbólico que apunta a `proyecto_remoto/`, y que usarás en tu editor/IDE.

---

## ⚙️ Configuración paso a paso

### 1. Crear punto de montaje

#### En WSL:
- mkdir -p ~/proyecto_remoto

##### Este será el **punto de montaje** donde se verá el contenido del servidor remoto.

### 2. Crear scripts para montar y desmontar

#### Script de montaje `montar_proyecto.sh`

- nano ~/montar_proyecto.sh

#### Contenido de ejemplo (ajusta variables según tu entorno):
#!/usr/bin/env bash
- REMOTE_USER="miusuario"
- REMOTE_HOST="192.168.1.100"
- REMOTE_DIR="/var/www/miproyecto"
- LOCAL_DIR="$HOME/proyecto_remoto"

#### Crear punto de montaje si no existe
- mkdir -p "$LOCAL_DIR"

#### Comprobar si el servidor responde (opcional)
- if ! ping -c 1 -W 1 "$REMOTE_HOST" >/dev/null 2>&1; then echo "⚠ No se puede alcanzar $REMOTE_HOST. ¿Estás en tu red?"
exit 1
fi

#### Evitar montar dos veces
- if mountpoint -q "$LOCAL_DIR"; then echo "✅ Ya está montado en $LOCAL_DIR" exit 0 fi
- sshfs -o idmap=user - "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" $LOCAL_DIR" && echo "✅ Montado en $LOCAL_DIR"

#### Dar permisos de ejecución:
- chmod +x ~/montar_proyecto.sh

#### Script de desmontaje `desmontar_proyecto.sh`
- nano ~/desmontar_proyecto.sh

#### Contenido
- LOCAL_DIR="$HOME/proyecto_remoto"
- if mountpoint -q "$LOCAL_DIR"; then
fusermount -u "$LOCAL_DIR" && echo "✅ Desmontado $LOCAL_DIR"
else
echo "ℹ $LOCAL_DIR no está montado"
fi

#### Permisos:
- chmod +x ~/desmontar_proyecto.sh

### 3. Crear el enlace simbólico
#### Esto simplifica mucho tu flujo con editores/IDE:
- ln -s ~/proyecto_remoto ~/proyecto_web
- ls -l ~/proyecto_web

#### Verás algo como:
- proyecto_web -> /home/tu_usuario/proyecto_remoto

Ahora puedes abrir `~/proyecto_web` en tu editor como si fuera una carpeta local. 

---

## 💻 Uso diario

### Montar cuando vayas a trabajar

#### En WSL:
- ~/montar_proyecto.sh

- Si estás en tu red y el servidor responde, montará el directorio remoto.
- Si no estás en la red correcta, el script te avisará y no montará nada.

### Desmontar cuando dejes de usar el proyecto

#### Antes de cerrar el notebook, cambiar de red, etc.:
- ~/desmontar_proyecto.sh

#### Esto evita problemas de bloqueo si el servidor ya no está disponible. A mi me pasó y es incómodo!🤔

---

## 🧪 Comprobaciones útiles

- Ver si el punto de montaje está activo:
    - mountpoint ~/proyecto_remoto
- Listar contenido remoto:
    - ls ~/proyecto_remoto
- Ver versión de SSHFS:
    - sshfs --version

---

## 🐛 Problemas frecuentes

- **`Permission denied` al montar**  
Verifica que tu usuario está en el grupo `fuse` y que iniciaste una nueva sesión (o usaste `newgrp fuse`).

- **Tarda mucho o se cuelga cuando cambias de red**  
Desmonta antes de irte: `~/desmontar_proyecto.sh`.  
En casos extremos:  
    - fusermount -u -z ~/proyecto_remoto

- **No llega al servidor remoto**  
Revisa IP/host, ping, y que el servicio SSH esté activo en el servidor. [web:79]

---

## 📚 Recursos recomendados

- Documentación de SSHFS (Ubuntu / Linux) 
- Tutoriales sobre compartir archivos vía SSHFS
- Guía básica de Git y comandos esenciales

---

## 👤 Autoría y comunidad

Este repo forma parte de mi proceso de aprendizaje en desarrollo **fullstack** usando **WSL + Linux + entornos remotos**, y está pensado para compartir con la comunidad (Conquer o quien lo necesite).  

### Si te sirve:

- Puedes abrir **Issues** con dudas o mejoras.
- Puedes hacer **Pull Requests** con mejoras al script, documentación o ejemplos para otros stacks (Node, Python, PHP, etc.).
- Utiliza Alias para mejorar aún más la experiencia de usuario.

¡Que te sea útil para mejorar tu entorno de desarrollo en Linux y WSL! 🚀















