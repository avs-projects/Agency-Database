/***************************************************************
**
**  Scénario 2 : On regarde la comptabilité d'un artiste avec
**  beaucoup de contrat avec des producteurs.
**  Un artiste qui a beaucoup de contrat et de participation au
**  projet et on regarde ça comptabilité
**
***************************************************************/

\echo '---------------------------------------------------------'
\echo 'Scenario 2 : La comptabilite d un artiste '
\echo '---------------------------------------------------------\n'

UPDATE propose SET result = 'true' WHERE artist_id = 1 AND demand_id < 20;

\echo '---------------------------------------------------------'
\echo 'L artiste a reussit plusieurs auditions : '
\echo '---------------------------------------------------------\n'

SELECT COUNT(*) as reussit FROM propose WHERE artist_id = 1 AND result = 'true';
SELECT COUNT(*) as rate FROM propose WHERE artist_id = 1 AND result = 'false';

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'Il signe des contrats pour chaque audition '
\echo 'Il participe alors a chaque projet dont il a reussit'
\echo '---------------------------------------------------------\n'

INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit)
  VALUES (1 , 1, 22000, 1, '2022-10-10', '2023-10-10', 300000, 1000),
         (5 , 1, 13240, 1, '2022-10-10', '2023-10-10', 300000, 1000),
         (8 , 1, 32120, 1, '2022-10-10', '2023-10-10', 300000, 1000),
         (9 , 1, 4214, 1, '2022-10-10', '2023-10-10', 300000, 1000),
         (17, 1, 1022, 1, '2022-10-10', '2023-10-10', 300000, 1000);

SELECT accounting_id, artist_id, amount, costs FROM accounting NATURAL JOIN contract_agency_artist WHERE artist_id = 1;

SELECT percentage FROM contract_agency_artist WHERE artist_id = 1;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'L artiste a gagne : '
\echo '---------------------------------------------------------\n'

SELECT artist_id, SUM(amount) as Somme FROM accounting NATURAL JOIN contract_agency_artist WHERE artist_id = 1 GROUP BY artist_id;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'L artiste a rapporte a l agence :  '
\echo '---------------------------------------------------------\n'

SELECT artist_id, SUM(costs) as Somme FROM accounting NATURAL JOIN contract_agency_artist WHERE artist_id = 1 GROUP BY artist_id;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'L artiste fort de son succes re-negocie son contrat avec'
\echo 'l agence pour un pourcentage de 10 : '
\echo '---------------------------------------------------------\n'

UPDATE contract_agency_artist SET percentage = 10 WHERE artist_id = 1;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'Il signe un nouveau contrat apres audition '
\echo 'Il participe au projet ou il reussit'
\echo '---------------------------------------------------------\n'

INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit)
  VALUES (18, 1, 5440, 1, '2022-10-10', '2023-10-10', 300000, 1000);

SELECT accounting_id, artist_id, amount, costs FROM accounting NATURAL JOIN contract_agency_artist WHERE artist_id = 1;

SELECT percentage FROM contract_agency_artist WHERE artist_id = 1;

\prompt 'next'

-- Suppressions des informations destinées au scénario
DELETE FROM contract_producer_artist WHERE artist_id = 1;
UPDATE contract_agency_artist SET percentage = 25 WHERE artist_id = 1;
