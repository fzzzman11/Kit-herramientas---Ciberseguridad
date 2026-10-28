<img width="1254" height="1254" alt="image" src="https://github.com/user-attachments/assets/a05d1ed9-8422-4bf0-86ac-6409b9ab58f8" />




# ☠ SENATEVIL v2.0

<p align="center">
  <strong>☣ HERRAMIENTA DE AUDITORÍA DE SEGURIDAD EN LINUX ☣</strong>
  <br><br>
  <code>RECONOCIMIENTO • AUDITORÍA • ANÁLISIS • SEGURIDAD</code>
</p>

<p align="center">
  <samp>「 CONOCE TU SISTEMA. ANALIZA SU SEGURIDAD. 」</samp>
</p>

---

**SENATEVIL** es una herramienta interactiva desarrollada en Bash para realizar auditorías locales y tareas de reconocimiento autorizado en sistemas Linux.

Reúne diferentes funciones de inspección y análisis en una sola interfaz de terminal, permitiendo recopilar información del sistema, revisar registros, comprobar permisos y generar informes sin introducir cada comando manualmente.

Está orientada al aprendizaje práctico de Linux y a la auditoría de seguridad en entornos controlados.

> ⚠️ **USO ÉTICO:** ejecuta las funciones de reconocimiento únicamente en sistemas propios o sobre los que tengas autorización explícita.

---

## ☠ FUNCIONES PRINCIPALES

- 🔴 Información general y auditoría del sistema.
- 💀 Revisión de usuarios, sesiones y procesos activos.
- ☣ Búsqueda de archivos con permisos SUID/SGID.
- 🩸 Análisis de registros de autenticación.
- 🔐 Inventario de archivos mediante hashes SHA256.
- 🌐 Consultas DNS de dominios autorizados.
- ⚡ Inspección de puertos y conexiones de red.
- ⚔ Escaneo de puertos TCP.
- 🛡 Verificación de dependencias.
- 🔧 Gestión de permisos mediante `chmod`.
- 📂 Registro de actividad por sesión.
- 📑 Generación de informes TXT y HTML.
- 🔏 Verificación de integridad mediante hashes.

## ⚙ REQUISITOS

- Sistema operativo Linux.
- Bash 4.0 o superior.
- Herramientas base: `awk`, `grep`, `sed`, `find`, `sha256sum`, `ps`, `ss`, `ip` y `stat`.
- Herramientas opcionales: `dig`, `journalctl` y `less`.

### Instalar dependencias opcionales

Compatible con distribuciones basadas en Debian:

```bash
sudo apt update
sudo apt install dnsutils less
```

## ⚔ INSTALACIÓN

Clona el repositorio y accede al directorio del proyecto:

```bash
git clone https://github.com/fzzzman11/SENATEVIL.git
cd SENATEVIL
chmod +x cibersec_toolkit.sh
./cibersec_toolkit.sh
```

> Nota: comprueba que la URL del repositorio y el nombre del script coincidan con los archivos reales de tu proyecto.

## 🔴 EJECUCIÓN

Inicia la herramienta desde la terminal:

```bash
./cibersec_toolkit.sh
```

Aparecerá un menú interactivo desde el que podrás seleccionar el módulo que deseas ejecutar.

### Menú principal

<img width="759" height="519" alt="image" src="https://github.com/user-attachments/assets/bae5ba0a-74f6-44fd-85dc-15393778f3b7" />

