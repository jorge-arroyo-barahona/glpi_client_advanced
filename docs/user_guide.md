# GLPI Advanced Client - User Guide

*Versión en español más abajo*

## English Version

### Table of Contents
1. [Getting Started](#getting-started)
2. [Authentication](#authentication)
3. [Dashboard Overview](#dashboard-overview)
4. [Ticket Management](#ticket-management)
5. [AI Assistant](#ai-assistant)
6. [Location Features](#location-features)
7. [Settings](#settings)
8. [Troubleshooting](#troubleshooting)

---

## Getting Started

### System Requirements

- **Operating System**: Windows 10+, macOS 10.15+, Linux Ubuntu 18.04+
- **Web Browser**: Chrome 90+, Firefox 88+, Safari 14+
- **Mobile**: Android 8.0+, iOS 13.0+
- **Network**: Stable internet connection

### Installation

#### Desktop (Windows/macOS/Linux)

1. Download the installer from [releases page](https://github.com/yourusername/glpi_client_advanced/releases)
2. Run the installer and follow the setup wizard
3. Launch the application from your desktop

#### Web

1. Open your web browser
2. Navigate to your GLPI Client URL
3. Bookmark for easy access

#### Mobile (Android/iOS)

1. Download from App Store/Google Play Store
2. Install the application
3. Open and configure your connection

### First Launch

1. **Welcome Screen**: Read the introduction
2. **Server Configuration**: Enter your GLPI server URL
3. **Authentication**: Choose your preferred method
4. **Initial Sync**: Wait for data synchronization

---

## Authentication

### User Token (Recommended)

1. **Generate Token**:
   - Log in to your GLPI web interface
   - Go to your user profile
   - Find "API" section
   - Click "Generate API Token"

2. **Use Token**:
   - Select "User Token" authentication method
   - Enter your App Token (from GLPI admin)
   - Enter your User Token
   - Click "Login"

### Username/Password

1. **Select Method**: Choose "Username/Password"
2. **Enter Credentials**:
   - App Token (from GLPI admin)
   - Your GLPI username
   - Your GLPI password
3. **Login**: Click to authenticate

### Security Tips

- **Keep tokens secure**: Don't share your tokens
- **Use HTTPS**: Always connect over secure connections
- **Regular updates**: Update your client regularly
- **Logout**: Always logout when finished

---

## Dashboard Overview

### Main Interface

```
┌─────────────────────────────────────────────────────────┐
│  GLPI Tickets                    [🔍] [🤖] [👤]        │
├─────────────────────────────────────────────────────────┤
│  [Search Bar] [All] [New] [Assigned] [Pending] [Solved] │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐│
│  │  Ticket Statistics                                  ││
│  │  Total: 150  New: 15  Open: 45  Solved: 90        ││
│  └─────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐│
│  │  Ticket #1234                                       ││
│  │  [New] [High] Server Down                          ││
│  │  The main server is not responding...              ││
│  │  📅 Today 14:30  👤 John Doe                      ││
│  └─────────────────────────────────────────────────────┘│
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Key Areas

1. **Header Bar**: App title, search, AI assistant, user menu
2. **Search & Filters**: Find and filter tickets
3. **Statistics**: Overview of ticket status
4. **Ticket List**: Main content area
5. **AI Assistant**: Floating AI help panel

### Navigation

- **Click tickets**: View details
- **Search bar**: Find specific tickets
- **Filter chips**: Filter by status
- **User menu**: Profile, settings, logout

---

## Ticket Management

### Viewing Tickets

1. **Ticket Cards**: Each ticket shows:
   - Status (New, Assigned, Pending, Solved, Closed)
   - Priority (Low, Medium, High, Major)
   - Title and description preview
   - Date and assignee information

2. **Ticket Details**:
   - Full description
   - Comments and history
   - Attachments
   - Related tickets

### Creating Tickets

1. **Click "+" button**: Bottom right corner
2. **Fill Form**:
   - Title: Brief description
   - Description: Detailed information
   - Category: Select from dropdown
   - Priority: Choose appropriate level
   - Location: Add location if needed

3. **AI Assistance**:
   - Click AI assistant icon
   - Ask for category suggestions
   - Get content improvement tips
   - Find similar tickets

### Updating Tickets

1. **Select Ticket**: Click on ticket card
2. **Edit Mode**: Click edit button
3. **Modify Fields**: Update information
4. **Save Changes**: Click save button

### Ticket Actions

- **Assign**: Assign to user or group
- **Update Status**: Change ticket status
- **Add Comment**: Leave notes and updates
- **Attach Files**: Add documents or images
- **Link Tickets**: Connect related tickets

---

## AI Assistant

### Opening AI Assistant

- Click the robot icon in the header
- The AI panel opens on the right side
- Start typing your question

### AI Capabilities

#### 1. Ticket Analysis
```
User: "Analyze this ticket about server issues"
AI: "I've analyzed your ticket. Here are some suggestions:
    - Add more specific error details
    - Include server specifications
    - Consider adding logs or screenshots
    - Priority seems appropriate for impact"
```

#### 2. Category Suggestions
```
User: "What category should I use for printer problems?"
AI: "Based on your description, I suggest these categories:
    1. Hardware > Printers
    2. Infrastructure > Office Equipment
    3. Technical Support > Hardware Issues"
```

#### 3. Finding Similar Tickets
```
User: "Find tickets similar to 'email not working'"
AI: "I found 5 similar tickets:
    - Ticket #123: Outlook connection issues
    - Ticket #456: Email server problems
    - Ticket #789: SMTP configuration"
```

#### 4. Response Generation
```
User: "Generate a response for a user asking about VPN access"
AI: "Dear [User],
    
    Thank you for contacting IT support regarding VPN access.
    
    To set up your VPN connection, please follow these steps:
    1. Download the VPN client from [link]
    2. Install using your credentials
    3. Connect using server: vpn.company.com
    
    If you need further assistance, please let us know.
    
    Best regards,
    IT Support Team"
```

### AI Tips

- **Be Specific**: Ask detailed questions
- **Provide Context**: Include relevant information
- **Use Examples**: Show what you need
- **Review Suggestions**: Always verify AI recommendations

---

## Location Features

### Enabling Location

1. **Permission Request**: App will ask for location permission
2. **Grant Access**: Allow location access
3. **Configure**: Choose accuracy level

### Using Current Location

1. **Click Location Button**: In ticket creation or editing
2. **Get Current Position**: App fetches GPS coordinates
3. **Add to Ticket**: Location is attached to ticket

### Address Search

1. **Enter Address**: Type in address field
2. **Search**: App finds coordinates
3. **Select**: Choose from results
4. **Add to Ticket**: Location is saved

### Location Features

- **Current Location**: Use device GPS
- **Address Search**: Find by address
- **Map View**: Visualize locations
- **Distance Calculation**: Measure distances
- **Location Filtering**: Filter tickets by area

### Location Privacy

- **User Control**: You control location sharing
- **Local Storage**: Locations stored locally
- **No Tracking**: App doesn't track your movements
- **Secure**: Location data is encrypted

---

## Settings

### General Settings

- **Theme**: Light or dark mode
- **Language**: Choose your preferred language
- **Notifications**: Configure alerts
- **Auto-refresh**: Set refresh intervals

### AI Settings

- **Enable AI**: Turn AI assistant on/off
- **AI Model**: Choose AI model (if multiple available)
- **Response Style**: Formal or casual tone
- **Privacy**: Control AI data usage

### Location Settings

- **Enable Location**: Turn location features on/off
- **Accuracy**: Choose GPS accuracy level
- **Privacy**: Control location data sharing
- **Default Location**: Set default location

### Sync Settings

- **Auto-sync**: Automatic data synchronization
- **Sync Interval**: How often to sync data
- **Offline Mode**: Work without internet
- **Data Usage**: Control data consumption

---

## Troubleshooting

### Common Issues

#### Can't Connect to Server

**Symptoms**: Connection timeout, authentication failed

**Solutions**:
1. Check internet connection
2. Verify server URL is correct
3. Confirm server is running
4. Check firewall settings
5. Try different authentication method

#### Tickets Not Loading

**Symptoms**: Empty ticket list, loading errors

**Solutions**:
1. Pull to refresh
2. Check filters are not too restrictive
3. Verify permissions
4. Clear cache and reload
5. Check server status

#### AI Assistant Not Working

**Symptoms**: No AI responses, errors

**Solutions**:
1. Check internet connection
2. Verify AI service is enabled
3. Check API key configuration
4. Try simpler queries
5. Contact administrator

#### Location Not Working

**Symptoms**: Can't get location, wrong location

**Solutions**:
1. Enable location services
2. Grant location permission
3. Check GPS is working
4. Try manual address entry
5. Restart the app

### Getting Help

1. **Check Documentation**: This guide and online docs
2. **Community Forum**: Ask other users
3. **GitHub Issues**: Report bugs
4. **Contact Support**: For enterprise users

### Performance Tips

- **Close Unused Apps**: Free up memory
- **Clear Cache**: Regularly clear app cache
- **Update App**: Keep app updated
- **Stable Connection**: Use stable internet
- **Regular Sync**: Keep data synchronized

---

## Advanced Features

### Keyboard Shortcuts

- **Ctrl/Cmd + K**: Open search
- **Ctrl/Cmd + N**: New ticket
- **Ctrl/Cmd + R**: Refresh
- **Ctrl/Cmd + ,**: Open settings
- **Esc**: Close dialogs

### Bulk Operations

1. **Select Multiple**: Hold Ctrl/Cmd and click
2. **Right-click**: Context menu
3. **Bulk Actions**: Update status, assign, delete

### Export/Import

- **Export Tickets**: CSV, PDF formats
- **Import Data**: Bulk ticket creation
- **Backup**: Save app data
- **Restore**: Import backup data

---

## 🌟 Versión en Español

### Guía de Usuario del Cliente Avanzado GLPI

### Contenido

1. [Primeros Pasos](#primeros-pasos-es)
2. [Autenticación](#autenticación-es)
3. [Panel de Control](#panel-de-control-es)
4. [Gestión de Tickets](#gestión-de-tickets-es)
5. [Asistente de IA](#asistente-de-ia-es)
6. [Funciones de Ubicación](#funciones-de-ubicación-es)
7. [Configuración](#configuración-es)
8. [Solución de Problemas](#solución-de-problemas-es)

---

## Primeros Pasos

### Requisitos del Sistema

- **Sistema Operativo**: Windows 10+, macOS 10.15+, Linux Ubuntu 18.04+
- **Navegador Web**: Chrome 90+, Firefox 88+, Safari 14+
- **Móvil**: Android 8.0+, iOS 13.0+
- **Red**: Conexión a internet estable

### Instalación

#### Escritorio (Windows/macOS/Linux)

1. Descargue el instalador de la [página de releases](https://github.com/yourusername/glpi_client_advanced/releases)
2. Ejecute el instalador y siga el asistente
3. Lance la aplicación desde el escritorio

#### Web

1. Abra su navegador web
2. Navegue a la URL de su Cliente GLPI
3. Añada a favoritos para acceso fácil

#### Móvil (Android/iOS)

1. Descargue de App Store/Google Play Store
2. Instale la aplicación
3. Abra y configure su conexión

### Primer Lanzamiento

1. **Pantalla de Bienvenida**: Lea la introducción
2. **Configuración del Servidor**: Ingrese la URL de su servidor GLPI
3. **Autenticación**: Elija su método preferido
4. **Sincronización Inicial**: Espere la sincronización de datos

---

## Autenticación

### Token de Usuario (Recomendado)

1. **Generar Token**:
   - Inicie sesión en su interfaz web GLPI
   - Vaya a su perfil de usuario
   - Busque la sección "API"
   - Haga clic en "Generar Token API"

2. **Usar Token**:
   - Seleccione el método de autenticación "Token de Usuario"
   - Ingrese su Token de App (del administrador GLPI)
   - Ingrese su Token de Usuario
   - Haga clic en "Iniciar Sesión"

### Nombre de Usuario/Contraseña

1. **Seleccionar Método**: Elija "Nombre de Usuario/Contraseña"
2. **Ingresar Credenciales**:
   - Token de App (del administrador GLPI)
   - Su nombre de usuario GLPI
   - Su contraseña GLPI
3. **Iniciar Sesión**: Haga clic para autenticar

### Consejos de Seguridad

- **Mantenga tokens seguros**: No comparta sus tokens
- **Use HTTPS**: Siempre conéctese sobre conexiones seguras
- **Actualizaciones regulares**: Actualice su cliente regularmente
- **Cierre sesión**: Siempre cierre sesión al terminar

---

## Panel de Control

### Interfaz Principal

```
┌─────────────────────────────────────────────────────────┐
│  Tickets GLPI                    [🔍] [🤖] [👤]        │
├─────────────────────────────────────────────────────────┤
│  [Barra de Búsqueda] [Todos] [Nuevo] [Asignado] [Pendiente]│
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐│
│  │  Estadísticas de Tickets                           ││
│  │  Total: 150  Nuevo: 15  Abierto: 45  Resuelto: 90 ││
│  └─────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐│
│  │  Ticket #1234                                      ││
│  │  [Nuevo] [Alto] Servidor Caído                     ││
│  │  El servidor principal no responde...              ││
│  │  📅 Hoy 14:30  👤 Juan Pérez                      ││
│  └─────────────────────────────────────────────────────┘│
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Áreas Principales

1. **Barra de Encabezado**: Título de la app, búsqueda, asistente de IA, menú de usuario
2. **Búsqueda y Filtros**: Encontrar y filtrar tickets
3. **Estadísticas**: Vista general del estado de tickets
4. **Lista de Tickets**: Área de contenido principal
5. **Asistente de IA**: Panel flotante de ayuda de IA

### Navegación

- **Clic en tickets**: Ver detalles
- **Barra de búsqueda**: Encontrar tickets específicos
- **Filtros**: Filtrar por estado
- **Menú de usuario**: Perfil, configuración, cerrar sesión

---

## Gestión de Tickets

### Ver Tickets

1. **Tarjetas de Ticket**: Cada ticket muestra:
   - Estado (Nuevo, Asignado, Pendiente, Resuelto, Cerrado)
   - Prioridad (Baja, Media, Alta, Mayor)
   - Vista previa del título y descripción
   - Fecha e información del asignado

2. **Detalles del Ticket**:
   - Descripción completa
   - Comentarios e historial
   - Adjuntos
   - Tickets relacionados

### Crear Tickets

1. **Haga clic en "+"**: Esquina inferior derecha
2. **Complete el Formulario**:
   - Título: Descripción breve
   - Descripción: Información detallada
   - Categoría: Seleccione del menú desplegable
   - Prioridad: Elija el nivel apropiado
   - Ubicación: Agregue ubicación si es necesario

3. **Asistencia de IA**:
   - Haga clic en el ícono del asistente de IA
   - Pida sugerencias de categoría
   - Obtenga consejos de mejora de contenido
   - Encuentre tickets similares

### Actualizar Tickets

1. **Seleccione Ticket**: Haga clic en la tarjeta del ticket
2. **Modo Edición**: Haga clic en el botón editar
3. **Modifique Campos**: Actualice la información
4. **Guarde Cambios**: Haga clic en el botón guardar

### Acciones de Ticket

- **Asignar**: Asignar a usuario o grupo
- **Actualizar Estado**: Cambiar el estado del ticket
- **Agregar Comentario**: Dejar notas y actualizaciones
- **Adjuntar Archivos**: Agregar documentos o imágenes
- **Enlazar Tickets**: Conectar tickets relacionados

---

## Asistente de IA

### Abrir el Asistente de IA

- Haga clic en el ícono de robot en el encabezado
- El panel de IA se abre en el lado derecho
- Comience a escribir su pregunta

### Capacidades de IA

#### 1. Análisis de Ticket
```
Usuario: "Analiza este ticket sobre problemas del servidor"
IA: "He analizado su ticket. Aquí hay algunas sugerencias:
    - Agregue más detalles específicos del error
    - Incluya especificaciones del servidor
    - Considere agregar registros o capturas de pantalla
    - La prioridad parece apropiada para el impacto"
```

#### 2. Sugerencias de Categoría
```
Usuario: "¿Qué categoría debo usar para problemas de impresora?"
IA: "Basado en su descripción, sugiero estas categorías:
    1. Hardware > Impresoras
    2. Infraestructura > Equipos de Oficina
    3. Soporte Técnico > Problemas de Hardware"
```

#### 3. Encontrar Tickets Similares
```
Usuario: "Encuentra tickets similares a 'email no funciona'"
IA: "Encontré 5 tickets similares:
    - Ticket #123: Problemas de conexión de Outlook
    - Ticket #456: Problemas del servidor de email
    - Ticket #789: Configuración SMTP"
```

#### 4. Generación de Respuesta
```
Usuario: "Genera una respuesta para un usuario preguntando sobre acceso VPN"
IA: "Estimado [Usuario],
    
    Gracias por contactar al soporte de IT respecto al acceso VPN.
    
    Para configurar su conexión VPN, por favor siga estos pasos:
    1. Descargue el cliente VPN de [enlace]
    2. Instale usando sus credenciales
    3. Conéctese usando el servidor: vpn.company.com
    
    Si necesita más ayuda, por favor háganoslo saber.
    
    Atentamente,
    Equipo de Soporte de IT"
```

### Consejos de IA

- **Sea Específico**: Haga preguntas detalladas
- **Proporcione Contexto**: Incluya información relevante
- **Use Ejemplos**: Muestre lo que necesita
- **Revise Sugerencias**: Siempre verifique las recomendaciones de IA

---

## Funciones de Ubicación

### Habilitar Ubicación

1. **Solicitud de Permiso**: La aplicación pedirá permiso de ubicación
2. **Conceder Acceso**: Permita el acceso a la ubicación
3. **Configurar**: Elija el nivel de precisión

### Usar Ubicación Actual

1. **Haga clic en Botón de Ubicación**: En creación o edición de ticket
2. **Obtener Posición Actual**: La aplicación obtiene coordenadas GPS
3. **Agregar al Ticket**: La ubicación se adjunta al ticket

### Búsqueda de Dirección

1. **Ingrese Dirección**: Escriba en el campo de dirección
2. **Buscar**: La aplicación encuentra coordenadas
3. **Seleccionar**: Elija de los resultados
4. **Agregar al Ticket**: La ubicación se guarda

### Funciones de Ubicación

- **Ubicación Actual**: Use el GPS del dispositivo
- **Búsqueda de Dirección**: Encuentre por dirección
- **Vista de Mapa**: Visualice ubicaciones
- **Cálculo de Distancia**: Mida distancias
- **Filtrado por Ubicación**: Filtre tickets por área

### Privacidad de Ubicación

- **Control del Usuario**: Usted controla el uso de ubicación
- **Almacenamiento Local**: Las ubicaciones se almacenan localmente
- **Sin Seguimiento**: La aplicación no rastrea sus movimientos
- **Seguro**: Los datos de ubicación están encriptados

---

## Configuración

### Configuración General

- **Tema**: Modo claro u oscuro
- **Idioma**: Elija su idioma preferido
- **Notificaciones**: Configure alertas
- **Auto-refrescar**: Establezca intervalos de actualización

### Configuración de IA

- **Habilitar IA**: Encienda/apague el asistente de IA
- **Modelo de IA**: Elija modelo de IA (si hay varios disponibles)
- **Estilo de Respuesta**: Tono formal o casual
- **Privacidad**: Controle el uso de datos de IA

### Configuración de Ubicación

- **Habilitar Ubicación**: Encienda/apague funciones de ubicación
- **Precisión**: Elija nivel de precisión GPS
- **Privacidad**: Controle el uso de datos de ubicación
- **Ubicación Predeterminada**: Establezca ubicación predeterminada

### Configuración de Sincronización

- **Auto-sincronización**: Sincronización automática de datos
- **Intervalo de Sincronización**: Con qué frecuencia sincronizar datos
- **Modo Sin Conexión**: Trabajar sin internet
- **Uso de Datos**: Controle el consumo de datos

---

## Solución de Problemas

### Problemas Comunes

#### No Puedo Conectarme al Servidor

**Síntomas**: Tiempo de conexión agotado, autenticación fallida

**Soluciones**:
1. Verifique la conexión a internet
2. Confirme que la URL del servidor es correcta
3. Verifique que el servidor esté funcionando
4. Revise la configuración del firewall
5. Pruebe un método de autenticación diferente

#### Los Tickets No Se Cargan

**Síntomas**: Lista de tickets vacía, errores de carga

**Soluciones**:
1. Deslice para actualizar
2. Revise que los filtros no sean demasiado restrictivos
3. Verifique los permisos
4. Borre caché y recargue
5. Revise el estado del servidor

#### El Asistente de IA No Funciona

**Síntomas**: Sin respuestas de IA, errores

**Soluciones**:
1. Verifique la conexión a internet
2. Confirme que el servicio de IA esté habilitado
3. Revise la configuración de la clave API
4. Pruebe consultas más simples
5. Contacte al administrador

#### La Ubicación No Funciona

**Síntomas**: No puedo obtener ubicación, ubicación incorrecta

**Soluciones**:
1. Habilite los servicios de ubicación
2. Conceda permiso de ubicación
3. Revise que el GPS esté funcionando
4. Pruebe la entrada manual de dirección
5. Reinicie la aplicación

### Obtener Ayuda

1. **Revise Documentación**: Esta guía y documentación en línea
2. **Foro de la Comunidad**: Pregunte a otros usuarios
3. **GitHub Issues**: Reporte errores
4. **Contacte Soporte**: Para usuarios empresariales

### Consejos de Rendimiento

- **Cierre Aplicaciones No Usadas**: Libere memoria
- **Borre Caché**: Borre regularmente el caché de la aplicación
- **Actualice Aplicación**: Mantenga la aplicación actualizada
- **Conexión Estable**: Use internet estable
- **Sincronización Regular**: Mantenga datos sincronizados

---

## Funciones Avanzadas

### Atajos de Teclado

- **Ctrl/Cmd + K**: Abrir búsqueda
- **Ctrl/Cmd + N**: Nuevo ticket
- **Ctrl/Cmd + R**: Actualizar
- **Ctrl/Cmd + ,**: Abrir configuración
- **Esc**: Cerrar diálogos

### Operaciones Masivas

1. **Seleccionar Múltiples**: Mantenga Ctrl/Cmd y haga clic
2. **Clic Derecho**: Menú contextual
3. **Acciones Masivas**: Actualizar estado, asignar, eliminar

### Exportar/Importar

- **Exportar Tickets**: Formatos CSV, PDF
- **Importar Datos**: Creación masiva de tickets
- **Respaldo**: Guarde datos de la aplicación
- **Restaurar**: Importe datos de respaldo

---

**Hecho con ❤️ por el Equipo del Cliente GLPI**