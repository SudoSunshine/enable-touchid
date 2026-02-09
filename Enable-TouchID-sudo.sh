#!/bin/bash

################################################################################
# Script Name:  Enable Touch ID for sudo in Terminal
# Description:  Enables Touch ID authentication for sudo commands by creating
#               and configuring /etc/pam.d/sudo_local from Apple's template.
#               This configuration survives macOS updates.
# Author:       Sunshine (SudoSunshine)
# GitHub:       https://github.com/SudoSunshine
# Created:      2026-02-09
# Version:      1.0
################################################################################

###
### VARIABLES
###

PAM_DIR="/etc/pam.d"
TEMPLATE_FILE="${PAM_DIR}/sudo_local.template"
TARGET_FILE="${PAM_DIR}/sudo_local"

###
### FUNCTION 1: Check if template exists
###

check_template() {
    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        echo "Error: Template file not found at $TEMPLATE_FILE"
        exit 1
    fi
}

###
### FUNCTION 2: Create sudo_local file from template
###

create_sudo_local() {
    if [[ ! -f "$TARGET_FILE" ]]; then
        echo "Creating $TARGET_FILE from template..."
        cp "$TEMPLATE_FILE" "$TARGET_FILE"
    else
        echo "$TARGET_FILE already exists, checking configuration..."
    fi
}

###
### FUNCTION 3: Check if Touch ID is already enabled
###

check_if_enabled() {
    if grep -q "^auth[[:space:]]*sufficient[[:space:]]*pam_tid.so" "$TARGET_FILE"; then
        echo "Touch ID already enabled in sudo_local"
        exit 0
    fi
}

###
### FUNCTION 4: Enable Touch ID by uncommenting the auth line
###

enable_touch_id() {
    echo "Enabling Touch ID for sudo..."
    sed -i '' 's/^#[[:space:]]*\(auth[[:space:]]*sufficient[[:space:]]*pam_tid\.so\)/\1/' "$TARGET_FILE"
}

###
### FUNCTION 5: Verify the configuration was successful
###

verify_configuration() {
    if grep -q "^auth[[:space:]]*sufficient[[:space:]]*pam_tid.so" "$TARGET_FILE"; then
        echo "Successfully enabled Touch ID for sudo"
        exit 0
    else
        echo "Error: Failed to enable Touch ID"
        exit 1
    fi
}

###
### MAIN EXECUTION
###

echo "=========================================="
echo "Touch ID for sudo - Configuration Script"
echo "=========================================="

check_template
create_sudo_local
check_if_enabled
enable_touch_id
verify_configuration
