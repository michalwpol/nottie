# Funkcja przeszukiwania notatek z ostatniego tygodnia

search_last_week_notes() {
    local keywords=("$@")
    local last_week_date
    last_week_date=$(date -d '7 days ago' +'%Y-%m-%d')

    if [[ ${#keywords[@]} -eq 0 ]]; then
        find "$notes_dir" -maxdepth 1 -name "*.md" -newermt "$last_week_date" -exec grep -hEv "^(- \[ \] |- \[x\] |#)" {} +
    else
        local pattern
        pattern=$(printf "|%s" "${keywords[@]}" | cut -c 2-)
        find "$notes_dir" -maxdepth 1 -name "*.md" -newermt "$last_week_date" -exec grep -Eh "^(- \[ \] |- \[x\] |#)" {} + | grep -Ei "($pattern)"
    fi
}
