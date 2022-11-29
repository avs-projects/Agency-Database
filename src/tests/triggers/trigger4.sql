/***************************************************************
**
**  Contrainte : Quand on insert sur la table demand
**  la table propose doit être remplie automatiquement avec
**  une proposition de type d'artistes qui correspondent au type
**  du projet de la demande, mais aussi au condition comme la
**  moyenne de critc minimum. Dans le cas ou aucun artiste n'est
**  proposé, on supprime la demand.
**
**  Objectif : Voir si lorsque l'on ajoute une demand la table
**  propose est remplie automatiquement avec des artistes
**  respectant les conditions de la demand. Voir si la demand
**  est supprimée dans le cas ou l'agence n'a aucun artiste à
**  proposer.
**
**  Test :
**    - On insère une demand avec des conditions précises.
**    - On observe si la table propose a étée remplie.
**    - On insère une demand que l'agence ne peut assurer.
**    - On observe si la demande est bien supprimée.
**
***************************************************************/

-- Insertion pour la suite des tests
INSERT INTO artist(artist_id, name_artist, firstname_artist, birthday_artist) VALUES (1000, 'ROBERT', 'Julia', '1967-10-28');

INSERT INTO actor(artist_id) VALUES (1000);

INSERT INTO critic(critic_id, artist_id, remarque) VALUES (1000, 1000, 10);

INSERT INTO language(actor_id, country) VALUES (1000, 'Français');

INSERT INTO contract_agency_artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage) VALUES (1000, 1000, TRUE, '2022-05-4', '2026-05-4', 25);

INSERT INTO project(project_id, type_project, date_project, profit_project, description_project) VALUES (1000, 1, '2020-10-20', 1000000, 'Role: Figurant');

INSERT INTO producer(producer_id, name_producer, firstname_producer) VALUES (1000, 'SPIELBERG', 'Steven');

ALTER TABLE participate DISABLE TRIGGER ALL;

\! cls
\echo '**********************************************'
\echo ' TEST : trigger fill_propose_trigger table demand \n'
\echo '     - ajout dans propose les artistes qui\n'
\echo '       correspondent a la demand \n'
\echo '     - si aucun artiste alors suppression demand '
\echo '**********************************************'
\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion demand\n'
\echo '     - profile_id = 1000 avec reference table\n'
\echo '       profile contenant language = ''Francais''\n'
\echo '       et critic = 9.9 \n'
\echo '     - artist_id = 1000 qui a une critic de 10\n'
\echo '       et parle Francais : Valide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, ''Français'', 9.9, null);\n'

INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, 'Français', 9.9, null);

\echo '\n> INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, ''2021-10-20'', ''2026-2-21'');\n'

INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1000, 1000, 1000, 1000, '2021-10-20', '2026-2-21');

\echo '\n> SELECT * FROM propose WHERE demand_id = 1000;\n'

SELECT * FROM propose WHERE demand_id = 1000;

\prompt 'next'
\echo '----------------------------------------------'
\echo ' Insertion demand\n'
\echo '     - profile_id = 1001 avec reference table \n'
\echo '       profile contenant language = ''Bengali''\n'
\echo '       et critic = 10 \n'
\echo '     - artist_id = 1000 qui a une critic de 10\n'
\echo '       et parle Francais : Invalide'
\echo '----------------------------------------------'
\prompt 'next'
\echo '> INSERT INTO profile(profile_id, language, critic, style) VALUES (1001, ''Bengali'', 10, null);\n'

INSERT INTO profile(profile_id, language, critic, style) VALUES (1001, 'Bengali', 10, null);

\echo '\n> INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1001, 1000, 1000, 1001, ''2021-10-20'', ''2026-2-21'');\n'

INSERT INTO demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand) VALUES (1001, 1000, 1000, 1001, '2021-10-20', '2026-2-21');

\echo '\n> SELECT * FROM propose WHERE demand_id = 1001;\n'

SELECT * FROM propose WHERE demand_id = 1001;

\prompt 'next'

-- Suppressions des informations destinées au test
DELETE FROM artist WHERE artist_id = 1000;

DELETE FROM project WHERE project_id = 1000;

DELETE FROM producer WHERE producer_id = 1000;

DELETE FROM profile WHERE profile_id = 1000;
DELETE FROM profile WHERE profile_id = 1001;

ALTER TABLE participate ENABLE TRIGGER ALL;
