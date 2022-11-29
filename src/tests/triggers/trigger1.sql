/***************************************************************
**
**  Contrainte : Quand on insert un contrat entre un producteur
**  et un artiste la date de début du contrat doit être comprise
**  dans la borne date de début contrat agence artiste et date de
**  fin contrat agence artiste.

**  Objectif : Voir si on peut ajouter une date de début de
**  contrat lien un producteur et un artiste hors de la borne
**  des dates du contrat lien l'agence et l'artiste.
**
**  Test :
**    - On insère un contrat un contrat avec cet artiste
**    - On insère dans contract_producer_artist un contrat avec l'artiste en question
**    - On compare les dates en fonction du résultat
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1001, 'HARDY', 'Tom', '1977-09-15');

INSERT INTO actor(artist_id) VALUES (1000);
INSERT INTO actor(artist_id) VALUES (1001);

ALTER TABLE payment DISABLE TRIGGER ALL;
ALTER TABLE contract_producer_artist DISABLE TRIGGER insert_payment_clause_cpa;
ALTER TABLE contract_producer_artist DISABLE TRIGGER insert_payment_earning_cpa;

\! cls
\echo '**********************************************'
\echo ' TEST : trigger insert_date_cpa table contract_producer_artist \n'
\echo '     - start_date_contract_AA (contract_agency_artist)\n'
\echo '     < start_date_contract_PA (contract_producer_artist)\n'
\echo '     < end_date_contract_AA (contract_agency_artist)'
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion contract_agency_artist pour 2\n'
\echo ' artistes\n'
\echo '     - Artiste 1 : type_contract = true (CDD)\n'
\echo '       et start_date_contract_aa = 2022-05-4\n'
\echo '       et end_date_contract_aa = 2026-05-4\n'
\echo '     - Artiste 2 : type_contract = false (CDI)'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, ''2022-05-4'', ''2026-05-4'', 25);\n'
\echo '> INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1001, 1001, FALSE, null, null, 25);\n'

INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2022-05-4', '2026-05-4', 25);
INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1001, 1001, FALSE, null, null, 25);

\echo '\n> SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1000 OR  contract_aa_id = 1001;\n\n'

SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1000 OR  contract_aa_id = 1001;

\prompt 'next'

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2020-10-20', 1000000, 'Role: Figurant');

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Français', 6, null);

ALTER TABLE demand DISABLE TRIGGER fill_propose_trigger;

INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2021-10-20', '2026-2-21');

ALTER TABLE propose DISABLE TRIGGER ALL;

INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1000, 1000, 1000, true);

INSERT INTO propose(propose_id, artist_id, demand_id, result) VALUES (1001, 1001, 1000, true);

\echo '----------------------------------------------'
\echo ' Insertion contract_producer_artist avec\n'
\echo ' start_date_contract_pa de 2023-05-04\n'
\echo '     - 2022-05-4 < 2023-05-04 < 2026-05-4 : Valide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 25000, 25, ''2023-05-04'', ''2024-4-1'', 10000000, 300000);\n'

-- VALIDE
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1000, 1000, 25000, 25, '2023-05-04', '2024-4-1', 10000000, 300000);

\echo '\n> SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1000;\n\n'

SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1000;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion contract_producer_artist avec\n'
\echo ' start_date_contract_pa de 2022-05-04\n'
\echo '     - contract_agency_artist est CDI : Valide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1003, 1000, 1001, 25000, 25, ''2022-05-04'', ''2024-4-1'', 10000000, 300000);\n'

-- VALIDE CDI
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1003, 1000, 1001, 25000, 25, '2022-05-04', '2024-4-1', 10000000, 300000);

\echo '\n> SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1003;\n\n'

SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1003;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion contract_producer_artist avec \n'
\echo ' start_date_contract_pa de 2021-05-4\n'
\echo '     -  start_date_contract_PA = 2021-05-4'
\echo '     < start_date_contract_AA = 2022-05-4 : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '\n> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1001, 1000, 1000, 25000, 25, ''2021-05-4'', ''2024-4-1'', 10000000, 300000);\n'

-- INVALIDE date debut
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1001, 1000, 1000, 25000, 25, '2021-05-4', '2024-4-1', 10000000, 300000);

\echo '\n> SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1001;\n\n'

SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1001;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion contract_producer_artist avec \n'
\echo ' start_date_contract_pa de 2021-05-4\n'
\echo '     -  end_date_contract_PA = 2021-4-1'
\echo '     > start_date_contract_AA = 2026-05-4 : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '\n> INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1002, 1000, 1000, 25000, 25, ''2020-05-04'', ''2021-4-1'', 10000000, 300000);\n'

-- INVALIDE date fin
INSERT INTO contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1002, 1000, 1000, 25000, 25, '2020-05-04', '2021-4-1', 10000000, 300000);

\echo '\n> SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1002;\n\n'

SELECT * FROM contract_producer_artist WHERE contract_pa_id = 1002;

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id = 1000;
DELETE FROM artist WHERE artist_id = 1001;

ALTER TABLE payment ENABLE TRIGGER ALL;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;

ALTER TABLE demand ENABLE TRIGGER ALL;

ALTER TABLE propose ENABLE TRIGGER ALL;

ALTER TABLE contract_producer_artist ENABLE TRIGGER ALL;