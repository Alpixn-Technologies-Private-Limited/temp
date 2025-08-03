CREATE DATABASE  IF NOT EXISTS `project_management_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `project_management_db`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: project_management_db
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
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `message` varchar(500) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `project_id` bigint DEFAULT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` bigint DEFAULT NULL,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `metadata` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_activity_logs_timestamp` (`timestamp`),
  KEY `idx_activity_logs_user_id` (`user_id`),
  KEY `idx_activity_logs_project_id` (`project_id`),
  KEY `idx_activity_logs_type` (`type`),
  KEY `idx_activity_logs_entity` (`entity_type`,`entity_id`),
  CONSTRAINT `fk_activity_logs_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_activity_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_automation_rules`
--

DROP TABLE IF EXISTS `ai_automation_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_automation_rules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `trigger_type` varchar(100) NOT NULL,
  `trigger_conditions` json DEFAULT NULL,
  `actions` json DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `execution_count` int DEFAULT '0',
  `success_count` int DEFAULT '0',
  `last_executed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `idx_trigger_type` (`trigger_type`),
  KEY `idx_status` (`status`),
  CONSTRAINT `ai_automation_rules_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_automation_rules`
--

LOCK TABLES `ai_automation_rules` WRITE;
/*!40000 ALTER TABLE `ai_automation_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_automation_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_insights`
--

DROP TABLE IF EXISTS `ai_insights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_insights` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entity_type` enum('PROJECT','TASK','USER','TEAM') NOT NULL,
  `entity_id` bigint NOT NULL,
  `insight_type` enum('RISK_PREDICTION','DEADLINE_PREDICTION','RESOURCE_RECOMMENDATION','PERFORMANCE_ANALYSIS') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `confidence_score` decimal(3,2) DEFAULT NULL,
  `impact_level` enum('LOW','MEDIUM','HIGH') DEFAULT 'MEDIUM',
  `status` enum('ACTIVE','RESOLVED','DISMISSED') DEFAULT 'ACTIVE',
  `data` json DEFAULT NULL,
  `suggested_actions` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_insight_type` (`insight_type`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_insights`
--

