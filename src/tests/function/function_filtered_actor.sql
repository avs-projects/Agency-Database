/***************************************************************
**
**  Contrainte : On veut pouvoir avoir la liste des actor qui
**  parlent une certaine langue.

**  Objectif : Voir si on peut filtrer les artistes qui parlent
**  une certaine langue..
**
**  Test :
**    - On insère un ensemble d'actor qui parlent des langues.
**    - On insert un type de profile recherché qui est appelé
**      par la fonction.
**    - On oberve.
**
***************************************************************/

\! cls
\echo '**********************************************'
\echo ' TEST : function filtered_actor\n'
\echo '     - afficher tous id des actor qui parlent\n'
\echo '       francais'
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion artistes avec des artist_id allant\n'
\echo ' de 1000 a 1009 '
\echo '----------------------------------------------\n\n'

INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist)
VALUES (1000, 'CLEMENT', 'Fabien', '1981-05-15'),
       (1001, 'NOEL', 'Gerard', '1986-11-13'),
       (1002, 'LECLERQ', 'Lucas', '1979-07-02'),
       (1003, 'BRUN', 'Valentin', '1983-10-16'),
       (1004, 'ROBIN', 'Herve', '1989-07-21'),
       (1005, 'LUCAS', 'Nicolas', '2001-05-23'),
       (1006, 'MENARD', 'Antoine', '1990-01-01'),
       (1007, 'BARRETTE', 'Edouard', '1956-11-11'),
       (1008, 'BONNEVILLE', 'La Roux', '1976-02-28'),
       (1009, 'TRUDEAU', 'Fabien', '1979-04-26');

\echo '> SELECT * FROM artist WHERE artist_id < 1010 AND artist_id > 999;\n\n'

SELECT * FROM artist WHERE artist_id < 1010 AND artist_id > 999;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion actor pour tous les artist ci-dessus '
\echo '----------------------------------------------\n\n'

INSERT INTO actor(artist_id)
VALUES 	(1000),
      	(1001),
      	(1002),
      	(1003),
      	(1004),
      	(1005),
      	(1006),
      	(1007),
      	(1008),
      	(1009);

\echo '> SELECT * FROM actor WHERE artist_id < 1010 AND artist_id > 999;\n\n'

SELECT * FROM actor WHERE artist_id < 1010 AND artist_id > 999;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion language pour les actor '
\echo '----------------------------------------------\n\n'

INSERT INTO language(actor_id, country)
VALUES 	(1000,'Français'),
      	(1001,'Hindi'),
      	(1002,'Bengali'),
      	(1003,'Ourdou'),
      	(1004,'Français'),
      	(1005,'Français'),
      	(1006,'Arabe'),
      	(1007,'Anglais'),
      	(1008,'Russe'),
      	(1009,'Ourdou');

\echo '> SELECT * FROM language WHERE actor_id < 1010 AND actor_id > 999;\n\n'

SELECT * FROM language WHERE actor_id < 1010 AND actor_id > 999;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Appel de fonction filtered_actor avec comme\n'
\echo ' parametre la langue ''Français'' '
\echo '----------------------------------------------\n\n'

\echo '> SELECT * FROM filtered_actor(''Français'')\n\n'

SELECT * FROM filtered_actor('Français');

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id < 1010 AND artist_id > 999;


