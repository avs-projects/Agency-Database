/***************************************************************
**
**  Contrainte : Quand on ajoute une demande, la date de début
**  de la demande doit être supérieur à la date du projet.
**
**  Objectig : Voir si l'on peut ajouter une date de début
**  de demande inférieur à la date du projet.
**
**  Test 1 :
**    - On ajoute un projet avec une date : '2022-10-20'.
**    - On ajoute une demande avec une date supérieur : '2021-10-20'.
**    - On ajoute une demande avec une date inférieur : '2023-10-20'.
**    - On compare les dates en fonction du résultat.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');

INSERT INTO actor(artist_id) VALUES (1000);

INSERT INTO critic(critic_id, artist_id, remarque) VALUES (1000, 1000, 10);

INSERT INTO language(actor_id, country) VALUES (1000, 'Français');

INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa,end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2022-05-4', '2026-05-4', 25);

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Français', 6, null);

\! cls
\echo '**********************************************'
\echo ' TEST : trigger insert_demand_check_date table\n'
\echo ' demand \n'
\echo '     - verifie si la date de debut de demand\n'
\echo '       est inferieur a la date de projet '
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion project \n'
\echo '     - date_project = 2020-10-20'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, ''2020-10-20'', 1000000, ''Role: Figurant'');\n'

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2020-10-20', 1000000, 'Role: Figurant');

\echo '\n> SELECT * FROM project WHERE project_id = 1000;\n'

SELECT * FROM project WHERE project_id = 1000;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion demand \n'
\echo '     - date_project = 2020-10-20\n'
\echo '     - start_date_demand = 2021-10-20\n'
\echo '     - start_date_demand < date_project : Valide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, ''2021-10-20'', ''2026-2-21'');\n'

-- VALIDE
INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2021-10-20', '2026-2-21');

\echo '\n> SELECT * FROM demand WHERE demand_id = 1000;\n'

SELECT * FROM demand WHERE demand_id = 1000;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion demand \n'
\echo '     - date_project = 2022-10-20\n'
\echo '     - start_date_demand = 2023-10-20\n'
\echo '     - start_date_demand > date_project : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1001, 1000, 1000, 1000, ''2023-10-20'', ''2026-2-21'');\n'

-- INVALIDE
INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1001, 1000, 1000, 1000, '2019-10-20', '2026-2-21');

\echo '\n> SELECT * FROM demand WHERE demand_id = 1001;\n'

SELECT * FROM demand WHERE demand_id = 1001;

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id = 1000;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;