#!/bin/bash

# Pfad zur TXT-Datei mit den E-Mail-Adressen
EMAIL_FILE="emails.txt"

# Ausgabe-CSV-Datei
OUTPUT_CSV="users.csv"

# Header für die CSV-Datei
echo "email;username;password" > "$OUTPUT_CSV"

# Funktion zum Generieren eines zufälligen Passworts
generate_password() {
    echo $(< /dev/urandom tr -dc A-Za-z0-9 | head -c18)
}

# Lese jede Zeile aus der TXT-Datei
while IFS= read -r email
do
    # Extrahiere Benutzernamen (Teil vor dem @-Zeichen)
    username=$(echo "$email" | cut -d'@' -f1)

    # Generiere ein zufälliges Passwort
    password=$(generate_password)

    # Anlegen des Benutzers über das vorhandene Node.js-Skript
    # Wir nehmen an, dass das Skript auf Fehlerüberprüfung und gültige Eingaben ausgelegt ist
    npm run create-user "$email" "$username" "$username" "$password"

    # Überprüfe, ob der Befehl erfolgreich war
    if [ $? -eq 0 ]; then
        # Füge die Daten zur CSV-Datei hinzu, wenn der Benutzer erfolgreich angelegt wurde
        echo "$email;$username;$password" >> "$OUTPUT_CSV"
    else
        echo "Fehler beim Anlegen des Benutzers: $email"
    fi
done < "$EMAIL_FILE"

echo "Fertig! Benutzer wurden angelegt und in $OUTPUT_CSV gespeichert."
