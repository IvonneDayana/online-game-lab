CREATE DATABASE IF NOT EXISTS online_game;
USE online_game;

CREATE TABLE `game` (
  `game_id` int unsigned NOT NULL AUTO_INCREMENT,
  `game_name` varchar(150) NOT NULL,
  PRIMARY KEY (`game_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `genre` (
  `genre_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `genre_name` varchar(30) NOT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE KEY `genre_name` (`genre_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `platform` (
  `platform_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `platform_name` varchar(10) NOT NULL,
  PRIMARY KEY (`platform_id`),
  UNIQUE KEY `platform_name` (`platform_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `publisher` (
  `publisher_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `publisher_name` varchar(100) NOT NULL,
  PRIMARY KEY (`publisher_id`),
  UNIQUE KEY `publisher_name` (`publisher_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `game_release` (
  `release_id` int unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int unsigned NOT NULL,
  `platform_id` tinyint unsigned NOT NULL,
  `genre_id` tinyint unsigned NOT NULL,
  `publisher_id` smallint unsigned DEFAULT NULL,
  `release_year` smallint DEFAULT NULL,
  `na_sales` decimal(6,2) NOT NULL DEFAULT '0.00',
  `eu_sales` decimal(6,2) NOT NULL DEFAULT '0.00',
  `jp_sales` decimal(6,2) NOT NULL DEFAULT '0.00',
  `other_sales` decimal(6,2) NOT NULL DEFAULT '0.00',
  `global_sales` decimal(6,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`release_id`),
  KEY `game_id` (`game_id`),
  KEY `platform_id` (`platform_id`),
  KEY `genre_id` (`genre_id`),
  KEY `publisher_id` (`publisher_id`),
  CONSTRAINT `game_release_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `game` (`game_id`),
  CONSTRAINT `game_release_ibfk_2` FOREIGN KEY (`platform_id`) REFERENCES `platform` (`platform_id`),
  CONSTRAINT `game_release_ibfk_3` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`),
  CONSTRAINT `game_release_ibfk_4` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`),
  CONSTRAINT `chk_release_sales` CHECK (((`na_sales` >= 0) and (`eu_sales` >= 0) and (`jp_sales` >= 0) and (`other_sales` >= 0) and (`global_sales` >= 0))),
  CONSTRAINT `chk_release_year` CHECK (((`release_year` is null) or (`release_year` between 1970 and 2030)))
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
