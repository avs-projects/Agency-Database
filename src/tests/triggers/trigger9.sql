/***************************************************************
**
**  Contrainte : Quand on ajoute un contrat lien un artiste à
**  un producteur, un nouveau paiement est ajouté à la table
**  payment avec le montant du salaire fixé par le contrat.
**
**  Objectif : Voir si le montant du contrat est bien ajouté
**  à la table payment.
**
**  Test 1 :
**    - On ajoute un nouveau contrat lien un artiste à un
**      producteur avec un salaire de 25 000$
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

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2018-10-20', 500000000, 'Role: Figurant');

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Français', 6, null);

ALTER TABLE demand DISABLE TRIGGER fill_propose_trigger;

INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2019-10-20', '2026-2-21');

ALTER TABLE propose DISABLE TRIGGER ALL;
INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1000, 1000, 1000, true);
INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1001, 1001, 1000, true);

ALTER TABLE accounting DISABLE TRIGGER ALL;

ALTER TABLE payment DISABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist DISABLE TRIGGER insert_payment_clause_cpa;


\! cls
\echo '**********************************************'
\echo ' TEST : trigger insert_payment_earning_cpa table\n'
\echo '        Contract_Producer_Artist \n'
\echo '     - ajout payment du salaire lors ajout\n'
\echo '       Contract_Producer_Artist'
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion Contract_producer_artist \n'
\echo '     - earning = 25000 '
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 25000, 25, ''2020-05-04'', current_date, 10000000, 500000);\n'

-- Valide
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 25000, 25, '2020-05-04', current_date, 100000000, 500000);

\echo '\n> SELECT * FROM payment WHERE contract_PA_id = 1000;\n'

SELECT * FROM payment WHERE contract_PA_id = 1000;

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

ALTER TABLE accounting ENABLE TRIGGER ALL;

ALTER TABLE payment ENABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist ENABLE TRIGGER ALL;