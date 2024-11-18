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
