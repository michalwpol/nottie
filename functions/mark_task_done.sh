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
