DROP DATABASE `KataManga`;
CREATE DATABASE IF NOT EXISTS `KataManga` DEFAULT CHARACTER SET utf8mb4;

USE `KataManga`;
SET NAMES utf8;
SET character_set_client = utf8;

SET SESSION sql_mode = '';

--
-- Table structure for table `author`
--
DROP TABLE IF EXISTS `author`;
CREATE TABLE `author` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `classify`
--
DROP TABLE IF EXISTS `classify`;
CREATE TABLE `classify` (
  `idmanga` int(11) NOT NULL,
  `idgenre` int(11) NOT NULL,
  PRIMARY KEY (`idmanga`,`idgenre`),
  KEY `fk_genre_idx` (`idgenre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `genre`
--
DROP TABLE IF EXISTS `genre`;
CREATE TABLE `genre` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `magazine`
--
DROP TABLE IF EXISTS `magazine`;
CREATE TABLE `magazine` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `manga`
--
DROP TABLE IF EXISTS `manga`;
CREATE TABLE `manga` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `synopsis` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `manga_id_IDX` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `publish`
--
DROP TABLE IF EXISTS `publish`;
CREATE TABLE `publish` (
  `idmanga` int(11) NOT NULL,
  `idmagazine` int(11) NOT NULL,
  PRIMARY KEY (`idmanga`,`idmagazine`),
  KEY `fk_magazine_idx` (`idmagazine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `write`
--
DROP TABLE IF EXISTS `write`;
CREATE TABLE `write` (
  `idmanga` int(11) NOT NULL,
  `idauthor` int(11) NOT NULL,
  `role` varchar(45) NOT NULL,
  PRIMARY KEY (`idmanga`,`idauthor`),
  KEY `fk_author_idx` (`idauthor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
