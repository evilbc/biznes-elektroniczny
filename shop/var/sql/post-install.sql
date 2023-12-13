-- włączamy SSL, bez tego nie działa SSL i jest pętla przekierowań

UPDATE ps_configuration SET value=1 WHERE name='PS_SSL_ENABLED' OR name='PS_SSL_ENABLED_EVERYWHERE';

-- usuwanie domyślnie dodanych produktów
DELETE FROM ps_product;
DELETE FROM ps_product_comment_report;
DELETE FROM ps_product_attribute_combination;
DELETE FROM ps_product_attribute_image;
DELETE FROM ps_product_shop;
DELETE FROM ps_product_country_tax;
DELETE FROM ps_product_tag;
DELETE FROM ps_product_sale;
DELETE FROM ps_product_download;
DELETE FROM ps_product_comment;
DELETE FROM ps_product_comment_criterion_product;
DELETE FROM ps_product_attribute;
DELETE FROM ps_product_lang;
DELETE FROM ps_product_attribute_shop;
DELETE FROM ps_product_supplier;
DELETE FROM ps_product_comment_criterion;
DELETE FROM ps_product_group_reduction_cache;
DELETE FROM ps_product_attachment;
DELETE FROM ps_product_comment_grade;
DELETE FROM ps_product_comment_criterion_category;
DELETE FROM ps_product_carrier;
DELETE FROM ps_product;
DELETE FROM ps_product_comment_criterion_lang;
DELETE FROM ps_product_comment_usefulness;

-- usuwa ceny
DELETE FROM ps_specific_price;
DELETE FROM ps_specific_price_priority;
DELETE FROM ps_specific_price_rule;
DELETE FROM ps_specific_price_rule_condition;
DELETE FROM ps_specific_price_rule_condition_group;

-- usuwa producentów i dostawców

DELETE FROM ps_supplier_shop;
DELETE FROM ps_supplier_lang;
DELETE FROM ps_supplier;     
DELETE FROM ps_manufacturer;
DELETE FROM ps_manufacturer_shop;
DELETE FROM ps_manufacturer_lang;

-- usuwa wszystkie domyślnie dodane kategorie oprócz PS_ROOT_CATEGORY i PS_HOME_CATEGORY - potrzebne w presta
DELETE FROM ps_category_product;
DELETE FROM ps_category WHERE id_category NOT IN (SELECT value FROM ps_configuration where name in ('PS_ROOT_CATEGORY', 'PS_HOME_CATEGORY'));
DELETE FROM ps_category_shop WHERE id_category NOT IN (SELECT value FROM ps_configuration where name in ('PS_ROOT_CATEGORY', 'PS_HOME_CATEGORY'));
DELETE FROM ps_category_group WHERE id_category NOT IN (SELECT value FROM ps_configuration where name in ('PS_ROOT_CATEGORY', 'PS_HOME_CATEGORY'));
DELETE FROM ps_category_lang WHERE id_category NOT IN (SELECT value FROM ps_configuration where name in ('PS_ROOT_CATEGORY', 'PS_HOME_CATEGORY'));
DELETE FROM ps_layered_category WHERE id_category NOT IN (SELECT value FROM ps_configuration where name in ('PS_ROOT_CATEGORY', 'PS_HOME_CATEGORY'));

-- usuwa wszystkich gości
DELETE FROM ps_guest;

-- usuwa wszystkie dostawy
DELETE FROM ps_delivery;

-- usuwa wszystkie sklepy stacjonarne

DELETE FROM ps_store;
DELETE FROM ps_store_lang;
DELETE FROM ps_store_shop;

-- usuwa wszystkie koszyki
DELETE FROM ps_cart_rule;
DELETE FROM ps_cart_rule_carrier;
DELETE FROM ps_cart_rule_product_rule_group;
DELETE FROM ps_cart_rule_product_rule_value;
DELETE FROM ps_cart_cart_rule;              
DELETE FROM ps_cart;              
DELETE FROM ps_cart_rule_lang;               
DELETE FROM ps_cart_product;             
DELETE FROM ps_cart_rule_group;       
DELETE FROM ps_cart_rule_combination;      
DELETE FROM ps_cart_rule_product_rule;      
DELETE FROM ps_cart_rule_shop;
DELETE FROM ps_cart_rule_country;

