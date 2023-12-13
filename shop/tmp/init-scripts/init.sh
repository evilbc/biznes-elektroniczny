#!/bin/sh

echo "Inicjalizacja sklepu..."

# Kopiowanie motywu
cp /theme/* /var/www/html/themes -R

# Serwer chce tutaj tworzyć pliki z cache i potrzebuje uprawnień
chown www-data:www-data /var/www/html/themes -R

# Kopiowanie logo
cp /var/www/html/themes/logo.png /var/www/html/img/logo.png

# https://github.com/PrestaShop/PrestaShop/issues/15701
# Naprawa buga w prestashopie, bez tego leciał błąd przy dodaniu produktu
sed -i "7178s/.*/return (false !== \$result \&\& array_key_exists('id_image', \$result)) ? \$result\['id_image'] : null;/" /var/www/html/classes/Product.php
