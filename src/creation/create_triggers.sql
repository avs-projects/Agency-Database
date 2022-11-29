------------------------------------------------------------------------------------------------------------------------------------
-- Contract_Producer_Artist
------------------------------------------------------------------------------------------------------------------------------------

/***************************************************************
**
**  Trigger 10 : check_demand_on_contract_producer_artist
**
**  Explication : Quand on insert un contrat lien un producteur à
**  un artiste une demande doit exister pour permettre son
**  insertion.
**
***************************************************************/

-- Fonction appelée par le trigger
CREATE OR REPLACE FUNCTION check_demand() RETURNS trigger AS $$
    DECLARE
      count INTEGER;
    BEGIN
      count = (SELECT COUNT(*) FROM demand WHERE demand_id = NEW.demand_id);
      IF(count = 1) THEN
        RETURN NEW;
      ELSE
        IF (TG_NAME = 'check_demand_on_contract_producer_artist') THEN
          RAISE NOTICE 'Access deleted demand % from % on %', NEW.demand_id, TG_NAME, NEW.contract_pa_id;
        ELSE
          RAISE NOTICE 'Access deleted demand % from %', NEW.demand_id, TG_NAME;
        END IF;
        RETURN NULL;
      END IF;
    END
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER check_demand_on_contract_producer_artist
  BEFORE INSERT
  ON contract_producer_artist
  FOR EACH ROW
  EXECUTE PROCEDURE check_demand();

/***************************************************************
**
**  Trigger 1 : insert_date_cpa
**
**  Explication : Quand on insert un contrat entre un producteur
**  et un artiste la date de début du contrat doit être comprise
**  dans la borne date de début contrat agence artiste et date de
**  fin contrat agence artiste.
**
***************************************************************/

-- Fonction appelée par le trigger
CREATE OR REPLACE FUNCTION date_cpa_error() RETURNS TRIGGER AS $$
    DECLARE
        start_date_caa DATE;
        end_date_caa DATE;
        type_caa BOOLEAN;
        count_cpa INT;
    BEGIN
        SELECT start_date_contract_aa, end_date_contract_aa, type_contract into start_date_caa, end_date_caa, type_caa FROM contract_agency_artist WHERE artist_id = NEW.artist_id;
        count_cpa = (SELECT COUNT(*) FROM contract_agency_artist WHERE ((type_caa = TRUE) AND (start_date_caa < NEW.start_date_contract_pa) AND (end_date_caa > NEW.start_date_contract_pa)));
        -- Si le contrat est de type CDD ET date debut contrat artiste agence < date debut contrat producteur artiste < date fin contrat artiste agence.
    IF ((count_cpa > 0) OR (type_caa = false)) THEN
      -- contrat valide
      RETURN NEW;
    END IF;
    RAISE NOTICE 'La date du contrat producteur artiste % est invalide car l agence ne s occupe pas de l artiste sur cette periode.', NEW.contract_pa_id;
    RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER insert_date_cpa
    BEFORE INSERT
    ON contract_producer_artist
    FOR EACH ROW
    EXECUTE PROCEDURE date_cpa_error();


/***************************************************************
**
**  Trigger 6 : check_success_audition
**
**  Explication : Quand on veut insérer un contrat
**  pour un artiste, il faut qu'il ait réussit l'audition
**  pour avoir droit au contrat
**
***************************************************************/

CREATE OR REPLACE FUNCTION check_success_audition() RETURNS trigger AS $$
DECLARE
  success BOOLEAN;
BEGIN
  SELECT result INTO success FROM propose WHERE artist_id = NEW.artist_id AND demand_id = NEW.demand_id;
  IF (success = 't') THEN
    -- l'artiste a reussit l'audition : il peut avoir un contrat
    RETURN NEW;
  ELSIF (success = 'f') THEN
    -- l'artiste a raté l'audition : il ne peut pas avoir un contrat
    RAISE NOTICE 'Pas de contrat possible sans reussir l''audition';
    RETURN NULL;
  ELSE
    -- sucess = null : l'artiste n'a pas été proposé
    RAISE NOTICE 'Artiste % non propose pour la demande %', NEW.artist_id , NEW.demand_id;
    RETURN NULL;
  END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_success_audition
    BEFORE INSERT
    ON contract_producer_artist
    FOR EACH ROW
    EXECUTE PROCEDURE check_success_audition();

/***************************************************************
**
**  Trigger 7 : fill_participate
**
**  Explication : Si l'artiste a réussit l'audition et a un
**   contrat alors on ajoute a participate
**
***************************************************************/
CREATE OR REPLACE FUNCTION fill_participate() RETURNS trigger AS $$
DECLARE
  success BOOLEAN;
  proj_id INTEGER;
