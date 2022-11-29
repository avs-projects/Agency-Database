/***************************************************************
**
**  Contrainte : Quand on insert une demande, la date du début
**  doit être inférieur à la date de fin.
**
**  Objectif : Voir si on peut ajouter une date de début supérieur
**  à la date de fin de la demande.
**
**  Test :
**    - On insère une demande avec une date de début inférieur
**      à la date de fin.
**    - On insère une demande avec une date de début supérieur
**      à la date de fin.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2020-10-20', 1000000, 'Role: Figurant');

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Français', 6, null);

ALTER TABLE demand DISABLE TRIGGER fill_propose_trigger;

\! cls
\echo '**********************************************'
\echo ' TEST : check table demand \n'
\echo '     - date debut < date fin de contrat'
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion demand avec une date de debut de\n'
\echo ' 2021-10-20 et de fin 2026-2-21\n'
\echo '     - 2021-10-20 < 2026-2-21 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, ''2021-10-20'', ''2026-2-21'');\n\n'

-- Valide
INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2021-10-20', '2026-2-21');

\echo '> SELECT * FROM demand WHERE demand_id = 1000;\n\n'

SELECT * FROM demand WHERE demand_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion demand avec une date de debut de\n'
\echo ' 2028-10-20 et de fin 2026-2-21\n'
\echo '     - 2028-10-20 > 2026-2-21 : Invalide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1001, 1000, 1000, 1000, ''2028-10-20'', ''2026-2-21'');\n\n'

-- Invalide
INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1001, 1000, 1000, 1000, '2028-10-20', '2026-2-21');

\echo '> SELECT * FROM demand WHERE demand_id = 1001;\n\n'

SELECT * FROM demand WHERE demand_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;

ALTER TABLE demand ENABLE TRIGGER ALL;