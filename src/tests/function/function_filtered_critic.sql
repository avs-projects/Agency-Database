/***************************************************************
**
**  Contrainte : On veut pouvoir avoir la liste des artiste en
**  fonction de la moyenne de leur critic.
**
**  Objectif : Voir si on peut filtrer les artistes en fonction
**  de leur moyenne de critic.
**
**  Test :
**    - On insère un ensemble artist avec des critic.
**    - On insert un type de profile recherché qui est appelé
**      par la fonction.
**    - On oberve.
**
***************************************************************/

\! cls
\echo '**********************************************'
\echo ' TEST : function filtered_critic\n'
\echo '     - afficher tous les id des artist qui ont\n'
\echo '       une moyenne de critic superieur a 9 '
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
\echo ' Insertion critic pour tous les artist ci-dessus '
\echo '----------------------------------------------\n\n'

INSERT INTO critic(artist_id, remarque)
VALUES 	(1000,0),
      	(1001,9.5),
      	(1002,9.80),
      	(1003,9.5),
      	(1004,9.75),
      	(1005,3),
      	(1006,2),
      	(1007,8),
      	(1008,1),
      	(1009,0);

\echo '> SELECT * FROM critic WHERE artist_id < 1010 AND artist_id > 999;\n\n'

SELECT * FROM critic WHERE artist_id < 1010 AND artist_id > 999;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Appel de fonction filtered_critic avec comme\n'
\echo ' parametre style ''9'' '
\echo '----------------------------------------------\n\n'

\echo '> SELECT * FROM filtered_critic(9);\n\n'

SELECT * FROM filtered_critic(9);

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id < 1010 AND artist_id > 999;