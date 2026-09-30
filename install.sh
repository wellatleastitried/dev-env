#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PACKAGE_MANAGER=""
FAILED_PACKAGES=()
HAS_YAY=false

teach_em() {
    echo -e "${YELLOW}No argument provided, you need to either pass:${NC}"
    echo -e "${YELLOW}  - 'user' to install the project for non-owners of the repo that want my configs${NC}"
    echo -e "${YELLOW}      This option is for people that want to use my configs and be along for the ride${NC}"
    echo -e "${RED}  - 'owner' to install the project for owners of the repo${NC}"
    echo -e "${RED}      This option is for me, you can run it if you want but the dev-env script will yell at you during the update portion of the script${NC}"
    exit 1
}

detect_shell() {
    echo "Detecting shell..."
    if [ -n "$BASH_VERSINFO" ]; then
        shell="bash"
    elif [ -n "$ZSH_VERSION" ]; then
        shell="zsh"
    else
        echo "Unsupported shell. You need either bash or zsh for this."
        exit 1
    fi
    echo "Detected shell: $shell"
}

detect_package_manager() {
    echo "Detecting package manager..."
    if command -v pacman &>/dev/null; then
        PACKAGE_MANAGER="pacman"
        echo "Detected package manager: pacman (Arch Linux)"
        if command -v yay &>/dev/null; then
            HAS_YAY=true
            echo "Detected AUR helper: yay"
        fi
    elif command -v dnf &>/dev/null; then
        PACKAGE_MANAGER="dnf"
        echo "Detected package manager: dnf (Fedora)"
    elif command -v apt-get &>/dev/null; then
        PACKAGE_MANAGER="apt-get"
        echo "Detected package manager: apt-get (Debian/Ubuntu)"
    elif command -v xbps-install &>/dev/null; then
        PACKAGE_MANAGER="xbps"
        echo "Detected package manager: xbps (Void Linux)"
    else
        echo -e "${RED}No supported package manager found.${NC}"
        echo "Supported: pacman (Arch), dnf (Fedora), apt-get (Debian/Ubuntu), xbps (Void Linux)"
        exit 1
    fi
}

update_existing_packages() {
    echo "Updating existing packages..."
    case "$PACKAGE_MANAGER" in
        pacman)
            sudo pacman -Syu
            ;;
        dnf)
            sudo dnf upgrade -y
            ;;
        apt-get)
            sudo apt-get update
            sudo apt-get upgrade -y
            ;;
        xbps)
            sudo xbps-install -u xbps
            sudo xbps-install -Su
            ;;
    esac
}

install_package() {
    local package="$1"
    case "$PACKAGE_MANAGER" in
        pacman)
            if yes | sudo pacman -S "$package" &>/dev/null; then
                return 0
            elif [ "$HAS_YAY" = true ]; then
                echo -n "  → Trying AUR with yay... "
                yay -S "$package" --noconfirm &>/dev/null
                return $?
            fi
            return 1
            ;;
        dnf)
            sudo dnf install -y "$package" &>/dev/null
            return $?
            ;;
        apt-get)
            sudo apt-get install -y "$package" &>/dev/null
            return $?
            ;;
        xbps)
            sudo xbps-install -y "$package" &>/dev/null
            return $?
            ;;
    esac
}

install_system_packages() {
    local package_file="$PATH_DEV_ENV/package_list.txt"

    if [ ! -f "$package_file" ]; then
        echo -e "${RED}Package list file not found at $package_file${NC}"
        exit 1
    fi

    echo "Updating system packages..."
    update_existing_packages

    echo "Installing packages from package_list.txt..."
    local total_packages=0
    local installed_count=0

    while IFS= read -r package; do
        [ -z "$package" ] && continue
        total_packages=$((total_packages + 1))

        echo -n "Installing $package... "
        if install_package "$package"; then
            echo -e "${GREEN}done${NC}"
            installed_count=$((installed_count + 1))
        else
            echo -e "${RED}failed${NC}"
            FAILED_PACKAGES+=("$package")
        fi
    done < "$package_file"

    echo ""
    echo "Package installation summary: $installed_count/$total_packages installed successfully"
    if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
        echo -e "${YELLOW}Warning: ${#FAILED_PACKAGES[@]} package(s) failed to install:${NC}"
        for failed_pkg in "${FAILED_PACKAGES[@]}"; do
            echo -e "  ${RED}✗${NC} $failed_pkg"
        done
    fi
}

set_access() {
    if [ "$1" != "user" ] && [ "$1" != "owner" ]; then
        teach_em
    fi
    echo "Saving access permissions: $1"
    echo "export PERMS_DEV_ENV=\"$1\"" >> "$HOME/.$shell"rc
}

set_perms() {
    echo "Setting script permissions..."
    chmod +x "$PATH_DEV_ENV/scripts/"*
}

ensure_repo_staged() {
    if ! grep -q "PATH_DEV_ENV" "$HOME/.$shell"rc; then
        echo "Staging repository path..."
        DEV_ENV_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        echo "export PATH_DEV_ENV=\"$DEV_ENV_PATH\"" >> "$HOME/.$shell"rc
        echo "export PATH=\$PATH:$DEV_ENV_PATH" >> "$HOME/.$shell"rc
    fi
}

