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
