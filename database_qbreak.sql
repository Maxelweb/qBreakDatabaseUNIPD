-- -------------------------------------------------------
--  PROGETTO qBreak (Social Network), BASI DI DATI
-- --------------------------------------
--  Anno 2017-2018
--  Università degli studi di Padova
--  Laurea in Informatica
-- -------------------------------------- 
--  Enrico Buratto
--  Mariano Sciacco
-- -------------------------------------------------------
--
-- INIZIO CREAZIONE STRUTTURA DATABASE
--
-- -------------------------------------------------------
--
-- Rimozione Tabelle se presenti
--

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS chat;
DROP TABLE IF EXISTS commento;
DROP TABLE IF EXISTS follow;
DROP TABLE IF EXISTS foto;
DROP TABLE IF EXISTS foto_in_post;
DROP TABLE IF EXISTS log;
DROP TABLE IF EXISTS notifica;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS progetto;
DROP TABLE IF EXISTS tag_in_post;
DROP TABLE IF EXISTS voto_in_post;

-- --------------------------------------------------------
--
-- Tabella account
--

CREATE TABLE account 
(
  accountID int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  DataReg date NOT NULL,
  Cancellato tinyint(1) NOT NULL DEFAULT 0,
  IsAdmin tinyint(1) NOT NULL DEFAULT 0,
  IsPage tinyint(1) NOT NULL,
  Username varchar(24) NOT NULL UNIQUE,
  Email varchar(64) NOT NULL UNIQUE,
  Password varchar(128) NOT NULL,
  CurrentIP varchar(24) NOT NULL,
  fotoProfiloID int(11) DEFAULT NULL,
  fotoCopertinaID int(11) DEFAULT NULL,
  NumMessaggi int(11) NOT NULL DEFAULT 0,
  NumVoti int(11) NOT NULL DEFAULT 0,
  Nome varchar(24) DEFAULT NULL,
  Cognome varchar(24) DEFAULT NULL,
  DataNascita date DEFAULT NULL,
  Formazione text DEFAULT NULL,
  Skillset text DEFAULT NULL,
  Titolo varchar(120) DEFAULT NULL,
  Descrizione text DEFAULT NULL,

  FOREIGN KEY (fotoProfiloID) REFERENCES foto(fotoID),
  FOREIGN KEY (fotoCopertinaID) REFERENCES foto(fotoID)

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Tabella chat
--

CREATE TABLE chat 
(
  accountMittenteID int(11) NOT NULL,
  accountDestinatarioID int(11) NOT NULL,
  Data timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Contenuto text NOT NULL,
  Visualizzato tinyint(1) NOT NULL DEFAULT 0,

  PRIMARY KEY (accountMittenteID,accountDestinatarioID,Data),
  FOREIGN KEY (accountMittenteID) REFERENCES account(accountID) ON DELETE CASCADE,
  FOREIGN KEY (accountDestinatarioID) REFERENCES account(accountID) ON DELETE CASCADE

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Tabella commento
--

CREATE TABLE commento 
(
  commentoID int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  accountID int(11) NOT NULL,
  postID int(11) NOT NULL,
  Data timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Contenuto text NOT NULL,
  Cancellato tinyint(1) NOT NULL DEFAULT 0,

  FOREIGN KEY (accountID) REFERENCES account(accountID),
  FOREIGN KEY (postID) REFERENCES post(postID) ON DELETE CASCADE

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Tabella follow
--

CREATE TABLE follow 
(
  followerID int(11) NOT NULL,
  followingID int(11) NOT NULL,
  Data timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (followerID,followingID),
  FOREIGN KEY (followerID) REFERENCES account(accountID) ON DELETE CASCADE,
  FOREIGN KEY (followingID) REFERENCES account(accountID) ON DELETE CASCADE

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Tabella foto
--
-- Nota: Non è stato creato il campo blob dal momento che il popolamento della tabella
-- avrebbe appesantito inutilmente il database inutilmente 
--

CREATE TABLE foto 
(
  fotoID int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  accountID int(11) NOT NULL,
  Cancellata tinyint(1) NOT NULL DEFAULT 0,
  Titolo varchar(128) DEFAULT NULL,
  File varchar(128) NOT NULL,
  Data timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (accountID) REFERENCES account(accountID) ON DELETE CASCADE

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Tabella foto_in_post
--

CREATE TABLE foto_in_post 
(
  postID int(11) NOT NULL,
  fotoID int(11) NOT NULL,
  
  PRIMARY KEY (postID, fotoID),
  FOREIGN KEY (postID) REFERENCES post(postID) ON DELETE CASCADE,
  FOREIGN KEY (fotoID) REFERENCES foto(fotoID) ON DELETE CASCADE

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Tabella log
--

CREATE TABLE log 
(
  logID int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  accountID int(11) NOT NULL,
  IsAdminAction tinyint(1) NOT NULL DEFAULT 0,
  IP varchar(16) NOT NULL,
  DataOra timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Descrizione text NOT NULL,

  FOREIGN KEY (accountID) REFERENCES account(accountID) ON DELETE CASCADE

) ENGINE=InnoDB;



-- --------------------------------------------------------

--
-- Tabella notifica
--

CREATE TABLE notifica
(
  notificaID int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  accountID int(11) NOT NULL,
  DataOra timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Descrizione text NOT NULL,
  Visualizzata tinyint(1) NOT NULL DEFAULT 0,

  FOREIGN KEY (accountID) REFERENCES account(accountID) ON DELETE CASCADE

) ENGINE=InnoDB;


-- --------------------------------------------------------

--
-- Tabella post
--

CREATE TABLE post 
(
  postID int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  accountID int(11) NOT NULL,
  Cancellato tinyint(1) NOT NULL DEFAULT 0,
  Data timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Titolo varchar(120) NOT NULL,
  Contenuto text NOT NULL,
  NumVoti int(11) NOT NULL DEFAULT 0,

  FOREIGN KEY (accountID) REFERENCES account(accountID) ON DELETE CASCADE

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Tabella progetto
--

CREATE TABLE progetto 
(
  accountID int(11) NOT NULL,
  Titolo varchar(128) NOT NULL,
  DataInserimento timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  DataUltimaModifica timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  Versione decimal(1,0) NOT NULL,
  Descrizione text NOT NULL,
  Url varchar(128) DEFAULT NULL,

  PRIMARY KEY (accountID, Titolo),
  FOREIGN KEY (accountID) REFERENCES account(accountID) ON DELETE CASCADE

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Struttura della tabella tag_in_post
--

CREATE TABLE tag_in_post (
  postID int(11) NOT NULL,
  Tag varchar(24) NOT NULL,

  PRIMARY KEY (postID,Tag),
  FOREIGN KEY (postID) REFERENCES post(postID) ON DELETE CASCADE

) ENGINE=InnoDB;

-- --------------------------------------------------------

--
-- Tabella voto_in_post
--

CREATE TABLE voto_in_post (
  postID int(11) NOT NULL,
  accountID int(11) NOT NULL,
  Voto tinyint(1) NOT NULL DEFAULT 1,

  PRIMARY KEY (postID, accountID),
  FOREIGN KEY (postID) REFERENCES post(postID) ON DELETE CASCADE,
  FOREIGN KEY (accountID) REFERENCES account(accountID) ON DELETE CASCADE

) ENGINE=InnoDB;


-- -------------------------------------------------------
--
-- FINE CREAZIONE STRUTTURA DATABASE
--
-- -------------------------------------------------------

-- -------------------------------------------------------
--
-- INIZIO POPOLAMENTO DATABASE
--
-- -------------------------------------------------------
--
-- Popolamento Tabella account
--

INSERT INTO account (accountID, DataReg, CurrentIP, Cancellato, IsAdmin, IsPage, Username, Email, Password, fotoProfiloID, fotoCopertinaID, NumMessaggi, NumVoti, Nome, Cognome, DataNascita, Formazione, Skillset, Titolo, Descrizione) VALUES
(1, '2018-01-10', '192.168.0.1', 0, 1, 0, 'Maxel', 'maxelweb@gmail.com', '27cfc2a44d1de0469245b0f641f03ae781ad82aac28b7702ae8d59e7fdb10629', 1, 2, 3, 3, 'Mariano', 'Sciacco', '1997-03-11', 'Università degli studi di Padova, Laurea in Informatica', 'Web Developer, C++ programmer, PAWN programmer, PHP programmer, HTML-CSS-JS programmer, SQL master', NULL, NULL),
(2, '2018-01-10', '192.168.0.2', 0, 1, 0, 'Enricobu6', 'enrico.buratto96@gmail.com', 'cccf330ecd9cba3497c9e729ec707de6bf72859b4338d23759cad1ab72e86885', NULL, NULL, 3, 4, 'Enrico', 'Buratto', '1996-02-20', 'Università degli studi di Padova, Laurea in Informatica', 'C++ programmer, SQL master, Meme Reviewer', NULL, NULL),
(3, '2018-01-18', '192.168.0.1', 0, 0, 0, 'xApple', 'stevejobz@hotmail.com', '34079ad752ce59b9e9ca4fd45a61e29f884bc3bd92079f8b7b0d738efe5674e8', NULL, NULL, 1, 0, 'Cristian', 'Verdi', '1995-08-28', 'Istituto Tecnico Statale di Monza', 'Programmatore C++, Leadership', NULL, NULL),
(4, '2018-01-18', '192.168.0.4', 0, 0, 0, 'BreakTheWall', 'mikeredfield@emaildomain.com', 'a60a52382d7077712def2a69eda3ba309b19598944aa459ce418ae53b7fb5d58', NULL, NULL, 2, 0, 'Michele', 'Camporosso', '1996-04-08', 'Liceo scientifico scienze applicate', 'Photoshop god', NULL, NULL),
(5, '2018-01-18', '192.168.0.5', 0, 0, 0, 'Hikaria', 'antonietta.verdi98@hotmail.com', 'a60a52382d7077712def2a69eda3ba309b19598944aa459ce418ae53b7fb5d58', NULL, NULL, 1, 0, 'Antonietta', 'Verdi', '1998-11-12', 'Istituto tecnico statale', 'Matematica, Programmazione ad oggetti', NULL, NULL),
(6, '2018-01-18', '192.168.0.6', 0, 0, 1, 'Spritz', 'spritzcampari@gmail.com', '7a0bd59b9fe8aac4507e330e4d67dfa18bef7473e7bd81f3b8ff51d89195cb29', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 'SPRITZ GROUP - UNIPD', 'We are a group of young (and less young) researchers very passionate in investigating security and privacy issues related to current and future technologies. The SPRITZ Security and Privacy Research Group was founded (in 2011) and is led by Prof. Mauro Conti. The group is mostly based at the University of Padua, while it enjoys worldwide collaborations.'),
(7, '2018-01-18', '192.168.0.7', 0, 0, 1, 'ZephirCorporation', 'pewds@gmail.com', '371a286d5872a3730d644327581546ec3e658bbf1a3c7f7f0de2bc19905d4402', NULL, NULL, 1, 3, NULL, NULL, NULL, NULL, NULL, 'APOLLO TECHNOLOGIES - PADOVA', 'Siamo una azienda che sviluppa tecnologie di alto livello per il settore industriale. TEL 0123 038302'),
(8, '2018-01-19', '192.168.0.8', 1, 0, 1, 'xyzPwner', 'xyzpwner@tempemail.com', 'f285f5147351f96e3930fc3a347525e8a527b2fd7c69a67a0207f14defff7657', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 'xyzPwner', 'Buy now from 9,99$! click here: sitospam.com/prodotto/roba/123');

--
-- Popolamento Tabella chat
--

INSERT INTO chat (accountMittenteID, accountDestinatarioID, Data, Contenuto, Visualizzato) VALUES
(1, 2, '2018-01-21 18:54:25', 'Ehy sembra funzionare la chat!', 1),
(2, 1, '2018-01-21 18:54:53', 'A quanto pare si, domani finiamo il progetto e lo mandiamo.', 1),
(2, 1, '2018-01-21 18:56:06', 'E non dimenticarti di mandarmi il link della cyberchallenge che la proviamo.', 0),
(2, 6, '2018-01-21 18:57:59', 'Okey, grazie.', 0),
(3, 5, '2018-01-21 19:02:15', 'Si, troppo convenienti a quel prezzo. Credo proprio che mi comprerò qualche droplet, per fare degli esercizi di programmazione in PHP.', 1),
(3, 5, '2018-01-21 19:04:18', 'No, il C++ è sacro, possiamo dire che sia meglio di Java però. ', 0),
(5, 3, '2018-01-21 19:00:05', 'Oi, hai visto le nuove versioni dei droplet di Digital Ocean?', 1),
(5, 3, '2018-01-21 19:03:16', 'Fai bene! Credo che sia il linguaggio del futuro! Sicuramente migliore del C++, non trovi?', 1),
(6, 1, '2018-01-21 18:57:17', 'Stiamo valutando il progetto, a breve manderemo il responso. ', 1);

--
-- Popolamento Tabella commento
--

INSERT INTO commento (commentoID, accountID, postID, Data, Contenuto, Cancellato) VALUES
(1, 2, 2, '2018-01-21 19:57:17', 'I server sono tornati a funzionare correttamente! Buona continuazione.', 0),
(2, 1, 1, '2018-01-21 19:57:42', 'E non dimenticate di followarci!', 0),
(3, 3, 3, '2018-01-21 19:59:42', 'Bella azienda!', 0),
(4, 4, 3, '2018-01-21 19:59:45', 'Bello! Continuate così.', 0),
(5, 4, 1, '2018-01-21 20:01:22', 'Ciao a tutti! Bel social network!', 0),
(6, 5, 1, '2018-01-21 20:25:42', 'Continuate così :)', 0),
(7, 2, 2, '2018-01-20 17:59:42', 'lol', 1);

--
-- Popolamento Tabella follow
--

INSERT INTO follow (followerID, followingID, Data) VALUES
(1, 2, '2018-01-21 18:54:25'),
(1, 5, '2018-01-21 15:41:25'),
(1, 6, '2018-01-20 19:39:25'),
(2, 1, '2018-01-21 13:49:25'),
(2, 5, '2018-01-21 20:54:25'),
(3, 6, '2018-01-20 10:32:16'),
(4, 1, '2018-01-21 15:42:38'),
(4, 3, '2018-01-21 13:46:48'),
(5, 1, '2018-01-21 09:31:40'),
(6, 1, '2018-01-21 20:41:57');

--
-- Popolamento Tabella foto
--

INSERT INTO foto (fotoID, accountID, Cancellata, Titolo, File, Data) VALUES
(1, 1, 0, 'Foto del Profilo', 'agr23873972234.jpg', '2018-01-21 19:40:57'),
(2, 1, 0, 'Foto Copertina', 'aaa3943803844.png', '2018-01-21 19:42:33'),
(3, 7, 0, 'Presentazione azienda', 'abd4098034834.png', '2018-01-21 19:48:20'),
(4, 1, 0, 'Reclutamento Admin', 'abc4459845845.png', '2018-01-22 15:13:33');

--
-- Popolamento Tabella foto_in_post
--

INSERT INTO foto_in_post (postID, fotoID) VALUES
(3, 3),
(4, 4);

--
-- Popolamento Tabella log
--

INSERT INTO log (logID, accountID, IsAdminAction, IP, DataOra, Descrizione) VALUES
(1, 1, 0, '192.168.0.1', '2018-01-10 11:11:00', 'USER_SUBSCRIPTION'),
(2, 1, 0, '192.168.0.1', '2018-01-10 11:11:02', 'USER_ACCESS'),
(3, 2, 0, '192.168.0.2', '2018-01-10 13:35:09', 'USER_SUBSCRIPTION'),
(4, 2, 0, '192.168.0.2', '2018-01-10 13:35:13', 'USER_ACCESS'),
(5, 3, 0, '192.168.0.3', '2018-01-17 23:18:00', 'USER_SUBSCRIPTION'),
(6, 3, 0, '192.168.0.3', '2018-01-17 23:18:04', 'USER_ACTION'),
(7, 4, 0, '192.168.0.4', '2018-01-18 04:00:00', 'USER_SUBSCRIPTION'),
(8, 4, 0, '192.168.0.4', '2018-01-18 04:00:05', 'USER_ACTION'),
(9, 5, 0, '192.168.0.5', '2018-01-18 10:27:04', 'USER_SUBSCRIPTION'),
(10,  5, 0, '192.168.0.5', '2018-01-18 10:27:07', 'USER_ACTION'),
(11,  6, 0, '192.168.0.6', '2018-01-18 12:12:10', 'USER_SUBSCRIPTION'),
(12,  6, 0, '192.168.0.6', '2018-01-18 12:12:15', 'USER_ACTION'),
(13,  7, 0, '192.168.0.7', '2018-01-18 22:18:10', 'USER_SUBSCRIPTION'),
(14,  7, 0, '192.168.0.7', '2018-01-18 22:18:16', 'USER_ACTION'),
(15,  8, 0, '192.168.0.8', '2018-01-19 03:00:07', 'USER_SUBSCRIPTION'),
(16,  8, 0, '192.168.0.8', '2018-01-19 03:00:09', 'USER_ACTION'),
(17,  1, 1, '192.168.0.1', '2018-01-19 14:12:18', 'CHANGE_USERNAME (ID = 6 - NAME: Aperol)'),
(18,  1, 1, '192.168.0.1', '2018-01-19 14:14:07', 'CHANGE_USERNAME (ID = 6 - NAME: Spritz)'),
(19,  1, 0, '192.168.0.1', '2018-01-21 19:07:32', 'USER_SEND_POST (ID = 1)'),
(20,  2, 0, '192.168.0.2', '2018-01-21 19:09:56', 'USER_SEND_POST (ID = 2)'),
(21,  7, 0, '192.168.0.7', '2018-01-21 19:12:38', 'USER_SEND_POST (ID = 3)'),
(22,  1, 0, '192.168.0.1', '2018-01-21 19:40:57', 'USER_ADD_FOTO (ID = 1)'),
(23,  1, 0, '192.168.0.1', '2018-01-21 19:42:33', 'USER_ADD_FOTO (ID = 2)'),
(24,  1, 0, '192.168.0.1', '2018-01-21 19:45:52', 'USER_ACCESS'),
(25,  7, 0, '192.168.0.7', '2018-01-21 19:42:33', 'USER_ADD_FOTO (ID = 3)'),
(26,  2, 0, '192.168.0.2', '2018-01-21 19:55:52', 'USER_ACCESS'),
(27,  2, 0, '192.168.0.2', '2018-01-21 19:57:17', 'USER_SEND_COMMENT (PID = 2)'),
(28,  1, 0, '192.168.0.1', '2018-01-21 19:57:42', 'USER_SEND_COMMENT (PID = 1)'),
(29,  3, 0, '192.168.0.3', '2018-01-21 19:59:42', 'USER_SEND_COMMENT (PID = 3)'),
(30,  4, 0, '192.168.0.4', '2018-01-21 19:59:45', 'USER_SEND_COMMENT (PID = 3)'),
(31,  4, 0, '192.168.0.4', '2018-01-21 20:01:22', 'USER_SEND_COMMENT (PID = 1)'),
(32,  5, 0, '192.168.0.5', '2018-01-21 20:25:42', 'USER_SEND_COMMENT (PID = 1)'),
(33,  1, 0, '192.168.0.1', '2018-01-22 15:13:32', 'USER_SEND_POST (ID = 4)'),
(34,  1, 0, '192.168.0.1', '2018-01-22 15:13:33', 'USER_ADD_FOTO (ID = 4)'),
(35,  8, 0, '192.168.0.8', '2018-01-23 04:11:52', 'USER_SEND_POST (ID = 5)'),
(36,  1, 0, '192.168.0.1', '2018-01-23 10:26:31', 'POST_DELETED (ID = 5)'),
(37,  1, 1, '192.168.0.1', '2018-01-23 10:27:00', 'USER_DELETED (ID = 8)');



--
-- Popolamento Tabella notifica
--

INSERT INTO notifica (notificaID, accountID, DataOra, Descrizione, Visualizzata) VALUES
(1, 7, '2018-01-21 18:59:42', 'xApple ha risposto al tuo post (#3) Presentazione aziendale', 1),
(2, 7, '2018-01-21 18:59:45', 'BreakTheWall ha risposto al tuo post (#3) Presentazione aziendale', 1),
(3, 1, '2018-01-21 19:01:22', 'BreakTheWall ha risposto al tuo post (#1) Primo post', 0),
(4, 1, '2018-01-21 19:25:42', 'Hikaria ha risposto al tuo post (#1) Primo post', 0),
(5, 1, '2018-01-23 14:23:22', 'Enricobu6 ha valutato negativamente il tuo post (#1) Primo post', 1),
(6, 1, '2018-01-23 12:27:18', 'Hikaria ha valutato positivamente il tuo post (#1) Primo post', 1),
(7, 1, '2018-01-23 14:23:22', 'Spritz ha valutato positivamente il tuo post (#1) Primo post', 0),
(8, 2, '2018-01-23 13:31:39', 'Maxel ha valutato positivamente il tuo post (#2) Problemi al server', 0),
(9, 2, '2018-01-23 14:23:22', 'xApple ha valutato positivamente il tuo post (#2) Problemi al server', 0),
(10, 2, '2018-01-23 10:20:22', 'Hikaria ha valutato positivamente il tuo post (#2) Problemi al server', 1),
(11, 2, '2018-01-23 14:23:22', 'Spritz ha valutato positivamente il tuo post (#2) Problemi al server', 0),
(12, 7, '2018-01-23 13:22:22', 'Maxel ha valutato positivamente il tuo post (#3) Presentazione aziendale', 0),
(13, 7, '2018-01-23 13:26:20', 'Enricobu6 ha valutato positivamente il tuo post (#3) Presentazione aziendale', 1),
(14, 7, '2018-01-23 13:25:19', 'BreakTheWall ha valutato positivamente il tuo post (#3) Presentazione aziendale', 0);


--
-- Popolamento Tabella post
--

INSERT INTO post (postID, accountID, Cancellato, Data, Titolo, Contenuto, NumVoti) VALUES
(1, 1, 0, '2018-01-21 19:07:32', 'Primo post', 'Diamo il benvenuto a tutti gli utenti del social network! Buona permanenza :)', 2),
(2, 2, 0, '2018-01-21 19:09:56', 'Problemi al server', 'Stiamo riscontrando alcuni problemi al server per via del grande traffico di utenti che si sta registrando, vi preghiamo di attendere che nelle prossime ore risolveremo aumentando le risorse del sistema.', 4),
(3, 7, 0, '2018-01-21 19:12:38', 'Presentazione aziendale', 'Salve a tutti, ci siamo iscritti perchè crediamo in questo progetto. Il sito è molto bello così come tutti gli algoritmi dietro. Se siete interessati, noi siamo una azienza che opera nel settore industriale introducendo nuove tecnologie. Per proposte di lavoro potete contattarci in privato.', 3),
(4, 1, 0, '2018-01-22 15:13:32', 'Apertura Candidature Amministratori', 'Volete diventare admin del social network? Inviate la vostra candidatura attraverso la sezione contatti e verrete valutati!', 0),
(5, 8, 1, '2018-01-23 04:11:52', 'Buy Arduino for 9,99$!', 'sitospam.com/prodottospam/12345.html - CLICK HERE FOR 9,99$', 0);


--
-- Popolamento Tabella progetto
--

INSERT INTO progetto (accountID, Titolo, DataInserimento, DataUltimaModifica, Versione, Descrizione, Url) VALUES
(1, 'qBreak - Social Network', '2018-01-21 19:20:34', '2018-01-21 19:20:34', '1', 'qBreak è un social network per programmatori e amanti della tecnologia! Chiunque può registrarsi e può fare domande direttamente agli esperti o semplicemente condividere le proprie idee e i propri lavori. Il progetto è un sito web realizzato in PHP 7 con Lavarel Framework, HTML, CSS3, Bootstrap4, JQuery e NodeJS.', 'https://www.qbreak.net'),
(2, 'qRepair - Social Newtwork', '2018-01-21 19:20:34', '2018-01-21 19:20:34', '0', 'qRepair è un progetto in pre-alpha che riguarda un social network in stile iFixIt per poter condividere i propri aiuti nella riparazione e il mantenimento di telefoni, tablet e computer.', NULL);

--
-- Popolamento Tabella tag_in_post
--

INSERT INTO tag_in_post (postID, Tag) VALUES
(1, 'welcome'),
(1, 'annuncio'),
(1, 'admin'),
(2, 'manutenzione'),
(3, 'proposte di lavoro'),
(3, 'tecnologia'),
(4, 'admin'),
(5, 'freedelivery');

--
-- Popolamento Tabella voto_in_post
--

INSERT INTO voto_in_post (postID, accountID, Voto) VALUES
(1, 2, 0),
(1, 5, 1),
(1, 6, 1),
(2, 1, 1),
(2, 3, 1),
(2, 5, 1),
(2, 6, 1),
(3, 1, 1),
(3, 2, 1),
(3, 4, 1);

-- -------------------------------------------------------
--
-- FINE POPOLAMENTO DATABASE
--
-- -------------------------------------------------------

-- -------------------------------------------------------
--
-- INIZIO FUNZIONI
--
-- -------------------------------------------------------
--
-- Rimozione Funzioni se presenti
--


DROP FUNCTION IF EXISTS ConflittoIP;
DROP FUNCTION IF EXISTS MostUsedTag;


-- --------------------------------------------------------
--
-- Funzione per il conflitto di indirizzo IP
--


DELIMITER ||
CREATE FUNCTION ConflittoIP(aid integer) RETURNS boolean
BEGIN
  DECLARE ip varchar(24);

  SELECT CurrentIP
  INTO ip
  FROM account
  WHERE accountID = aid;

  IF(SELECT COUNT(*) FROM account a WHERE a.CurrentIP = ip AND a.accountID != aid) > 0
  THEN  
    RETURN true;
  ELSE
    RETURN false;
  END IF;
END ||
DELIMITER ;


-- --------------------------------------------------------
--
-- Funzione per i tag piu usati da un utente
--

DELIMITER ||
CREATE FUNCTION MostUsedTag(aid integer, type tinyint(1)) RETURNS varchar(32) 
BEGIN
  DECLARE tag varchar(32);
  DECLARE ntag int(11);

  SELECT tip.Tag, COUNT(tip.Tag)
  INTO tag, ntag
  FROM tag_in_post tip JOIN post p ON tip.postID = p.postID
  WHERE p.accountID = aid
  GROUP BY tip.Tag
  ORDER BY tip.postID DESC
  LIMIT 1;

  IF(type > 0)
  THEN
    RETURN tag;
  ELSE
    RETURN ntag;
  END IF;

END ||
DELIMITER ;

-- -------------------------------------------------------
--
-- FINE FUNZIONI
--
-- -------------------------------------------------------

-- -------------------------------------------------------
--
-- INIZIO TRIGGERS
--
-- -------------------------------------------------------
--
-- Rimozione Triggers se presenti
--

DROP TRIGGER IF EXISTS ControlloIscrizione;
DROP TRIGGER IF EXISTS ControlloUtente;
DROP TRIGGER IF EXISTS LogUserSubscription;
DROP TRIGGER IF EXISTS SendPost;
DROP TRIGGER IF EXISTS SendComment;
DROP TRIGGER IF EXISTS LogAddFoto;
DROP TRIGGER IF EXISTS LogAddProject;

DROP TRIGGER IF EXISTS UpdateNumMessaggiByPost;
DROP TRIGGER IF EXISTS UpdateNumMessaggiByComment;
DROP TRIGGER IF EXISTS AddNumVoti;
DROP TRIGGER IF EXISTS RemoveNumVoti;



-- --------------------------------------------------------
--
-- Trigger ControlloIscrizione OK
--

DELIMITER || 
CREATE TRIGGER ControlloIscrizione
BEFORE INSERT ON account 
FOR EACH ROW 
BEGIN
  DECLARE msg varchar(200);
  DECLARE n int(11);

  IF (New.IsPage > 0)  
  THEN
    IF  (New.Nome IS NOT NULL) OR 
      (New.Cognome IS NOT NULL) OR 
      (New.DataNascita IS NOT NULL) OR 
      (New.Skillset IS NOT NULL) OR
      (New.Formazione IS NOT NULL)
    THEN  
      SET msg = "La pagina non può avere come attributi Nome, Cognome, Data di nascita, Abilità e Formazione.";
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
  ELSE
    IF  (New.Titolo IS NOT NULL) OR 
        (New.Descrizione IS NOT NULL)
    THEN
      SET msg = "Un utente non può avere come attributi Titolo e Descrizione.";
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
  END IF;


  SELECT COUNT(*) INTO n FROM account WHERE Username = New.Username AND accountID != New.accountID; 
  IF(n <> 0)
  THEN 
    SET msg = "Lo username inserito risulta già presente nel database.";
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
  END IF;

  SELECT COUNT(*) INTO n FROM account WHERE Email = New.Email AND accountID != New.accountID; 
  IF(n <> 0)
  THEN 
    SET msg = "L'email inserita risulta già presente nel database.";
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
  END IF; 

END ||
DELIMITER ;


-- --------------------------------------------------------
--
-- Trigger ControlloUtente OK
--

DELIMITER || 
CREATE TRIGGER ControlloUtente
BEFORE UPDATE ON account 
FOR EACH ROW 
BEGIN
  DECLARE msg varchar(200);
  DECLARE n int(11);

  IF (New.IsAdmin > 0)   
  THEN
    IF (New.Cancellato > 0)
    THEN  
      SET msg = "Un admin deve essere un utente attivo!";
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
  END IF;

  IF(New.Username <> Old.Username)
  THEN
    SELECT COUNT(*) INTO n FROM account WHERE Username = New.Username AND accountID != New.accountID; 
    IF(n <> 0)
    THEN 
      SET msg = "Il nuovo username per l'utente risulta già presente nel database.";
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
  END IF;

  IF(New.Email <> Old.Email)
  THEN
    SELECT COUNT(*) INTO n FROM account WHERE Email = New.Email AND accountID != New.accountID; 
    IF(n <> 0)
    THEN 
      SET msg = "La nuova email per l'utente risulta già presente nel database.";
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;
  END IF;
END ||
DELIMITER ;


-- --------------------------------------------------------
--
-- Trigger LogUserSubscription OK
--

DELIMITER || 
CREATE TRIGGER LogUserSubscription
AFTER INSERT ON account 
FOR EACH ROW 
BEGIN
  INSERT INTO log (accountID, IP, Descrizione) 
  VALUES (New.accountID, New.CurrentIP, 'USER_SUBSCRIPTION');
END ||
DELIMITER ;



-- --------------------------------------------------------
--
-- Trigger SendPost OK
--

DELIMITER || 
CREATE TRIGGER SendPost
AFTER INSERT ON post 
FOR EACH ROW 
BEGIN
  DECLARE UserIP varchar(24);
  DECLARE Azione varchar(64);

  SELECT a.CurrentIP 
  INTO UserIP 
  FROM account a 
  WHERE a.accountID = New.accountID
  LIMIT 1;

  UPDATE account
  SET NumMessaggi = NumMessaggi+1
  WHERE accountID = New.accountID
  LIMIT 1;

  SET Azione = CONCAT('USER_SEND_POST (ID = ', New.postID, ')');
  INSERT INTO log (accountID, IP, Descrizione) 
  VALUES (New.accountID, UserIP, Azione);
END ||
DELIMITER ;


-- --------------------------------------------------------
--
-- Trigger SendComment OK
--

DELIMITER || 
CREATE TRIGGER SendComment
AFTER INSERT ON commento 
FOR EACH ROW 
BEGIN
  DECLARE AuthorID int(11);
  DECLARE UserIP varchar(24);
  DECLARE Azione varchar(64);
  DECLARE DescNot varchar(256);
  DECLARE FromUsername varchar(24); 
  DECLARE TitoloPost varchar(128); 

  SELECT a.CurrentIP 
  INTO UserIP 
  FROM account a 
  WHERE a.accountID = New.accountID
  LIMIT 1;

  UPDATE account
  SET NumMessaggi = NumMessaggi+1
  WHERE accountID = New.accountID
  LIMIT 1;

  SELECT accountID, Titolo
  INTO AuthorID, TitoloPost 
  FROM post 
  WHERE postID = New.postID
  LIMIT 1;

  SELECT Username
  INTO FromUsername 
  FROM account 
  WHERE accountID = New.accountID
  LIMIT 1;

  IF (AuthorID <> New.accountID)
  THEN 
    SET DescNot = CONCAT(FromUsername, ' ha risposto al tuo post (#', New.postID, ') ', TitoloPost);
    INSERT INTO notifica (accountID, DataOra, Descrizione) VALUES (AuthorID, New.Data, DescNot);
  END IF;

  SET Azione = CONCAT('USER_SEND_COMMENT (ID = ', New.commentoID, ')', ' (PID = ', New.postID, ')');
  INSERT INTO log (accountID, IP, Descrizione) 
  VALUES (New.accountID, UserIP, Azione);
END ||
DELIMITER ;



-- --------------------------------------------------------
--
-- Trigger LogAddFoto OK
--

DELIMITER || 
CREATE TRIGGER LogAddFoto
AFTER INSERT ON foto 
FOR EACH ROW 
BEGIN
  DECLARE UserIP varchar(24);
  DECLARE Azione varchar(64);

  SELECT a.CurrentIP 
  INTO UserIP 
  FROM account a 
  WHERE a.accountID = New.accountID
  LIMIT 1;

  SET Azione = CONCAT('USER_ADD_FOTO (ID = ', New.fotoID, ')');
  INSERT INTO log (accountID, IP, Descrizione) 
  VALUES (New.accountID, UserIP, Azione);
END ||
DELIMITER ;



-- --------------------------------------------------------
--
-- Trigger LogAddProject OK
--

DELIMITER || 
CREATE TRIGGER LogAddProject
AFTER INSERT ON progetto
FOR EACH ROW 
BEGIN
  DECLARE UserIP varchar(24);
  DECLARE Azione varchar(256);

  SELECT a.CurrentIP 
  INTO UserIP 
  FROM account a 
  WHERE a.accountID = New.accountID
  LIMIT 1;

  SET Azione = CONCAT('USER_ADD_PROJECT (NAME = ', New.Titolo, ')');
  INSERT INTO log (accountID, IP, Descrizione) 
  VALUES (New.accountID, UserIP, Azione);
END ||
DELIMITER ;


-- --------------------------------------------------------
--
-- Trigger UpdateNumMessaggiByPost OK
--

DELIMITER || 
CREATE TRIGGER UpdateNumMessaggiByPost
AFTER UPDATE ON post 
FOR EACH ROW 
BEGIN
  IF (New.Cancellato = 1) AND (Old.Cancellato != New.Cancellato)
  THEN
    UPDATE account
    SET NumMessaggi = NumMessaggi-1
    WHERE accountID = New.accountID
    LIMIT 1;
  ELSEIF (New.Cancellato = 0) AND (Old.Cancellato != New.Cancellato) 
  THEN
    UPDATE account
    SET NumMessaggi = NumMessaggi+1
    WHERE accountID = New.accountID
    LIMIT 1;
  END IF;
END ||
DELIMITER ;


-- --------------------------------------------------------
--
-- Trigger UpdateNumMessaggiByComment OK
--

DELIMITER || 
CREATE TRIGGER UpdateNumMessaggiByComment
AFTER UPDATE ON commento
FOR EACH ROW 
BEGIN
  IF (New.Cancellato = 1) AND (Old.Cancellato != New.Cancellato) 
  THEN
    UPDATE account
    SET NumMessaggi = NumMessaggi-1
    WHERE accountID = New.accountID
    LIMIT 1;
  ELSEIF (New.Cancellato = 0) AND (Old.Cancellato != New.Cancellato) 
  THEN
    UPDATE account
    SET NumMessaggi = NumMessaggi+1
    WHERE accountID = New.accountID
    LIMIT 1;
  END IF;
END ||
DELIMITER ;



-- --------------------------------------------------------
--
-- Trigger AddNumVotiPost OK
--

DELIMITER || 
CREATE TRIGGER AddNumVoti
AFTER INSERT ON voto_in_post
FOR EACH ROW 
BEGIN
  DECLARE AuthorID int(11);
  DECLARE DescrizioneNot text;
  DECLARE FromUsername varchar(24); 
  DECLARE TitoloPost varchar(24); 
  DECLARE t int(1);

  IF (New.Voto > 0) 
  THEN
    SET t = 1;
  ELSE
    SET t = -1;
  END IF; 

  UPDATE post
  SET NumVoti = (NumVoti+t)
  WHERE postID = New.postID
  LIMIT 1;

  SELECT p.accountID, p.Titolo 
  INTO AuthorID,TitoloPost 
  FROM post p 
  WHERE p.postID = New.postID 
  LIMIT 1;

  UPDATE account
  SET NumVoti = (NumVoti+1)
  WHERE accountID = AuthorID
  LIMIT 1;

  SELECT Username
  INTO FromUsername 
  FROM account 
  WHERE accountID = New.accountID
  LIMIT 1;

  IF (AuthorID <> New.accountID)
  THEN 
    IF( t > 0)
    THEN
      SET DescrizioneNot = CONCAT(FromUsername, ' ha valutato positivamente il tuo post (#', New.postID, ') ', TitoloPost);
    ELSE
      SET DescrizioneNot = CONCAT(FromUsername, ' ha valutato negativamente il tuo post (#', New.postID, ') ', TitoloPost);
    END IF;

    INSERT INTO notifica (accountID, Descrizione) VALUES (AuthorID, DescrizioneNot);

  END IF;

END ||
DELIMITER ;

-- --------------------------------------------------------
--
-- Trigger RemoveNumVotiPost OK
--

DELIMITER || 
CREATE TRIGGER RemoveNumVoti
AFTER DELETE ON voto_in_post
FOR EACH ROW 
BEGIN
  DECLARE AuthorID int(11);
  DECLARE t int(1);

  IF (Old.Voto > 0) 
  THEN
    SET t = -1;
  ELSE
    SET t = 1;
  END IF; 

  UPDATE post
  SET NumVoti = (NumVoti+t)
  WHERE postID = Old.postID
  LIMIT 1;

  SELECT p.accountID INTO AuthorID FROM post p WHERE p.postID = Old.postID LIMIT 1;

  UPDATE account
  SET NumVoti = (NumVoti-1)
  WHERE accountID = AuthorID
  LIMIT 1;

END ||
DELIMITER ;


-- -------------------------------------------------------
--
-- FINE TRIGGERS
--
-- -------------------------------------------------------


-- -------------------------------------------------------
--
-- INIZIO PROCEDURE, VIEW
--
-- -------------------------------------------------------
--
-- Rimozione se presenti
--

DROP PROCEDURE IF EXISTS commenti_post;
DROP PROCEDURE IF EXISTS visualizza_post;
DROP PROCEDURE IF EXISTS visualizza_chat;
DROP PROCEDURE IF EXISTS bacheca;
DROP VIEW IF EXISTS attivi;
DROP VIEW IF EXISTS admins;
DROP VIEW IF EXISTS cancellati;
DROP VIEW IF EXISTS conflittoIP;
DROP VIEW IF EXISTS attivi;
DROP VIEW IF EXISTS StatisticheTags;
DROP VIEW IF EXISTS StatisticheUtenti;
DROP VIEW IF EXISTS TagsPerUtente;

-- --------------------------------------------------------
--
--  Visualizzazione del numero di utenti attivi, utenti admin e utenti cancellati
--

CREATE VIEW attivi AS  
    SELECT COUNT(accountID) as "Utenti attivi"
    FROM account 
    WHERE Cancellato='0';
CREATE VIEW admins AS 
    SELECT COUNT(accountID) as "Utenti amministratori"
    FROM account 
    WHERE IsAdmin='1';
CREATE VIEW cancellati AS 
    SELECT COUNT(accountID) as "Utenti cancellati"
    FROM account 
    WHERE Cancellato='1';

-- --------------------------------------------------------
--
--  Visualizzazione utenti con conflitto di indirizzo IP
--

CREATE VIEW conflittoIP AS 
    SELECT a.Username,a.IsPage as "Pagina(1) - Utente(0)", a.CurrentIP as "IP"
    FROM account a
    WHERE ConflittoIP(a.accountID)=1;


-- --------------------------------------------------------
--
-- Visualizzazione dei commenti attivi relativi ad un post
--

DELIMITER ||
CREATE PROCEDURE commenti_post(idp INT(11))
BEGIN
SELECT a.Username, com.Data, com.Contenuto
FROM commento com, post p, account a
WHERE p.postID=idp AND com.postID=p.postID AND a.accountID=com.acccountID AND p.Cancellato=0;
END ||
DELIMITER ;

-- --------------------------------------------------------
--
-- Procedura di visualizzazione chat tra due utenti
--

DELIMITER ||
CREATE PROCEDURE visualizza_chat (id1 INT(11), id2 INT(11)) 
BEGIN 
SELECT  a.Username, c.Data, c.Contenuto, c.Visualizzato 
FROM account a, chat c 
WHERE (c.accountMittenteID=id1 AND c.accountDestinatarioID=id2 AND a.accountID=id1) OR (c.accountMittenteID=id2 AND c.accountDestinatarioID=id1 AND a.accountID=id2) 
ORDER BY c.Data ASC;  
END || 
DELIMITER ;


-- --------------------------------------------------------
--
-- Procedura per vedere un post con foto o senza
--

DELIMITER ||
CREATE PROCEDURE visualizza_post(idp INT(11))
BEGIN 
SELECT a.Username, p.Titolo, p.Contenuto, p.NumVoti, p.Data, tip.Tag, f.Titolo AS "Titolo Foto", f.File AS "Foto" 
FROM post p, foto f, foto_in_post fip, tag_in_post tip, account a
WHERE p.postID=idp AND p.Cancellato=0 AND f.Cancellata=0 AND p.postID=fip.postID AND fip.fotoID=f.fotoID AND tip.postID=p.postID AND p.accountID=a.accountID; 
END ||
DELIMITER ;


-- --------------------------------------------------------
--
-- Visualizzazione dei tags più popolari
--

CREATE VIEW StatisticheTags AS 
SELECT Tag, COUNT(Tag) as "Numero Tag" 
FROM tag_in_post 
GROUP BY Tag 
ORDER BY COUNT(Tag);


-- --------------------------------------------------------
--
-- Procedura per vedere i post degli account followati (bacheca)
--

DELIMITER ||
CREATE PROCEDURE bacheca (id INT(11))
BEGIN 
SELECT DISTINCT a.Username, p.postID
FROM account a, post p, follow fol 
WHERE p.Cancellato=0 AND a.accountID=p.accountID AND fol.followerID=id 
ORDER BY p.Data DESC; 
END ||
DELIMITER ;


-- --------------------------------------------------------
--
-- Visualizzare il numero medio di voti (numvoti) e il numero medio di messaggi (nummessaggi) da utenti e pagine entrambi non cancellate
--

CREATE VIEW StatisticheUtenti AS
SELECT a.IsPage AS "Utente (0) o pagina (1)", 
       AVG(a.NumVoti) AS "Numero medio voti", 
       AVG(a.NumMessaggi) AS "Numero medio messaggi" 
FROM account a 
WHERE a.Cancellato=0 
GROUP BY a.IsPage;

-- --------------------------------------------------------
--
-- Visualizzazione del numero di tag inseriti per ogni utente
--

CREATE VIEW TagsPerUtente AS
SELECT a.Username, COUNT(*) 
FROM account a, tag_in_post tip, post p 
WHERE p.accountID=a.accountID AND tip.postID=p.postID 
GROUP BY a.accountID;


-- -------------------------------------------------------
--
-- FINE PROCEDURE, VIEW, FUNZIONI
--
-- -------------------------------------------------------
-- -------------------------------------------------------
--
--  Fine del file
--
-- -------------------------------------------------------