/***************************************************************
**
**  Contrainte : Quand on insert un artiste, sa date de naissance
**  doit être inférieur à celle du jour.
**
**  Objectif : Voir si on peut ajouter une date de naissance
**  supérieur à aujourd'hui.
**
**  Test :
**    - On insère un artiste avec une date de naissance inférieur
**      a celle du jour. (Insertion)
**    - On insère un artiste avec une date de naissance supérieur
**      a celle du jour. (Erreur)
**
***************************************************************/

\! cls
\echo '**********************************************'
\echo ' TEST : check table artist\n'
\echo '     - date naissance < date du jour'
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion artiste nee en 1967 \n'
\echo '     - 1967 < 2022 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, ''ROBERT'', ''Julia'', ''1967-10-28'');\n\n'

-- Valide
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');

\echo '> SELECT * FROM artist WHERE artist_id = 1000;\n\n'

SELECT * FROM artist WHERE artist_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion artiste nee en 2023 \n'
\echo '     - 2023 > 2022 : Invalide '
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1001, ''ROBERT'', ''Jules'', ''2023-09-8'');\n\n'

-- Invalide
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1001, 'ROBERT', 'Jules', '2023-09-8');

\echo '> SELECT * FROM artist WHERE artist_id = 1001;\n\n'

SELECT * FROM artist WHERE artist_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM artist WHERE artist_id = 1000;