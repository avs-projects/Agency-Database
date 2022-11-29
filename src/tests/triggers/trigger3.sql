/***************************************************************
**
**  Contrainte : Quand on insert sur la table participate on
**  doit respecter plusieurs conditons. Si l'artiste est déjà
**  incrit comme participant au projet alors ne l'ajouter
**  (unicité du couple projet-artiste). Quand on insert dans
**  participate alors le type du projet et de l'artiste doivent
**  se correspondre.
**
**  Objectif : Voir si on peut ajouter une ligne qui existe déjà
**  dans participate. Voir si on peut ajouter un type de projet
**  et d'artiste que ne se correpondent pas.
**
**  Test :
**    - On insère une participation avec un couple déjà existant.
**    - On insère une participation avec un type de projet et
**      d'artiste qui se correpondent.
**    - On insère une participation avec un type de projet et
**      d'artiste qui ne se correpondent pas.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1001, 'JACKSON', 'Michael', '1958-08-29');

INSERT INTO actor(artist_id) VALUES (1000);
INSERT INTO musician(musician_id, artist_id, style) VALUES (1000, 1001, 'Jazz');

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2022-10-20', 1000000, 'Role: Figurant');
INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1001, 2, '2022-10-20', 1000000, 'Festival');

\! cls
\echo '**********************************************'
\echo ' TEST : trigger check_participation table\n'
\echo ' participate \n'
\echo '     - unicite du couple projet-artiste \n'
\echo '     - le type du projet et artiste doivent'
\echo '       etre identiques'
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion participate \n'
\echo '     - project_id = 1000\n'
\echo '     - artist_id = 1000\n'
\echo '     - couple inexistant : Valide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO participate(project_id, artist_id) VALUES (1000, 1000);\n'

-- VALIDE, on peut ajouter un couple
INSERT INTO participate(project_id, artist_id) VALUES (1000, 1000);

\echo '\n> SELECT * FROM participate WHERE project_id = 1000;\n'

SELECT * FROM participate WHERE project_id = 1000;

\prompt 'next'
\echo '\n----------------------------------------------'
\echo ' Insertion participate \n'
\echo '     - project_id = 1000\n'
\echo '     - artist_id = 1000\n'
\echo '     - couple existant : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO participate(project_id, artist_id) VALUES (1000, 1000);\n'

-- INVALIDE, on ne peut pas dupliquer un couple
INSERT INTO participate(project_id, artist_id) VALUES (1000, 1000);

\echo '\n> SELECT * FROM participate WHERE project_id = 1000;\n'

SELECT * FROM participate WHERE project_id = 1000;

\prompt 'next'
\echo '\n----------------------------------------------'
\echo ' Insertion participate \n'
\echo '     - project_id = 1001 et type_project = 2\n'
\echo '     - artist_id = 1001 et artiste est un musician\n'
\echo '     - Musician participe a festival (type =) : Valide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO participate(project_id, artist_id) VALUES (1001, 1001);\n'

-- VALIDE, insertion d'un type équivalent
INSERT INTO participate(project_id, artist_id) VALUES (1001, 1001);

\echo '\n> SELECT * FROM participate WHERE project_id = 1000 OR project_id = 1001;\n'

SELECT * FROM participate WHERE project_id = 1000 OR project_id = 1001;

\echo '> SELECT * FROM project WHERE project_id = 1000 OR project_id = 1001;\n'

SELECT * FROM project WHERE project_id = 1000 OR project_id = 1001;

\echo '> SELECT * FROM musician WHERE artist_id = 1001;\n'

SELECT * FROM musician WHERE artist_id = 1001;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion participate \n'
\echo '     - project_id = 1000 et type_project = 1\n'
\echo '     - artist_id = 1001 et artiste est un musician\n'
\echo '     - Musician ne peut pas participer a un film (type non =) : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO participate(project_id, artist_id) VALUES (1000, 1001);\n'

-- INVALIDE, insertion de types non équivalent.
INSERT INTO participate(project_id, artist_id) VALUES (1000, 1001);

\echo '\n> SELECT * FROM participate WHERE project_id = 1000;\n'

SELECT * FROM participate WHERE project_id = 1000;

\echo '> SELECT * FROM project WHERE project_id = 1000;\n'

SELECT * FROM project WHERE project_id = 1000;

\echo '> SELECT * FROM musician WHERE artist_id = 1001;\n'

SELECT * FROM musician WHERE artist_id = 1001;

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id = 1000;
DELETE FROM artist WHERE artist_id = 1001;

DELETE FROM project WHERE project_id = 1000;
DELETE FROM project WHERE project_id = 1001;