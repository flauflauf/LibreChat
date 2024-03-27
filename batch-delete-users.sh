#!/bin/sh

# Pfad zur TXT-Datei mit den E-Mail-Adressen
EMAIL_FILE="user-management/emails.txt"

# Ausgabe-Log-Datei
OUTPUT_LOG="user-management/delete-users.log"

# Header für die Log-Datei
echo "Datum;E-Mail;Status" > "$OUTPUT_LOG"

# Lese jede Zeile aus der TXT-Datei
while IFS= read -r email
do
    # Lösche den Benutzer über das vorhandene Node.js-Skript
    # Wir nehmen an, dass das Skript auf Fehlerüberprüfung und gültige Eingaben ausgelegt ist
    # Automatische Bestätigung mit 'y'
    echo 'y' | npm run delete-user "$email"

    # Überprüfe, ob der Befehl erfolgreich war
    if [ $? -eq 0 ]; then
        # Logge den Erfolg, wenn der Benutzer erfolgreich gelöscht wurde
        echo "$(date +%Y-%m-%d);$email;Erfolgreich gelöscht" >> "$OUTPUT_LOG"
    else
        echo "$(date +%Y-%m-%d);$email;Fehler beim Löschen" >> "$OUTPUT_LOG"
    fi
done < "$EMAIL_FILE"

echo "Fertig! Benutzer wurden gelöscht und in $OUTPUT_LOG geloggt."