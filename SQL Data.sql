CREATE DATABASE  IF NOT EXISTS `quickserve` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `quickserve`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: quickserve
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(255) DEFAULT NULL,
  `customer_phone_no` varchar(10) DEFAULT NULL,
  `customer_address` text,
  `customer_password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Rajat Singh','8747583902','Indraprastha, Delhi','rajat@123'),(3,'Mahir','8684020423','Rewari, Haryana','mahir@1234'),(4,'Karan','8744883902','Dwarka, Delhi','karan@123');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_worker`
--

DROP TABLE IF EXISTS `delivery_worker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_worker` (
  `delivery_worker_id` int NOT NULL AUTO_INCREMENT,
  `delivery_worker_name` varchar(255) DEFAULT NULL,
  `delivery_worker_phone_no` varchar(10) DEFAULT NULL,
  `delivery_worker_address` text,
  `delivery_worker_password` varchar(255) DEFAULT NULL,
  `delivery_worker_salary` int DEFAULT '10000',
  `no_of_deliveries` int DEFAULT '0',
  PRIMARY KEY (`delivery_worker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_worker`
--

LOCK TABLES `delivery_worker` WRITE;
/*!40000 ALTER TABLE `delivery_worker` DISABLE KEYS */;
INSERT INTO `delivery_worker` VALUES (1,'Naman','9787382965','Dwarka, Delhi','naman@857',12000,99),(2,'Rakesh','7639872345','Vaishali, Ghaziabad','rakesh@124',11000,100);
/*!40000 ALTER TABLE `delivery_worker` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `increment_salary` BEFORE UPDATE ON `delivery_worker` FOR EACH ROW BEGIN
    DECLARE old_deliveries INT;
    DECLARE new_deliveries INT;

    -- Get the old and new number of deliveries
    SET old_deliveries = OLD.no_of_deliveries;
    SET new_deliveries = NEW.no_of_deliveries;

    -- Check if the new number of deliveries is a multiple of 100 and greater than the old count
    IF new_deliveries % 100 = 0 AND new_deliveries > old_deliveries THEN
        -- Increment the salary by a certain amount (e.g., 100)
        SET NEW.delivery_worker_salary = NEW.delivery_worker_salary + 1000;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `food`
--

DROP TABLE IF EXISTS `food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food` (
  `food_id` int NOT NULL AUTO_INCREMENT,
  `food_name` varchar(255) DEFAULT NULL,
  `food_price` int DEFAULT NULL,
  `food_stock` int DEFAULT NULL,
  `food_isVeg` tinyint(1) DEFAULT NULL,
  `res_id` int DEFAULT NULL,
  PRIMARY KEY (`food_id`),
  KEY `fk_restaurant_id` (`res_id`),
  CONSTRAINT `fk_restaurant_id` FOREIGN KEY (`res_id`) REFERENCES `restaurant` (`restaurant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food`
--

LOCK TABLES `food` WRITE;
/*!40000 ALTER TABLE `food` DISABLE KEYS */;
INSERT INTO `food` VALUES (1,'Tomato Pizza',49,0,1,2),(2,'chicken burger',99,1,0,1),(4,'Onion Pizza',79,6,1,2),(5,'Chicken Sausage Pizza',139,0,0,2),(6,'Tandoori Paneer Pizza',119,8,1,2),(7,'corn pizza',79,5,1,2),(8,'Classic Chicken Pizza',129,3,0,2),(9,'Crispy Veg Burger',69,3,1,1);
/*!40000 ALTER TABLE `food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `food_details`
--

DROP TABLE IF EXISTS `food_details`;
/*!50001 DROP VIEW IF EXISTS `food_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `food_details` AS SELECT 
 1 AS `food_id`,
 1 AS `food_name`,
 1 AS `food_price`,
 1 AS `food_stock`,
 1 AS `food_isVeg`,
 1 AS `res_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `ord_id` int NOT NULL AUTO_INCREMENT,
  `ord_status` varchar(255) DEFAULT 'On The Way',
  `mode_of_payment` varchar(255) DEFAULT NULL,
  `ord_amount` int DEFAULT NULL,
  `address` text,
  `cust_id` int DEFAULT NULL,
  `w_id` int DEFAULT NULL,
  `res_id` int DEFAULT NULL,
  `delivery_time` datetime DEFAULT NULL,
  PRIMARY KEY (`ord_id`),
  KEY `fk_customer_id` (`cust_id`),
  KEY `fk_worker_id` (`w_id`),
  KEY `fk_res_id` (`res_id`),
  CONSTRAINT `fk_customer_id` FOREIGN KEY (`cust_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `fk_res_id` FOREIGN KEY (`res_id`) REFERENCES `restaurant` (`restaurant_id`),
  CONSTRAINT `fk_worker_id` FOREIGN KEY (`w_id`) REFERENCES `delivery_worker` (`delivery_worker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'Delivered','UPI',256,'Indraprastha, Delhi',1,1,2,'2024-06-20 23:31:12'),(2,'Delivered','Cash On Delivery',496,'Rewari, Haryana',3,2,2,'2024-06-21 00:01:35'),(3,'On The Way','Cash On Delivery',534,'Dwarka, Delhi',4,2,1,NULL),(4,'On The Way','UPI',336,'Rewari, Haryana',3,2,1,NULL),(5,'On The Way','Cash On Delivery',545,'Rewari, Haryana',3,2,2,NULL),(6,'On The Way','UPI',375,'Dwarka, Delhi',4,2,1,NULL),(7,'On The Way','UPI',395,'Indraprastha, Delhi',1,1,2,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_delivery_time` BEFORE UPDATE ON `orders` FOR EACH ROW BEGIN
    IF NEW.ord_status = 'DELIVERED' THEN
        SET NEW.delivery_time = CURRENT_TIMESTAMP;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `res_details`
--

DROP TABLE IF EXISTS `res_details`;
/*!50001 DROP VIEW IF EXISTS `res_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `res_details` AS SELECT 
 1 AS `restaurant_id`,
 1 AS `restaurant_name`,
 1 AS `restaurant_phone_no`,
 1 AS `restaurant_address`,
 1 AS `restaurant_password`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `restaurant_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_name` varchar(255) DEFAULT NULL,
  `restaurant_phone_no` varchar(10) DEFAULT NULL,
  `restaurant_address` text,
  `restaurant_password` varchar(255) DEFAULT NULL,
  `access_status` varchar(255) DEFAULT 'NOT GIVEN',
  PRIMARY KEY (`restaurant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES (1,'Burger King','9485747589','kalkaji, Delhi','king@453','YES'),(2,'Dominos','7649857365','Moolchand, Delhi','domino@124','YES'),(3,'RollsKing','8764093845','Karkardooma, Delhi','roll@123','NOT GIVEN');
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'quickserve'
--

--
-- Dumping routines for database 'quickserve'
--

--
-- Final view structure for view `food_details`
--

/*!50001 DROP VIEW IF EXISTS `food_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `food_details` AS select `food`.`food_id` AS `food_id`,`food`.`food_name` AS `food_name`,`food`.`food_price` AS `food_price`,`food`.`food_stock` AS `food_stock`,`food`.`food_isVeg` AS `food_isVeg`,`food`.`res_id` AS `res_id` from `food` where (`food`.`food_stock` > 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `res_details`
--

/*!50001 DROP VIEW IF EXISTS `res_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `res_details` AS select `restaurant`.`restaurant_id` AS `restaurant_id`,`restaurant`.`restaurant_name` AS `restaurant_name`,`restaurant`.`restaurant_phone_no` AS `restaurant_phone_no`,`restaurant`.`restaurant_address` AS `restaurant_address`,`restaurant`.`restaurant_password` AS `restaurant_password` from `restaurant` where (`restaurant`.`access_status` = 'YES') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-21 16:59:33
