/***************************************************************
**
**  Contrainte : Quand on insert un projet le type de projet doit
**  être 1 OU 2 OU 3.
**
**  Objectif : Voir si on peut ajouter un autre type que 1,2 ou 3.
**
**  Test :
**    - On insère un projet avec un type de 1.
**    - On insère un projet avec un type de 4.
**
***************************************************************/

\! cls
\echo '**********************************************'
\echo ' TEST : check table project \n'
\echo '     - type = 1 OU 2 OU 3   '
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion project avec un type de 1 \n'
\echo '     - 1 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, ''2022-10-20'', 1000000, ''Role: Figurant'');\n\n'

-- Valide
INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2022-10-20', 1000000, 'Role: Figurant');

\echo '> SELECT * FROM project WHERE project_id = 1000;\n\n'

SELECT * FROM project WHERE project_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion project avec un type de 4 \n'
\echo '     - 4 : Invalide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1001, 4, ''2022-10-20'', 1000000, ''Role: Figurant'');\n\n'

-- Invalide
INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1001, 4, '2022-10-20', 1000000, 'Role: Figurant');

\echo '> SELECT * FROM project WHERE project_id = 1001;\n\n'

SELECT * FROM project WHERE project_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM project WHERE project_id = 1000;