-- usuwa wszystkich klientów i ich dane
DELETE FROM ps_customer;
DELETE FROM ps_customer_message_sync_imap;
DELETE FROM ps_customer_group;
DELETE FROM ps_customer_thread;
DELETE FROM ps_customer;
DELETE FROM ps_customer_session;
DELETE FROM ps_customer_message;

-- usuwa wszystkie zamówienia
DELETE FROM ps_order_invoice_tax;
DELETE FROM ps_order_invoice;
DELETE FROM ps_order_carrier;
DELETE FROM ps_order_return;
DELETE FROM ps_order_slip;
DELETE FROM ps_order_message_lang;
DELETE FROM ps_order_return_state_lang;
DELETE FROM ps_order_message;
DELETE FROM ps_orders;
DELETE FROM ps_order_payment;
DELETE FROM ps_order_state;
DELETE FROM ps_order_return_detail;
DELETE FROM ps_order_slip_detail;
DELETE FROM ps_order_history;
DELETE FROM ps_order_cart_rule;
DELETE FROM ps_order_detail;
DELETE FROM ps_order_return_state;
DELETE FROM ps_order_invoice_payment;
DELETE FROM ps_order_state_lang;
DELETE FROM ps_order_detail_tax;

-- usuwamy domyślnych przewoźników
DELETE FROM ps_carrier;
DELETE FROM ps_carrier_tax_rules_group_shop;
DELETE FROM ps_carrier_zone;
DELETE FROM ps_carrier_group;
DELETE FROM ps_carrier_shop;
DELETE FROM ps_carrier_lang;

-- usuwamy indeks wyszukiwarki
DELETE FROM ps_search_index;

-- usuwa dane z CMSa - konkretne strony
DELETE FROM ps_cms;
DELETE FROM ps_cms_category;
DELETE FROM ps_cms_role;
DELETE FROM ps_cms_category_lang;
DELETE FROM ps_cms_category_shop;
DELETE FROM ps_cms_shop;
DELETE FROM ps_cms_role_lang;
DELETE FROM ps_cms_lang;

-- usuwamy tabelę z walutami i dodajemy PLN jako podstawową walutę, dzięki temu PLN ma id 1

