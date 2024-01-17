# biznes-elektroniczny
Projekt na biznes elektroniczny - sklep w Prestashop, oparty na sklepie https://sklep.keeza.pl/ (zescrapowane produkty)

Sklep obecnie generuje certyfikat automatycznie na 365 dni. Konfiguracja podstawowa w pliku shop/.env

## Przydatne informacje w ramach 2 etapu

Należy podłączyć się VPN WETI przed wykonywaniem niżej podanych poleceń!

### Lokalny dostęp do sklepu

```bash
ssh -L 443:student-swarm01.maas:18427 rsww@172.20.83.101
```

Po wykonaniu polecenia można wejść na sklep pod adresem [https://localhost/](https://localhost/), ale sklep jest hostowany na zewnętrznym serwerze.

### Lokalny dostęp do maili

```bash
ssh -L 1080:student-swarm01.maas:18865 rsww@172.20.83.101
```

Maile dostępne pod [http://localhost:1080](http://localhost:1080).

### Lokalny dostęp do bazy danych

```bash
ssh -L 3306:student-swarm01.maas:3306 rsww@172.20.83.101
```

Baza dostępna na porcie 3306 lokalnie, można dzięki temu ją modyfikować. 
Należy uważać na nazwę bazy danych!

### Dostęp do serwera

```bash
ssh rsww@172.20.83.101
# po zalogowaniu
ssh hdoop@student-swarm01.maas
```

Dostęp do innych serwerów wymaga dostępu do serwera 1, a potem ponownie po ssh do innego serwera.

## Przydatne informacje w ramach 1 etapu

### Przydatne polecenia

Zaczynamy w katalogu shop. 
Polecenia docker build i docker compose wykonujemy zawsze w tym katalogu. Reszta bez znaczenia.

#### Uruchomienie sklepu
Sklep zostanie automatycznie zainstalowany i uruchomiony (jeżeli nie był zainstalowany wcześniej)

```bash
docker compose build && docker compose create && docker compose start
```

Alternatywnie można użyć innego polecenia, ale wtedy po naciśnięciu ctrl+c wszystko się wyłącza.
Natomiast można w ten sposób łatwo śledzić logi między różnymi kontenerami.
```bash
docker compose up
```

#### Restart sklepu (bez bazy)

```bash
docker restart shop-prestashop-1
```

#### Zbudowanie nowego obrazu kontenera sklepu

```bash
# latest to tag, ale można równie dobrze wpisać v1 albo 1, etc.
docker build -t niesytomichal/pg-weti-biznes-elektroniczny:latest .
```

Każdy może zbudować i mieć lokalny build. Do opcji push proszę o kontakt ze mną i wtedy dam uprawnienia tak aby robić push.

#### Wyłączenie sklepu

```bash
docker compose down
```

#### Usunięcie zainstalowanego sklepu (do ponownej instalacji), wymagane wyłączenie

```bash
docker volume rm shop_psdata
docker volume rm shop_dbdata
```

#### Wejście do kontenera sklepu

```bash
docker exec -it shop-prestashop-1 /bin/bash
```

#### Wejście do bazy danych sklepu

```bash
# -padmin oznacza hasło admin
docker exec -it shop-db-1 /bin/mysql -padmin presta
```

W konsoli bazy danych można również zobaczyć jakie są tabele za pomocą:

```sql
SHOW TABLES; 
```

#### Zrobienie dumpa całej bazy

```bash
# Plik dump.sql można zamienić na inną lokalizację, dostaniemy ten plik lokalnie a nie w kontenerze
# Jeśli chce się zapisać również zdjęcia, należy zzipować katalog \\wsl$\docker-desktop-data\data\docker\volumes\shop_psdata\_data\img (lub /var/snap/docker/common/var-lib-docker/volumes/shop_psdata/_data/img na Linuxie) i plik zip umieścić w shop/tmp/
docker exec shop-db-1 /bin/mysqldump -padmin presta > dump.sql
```

#### Zrobienie dumpa danej tabeli

```bash
# Plik dump.sql można zamienić na inną lokalizację, dostaniemy ten plik lokalnie a nie w kontenerze
# Zamień ps_table na rzeczywistą nazwę tabeli
docker exec shop-db-1 /bin/mysqldump -padmin presta ps_table > dump.sql
```

#### Inicjalizacja produktów
Należy najpierw odpalić scrapera (scraper/scraper.py, można uruchomić np. w PyCharmie), żeby pobrały się zdjęcia produktów. Wymagane zależności są podane w requirements.txt (najlepiej w wirtualnym środowisku), jeśli katalog scraper otworzy się w PyCharmie, to powinien je automatycznie zainstalować. Następnie należy otworzyć product-init/ProductInit.sln w VisualStudio i uruchomić Initializer.cs

#### Maile

Maile dostępne są z użyciem klienta w przeglądarce opartego o HTTP na tym samym hoście zainstalowana reszta, na porcie 1080.
Dla localhost będzie to http://localhost:1080
Maile należy dostosować pod względem wizualnym i językowym.
Po wyłączeniu kontenera maile znikają.

#### Polecenie na dump bazy danych aby zmienić liczbę produktów na stanie

```bash
# Polecenie początkowe, trzeba go użyć przed modyfikacją liczby produktów, zapisuje aktualną liczbę produktów
docker exec shop-db-1 /bin/mysqldump -padmin presta ps_stock_available > dump.sql
# Polecenie do użycia po testach, przywraca liczbę produktów do zapisanej wartości
docker exec -i shop-db-1 /bin/mysql -uuser -padmin -h db presta < dump.sql
```

### Autorzy

- Paweł Jastrzębski
- Michał Niesyto
- Bartosz Kołakowski
- Maksym Nowak
- Michał Mróz

### Wykorzystane oprogramowanie

Prestashop 1.7.8

mariadb:10.10

maildev:2.1.0

C# (7.0) - dotenv.net 3.1.3, Newtonsoft.Json 13.0.3, PrestaSharp 1.2.9

Python (3) - Scrapy 2.11.0, beautifulsoup4 4.12.2, itemadapter 0.8.0, Pillow 10.1.0, pytest 7.4.3, selenium 4.15.2, webdriver_manager 4.0.1
