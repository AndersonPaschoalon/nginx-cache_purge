#!/bin/bash
set -e

VERSION="1.0.0"

display_help() {
    cat <<EOF
apt-install-list.sh - Install multiple apt packages from a text file

Usage:
  $(basename "$0") [OPTIONS] <file.txt>

Options:
  --help            Show this help message and exit.
  --version         Show script version and exit.
  --file FILE       Path to the text file containing package names (one per line).
  --assume-yes      Automatically answer 'yes' to apt prompts.

File format:
  One package name per line. Optionally specify version:
    package
    package=version

Example:
  $(basename "$0") --file apt.txt
  $(basename "$0") --file apt.txt --assume-yes
EOF
    exit 0
}

display_version() {
    echo "$(basename "$0") version $VERSION"
    exit 0
}

install_packages_from_file() {
    local file="$1"
    local assume_yes="$2"

    if [ ! -f "$file" ]; then
        echo "❌ File not found: $file"
        exit 1
    fi

    echo "🔄 Updating package lists..."
    if [ "$assume_yes" = true ]; then
        sudo apt update -y
    else
        sudo apt update
    fi

    echo "📦 Installing packages from $file..."
    while IFS= read -r line || [ -n "$line" ]; do
        # Remove comments and trim whitespace
        pkg=$(echo "$line" | sed 's/#.*//' | xargs)
        [ -z "$pkg" ] && continue

        echo "➡ Installing: $pkg"
        if [ "$assume_yes" = true ]; then
            sudo apt install -y "$pkg"
        else
            sudo apt install "$pkg"
        fi
    done < "$file"

    echo "✅ All packages processed."
}

main_procedure() {
    local file="$1"
    local assume_yes="$2"

    install_packages_from_file "$file" "$assume_yes"
}

main() {
    local file=""
    local assume_yes=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help)
                display_help
                ;;
            --version)
                display_version
                ;;
            --file)
                shift
                file="$1"
                ;;
            --assume-yes)
                assume_yes=true
                ;;
            *)
                echo "❌ Unknown option: $1"
                echo "Use --help to see usage."
                exit 1
                ;;
        esac
        shift
    done

    if [ -z "$file" ]; then
        echo "❌ No file specified."
        display_help
    fi

    main_procedure "$file" "$assume_yes"
}

main "$@"



