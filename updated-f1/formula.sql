-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 04, 2024 at 03:58 AM
-- Server version: 11.3.2-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `formula`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `all_drivers_view`
-- (See below for the actual view)
--
CREATE TABLE `all_drivers_view` (
`Driver_Name` varchar(40)
,`Nationality` varchar(40)
,`Age` int(11)
,`Team` varchar(40)
);

-- --------------------------------------------------------

--
-- Table structure for table `constructor_standings`
--

CREATE TABLE `constructor_standings` (
  `Pos` int(11) NOT NULL,
  `Team_id` varchar(40) DEFAULT NULL,
  `Team_Name` varchar(40) DEFAULT NULL,
  `Wins` int(11) DEFAULT NULL,
  `Podiums` int(11) DEFAULT NULL,
  `Total_Points` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `constructor_standings`
--

INSERT INTO `constructor_standings` (`Pos`, `Team_id`, `Team_Name`, `Wins`, `Podiums`, `Total_Points`) VALUES
(1, '#1004', 'Red Bull Racing', 21, 30, 860),
(2, '#1001', 'Mercedes', 0, 8, 409),
(3, '#1008', 'Ferrari', 1, 9, 406),
(4, '#1005', 'McLaren', 0, 9, 302),
(5, '#1006', 'Aston Martin', 0, 8, 280),
(6, '#1002', 'Alpine', 0, 2, 120),
(7, '#1010', 'Williams', 0, 0, 28),
(8, '#1007', 'Alphatauri', 0, 0, 25),
(9, '#1009', 'Alfa Romeo', 0, 0, 16),
(10, '#1003', 'Haas F1 Team', 0, 0, 12),
(11, '#1012', 'Audi', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `Driver_id` varchar(40) NOT NULL,
  `Driver_Name` varchar(40) NOT NULL,
  `Nationality` varchar(40) NOT NULL,
  `Age` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`Driver_id`, `Driver_Name`, `Nationality`, `Age`) VALUES
('#1', 'Max Verstappen', 'NED', 25),
('#10', 'Pierre Gasly', 'FRA', 27),
('#100', 'Ananth', 'Japan', 23),
('#11', 'Sergio Perez', 'MEX', 33),
('#14', 'Fernando Alonso', 'ESP', 41),
('#16', 'Charles Leclerc', 'MON', 25),
('#18', 'Lance Stroll', 'CAN', 24),
('#2', 'Logan Sargeant', 'USA', 22),
('#20', 'Kevin Magnussen', 'DEN', 30),
('#21', 'Nyck De Vries', 'NED', 28),
('#22', 'Yuki Tsunoda', 'JPN', 22),
('#23', 'Alexander Albon', 'THA', 26),
('#24', 'Zhou Guanyu', 'CHN', 23),
('#27', 'Nico Hulkenberg', 'GER', 35),
('#3', 'Daniel Ricciardo', 'AUS', 34),
('#31', 'Esteban Ocon', 'FRA', 26),
('#4', 'Lando Norris', 'GBR', 23),
('#40', 'Liam Lawson', 'NZL', 21),
('#44', 'Lewis Hamilton', 'GBR', 38),
('#55', 'Carlos Sainz', 'ESP', 28),
('#63', 'George Russell', 'GBR', 25),
('#77', 'Valtteri Bottas', 'FIN', 33),
('#81', 'Oscar Piastri', 'AUS', 21),
('#99', 'Sreedhar', 'Indian', 22);

--
-- Triggers `drivers`
--
DELIMITER $$
CREATE TRIGGER `after_driver_insert` AFTER INSERT ON `drivers` FOR EACH ROW BEGIN
    DECLARE max_pos INT;

    -- Calculate the next Pos value based on the highest Pos value in driver_standings table
    SELECT MAX(Pos) INTO max_pos FROM driver_standings;
    SET max_pos = IFNULL(max_pos, 0);
    INSERT INTO driver_standings (Pos, Driver_id, Driver_Name, Wins, Podiums, Total_points) 
    VALUES (max_pos + 1, NEW.Driver_Id, NEW.Driver_Name, 0, 0, 0);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `driver_standings`
--

CREATE TABLE `driver_standings` (
  `Pos` int(11) NOT NULL,
  `Driver_id` varchar(40) DEFAULT NULL,
  `Driver_Name` varchar(40) DEFAULT NULL,
  `Wins` int(11) DEFAULT NULL,
  `Podiums` int(11) DEFAULT NULL,
  `Total_Points` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `driver_standings`
--

INSERT INTO `driver_standings` (`Pos`, `Driver_id`, `Driver_Name`, `Wins`, `Podiums`, `Total_Points`) VALUES
(1, '#1', 'Max Verstappen', 19, 21, 575),
(2, '#11', 'Sergio Perez', 2, 9, 285),
(3, '#44', 'Lewis Hamilton', 0, 6, 234),
(4, '#14', 'Fernando Alonso', 0, 8, 206),
(5, '#16', 'Charles Leclerc', 0, 6, 206),
(6, '#4', 'Lando Norris', 0, 7, 205),
(7, '#55', 'Carlos Sainz', 1, 3, 200),
(8, '#63', 'George Russell', 0, 2, 175),
(9, '#81', 'Oscar Piastri', 0, 2, 97),
(10, '#18', 'Lance Stroll', 0, 0, 74),
(11, '#10', 'Pierre Gasly', 0, 1, 62),
(12, '#31', 'Esteban Ocon', 0, 1, 58),
(13, '#23', 'Alexander Albon', 0, 0, 27),
(14, '#22', 'Yuki Tsunoda', 0, 0, 17),
(15, '#77', 'Valtteri Bottas', 0, 0, 10),
(16, '#27', 'Nico Hulkenberg', 0, 0, 9),
(17, '#3', 'Daniel Ricciardo', 0, 0, 6),
(18, '#24', 'Zhou Guanyu', 0, 0, 6),
(19, '#20', 'Kevin Magnussen', 0, 0, 3),
(20, '#40', 'Liam Lawson', 0, 0, 2),
(21, '#2', 'Logan Sargeant', 0, 0, 1),
(22, '#21', 'Nyck De Vries', 0, 0, 0),
(23, '#99', 'Sreedhar', 0, 0, 0),
(24, '#100', 'Ananth', 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `races`
--

CREATE TABLE `races` (
  `Race_id` varchar(40) NOT NULL,
  `Race_Name` varchar(40) DEFAULT NULL,
  `Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `races`
--

INSERT INTO `races` (`Race_id`, `Race_Name`, `Date`) VALUES
('#1', 'Bahrain', '2023-03-05'),
('#10', 'Great Britain', '2023-07-09'),
('#11', 'Hungary', '2023-07-23'),
('#12', 'Belgium', '2023-07-30'),
('#13', 'Netherlands', '2023-08-27'),
('#14', 'Italy', '2023-09-03'),
('#15', 'Singapore', '2023-09-17'),
('#16', 'Japan', '2023-09-24'),
('#17', 'Qatar', '2023-10-08'),
('#18', 'United States', '2023-10-22'),
('#19', 'Mexico', '2023-10-29'),
('#2', 'Saudi Arabia', '2023-03-19'),
('#20', 'Brazil', '2023-11-05'),
('#21', 'Las Vegas', '2023-11-18'),
('#22', 'Abu Dhabi', '2023-11-26'),
('#3', 'Australia', '2023-04-02'),
('#4', 'Azerbaijan', '2023-04-30'),
('#5', 'Miami', '2023-05-07'),
('#6', 'Monaco', '2023-05-28'),
('#7', 'Spain', '2023-06-04'),
('#8', 'Canada', '2023-06-18'),
('#9', 'Austria', '2023-07-02');

-- --------------------------------------------------------

--
-- Table structure for table `results`
--

CREATE TABLE `results` (
  `Race_id` varchar(40) DEFAULT NULL,
  `Pos` int(11) NOT NULL,
  `Driver_id` varchar(40) DEFAULT NULL,
  `Team_id` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `results`
--

INSERT INTO `results` (`Race_id`, `Pos`, `Driver_id`, `Team_id`) VALUES
('#1', 1, '#1', '#1004'),
('#1', 2, '#11', '#1004'),
('#1', 3, '#14', '#1006'),
('#1', 4, '#55', '#1008'),
('#1', 5, '#44', '#1001'),
('#1', 6, '#18', '#1006'),
('#1', 7, '#63', '#1001'),
('#1', 8, '#77', '#1009'),
('#1', 9, '#10', '#1002'),
('#1', 10, '#23', '#1010'),
('#1', 11, '#22', '#1007'),
('#1', 12, '#2', '#1010'),
('#1', 13, '#20', '#1003'),
('#1', 14, '#21', '#1007'),
('#1', 15, '#27', '#1003'),
('#1', 16, '#24', '#1009'),
('#1', 17, '#4', '#1005'),
('#1', 18, '#31', '#1002'),
('#1', 19, '#16', '#1008'),
('#1', 20, '#81', '#1005'),
('#2', 1, '#11', '#1004'),
('#2', 2, '#1', '#1004'),
('#2', 3, '#14', '#1006'),
('#2', 4, '#63', '#1001'),
('#2', 5, '#44', '#1001'),
('#2', 6, '#55', '#1008'),
('#2', 7, '#16', '#1008'),
('#2', 8, '#31', '#1002'),
('#2', 9, '#10', '#1002'),
('#2', 10, '#20', '#1003'),
('#2', 11, '#22', '#1007'),
('#2', 12, '#27', '#1003'),
('#2', 13, '#24', '#1009'),
('#2', 14, '#21', '#1007'),
('#2', 15, '#81', '#1005'),
('#2', 16, '#2', '#1010'),
('#2', 17, '#4', '#1005'),
('#2', 18, '#77', '#1009'),
('#2', 19, '#23', '#1010'),
('#2', 20, '#18', '#1006'),
('#3', 1, '#1', '#1004'),
('#3', 2, '#44', '#1001'),
('#3', 3, '#14', '#1006'),
('#3', 4, '#18', '#1006'),
('#3', 5, '#11', '#1004'),
('#3', 6, '#4', '#1005'),
('#3', 7, '#27', '#1003'),
('#3', 8, '#81', '#1005'),
('#3', 9, '#24', '#1009'),
('#3', 10, '#22', '#1007'),
('#3', 11, '#77', '#1009'),
('#3', 12, '#55', '#1008'),
('#3', 13, '#10', '#1002'),
('#3', 14, '#31', '#1002'),
('#3', 15, '#21', '#1007'),
('#3', 16, '#2', '#1010'),
('#3', 17, '#20', '#1003'),
('#3', 18, '#63', '#1001'),
('#3', 19, '#23', '#1010'),
('#3', 20, '#16', '#1008'),
('#4', 1, '#11', '#1004'),
('#4', 2, '#1', '#1004'),
('#4', 3, '#16', '#1008'),
('#4', 4, '#14', '#1006'),
('#4', 5, '#55', '#1008'),
('#4', 6, '#44', '#1001'),
('#4', 7, '#18', '#1006'),
('#4', 8, '#63', '#1001'),
('#4', 9, '#4', '#1005'),
('#4', 10, '#22', '#1007'),
('#4', 11, '#81', '#1005'),
('#4', 12, '#23', '#1010'),
('#4', 13, '#20', '#1003'),
('#4', 14, '#10', '#1002'),
('#4', 15, '#31', '#1002'),
('#4', 16, '#2', '#1010'),
('#4', 17, '#27', '#1003'),
('#4', 18, '#77', '#1009'),
('#4', 19, '#24', '#1009'),
('#4', 20, '#21', '#1007'),
('#5', 1, '#1', '#1004'),
('#5', 2, '#11', '#1004'),
('#5', 3, '#14', '#1006'),
('#5', 4, '#63', '#1001'),
('#5', 5, '#55', '#1008'),
('#5', 6, '#44', '#1001'),
('#5', 7, '#16', '#1008'),
('#5', 8, '#10', '#1002'),
('#5', 9, '#31', '#1002'),
('#5', 10, '#20', '#1003'),
('#5', 11, '#22', '#1007'),
('#5', 12, '#18', '#1006'),
('#5', 13, '#77', '#1009'),
('#5', 14, '#23', '#1010'),
('#5', 15, '#27', '#1003'),
('#5', 16, '#24', '#1009'),
('#5', 17, '#4', '#1005'),
('#5', 18, '#21', '#1007'),
('#5', 19, '#81', '#1005'),
('#5', 20, '#2', '#1010'),
('#6', 1, '#1', '#1004'),
('#6', 2, '#14', '#1006'),
('#6', 3, '#31', '#1002'),
('#6', 4, '#44', '#1001'),
('#6', 5, '#63', '#1001'),
('#6', 6, '#16', '#1008'),
('#6', 7, '#10', '#1002'),
('#6', 8, '#55', '#1008'),
('#6', 9, '#4', '#1005'),
('#6', 10, '#81', '#1005'),
('#6', 11, '#77', '#1009'),
('#6', 12, '#21', '#1007'),
('#6', 13, '#24', '#1009'),
('#6', 14, '#23', '#1010'),
('#6', 15, '#22', '#1007'),
('#6', 16, '#11', '#1004'),
('#6', 17, '#27', '#1003'),
('#6', 18, '#2', '#1010'),
('#6', 19, '#20', '#1003'),
('#6', 20, '#18', '#1006'),
('#7', 1, '#1', '#1004'),
('#7', 2, '#44', '#1001'),
('#7', 3, '#63', '#1001'),
('#7', 4, '#11', '#1004'),
('#7', 5, '#55', '#1008'),
('#7', 6, '#18', '#1006'),
('#7', 7, '#14', '#1006'),
('#7', 8, '#31', '#1002'),
('#7', 9, '#24', '#1009'),
('#7', 10, '#10', '#1002'),
('#7', 11, '#16', '#1008'),
('#7', 12, '#22', '#1007'),
('#7', 13, '#81', '#1004'),
('#7', 14, '#21', '#1007'),
('#7', 15, '#27', '#1003'),
('#7', 16, '#23', '#1010'),
('#7', 17, '#4', '#1005'),
('#7', 18, '#20', '#1003'),
('#7', 19, '#77', '#1009'),
('#7', 20, '#2', '#1010'),
('#8', 1, '#1', '#1004'),
('#8', 2, '#14', '#1006'),
('#8', 3, '#44', '#1001'),
('#8', 4, '#16', '#1008'),
('#8', 5, '#55', '#1008'),
('#8', 6, '#11', '#1004'),
('#8', 7, '#23', '#1010'),
('#8', 8, '#31', '#1002'),
('#8', 9, '#18', '#1006'),
('#8', 10, '#77', '#1009'),
('#8', 11, '#81', '#1005'),
('#8', 12, '#10', '#1002'),
('#8', 13, '#4', '#1005'),
('#8', 14, '#22', '#1007'),
('#8', 15, '#27', '#1003'),
('#8', 16, '#24', '#1009'),
('#8', 17, '#20', '#1003'),
('#8', 18, '#21', '#1007'),
('#8', 19, '#63', '#1001'),
('#8', 20, '#2', '#1010'),
('#9', 1, '#1', '#1004'),
('#9', 2, '#16', '#1008'),
('#9', 3, '#11', '#1004'),
('#9', 4, '#4', '#1005'),
('#9', 5, '#14', '#1006'),
('#9', 6, '#55', '#1008'),
('#9', 7, '#63', '#1001'),
('#9', 8, '#44', '#1001'),
('#9', 9, '#18', '#1006'),
('#9', 10, '#10', '#1002'),
('#9', 11, '#23', '#1010'),
('#9', 12, '#24', '#1009'),
('#9', 13, '#2', '#1010'),
('#9', 14, '#31', '#1002'),
('#9', 15, '#77', '#1009'),
('#9', 16, '#81', '#1005'),
('#9', 17, '#21', '#1007'),
('#9', 18, '#20', '#1003'),
('#9', 19, '#22', '#1007'),
('#9', 20, '#27', '#1003'),
('#10', 1, '#1', '#1004'),
('#10', 2, '#4', '#1005'),
('#10', 3, '#44', '#1001'),
('#10', 4, '#81', '#1005'),
('#10', 5, '#63', '#1001'),
('#10', 6, '#11', '#1004'),
('#10', 7, '#14', '#1006'),
('#10', 8, '#23', '#1010'),
('#10', 9, '#16', '#1008'),
('#10', 10, '#55', '#1008'),
('#10', 11, '#2', '#1010'),
('#10', 12, '#77', '#1009'),
('#10', 13, '#27', '#1003'),
('#10', 14, '#18', '#1006'),
('#10', 15, '#24', '#1009'),
('#10', 16, '#22', '#1007'),
('#10', 17, '#21', '#1007'),
('#10', 18, '#10', '#1002'),
('#10', 19, '#20', '#1003'),
('#10', 20, '#31', '#1002'),
('#11', 1, '#1', '#1004'),
('#11', 2, '#4', '#1005'),
('#11', 3, '#11', '#1004'),
('#11', 4, '#44', '#1001'),
('#11', 5, '#81', '#1005'),
('#11', 6, '#63', '#1001'),
('#11', 7, '#16', '#1008'),
('#11', 8, '#55', '#1008'),
('#11', 9, '#14', '#1006'),
('#11', 10, '#18', '#1006'),
('#11', 11, '#23', '#1010'),
('#11', 12, '#77', '#1009'),
('#11', 13, '#3', '#1007'),
('#11', 14, '#27', '#1003'),
('#11', 15, '#22', '#1007'),
('#11', 16, '#24', '#1009'),
('#11', 17, '#20', '#1003'),
('#11', 18, '#2', '#1010'),
('#11', 19, '#31', '#1002'),
('#11', 20, '#10', '#1002'),
('#12', 1, '#1', '#1004'),
('#12', 2, '#11', '#1004'),
('#12', 3, '#16', '#1008'),
('#12', 4, '#44', '#1001'),
('#12', 5, '#14', '#1006'),
('#12', 6, '#63', '#1001'),
('#12', 7, '#4', '#1005'),
('#12', 8, '#31', '#1002'),
('#12', 9, '#18', '#1006'),
('#12', 10, '#22', '#1007'),
('#12', 11, '#10', '#1002'),
('#12', 12, '#77', '#1009'),
('#12', 13, '#24', '#1009'),
('#12', 14, '#23', '#1010'),
('#12', 15, '#20', '#1003'),
('#12', 16, '#3', '#1007'),
('#12', 17, '#2', '#1010'),
('#12', 18, '#27', '#1003'),
('#12', 19, '#55', '#1008'),
('#12', 20, '#81', '#1005'),
('#13', 1, '#1', '#1004'),
('#13', 2, '#14', '#1006'),
('#13', 3, '#10', '#1002'),
('#13', 4, '#11', '#1004'),
('#13', 5, '#55', '#1008'),
('#13', 6, '#44', '#1001'),
('#13', 7, '#4', '#1005'),
('#13', 8, '#23', '#1010'),
('#13', 9, '#81', '#1005'),
('#13', 10, '#31', '#1002'),
('#13', 11, '#18', '#1006'),
('#13', 12, '#27', '#1003'),
('#13', 13, '#40', '#1007'),
('#13', 14, '#77', '#1009'),
('#13', 15, '#22', '#1007'),
('#13', 16, '#20', '#1003'),
('#13', 17, '#63', '#1001'),
('#13', 18, '#24', '#1009'),
('#13', 19, '#16', '#1008'),
('#13', 20, '#2', '#1010'),
('#14', 1, '#1', '#1004'),
('#14', 2, '#11', '#1004'),
('#14', 3, '#55', '#1008'),
('#14', 4, '#16', '#1008'),
('#14', 5, '#63', '#1001'),
('#14', 6, '#44', '#1001'),
('#14', 7, '#23', '#1010'),
('#14', 8, '#4', '#1005'),
('#14', 9, '#14', '#1002'),
('#14', 10, '#77', '#1009'),
('#14', 11, '#40', '#1007'),
('#14', 12, '#81', '#1005'),
('#14', 13, '#2', '#1010'),
('#14', 14, '#24', '#1009'),
('#14', 15, '#10', '#1002'),
('#14', 16, '#18', '#1006'),
('#14', 17, '#27', '#1003'),
('#14', 18, '#20', '#1003'),
('#14', 19, '#31', '#1002'),
('#14', 20, '#22', '#1007'),
('#15', 1, '#55', '#1008'),
('#15', 2, '#4', '#1005'),
('#15', 3, '#44', '#1001'),
('#15', 4, '#16', '#1008'),
('#15', 5, '#1', '#1004'),
('#15', 6, '#10', '#1002'),
('#15', 7, '#81', '#1005'),
('#15', 8, '#11', '#1002'),
('#15', 9, '#40', '#1007'),
('#15', 10, '#20', '#1003'),
('#15', 11, '#23', '#1010'),
('#15', 12, '#24', '#1009'),
('#15', 13, '#27', '#1003'),
('#15', 14, '#2', '#1010'),
('#15', 15, '#14', '#1006'),
('#15', 16, '#63', '#1001'),
('#15', 17, '#77', '#1009'),
('#15', 18, '#31', '#1002'),
('#15', 19, '#22', '#1007'),
('#16', 1, '#1', '#1004'),
('#16', 2, '#4', '#1005'),
('#16', 3, '#81', '#1005'),
('#16', 4, '#16', '#1008'),
('#16', 5, '#44', '#1001'),
('#16', 6, '#55', '#1008'),
('#16', 7, '#63', '#1001'),
('#16', 8, '#14', '#1006'),
('#16', 9, '#31', '#1002'),
('#16', 10, '#10', '#1002'),
('#16', 11, '#40', '#1007'),
('#16', 12, '#22', '#1007'),
('#16', 13, '#24', '#1009'),
('#16', 14, '#27', '#1003'),
('#16', 15, '#20', '#1003'),
('#16', 16, '#23', '#1010'),
('#16', 17, '#2', '#1010'),
('#16', 18, '#18', '#1006'),
('#16', 19, '#11', '#1004'),
('#16', 20, '#77', '#1009'),
('#17', 1, '#1', '#1004'),
('#17', 2, '#81', '#1005'),
('#17', 3, '#4', '#1005'),
('#17', 4, '#63', '#1001'),
('#17', 5, '#16', '#1008'),
('#17', 6, '#14', '#1006'),
('#17', 7, '#31', '#1002'),
('#17', 8, '#77', '#1009'),
('#17', 9, '#24', '#1009'),
('#17', 10, '#11', '#1004'),
('#17', 11, '#18', '#1006'),
('#17', 12, '#10', '#1002'),
('#17', 13, '#23', '#1010'),
('#17', 14, '#20', '#1003'),
('#17', 15, '#22', '#1007'),
('#17', 16, '#27', '#1003'),
('#17', 17, '#40', '#1007'),
('#17', 18, '#2', '#1010'),
('#17', 19, '#44', '#1001'),
('#17', 20, '#55', '#1008'),
('#18', 1, '#1', '#1004'),
('#18', 2, '#4', '#1005'),
('#18', 3, '#55', '#1008'),
('#18', 4, '#11', '#1004'),
('#18', 5, '#63', '#1001'),
('#18', 6, '#10', '#1002'),
('#18', 7, '#18', '#1006'),
('#18', 8, '#22', '#1007'),
('#18', 9, '#23', '#1010'),
('#18', 10, '#2', '#1010'),
('#18', 11, '#27', '#1003'),
('#18', 12, '#77', '#1009'),
('#18', 13, '#24', '#1009'),
('#18', 14, '#20', '#1003'),
('#18', 15, '#3', '#1007'),
('#18', 16, '#14', '#1006'),
('#18', 17, '#81', '#1005'),
('#18', 18, '#31', '#1002'),
('#18', 19, '#44', '#1001'),
('#18', 20, '#16', '#1008'),
('#19', 1, '#1', '#1004'),
('#19', 2, '#44', '#1001'),
('#19', 3, '#16', '#1008'),
('#19', 4, '#55', '#1008'),
('#19', 5, '#4', '#1005'),
('#19', 6, '#63', '#1001'),
('#19', 7, '#3', '#1007'),
('#19', 8, '#81', '#1005'),
('#19', 9, '#23', '#1010'),
('#19', 10, '#31', '#1002'),
('#19', 11, '#10', '#1002'),
('#19', 12, '#22', '#1007'),
('#19', 13, '#27', '#1003'),
('#19', 14, '#24', '#1009'),
('#19', 15, '#77', '#1009'),
('#19', 16, '#2', '#1010'),
('#19', 17, '#18', '#1006'),
('#19', 18, '#14', '#1006'),
('#19', 19, '#20', '#1003'),
('#19', 20, '#11', '#1004'),
('#20', 1, '#1', '#1004'),
('#20', 2, '#4', '#1005'),
('#20', 3, '#14', '#1006'),
('#20', 4, '#11', '#1004'),
('#20', 5, '#18', '#1006'),
('#20', 6, '#55', '#1008'),
('#20', 7, '#10', '#1002'),
('#20', 8, '#44', '#1001'),
('#20', 9, '#22', '#1007'),
('#20', 10, '#31', '#1002'),
('#20', 11, '#2', '#1010'),
('#20', 12, '#27', '#1003'),
('#20', 13, '#3', '#1007'),
('#20', 14, '#81', '#1005'),
('#20', 15, '#63', '#1001'),
('#20', 16, '#77', '#1009'),
('#20', 17, '#24', '#1009'),
('#20', 18, '#20', '#1003'),
('#20', 19, '#23', '#1010'),
('#20', 20, '#16', '#1008'),
('#21', 1, '#1', '#1004'),
('#21', 2, '#16', '#1008'),
('#21', 3, '#11', '#1004'),
('#21', 4, '#31', '#1002'),
('#21', 5, '#18', '#1006'),
('#21', 6, '#55', '#1008'),
('#21', 7, '#44', '#1001'),
('#21', 8, '#63', '#1001'),
('#21', 9, '#14', '#1006'),
('#21', 10, '#81', '#1005'),
('#21', 11, '#10', '#1002'),
('#21', 12, '#23', '#1010'),
('#21', 13, '#20', '#1003'),
('#21', 14, '#3', '#1007'),
('#21', 15, '#24', '#1009'),
('#21', 16, '#2', '#1010'),
('#21', 17, '#77', '#1009'),
('#21', 18, '#22', '#1007'),
('#21', 19, '#27', '#1003'),
('#21', 20, '#4', '#1005'),
('#22', 1, '#1', '#1004'),
('#22', 2, '#16', '#1008'),
('#22', 3, '#63', '#1001'),
('#22', 4, '#11', '#1004'),
('#22', 5, '#4', '#1005'),
('#22', 6, '#81', '#1005'),
('#22', 7, '#14', '#1006'),
('#22', 8, '#22', '#1007'),
('#22', 9, '#44', '#1001'),
('#22', 10, '#18', '#1006'),
('#22', 11, '#3', '#1007'),
('#22', 12, '#31', '#1002'),
('#22', 13, '#10', '#1002'),
('#22', 14, '#23', '#1010'),
('#22', 15, '#27', '#1003'),
('#22', 16, '#2', '#1010'),
('#22', 17, '#24', '#1009'),
('#22', 18, '#55', '#1008'),
('#22', 19, '#77', '#1009'),
('#22', 20, '#20', '#1003');

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `Team_id` varchar(40) NOT NULL,
  `Team_Name` varchar(40) NOT NULL,
  `Origin` varchar(40) DEFAULT NULL,
  `Driver_1` varchar(40) DEFAULT NULL,
  `Driver_2` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`Team_id`, `Team_Name`, `Origin`, `Driver_1`, `Driver_2`) VALUES
('#1001', 'Mercedes', 'Germany', '#44', '#63'),
('#1002', 'Alpine', 'France', '#31', '#10'),
('#1003', 'Haas F1 Team', 'USA', '#20', '#27'),
('#1004', 'Red Bull Racing', 'AUT', '#1', '#11'),
('#1005', 'McLaren', 'UK', '#4', '#81'),
('#1006', 'Aston Martin', 'UK', '#14', '#18'),
('#1007', 'Alphatauri', 'ITA', '#22', '#3'),
('#1008', 'Ferrari', 'ITA', '#16', '#55'),
('#1009', 'Alfa Romeo', 'ITA', '#77', '#24'),
('#1010', 'Williams', 'UK', '#23', '#2'),
('#1012', 'Audi', 'German', '#99', '#100');

--
-- Triggers `teams`
--
DELIMITER $$
CREATE TRIGGER `after_team_insert` AFTER INSERT ON `teams` FOR EACH ROW BEGIN
    DECLARE max_pos INT;

    -- Calculate the next Pos value based on the highest Pos value in constructor_standings table
    SELECT MAX(Pos) INTO max_pos FROM constructor_standings;
    SET max_pos = IFNULL(max_pos, 0);
    INSERT INTO constructor_standings (Team_id, Pos, Team_name, Wins, Podiums, Total_Points) 
    VALUES (NEW.Team_Id, max_pos + 1, NEW.Team_Name, 0, 0, 0);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `all_drivers_view`
--
DROP TABLE IF EXISTS `all_drivers_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_drivers_view`  AS SELECT `d`.`Driver_Name` AS `Driver_Name`, `d`.`Nationality` AS `Nationality`, `d`.`Age` AS `Age`, `t`.`Team_Name` AS `Team` FROM (`drivers` `d` left join `teams` `t` on(`d`.`Driver_id` = `t`.`Driver_1` or `d`.`Driver_id` = `t`.`Driver_2`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `constructor_standings`
--
ALTER TABLE `constructor_standings`
  ADD PRIMARY KEY (`Pos`),
  ADD KEY `Team_id` (`Team_id`);

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`Driver_id`);

--
-- Indexes for table `driver_standings`
--
ALTER TABLE `driver_standings`
  ADD PRIMARY KEY (`Pos`),
  ADD KEY `Driver_id` (`Driver_id`);

--
-- Indexes for table `races`
--
ALTER TABLE `races`
  ADD PRIMARY KEY (`Race_id`);

--
-- Indexes for table `results`
--
ALTER TABLE `results`
  ADD KEY `Race_id` (`Race_id`),
  ADD KEY `Driver_id` (`Driver_id`),
  ADD KEY `Team_id` (`Team_id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`Team_id`),
  ADD KEY `Driver_1` (`Driver_1`),
  ADD KEY `Driver_2` (`Driver_2`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `constructor_standings`
--
ALTER TABLE `constructor_standings`
  ADD CONSTRAINT `constructor_standings_ibfk_1` FOREIGN KEY (`Team_id`) REFERENCES `teams` (`Team_id`);

--
-- Constraints for table `driver_standings`
--
ALTER TABLE `driver_standings`
  ADD CONSTRAINT `driver_standings_ibfk_1` FOREIGN KEY (`Driver_id`) REFERENCES `drivers` (`Driver_id`);

--
-- Constraints for table `results`
--
ALTER TABLE `results`
  ADD CONSTRAINT `results_ibfk_1` FOREIGN KEY (`Race_id`) REFERENCES `races` (`Race_id`),
  ADD CONSTRAINT `results_ibfk_2` FOREIGN KEY (`Driver_id`) REFERENCES `drivers` (`Driver_id`),
  ADD CONSTRAINT `results_ibfk_3` FOREIGN KEY (`Team_id`) REFERENCES `teams` (`Team_id`);

--
-- Constraints for table `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`Driver_1`) REFERENCES `drivers` (`Driver_id`),
  ADD CONSTRAINT `teams_ibfk_2` FOREIGN KEY (`Driver_2`) REFERENCES `drivers` (`Driver_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
