/***************************************************************
**
**  Contrainte : Quand on insert un profile, la note critic doit
**  être comprise dans la borne 0 et 10.
**
**  Objectif : Voir si on peut ajouter une note hors de la borne
**
**  Test :
**    - On insère un profile avec une note comprise entre 0 et 10.
**    - On insère un profile avec une note comprise de 18.
**
***************************************************************/

\! cls
\echo '**********************************************'
\echo ' TEST : check table profile \n'
\echo '     - 0 < note critic < 10'
\echo '**********************************************\n'
\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion profile avec note de 9\n'
\echo '     - 0 < 9 < 10 : Valide'
\echo '----------------------------------------------\n\n'

\echo '> INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, null, 9, null);\n\n'

-- Valide
INSERT INTO profile(profile_id, language, critic, style) VALUES (1000, null, 9, null);

\echo '> SELECT * FROM profile WHERE profile_id = 1000;\n\n'

SELECT * FROM profile WHERE profile_id = 1000;

\prompt 'next'

\echo '----------------------------------------------'
\echo ' Insertion profile avec note de 18\n'
\echo '     - 18 > 10 : Invalide'
\echo '----------------------------------------------\n\n'


\echo '> INSERT INTO profile(profile_id, language, critic, style) VALUES (1001, null, 18, null);\n\n'

-- Invalide
INSERT INTO profile(profile_id, language, critic, style) VALUES (1001, null, 18, null);

\echo '> SELECT * FROM profile WHERE profile_id = 1001;\n\n'

SELECT * FROM profile WHERE profile_id = 1001;

\prompt 'next'

-- Suppression des données du test
DELETE FROM profile WHERE profile_id = 1000;