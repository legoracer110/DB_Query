-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema hw04
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema hw04
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hw04` DEFAULT CHARACTER SET utf8 ;
USE `hw04` ;

-- -----------------------------------------------------
-- Table `hw04`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hw04`.`customer` ;

CREATE TABLE IF NOT EXISTS `hw04`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `customer_name` VARCHAR(10) NULL,
  `customer_address` VARCHAR(45) NULL,
  `customer_tel1` VARCHAR(15) NULL,
  `customer_tel2` VARCHAR(15) NULL,
  `order_id` INT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hw04`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hw04`.`order` ;

CREATE TABLE IF NOT EXISTS `hw04`.`order` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `order_date` TIMESTAMP NULL,
  `customer_id` INT NULL,
  PRIMARY KEY (`order_id`),
  CONSTRAINT `order_customer_id_fk`
    FOREIGN KEY (`order_id`)
    REFERENCES `hw04`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hw04`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hw04`.`product` ;

CREATE TABLE IF NOT EXISTS `hw04`.`product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(20) NULL,
  `product_price` INT NULL,
  PRIMARY KEY (`product_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hw04`.`order_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hw04`.`order_detail` ;

CREATE TABLE IF NOT EXISTS `hw04`.`order_detail` (
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `cnt` INT NULL,
  `delivery` TINYINT NULL,
  `paid` TINYINT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `order_detail_product_id_fk_idx` (`product_id` ASC),
  CONSTRAINT `order_detail_order_id_fk`
    FOREIGN KEY (`order_id`)
    REFERENCES `hw04`.`order` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_detail_product_id_fk`
    FOREIGN KEY (`product_id`)
    REFERENCES `hw04`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
