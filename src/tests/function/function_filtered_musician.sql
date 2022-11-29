/***************************************************************
**
**  Contrainte : On veut pouvoir avoir la liste des musician
**  avec le style.

**  Objectif : Voir si on peut filtrer les musician en fonction
**  de leur style.
**
**  Test :
**    - On insère un ensemble musician avec des style.
**    - On insert un type de profile recherché qui est appelé
**      par la fonction.
**    - On oberve.
**
***************************************************************/

\! cls
\echo '**********************************************'
\echo ' TEST : function filtered_musician\n'
\echo '     - afficher tous id des musician qui ont\n'
\echo '       pour style ''jazz'''
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
\echo ' Insertion musician pour tous les musician ci-dessus '
\echo '----------------------------------------------\n\n'

INSERT INTO musician(musician_id, artist_id, style)
VALUES 	(1000, 1000,'Funk'),
      	(1001, 1001,'Jazz'),
      	(1002, 1002,'Reggae'),
      	(1003, 1003,'Hip-hop'),
      	(1004, 1004,'Jazz'),
      	(1005, 1005,'Hip-hop'),
      	(1006, 1006,'Metal'),
      	(1007, 1007,'Electro'),
      	(1008, 1008,'Jazz'),
      	(1009, 1009,'Reggae');

\echo '> SELECT * FROM musician WHERE artist_id < 1010 AND artist_id > 999;\n\n'

SELECT * FROM musician WHERE artist_id < 1010 AND artist_id > 999;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Appel de fonction filtered_musician avec comme\n'
\echo ' parametre style ''Jazz'' '
\echo '----------------------------------------------\n\n'

\echo '> SELECT * FROM filtered_musician(''Jazz'');\n\n'

SELECT * FROM filtered_musician('Jazz');

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id < 1010 AND artist_id > 999;


