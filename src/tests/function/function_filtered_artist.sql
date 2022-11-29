/***************************************************************
**
**  Contrainte : On veut pouvoir avoir la liste des artist avec
**  un type spécifique.
**
**  Objectif : Voir si on peut filtrer les artist en fonction
**  de leur type (Musician, Actor).
**
**  Test :
**    - On insère un ensemble artist avec des types différents.
**    - On insert un type de profile recherché qui est appelé
**      par la fonction.
**    - On oberve.
**
***************************************************************/

\! cls
\echo '**********************************************'
\echo ' TEST : function filtered_artist\n'
\echo '     - afficher tous id des actor  '
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion artistes avec des artist_id allant\n'
\echo ' de 1000 à 1009 '
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
\echo ' Insertion musician pour une partie des artist\n'
\echo ' ci-dessus '
\echo '----------------------------------------------\n\n'

INSERT INTO musician(musician_id, artist_id, style)
VALUES  (1006, 1006,'Metal'),
      	(1007, 1007,'Electro'),
      	(1008, 1008,'Jazz'),
      	(1009, 1009,'Reggae');

\echo '> SELECT * FROM musician WHERE artist_id < 1010 AND artist_id > 1005;\n\n'

SELECT * FROM musician WHERE artist_id < 1010 AND artist_id > 1005;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion actor pour une partie des artist\n'
\echo ' ci-dessus '
\echo '----------------------------------------------\n\n'

INSERT INTO actor(artist_id)
VALUES 	(1000),
      	(1001),
      	(1002),
      	(1003),
      	(1004),
      	(1005);

\echo '> SELECT * FROM actor WHERE artist_id < 1006 AND artist_id > 999;\n\n'

SELECT * FROM actor WHERE artist_id < 1006 AND artist_id > 999;

\prompt 'next'

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2020-10-20', 1000000, 'Role: Figurant');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, null, null, null);

\echo '----------------------------------------------'
\echo ' Appel de fonction filtered_artist avec comme\n'
\echo ' parametre le profile et le project ''1000 et 1000'' '
\echo '----------------------------------------------\n\n'

\echo '> SELECT * FROM filtered_artist(''1000, 1000'');\n\n'

SELECT * FROM filtered_artist(1000, 1000);

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id < 1010 AND artist_id > 999;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;
