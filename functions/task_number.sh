# Funkcja generująca unikalny numer zadania

get_next_task_number() {
    if [[ ! -f "$counter_file" ]]; then
        echo 1 > "$counter_file"
    fi
    task_number=$(<"$counter_file")
    echo $((task_number + 1)) > "$counter_file"
    echo "$task_number"
}