LOCK TABLES `ai_insights` WRITE;
/*!40000 ALTER TABLE `ai_insights` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_insights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_predictions`
--

DROP TABLE IF EXISTS `ai_predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_predictions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entity_type` enum('PROJECT','TASK') NOT NULL,
  `entity_id` bigint NOT NULL,
  `prediction_type` enum('COMPLETION_DATE','BUDGET_OVERRUN','RISK_SCORE','QUALITY_SCORE') NOT NULL,
  `predicted_value` varchar(255) DEFAULT NULL,
  `actual_value` varchar(255) DEFAULT NULL,
  `confidence_score` decimal(3,2) DEFAULT NULL,
  `factors` json DEFAULT NULL,
  `is_accurate` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_prediction_type` (`prediction_type`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_predictions`
--

LOCK TABLES `ai_predictions` WRITE;
/*!40000 ALTER TABLE `ai_predictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_predictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `analytics_data`
--

DROP TABLE IF EXISTS `analytics_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analytics_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entity_type` enum('PROJECT','TASK','USER','TEAM','CLIENT') NOT NULL,
  `entity_id` bigint NOT NULL,
  `metric_name` varchar(100) NOT NULL,
  `metric_value` decimal(15,4) DEFAULT NULL,
  `metric_data` json DEFAULT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_metric_name` (`metric_name`),
  KEY `idx_date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analytics_data`
--

LOCK TABLES `analytics_data` WRITE;
/*!40000 ALTER TABLE `analytics_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `analytics_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(100) NOT NULL,
  `entity_id` bigint DEFAULT NULL,
  `action` enum('CREATE','READ','UPDATE','DELETE') NOT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_action` (`action`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_addresses`
--

DROP TABLE IF EXISTS `client_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_addresses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_id` bigint NOT NULL,
  `street` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_client_id` (`client_id`),
  CONSTRAINT `client_addresses_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_addresses`
--

LOCK TABLES `client_addresses` WRITE;
/*!40000 ALTER TABLE `client_addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_contacts`
--

DROP TABLE IF EXISTS `client_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_contacts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_id` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_email` (`email`),
  CONSTRAINT `client_contacts_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_contacts`
--

LOCK TABLES `client_contacts` WRITE;
/*!40000 ALTER TABLE `client_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_custom_fields`
--

DROP TABLE IF EXISTS `client_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_custom_fields` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_id` bigint NOT NULL,
  `field_name` varchar(100) NOT NULL,
  `field_value` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_client_id` (`client_id`),
  CONSTRAINT `client_custom_fields_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_custom_fields`
--

LOCK TABLES `client_custom_fields` WRITE;
/*!40000 ALTER TABLE `client_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_feedback`
--

DROP TABLE IF EXISTS `client_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_id` bigint NOT NULL,
  `project_id` bigint DEFAULT NULL,
  `rating` decimal(2,1) NOT NULL,
  `feedback` text,
  `feedback_type` enum('PROJECT_COMPLETION','MILESTONE','GENERAL') DEFAULT 'GENERAL',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_client_feedback_client` (`client_id`),
  KEY `idx_client_feedback_project` (`project_id`),
  KEY `idx_client_feedback_rating` (`rating`),
  KEY `idx_client_feedback_created` (`created_at`),
  CONSTRAINT `fk_client_feedback_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_client_feedback_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `client_feedback_chk_1` CHECK (((`rating` >= 1.0) and (`rating` <= 5.0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_feedback`
--

LOCK TABLES `client_feedback` WRITE;
/*!40000 ALTER TABLE `client_feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `logo_url` varchar(500) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `company_size` varchar(50) DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_name` (`name`),
  KEY `idx_status` (`status`),
  KEY `idx_industry` (`industry`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (1,'Digital Marketing Agency','https://example.com/logo.png','hello@digitalagency.com','+1-555-987-6543','https://digitalagency.com','Marketing','50-100','ACTIVE','2025-07-24 16:21:36','2025-07-24 16:21:36','kohn.admin@aipm.com','kohn.admin@aipm.com'),(2,'Test Client',NULL,'client@example.com','123-456-7890',NULL,NULL,NULL,'ACTIVE','2025-07-27 19:40:24','2025-07-27 19:40:24','1',NULL);
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_mentions`
--

DROP TABLE IF EXISTS `comment_mentions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_mentions` (
  `comment_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  KEY `FKh07hvi19kedhwbv9ts8oc9p6a` (`comment_id`),
  CONSTRAINT `FKh07hvi19kedhwbv9ts8oc9p6a` FOREIGN KEY (`comment_id`) REFERENCES `task_comments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_mentions`
--

LOCK TABLES `comment_mentions` WRITE;
/*!40000 ALTER TABLE `comment_mentions` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_mentions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_reports`
--

DROP TABLE IF EXISTS `custom_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_reports` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `report_type` varchar(100) DEFAULT NULL,
  `data_sources` json DEFAULT NULL,
  `metrics` json DEFAULT NULL,
  `filters` json DEFAULT NULL,
  `visualization_config` json DEFAULT NULL,
  `schedule_config` json DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_report_type` (`report_type`),
  CONSTRAINT `custom_reports_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_reports`
--

LOCK TABLES `custom_reports` WRITE;
/*!40000 ALTER TABLE `custom_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard_metrics`
--

DROP TABLE IF EXISTS `dashboard_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dashboard_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `metric_type` varchar(100) NOT NULL,
  `metric_value` text NOT NULL,
  `calculated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_dashboard_metrics_user_type` (`user_id`,`metric_type`),
  KEY `idx_dashboard_metrics_expires` (`expires_at`),
  CONSTRAINT `fk_dashboard_metrics_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard_metrics`
--

LOCK TABLES `dashboard_metrics` WRITE;
/*!40000 ALTER TABLE `dashboard_metrics` DISABLE KEYS */;
/*!40000 ALTER TABLE `dashboard_metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_metadata`
--

DROP TABLE IF EXISTS `file_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_metadata` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_size` bigint NOT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `description` text,
  `project_id` bigint DEFAULT NULL,
  `task_id` bigint DEFAULT NULL,
  `uploaded_by` bigint NOT NULL,
  `download_count` int DEFAULT '0',
  `is_public` tinyint(1) DEFAULT '0',
  `tags` json DEFAULT NULL,
  `ai_analysis` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_uploaded_by` (`uploaded_by`),
  KEY `idx_mime_type` (`mime_type`),
  CONSTRAINT `file_metadata_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `file_metadata_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `file_metadata_ibfk_3` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_metadata`
--

LOCK TABLES `file_metadata` WRITE;
/*!40000 ALTER TABLE `file_metadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flyway_schema_history`
--

DROP TABLE IF EXISTS `flyway_schema_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flyway_schema_history` (
  `installed_rank` int NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `flyway_schema_history_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flyway_schema_history`
--

LOCK TABLES `flyway_schema_history` WRITE;
/*!40000 ALTER TABLE `flyway_schema_history` DISABLE KEYS */;
INSERT INTO `flyway_schema_history` VALUES (1,'1','Create users table','SQL','V1__Create_users_table.sql',-752975873,'root','2025-07-21 17:01:20',238,1),(2,'2','Create clients table','SQL','V2__Create_clients_table.sql',1234062445,'root','2025-07-21 17:01:21',217,1),(3,'3','Create projects table','SQL','V3__Create_projects_table.sql',1122435203,'root','2025-07-21 17:01:21',231,1),(4,'4','Create tasks table','SQL','V4__Create_tasks_table.sql',-1667399367,'root','2025-07-21 17:01:21',266,1),(5,'5','Create ai tables','SQL','V5__Create_ai_tables.sql',-997268465,'root','2025-07-21 17:01:22',199,1),(6,'6','Create communication tables','SQL','V6__Create_communication_tables.sql',166996262,'root','2025-07-21 17:01:22',215,1),(7,'7','Create files and analytics tables','SQL','V7__Create_files_and_analytics_tables.sql',-217329271,'root','2025-07-21 17:01:22',285,1),(8,'8','Create dashboard tables','SQL','V8__Create_dashboard_tables.sql',-1188397538,'root','2025-07-23 17:52:24',351,0);
/*!40000 ALTER TABLE `flyway_schema_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kpi_metrics`
--

DROP TABLE IF EXISTS `kpi_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kpi_metrics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `metric_date` date NOT NULL,
  `total_active_projects` int DEFAULT '0',
  `total_clients` int DEFAULT '0',
  `team_utilization` decimal(5,2) DEFAULT '0.00',
  `monthly_revenue` decimal(12,2) DEFAULT '0.00',
  `completed_tasks` int DEFAULT '0',
  `overdue_tasks` int DEFAULT '0',
  `average_task_completion_time` decimal(5,2) DEFAULT '0.00',
  `client_satisfaction_score` decimal(3,2) DEFAULT '0.00',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `metric_date` (`metric_date`),
  KEY `idx_kpi_metrics_date` (`metric_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kpi_metrics`
--

LOCK TABLES `kpi_metrics` WRITE;
/*!40000 ALTER TABLE `kpi_metrics` DISABLE KEYS */;
/*!40000 ALTER TABLE `kpi_metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message_threads`
--

DROP TABLE IF EXISTS `message_threads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message_threads` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` enum('PROJECT','DIRECT','TEAM') NOT NULL DEFAULT 'PROJECT',
  `title` varchar(255) DEFAULT NULL,
  `project_id` bigint DEFAULT NULL,
  `is_pinned` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_type` (`type`),
  CONSTRAINT `message_threads_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `message_threads_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_threads`
--

LOCK TABLES `message_threads` WRITE;
/*!40000 ALTER TABLE `message_threads` DISABLE KEYS */;
/*!40000 ALTER TABLE `message_threads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `thread_id` bigint NOT NULL,
  `author_id` bigint NOT NULL,
  `content` text NOT NULL,
  `mentions` json DEFAULT NULL,
  `attachments` json DEFAULT NULL,
  `reactions` json DEFAULT NULL,
  `edited_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_thread_id` (`thread_id`),
  KEY `idx_author_id` (`author_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`thread_id`) REFERENCES `message_threads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `type` enum('TASK_ASSIGNED','TASK_COMPLETED','PROJECT_UPDATE','MENTION','DEADLINE_REMINDER','AI_SUGGESTION') NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text,
  `data` json DEFAULT NULL,
  `priority` enum('LOW','MEDIUM','HIGH') DEFAULT 'MEDIUM',
  `is_read` tinyint(1) DEFAULT '0',
  `read_at` timestamp NULL DEFAULT NULL,
  `actions` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_type` (`type`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `token` varchar(500) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `is_used` bit(1) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_token` (`token`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_documents`
--

DROP TABLE IF EXISTS `project_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_documents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `file_path` varchar(255) DEFAULT NULL,
  `file_size` bigint DEFAULT NULL,
  `file_type` varchar(100) DEFAULT NULL,
  `version` varchar(50) DEFAULT NULL,
  `uploaded_by` bigint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `completed_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_documents_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_documents`
--

LOCK TABLES `project_documents` WRITE;
/*!40000 ALTER TABLE `project_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_health_tracking`
--

DROP TABLE IF EXISTS `project_health_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_health_tracking` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL,
  `health_score` decimal(3,1) NOT NULL DEFAULT '5.0',
  `status` enum('HEALTHY','AT_RISK','CRITICAL','ON_HOLD','COMPLETED') DEFAULT 'HEALTHY',
  `risk_factors` text,
  `calculated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_project_health_project` (`project_id`),
  KEY `idx_project_health_status` (`status`),
  KEY `idx_project_health_calculated` (`calculated_at`),
  CONSTRAINT `fk_project_health_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_health_tracking`
--

LOCK TABLES `project_health_tracking` WRITE;
/*!40000 ALTER TABLE `project_health_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_health_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_milestones`
--

DROP TABLE IF EXISTS `project_milestones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_milestones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `due_date` date NOT NULL,
  `status` enum('PENDING','IN_PROGRESS','COMPLETED','OVERDUE') NOT NULL DEFAULT 'PENDING',
  `progress` decimal(5,2) DEFAULT '0.00',
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(45) DEFAULT NULL,
  `is_completed` tinyint DEFAULT '0',
  `progress_percentage` decimal(10,0) DEFAULT '0',
  `updated_by` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_due_date` (`due_date`),
  KEY `idx_status` (`status`),
  CONSTRAINT `project_milestones_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_milestones`
--

LOCK TABLES `project_milestones` WRITE;
/*!40000 ALTER TABLE `project_milestones` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_milestones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_team_members`
--

DROP TABLE IF EXISTS `project_team_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_team_members` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `role` varchar(100) DEFAULT NULL,
  `allocation_percentage` decimal(5,2) DEFAULT '100.00',
  `hourly_rate` decimal(10,2) DEFAULT NULL,
  `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `left_at` timestamp NULL DEFAULT NULL,
  `assigned_by` bigint DEFAULT NULL,
  `assigned_date` date DEFAULT (curdate()),
  `removed_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_project_user` (`project_id`,`user_id`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `project_team_members_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `project_team_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_team_members`
--

LOCK TABLES `project_team_members` WRITE;
/*!40000 ALTER TABLE `project_team_members` DISABLE KEYS */;
INSERT INTO `project_team_members` VALUES (3,6,2,'PROJECT_MANAGER',NULL,NULL,'2025-07-31 15:07:58',NULL,1,'2025-08-01',NULL,'2025-07-31 15:07:58','2025-07-31 15:07:58');
/*!40000 ALTER TABLE `project_team_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_templates`
--

DROP TABLE IF EXISTS `project_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_templates` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `industry` varchar(100) DEFAULT NULL,
  `template_data` json DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `usage_count` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `idx_name` (`name`),
  KEY `idx_industry` (`industry`),
  CONSTRAINT `project_templates_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_templates`
--

LOCK TABLES `project_templates` WRITE;
/*!40000 ALTER TABLE `project_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `client_id` bigint NOT NULL,
  `manager_id` bigint DEFAULT NULL,
  `status` enum('PLANNING','IN_PROGRESS','ON_HOLD','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PLANNING',
  `priority` enum('LOW','MEDIUM','HIGH','CRITICAL') NOT NULL DEFAULT 'MEDIUM',
  `progress` decimal(5,2) DEFAULT '0.00',
  `budget` decimal(15,2) DEFAULT NULL,
  `spent` decimal(15,2) DEFAULT '0.00',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `actual_start_date` date DEFAULT NULL,
  `actual_end_date` date DEFAULT NULL,
  `ai_health_score` decimal(3,1) DEFAULT NULL,
  `ai_risk_level` enum('LOW','MEDIUM','HIGH') DEFAULT 'LOW',
  `tags` json DEFAULT NULL,
  `custom_fields` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `actual_hours` decimal(10,2) DEFAULT '0.00',
  `estimated_hours` decimal(10,2) DEFAULT '0.00',
  `progress_percentage` decimal(10,2) DEFAULT '0.00',
  `project_manager_id` decimal(10,2) DEFAULT '0.00',
  `spent_amount` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_manager_id` (`manager_id`),
  KEY `idx_status` (`status`),
  KEY `idx_priority` (`priority`),
  KEY `idx_start_date` (`start_date`),
  KEY `idx_end_date` (`end_date`),
  CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`manager_id`) REFERENCES `users` (`id`),
  CONSTRAINT `projects_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `projects_ibfk_4` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (6,'Mobile Banking App v2','Updated description',1,2,'IN_PROGRESS','HIGH',0.00,55000.00,NULL,'2025-08-01','2025-09-15',NULL,NULL,NULL,NULL,NULL,NULL,'2025-07-31 15:07:56','2025-07-31 17:35:24',1,1,0.00,0.00,0.00,0.00,NULL);
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subtasks`
--

DROP TABLE IF EXISTS `subtasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subtasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_task_id` bigint NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `assignee_id` bigint DEFAULT NULL,
  `status` enum('TODO','IN_PROGRESS','COMPLETED') NOT NULL DEFAULT 'TODO',
  `due_date` date DEFAULT NULL,
  `estimated_hours` decimal(8,2) DEFAULT NULL,
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `task_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_task_id` (`parent_task_id`),
  KEY `idx_assignee_id` (`assignee_id`),
  KEY `idx_status` (`status`),
  KEY `FKsvs126nsj9ohhvwjog5ddp76x` (`task_id`),
  CONSTRAINT `FKsvs126nsj9ohhvwjog5ddp76x` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`),
  CONSTRAINT `subtasks_ibfk_1` FOREIGN KEY (`parent_task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subtasks_ibfk_2` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subtasks`
--

LOCK TABLES `subtasks` WRITE;
/*!40000 ALTER TABLE `subtasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `subtasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_ai_suggestions`
--

DROP TABLE IF EXISTS `task_ai_suggestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_ai_suggestions` (
  `task_id` bigint NOT NULL,
  `suggestion` varchar(500) DEFAULT NULL,
  KEY `FKalydfkepfplp3o7vxtgjlmd1w` (`task_id`),
  CONSTRAINT `FKalydfkepfplp3o7vxtgjlmd1w` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_ai_suggestions`
--

LOCK TABLES `task_ai_suggestions` WRITE;
/*!40000 ALTER TABLE `task_ai_suggestions` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_ai_suggestions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_comments`
--

DROP TABLE IF EXISTS `task_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_comments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL,
  `parent_comment_id` bigint DEFAULT NULL,
  `author_id` bigint NOT NULL,
  `content` text NOT NULL,
  `mentions` json DEFAULT NULL,
  `attachments` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_author_id` (`author_id`),
  KEY `idx_parent_comment` (`parent_comment_id`),
  CONSTRAINT `task_comments_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_comments_ibfk_2` FOREIGN KEY (`parent_comment_id`) REFERENCES `task_comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_comments_ibfk_3` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_comments`
--

LOCK TABLES `task_comments` WRITE;
/*!40000 ALTER TABLE `task_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_dependencies`
--

DROP TABLE IF EXISTS `task_dependencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_dependencies` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dependent_task_id` bigint NOT NULL,
  `prerequisite_task_id` bigint NOT NULL,
  `dependency_type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `dependency_task_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_dependency` (`dependent_task_id`,`prerequisite_task_id`),
  UNIQUE KEY `UKl7q2ebvq4vtkyv07s2um8o4yd` (`dependent_task_id`,`dependency_task_id`),
  KEY `idx_dependent_task` (`dependent_task_id`),
  KEY `idx_prerequisite_task` (`prerequisite_task_id`),
  KEY `FK1ti6o1efapgjt45s0upt244rw` (`dependency_task_id`),
  CONSTRAINT `FK1ti6o1efapgjt45s0upt244rw` FOREIGN KEY (`dependency_task_id`) REFERENCES `tasks` (`id`),
  CONSTRAINT `task_dependencies_ibfk_1` FOREIGN KEY (`dependent_task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_dependencies_ibfk_2` FOREIGN KEY (`prerequisite_task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_dependencies`
--

LOCK TABLES `task_dependencies` WRITE;
/*!40000 ALTER TABLE `task_dependencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_dependencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_labels`
--

DROP TABLE IF EXISTS `task_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_labels` (
  `task_id` bigint NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  KEY `FK7wi3dfqb8gx9kiysuy980sbus` (`task_id`),
  CONSTRAINT `FK7wi3dfqb8gx9kiysuy980sbus` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_labels`
--

LOCK TABLES `task_labels` WRITE;
/*!40000 ALTER TABLE `task_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_reviews`
--

DROP TABLE IF EXISTS `task_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_reviews` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL,
  `reviewer_id` bigint NOT NULL,
  `rating` decimal(2,1) NOT NULL,
  `feedback` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_reviews` (`task_id`,`reviewer_id`),
  KEY `idx_task_reviews_task` (`task_id`),
  KEY `idx_task_reviews_reviewer` (`reviewer_id`),
  KEY `idx_task_reviews_rating` (`rating`),
  CONSTRAINT `fk_task_reviews_reviewer` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_task_reviews_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_reviews_chk_1` CHECK (((`rating` >= 1.0) and (`rating` <= 5.0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_reviews`
--

LOCK TABLES `task_reviews` WRITE;
/*!40000 ALTER TABLE `task_reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `project_id` bigint NOT NULL,
  `assignee_id` bigint DEFAULT NULL,
  `reporter_id` bigint DEFAULT NULL,
  `status` enum('BACKLOG','TODO','IN_PROGRESS','IN_REVIEW','TESTING','DONE','CANCELLED') NOT NULL DEFAULT 'BACKLOG',
  `priority` enum('LOW','MEDIUM','HIGH','CRITICAL') NOT NULL DEFAULT 'MEDIUM',
  `due_date` datetime(6) DEFAULT NULL,
  `estimated_hours` double DEFAULT NULL,
  `logged_hours` double DEFAULT NULL,
  `progress` int DEFAULT NULL,
  `labels` json DEFAULT NULL,
  `custom_fields` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reporter_id` (`reporter_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_assignee_id` (`assignee_id`),
  KEY `idx_status` (`status`),
  KEY `idx_priority` (`priority`),
  KEY `idx_due_date` (`due_date`),
  CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`),
  CONSTRAINT `tasks_ibfk_3` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`),
  CONSTRAINT `tasks_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `tasks_ibfk_5` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_members`
--

DROP TABLE IF EXISTS `team_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_members` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `team_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `role` varchar(100) DEFAULT NULL,
  `status` enum('active','inactive','pending') DEFAULT 'active',
  `availability` enum('available','busy','away') DEFAULT 'available',
  `hourly_rate` decimal(10,2) DEFAULT NULL,
  `capacity` int DEFAULT '40',
  `hire_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_team_user` (`team_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `team_members_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `team_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_members`
--

LOCK TABLES `team_members` WRITE;
/*!40000 ALTER TABLE `team_members` DISABLE KEYS */;
INSERT INTO `team_members` VALUES (1,1,2,'Principal tester','active','away',80.00,40,'2023-04-15','2025-08-01 02:12:19','2025-08-01 02:12:19'),(2,1,3,'ML Scientist','active','busy',90.00,40,'2023-05-01','2025-08-01 02:12:19','2025-08-01 02:12:19'),(3,2,2,'Backend Developer','active','available',75.00,40,'2023-08-10','2025-08-01 02:12:19','2025-08-01 02:12:19'),(4,2,4,'Frontend Developer','active','away',70.00,30,'2024-01-12','2025-08-01 02:12:19','2025-08-01 02:12:19'),(5,2,1,'Frontend Developer','active','available',NULL,40,NULL,'2025-07-31 21:38:32','2025-07-31 21:38:32');
/*!40000 ALTER TABLE `team_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `department` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `manager_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `manager_id` (`manager_id`),
  CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`manager_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,'AI Research','AI-focused research team','R&D','2025-08-01 02:12:19','2025-08-01 02:12:19',1),(2,'Product Team','Develops core products','Engineering','2025-08-01 02:12:19','2025-08-01 02:12:19',1);
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thread_participants`
--

DROP TABLE IF EXISTS `thread_participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thread_participants` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `thread_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_read_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_thread_participant` (`thread_id`,`user_id`),
  KEY `idx_thread_id` (`thread_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `thread_participants_ibfk_1` FOREIGN KEY (`thread_id`) REFERENCES `message_threads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `thread_participants_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thread_participants`
--

LOCK TABLES `thread_participants` WRITE;
/*!40000 ALTER TABLE `thread_participants` DISABLE KEYS */;
/*!40000 ALTER TABLE `thread_participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_tracking`
--

DROP TABLE IF EXISTS `time_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_tracking` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `hours` double NOT NULL,
  `description` text,
  `date` date NOT NULL,
  `billable` tinyint(1) DEFAULT '1',
  `hourly_rate` double DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_date` (`date`),
  CONSTRAINT `time_tracking_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `time_tracking_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_tracking`
--

LOCK TABLES `time_tracking` WRITE;
/*!40000 ALTER TABLE `time_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `time_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_certifications`
--

DROP TABLE IF EXISTS `user_certifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_certifications` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `issuer` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_certifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_certifications`
--

LOCK TABLES `user_certifications` WRITE;
/*!40000 ALTER TABLE `user_certifications` DISABLE KEYS */;
INSERT INTO `user_certifications` VALUES (1,2,'AWS Certified ML','Amazon','2022-06-10','2025-06-10'),(2,3,'Data Science Professional','Coursera','2023-01-15',NULL),(3,4,'Frontend Specialist','Google','2021-09-01','2024-09-01');
/*!40000 ALTER TABLE `user_certifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_performance`
--

DROP TABLE IF EXISTS `user_performance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_performance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `overall_score` decimal(3,2) DEFAULT NULL,
  `tasks_completed` int DEFAULT NULL,
  `on_time_delivery` int DEFAULT NULL,
  `code_quality` decimal(3,2) DEFAULT NULL,
  `team_collaboration` decimal(3,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_performance_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_performance`
--

LOCK TABLES `user_performance` WRITE;
/*!40000 ALTER TABLE `user_performance` DISABLE KEYS */;
INSERT INTO `user_performance` VALUES (1,2,4.80,120,115,4.90,4.70,'2025-08-01 02:12:19'),(2,3,4.40,98,90,4.50,4.30,'2025-08-01 02:12:19'),(3,4,4.60,110,105,4.70,4.80,'2025-08-01 02:12:19');
/*!40000 ALTER TABLE `user_performance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permissions`
--

DROP TABLE IF EXISTS `user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_permissions` (
  `user_id` bigint NOT NULL,
  `permission` varchar(255) DEFAULT NULL,
  KEY `FKkowxl8b2bngrxd1gafh13005u` (`user_id`),
  CONSTRAINT `FKkowxl8b2bngrxd1gafh13005u` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permissions`
--

LOCK TABLES `user_permissions` WRITE;
/*!40000 ALTER TABLE `user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_preferences`
--

DROP TABLE IF EXISTS `user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_preferences` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `theme` varchar(20) DEFAULT 'light',
  `date_format` varchar(20) DEFAULT 'MM/DD/YYYY',
  `time_format` varchar(5) DEFAULT '12',
  `items_per_page` int DEFAULT '20',
  `email_notifications` json DEFAULT NULL,
  `push_notifications` json DEFAULT NULL,
  `digest_frequency` enum('NEVER','DAILY','WEEKLY') DEFAULT 'DAILY',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_preference` (`user_id`),
  CONSTRAINT `user_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preferences`
--

LOCK TABLES `user_preferences` WRITE;
/*!40000 ALTER TABLE `user_preferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `refresh_token` varchar(500) NOT NULL,
  `device_info` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `revoked_at` datetime(6) DEFAULT NULL,
  `revoked_reason` varchar(255) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_refresh_token` (`refresh_token`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
INSERT INTO `user_sessions` VALUES (1,1,'0ab202fd-21ea-487f-85fa-ebddf25ca95d',NULL,'0:0:0:0:0:0:0:1','2025-08-03 16:22:21','2025-07-27 16:22:21','system','2025-07-27 21:52:21.078832','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(2,1,'7a35cd8e-e78a-4141-8ec5-32c30a3b4ab7',NULL,'0:0:0:0:0:0:0:1','2025-08-04 13:59:41','2025-07-28 13:59:41','system','2025-07-28 19:29:40.633097','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(3,1,'341b5fa2-bef7-4932-a273-31a8a0fee412',NULL,'0:0:0:0:0:0:0:1','2025-08-04 14:45:37','2025-07-28 14:45:37','system','2025-07-28 20:15:37.447417','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(4,1,'46a7918a-ac26-4df1-bdfa-e532eeee7fd2',NULL,'0:0:0:0:0:0:0:1','2025-08-04 14:45:47','2025-07-28 14:45:47','system','2025-07-28 20:15:46.862364','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(5,1,'008d99a9-a5ce-4e2c-bb4b-b347d4e41d5b',NULL,'0:0:0:0:0:0:0:1','2025-08-06 19:24:59','2025-07-30 19:25:00','system','2025-07-31 00:54:59.522751','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(6,1,'72713c1f-e815-44aa-9492-d024d106ec73',NULL,'0:0:0:0:0:0:0:1','2025-08-06 19:49:35','2025-07-30 19:49:35','system','2025-07-31 01:19:35.075807','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(7,1,'7066b9d0-6824-43c6-9afb-f3ec034e1a9a',NULL,'0:0:0:0:0:0:0:1','2025-08-07 03:48:26','2025-07-31 03:48:26','system','2025-07-31 09:18:25.694619','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(8,1,'e0481f20-9185-44ae-b1bf-c9acbe0efbe7',NULL,'0:0:0:0:0:0:0:1','2025-08-07 06:36:38','2025-07-31 06:36:38','system','2025-07-31 12:06:38.111351','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(9,1,'2a244c0a-60bc-442d-8dae-61246f831f0b',NULL,'0:0:0:0:0:0:0:1','2025-08-07 07:22:25','2025-07-31 07:22:25','system','2025-07-31 12:52:25.166764','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(10,1,'f1270630-a9db-42d5-8e15-d4b439643bbe',NULL,'0:0:0:0:0:0:0:1','2025-08-07 14:07:15','2025-07-31 14:07:15','system','2025-07-31 19:37:14.991581','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(11,1,'c1f644e0-44d9-407c-ad12-046842f5572b',NULL,'0:0:0:0:0:0:0:1','2025-08-07 14:26:29','2025-07-31 14:26:29','system','2025-07-31 19:56:29.175188','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(12,1,'b102ab72-cf59-418d-94ac-928d0f69e8de',NULL,'0:0:0:0:0:0:0:1','2025-08-07 14:42:32','2025-07-31 14:42:32','system','2025-07-31 20:12:32.020490','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(13,1,'10d657dd-197c-45ae-9d7c-3f21fa18202b',NULL,'0:0:0:0:0:0:0:1','2025-08-07 15:05:41','2025-07-31 15:05:41','system','2025-07-31 20:35:40.916284','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(14,1,'1a5ca1d3-89c1-4298-a6d0-db43103996e4',NULL,'0:0:0:0:0:0:0:1','2025-08-07 15:41:29','2025-07-31 15:41:29','system','2025-07-31 21:11:29.194050','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(15,1,'15c3bb51-0d34-4bdf-a75b-c6c489f2fbfa',NULL,'0:0:0:0:0:0:0:1','2025-08-07 16:21:48','2025-07-31 16:21:48','system','2025-07-31 21:51:47.930937','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(16,1,'54a8cdc7-fb73-4969-92f2-27f067474500',NULL,'0:0:0:0:0:0:0:1','2025-08-07 16:33:06','2025-07-31 16:33:06','system','2025-07-31 22:03:06.219143','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(17,1,'f67276aa-0376-4482-a9fa-8d7c427798e3',NULL,'0:0:0:0:0:0:0:1','2025-08-07 16:42:02','2025-07-31 16:42:02','system','2025-07-31 22:12:02.057227','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(18,1,'566f3527-63f4-435c-82b8-ae3b6aa84c92',NULL,'0:0:0:0:0:0:0:1','2025-08-07 20:33:20','2025-07-31 20:33:20','system','2025-08-01 02:03:19.969129','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(19,1,'a1486d61-4485-423d-98d1-0c6638309425',NULL,'0:0:0:0:0:0:0:1','2025-08-07 20:51:35','2025-07-31 20:51:35','system','2025-08-01 02:21:34.794281','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(20,1,'f816fef9-1025-4c15-901f-0883405bbaa9',NULL,'0:0:0:0:0:0:0:1','2025-08-07 21:30:44','2025-07-31 21:30:44','system','2025-08-01 03:00:44.056480','system',_binary '',NULL,NULL,'PostmanRuntime/7.44.1'),(21,1,'d2a1fd25-33bb-468f-9a04-7a569954966b',NULL,'0:0:0:0:0:0:0:1','2025-08-08 05:03:14','2025-08-01 05:03:14','system','2025-08-01 10:33:14.492345','system',_binary '',NULL,NULL,'PostmanRuntime/7.45.0'),(22,1,'9826ea83-ebde-4cd9-81df-88e76dc7f6c2',NULL,'0:0:0:0:0:0:0:1','2025-08-09 04:11:14','2025-08-02 04:11:14','system','2025-08-02 09:41:14.127708','system',_binary '',NULL,NULL,'PostmanRuntime/7.45.0'),(23,1,'5e88bfbc-3a7c-4171-b3ae-ddf1209f0c5a',NULL,'0:0:0:0:0:0:0:1','2025-08-09 04:39:50','2025-08-02 04:39:50','system','2025-08-02 10:09:49.871068','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(24,1,'74e7787b-7e71-40fa-92e5-4e62d613bf0f',NULL,'0:0:0:0:0:0:0:1','2025-08-09 04:40:12','2025-08-02 04:40:12','system','2025-08-02 10:10:12.429092','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(25,1,'6f94af5b-42aa-4d3d-9a3d-7f4de6b8d51e',NULL,'0:0:0:0:0:0:0:1','2025-08-09 04:41:08','2025-08-02 04:41:08','system','2025-08-02 10:11:08.306163','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(26,1,'21875554-6ddb-4791-9881-069d7a6f823d',NULL,'0:0:0:0:0:0:0:1','2025-08-09 05:35:58','2025-08-02 05:35:58','system','2025-08-02 11:05:57.534737','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(27,1,'5a1f0e0f-01e1-42ee-9499-bbbc47203431',NULL,'0:0:0:0:0:0:0:1','2025-08-09 05:41:02','2025-08-02 05:41:02','system','2025-08-02 11:11:01.796293','system',_binary '',NULL,NULL,'PostmanRuntime/7.45.0'),(28,1,'b921f7e3-a502-419c-af62-80d0b47e0017',NULL,'0:0:0:0:0:0:0:1','2025-08-09 05:50:23','2025-08-02 05:50:23','system','2025-08-02 11:20:23.003719','system',_binary '',NULL,NULL,'PostmanRuntime/7.45.0'),(29,1,'64872d10-fc78-45dd-8e86-999f33437665',NULL,'0:0:0:0:0:0:0:1','2025-08-09 05:51:37','2025-08-02 05:51:37','system','2025-08-02 11:21:36.695141','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(30,1,'3625bfb7-a831-4f4a-bc2d-26ee1b9fab52',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:04:05','2025-08-02 11:04:05','system','2025-08-02 16:34:05.383419','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(31,1,'89c7593e-932d-4687-a0cd-71c4a250e919',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:13:40','2025-08-02 11:13:40','system','2025-08-02 16:43:39.981341','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(32,1,'f7290f9f-736f-4c27-b4b8-accbbbbba5d6',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:14:05','2025-08-02 11:14:05','system','2025-08-02 16:44:05.050010','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(33,1,'41adacbe-d44d-44cd-9984-e37d4cae99ba',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:15:29','2025-08-02 11:15:29','system','2025-08-02 16:45:29.355321','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(34,1,'252a6f3c-0ee3-4889-a5a7-b814eb930758',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:19:24','2025-08-02 11:19:24','system','2025-08-02 16:49:24.114595','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(35,1,'450492c4-6742-44ce-a43b-43b5048d6552',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:28:21','2025-08-02 11:28:21','system','2025-08-02 16:58:21.375147','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(36,1,'fbdf8c42-84ba-476d-9e25-910718b14123',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:37:25','2025-08-02 11:37:25','system','2025-08-02 17:07:24.727431','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(37,1,'7e366e4c-6335-4883-8c73-60e307b57813',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:38:55','2025-08-02 11:38:55','system','2025-08-02 17:08:55.411346','system',_binary '',NULL,NULL,'PostmanRuntime/7.45.0'),(38,1,'33114892-055b-400c-b077-0d02befe7377',NULL,'0:0:0:0:0:0:0:1','2025-08-09 11:39:05','2025-08-02 11:39:05','system','2025-08-02 17:09:05.129504','system',_binary '',NULL,NULL,'PostmanRuntime/7.45.0'),(39,1,'d7677275-4059-4842-a6b5-396a2d6508d7',NULL,'0:0:0:0:0:0:0:1','2025-08-09 12:34:54','2025-08-02 12:34:54','system','2025-08-02 18:04:54.125002','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(40,1,'3d7056ed-a214-4682-802a-489c89a405af',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:22:56','2025-08-02 14:22:56','system','2025-08-02 19:52:55.544621','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(41,1,'540d30af-43e0-4c68-8ea3-0e63c7d86da8',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:23:00','2025-08-02 14:23:00','system','2025-08-02 19:52:59.556397','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(42,1,'05a5f893-472a-4076-86a8-ad82548eaddb',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:24:36','2025-08-02 14:24:36','system','2025-08-02 19:54:35.546897','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(43,1,'14271381-57b0-4191-b366-c38b7fc715af',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:26:53','2025-08-02 14:26:53','system','2025-08-02 19:56:52.650654','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(44,1,'40c7bf5d-f069-4950-a34f-f23f0c8f60c9',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:26:55','2025-08-02 14:26:55','system','2025-08-02 19:56:55.366759','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(45,1,'fa5486c1-7311-4fca-abf3-7f4df9e1aa5c',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:29:42','2025-08-02 14:29:42','system','2025-08-02 19:59:42.361443','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(46,1,'b8348092-6d06-401f-9e6a-88c144f9cf1a',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:35:08','2025-08-02 14:35:08','system','2025-08-02 20:05:08.200611','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(47,1,'c1626aff-253b-4803-8fc0-0a138c656f52',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:35:51','2025-08-02 14:35:51','system','2025-08-02 20:05:51.196584','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(48,1,'aa12f564-8ce2-453e-b686-e56dcf41f330',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:35:53','2025-08-02 14:35:53','system','2025-08-02 20:05:53.438832','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(49,1,'f00e5090-1a8e-4ae8-b706-9bbffd76d44a',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:37:20','2025-08-02 14:37:20','system','2025-08-02 20:07:20.244164','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'),(50,1,'cf8cecde-d275-4c89-ae4b-298515af267c',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:41:15','2025-08-02 14:41:15','system','2025-08-02 20:11:15.277150','system',_binary '',NULL,NULL,'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'),(51,1,'0954d142-9ee8-411c-bc93-6b2331204d4f',NULL,'0:0:0:0:0:0:0:1','2025-08-09 14:43:12','2025-08-02 14:43:12','system','2025-08-02 20:13:12.258085','system',_binary '',NULL,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36');
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_skills`
--

DROP TABLE IF EXISTS `user_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_skills` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `name` varchar(100) NOT NULL,
  `level` enum('beginner','intermediate','advanced','expert') DEFAULT 'beginner',
  `years_experience` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_skills_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_skills`
--

LOCK TABLES `user_skills` WRITE;
/*!40000 ALTER TABLE `user_skills` DISABLE KEYS */;
INSERT INTO `user_skills` VALUES (1,2,'Python','expert',5),(2,2,'Machine Learning','advanced',4),(3,3,'Data Analysis','advanced',3),(4,3,'Deep Learning','intermediate',2),(5,4,'JavaScript','expert',6),(6,4,'React','advanced',4);
/*!40000 ALTER TABLE `user_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `role` enum('ADMIN','PROJECT_MANAGER','TEAM_MEMBER','CLIENT') NOT NULL DEFAULT 'TEAM_MEMBER',
  `status` enum('ACTIVE','INACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
  `phone` varchar(20) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `timezone` varchar(50) DEFAULT 'UTC',
  `language` varchar(10) DEFAULT 'en',
  `email_verified` tinyint(1) DEFAULT '0',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `password_changed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `last_login` datetime(6) DEFAULT NULL,
  `locked_until` datetime(6) DEFAULT NULL,
  `login_attempts` int DEFAULT NULL,
  `two_factor_enabled` bit(1) DEFAULT NULL,
  `two_factor_secret` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@example.com','$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG','Admin User',NULL,'ADMIN','ACTIVE',NULL,NULL,'UTC','en',0,NULL,NULL,'2025-07-27 20:26:57','2025-08-02 14:43:12',NULL,'system',1,0,'2025-08-02 20:13:12.258085',NULL,0,_binary '','0',1),(2,'pm@example.com','$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG','Project Manager',NULL,'PROJECT_MANAGER','ACTIVE',NULL,NULL,'UTC','en',0,NULL,NULL,'2025-07-27 20:26:57','2025-08-01 02:34:02',NULL,NULL,1,0,NULL,NULL,0,_binary '','0',1),(3,'team@example.com','$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG','Team Member',NULL,'TEAM_MEMBER','ACTIVE',NULL,NULL,'UTC','en',0,NULL,NULL,'2025-07-27 20:26:57','2025-08-01 02:34:02',NULL,NULL,1,0,NULL,NULL,0,_binary '','0',1),(4,'alice.manager@example.com','$2a$10$dummyhashAlice','Alice Manager','https://randomuser.me/api/portraits/women/1.jpg','PROJECT_MANAGER','ACTIVE','+911234567890','Delhi, India','Asia/Kolkata','en',1,'2025-07-31 03:00:00','2025-07-15 04:30:00','2025-08-01 02:12:19','2025-08-01 02:34:02',NULL,NULL,1,0,NULL,NULL,0,_binary '','0',1),(5,'bob.member@example.com','$2a$10$dummyhashBob','Bob Member','https://randomuser.me/api/portraits/men/2.jpg','TEAM_MEMBER','ACTIVE','+919812345678','Mumbai, India','Asia/Kolkata','en',1,'2025-07-30 12:40:00','2025-07-10 03:30:00','2025-08-01 02:12:19','2025-08-01 02:34:02',NULL,NULL,1,0,NULL,NULL,0,_binary '','0',1),(6,'charlie.member@example.com','$2a$10$dummyhashCharlie','Charlie Member','https://randomuser.me/api/portraits/men/3.jpg','TEAM_MEMBER','ACTIVE','+917878787878','Bangalore, India','Asia/Kolkata','en',0,NULL,NULL,'2025-08-01 02:12:19','2025-08-01 02:34:02',NULL,NULL,1,0,NULL,NULL,0,_binary '','0',1),(7,'david.member@example.com','$2a$10$dummyhashDavid','David Member','https://randomuser.me/api/portraits/men/4.jpg','TEAM_MEMBER','INACTIVE','+915555555555','Chennai, India','Asia/Kolkata','en',0,NULL,NULL,'2025-08-01 02:12:19','2025-08-01 02:34:02',NULL,NULL,1,0,NULL,NULL,0,_binary '','0',1),(8,'eve.client@example.com','$2a$10$dummyhashEve','Eve Client','https://randomuser.me/api/portraits/women/5.jpg','CLIENT','ACTIVE',NULL,'London, UK','Europe/London','en',1,'2025-07-28 08:30:00',NULL,'2025-08-01 02:12:19','2025-08-01 02:34:02',NULL,NULL,1,0,NULL,NULL,0,_binary '','0',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-03 20:13:29
