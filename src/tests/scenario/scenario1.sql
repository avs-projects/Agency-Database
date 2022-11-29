/***************************************************************
**
**  Scenario 1 : Plusieurs nouveaux projet arrive a l'agence
**  Est ce que notre artiste (1) va :
**    Etre sélectionner
**    Reussir l'audition
**    Avoir un contrat avec le producteur
**    Enfin participer au projet
**
***************************************************************/

\! cls
\echo '---------------------------------------------------------'
\echo 'Scenario 1 : Un artiste participe a un nouveau projet'
\echo '---------------------------------------------------------\n'


\echo '---------------------------------------------------------'
\echo 'Caracteristiques de notre artiste (artist_id = 1)'
\echo '---------------------------------------------------------\n'

\echo 'Moyenne de l''artiste : ';
SELECT artist_id, AVG(remarque) FROM critic WHERE artist_id = 1   GROUP BY artist_id;

\echo 'Est un acteur ?';
SELECT * FROM filtered_actor('') WHERE id = 1;

\echo 'Langue connue ?';
SELECT * FROM language WHERE actor_id = 1;

\echo 'Est un musicien ?';
SELECT * FROM filtered_musician('') WHERE id = 1;

\echo 'Style connue ?';
SELECT artist_id, style FROM musician WHERE artist_id = 1;

\prompt 'next'

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2020-10-20', 1000000, 'Role: Figurant');
INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1001, 2, '2020-10-20', 1000000, 'Album: écriture paroles');
INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1002, 1, '2020-10-20', 1000000, 'Role: Figurant');

INSERT INTO profile(profile_id, language, critic, style) VALUES  (1000, 'Russe', 5, null);
INSERT INTO profile(profile_id, language, critic, style) VALUES (1001,null,3,'Rap');
INSERT INTO profile(profile_id, language, critic, style) VALUES (1002,'Russe',7,null);

\echo '---------------------------------------------------------'
\echo 'Il y a trois nouveaux projet qui recherche des artistes'
\echo '---------------------------------------------------------\n'

INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand)
  VALUES (1000, 1, 1000, 1000, '2021-10-20', '2022-2-21'),
         (1001, 2, 1001, 1001, '2021-10-20', '2022-2-21'),
         (1002, 1, 1002, 1002, '2021-10-20', '2022-2-21');

\echo '---------------------------------------------------------'
\echo 'Le premiere projet recherchait : '
\echo '---------------------------------------------------------\n'

SELECT demand_id, type_project, description_project, language, critic, style FROM demand NATURAL JOIN Project NATURAL JOIN Profile WHERE demand_id = 1000;

\echo '---------------------------------------------------------'
\echo 'Est ce que notre artiste va etre propose ?'
\echo '---------------------------------------------------------\n'

SELECT * FROM propose WHERE demand_id = 1000;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'Le second projet recherchait : '
\echo '---------------------------------------------------------\n'

SELECT demand_id, type_project, description_project, language, critic, style FROM demand NATURAL JOIN project NATURAL JOIN profile WHERE demand_id = 1001;

\echo '---------------------------------------------------------'
\echo 'Est ce que notre artiste va etre propose ?'
\echo '---------------------------------------------------------\n'

SELECT * FROM propose WHERE demand_id = 1001;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'Le troisieme projet recherchait : '
\echo '---------------------------------------------------------\n'

SELECT demand_id, type_project, description_project, language, critic, style FROM demand NATURAL JOIN project NATURAL JOIN profile WHERE demand_id = 1002;

\echo '---------------------------------------------------------'
\echo 'Est ce que notre artiste va etre propose ?'
\echo '---------------------------------------------------------\n'

SELECT * FROM propose WHERE demand_id = 1002;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'L artiste reussit l audition du premier projet'
\echo '---------------------------------------------------------\n'

UPDATE propose SET result = 'true' WHERE demand_id = 1000 AND artist_id = 1;

SELECT * FROM propose WHERE demand_id = 1000;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'Il va signer son nouveau contrat pour le premier projet'
\echo '---------------------------------------------------------\n'

INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1000, 1, 12000, 1, '2022-10-10', '2023-10-10', 300000, 1000);

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'Il a reussit l audition et signer le contrat '
\echo '---------------------------------------------------------\n'

\echo 'Il participe ? '
SELECT * FROM participate WHERE artist_id = 1;

\prompt 'next'
\echo '---------------------------------------------------------'
\echo 'Il va signer son nouveau contrat pour le second projet mais ...'
\echo '---------------------------------------------------------\n'

INSERT INTO contract_producer_artist(demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit) VALUES (1001, 1, 12000, 1, '2022-10-10', '2023-10-10', 300000, 1000);

-- Suppressions des informations destinées au scénario
DELETE FROM project WHERE project_id >= 1000;
DELETE FROM profile WHERE profile_id >= 1000;
