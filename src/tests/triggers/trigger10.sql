/***************************************************************
**
**  Contrainte : Quand on insert un contrat lien un producteur à
**  un artiste une demande doit exister pour permettre son
**  insertion.
**
**  Objectif : Voir si on peut ajouter un contrat lien un
**  un producteur et un artiste avec une demande inexistante.
**
**  Test :
**    - On insère un contrat lien un producteur à un artiste
**      avec une demande existante.
**    - On insère un contrat lien un producteur à un artiste
**      avec une demande inexistante.
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

ALTER TABLE accounting DISABLE TRIGGER ALL;

ALTER TABLE payment DISABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist DISABLE TRIGGER insert_payment_earning_cpa;
ALTER TABLE contract_producer_artist DISABLE TRIGGER insert_payment_clause_cpa;

\! cls
\echo '**********************************************'
\echo ' TEST : trigger check_demand_on_contract_producer_artist\n'
\echo '        table contract_producer_artist \n'
\echo '     - verifie si la demand existe'
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion contract_producer_artist \n'
\echo '     - demand_id = 1000 \n'
\echo '     - demand_id existe donc ajout : Valide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 25000, 25, ''2023-05-04'', ''2024-4-1'', 10000000, 300000);\n'

-- Valide
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit)VALUES (1000, 1000, 1000, 25000, 25, '2023-05-04', '2024-4-1', 10000000, 300000);

\echo '\n> SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1000;\n'

SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1000;

\echo '> SELECT * FROM demand WHERE demand_id = 1000;\n'

SELECT * FROM demand WHERE demand_id = 1000;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion contract_producer_artist \n'
\echo '     - demand_id = 1001 \n'
\echo '     - demand_id existe pas donc pas ajout : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO aontract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1001, 1001, 1001, 25000, 25, ''2022-05-04'', ''2024-4-1'', 10000000, 300000);\n'

-- INVALIDE
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1001, 1001, 1000, 25000, 25, '2022-05-04', '2024-4-1', 10000000, 300000);

\echo '\n> SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1001;\n'

SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1001;

\echo '> SELECT * FROM demand WHERE demand_id = 1001;\n'

SELECT * FROM demand WHERE demand_id = 1001;

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id = 1000;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;

ALTER TABLE demand ENABLE TRIGGER ALL;

ALTER TABLE propose ENABLE TRIGGER ALL;

ALTER TABLE accounting ENABLE TRIGGER ALL;

ALTER TABLE payment ENABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist ENABLE TRIGGER ALL;
