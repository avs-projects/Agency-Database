/***************************************************************
**
**  Contrainte : Quand on insert une critique, la note doit être
**  comprise dans la borne 0 et 10.
**
**  Objectif : Voir si on peut ajouter une critique hors de la
**  borne.
**
**  Test :
**    - On insère une critique de 8.
**    - On insère une critique de 20.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');

\! cls
\echo '**********************************************'
\echo ' TEST : check table critic \n'
\echo '     - 0 < remarque < 10   '
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion critic avec un remarque de 8 \n'
\echo '     - 0 < 8 < 10 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO critic(critic_id, artist_id, remarque) VALUES (1000, 1000, 8);\n\n'

INSERT INTO critic(critic_id, artist_id, remarque) VALUES (1000, 1000, 8);

\echo '> SELECT * FROM critic WHERE critic_id = 1000;\n\n'

SELECT * FROM critic WHERE critic_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion critic avec un remarque de 20 \n'
\echo '     - 20 > 10 : Invalide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO critic(critic_id, artist_id, remarque) VALUES (1001, 1000, 20);\n\n'

INSERT INTO critic(critic_id, artist_id, remarque) VALUES (1001, 1000, 20);

\echo '> SELECT * FROM critic WHERE critic_id = 1001;\n\n'

SELECT * FROM critic WHERE critic_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM artist WHERE artist_id = 1000;