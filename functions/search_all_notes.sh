# Funkcja przeszukiwania notatek po słowach kluczowych we wszystkich plikach

search_all_notes() {
    local keywords=("$@")
    if [[ ${#keywords[@]} -eq 0 ]]; then
        grep -hrvE "^(- \[ \] |- \[x\] |#)" "$notes_dir"/*.md
    else
        local pattern
        pattern=$(printf "|%s" "${keywords[@]}" | cut -c 2-)
        grep -Ehrv "^(- \[ \] |- \[x\] |#)" "$notes_dir"/*.md | grep -Ei "($pattern)"
    fi
}
