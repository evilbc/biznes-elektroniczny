FROM prestashop/prestashop:1.7.8

# zaczynamy od obrazu bazowego, będziemy dodawać kolejne rzeczy, które będą nadpisywać go

# Korzystamy z overlay2, więc możemy w ten sposób nadpisywać pliki, w /var/www/html/themes jest miejsce na motywy, do dalszej pracy

# W /tmp znajdziemy skrypty inicjalizujące
COPY tmp /tmp
COPY var /var

# Skrypty muszą być wykonywalne
# Robienie tego w jednym RUN powoduje, że nie tworzymy niepotrzebnych warstw w obrazie
RUN chmod +x /tmp/pre-install-scripts/pre-install.sh && chmod +x /tmp/post-install-scripts/post-install.sh && chmod +x /tmp/init-scripts/init.sh

RUN apt update # trzeba odświeżyć repozytoria

# gettext-base do envsubst, dos2unix do zmiany CRLF na LF, unzip do odtworzenia zdjęć produktów
RUN apt install -y gettext-base dos2unix unzip

# Poniżej kod wykona konwersję dla wszystkich plików w katalogach (typ pliku to zwykły plik) i każdy plik pójdzie do konwersji
RUN find /tmp/init-scripts /tmp/post-install-scripts /tmp/pre-install-scripts -type f | xargs dos2unix 

# Można w tych skryptach np. dodać scrapera czy zmianę ustawień, przez SQL czy zmiany w plikach
