#!/bin/bash

# Ścieżki
notes_dir="$HOME/.nottie"
today_file="$notes_dir/$(date +'%Y-%m-%d').md"
counter_file="$notes_dir/.task_counter"

source functions/add_timestamp.sh 
source functions/create_today_file.sh
source functions/help.sh
source functions/mark_task_done.sh
source functions/search_all_notes.sh
source functions/search_last_week_notes.sh
source functions/search_uncomplited_tasks.sh
source functions/task_number.sh

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

