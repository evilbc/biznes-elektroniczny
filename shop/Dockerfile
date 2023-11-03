FROM prestashop/prestashop:1.7.8

# zaczynamy od obrazu bazowego, będziemy dodawać kolejne rzeczy, które będą nadpisywać go

# Korzystamy z overlay2, więc możemy w ten sposób nadpisywać pliki, w /var/www/html/themes jest miejsce na motywy, do dalszej pracy

# W /tmp znajdziemy skrypty inicjalizujące
COPY tmp /tmp

# Skrypty muszą być wykonywalne
# Robienie tego w jednym RUN powoduje, że nie tworzymy niepotrzebnych warstw w obrazie
RUN chmod +x /tmp/pre-install-scripts/pre-install.sh && chmod +x /tmp/post-install-scripts/post-install.sh && chmod +x /tmp/init-scripts/init.sh



# Można w tych skryptach np. dodać scrapera czy zmianę ustawień, przez SQL czy zmiany w plikach
