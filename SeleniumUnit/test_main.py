import random
import pytest as pytest
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from webdriver_manager.chrome import ChromeDriverManager

def add_to_cart_and_continue_shopping():
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[text() = 'Kontynuuj zakupy']").click()

def add_to_cart_and_take_an_order():
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//a[contains(text(),'Przejdź do realizacji zamówienia')]").click()

def select_quantity(number):
    driver.find_element("id", "quantity_wanted").click()
    driver.find_element("id", "quantity_wanted").send_keys(Keys.BACKSPACE)
    driver.find_element("id", "quantity_wanted").send_keys(str(number))

def select_by_name(name):
    driver.find_element("xpath", "//a[contains(text(), '" + name + "')]").click()

def select_category(category):
    driver.find_element("xpath", "//span[contains(text(), 'Strona główna')]").click()
    driver.find_element("xpath", "//a[contains(text(), 'Wszystkie produkty')]").click()
    driver.find_element("xpath", "//a[contains(text(), '" + category + "')]").click()

def select_current_category(category):
    driver.find_element("xpath", "//span[contains(text(), '" + category + "')]").click()

def select_size_and_material(size, material):
    driver.find_element("xpath", "//option[@title='" + size + "']").click()
    driver.find_element("xpath", "//input[@title='" + material + "']").click()

def find_item_by_name(item_name):
    driver.find_element("xpath", "//input[@placeholder='Szukaj w naszym katalogu']").click()
    driver.find_element("xpath", "//input[@placeholder='Szukaj w naszym katalogu']").send_keys(str(item_name))
    driver.find_element("xpath", "//input[@placeholder='Szukaj w naszym katalogu']").send_keys(Keys.ENTER)

def choose_element(chosen_element):
    driver.find_element("xpath", "//a[contains(text(), '" + str(chosen_element) + "')]").click()

def delete_from_cart(name):
    driver.find_element("xpath", "//a/text()[contains(., '" + name + "')]"
                                 "/ancestor::li[contains(@class, 'cart-item')]"
                                 "//a[@data-link-action='delete-from-cart']").click()

@pytest.fixture
def test_setup():
    options = Options()
    options.add_experimental_option("detach", True)
    options.add_argument("--ignore-certificate-errors")

    global driver
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
    driver.implicitly_wait(10)
    # driver.maximize_window()

def test_add_to_basket(test_setup):
    driver.get("https://localhost/pl/2-strona-glowna")

    driver.find_element("xpath", "//a[contains(text(), 'Lifestyle')]").click()
    select_by_name('Rozpinana bluza z kapturem')
    select_quantity(3)
    add_to_cart_and_continue_shopping()

    select_current_category('Lifestyle')
    select_by_name('Torba bawełniana KEEZA')
    add_to_cart_and_continue_shopping()

    select_current_category('Lifestyle')
    select_by_name('Torba bawełniana Kwiaty')
    select_quantity(2)
    add_to_cart_and_continue_shopping()

    select_current_category('Lifestyle')
    select_by_name('Bluza bawełniana "e" Orange')
    add_to_cart_and_continue_shopping()

    select_current_category('Lifestyle')
    select_by_name('Bluza KEEZA Basic Bordo')
    select_quantity(4)
    add_to_cart_and_continue_shopping()

    select_current_category('Lifestyle')
    select_by_name('Bluza bawełniana Keeza...')
    add_to_cart_and_continue_shopping()

    select_current_category('Lifestyle')
    select_by_name('Bluza KEEZA Basic Green')
    select_quantity(5)
    add_to_cart_and_continue_shopping()

    select_category('Odzież sportowa')
    select_by_name('Fartuch grillowy')
    add_to_cart_and_continue_shopping()

    select_current_category('Odzież sportowa')
    select_by_name('Plecak Napoli')
    select_quantity(3)
    add_to_cart_and_continue_shopping()

    select_current_category('Odzież sportowa')
    select_by_name('Znacznik treningowy')
    add_to_cart_and_continue_shopping()

    select_category('Wyprzedaż')
    select_by_name('Getry sportowe')
    select_size_and_material('L', 'Syntetyczne')
    add_to_cart_and_continue_shopping()

    select_current_category('Wyprzedaż')
    select_by_name('Getry sportowe')
    select_size_and_material('M', 'Bawełna')
    add_to_cart_and_continue_shopping()

    select_current_category('Wyprzedaż')
    select_by_name('Koszulka Casual line')
    select_size_and_material('S', 'Len')
    add_to_cart_and_continue_shopping()