BEGIN
  SELECT project_id INTO proj_id FROM Demand WHERE demand_id = NEW.demand_id;
  SELECT result INTO success FROM Propose WHERE artist_id = NEW.artist_id AND demand_id = NEW.demand_id;
  IF(success = 't') THEN
    -- L'artiste a reussit l'audition et a un contrat : il participe au projet
    RAISE NOTICE 'Contrat signe : Felicitation a % pour participer au projet %', NEW.artist_id, proj_id;
    INSERT INTO participate(project_id, artist_id) VALUES (proj_id, NEW.artist_id);
    RETURN NULL;
  END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER fill_participate
  AFTER INSERT
  ON contract_producer_artist
  FOR EACH ROW
  EXECUTE PROCEDURE fill_participate();


/***************************************************************
**
**  Trigger 8 : insert_payment_clause_cpa
**
**  Explication : Quand un artiste à respécté la clause de son
**  contrat stipulant que si le projet fait un bénéfice d'une
**  certaine somme alors il doit recevoir un paiement équivalent
**  au montant de la clause promise.
**
***************************************************************/

-- Fonction appelée par le trigger
CREATE OR REPLACE FUNCTION add_clause_payment() RETURNS trigger AS $$
    DECLARE
        project_id_new INT;
        project_profit_new DOUBLE PRECISION;
    BEGIN
        project_id_new = (SELECT project_id FROM demand WHERE demand_id = NEW.demand_id);
        project_profit_new = (SELECT profit_project FROM project WHERE project_id = project_id_new);
        IF (NEW.clause >= project_profit_new) THEN
            INSERT INTO payment(contract_pa_id, amount_payment, date_payment) VALUES (NEW.contract_pa_id, NEW.clause_profit, NEW.end_date_contract_PA);
            RAISE NOTICE 'Un nouveau paiement est ajoute pour le contrat producer artiste %, pour un montant de %', NEW.contract_pa_id, NEW.clause_profit;
            RETURN NULL;
        ELSE
            RETURN NULL;
        END IF;
    END
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER insert_payment_clause_cpa
    AFTER INSERT
    ON contract_producer_artist
    FOR EACH ROW
    EXECUTE PROCEDURE add_clause_payment();

/***************************************************************
**
**  Trigger 9 : insert_payment_earning_cpa
**
**  Explication : Quand on ajoute un contrat lien un artiste à
**  un producteur, un nouveau paiement est ajouté à la table
**  payment avec le montant du salaire fixé par le contrat.
**
***************************************************************/

-- Fonction appelée par le trigger
CREATE OR REPLACE FUNCTION add_earning_payment() RETURNS trigger AS $$
    BEGIN
        INSERT INTO payment(contract_pa_id, amount_payment, date_payment) VALUES (NEW.contract_pa_id, NEW.earning, NEW.end_date_contract_pa);
        RAISE NOTICE 'Un nouveau paiement est ajoute pour le contrat producer artiste %, pour un montant de %', NEW.contract_pa_id, NEW.earning;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER insert_payment_earning_cpa
    AFTER INSERT
    ON contract_producer_artist
    FOR EACH ROW
    EXECUTE PROCEDURE add_earning_payment();

------------------------------------------------------------------------------------------------------------------------------------
-- Payment
------------------------------------------------------------------------------------------------------------------------------------

/***************************************************************
**
**  Trigger 2 : insert_payment_in_accounting
**
**  Explication : Quand on insert un paiement alors une nouvelle
**  ligne est insérée dans la table accounting avec le montant
**  du salaire de l'artiste et les frais d'agence calculé à partir
**  du pourcentage mentionnée dans le contrat lien l'artiste à
**  l'agence.
**
***************************************************************/

-- Fonction appelée par le trigger
CREATE OR REPLACE FUNCTION actualise_accounting() RETURNS trigger AS $$
    DECLARE
        artist_id_new INT;
        contract_aa_id_new INT;
        percentage_new DOUBLE PRECISION;
        amount_new DOUBLE PRECISION;
        costs_new DOUBLE PRECISION;
    BEGIN
        artist_id_new = (SELECT artist_id FROM contract_producer_artist WHERE contract_pa_id = NEW.contract_pa_id);
        SELECT contract_aa_id, percentage INTO contract_aa_id_new, percentage_new FROM contract_agency_artist WHERE artist_id = artist_id_new;
        amount_new = ((NEW.amount_payment) - ((NEW.amount_payment) * percentage_new) / 100);
        costs_new = ((NEW.amount_payment) - amount_new);
        INSERT INTO accounting(payment_id, contract_aa_id, amount, costs) VALUES (NEW.payment_id, contract_aa_id_new, amount_new, costs_new);
        RAISE NOTICE 'La comptabilite traite le paiement %, les frais d''agence sont de % et le montant verse a l''artiste %', NEW.payment_id, costs_new, amount_new;
        RETURN NULL;
    END
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER insert_payment_in_accounting
    AFTER INSERT
    ON payment
    FOR EACH ROW
    EXECUTE PROCEDURE actualise_accounting();

------------------------------------------------------------------------------------------------------------------------------------
-- Participate
------------------------------------------------------------------------------------------------------------------------------------

