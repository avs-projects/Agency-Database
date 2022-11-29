/***************************************************************
**
**  Contrainte : Quand on insert un contrat entre l'agence et
**  un artiste le pourcentage doit être compris dans la borne
**  0 et 100.
**
**  Objectif : Voir si on peut ajouter un pourcentage hors de
**  la borne
**
**  Test :
**    - On insère un contrat avec un pourcentage de 25.
**    - On insère un contrat avec un pourcentage de 200.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');

\! cls
\echo '**********************************************'
\echo ' TEST : check table contract_agency_artist \n'
\echo '     - 0 < percentage < 100   '
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion contract_agency_artist avec un \n'
\echo ' percentage de 25 pour 100 \n'
\echo '     - 0 < 25 < 100 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, ''2022-05-4'', ''2026-05-4'', 25);\n\n'

-- Valide
INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2022-05-4', '2026-05-4', 25);

\echo '> SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1000;\n\n'

SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion contract_agency_artist avec un \n'
\echo ' percentage de 200 pour 100 \n'
\echo '     - 200 > 100 : Invalide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1001, 1000, FALSE, null, null, 200);\n\n'

-- Invalide
INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1001, 1000, FALSE, null, null, 200);

\echo '> SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1001;\n\n'

SELECT * FROM contract_agency_artist WHERE contract_aa_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM artist WHERE artist_id = 1000;