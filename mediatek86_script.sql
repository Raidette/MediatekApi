-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 25 avr. 2023 à 17:09
-- Version du serveur : 10.4.24-MariaDB-log
-- Version de PHP : 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `mediatek86`
--

-- --------------------------------------------------------

--
-- Structure de la table `abonnement`
--

CREATE TABLE `abonnement` (
  `id` varchar(5) NOT NULL,
  `dateFinAbonnement` date DEFAULT NULL,
  `idRevue` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `abonnement`
--

INSERT INTO `abonnement` (`id`, `dateFinAbonnement`, `idRevue`) VALUES
('99351', '2023-04-08', '10001');

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

CREATE TABLE `commande` (
  `id` varchar(5) NOT NULL,
  `dateCommande` date DEFAULT '2023-01-01',
  `montant` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `commande`
--

INSERT INTO `commande` (`id`, `dateCommande`, `montant`) VALUES
('04899', '2023-04-08', 690),
('05642', '2023-04-04', 100),
('19942', '2023-04-08', 690),
('28938', '2023-04-25', 15),
('37335', '2023-04-09', 691),
('37700', '2023-04-08', 25),
('48030', '2023-04-04', 100),
('48250', '2023-04-04', 100),
('55088', '2023-04-05', 200),
('59064', '2023-04-05', 200),
('99351', '2023-04-05', 200);

--
-- Déclencheurs `commande`
--
DELIMITER $$
CREATE TRIGGER `check_commande_partition` AFTER INSERT ON `commande` FOR EACH ROW BEGIN
	SELECT COUNT(*) INTO @nombrecd FROM commandedocument WHERE id = NEW.id;
	SELECT COUNT(*) INTO @nombreabo FROM abonnement WHERE id = NEW.id ;

	IF @nombrecd != 0 OR @nombreabo != 0 THEN
		IF @nombrecd > 0 AND @nombreabo > 0 THEN
    		SIGNAL sqlstate '45000' SET message_text = 'Une commande ne peut pas être à la fois une commande de document et de revue.' ;
    	END IF;
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `deleteSuivi` BEFORE DELETE ON `commande` FOR EACH ROW BEGIN
	DECLARE id_commande INT;
    SET id_commande := OLD.id;
    
    DELETE FROM suivi WHERE id = id_commande;
    DELETE FROM commandedocument WHERE id = id_commande;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commandedocument`
--

CREATE TABLE `commandedocument` (
  `id` varchar(5) NOT NULL,
  `nbExemplaire` int(11) DEFAULT NULL,
  `idLivreDvd` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `commandedocument`
--

INSERT INTO `commandedocument` (`id`, `nbExemplaire`, `idLivreDvd`) VALUES
('04899', 1, '20001'),
('19942', 3, '00017'),
('28938', 1, '00017'),
('37335', 2, '20001'),
('37700', 2, '00017'),
('55088', 5, '20001');

-- --------------------------------------------------------

--
-- Structure de la table `document`
--

CREATE TABLE `document` (
  `id` varchar(10) NOT NULL,
  `titre` varchar(60) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `idRayon` varchar(5) NOT NULL,
  `idPublic` varchar(5) NOT NULL,
  `idGenre` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `document`
--

INSERT INTO `document` (`id`, `titre`, `image`, `idRayon`, `idPublic`, `idGenre`) VALUES
('00001', 'Quand sort la recluse', '', 'LV003', '00002', '10014'),
('00002', 'Un pays à l\'aube', '', 'LV001', '00002', '10004'),
('00003', 'Et je danse aussi', '', 'LV002', '00003', '10013'),
('00004', 'L\'armée furieuse', '', 'LV003', '00002', '10014'),
('00005', 'Les anonymes', '', 'LV001', '00002', '10014'),
('00006', 'La marque jaune', '', 'BD001', '00003', '10001'),
('00007', 'Dans les coulisses du musée', '', 'LV001', '00003', '10006'),
('00008', 'Histoire du juif errant', '', 'LV002', '00002', '10006'),
('00009', 'Pars vite et reviens tard', '', 'LV003', '00002', '10014'),
('00010', 'Le vestibule des causes perdues', '', 'LV001', '00002', '10006'),
('00011', 'L\'île des oubliés', '', 'LV002', '00003', '10006'),
('00012', 'La souris bleue', '', 'LV002', '00003', '10006'),
('00013', 'Sacré Pêre Noël', '', 'JN001', '00001', '10001'),
('00014', 'Mauvaise étoile', '', 'LV003', '00003', '10014'),
('00015', 'La confrérie des téméraires', '', 'JN002', '00004', '10014'),
('00016', 'Le butin du requin', '', 'JN002', '00004', '10014'),
('00017', 'Catastrophes au Brésil', '', 'JN002', '00004', '10014'),
('00018', 'Le Routard - Maroc', '', 'DV005', '00003', '10011'),
('00019', 'Guide Vert - Iles Canaries', '', 'DV005', '00003', '10011'),
('00020', 'Guide Vert - Irlande', '', 'DV005', '00003', '10011'),
('00021', 'Les déferlantes', '', 'LV002', '00002', '10006'),
('00022', 'Une part de Ciel', '', 'LV002', '00002', '10006'),
('00023', 'Le secret du janissaire', '', 'BD001', '00002', '10001'),
('00024', 'Pavillon noir', '', 'BD001', '00002', '10001'),
('00025', 'L\'archipel du danger', '', 'BD001', '00002', '10001'),
('00026', 'La planète des singes', '', 'LV002', '00003', '10002'),
('10001', 'Arts Magazine', '', 'PR002', '00002', '10016'),
('10002', 'Alternatives Economiques', '', 'PR002', '00002', '10015'),
('10003', 'Challenges', '', 'PR002', '00002', '10015'),
('10004', 'Rock and Folk', '', 'PR002', '00002', '10016'),
('10005', 'Les Echos', '', 'PR001', '00002', '10015'),
('10006', 'Le Monde', '', 'PR001', '00002', '10018'),
('10007', 'Telerama', '', 'PR002', '00002', '10016'),
('10008', 'L\'Obs', '', 'PR002', '00002', '10018'),
('10009', 'L\'Equipe', '', 'PR001', '00002', '10017'),
('10010', 'L\'Equipe Magazine', '', 'PR002', '00002', '10017'),
('10011', 'Geo', '', 'PR002', '00003', '10016'),
('20001', 'Star Wars 5 L\'empire contre attaque', '', 'DF001', '00003', '10002'),
('20002', 'Le seigneur des anneaux : la communauté de l\'anneau', '', 'DF001', '00003', '10019'),
('20003', 'Jurassic Park', '', 'DF001', '00003', '10002'),
('20004', 'Matrix', '', 'DF001', '00003', '10002');

-- --------------------------------------------------------

--
-- Structure de la table `dvd`
--

CREATE TABLE `dvd` (
  `id` varchar(10) NOT NULL,
  `synopsis` text DEFAULT NULL,
  `realisateur` varchar(20) DEFAULT NULL,
  `duree` int(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `dvd`
--

INSERT INTO `dvd` (`id`, `synopsis`, `realisateur`, `duree`) VALUES
('20001', 'Luc est entraîné par Yoda pendant que Han et Leia tentent de se cacher dans la cité des nuages.', 'George Lucas', 124),
('20002', 'L\'anneau unique, forgé par Sauron, est porté par Fraudon qui l\'amène à Foncombe. De là, des représentants de peuples différents vont s\'unir pour aider Fraudon à amener l\'anneau à la montagne du Destin.', 'Peter Jackson', 228),
('20003', 'Un milliardaire et des généticiens créent des dinosaures à partir de clonage.', 'Steven Spielberg', 128),
('20004', 'Un informaticien réalise que le monde dans lequel il vit est une simulation gérée par des machines.', 'Les Wachowski', 136);

-- --------------------------------------------------------

--
-- Structure de la table `etat`
--

CREATE TABLE `etat` (
  `id` char(5) NOT NULL,
  `libelle` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `etat`
--

INSERT INTO `etat` (`id`, `libelle`) VALUES
('00001', 'neuf'),
('00002', 'usagé'),
('00003', 'détérioré'),
('00004', 'inutilisable');

-- --------------------------------------------------------

--
-- Structure de la table `exemplaire`
--

CREATE TABLE `exemplaire` (
  `id` varchar(10) NOT NULL,
  `numero` int(11) NOT NULL,
  `dateAchat` date DEFAULT NULL,
  `photo` varchar(500) NOT NULL,
  `idEtat` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `exemplaire`
--

INSERT INTO `exemplaire` (`id`, `numero`, `dateAchat`, `photo`, `idEtat`) VALUES
('00017', 3245, '2023-03-24', '', '00001'),
('00017', 3246, '2023-03-23', '', '00001'),
('00017', 3247, '2023-03-23', '', '00001'),
('00017', 3248, '2023-03-23', '', '00001'),
('00017', 3249, '2023-03-23', '', '00001'),
('00017', 3250, '2023-03-23', '', '00001'),
('00017', 3251, '2023-03-23', '', '00001'),
('00017', 3252, '2023-03-23', '', '00001'),
('00017', 3253, '2023-03-23', '', '00001'),
('00017', 3254, '2023-03-23', '', '00001'),
('00017', 3255, '2023-03-23', '', '00001'),
('00017', 3256, '2023-03-23', '', '00001'),
('00017', 3257, '2023-03-23', '', '00001'),
('00017', 3258, '2023-03-23', '', '00001'),
('00017', 3259, '2023-03-23', '', '00001'),
('00017', 3260, '2023-03-23', '', '00001'),
('00017', 3261, '2023-03-23', '', '00001'),
('00017', 3262, '2023-03-23', '', '00001'),
('00017', 3263, '2023-03-23', '', '00001'),
('00017', 3264, '2023-03-23', '', '00001'),
('00017', 3265, '2023-03-22', '', '00001'),
('00017', 3266, '2023-03-22', '', '00001'),
('00017', 3267, '2023-03-22', '', '00001'),
('00017', 3268, '2023-03-22', '', '00001'),
('00017', 3269, '2023-03-22', '', '00001'),
('00017', 3270, '2023-03-22', '', '00001'),
('00017', 3271, '2023-03-22', '', '00001'),
('00017', 3272, '2023-03-22', '', '00001'),
('00017', 3273, '2023-03-22', '', '00001'),
('00017', 3274, '2023-03-22', '', '00001'),
('00017', 3275, '2023-03-22', '', '00001'),
('00017', 3276, '2023-03-22', '', '00001'),
('00017', 3277, '2023-03-22', '', '00001'),
('00017', 3278, '2023-03-22', '', '00001'),
('00017', 3279, '2023-03-22', '', '00001'),
('00017', 3280, '2023-03-22', '', '00001'),
('00017', 3281, '2023-03-22', '', '00001'),
('00017', 3282, '2023-03-22', '', '00001'),
('00017', 3283, '2023-03-22', '', '00001'),
('00017', 3284, '2023-03-22', '', '00001'),
('00017', 3285, '2023-03-22', '', '00001'),
('00017', 3286, '2023-03-22', '', '00001'),
('00017', 3287, '2023-03-22', '', '00001'),
('00017', 3288, '2023-03-22', '', '00001'),
('00017', 3289, '2023-03-22', '', '00001'),
('00017', 3290, '2023-03-22', '', '00001'),
('00017', 3291, '2023-03-22', '', '00001'),
('00017', 3292, '2023-03-22', '', '00001'),
('00017', 3293, '2023-03-22', '', '00001'),
('00017', 3294, '2023-03-22', '', '00001'),
('00017', 3295, '2023-03-22', '', '00001'),
('00017', 3296, '2023-03-22', '', '00001'),
('00017', 3297, '2023-03-22', '', '00001'),
('00017', 3298, '2023-03-22', '', '00001'),
('00017', 3299, '2023-03-22', '', '00001'),
('00017', 3300, '2023-03-22', '', '00001'),
('00017', 3301, '2023-03-22', '', '00001'),
('00017', 3302, '2023-03-22', '', '00001'),
('00017', 3303, '2023-03-22', '', '00001'),
('00017', 3304, '2023-03-22', '', '00001'),
('00017', 3305, '2023-03-22', '', '00001'),
('00017', 3306, '2023-03-22', '', '00001'),
('00017', 3307, '2023-03-22', '', '00001'),
('00017', 3308, '2023-03-22', '', '00001'),
('00017', 3309, '2023-03-22', '', '00001'),
('00017', 3310, '2023-03-22', '', '00001'),
('00017', 3311, '2023-03-22', '', '00001'),
('00017', 3312, '2023-03-22', '', '00001'),
('00017', 3313, '2023-03-22', '', '00001'),
('00017', 3314, '2023-03-22', '', '00001'),
('00017', 3315, '2023-03-22', '', '00001'),
('00017', 3316, '2023-03-22', '', '00001'),
('00017', 3317, '2023-03-22', '', '00001'),
('00017', 3318, '2023-03-22', '', '00001'),
('00017', 3319, '2023-03-22', '', '00001'),
('00017', 3320, '2023-03-22', '', '00001'),
('00017', 3321, '2023-03-22', '', '00001'),
('00017', 3322, '2023-03-22', '', '00001'),
('00017', 3323, '2023-03-22', '', '00001'),
('00017', 3324, '2023-03-22', '', '00001'),
('00017', 3325, '2023-03-22', '', '00001'),
('00017', 3326, '2023-03-22', '', '00001'),
('00017', 3327, '2023-03-22', '', '00001'),
('00017', 3328, '2023-03-22', '', '00001'),
('00017', 3329, '2023-03-22', '', '00001'),
('00017', 3330, '2023-03-22', '', '00001'),
('00017', 3331, '2023-03-22', '', '00001'),
('00017', 3332, '2023-03-22', '', '00001'),
('00017', 3333, '2023-03-22', '', '00001'),
('00017', 42070, '2023-04-08', '', '00001'),
('00017', 42071, '2023-04-08', '', '00001'),
('20001', 3357, '2023-03-24', '', '00001'),
('20001', 3358, '2023-03-24', '', '00001'),
('20001', 3359, '2023-03-24', '', '00001'),
('20001', 3360, '2023-03-24', '', '00001'),
('20001', 3361, '2023-03-24', '', '00001'),
('20001', 3362, '2023-03-24', '', '00001'),
('20001', 3363, '2023-03-24', '', '00001'),
('20001', 3364, '2023-03-24', '', '00001'),
('20001', 3365, '2023-03-24', '', '00001'),
('20001', 3366, '2023-03-24', '', '00001'),
('20001', 3367, '2023-03-24', '', '00001'),
('20001', 3368, '2023-03-24', '', '00001'),
('20001', 3369, '2023-03-24', '', '00001'),
('20001', 3370, '2023-03-24', '', '00001'),
('20001', 3371, '2023-03-24', '', '00001'),
('20001', 3372, '2023-03-24', '', '00001'),
('20001', 3373, '2023-03-24', '', '00001'),
('20001', 3374, '2023-03-24', '', '00001'),
('20001', 3375, '2023-03-24', '', '00001'),
('20001', 3376, '2023-03-24', '', '00001'),
('20001', 42072, '2023-04-09', '', '00001'),
('20001', 42073, '2023-04-09', '', '00001');

-- --------------------------------------------------------

--
-- Structure de la table `genre`
--

CREATE TABLE `genre` (
  `id` varchar(5) NOT NULL,
  `libelle` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `genre`
--

INSERT INTO `genre` (`id`, `libelle`) VALUES
('10000', 'Humour'),
('10001', 'Bande dessinée'),
('10002', 'Science Fiction'),
('10003', 'Biographie'),
('10004', 'Historique'),
('10006', 'Roman'),
('10007', 'Aventures'),
('10008', 'Essai'),
('10009', 'Documentaire'),
('10010', 'Technique'),
('10011', 'Voyages'),
('10012', 'Drame'),
('10013', 'Comédie'),
('10014', 'Policier'),
('10015', 'Presse Economique'),
('10016', 'Presse Culturelle'),
('10017', 'Presse sportive'),
('10018', 'Actualités'),
('10019', 'Fantazy');

-- --------------------------------------------------------

--
-- Structure de la table `livre`
--

CREATE TABLE `livre` (
  `id` varchar(10) NOT NULL,
  `ISBN` varchar(13) DEFAULT NULL,
  `auteur` varchar(20) DEFAULT NULL,
  `collection` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `livre`
--

INSERT INTO `livre` (`id`, `ISBN`, `auteur`, `collection`) VALUES
('00001', '1234569877896', 'Fred Vargas', 'Commissaire Adamsberg'),
('00002', '1236547896541', 'Dennis Lehanne', ''),
('00003', '6541236987410', 'Anne-Laure Bondoux', ''),
('00004', '3214569874123', 'Fred Vargas', 'Commissaire Adamsberg'),
('00005', '3214563214563', 'RJ Ellory', ''),
('00006', '3213213211232', 'Edgar P. Jacobs', 'Blake et Mortimer'),
('00007', '6541236987541', 'Kate Atkinson', ''),
('00008', '1236987456321', 'Jean d\'Ormesson', ''),
('00009', '', 'Fred Vargas', 'Commissaire Adamsberg'),
('00010', '', 'Manon Moreau', ''),
('00011', '', 'Victoria Hislop', ''),
('00012', '', 'Kate Atkinson', ''),
('00013', '', 'Raymond Briggs', ''),
('00014', '', 'RJ Ellory', ''),
('00015', '', 'Floriane Turmeau', ''),
('00016', '', 'Julian Press', ''),
('00017', '', 'Philippe Masson', ''),
('00018', '', '', 'Guide du Routard'),
('00019', '', '', 'Guide Vert'),
('00020', '', '', 'Guide Vert'),
('00021', '', 'Claudie Gallay', ''),
('00022', '', 'Claudie Gallay', ''),
('00023', '', 'Ayrolles - Masbou', 'De cape et de crocs'),
('00024', '', 'Ayrolles - Masbou', 'De cape et de crocs'),
('00025', '', 'Ayrolles - Masbou', 'De cape et de crocs'),
('00026', '', 'Pierre Boulle', 'Julliard');

-- --------------------------------------------------------

--
-- Structure de la table `livres_dvd`
--

CREATE TABLE `livres_dvd` (
  `id` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `livres_dvd`
--

INSERT INTO `livres_dvd` (`id`) VALUES
('00001'),
('00002'),
('00003'),
('00004'),
('00005'),
('00006'),
('00007'),
('00008'),
('00009'),
('00010'),
('00011'),
('00012'),
('00013'),
('00014'),
('00015'),
('00016'),
('00017'),
('00018'),
('00019'),
('00020'),
('00021'),
('00022'),
('00023'),
('00024'),
('00025'),
('00026'),
('20001'),
('20002'),
('20003'),
('20004');

-- --------------------------------------------------------

--
-- Structure de la table `public`
--

CREATE TABLE `public` (
  `id` varchar(5) NOT NULL,
  `libelle` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `public`
--

INSERT INTO `public` (`id`, `libelle`) VALUES
('00001', 'Jeunesse'),
('00002', 'Adultes'),
('00003', 'Tous publics'),
('00004', 'Ados');

-- --------------------------------------------------------

--
-- Structure de la table `rayon`
--

CREATE TABLE `rayon` (
  `id` char(5) NOT NULL,
  `libelle` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `rayon`
--

INSERT INTO `rayon` (`id`, `libelle`) VALUES
('BD001', 'BD Adultes'),
('BL001', 'Beaux Livres'),
('DF001', 'DVD films'),
('DV001', 'Sciences'),
('DV002', 'Maison'),
('DV003', 'Santé'),
('DV004', 'Littérature classique'),
('DV005', 'Voyages'),
('JN001', 'Jeunesse BD'),
('JN002', 'Jeunesse romans'),
('LV001', 'Littérature étrangère'),
('LV002', 'Littérature française'),
('LV003', 'Policiers français étrangers'),
('PR001', 'Presse quotidienne'),
('PR002', 'Magazines');

-- --------------------------------------------------------

--
-- Structure de la table `revue`
--

CREATE TABLE `revue` (
  `id` varchar(10) NOT NULL,
  `periodicite` varchar(2) DEFAULT NULL,
  `delaiMiseADispo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `revue`
--

INSERT INTO `revue` (`id`, `periodicite`, `delaiMiseADispo`) VALUES
('10001', 'MS', 52),
('10002', 'MS', 52),
('10003', 'HB', 15),
('10004', 'HB', 15),
('10005', 'QT', 5),
('10006', 'QT', 5),
('10007', 'HB', 26),
('10008', 'HB', 26),
('10009', 'QT', 5),
('10010', 'HB', 12),
('10011', 'MS', 52);

-- --------------------------------------------------------

--
-- Structure de la table `services`
--

CREATE TABLE `services` (
  `idService` varchar(5) NOT NULL,
  `nomService` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `services`
--

INSERT INTO `services` (`idService`, `nomService`) VALUES
('00001', 'culture'),
('00002', 'prêts'),
('00003', 'serviceAdministratif'),
('00004', 'administrateur');

-- --------------------------------------------------------

--
-- Structure de la table `suivi`
--

CREATE TABLE `suivi` (
  `id` varchar(5) NOT NULL,
  `statut` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `suivi`
--

INSERT INTO `suivi` (`id`, `statut`) VALUES
('04899', 'Relancée'),
('19942', 'En cours'),
('28938', 'En cours'),
('37335', 'Réglée'),
('37700', 'Réglée'),
('55088', 'Relancée');

--
-- Déclencheurs `suivi`
--
DELIMITER $$
CREATE TRIGGER `creationexemplaires` AFTER UPDATE ON `suivi` FOR EACH ROW BEGIN
    DECLARE id_nouvelle_commande INT ;
    DECLARE nouvelle_etape_suivi varchar(20) ;
    DECLARE id_document_commande varchar(20) ;
    DECLARE iterateur INT ;
    DECLARE nbExemplairesCommande INT ;
    DECLARE dateAchatExemplaires DATE ;
    
    SET nouvelle_etape_suivi := NEW.statut;
    SET id_nouvelle_commande := NEW.id;
    SET id_document_commande := (SELECT idLivreDvd FROM commandedocument WHERE id = id_nouvelle_commande);
    SET iterateur := 0 ;
    SET nbExemplairesCommande := (SELECT nbExemplaire FROM commandedocument WHERE id = id_nouvelle_commande);
    SET dateAchatExemplaires := (SELECT dateCommande FROM commande WHERE id = id_nouvelle_commande);
    
    
    IF nouvelle_etape_suivi = "Livrée" THEN
    	loopCreationExemplaires:LOOP
    		INSERT INTO exemplaire VALUES (id_document_commande,null,dateAchatExemplaires,"","00001");
    		SET iterateur = iterateur + 1;
    		IF iterateur < nbExemplairesCommande THEN
      			ITERATE loopCreationExemplaires;
    		END IF;
    		LEAVE loopCreationExemplaires;
		END LOOP loopCreationExemplaires;
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `id` varchar(5) NOT NULL,
  `nom` varchar(60) NOT NULL,
  `mdp` char(60) NOT NULL,
  `idService` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `nom`, `mdp`, `idService`) VALUES
('00001', 'serviceculturemediatek', '$2y$10$cH3CKhg0gNFV7BCpauO9uebH2Kbx0it/IOtV4n30o4rii.ItgHoYa', '00001'),
('00002', 'serviceprêtsmediatek', '$2y$10$tb2J4E/ssIfW5iIYngfW9.k7Ul6F8jDL2jJiagUSuvzFZnhviv282', '00002'),
('00003', 'serviceadministratifmediatek', '$2y$10$8XSJ2TP9XYHfTG.zvAq1weqWEuKZkKzHcDk.hPXBO.GF9ESR6dlcK', '00003'),
('00004', 'serviceadministrateurmediatek', '$2y$10$ih4w/l40M7wEVwMtiruCuOv/P7PdTDVUmU5tWUdZ.ZWccL8.hLmpO', '00004');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `abonnement`
--
ALTER TABLE `abonnement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idRevue` (`idRevue`);

--
-- Index pour la table `commande`
--
ALTER TABLE `commande`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `commandedocument`
--
ALTER TABLE `commandedocument`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idLivreDvd` (`idLivreDvd`);

--
-- Index pour la table `document`
--
ALTER TABLE `document`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idRayon` (`idRayon`),
  ADD KEY `idPublic` (`idPublic`),
  ADD KEY `idGenre` (`idGenre`);

--
-- Index pour la table `dvd`
--
ALTER TABLE `dvd`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `etat`
--
ALTER TABLE `etat`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `exemplaire`
--
ALTER TABLE `exemplaire`
  ADD PRIMARY KEY (`id`,`numero`),
  ADD UNIQUE KEY `Num_Unique` (`numero`),
  ADD KEY `idEtat` (`idEtat`);

--
-- Index pour la table `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `livre`
--
ALTER TABLE `livre`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `livres_dvd`
--
ALTER TABLE `livres_dvd`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `public`
--
ALTER TABLE `public`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `rayon`
--
ALTER TABLE `rayon`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `revue`
--
ALTER TABLE `revue`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`idService`);

--
-- Index pour la table `suivi`
--
ALTER TABLE `suivi`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_service_utilisateur` (`idService`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `exemplaire`
--
ALTER TABLE `exemplaire`
  MODIFY `numero` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42074;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `abonnement`
--
ALTER TABLE `abonnement`
  ADD CONSTRAINT `abonnement_ibfk_1` FOREIGN KEY (`id`) REFERENCES `commande` (`id`),
  ADD CONSTRAINT `abonnement_ibfk_2` FOREIGN KEY (`idRevue`) REFERENCES `revue` (`id`);

--
-- Contraintes pour la table `commandedocument`
--
ALTER TABLE `commandedocument`
  ADD CONSTRAINT `commandedocument_ibfk_1` FOREIGN KEY (`id`) REFERENCES `commande` (`id`),
  ADD CONSTRAINT `commandedocument_ibfk_2` FOREIGN KEY (`idLivreDvd`) REFERENCES `livres_dvd` (`id`);

--
-- Contraintes pour la table `document`
--
ALTER TABLE `document`
  ADD CONSTRAINT `document_ibfk_1` FOREIGN KEY (`idRayon`) REFERENCES `rayon` (`id`),
  ADD CONSTRAINT `document_ibfk_2` FOREIGN KEY (`idPublic`) REFERENCES `public` (`id`),
  ADD CONSTRAINT `document_ibfk_3` FOREIGN KEY (`idGenre`) REFERENCES `genre` (`id`);

--
-- Contraintes pour la table `dvd`
--
ALTER TABLE `dvd`
  ADD CONSTRAINT `dvd_ibfk_1` FOREIGN KEY (`id`) REFERENCES `livres_dvd` (`id`);

--
-- Contraintes pour la table `exemplaire`
--
ALTER TABLE `exemplaire`
  ADD CONSTRAINT `exemplaire_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`),
  ADD CONSTRAINT `exemplaire_ibfk_2` FOREIGN KEY (`idEtat`) REFERENCES `etat` (`id`);

--
-- Contraintes pour la table `livre`
--
ALTER TABLE `livre`
  ADD CONSTRAINT `livre_ibfk_1` FOREIGN KEY (`id`) REFERENCES `livres_dvd` (`id`);

--
-- Contraintes pour la table `livres_dvd`
--
ALTER TABLE `livres_dvd`
  ADD CONSTRAINT `livres_dvd_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`);

--
-- Contraintes pour la table `revue`
--
ALTER TABLE `revue`
  ADD CONSTRAINT `revue_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`);

--
-- Contraintes pour la table `suivi`
--
ALTER TABLE `suivi`
  ADD CONSTRAINT `id_equals_commandedocument` FOREIGN KEY (`id`) REFERENCES `commandedocument` (`id`);

--
-- Contraintes pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD CONSTRAINT `id_service_utilisateur` FOREIGN KEY (`idService`) REFERENCES `services` (`idService`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