DROP TABLE IF EXISTS `ps_currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ps_currency` (
  `id_currency` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `iso_code` varchar(3) NOT NULL DEFAULT '0',
  `numeric_iso_code` varchar(3) DEFAULT NULL,
  `precision` int(2) NOT NULL DEFAULT 6,
  `conversion_rate` decimal(13,6) NOT NULL,
  `deleted` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `unofficial` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `modified` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_currency`),
  KEY `currency_iso_code` (`iso_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ps_currency` WRITE;
/*!40000 ALTER TABLE `ps_currency` DISABLE KEYS */;
INSERT INTO `ps_currency` VALUES
(1,'','PLN','985',2,1.000000,0,1,0,1);
/*!40000 ALTER TABLE `ps_currency` ENABLE KEYS */;
UNLOCK TABLES;

-- problem z polskimi znakami, HEX('C582') = ł
LOCK TABLES `ps_currency_lang` WRITE;
/*!40000 ALTER TABLE `ps_currency_lang` DISABLE KEYS */;
DELETE FROM ps_currency_lang WHERE id_currency = 1 AND id_lang = 1;
INSERT INTO `ps_currency_lang` VALUES
(1,1,CONCAT('z', UNHEX('C582'), 'oty'),CONCAT('z', UNHEX('C582')),UNHEX('232C2323302E3030C2A0C2A4'));
/*!40000 ALTER TABLE `ps_currency_lang` ENABLE KEYS */;
UNLOCK TABLES;

-- podatki
LOCK TABLES `ps_tax` WRITE;
/*!40000 ALTER TABLE `ps_tax` DISABLE KEYS */;
INSERT INTO `ps_tax` VALUES
(1,23.000,1,0);
/*!40000 ALTER TABLE `ps_tax` ENABLE KEYS */;
UNLOCK TABLES;
 
LOCK TABLES `ps_tax_lang` WRITE;
/*!40000 ALTER TABLE `ps_tax_lang` DISABLE KEYS */;
INSERT INTO `ps_tax_lang` VALUES
(1,1,'VAT'),
(1,2,'VAT');
/*!40000 ALTER TABLE `ps_tax_lang` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_tax_rule` WRITE;
/*!40000 ALTER TABLE `ps_tax_rule` DISABLE KEYS */;
INSERT INTO `ps_tax_rule` VALUES
(1,1,14,0,'0','0',1,0,'');
/*!40000 ALTER TABLE `ps_tax_rule` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_tax_rules_group` WRITE;
/*!40000 ALTER TABLE `ps_tax_rules_group` DISABLE KEYS */;
INSERT INTO `ps_tax_rules_group` VALUES
(1,'VAT',1,0,'2023-11-09 10:31:21','2023-11-09 10:31:37');
/*!40000 ALTER TABLE `ps_tax_rules_group` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_tax_rules_group_shop` WRITE;
/*!40000 ALTER TABLE `ps_tax_rules_group_shop` DISABLE KEYS */;
INSERT INTO `ps_tax_rules_group_shop` VALUES
(1,1);
/*!40000 ALTER TABLE `ps_tax_rules_group_shop` ENABLE KEYS */;
UNLOCK TABLES;

-- api
LOCK TABLES `ps_webservice_account` WRITE;
/*!40000 ALTER TABLE `ps_webservice_account` DISABLE KEYS */;
DELETE FROM ps_webservice_account;
INSERT INTO `ps_webservice_account` VALUES
(1,'NM5MUI12C95VICSZW2ELLTFWUYIXM11U','','WebserviceRequest',0,NULL,1);
/*!40000 ALTER TABLE `ps_webservice_account` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_webservice_account_shop` WRITE;
/*!40000 ALTER TABLE `ps_webservice_account_shop` DISABLE KEYS */;
INSERT INTO `ps_webservice_account_shop` VALUES
(1,1);
/*!40000 ALTER TABLE `ps_webservice_account_shop` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `ps_webservice_permission` WRITE;
/*!40000 ALTER TABLE `ps_webservice_permission` DISABLE KEYS */;
INSERT INTO `ps_webservice_permission` VALUES
(1,'categories','GET',1),
(3,'categories','POST',1),
(2,'categories','PUT',1),
(4,'categories','DELETE',1),
(5,'categories','HEAD',1),
(6,'images','GET',1),
(8,'images','POST',1),
(7,'images','PUT',1),
(9,'images','DELETE',1),
(10,'images','HEAD',1),
(11,'products','GET',1),
(13,'products','POST',1),
(12,'products','PUT',1),
(14,'products','DELETE',1),
(15,'products','HEAD',1),
(16,'stock_availables','GET',1),
(18,'stock_availables','POST',1),
(17,'stock_availables','PUT',1),
(19,'stock_availables','DELETE',1),
(20,'stock_availables','HEAD',1);
/*!40000 ALTER TABLE `ps_webservice_permission` ENABLE KEYS */;
UNLOCK TABLES;

-- przewoźnicy
LOCK TABLES `ps_carrier` WRITE;
/*!40000 ALTER TABLE `ps_carrier` DISABLE KEYS */;
INSERT INTO `ps_carrier` VALUES
(5,5,0,'Express Delivery','',1,1,1,1,0,0,0,0,'',1,0,40,40,80,50.000000,9),
(6,6,0,'Cheap Delivery','',1,1,1,1,0,0,0,0,'',1,1,40,40,80,50.000000,6),
(7,5,0,'Express Delivery','',1,0,1,1,0,0,0,0,'',1,0,40,40,80,50.000000,9),
(8,6,0,'Cheap Delivery','',1,0,1,1,0,0,0,0,'',1,1,40,40,80,50.000000,6);
/*!40000 ALTER TABLE `ps_carrier` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `ps_carrier_group` WRITE;
/*!40000 ALTER TABLE `ps_carrier_group` DISABLE KEYS */;
INSERT INTO `ps_carrier_group` VALUES
(5,1),
(5,2),
(5,3),
(6,1),
(6,2),
(6,3),
(7,1),
(7,2),
(7,3),
(8,1),
(8,2),
(8,3);
/*!40000 ALTER TABLE `ps_carrier_group` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_carrier_lang` WRITE;
/*!40000 ALTER TABLE `ps_carrier_lang` DISABLE KEYS */;
INSERT INTO `ps_carrier_lang` VALUES
(5,1,1,'1 dzien'),
(6,1,1,'od 3 do 4 dni'),
(7,1,1,'1 dzien'),
(8,1,1,'od 3 do 4 dni'),
(5,1,2,'1 dzien'),
(6,1,2,'od 3 do 4 dni'),
(7,1,2,'1 dzien'),
(8,1,2,'od 3 do 4 dni');
/*!40000 ALTER TABLE `ps_carrier_lang` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_carrier_tax_rules_group_shop` WRITE;
/*!40000 ALTER TABLE `ps_carrier_tax_rules_group_shop` DISABLE KEYS */;
INSERT INTO `ps_carrier_tax_rules_group_shop` VALUES
(5,0,1),
(6,0,1),
(7,0,1),
(8,0,1);
/*!40000 ALTER TABLE `ps_carrier_tax_rules_group_shop` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_carrier_zone` WRITE;
/*!40000 ALTER TABLE `ps_carrier_zone` DISABLE KEYS */;
INSERT INTO `ps_carrier_zone` VALUES
(5,1),
(5,7),
(6,1),
(6,7),
(7,1),
(7,7),
(8,1),
(8,7);
/*!40000 ALTER TABLE `ps_carrier_zone` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_module_carrier` WRITE;
/*!40000 ALTER TABLE `ps_module_carrier` DISABLE KEYS */;
INSERT INTO `ps_module_carrier` VALUES
(14,1,5),
(14,1,6),
(35,1,5),
(35,1,6),
(56,1,5),
(56,1,6);
/*!40000 ALTER TABLE `ps_module_carrier` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_range_weight` WRITE;
/*!40000 ALTER TABLE `ps_range_weight` DISABLE KEYS */;
INSERT INTO `ps_range_weight` VALUES
(5,5,0.000000,10.000000),
(6,5,10.000000,50.000000),
(7,6,0.000000,10.000000),
(8,6,10.000000,50.000000),
(9,7,0.000000,10.000000),
(10,7,10.000000,50.000000),
(11,8,0.000000,10.000000),
(12,8,10.000000,50.000000);
/*!40000 ALTER TABLE `ps_range_weight` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ps_delivery` WRITE;
/*!40000 ALTER TABLE `ps_delivery` DISABLE KEYS */;
INSERT INTO `ps_delivery` VALUES
(19,NULL,NULL,5,NULL,5,1,5.000000),
(20,NULL,NULL,5,NULL,5,7,5.000000),
(23,NULL,NULL,5,NULL,6,1,10.000000),
(24,NULL,NULL,5,NULL,6,7,10.000000),
(27,NULL,NULL,6,NULL,7,1,2.000000),
(28,NULL,NULL,6,NULL,7,7,2.000000),
(31,NULL,NULL,6,NULL,8,1,5.000000),
(32,NULL,NULL,6,NULL,8,7,5.000000),
(35,NULL,NULL,7,NULL,9,1,5.000000),
(36,NULL,NULL,7,NULL,9,7,5.000000),
(39,NULL,NULL,7,NULL,10,1,10.000000),
(40,NULL,NULL,7,NULL,10,7,10.000000),
(43,NULL,NULL,8,NULL,11,1,2.000000),
(44,NULL,NULL,8,NULL,11,7,2.000000),
(47,NULL,NULL,8,NULL,12,1,5.000000),
(48,NULL,NULL,8,NULL,12,7,5.000000);
/*!40000 ALTER TABLE `ps_delivery` ENABLE KEYS */;
UNLOCK TABLES;

-- Ustawiamy maile na mailcatchera

UPDATE ps_configuration SET value='mailcatcher' WHERE name='PS_MAIL_SERVER';
UPDATE ps_configuration SET value='2' WHERE name='PS_MAIL_METHOD';
UPDATE ps_configuration SET value='1025' WHERE name='PS_MAIL_SMTP_PORT';
UPDATE ps_configuration SET value='off' WHERE name='PS_MAIL_SMTP_ENCRYPTION';

-- włączenie webservice'u, domyślnie taka konfiguracja nie istnieje
INSERT INTO ps_configuration (id_shop_group, id_shop, name, value, date_add, date_upd) values (null, null, 'PS_WEBSERVICE', '1', now(), now());

-- przewoźnicy
UPDATE ps_configuration SET value = '8' WHERE name ='PS_CARRIER_DEFAULT';
UPDATE ps_configuration SET value = '2000' WHERE name ='PS_SHIPPING_FREE_PRICE';
