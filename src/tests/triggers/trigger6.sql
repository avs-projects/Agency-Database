/***************************************************************
**
**  Contrainte : Quand l'artist a un nouveau contrat producer
**  S'il a réussit l'audition alors il a droit à un contrat
**  Sinon le contrat ne se fait pas
**
**  Objectif : Vérifié l'insertion du contrat_PA
**
**  Test 1 :
**    - On ajoute un contrat avec un artiste qui réussit l'audition
**    - On ajoute un contrat avec un artiste qui n'a pas réussit
**    - On ajoute un contrat avec un artiste meme pas proposé
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1001, 'ROBERT', 'Julia', '1967-10-28');
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1002, 'ROBERT', 'Julia', '1967-10-28');

INSERT INTO actor(artist_id) VALUES (1000);
INSERT INTO actor(artist_id) VALUES (1001);
INSERT INTO actor(artist_id) VALUES (1002);

INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2022-05-4', '2026-05-4', 25);
INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1001, 1001, TRUE, '2022-05-4', '2026-05-4', 25);
INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1002, 1002, TRUE, '2022-05-4', '2026-05-4', 25);

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2020-10-20', 1000000, 'Role: Figurant');

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Francais', 6, null);

ALTER TABLE demand DISABLE TRIGGER fill_propose_trigger;

INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2021-10-20', '2026-2-21');

ALTER TABLE accounting DISABLE TRIGGER ALL;

ALTER TABLE payment DISABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist DISABLE TRIGGER insert_payment_earning_cpa;
ALTER TABLE contract_producer_artist DISABLE TRIGGER insert_payment_clause_cpa;

\! cls
\echo '**********************************************'
\echo ' TEST : trigger check_success_audition on table\n'
\echo ' contract_producer_artist \n'
\echo '     - ajout contrat si audition = true'
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion propose \n'
\echo '     - result = true \n'
\echo '     - doit ajouter dans contract_producer_artist : Valide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1000, 1000, 1000, true);\n'
INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1000, 1000, 1000, true);

\echo '> INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 10, 1, 2022-10-10, 2023-10-10, 50, 50);\n'
INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 10, 1, '2022-10-10', '2023-10-10', 50, 50);

\prompt 'next'
\echo '> SELECT * FROM contract_producer_artist WHERE artist_id = 1000\n'
SELECT * FROM contract_producer_artist WHERE artist_id = 1000;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion propose \n'
\echo '     - result = false \n'
\echo '     - doit ajouter dans contract_producer_artist : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1001, 1001, 1000, false);\n'
INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1001, 1001, 1000, false);

\echo '> INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1001, 10, 1, 2022-10-10, 2023-10-10, 50, 50);\n'
INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1001, 10, 1, '2022-10-10', '2023-10-10', 50, 50);

\prompt 'next'
\echo '> SELECT * FROM contract_producer_artist WHERE artist_id = 1001\n'
SELECT * FROM contract_producer_artist WHERE artist_id = 1001;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion propose \n'
\echo '     - result = null (meme pas propose)\n'
\echo '     - doit ajouter dans contract_producer_artist : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1002, 10, 1, 2022-10-10, 2023-10-10, 50, 50);\n'
INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1002, 10, 1, '2022-10-10', '2023-10-10', 50, 50);

\prompt 'next'
\echo '> SELECT * FROM contract_producer_artist WHERE artist_id = 1002;\n'
SELECT * FROM contract_producer_artist WHERE artist_id = 1002;

\prompt 'next'
\echo '> SELECT * FROM contract_producer_artist WHERE artist_id >= 1000;\n'
SELECT * FROM contract_producer_artist WHERE artist_id >= 1000;

\prompt 'next'

-- Suppressions des informations destinées au test
ALTER TABLE demand ENABLE TRIGGER ALL;

DELETE FROM contract_agency_artist WHERE contract_aa_id >= 1000;

DELETE FROM project WHERE project_id >= 1000;

DELETE FROM producer WHERE producer_id >= 1000;

DELETE FROM profile WHERE profile_id >= 1000;

ALTER TABLE accounting ENABLE TRIGGER ALL;

ALTER TABLE payment ENABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist ENABLE TRIGGER ALL;

