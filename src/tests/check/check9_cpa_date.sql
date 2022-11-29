/***************************************************************
**
**  Contrainte : Quand on insert un contrat producer-artiste,
**  la date du début doit être inférieur à la date de fin.
**
**  Objectif : Voir si on peut ajouter une date de début supérieur
**  à la date de fin de la demande.
**
**  Test :
**    - On insère une contrat producteur artiste avec une date
**      de début inférieur à la date de fin.
**    - On insère une contrat producteur artiste avec une date
**      de début supérieur à la date de fin.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');

INSERT INTO actor(artist_id) VALUES (1000);

INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2022-05-4', '2026-05-4', 25);

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2020-10-20', 1000000, 'Role: Figurant');

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Français', 6, null);

ALTER TABLE demand DISABLE TRIGGER fill_propose_trigger;
INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2021-10-20', '2026-2-21');

ALTER TABLE propose DISABLE TRIGGER ALL;
INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1000, 1000, 1000, true);

ALTER TABLE contract_producer_artist DISABLE TRIGGER ALL;

\! cls
\echo '**********************************************'
\echo ' TEST : check table contract_producer_artist \n'
\echo '     - date debut < date fin de contrat   '
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion contract_producer_artist avec une\n'
\echo ' date de debut de 2023-05-04 et de fin 2024-4-1\n'
\echo '     - 2023-05-04 < 2024-4-1 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 25000, 25, ''2023-05-04'', ''2024-4-1'', 10000000, 300000);\n\n'

-- VALIDE
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 25000, 25, '2023-05-04', '2024-4-1', 10000000, 300000);

\echo '> SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1000;\n\n'

SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion contract_producer_artist avec une\n'
\echo ' date de debut de 2026-05-04 et de fin 2026-05-4\n'
\echo '     - 2026-05-04 > 2026-05-4 : Invalide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1001, 1000, 1000, 25000, 25, ''2026-05-04'', ''2024-4-1'', 10000000, 300000);\n\n'

-- INVALIDE
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1001, 1000, 1000, 25000, 25, '2026-05-04', '2024-4-1', 10000000, 300000);

\echo '> SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1001;\n\n'

SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM artist WHERE artist_id = 1000;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;

ALTER TABLE demand ENABLE TRIGGER ALL;

ALTER TABLE propose ENABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist ENABLE TRIGGER ALL;