/***************************************************************
**
**  Contrainte : Quand on insert un contrat entre l'agence et
**  un artiste la date de début de contrat doit être inférieur
**  à la date de fin.
**
**  Objectif : Voir si on peut ajouter une date de début de
**  contrat supérieur à la date de fin de contrat.
**
**  Test :
**    - On insère un contrat avec une date de début inférieur
**      à la date de fin.
**    - On insère un contrat avec une date de début supérieur
**      à la date de fin.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');

\! cls
\echo '**********************************************'
\echo ' TEST : check table contract_agency_artist \n'
\echo '     - date debut < date fin de contrat   '
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion contract_agency_artist avec une date\n'
\echo ' de debut de 2022-05-4 et de fin 2026-05-4\n'
\echo '     - 2022-05-4 < 2026-05-4 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, ''2022-05-4'', ''2026-05-4'', 25);\n\n'

-- Valide
INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2022-05-4', '2026-05-4', 25);

\echo '> SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1000;\n\n'

SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion contract_agency_artist avec une date\n'
\echo ' de debut de 2027-05-4 et de fin 2026-05-4\n'
\echo '     - 2027-05-4 > 2026-05-4 : Invalide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1001, 1000, TRUE, ''2027-05-4'', ''2026-05-4'', 25);\n\n'

-- Invalide
INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1001, 1000, TRUE, '2027-05-4', '2026-05-4', 25);

\echo '> SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1001;\n\n'

SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM artist WHERE artist_id = 1000;
