/***************************************************************
**
**  Contrainte : Quand un artiste à respécté la clause de son
**  contrat stipulant que si le projet fait un bénéfice d'une
**  certaine somme alors il doit recevoir un paiement équivalent
**  au montant de la clause promise.
**
**  Objectif : Voir si lorque l'objectif du projet est atteint
**  l'artiste reçoit bien un paiement du montant de sa clause.
**
**  Test 1 :
**    - On ajoute un projet avec un bénéfice de 1 000 000$.
**    - On ajoute un contrat lien un artiste à un producteur pour
**      ce même projet avec une clause qui sera validée à savoir
**      supérieur à 500 000$ pour une clause de 300 000$.
**    - On ajoute un contrat lien un artiste à un producteur pour
**      ce même projet avec une clause qui ne sera pas validée à
**      savoir supérieur à 1 000 000$ pour une clause de 300 000$.
**    - On compare en fonction du résultat.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1001, 'HARDY', 'Tom', '1977-09-15');

INSERT INTO actor(artist_id) VALUES (1000);
INSERT INTO actor(artist_id) VALUES (1001);

INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2018-05-4', '2026-05-4', 25);
INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1001, 1001, FALSE, null, null, 25);

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2018-10-20', 1000000, 'Role: Figurant');

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Français', 6, null);

ALTER TABLE demand DISABLE TRIGGER fill_propose_trigger;
INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2019-10-20', '2026-2-21');

ALTER TABLE propose DISABLE TRIGGER ALL;
INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1000, 1000, 1000, true);
INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1001, 1001, 1000, true);

ALTER TABLE payment DISABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist DISABLE TRIGGER insert_payment_earning_cpa;

\! cls
\echo '**********************************************'
\echo ' TEST : trigger insert_payment_clause_cpa table\n'
\echo '        Contract_Producer_Artist \n'
\echo '     - Si profit_project (project) > clause\n'
\echo '       (Contract_producer_artist) alors ajout\n'
\echo '       nouveau payment'
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion Contract_producer_artist \n'
\echo '     - profit_project = 1000000 \n'
\echo '     - clause  = 10000000 \n'
\echo '     - clause > profit_project : Valide \n'
\echo '     - clause_profit = 500 000 : Valide '
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 2000000, 25, ''2020-05-04'', current_date, 10000000, 500000);\n'

-- Reçoit clause
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 2000000, 25, '2020-05-04', current_date, 10000000, 500000);

\echo '\n> SELECT * FROM payment WHERE contract_PA_id = 1000;\n'

SELECT * FROM payment WHERE contract_PA_id = 1000;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion Contract_producer_artist \n'
\echo '     - profit_project = 1 000000 \n'
\echo '     - clause  = 500 000 \n'
\echo '     - clause < profit_project : Invalide \n'
\echo '     - clause_profit = 300 000 : Invalide '
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1002, 1000, 1001, 1000000, 25, ''2020-05-04'', current_date, 500000, 300000);\n'

-- Reçoit pas clause
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1001, 1000, 1001, 1000000, 25, '2020-05-04', current_date, 500000, 300000);

\echo '\n> SELECT * FROM payment WHERE contract_PA_id = 1001;\n'

SELECT * FROM payment WHERE contract_PA_id = 1001;

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id = 1000;
DELETE FROM artist WHERE artist_id = 1001;

DELETE FROM demand WHERE demand_id = 1000;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;

ALTER TABLE demand ENABLE TRIGGER ALL;

ALTER TABLE propose ENABLE TRIGGER ALL;

ALTER TABLE payment ENABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist ENABLE TRIGGER ALL;