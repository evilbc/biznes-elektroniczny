#!/bin/sh



echo 'Czyszczenie bazy danych'

# Czyścimy bazę danych do stanu z dumpa, alternatywnie można użyć post-install.sql w tym samym katalogu
# Różnica między tymi plikami jest taka, że post-install.sql usuwa dane początkowe i czasem coś dodaje
# Ten drugi przywraca stan z momentu usuwania i został wygenerowany automatycznie, do ręcznej edycji post-install.sql, ale ten drugi do generowania z użyciem mysqldump
# W przypadku tego drugiego tabele w bazie danych są usuwane i tworzone ponownie, dzięki temu id zawsze może zacząć się od 1, w przypadku usunięcia danych id zacznie się od następnej wartości tak jakby te rzeczy dalej były w bazie

SQL_SCRIPT_FILE="/var/sql/post-install.sql"


if [ "$BIZ_DB_USE_DUMP" -eq "1" ] ; then
	echo 'Wykorzystywanie dumpa bazy danych'
	SQL_SCRIPT_FILE="/var/sql/prestashop_dump.sql"
else
	echo 'Wykorzystywanie skryptu inicjalizującego bazę'
fi

mysql -u$DB_USER -p$DB_PASSWD -h $DB_SERVER $DB_NAME < $SQL_SCRIPT_FILE

if [ "$BIZ_DB_USE_DUMP" -eq "1" ] ; then
	echo 'Naprawa danych związanych z hostem w bazie danych'
	envsubst '$PS_DOMAIN' < /var/sql/sql-hostname-update.sql.tmpl > /var/sql/sql-hostname-update.sql
	# Po substytucji zmiennych środowiskowych wykonujemy to na serwerze
	mysql -u$DB_USER -p$DB_PASSWD -h $DB_SERVER $DB_NAME < /var/sql/sql-hostname-update.sql
	# Odtworzenie zdjęć
	unzip -q -o -u /tmp/img.zip -d /var/www/html/
fi

echo 'Czyszczenie bazy zakończone'


echo "Generowanie certyfikatu dla domeny $PS_DOMAIN"

mkdir /etc/apache2/certificates
cd /etc/apache2/certificates

openssl req -new -newkey rsa:4096 -nodes \
    -keyout prestashop.key -out prestashop.csr \
    -subj "/CN=$PS_DOMAIN"

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/CN=$PS_DOMAIN" \
    -keyout prestashop.key  -out prestashop.cert

rm prestashop.csr

echo 'Włączenie modułu TLS'

a2enmod ssl

echo 'Konfigurowanie TLS'

echo "Administrator serwera to $ADMIN_MAIL"

envsubst '$PS_DOMAIN,$ADMIN_MAIL' < /var/conf/site-config.tmpl.conf > /etc/apache2/sites-available/000-default.conf # Podmienia dane z pliku na zmienne środowiskowe, przerzuca je do konfiguracji danej strony

echo 'Skonfigurowano TLS'

echo 'Skrypt po instalacji został wykonany'
