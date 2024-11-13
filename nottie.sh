#!/bin/bash

# Ścieżki
notes_dir="$HOME/.nottie"
today_file="$notes_dir/$(date +'%Y-%m-%d').md"
counter_file="$notes_dir/.task_counter"

# Funkcja pomocy
help() {
    echo "Użycie: ./skrypt.sh [opcje]"
    echo ""
    echo "Dostępne opcje:"
    echo "  add <treść>                - Dodaj nową notatkę z podaną treścią."
    echo "  todo <treść zadania>       - Dodaj nowe zadanie todo."
    echo "  todo done <numer zadania>  - Oznacz zadanie o podanym numerze jako wykonane."
    echo "  search all notes <słowa kluczowe> - Przeszukaj wszystkie notatki po podanych słowach kluczowych (maksymalnie 5)."
    echo "  search last notes <słowa kluczowe> - Przeszukaj notatki z ostatniego tygodnia po podanych słowach kluczowych (maksymalnie 5)."
    echo "  search undone              - Wyświetl listę wszystkich niezrobionych zadań."
    echo ""
    echo "Jeśli nie podano żadnych słów kluczowych, wyświetlane są wszystkie notatki lub wszystkie notatki z ostatniego tygodnia, pomijając zadania i nagłówki."
    echo ""
}

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

# Funkcja dodająca znacznik czasu
add_timestamp() {
    echo "$(date +'%H:%M:%S')"
}

# Funkcja generująca unikalny numer zadania
get_next_task_number() {
    if [[ ! -f "$counter_file" ]]; then
        echo 1 > "$counter_file"
    fi
    task_number=$(<"$counter_file")
    echo $((task_number + 1)) > "$counter_file"
    echo "$task_number"
}

# Funkcja przeszukiwania niezrobionych zadań i formatowania wyjścia
search_uncompleted_tasks() {
    echo -e "\nNiezrobione zadania:"
    grep -hr "^- \[ \] .* \`[0-9]\+\`" "$notes_dir"/*.md | sort -t '`' -k2,2n | while read -r line; do
        # Wyodrębnianie treści zadania, numeru i daty
        task_text=$(echo "$line" | sed -E "s/- \[ \] (.*) \`[0-9]+\` .*/\1/")
        task_number=$(echo "$line" | grep -o "\`[0-9]\+\`" | tr -d '`')
        task_date=$(echo "$line" | grep -o "[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}")

        # Wyświetlanie linii z podświetleniem numeru zadania i daty z wyrównaniem
        printf -- "- [ ] %-20s \e[32m\`%-3s\`\e[0m  \e[34m%-10s\e[0m\n" "$task_text" "$task_number" "$task_date"
    done
}



# Funkcja oznaczania zadania jako wykonane
mark_task_done() {
    local task_num=$1
    if grep -q "^- \[ \] .* \`$task_num\`" "$notes_dir"/*.md; then
        sed -i "s/^- \[ \] \(.*\`$task_num\`\)/- [x] \1/" "$notes_dir"/*.md
        echo "Zadanie o numerze $task_num zostało oznaczone jako wykonane."
    else
        echo "Nie znaleziono zadania o numerze $task_num."
    fi
}

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

# Sprawdzanie argumentów skryptu
if [[ $# -eq 0 ]]; then
    help
elif [[ $1 == "add" ]]; then
    if [[ -z $2 ]]; then
        echo "Brak treści do dodania. Użyj: skrypt.sh add 'dowolna treść'"
        exit 1
    fi
    create_today_file_if_missing
    echo "- $2 \`$(add_timestamp)\`" >> "$today_file"
    echo "Dodano treść do pliku $today_file: $2"

elif [[ $1 == "todo" ]]; then
    if [[ $2 == "done" ]]; then
        if [[ -z $3 ]]; then
            echo "Brak numeru zadania. Użyj: skrypt.sh todo done <numer zadania>"
            exit 1
        fi
        mark_task_done "$3"
    elif [[ -z $2 ]]; then
        echo "Brak treści zadania. Użyj: skrypt.sh todo 'treść zadania'"
        exit 1
    else
        create_today_file_if_missing
        task_number=$(get_next_task_number)
        echo "- [ ] $2 \`$task_number\` \`$(add_timestamp)\`" >> "$today_file"
        echo "Dodano zadanie do pliku $today_file: [$task_number] $2"
    fi

elif [[ $1 == "search" ]]; then
    if [[ $2 == "all" && $3 == "notes" ]]; then
        shift 3
        search_all_notes "$@"
    elif [[ $2 == "last" && $3 == "notes" ]]; then
        shift 3
        search_last_week_notes "$@"
    elif [[ $2 == "undone" ]]; then
        search_uncompleted_tasks
    else
        echo "Nieprawidłowa komenda. Użyj 'search all notes <słowo_kluczowe...>', 'search last notes <słowo_kluczowe...>' lub 'search undone'."
    fi

else
    echo "Nieprawidłowa komenda. Użyj 'add', 'todo', 'search all notes', 'search last notes', 'search undone' lub 'todo done <numer zadania>'."
fi

