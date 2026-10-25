#!/data/data/com.termux/files/usr/bin/bash

# Color codes for visual feedback
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Termux ble.sh Fixer ===${NC}"
echo "Applying patches for empty \$USER and broken 'C' locale warning..."

# 1. Fix the $USER is empty issue in ~/.bashrc
BASHRC="$HOME/.bashrc"
USER_FIX='[[ ${USER-} ]] || export USER=$(id -un)'

if [ ! -f "$BASHRC" ]; then
    touch "$BASHRC"
    echo -e "${GREEN}[+] Created .bashrc${NC}"
fi

if grep -Fq 'export USER=$(id -un)' "$BASHRC" || { grep -Fq 'USER=' "$BASHRC" && grep -Fq 'id -un' "$BASHRC"; }; then
    echo -e "${GREEN}[+] USER configuration is already present in .bashrc${NC}"
else
    # Find the line where ble.sh is sourced
    BLE_LINE=$(grep -n 'blesh/ble.sh' "$BASHRC" | cut -d: -f1 | head -n 1)
    
    if [ -n "$BLE_LINE" ]; then
        # Insert the USER_FIX right before the line where ble.sh is sourced
        sed -i "${BLE_LINE}i ${USER_FIX}" "$BASHRC"
        echo -e "${GREEN}[+] Inserted USER fix before ble.sh sourcing in .bashrc${NC}"
    else
        # If ble.sh sourcing line was not found, just append to the end of .bashrc
        echo -e "\n${USER_FIX}" >> "$BASHRC"
        echo -e "${GREEN}[+] Appended USER fix to the end of .bashrc${NC}"
    fi
fi

# 2. Fix the broken locale 'C' warning in ~/.blerc
BLERC="$HOME/.blerc"
read -r -d '' LOCALE_FIX << 'EOF'
# Suppress broken locale warnings in Termux safely
function ble/util/notify-broken-locale {
  return 0
}
EOF

if [ ! -f "$BLERC" ]; then
    echo "$LOCALE_FIX" > "$BLERC"
    echo -e "${GREEN}[+] Created .blerc and added locale warning bypass${NC}"
else
    if grep -Fq 'ble/util/notify-broken-locale' "$BLERC"; then
        echo -e "${GREEN}[+] Locale bypass is already present in .blerc${NC}"
    else
        echo -e "\n$LOCALE_FIX" >> "$BLERC"
        echo -e "${GREEN}[+] Appended locale bypass to .blerc${NC}"
    fi
fi

echo -e "\n${GREEN}[✔] ble.sh fix applied successfully!${NC}"
echo -e "Please run: ${BLUE}source ~/.bashrc${NC} or restart Termux to apply changes."
