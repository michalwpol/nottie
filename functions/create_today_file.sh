# Funkcja tworzenia pliku, jeśli nie istnieje, z wbudowanym szablonem

create_today_file_if_missing() {
    if [[ ! -f "$today_file" ]]; then
        # Wbudowany szablon
        cat <<EOL > "$today_file"
# Notatki z dnia $(date +'%Y-%m-%d') $(date +'%A')


EOL
        echo "Utworzono nowy plik notatek na dziś: $today_file"
    fi
}
