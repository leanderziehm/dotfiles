#!/usr/bin/env bash

# Options
options=("git" "vim" "htop" "curl")

# Selection state (0 = off, 1 = on)
selected=()
for _ in "${options[@]}"; do
    selected+=(0)
done

current=0

draw() {
    clear
    echo "Use ↑ ↓ to move"
    echo "Press ENTER to toggle"
    echo "Press ENTER on [ OK ] to confirm"
    echo

    # Draw options
    for i in "${!options[@]}"; do
        if [ "$i" -eq "$current" ]; then
            prefix="> "
        else
            prefix="  "
        fi

        if [ "${selected[$i]}" -eq 1 ]; then
            mark="[x]"
        else
            mark="[ ]"
        fi

        echo "${prefix}${mark} ${options[$i]}"
    done

    echo

    # Draw OK button
    if [ "$current" -eq "${#options[@]}" ]; then
        echo "> [ OK ]"
    else
        echo "  [ OK ]"
    fi
}

while true; do
    draw

    # Read key (Termux-safe)
    IFS= read -r -s -n1 key

    # Handle arrow keys
    if [[ $key == $'\x1b' ]]; then
        read -r -s -n2 key
        key=$'\x1b'"$key"
    fi

    case "$key" in
        $'\x1b[A') ((current--)) ;;   # Up
        $'\x1b[B') ((current++)) ;;   # Down

        "") # ENTER
            if [ "$current" -lt "${#options[@]}" ]; then
                # Toggle item
                if [ "${selected[$current]}" -eq 1 ]; then
                    selected[$current]=0
                else
                    selected[$current]=1
                fi
            else
                # OK selected → exit
                break
            fi
            ;;
    esac

    # Bounds check
    if [ "$current" -lt 0 ]; then
        current=0
    fi
    if [ "$current" -gt "${#options[@]}" ]; then
        current="${#options[@]}"
    fi
done

# Output result
clear
echo "Selected packages:"
echo

for i in "${!options[@]}"; do
    if [ "${selected[$i]}" -eq 1 ]; then
        echo "- ${options[$i]}"
    fi
done