install_xnote() {
    echo "Installing xnote from GitHub..."
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    if git clone --depth 1 https://github.com/wellatleastitried/xnote.git; then
        cd xnote
        if sudo install -m 755 ./xnote /usr/local/bin/xnote; then
            echo -e "${GREEN}xnote installed successfully${NC}"
        else
            echo -e "${RED}Failed to install xnote${NC}"
            FAILED_PACKAGES+=("xnote")
        fi
    else
        echo -e "${RED}Failed to clone xnote repository${NC}"
        FAILED_PACKAGES+=("xnote")
    fi

    cd "$PATH_DEV_ENV"
    rm -rf "$temp_dir"
}

install_custom_tools() {
    echo "Installing custom tools..."

    if ! command -v xnote &>/dev/null; then
        install_xnote
    else
        echo "xnote already installed"
    fi

    if ! command -v restart-dns &>/dev/null; then
        echo "Installing restart-dns..."
        if sudo install -m 755 "$PATH_DEV_ENV/scripts/restart-dns" /usr/local/bin/restart-dns; then
            echo -e "${GREEN}restart-dns installed successfully${NC}"
        else
            echo -e "${RED}Failed to install restart-dns${NC}"
            FAILED_PACKAGES+=("restart-dns")
        fi
    else
        echo "restart-dns already installed"
    fi

    if ! grep -q "alias cat=bat" "$HOME/.$shell"rc; then
        echo "Adding cat alias..."
        echo "alias cat=bat" >> "$HOME/.$shell"rc
    fi
}

survived_questionnaire() {
    echo -e "${YELLOW}Do you have a second nvme drive that has been added to your btrfs filesystem? (y/n)${NC}"
    read -r response
    [[ "$response" == "y" ]] || return 1

    echo -e "${YELLOW}Do you use limine as your bootloader? (y/n)${NC}"
    read -r bootloader_response
    [[ "$bootloader_response" == "y" ]] || return 1

    echo -e "${YELLOW}Do you want to implement a custom kernel hook to automatically decrypt and mount the drive on boot? (y/n)${NC}"
    read -r hook_response
    [[ "$hook_response" == "y" ]] || return 1

    return 0
}

implement_custom_kernel_hook() {
    if survived_questionnaire; then
        echo "Implementing custom kernel hook..."
        sudo cp "$PATH_DEV_ENV/config/initcpio/hooks/cryptdrive2" /etc/initcpio/hooks/
        sudo cp "$PATH_DEV_ENV/config/initcpio/install/cryptdrive2" /etc/initcpio/install/

        echo -e "${YELLOW}Do you use omarchy as your Arch Linux installation base? (y/n)${NC}"
        read -r omarchy_response

        if [[ "$omarchy_response" == "y" ]]; then
            echo "Applying new hook to omarchy mkinitcpio config..."
            sudo sed -i 's/encrypt/encrypt cryptdrive2/' /etc/mkinitcpio.conf.d/omarchy_hooks.conf
            echo "Rebuilding initramfs with limine-mkinitcpio..."
            sudo limine-mkinitcpio
            echo -e "${GREEN}Custom kernel hook added!${NC}"
        else
            echo "Applying new hook to mkinitcpio config..."
            if sudo cat /etc/mkinitcpio.conf | grep -iE '^HOOKS=' | grep -q 'systemd'; then
                echo "Current hooks are systemd based - the custom hook is untested with systemd setups."
                echo "If you would like to proceed anyway, please type 'yes' to confirm."
                read -r confirm_systemd
                if [[ "$confirm_systemd" != "yes" ]]; then
                    echo -e "${RED}Aborting custom kernel hook implementation.${NC}"
                    return
                fi
            fi
            sudo sed -i 's/encrypt/encrypt cryptdrive2/' /etc/mkinitcpio.conf
            echo "Rebuilding initramfs..."
            sudo mkinitcpio -P
            echo -e "${GREEN}Custom kernel hook added!${NC}"
        fi
    else
        echo "Skipping custom kernel hook implementation."
    fi
}

print_final_summary() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo "Installation complete!"
    echo -e "${GREEN}========================================${NC}"

    if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
        echo -e "${RED}⚠️  WARNING: Some packages failed to install:${NC}"
        for failed_pkg in "${FAILED_PACKAGES[@]}"; do
            echo -e "  ${RED}✗${NC} $failed_pkg"
        done
        echo ""
        echo -e "${YELLOW}You may want to install these manually later.${NC}"
    else
        echo -e "${GREEN}All packages installed successfully!${NC}"
    fi

    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Reload your shell: source \$HOME/.$shell\"rc\""
    echo "  2. Configure your dev environment: dev-env edit"
    echo "  3. Update all configs: dev-env update"
}

main() {
    if [ -z "$1" ]; then
        teach_em
    fi

    detect_shell
    detect_package_manager
    set_access "$1"
    set_perms
    ensure_repo_staged
    install_system_packages
    install_custom_tools
    implement_custom_kernel_hook
    print_final_summary

    echo ""
    echo -e "${RED}NOTICE FOR REPOSITORY OWNER${NC}"
    echo "When modifying your configs, edit them in this repo's config folder using 'dev-env edit'."
    echo "This makes deploying and saving configurations simpler."
}

main "$@"
