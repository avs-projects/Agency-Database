/***************************************************************
**
**  Contrainte : Quand on insert un paiement alors une nouvelle
**  ligne est insérée dans la table accounting avec le montant
**  du salaire de l'artiste et les frais d'agence calculé à partir
**  du pourcentage mentionnée dans le contrat lien l'artiste à
**  l'agence.
**
**  Objectif : Voir si le calcul du salaire et des frais est
**  conforme au pourcentage mentionnée dans le contrat lien
**  l'agence à l'artiste.
**
**  Test 1 :
**    - On ajoute un contrat lien un artiste et l'agence avec
**      un pourcentage de 25%
**    - On ajoute un paiement de 100 000$
**    - On compare les résultats obtenus avec nos propres
**      calculs.
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

INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 100000, 25, '2023-05-04', '2024-4-1', 10000000, 300000);

\! cls
\echo '**********************************************'
\echo ' TEST : trigger insert_payment_in_accounting \n'
\echo ' table payment \n'
\echo '     - ajout payment dans accounting '
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion payement \n'
\echo '     - amount_payment = 100 000\n'
\echo '     - 100 000 - 25% = 75 000 = amount\n'
\echo '     - 100 000 * 25% = 25 000 = costs'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO payment(payment_id, contract_pa_id, amount_payment, date_payment) VALUES (1000, 1000, 100000, ''2023-05-04'');\n'

INSERT INTO payment(payment_id, contract_pa_id, amount_payment, date_payment) VALUES (1000, 1000, 100000, '2023-05-04');

\echo '\n> SELECT * FROM payment WHERE payment_id = 1000;\n'

SELECT * FROM payment WHERE payment_id = 1000;

\prompt 'next'
\echo '> SELECT * FROM accounting;\n'

SELECT * FROM accounting WHERE payment_id = 1000;

\echo '> SELECT percentage FROM contract_agency_artist WHERE artist_id = 1000;\n'

SELECT percentage FROM contract_agency_artist WHERE artist_id = 1000;

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id = 1000;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;

ALTER TABLE demand ENABLE TRIGGER ALL;

ALTER TABLE propose ENABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist ENABLE TRIGGER ALL;