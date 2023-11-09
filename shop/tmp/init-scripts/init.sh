#!/bin/sh

echo "Inicjalizacja sklepu..."

# https://github.com/PrestaShop/PrestaShop/issues/15701
# Naprawa buga w prestashopie, bez tego leciał błąd przy dodaniu produktu
sed -i "7178s/.*/return (false !== \$result \&\& array_key_exists('id_image', \$result)) ? \$result\['id_image'] : null;/" /var/www/html/classes/Product.php