def test_find_by_name():
    find_item_by_name('bluza')
    choose_element('Bluza termoaktywna Lima')
    add_to_cart_and_take_an_order()

def test_delete_three_elements():
    delete_from_cart('Torba bawełniana Kwiaty')
    delete_from_cart('Torba bawełniana KEEZA')
    delete_from_cart('Rozpinana bluza z kapturem')

def test_register_new_account():
    driver.find_element("xpath", "//span[contains(text(),'Zaloguj się')]").click()
    driver.find_element("xpath", "//a[contains(text(),'Nie masz konta? Załóż je tutaj')]").click()
    driver.find_element("id", "field-id_gender-1").click()
    driver.find_element("id", "field-firstname").send_keys("Jan")
    driver.find_element("id", "field-lastname").send_keys("Kowalski")
    rn = random.randint(0, 10000000000)
    driver.find_element("id", "field-email").send_keys(str(rn) + "@example.com")
    driver.find_element("id", "field-password").send_keys("qwerty")
    driver.find_element("id", "field-birthday").send_keys("1970-01-01")
    driver.find_element("xpath", "//input[@type='checkbox' and @name='optin']").click()
    driver.find_element("xpath", "//input[@type='checkbox' and @name='customer_privacy']").click()
    driver.find_element("xpath", "//input[@type='checkbox' and @name='newsletter']").click()
    driver.find_element("xpath", "//input[@type='checkbox' and @name='psgdpr']").click()
    driver.find_element("xpath", "//button[@type='submit']").click()

def test_make_order_and_send_address_data():
    driver.find_element("xpath", "//span[contains(text(),'Koszyk')]").click()
    driver.find_element("xpath", "//a[contains(text(),'Przejdź do realizacji zamówienia')]").click()

    driver.find_element("id", "field-alias").send_keys("JKow")
    driver.find_element("id", "field-company").send_keys("JKowalex")
    driver.find_element("id", "field-vat_number").send_keys("PL0123456789")
    driver.find_element("id", "field-address1").send_keys("ul. Puławska 1/2")
    driver.find_element("id", "field-address2").send_keys("przy placu Unii Lubelskiej")
    driver.find_element("id", "field-postcode").send_keys("02-515")
    driver.find_element("id", "field-city").send_keys("Warszawa")
    driver.find_element("id", "field-phone").send_keys("123456789")
    driver.find_element("xpath", "//button[@name='confirm-addresses']").click()

def test_choose_transporter():
    driver.find_element("xpath", "//button[@name='confirmDeliveryOption']").click()

def test_select_payment_on_delivery():
    driver.find_element("xpath", "//span[contains(text(),'Zapłać gotówką przy odbiorze')]").click()
    driver.find_element("id", "conditions_to_approve[terms-and-conditions]").click()

def test_approve_purchase():
    driver.find_element("xpath", "//button[contains(text(),'Złóż zamówienie')]").click()

def test_check_order_status():
    driver.find_element("xpath", "//span[contains(text(),'Strona główna')]").click()
    driver.find_element("xpath", "//a[contains(text(),'Zamówienia')]").click()
    driver.find_element("xpath", "//a[contains(text(),'Szczegóły')]").click()

def test_download_invoice():
    driver.find_element("xpath", "//a[contains(text(),'Pobierz fakturę proforma w pliku PDF')]").click()

'''
@pytest.fixture()
def test_teardown():
    yield
    driver.close()
    driver.quit()
    print("Test completed")
'''