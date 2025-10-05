#!/bin/bash

# GLPI Advanced Client - Setup Script
# This script helps set up the development environment

set -e

echo "🚀 GLPI Advanced Client - Setup Script"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
check_flutter() {
    if command -v flutter &> /dev/null; then
        print_success "Flutter is installed"
        flutter --version
    else
        print_error "Flutter is not installed. Please install Flutter first."
        echo "Visit: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
}

# Check Flutter doctor
check_flutter_doctor() {
    print_status "Checking Flutter environment..."
    if flutter doctor; then
        print_success "Flutter environment is healthy"
    else
        print_warning "Flutter doctor found issues. Please resolve them for best performance."
    fi
}

# Get dependencies
get_dependencies() {
    print_status "Getting dependencies..."
    if flutter pub get; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
        exit 1
    fi
}

# Generate code
generate_code() {
    print_status "Generating code..."
    if flutter pub run build_runner build --delete-conflicting-outputs; then
        print_success "Code generated successfully"
    else
        print_warning "Code generation failed, but project might still work"
    fi
}

# Create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    mkdir -p assets/images
    mkdir -p assets/icons
    mkdir -p assets/translations
    mkdir -p assets/config
    mkdir -p fonts
    print_success "Directories created"
}

# Create sample configuration file
create_sample_config() {
    print_status "Creating sample configuration..."
    cat > assets/config/sample_config.json << EOF
{
  "api_base_url": "https://your-glpi-server.com/apirest.php",
  "app_name": "GLPI Advanced Client",
  "version": "2.0.0",
  "ai_enabled": true,
  "location_enabled": true,
  "notifications_enabled": true,
  "auto_sync_enabled": true,
  "sync_interval_minutes": 5,
  "cache_timeout_minutes": 5,
  "max_retries": 3,
  "timeout_seconds": 30
}
EOF
    print_success "Sample configuration created"
}

# Create sample translation files
create_sample_translations() {
    print_status "Creating sample translation files..."
    
    # English
    cat > assets/translations/app_en.arb << EOF
{
  "@@locale": "en",
  "appTitle": "GLPI Advanced Client",
  "login": "Login",
  "logout": "Logout",
  "username": "Username",
  "password": "Password",
  "appToken": "App Token",
  "userToken": "User Token",
  "loginWithUserToken": "Login with User Token",
  "loginWithUsername": "Login with Username/Password",
  "forgotPassword": "Forgot Password?",
  "dashboard": "Dashboard",
  "tickets": "Tickets",
  "createTicket": "Create Ticket",
  "searchTickets": "Search Tickets...",
  "filter": "Filter",
  "status": "Status",
  "priority": "Priority",
  "category": "Category",
  "assignee": "Assignee",
  "date": "Date",
  "newTicket": "New Ticket",
  "openTickets": "Open Tickets",
  "closedTickets": "Closed Tickets",
  "allTickets": "All Tickets",
  "loading": "Loading...",
  "error": "Error",
  "success": "Success",
  "retry": "Retry",
  "cancel": "Cancel",
  "save": "Save",
  "delete": "Delete",
  "edit": "Edit",
  "view": "View",
  "close": "Close",
  "aiAssistant": "AI Assistant",
  "location": "Location",
  "settings": "Settings",
  "profile": "Profile",
  "help": "Help",
  "about": "About",
  "version": "Version",
  "unknownError": "An unknown error occurred",
  "networkError": "Network error",
  "authenticationError": "Authentication failed",
  "serverError": "Server error",
  "validationError": "Validation error"
}
EOF

    # Spanish
    cat > assets/translations/app_es.arb << EOF
{
  "@@locale": "es",
  "appTitle": "Cliente Avanzado GLPI",
  "login": "Iniciar Sesión",
  "logout": "Cerrar Sesión",
  "username": "Nombre de Usuario",
  "password": "Contraseña",
  "appToken": "Token de App",
  "userToken": "Token de Usuario",
  "loginWithUserToken": "Iniciar con Token de Usuario",
  "loginWithUsername": "Iniciar con Usuario/Contraseña",
  "forgotPassword": "¿Olvidó su contraseña?",
  "dashboard": "Panel de Control",
  "tickets": "Tickets",
  "createTicket": "Crear Ticket",
  "searchTickets": "Buscar Tickets...",
  "filter": "Filtrar",
  "status": "Estado",
  "priority": "Prioridad",
  "category": "Categoría",
  "assignee": "Asignado a",
  "date": "Fecha",
  "newTicket": "Nuevo Ticket",
  "openTickets": "Tickets Abiertos",
  "closedTickets": "Tickets Cerrados",
  "allTickets": "Todos los Tickets",
  "loading": "Cargando...",
  "error": "Error",
  "success": "Éxito",
  "retry": "Reintentar",
  "cancel": "Cancelar",
  "save": "Guardar",
  "delete": "Eliminar",
  "edit": "Editar",
  "view": "Ver",
  "close": "Cerrar",
  "aiAssistant": "Asistente de IA",
  "location": "Ubicación",
  "settings": "Configuración",
  "profile": "Perfil",
  "help": "Ayuda",
  "about": "Acerca de",
  "version": "Versión",
  "unknownError": "Ocurrió un error desconocido",
  "networkError": "Error de red",
  "authenticationError": "Falló la autenticación",
  "serverError": "Error del servidor",
  "validationError": "Error de validación"
}
EOF
    print_success "Sample translation files created"
}

# Run Flutter doctor
run_flutter_doctor() {
    print_status "Running Flutter doctor..."
    flutter doctor
}

# Main setup function
main() {
    echo
    check_flutter
    check_flutter_doctor
    get_dependencies
    generate_code
    create_directories
    create_sample_config
    create_sample_translations
    
    echo
    print_success "Setup complete! 🎉"
    echo
    echo "Next steps:"
    echo "1. Update the configuration in assets/config/sample_config.json"
    echo "2. Add your GLPI server URL and API keys"
    echo "3. Run 'flutter run' to start the application"
    echo
    echo "For development, you can use:"
    echo "  make run          # Run the app"
    echo "  make test         # Run tests"
    echo "  make lint         # Check code quality"
    echo "  make build        # Build the app"
    echo
}

# Run main function
main "$@"