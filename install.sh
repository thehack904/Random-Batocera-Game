#!/bin/bash
#
# Random Batocera Game Selector - Installer
# Version: 2.0
# This script automates the installation process
#

VERSION="2.0"
SCRIPT_NAME="random_game.sh"
INSTALL_DIR="/userdata/system"
CUSTOM_SH="${INSTALL_DIR}/custom.sh"
SCRIPT_PATH="${INSTALL_DIR}/${SCRIPT_NAME}"
SCRIPT_URL="https://raw.githubusercontent.com/thehack904/Random-Batocera-Game/main/random_game.sh"
# Legacy v1.0 path
OLD_V1_SCRIPT_PATH="${INSTALL_DIR}/random_start.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║   Random Batocera Game Selector - Installer v${VERSION}        ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running on Batocera
check_batocera() {
    if [ ! -d "/userdata/system" ]; then
        print_warning "Not running on Batocera system or /userdata/system not found"
        print_info "This installer is designed for Batocera systems"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check for legacy v1.0 installation
check_legacy_v1() {
    local found_legacy=0
    
    # Check for old v1.0 script file
    if [ -f "$OLD_V1_SCRIPT_PATH" ]; then
        print_warning "Found legacy v1.0 installation at: $OLD_V1_SCRIPT_PATH"
        found_legacy=1
    fi
    
    # Check for old references in custom.sh
    if [ -f "$CUSTOM_SH" ] && grep -q "$OLD_V1_SCRIPT_PATH" "$CUSTOM_SH"; then
        print_warning "Found legacy v1.0 reference in custom.sh"
        found_legacy=1
    fi
    
    return $found_legacy
}

# Clean up legacy v1.0 installation
cleanup_legacy_v1() {
    print_info "Cleaning up legacy v1.0 installation..."
    
    # Remove old script file
    if [ -f "$OLD_V1_SCRIPT_PATH" ]; then
        # Backup the old script first
        BACKUP_PATH="${OLD_V1_SCRIPT_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up legacy script to ${BACKUP_PATH}"
        cp "$OLD_V1_SCRIPT_PATH" "$BACKUP_PATH"
        
        # Remove the old script
        rm "$OLD_V1_SCRIPT_PATH"
        print_success "Removed legacy script: $OLD_V1_SCRIPT_PATH"
    fi
    
    # Remove old references from custom.sh
    if [ -f "$CUSTOM_SH" ]; then
        if grep -q "$OLD_V1_SCRIPT_PATH" "$CUSTOM_SH"; then
            print_info "Removing legacy references from custom.sh"
            sed -i "\|$OLD_V1_SCRIPT_PATH|d" "$CUSTOM_SH"
            print_success "Cleaned up custom.sh"
        fi
    fi
    
    print_success "Legacy v1.0 cleanup complete"
}

# Detect installed version
detect_version() {
    # First check for legacy v1.0 at old path
    if [ -f "$OLD_V1_SCRIPT_PATH" ] && [ ! -f "$SCRIPT_PATH" ]; then
        # Old v1.0 script exists at legacy path
        if grep -q "/userdata/roms/mame/\*\.zip" "$OLD_V1_SCRIPT_PATH" 2>/dev/null; then
            echo "1.0"
            return
        fi
    fi
    
    if [ ! -f "$SCRIPT_PATH" ]; then
        echo "none"
        return
    fi
    
    # Try to get version from --version flag (v2.0+)
    if [ -x "$SCRIPT_PATH" ]; then
        local version_output=$("$SCRIPT_PATH" --version 2>/dev/null)
        if [ $? -eq 0 ] && [[ "$version_output" =~ v?([0-9]+\.[0-9]+) ]]; then
            echo "${BASH_REMATCH[1]}"
            return
        fi
    fi
    
    # Check if it has version header comment (v2.0+)
    if grep -q "^# Version:" "$SCRIPT_PATH" 2>/dev/null; then
        local ver=$(grep "^# Version:" "$SCRIPT_PATH" | head -1 | awk '{print $3}')
        if [ -n "$ver" ]; then
            echo "$ver"
            return
        fi
    fi
    
    # Check script characteristics to identify v1.0
    # v1.0 characteristics: short script, uses backticks, hardcoded mame path
    if grep -q "/userdata/roms/mame/\*\.zip" "$SCRIPT_PATH" 2>/dev/null; then
        if ! grep -q "# Version:" "$SCRIPT_PATH" 2>/dev/null; then
            echo "1.0"
            return
        fi
    fi
    
    # Unknown version
    echo "unknown"
}

# Show upgrade information
show_upgrade_info() {
    local old_version="$1"
    
    echo ""
    print_info "═══════════════════════════════════════════════════════════"
    print_warning "UPGRADE DETECTED: v${old_version} → v${VERSION}"
    print_info "═══════════════════════════════════════════════════════════"
    echo ""
    
    if [ "$old_version" = "1.0" ]; then
        echo "  What's new in v2.0:"
        echo "  ✓ Support for ALL Batocera emulators (not just MAME)"
        echo "  ✓ 112 file extensions across all platforms"
        echo "  ✓ Nintendo, Sega, Sony, Atari, and many more systems"
        echo "  ✓ Improved error handling and validation"
        echo "  ✓ Modern bash syntax and optimizations"
        echo "  ✓ Version tracking with --version flag"
        echo ""
        print_info "Your random game selection will now include your ENTIRE collection!"
        echo ""
    else
        echo "  Upgrading from version ${old_version}"
        echo ""
    fi
    
    read -p "Continue with upgrade? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Upgrade cancelled"
        exit 0
    fi
}

# Backup existing installation
backup_existing() {
    if [ -f "$SCRIPT_PATH" ]; then
        BACKUP_PATH="${SCRIPT_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing installation to ${BACKUP_PATH}"
        cp "$SCRIPT_PATH" "$BACKUP_PATH"
        print_success "Backup created: $(basename $BACKUP_PATH)"
    fi
}

# Install the script
install_script() {
    print_info "Installing ${SCRIPT_NAME} to ${INSTALL_DIR}..."
    
    # Check if we're in the git repository
    if [ -f "./random_game.sh" ]; then
        print_info "Installing from local repository"
        cp "./random_game.sh" "$SCRIPT_PATH"
    else
        print_info "Downloading from GitHub..."
        if command -v curl &> /dev/null; then
            curl -fsSL "$SCRIPT_URL" -o "$SCRIPT_PATH"
        elif command -v wget &> /dev/null; then
            wget -q "$SCRIPT_URL" -O "$SCRIPT_PATH"
        else
            print_error "Neither curl nor wget found. Cannot download script."
            exit 1
        fi
    fi
    
    # Make executable
    chmod +x "$SCRIPT_PATH"
    
    if [ -f "$SCRIPT_PATH" ]; then
        print_success "Script installed successfully"
    else
        print_error "Installation failed"
        exit 1
    fi
}

# Configure custom.sh
configure_custom_sh() {
    print_info "Configuring custom.sh integration..."
    
    # Create custom.sh if it doesn't exist
    if [ ! -f "$CUSTOM_SH" ]; then
        print_info "Creating ${CUSTOM_SH}"
        cat > "$CUSTOM_SH" << 'EOF'
#!/bin/bash
# Batocera custom startup script

EOF
        chmod +x "$CUSTOM_SH"
    fi
    
    # Check if already configured
    if grep -q "$SCRIPT_PATH" "$CUSTOM_SH"; then
        print_warning "Script already configured in custom.sh"
        read -p "Reconfigure anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
        # Remove old entries
        sed -i "\|$SCRIPT_PATH|d" "$CUSTOM_SH"
    fi
    
    # Add to custom.sh
    echo "" >> "$CUSTOM_SH"
    echo "# Random Batocera Game Selector" >> "$CUSTOM_SH"
    echo "$SCRIPT_PATH" >> "$CUSTOM_SH"
    
    chmod +x "$CUSTOM_SH"
    print_success "custom.sh configured"
}

# Check boot game configuration
check_boot_game() {
    print_info "Checking boot game configuration..."
    
    BATOCERA_CONF="/userdata/system/batocera.conf"
    if [ -f "$BATOCERA_CONF" ]; then
        if grep -q "global.bootgame.cmd" "$BATOCERA_CONF"; then
            print_success "Boot game already configured"
        else
            print_warning "No boot game configured yet"
            print_info "You need to configure a game to start on boot first:"
            echo "  1. Select any game in EmulationStation"
            echo "  2. Press 'A' (or South button) for Game Options"
            echo "  3. Go to 'Advanced Game Options'"
            echo "  4. Enable 'Boot this game on startup'"
            echo ""
            print_info "After configuring, run the script to test:"
            echo "  ${SCRIPT_PATH}"
        fi
    else
        print_warning "batocera.conf not found"
    fi
}

# Test the installation
test_installation() {
    print_info "Testing installation..."
    
    if [ -x "$SCRIPT_PATH" ]; then
        VERSION_OUTPUT=$("$SCRIPT_PATH" --version 2>&1)
        if [ $? -eq 0 ]; then
            print_success "Installation test passed"
            print_info "Version: $VERSION_OUTPUT"
        else
            print_error "Script execution failed"
        fi
    else
        print_error "Script is not executable"
    fi
}

# Uninstall
uninstall() {
    print_header
    print_warning "This will remove Random Batocera Game Selector"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstall cancelled"
        exit 0
    fi
    
    # Remove from custom.sh
    if [ -f "$CUSTOM_SH" ]; then
        if grep -q "$SCRIPT_PATH" "$CUSTOM_SH"; then
            print_info "Removing from custom.sh"
            sed -i "\|$SCRIPT_PATH|d" "$CUSTOM_SH"
            sed -i '/# Random Batocera Game Selector/d' "$CUSTOM_SH"
            print_success "Removed from custom.sh"
        fi
        # Also check for legacy v1.0 references
        if grep -q "$OLD_V1_SCRIPT_PATH" "$CUSTOM_SH"; then
            print_info "Removing legacy v1.0 references from custom.sh"
            sed -i "\|$OLD_V1_SCRIPT_PATH|d" "$CUSTOM_SH"
            print_success "Removed legacy references from custom.sh"
        fi
    fi
    
    # Remove script
    if [ -f "$SCRIPT_PATH" ]; then
        print_info "Removing script"
        rm "$SCRIPT_PATH"
        print_success "Script removed"
    fi
    
    # Remove legacy v1.0 script if it exists
    if [ -f "$OLD_V1_SCRIPT_PATH" ]; then
        print_info "Removing legacy v1.0 script"
        rm "$OLD_V1_SCRIPT_PATH"
        print_success "Legacy script removed"
    fi
    
    print_success "Uninstall complete"
    exit 0
}

# Show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  install     Install Random Batocera Game Selector (default)"
    echo "  uninstall   Remove the installation"
    echo "  --help      Show this help message"
    echo ""
}

# Main installation process
main() {
    print_header
    
    # Parse arguments
    case "${1:-install}" in
        uninstall)
            uninstall
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        install|*)
            check_batocera
            
            # Check for and handle legacy v1.0 installation
            if check_legacy_v1; then
                print_info "Legacy v1.0 installation detected"
            fi
            
            # Detect current version
            CURRENT_VERSION=$(detect_version)
            
            if [ "$CURRENT_VERSION" != "none" ]; then
                # Show upgrade information
                show_upgrade_info "$CURRENT_VERSION"
            else
                print_info "No existing installation found - performing fresh install"
            fi
            
            # Clean up legacy v1.0 if found
            if check_legacy_v1; then
                cleanup_legacy_v1
            fi
            
            backup_existing
            install_script
            configure_custom_sh
            check_boot_game
            test_installation
            
            echo ""
            print_success "Installation complete!"
            echo ""
            print_info "Next steps:"
            echo "  1. Configure a game to boot on startup (if not already done)"
            echo "  2. Test the script: ${SCRIPT_PATH}"
            echo "  3. Reboot to see a random game selected!"
            echo ""
            print_info "To uninstall: $0 uninstall"
            ;;
    esac
}

# Run main
main "$@"
