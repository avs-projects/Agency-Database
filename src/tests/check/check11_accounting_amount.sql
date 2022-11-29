/***************************************************************
**
**  Contrainte : Quand on insert un accounting, le montant doit être
**  supérieur à 0.
**
**  Objectif : Voir si on peut ajouter un montant inférieur à 0
**
**  Test :
**    - On insère un accounting avec un montant de 1 000$.
**    - On insère un accounting avec un montant de -100$.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');

INSERT INTO actor(artist_id) VALUES (1000);

INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2022-05-4', '2026-05-4', 25);

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2022-10-20', 1000000, 'Role: Figurant');

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Français', 6, null);

ALTER TABLE demand DISABLE TRIGGER fill_propose_trigger;
INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2021-10-20', '2026-2-21');

ALTER TABLE propose DISABLE TRIGGER ALL;
INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1000, 1000, 1000, true);

ALTER TABLE contract_producer_artist DISABLE TRIGGER ALL;
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 100000, 25, '2023-05-04', '2024-4-1', 10000000, 300000);

ALTER TABLE payment DISABLE TRIGGER ALL;
INSERT INTO payment(payment_id, contract_pa_id, amount_payment, date_payment) VALUES (1000, 1000, 100000, '2023-05-04');
INSERT INTO payment(payment_id, contract_pa_id, amount_payment, date_payment) VALUES (1001, 1000, 100000, '2023-05-04');

ALTER TABLE accounting DISABLE TRIGGER ALL;

\! cls
\echo '**********************************************'
\echo ' TEST : check table accounting \n'
\echo '     - amount > 0   '
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion accounting avec un amount de 1000\n'
\echo '     - 1000 > 0 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO accounting(accounting_id, payment_id, contract_aa_id, amount, costs) VALUES (1000, 1000, 1000, 1000, 1000);\n\n'

-- VALIDE
INSERT INTO accounting(accounting_id, payment_id, contract_aa_id, amount, costs) VALUES (1000, 1000, 1000, 1000, 1000);

\echo '> SELECT * FROM accounting WHERE accounting_id = 1000;\n\n'

SELECT * FROM accounting WHERE accounting_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion accounting avec un amount de - 100\n'
\echo '     - -100 > 0 : Invalide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO accounting(accounting_id, payment_id, contract_aa_id, amount, costs) VALUES (1001, 1000, 1000, -100, 1000);\n\n'

-- INVALIDE
INSERT INTO accounting(accounting_id, payment_id, contract_aa_id, amount, costs) VALUES (1001, 1000, 1000, -100, 1000);

\echo '> SELECT * FROM accounting WHERE accounting_id = 1001;\n'

SELECT * FROM accounting WHERE accounting_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM artist WHERE artist_id = 1000;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;

ALTER TABLE demand ENABLE TRIGGER ALL;

ALTER TABLE propose ENABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist ENABLE TRIGGER ALL;

ALTER TABLE payment ENABLE TRIGGER ALL;
DELETE FROM payment WHERE payment_id = 1000;
DELETE FROM payment WHERE payment_id = 1001;
ALTER TABLE payment ENABLE TRIGGER ALL;

ALTER TABLE accounting ENABLE TRIGGER ALL;