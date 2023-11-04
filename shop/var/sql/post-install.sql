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

-- usuwa wszystkie domyślnie dodane kategorie
DELETE FROM ps_category_product;
DELETE FROM ps_category;
DELETE FROM ps_category_shop;
DELETE FROM ps_category_group;
DELETE FROM ps_category_lang;
DELETE FROM ps_layered_category;

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
(1,'','PLN','985',2,1.000000,0,1,0,0);
/*!40000 ALTER TABLE `ps_currency` ENABLE KEYS */;
UNLOCK TABLES;
