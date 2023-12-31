-- MariaDB dump 10.19  Distrib 10.10.7-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: presta
-- ------------------------------------------------------
-- Server version	10.10.7-MariaDB-1:10.10.7+maria~ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ps_stock_available`
--

DROP TABLE IF EXISTS `ps_stock_available`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ps_stock_available` (
  `id_stock_available` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_product` int(11) unsigned NOT NULL,
  `id_product_attribute` int(11) unsigned NOT NULL,
  `id_shop` int(11) unsigned NOT NULL,
  `id_shop_group` int(11) unsigned NOT NULL,
  `quantity` int(10) NOT NULL DEFAULT 0,
  `physical_quantity` int(11) NOT NULL DEFAULT 0,
  `reserved_quantity` int(11) NOT NULL DEFAULT 0,
  `depends_on_stock` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `out_of_stock` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `location` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_stock_available`),
  UNIQUE KEY `product_sqlstock` (`id_product`,`id_product_attribute`,`id_shop`,`id_shop_group`),
  KEY `id_shop` (`id_shop`),
  KEY `id_shop_group` (`id_shop_group`),
  KEY `id_product` (`id_product`),
  KEY `id_product_attribute` (`id_product_attribute`)
) ENGINE=InnoDB AUTO_INCREMENT=425 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ps_stock_available`
--

LOCK TABLES `ps_stock_available` WRITE;
/*!40000 ALTER TABLE `ps_stock_available` DISABLE KEYS */;
INSERT INTO `ps_stock_available` VALUES
(1,1,0,1,0,2400,0,0,0,2,''),
(2,2,0,1,0,2100,0,0,0,2,''),
(3,3,0,1,0,1500,0,0,0,2,''),
(4,4,0,1,0,1500,0,0,0,2,''),
(5,5,0,1,0,900,0,0,0,2,''),
(6,6,0,1,0,300,0,0,0,2,''),
(7,7,0,1,0,300,0,0,0,2,''),
(8,8,0,1,0,300,0,0,0,2,''),
(9,9,0,1,0,600,0,0,0,2,''),
(10,10,0,1,0,600,0,0,0,2,''),
(11,11,0,1,0,600,0,0,0,2,''),
(12,12,0,1,0,300,0,0,0,1,''),
(13,13,0,1,0,300,0,0,0,1,''),
(14,14,0,1,0,300,0,0,0,1,''),
(15,15,0,1,0,100,0,0,0,2,''),
(16,16,0,1,0,1200,0,0,0,2,''),
(17,17,0,1,0,1200,0,0,0,2,''),
(18,18,0,1,0,1200,0,0,0,2,''),
(19,19,0,1,0,300,0,0,0,2,''),
(20,1,1,1,0,300,0,0,0,2,''),
(21,1,2,1,0,300,0,0,0,2,''),
(22,1,3,1,0,300,0,0,0,2,''),
(23,1,4,1,0,300,0,0,0,2,''),
(24,1,5,1,0,300,0,0,0,2,''),
(25,1,6,1,0,300,0,0,0,2,''),
(26,1,7,1,0,300,0,0,0,2,''),
(27,1,8,1,0,300,0,0,0,2,''),
(28,2,9,1,0,1200,0,0,0,2,''),
(29,2,10,1,0,300,0,0,0,2,''),
(30,2,11,1,0,300,0,0,0,2,''),
(31,2,12,1,0,300,0,0,0,2,''),
(32,3,13,1,0,900,0,0,0,2,''),
(33,3,14,1,0,300,0,0,0,2,''),
(34,3,15,1,0,300,0,0,0,2,''),
(35,4,16,1,0,900,0,0,0,2,''),
(36,4,17,1,0,300,0,0,0,2,''),
(37,4,18,1,0,300,0,0,0,2,''),
(38,5,19,1,0,300,0,0,0,2,''),
(39,5,20,1,0,300,0,0,0,2,''),
(40,5,21,1,0,300,0,0,0,2,''),
(41,9,22,1,0,300,0,0,0,2,''),
(42,9,23,1,0,300,0,0,0,2,''),
(43,10,24,1,0,300,0,0,0,2,''),
(44,10,25,1,0,300,0,0,0,2,''),
(45,11,26,1,0,300,0,0,0,2,''),
(46,11,27,1,0,300,0,0,0,2,''),
(47,16,28,1,0,300,0,0,0,2,''),
(48,16,29,1,0,300,0,0,0,2,''),
(49,16,30,1,0,300,0,0,0,2,''),
(50,16,31,1,0,300,0,0,0,2,''),
(51,17,32,1,0,300,0,0,0,2,''),
(52,17,33,1,0,300,0,0,0,2,''),
(53,17,34,1,0,300,0,0,0,2,''),
(54,17,35,1,0,300,0,0,0,2,''),
(55,18,36,1,0,300,0,0,0,2,''),
(56,18,37,1,0,300,0,0,0,2,''),
(57,18,38,1,0,300,0,0,0,2,''),
(58,18,39,1,0,300,0,0,0,2,''),
(59,20,0,1,0,0,0,0,0,0,''),
(60,21,0,1,0,7,0,0,0,0,''),
(61,22,0,1,0,1,0,0,0,0,''),
(62,23,0,1,0,4,0,0,0,0,''),
(63,24,0,1,0,3,0,0,0,0,''),
(64,25,0,1,0,7,0,0,0,0,''),
(65,26,0,1,0,6,0,0,0,0,''),
(66,27,0,1,0,3,0,0,0,0,''),
(67,28,0,1,0,0,0,0,0,0,''),
(68,29,0,1,0,9,0,0,0,0,''),
(69,30,0,1,0,7,0,0,0,0,''),
(70,31,0,1,0,3,0,0,0,0,''),
(71,32,0,1,0,0,0,0,0,0,''),
(72,33,0,1,0,8,0,0,0,0,''),
(73,34,0,1,0,9,0,0,0,0,''),
(74,35,0,1,0,1,0,0,0,0,''),
(75,36,0,1,0,4,0,0,0,0,''),
(76,37,0,1,0,7,0,0,0,0,''),
(77,38,0,1,0,8,0,0,0,0,''),
(78,39,0,1,0,1,0,0,0,0,''),
(79,40,0,1,0,1,0,0,0,0,''),
(80,41,0,1,0,5,0,0,0,0,''),
(81,42,0,1,0,2,0,0,0,0,''),
(82,43,0,1,0,9,0,0,0,0,''),
(83,44,0,1,0,6,0,0,0,0,''),
(84,45,0,1,0,1,0,0,0,0,''),
(85,46,0,1,0,7,0,0,0,0,''),
(86,47,0,1,0,7,0,0,0,0,''),
(87,48,0,1,0,4,0,0,0,0,''),
(88,49,0,1,0,3,0,0,0,0,''),
(89,50,0,1,0,5,0,0,0,0,''),
(90,51,0,1,0,0,0,0,0,0,''),
(91,52,0,1,0,7,0,0,0,0,''),
(92,53,0,1,0,5,0,0,0,0,''),
(93,54,0,1,0,5,0,0,0,0,''),
(94,55,0,1,0,1,0,0,0,0,''),
(95,56,0,1,0,1,0,0,0,0,''),
(96,57,0,1,0,2,0,0,0,0,''),
(97,58,0,1,0,9,0,0,0,0,''),
(98,59,0,1,0,4,0,0,0,0,''),
(99,60,0,1,0,5,0,0,0,0,''),
(100,61,0,1,0,8,0,0,0,0,''),
(101,62,0,1,0,9,0,0,0,0,''),
(102,63,0,1,0,5,0,0,0,0,''),
(103,64,0,1,0,5,0,0,0,0,''),
(104,65,0,1,0,7,0,0,0,0,''),
(105,66,0,1,0,0,0,0,0,0,''),
(106,67,0,1,0,4,0,0,0,0,''),
(107,68,0,1,0,2,0,0,0,0,''),
(108,69,0,1,0,8,0,0,0,0,''),
(109,70,0,1,0,3,0,0,0,0,''),
(110,71,0,1,0,0,0,0,0,0,''),
(111,72,0,1,0,5,0,0,0,0,''),
(112,73,0,1,0,1,0,0,0,0,''),
(113,74,0,1,0,9,0,0,0,0,''),
(114,75,0,1,0,0,0,0,0,0,''),
(115,76,0,1,0,4,0,0,0,0,''),
(116,77,0,1,0,4,0,0,0,0,''),
(117,78,0,1,0,1,0,0,0,0,''),
(118,79,0,1,0,8,0,0,0,0,''),
(119,80,0,1,0,8,0,0,0,0,''),
(120,81,0,1,0,5,0,0,0,0,''),
(121,82,0,1,0,0,0,0,0,0,''),
(122,83,0,1,0,5,0,0,0,0,''),
(123,84,0,1,0,9,0,0,0,0,''),
(124,85,0,1,0,1,0,0,0,0,''),
(125,86,0,1,0,0,0,0,0,0,''),
(126,87,0,1,0,7,0,0,0,0,''),
(127,88,0,1,0,1,0,0,0,0,''),
(128,89,0,1,0,7,0,0,0,0,''),
(129,90,0,1,0,0,0,0,0,0,''),
(130,91,0,1,0,8,0,0,0,0,''),
(131,92,0,1,0,5,0,0,0,0,''),
(132,93,0,1,0,5,0,0,0,0,''),
(133,94,0,1,0,3,0,0,0,0,''),
(134,95,0,1,0,3,0,0,0,0,''),
(135,96,0,1,0,7,0,0,0,0,''),
(136,97,0,1,0,2,0,0,0,0,''),
(137,98,0,1,0,2,0,0,0,0,''),
(138,99,0,1,0,8,0,0,0,0,''),
(139,100,0,1,0,3,0,0,0,0,''),
(140,101,0,1,0,7,0,0,0,0,''),
(141,102,0,1,0,1,0,0,0,0,''),
(142,103,0,1,0,6,0,0,0,0,''),
(143,104,0,1,0,7,0,0,0,0,''),
(144,105,0,1,0,6,0,0,0,0,''),
(145,106,0,1,0,3,0,0,0,0,''),
(146,107,0,1,0,1,0,0,0,0,''),
(147,108,0,1,0,8,0,0,0,0,''),
(148,109,0,1,0,0,0,0,0,0,''),
(149,110,0,1,0,4,0,0,0,0,''),
(150,111,0,1,0,1,0,0,0,0,''),
(151,112,0,1,0,4,0,0,0,0,''),
(152,113,0,1,0,5,0,0,0,0,''),
(153,114,0,1,0,0,0,0,0,0,''),
(154,115,0,1,0,0,0,0,0,0,''),
(155,116,0,1,0,0,0,0,0,0,''),
(156,117,0,1,0,4,0,0,0,0,''),
(157,118,0,1,0,5,0,0,0,0,''),
(158,119,0,1,0,4,0,0,0,0,''),
(159,120,0,1,0,8,0,0,0,0,''),
(160,121,0,1,0,1,0,0,0,0,''),
(161,122,0,1,0,2,0,0,0,0,''),
(162,123,0,1,0,6,0,0,0,0,''),
(163,124,0,1,0,8,0,0,0,0,''),
(164,125,0,1,0,5,0,0,0,0,''),
(165,126,0,1,0,6,0,0,0,0,''),
(166,127,0,1,0,7,0,0,0,0,''),
(167,128,0,1,0,8,0,0,0,0,''),
(168,129,0,1,0,4,0,0,0,0,''),
(169,130,0,1,0,9,0,0,0,0,''),
(170,131,0,1,0,6,0,0,0,0,''),
(171,132,0,1,0,5,0,0,0,0,''),
(172,133,0,1,0,7,0,0,0,0,''),
(173,134,0,1,0,1,0,0,0,0,''),
(174,135,0,1,0,3,0,0,0,0,''),
(175,136,0,1,0,0,0,0,0,0,''),
(176,137,0,1,0,9,0,0,0,0,''),
(177,138,0,1,0,1,0,0,0,0,''),
(178,139,0,1,0,2,0,0,0,0,''),
(179,140,0,1,0,0,0,0,0,0,''),
(180,141,0,1,0,3,0,0,0,0,''),
(181,142,0,1,0,7,0,0,0,0,''),
(182,143,0,1,0,0,0,0,0,0,''),
(183,144,0,1,0,2,0,0,0,0,''),
(184,145,0,1,0,7,0,0,0,0,''),
(185,146,0,1,0,2,0,0,0,0,''),
(186,147,0,1,0,8,0,0,0,0,''),
(187,148,0,1,0,1,0,0,0,0,''),
(188,149,0,1,0,8,0,0,0,0,''),
(189,150,0,1,0,0,0,0,0,0,''),
(190,151,0,1,0,3,0,0,0,0,''),
(191,152,0,1,0,5,0,0,0,0,''),
(192,153,0,1,0,8,0,0,0,0,''),
(193,154,0,1,0,4,0,0,0,0,''),
(194,155,0,1,0,8,0,0,0,0,''),
(195,156,0,1,0,4,0,0,0,0,''),
(196,157,0,1,0,1,0,0,0,0,''),
(197,158,0,1,0,7,0,0,0,0,''),
(198,159,0,1,0,3,0,0,0,0,''),
(199,160,0,1,0,0,0,0,0,0,''),
(200,161,0,1,0,6,0,0,0,0,''),
(201,162,0,1,0,7,0,0,0,0,''),
(202,163,0,1,0,2,0,0,0,0,''),
(203,164,0,1,0,2,0,0,0,0,''),
(204,165,0,1,0,5,0,0,0,0,''),
(205,166,0,1,0,5,0,0,0,0,''),
(206,167,0,1,0,9,0,0,0,0,''),
(207,168,0,1,0,7,0,0,0,0,''),
(208,169,0,1,0,5,0,0,0,0,''),
(209,170,0,1,0,3,0,0,0,0,''),
(210,171,0,1,0,9,0,0,0,0,''),
(211,172,0,1,0,9,0,0,0,0,''),
(212,173,0,1,0,9,0,0,0,0,''),
(213,174,0,1,0,6,0,0,0,0,''),
(214,175,0,1,0,3,0,0,0,0,''),
(215,176,0,1,0,0,0,0,0,0,''),
(216,177,0,1,0,8,0,0,0,0,''),
(217,178,0,1,0,6,0,0,0,0,''),
(218,179,0,1,0,9,0,0,0,0,''),
(219,180,0,1,0,9,0,0,0,0,''),
(220,181,0,1,0,8,0,0,0,0,''),
(221,182,0,1,0,0,0,0,0,0,''),
(222,183,0,1,0,2,0,0,0,0,''),
(223,184,0,1,0,6,0,0,0,0,''),
(224,185,0,1,0,0,0,0,0,0,''),
(225,186,0,1,0,8,0,0,0,0,''),
(226,187,0,1,0,0,0,0,0,0,''),
(227,188,0,1,0,3,0,0,0,0,''),
(228,189,0,1,0,0,0,0,0,0,''),
(229,190,0,1,0,2,0,0,0,0,''),
(230,191,0,1,0,7,0,0,0,0,''),
(231,192,0,1,0,7,0,0,0,0,''),
(232,193,0,1,0,2,0,0,0,0,''),
(233,194,0,1,0,5,0,0,0,0,''),
(234,195,0,1,0,4,0,0,0,0,''),
(235,196,0,1,0,1,0,0,0,0,''),
(236,197,0,1,0,1,0,0,0,0,''),
(237,198,0,1,0,5,0,0,0,0,''),
(238,199,0,1,0,8,0,0,0,0,''),
(239,200,0,1,0,5,0,0,0,0,''),
(240,201,0,1,0,8,0,0,0,0,''),
(241,202,0,1,0,6,0,0,0,0,''),
(242,203,0,1,0,4,0,0,0,0,''),
(243,204,0,1,0,9,0,0,0,0,''),
(244,205,0,1,0,1,0,0,0,0,''),
(245,206,0,1,0,1,0,0,0,0,''),
(246,207,0,1,0,6,0,0,0,0,''),
(247,208,0,1,0,8,0,0,0,0,''),
(248,209,0,1,0,2,0,0,0,0,''),
(249,210,0,1,0,1,0,0,0,0,''),
(250,211,0,1,0,2,0,0,0,0,''),
(251,212,0,1,0,3,0,0,0,0,''),
(252,213,0,1,0,2,0,0,0,0,''),
(253,214,0,1,0,7,0,0,0,0,''),
(254,215,0,1,0,1,0,0,0,0,''),
(255,216,0,1,0,3,0,0,0,0,''),
(256,217,0,1,0,9,0,0,0,0,''),
(257,218,0,1,0,8,0,0,0,0,''),
(258,219,0,1,0,1,0,0,0,0,''),
(259,220,0,1,0,2,0,0,0,0,''),
(260,221,0,1,0,7,0,0,0,0,''),
(261,222,0,1,0,8,0,0,0,0,''),
(262,223,0,1,0,6,0,0,0,0,''),
(263,224,0,1,0,5,0,0,0,0,''),
(264,225,0,1,0,0,0,0,0,0,''),
(265,226,0,1,0,3,0,0,0,0,''),
(266,227,0,1,0,3,0,0,0,0,''),
(267,228,0,1,0,5,0,0,0,0,''),
(268,229,0,1,0,8,0,0,0,0,''),
(269,230,0,1,0,6,0,0,0,0,''),
(270,231,0,1,0,6,0,0,0,0,''),
(271,232,0,1,0,5,0,0,0,0,''),
(272,233,0,1,0,1,0,0,0,0,''),
(273,234,0,1,0,7,0,0,0,0,''),
(274,235,0,1,0,9,0,0,0,0,''),
(275,236,0,1,0,5,0,0,0,0,''),
(276,237,0,1,0,3,0,0,0,0,''),
(277,238,0,1,0,2,0,0,0,0,''),
(278,239,0,1,0,6,0,0,0,0,''),
(279,240,0,1,0,1,0,0,0,0,''),
(280,241,0,1,0,6,0,0,0,0,''),
(281,242,0,1,0,8,0,0,0,0,''),
(282,243,0,1,0,1,0,0,0,0,''),
(283,244,0,1,0,2,0,0,0,0,''),
(284,245,0,1,0,9,0,0,0,0,''),
(285,246,0,1,0,9,0,0,0,0,''),
(286,247,0,1,0,9,0,0,0,0,''),
(287,248,0,1,0,2,0,0,0,0,''),
(288,249,0,1,0,8,0,0,0,0,''),
(289,250,0,1,0,3,0,0,0,0,''),
(290,251,0,1,0,5,0,0,0,0,''),
(291,252,0,1,0,0,0,0,0,0,''),
(292,253,0,1,0,8,0,0,0,0,''),
(293,254,0,1,0,2,0,0,0,0,''),
(294,255,0,1,0,2,0,0,0,0,''),
(295,256,0,1,0,6,0,0,0,0,''),
(296,257,0,1,0,2,0,0,0,0,''),
(297,258,0,1,0,9,0,0,0,0,''),
(298,259,0,1,0,8,0,0,0,0,''),
(299,260,0,1,0,2,0,0,0,0,''),
(300,261,0,1,0,2,0,0,0,0,''),
(301,262,0,1,0,9,0,0,0,0,''),
(302,263,0,1,0,6,0,0,0,0,''),
(303,264,0,1,0,4,0,0,0,0,''),
(304,265,0,1,0,2,0,0,0,0,''),
(305,266,0,1,0,1,0,0,0,0,''),
(306,267,0,1,0,3,0,0,0,0,''),
(307,268,0,1,0,9,0,0,0,0,''),
(308,269,0,1,0,6,0,0,0,0,''),
(309,270,0,1,0,5,0,0,0,0,''),
(310,271,0,1,0,2,0,0,0,0,''),
(311,272,0,1,0,1,0,0,0,0,''),
(312,273,0,1,0,7,0,0,0,0,''),
(313,274,0,1,0,1,0,0,0,0,''),
(314,275,0,1,0,7,0,0,0,0,''),
(315,276,0,1,0,6,0,0,0,0,''),
(316,277,0,1,0,0,0,0,0,0,''),
(317,278,0,1,0,9,0,0,0,0,''),
(318,279,0,1,0,9,0,0,0,0,''),
(319,280,0,1,0,1,0,0,0,0,''),
(320,281,0,1,0,8,0,0,0,0,''),
(321,282,0,1,0,3,0,0,0,0,''),
(322,283,0,1,0,7,0,0,0,0,''),
(323,284,0,1,0,0,0,0,0,0,''),
(324,285,0,1,0,2,0,0,0,0,''),
(325,286,0,1,0,7,0,0,0,0,''),
(326,287,0,1,0,9,0,0,0,0,''),
(327,288,0,1,0,7,0,0,0,0,''),
(328,289,0,1,0,2,0,0,0,0,''),
(329,290,0,1,0,2,0,0,0,0,''),
(330,291,0,1,0,4,0,0,0,0,''),
(331,292,0,1,0,5,0,0,0,0,''),
(332,293,0,1,0,5,0,0,0,0,''),
(333,294,0,1,0,8,0,0,0,0,''),
(334,295,0,1,0,7,0,0,0,0,''),
(335,296,0,1,0,8,0,0,0,0,''),
(336,297,0,1,0,1,0,0,0,0,''),
(337,298,0,1,0,3,0,0,0,0,''),
(338,299,0,1,0,0,0,0,0,0,''),
(339,300,0,1,0,1,0,0,0,0,''),
(340,301,0,1,0,7,0,0,0,0,''),
(341,302,0,1,0,9,0,0,0,0,''),
(342,303,0,1,0,7,0,0,0,0,''),
(343,304,0,1,0,2,0,0,0,0,''),
(344,305,0,1,0,9,0,0,0,0,''),
(345,306,0,1,0,2,0,0,0,0,''),
(346,307,0,1,0,1,0,0,0,0,''),
(347,308,0,1,0,7,0,0,0,0,''),
(348,309,0,1,0,1,0,0,0,0,''),
(349,310,0,1,0,3,0,0,0,0,''),
(350,311,0,1,0,4,0,0,0,0,''),
(351,312,0,1,0,5,0,0,0,0,''),
(352,313,0,1,0,9,0,0,0,0,''),
(353,314,0,1,0,6,0,0,0,0,''),
(354,315,0,1,0,3,0,0,0,0,''),
(355,316,0,1,0,6,0,0,0,0,''),
(356,317,0,1,0,5,0,0,0,0,''),
(357,318,0,1,0,0,0,0,0,0,''),
(358,319,0,1,0,9,0,0,0,0,''),
(359,320,0,1,0,8,0,0,0,0,''),
(360,321,0,1,0,9,0,0,0,0,''),
(361,322,0,1,0,5,0,0,0,0,''),
(362,323,0,1,0,9,0,0,0,0,''),
(363,324,0,1,0,6,0,0,0,0,''),
(364,325,0,1,0,9,0,0,0,0,''),
(365,326,0,1,0,25,0,0,0,0,''),
(366,327,0,1,0,21,0,0,0,0,''),
(367,328,0,1,0,11,0,0,0,0,''),
(368,329,0,1,0,9,0,0,0,0,''),
(369,330,0,1,0,0,0,0,0,0,''),
(385,329,55,1,0,2,0,0,0,0,''),
(386,329,56,1,0,2,0,0,0,0,''),
(387,329,57,1,0,2,0,0,0,0,''),
(388,329,58,1,0,1,0,0,0,0,''),
(389,329,59,1,0,1,0,0,0,0,''),
(390,329,60,1,0,1,0,0,0,0,''),
(391,328,61,1,0,2,0,0,0,0,''),
(392,328,62,1,0,3,0,0,0,0,''),
(393,328,63,1,0,5,0,0,0,0,''),
(394,328,64,1,0,0,0,0,0,0,''),
(395,328,65,1,0,1,0,0,0,0,''),
(396,328,66,1,0,0,0,0,0,0,''),
(403,327,73,1,0,1,0,0,0,0,''),
(404,327,74,1,0,2,0,0,0,0,''),
(405,327,75,1,0,3,0,0,0,0,''),
(406,327,76,1,0,4,0,0,0,0,''),
(407,327,77,1,0,5,0,0,0,0,''),
(408,327,78,1,0,6,0,0,0,0,''),
(409,326,79,1,0,4,0,0,0,0,''),
(410,326,80,1,0,1,0,0,0,0,''),
(411,326,81,1,0,3,0,0,0,0,''),
(412,326,82,1,0,0,0,0,0,0,''),
(413,326,83,1,0,2,0,0,0,0,''),
(414,326,84,1,0,0,0,0,0,0,''),
(415,326,85,1,0,1,0,0,0,0,''),
(416,326,86,1,0,3,0,0,0,0,''),
(417,326,87,1,0,5,0,0,0,0,''),
(418,326,88,1,0,0,0,0,0,0,''),
(419,326,89,1,0,6,0,0,0,0,''),
(420,326,90,1,0,0,0,0,0,0,''),
(421,325,91,1,0,2,0,0,0,0,''),
(422,325,92,1,0,3,0,0,0,0,''),
(423,325,93,1,0,1,0,0,0,0,''),
(424,325,94,1,0,3,0,0,0,0,'');
/*!40000 ALTER TABLE `ps_stock_available` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-13 21:32:06