/***************************************************************
**
**  Trigger 3 : check_participation
**
**  Explication : Quand on insert sur la table participate on
**  doit respecter plusieurs conditons. Si l'artiste est déjà
**  incrit comme participant au projet alors ne l'ajouter
**  (unicité du couple projet-artiste). Quand on insert dans
**  participate alors le type du projet et de l'artiste doivent
**  se correspondre.
**
***************************************************************/

-- Fonction appelée par le trigger
CREATE OR REPLACE FUNCTION check_participation() RETURNS TRIGGER AS $$
    DECLARE
        type INTEGER;
        find INTEGER;
    BEGIN
        IF ((SELECT COUNT(*) FROM participate WHERE project_id = NEW.project_id AND artist_id = NEW.artist_id) = 1) THEN
            --Si l'artiste participe déjà au projet
            --Pas besoin de l'ajouté
            RAISE NOTICE 'Artiste % participe deja au projet %', NEW.artist_id, NEW.project_id;
            RETURN NULL;
        END IF;
        SELECT type_project INTO type FROM project WHERE project_id = NEW.project_id;
        IF (type = 1) THEN
            -- projet = film
            -- verifie si c'est un acteur
            find = (SELECT COUNT(*) FROM actor WHERE artist_id = NEW.artist_id);
            IF (find = 0) THEN
                RAISE NOTICE 'Non Acteur dans le projet % qui est un film', NEW.project_id;
                RETURN NULL;
            END IF;
        ELSE
            -- projet = album / festival
            -- verifie si c'est un musicien
            find = (SELECT COUNT(*) FROM musician WHERE artist_id = NEW.artist_id);
            IF (find = 0) THEN
                RAISE NOTICE 'Non Musicien dans le projet % qui est musicale', NEW.project_id;
                RETURN NULL;
            END IF;
        END IF;
        RETURN NEW;
    END
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER check_participation
  BEFORE INSERT
  ON participate
  FOR EACH ROW
  EXECUTE PROCEDURE check_participation();

------------------------------------------------------------------------------------------------------------------------------------
-- Demand
------------------------------------------------------------------------------------------------------------------------------------

/***************************************************************
**
**  Trigger 4 : fill_propose_trigger
**
**  Explication : Quand on insert sur la table demand
**  la table propose doit être remplie automatiquement avec
**  une proposition de type d'artistes qui correspondent au type
**  du projet de la demande, mais aussi au condition comme la
**  moyenne de critc minimum. Dans le cas ou aucun artiste n'est
**  proposé, on supprime la demand.
**
***************************************************************/

-- Fonction appelée par le trigger
-- Remplis la table propose avec les artistes filter par le profile demandé
CREATE OR REPLACE FUNCTION fill_propose() RETURNS TRIGGER AS $$
    DECLARE
        proj INTEGER;
        nb_found INTEGER;
    BEGIN
        nb_found = (SELECT COUNT(*) FROM filtered_artist(NEW.profile_id, NEW.project_id));
        proj = NEW.project_id;
        IF(nb_found>0) THEN
            INSERT INTO Propose (demand_id, artist_id, result) SELECT NEW.demand_id, FA.id, 'f' FROM filtered_artist(NEW.profile_id, proj) as FA;
            RAISE NOTICE 'Les artistes de demande % ajoute % a Propose ', NEW.demand_id, nb_found;
            RETURN NEW;
        ELSE
            RAISE NOTICE 'Pas d artiste pour la demande % et le profile %', NEW.demand_id,NEW.profile_id;
            RETURN NULL;
        END IF;
    END
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER fill_propose_trigger
  AFTER INSERT
  ON demand
  FOR EACH ROW
  EXECUTE PROCEDURE fill_propose();

/***************************************************************
**
**  Trigger 5 : insert_demand_check_date
**
**  Explication : Quand on ajoute une demande, la date de début
**  de la demande doit être supérieur à la date du projet.
**
***************************************************************/

-- Fonction appelée par le trigger
CREATE OR REPLACE FUNCTION check_date_demand_project() RETURNS trigger AS $$
    DECLARE
        project_date DATE;
    BEGIN
        project_date = (SELECT date_project FROM project WHERE project_id = NEW.project_id);
        IF (project_date > NEW.start_date_demand) THEN
            RAISE NOTICE 'La date de la demande % est invalide, elle est superieur a la date du projet', NEW.demand_id;
            RETURN NULL;
        ELSE
            RETURN NEW;
        END IF;
    END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER insert_demand_check_date
    BEFORE INSERT
    ON demand
    FOR EACH ROW
    EXECUTE PROCEDURE check_date_demand_project();

------------------------------------------------------------------------------------------------------------------------------------
-- Propose
------------------------------------------------------------------------------------------------------------------------------------

/***************************************************************
**
**  Trigger 11 : check_demand_on_propose
**
**  Explication : Quand on insert dans propose une demande doit
**  exister pour permettre son insertion.
**
***************************************************************/

-- Trigger
CREATE TRIGGER check_demand_on_propose
  BEFORE INSERT
  ON propose
  FOR EACH ROW
  EXECUTE PROCEDURE check_demand();
