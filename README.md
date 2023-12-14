# biznes-elektroniczny
Projekt na biznes elektroniczny - sklep w Prestashop, oparty na sklepie https://sklep.keeza.pl/ (zescrapowane produkty)

Sklep obecnie generuje certyfikat automatycznie na 365 dni. Konfiguracja podstawowa w pliku shop/.env

## Przydatne polecenia

Zaczynamy w katalogu shop. 
Polecenia docker build i docker compose wykonujemy zawsze w tym katalogu. Reszta bez znaczenia.

### Uruchomienie sklepu
Sklep zostanie automatycznie zainstalowany i uruchomiony (jeżeli nie był zainstalowany wcześniej)

```bash
docker compose build && docker compose create && docker compose start
```

Alternatywnie można użyć innego polecenia, ale wtedy po naciśnięciu ctrl+c wszystko się wyłącza.
Natomiast można w ten sposób łatwo śledzić logi między różnymi kontenerami.
```bash
docker compose up
```

### Restart sklepu (bez bazy)

```bash
docker restart shop-prestashop-1
```

### Zbudowanie nowego obrazu kontenera sklepu

```bash
# latest to tag, ale można równie dobrze wpisać v1 albo 1, etc.
docker build -t niesytomichal/pg-weti-biznes-elektroniczny:latest .
```

Każdy może zbudować i mieć lokalny build. Do opcji push proszę o kontakt ze mną i wtedy dam uprawnienia tak aby robić push.

### Wyłączenie sklepu

```bash
docker compose down
```

### Usunięcie zainstalowanego sklepu (do ponownej instalacji), wymagane wyłączenie

```bash
docker volume rm shop_psdata
docker volume rm shop_dbdata
```

### Wejście do kontenera sklepu

```bash
docker exec -it shop-prestashop-1 /bin/bash
```

### Wejście do bazy danych sklepu

```bash
# -padmin oznacza hasło admin
docker exec -it shop-db-1 /bin/mysql -padmin presta
```

W konsoli bazy danych można również zobaczyć jakie są tabele za pomocą:

```sql
SHOW TABLES; 
```

### Zrobienie dumpa całej bazy

```bash
# Plik dump.sql można zamienić na inną lokalizację, dostaniemy ten plik lokalnie a nie w kontenerze
# Jeśli chce się zapisać również zdjęcia, należy zzipować katalog \\wsl$\docker-desktop-data\data\docker\volumes\shop_psdata\_data\img (lub /var/snap/docker/common/var-lib-docker/volumes/shop_psdata/_data/img na Linuxie) i plik zip umieścić w shop/tmp/
docker exec shop-db-1 /bin/mysqldump -padmin presta > dump.sql
```

### Zrobienie dumpa danej tabeli

```bash
# Plik dump.sql można zamienić na inną lokalizację, dostaniemy ten plik lokalnie a nie w kontenerze
# Zamień ps_table na rzeczywistą nazwę tabeli
docker exec shop-db-1 /bin/mysqldump -padmin presta ps_table > dump.sql
```

### Inicjalizacja produktów
Należy najpierw odpalić scrapera (scraper/scraper.py, można uruchomić np. w PyCharmie), żeby pobrały się zdjęcia produktów. Wymagane zależności są podane w requirements.txt (najlepiej w wirtualnym środowisku), jeśli katalog scraper otworzy się w PyCharmie, to powinien je automatycznie zainstalować. Następnie należy otworzyć product-init/ProductInit.sln w VisualStudio i uruchomić Initializer.cs

### Maile

Maile dostępne są z użyciem klienta w przeglądarce opartego o HTTP na tym samym hoście zainstalowana reszta, na porcie 1080.
Dla localhost będzie to http://localhost:1080
Maile należy dostosować pod względem wizualnym i językowym.
Po wyłączeniu kontenera maile znikają.


## Autorzy

- Paweł Jastrzębski
- Michał Niesyto
- Bartosz Kołakowski
- Maksym Nowak
- Michał Mróz

## Wykorzystane oprogramowanie

Prestashop 1.7.8

mariadb:10.10

maildev:2.1.0

C# (7.0) - dotenv.net 3.1.3, Newtonsoft.Json 13.0.3, PrestaSharp 1.2.9

Python (3) - Scrapy 2.11.0, beautifulsoup4 4.12.2, itemadapter 0.8.0, Pillow 10.1.0, pytest 7.4.3, selenium 4.15.2, webdriver_manager 4.0.1
