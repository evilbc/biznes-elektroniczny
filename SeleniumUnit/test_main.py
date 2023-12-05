import random
import pytest as pytest
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from webdriver_manager.chrome import ChromeDriverManager

@pytest.fixture
def test_setup():
    options = Options()
    # options.add_experimental_option("detach", True)
    options.add_argument("--ignore-certificate-errors")

    global driver
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
    driver.implicitly_wait(10)
    # driver.maximize_window()

def test_add_to_basket(test_setup):
    driver.get("https://localhost/pl/2-strona-glowna")
    # driver.find_element("id", "details-button").click()
    # driver.find_element("id", "proceed-link").click()
    driver.find_element("xpath", "//*[contains(text(), 'Lifestyle')]").click()
    driver.find_element("xpath", "//*[contains(text(), 'Bawełniane spodenki Buffalo...')]").click()
    driver.find_element("id", "quantity_wanted").click()
    driver.find_element("id", "quantity_wanted").send_keys(Keys.BACKSPACE)
    driver.find_element("id", "quantity_wanted").send_keys("3")
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/10-lifestyle']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/spodniemeskie/111-spodnie-dresowe-meskie.html']").click()
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/10-lifestyle']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/skarpetki/99-skarpetki-lifestyle-rowerki.html']").click()
    driver.find_element("id", "quantity_wanted").click()
    driver.find_element("id", "quantity_wanted").send_keys(Keys.BACKSPACE)
    driver.find_element("id", "quantity_wanted").send_keys("2")
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/10-lifestyle']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/odziezzimowa/98-plaszcz-zimowy-brugia.html']").click()
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/10-lifestyle']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/kurtki_i_softshelle/92-softshell-damski-taliowany-black.html']").click()
    driver.find_element("id", "quantity_wanted").click()
    driver.find_element("id", "quantity_wanted").send_keys(Keys.BACKSPACE)
    driver.find_element("id", "quantity_wanted").send_keys("4")
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/10-lifestyle']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/czapki_i_kominy/42-czapka-i-komin.html']").click()
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/10-lifestyle']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/czapki_z_daszkiem/46-czapka-z-daszkiem-keeza-pink.html']").click()
    driver.find_element("id", "quantity_wanted").click()
    driver.find_element("id", "quantity_wanted").send_keys(Keys.BACKSPACE)
    driver.find_element("id", "quantity_wanted").send_keys("5")
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/2-strona-glowna']").click()
    driver.find_element("xpath", "//*[contains(text(), 'Odzież sportowa')]").click()
    driver.get("https://localhost/pl/spodenki_sportowe/199-krotkie-spodenki-nesta.html")
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/24-odziezsportowa']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/skarpety_sportowe/180-skarpetki-stopki-biale-trojpak.html']").click()
    driver.find_element("id", "quantity_wanted").click()
    driver.find_element("id", "quantity_wanted").send_keys(Keys.BACKSPACE)
    driver.find_element("id", "quantity_wanted").send_keys("6")
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

    driver.find_element("xpath", "//a[@href='https://localhost/pl/24-odziezsportowa']").click()
    driver.find_element("xpath", "//a[@href='https://localhost/pl/odzieztermoaktywna/175-komplet-termoaktywny-z-dlugim-rekawem.html']").click()
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//button[@class='btn btn-secondary']").click()

def test_find_by_name():
    driver.find_element("xpath", "//input[@placeholder='Szukaj w naszym katalogu']").click()
    driver.find_element("xpath", "//input[@placeholder='Szukaj w naszym katalogu']").send_keys("bluza")
    driver.find_element("xpath", "//input[@placeholder='Szukaj w naszym katalogu']").send_keys(Keys.ENTER)
    driver.find_element("xpath", "//a[@class='thumbnail product-thumbnail']").click()
    driver.find_element("xpath", "//button[@data-button-action='add-to-cart']").click()
    driver.find_element("xpath", "//a[contains(text(),'Przejdź do realizacji zamówienia')]").click()

def test_delete_three_elements():
    driver.find_element("xpath", "//a[@data-link-action='delete-from-cart' and @data-id-product='111']").click()
    driver.find_element("xpath", "//a[@data-link-action='delete-from-cart' and @data-id-product='99']").click()
    driver.find_element("xpath", "//a[@data-link-action='delete-from-cart' and @data-id-product='98']").click()

def test_register_new_account():
    driver.find_element("xpath", "//span[contains(text(),'Zaloguj się')]").click()
    driver.find_element("xpath", "//a[contains(text(),'Nie masz konta? Załóż je tutaj')]").click()
    driver.find_element("id", "field-id_gender-1").click()
    driver.find_element("id", "field-firstname").send_keys("Jan")
    driver.find_element("id", "field-lastname").send_keys("Kowalski")
    rn = random.randint(0, 10000000000)
    driver.find_element("id", "field-email").send_keys(str(rn) + "@gmail.com")
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
    driver.find_element("id", "payment-option-1").click()
    driver.find_element("id", "conditions_to_approve[terms-and-conditions]").click()

def test_approve_purchase(test_teardown):
    driver.find_element("xpath", "//button[contains(text(),'Złóż zamówienie')]").click()
#driver.execute_script("window.history.go(-1)")

@pytest.fixture()
def test_teardown():
    yield
    driver.close()
    driver.quit()
    print("Test completed")