```

Selecciona una opción e introduce los datos solicitados. Al finalizar cada módulo, podrás volver al menú principal.

## 🩸 DESCRIPCIÓN DE LOS MÓDULOS

### ☠ 1. Información del sistema

Muestra información general del equipo, incluyendo hostname, kernel, arquitectura, direcciones IP y tiempo de actividad.

<!-- CAPTURA DEL MÓDULO 1 -->
![Información del sistema](capturas/01-info-sistema.png)

---

### ☣ 2. Auditoría avanzada

Realiza una revisión general del sistema, incluyendo usuarios, permisos, puertos en escucha y archivos relevantes para la auditoría.

<!-- CAPTURA DEL MÓDULO 2 -->
![Auditoría avanzada](capturas/02-auditoria-avanzada.png)

---

### 💀 3. Usuarios y sesiones

Permite consultar usuarios conectados, últimos accesos y cuentas con shell válida.

<!-- CAPTURA DEL MÓDULO 3 -->
![Usuarios y sesiones](capturas/03-usuarios-sesiones.png)

---

### 🔴 4. Búsqueda SUID / SGID

Busca archivos con bits de permisos especiales para facilitar su identificación y revisión.

<!-- CAPTURA DEL MÓDULO 4 -->
![Búsqueda SUID y SGID](capturas/04-suid-sgid.png)

---

### 🩸 5. Análisis de registros de autenticación

Examina los registros disponibles para identificar intentos fallidos de autenticación y otros patrones relevantes.

<!-- CAPTURA DEL MÓDULO 5 -->
![Análisis de autenticación](capturas/05-logs-autenticacion.png)

---

### 🔐 6. Inventario SHA256

Calcula hashes SHA256 de los archivos de un directorio para facilitar su identificación y comparación posterior.

<!-- CAPTURA DEL MÓDULO 6 -->
![Inventario SHA256](capturas/06-inventario-sha256.png)

---

### 🌐 7. Reconocimiento DNS

Permite consultar registros DNS como A, AAAA, MX, NS, TXT, CNAME y SOA para dominios autorizados.

<!-- CAPTURA DEL MÓDULO 7 -->
![Reconocimiento DNS](capturas/07-reconocimiento-dns.png)

---

### ⚡ 8. Puertos y conexiones de red

Muestra puertos en escucha y conexiones activas disponibles en el sistema.

<!-- CAPTURA DEL MÓDULO 8 -->
![Puertos y conexiones](capturas/08-red-conexiones.png)

---

### ⚙ 9. Procesos en ejecución

Facilita la revisión de procesos activos y su consumo de recursos.

<!-- CAPTURA DEL MÓDULO 9 -->
![Procesos en ejecución](capturas/09-procesos.png)

---

### ⚔ 10. Escáner de puertos

Permite comprobar puertos TCP mediante rangos predefinidos o personalizados, dentro del alcance autorizado.

<!-- CAPTURA DEL MÓDULO 10 -->
![Escáner de puertos](capturas/10-escaner-puertos.png)

---

### 🛡 11. Verificación de dependencias

Comprueba qué herramientas necesita la aplicación y cuáles están disponibles en el sistema.

<!-- CAPTURA DEL MÓDULO 11 -->
![Verificación de dependencias](capturas/11-dependencias.png)

---

### 📂 12. Registro de actividad

Muestra el registro de las operaciones realizadas durante la sesión actual.

<!-- CAPTURA DEL MÓDULO 12 -->
![Registro de actividad](capturas/12-registro-actividad.png)

---

### 📑 13. Generación de informes

Genera reportes en formato TXT y HTML con los resultados recopilados durante la auditoría.

<!-- CAPTURA DEL MÓDULO 13 -->
![Generación de informes](capturas/13-informes.png)

---

### 🔧 14. Gestor de permisos

Permite modificar permisos mediante `chmod`, con confirmación explícita antes de aplicar los cambios.

<!-- CAPTURA DEL MÓDULO 14 -->
![Gestor de permisos](capturas/14-gestor-permisos.png)

---

### ☠ 15. Auditoría completa

Ejecuta los módulos principales y recopila los resultados para facilitar una revisión general del sistema.

<!-- CAPTURA DEL MÓDULO 15 -->
![Auditoría completa](capturas/15-auditoria-completa.png)
## 📂 RESULTADOS Y EVIDENCIAS

Los resultados se almacenan localmente en directorios asociados a cada sesión.

```text
cybersec_results/
├── identificador_sesion/
│   ├── session.log
│   ├── system_audit.txt
│   ├── auth_log_analysis.txt
│   └── hashes_*.sha256
└── reports/
    ├── INFORME_CYBERSEC_fecha.txt
    └── INFORME_CYBERSEC_fecha.html
```

Los archivos generados dependen de los módulos ejecutados.

- **Registros:** permiten consultar la actividad de la sesión.
- **Inventarios SHA256:** ayudan a detectar cambios entre archivos comparados.
- **Informes TXT:** presentan los resultados en texto plano.
- **Informes HTML:** organizan los resultados en un formato más cómodo para su revisión.

Los hashes no garantizan por sí solos la autenticidad de las evidencias.

## 🛡 FLUJO DE TRABAJO RECOMENDADO

```text
[01] Comprobar dependencias
          |
          v
[02] Ejecutar la auditoría
          |
          v
[03] Revisar las evidencias
          |
          v
[04] Generar el informe
          |
          v
[05] Comprobar los hashes
```

## 🔐 CONSIDERACIONES DE SEGURIDAD

- Los módulos de inspección están orientados principalmente a la lectura de información.
- El gestor de permisos puede modificar archivos; revisa cada cambio antes de confirmarlo.
- Algunos registros y datos del sistema requieren privilegios adicionales.
- Los escaneos de red deben limitarse a sistemas autorizados.
- Encontrar un puerto abierto o un archivo SUID/SGID no implica automáticamente que exista una vulnerabilidad.
- Los resultados deben analizarse antes de utilizarlos como evidencia de una incidencia.
- Evita ejecutar la herramienta como `root` si no es necesario.

## 🧪 CONCEPTOS APLICADOS

Este proyecto permite practicar diferentes conceptos de administración y seguridad en Linux:

- Funciones y modularidad en Bash.
- Bucles `while` y `for`.
- Condicionales `if` y `case`.
- Redirecciones, tuberías y manejo de errores.
- Validación de entradas.
- Gestión de permisos con `chmod` y `stat`.
- Inspección de procesos y conexiones.
- Consultas DNS y comprobaciones de puertos.
- Cálculo de hashes SHA256.
- Registro de actividad y generación automatizada de informes.

## 🔧 SOLUCIÓN DE PROBLEMAS

| Problema | Solución |
|---|---|
| `Permission denied` | Comprueba los permisos de ejecución del script. |
| `dig: command not found` | Instala `dnsutils`. |
| Registros vacíos | Revisa las rutas y los permisos de acceso. |
| No aparecen los colores | Utiliza una terminal compatible con ANSI. |
| Error al cambiar permisos | Comprueba el propietario y los privilegios necesarios. |
| Faltan dependencias | Ejecuta la opción 11 del menú. |

## 👤 AUTOR

**F. S. N. D.**

Estudiante de Ciberseguridad

GitHub: [@fzzzman11](https://github.com/fzzzman11)

## 📜 LICENCIA

Este proyecto se distribuye bajo la licencia MIT. Consulta el archivo `LICENSE` para conocer las condiciones de uso, modificación y distribución.

---

<p align="center">
  <samp>☠ SENATEVIL // LA SEGURIDAD EMPIEZA POR CONOCER TU SISTEMA ☠</samp>
</p>
