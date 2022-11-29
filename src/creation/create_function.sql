-- Renvoie les acteurs qui connaissent lang ou tous les acteurs
CREATE OR REPLACE FUNCTION filtered_actor(lang VARCHAR) RETURNS TABLE(id INTEGER) AS $$
    BEGIN
        IF (lang IS NULL OR lang = '') THEN
            -- Pas de contrainte, on renvoie tous les acteurs
            RETURN QUERY SELECT artist_id FROM actor;
            RETURN;
        END IF;
        -- renvoie les acteurs qui connaissent lang
        RETURN QUERY SELECT artist_id FROM language, actor WHERE actor.artist_id = language.actor_id AND country = lang;
    END
$$ LANGUAGE plpgsql;

-- Renvoie les musiciens qui ont ce style ou tous les musiciens
CREATE OR REPLACE FUNCTION filtered_musician(sty VARCHAR) RETURNS TABLE(id INTEGER) AS $$
    BEGIN
        IF (sty IS NULL OR sty = '') THEN
            -- Pas de contrainte, on renvoie tous les musiciens
            RETURN QUERY SELECT DISTINCT artist_id FROM musician;
            RETURN;
        END IF;
        -- renvoie les musiciens qui ont ce style
        RETURN QUERY SELECT DISTINCT artist_id FROM musician WHERE musician.style = sty;
    END
$$ LANGUAGE plpgsql;

-- Renvoie les artistes avec un crit minimum ou tous les artistes;
CREATE OR REPLACE FUNCTION filtered_critic(crit DOUBLE PRECISION)  RETURNS TABLE(id INTEGER) AS $$
    BEGIN
        IF (crit IS NULL) THEN
            -- Pas de contrainte, on renvoie tout les artistes
            RETURN QUERY SELECT artist_id FROM artist;
            RETURN;
        END IF;
        -- renvoie les artistes avec un crit minimum
        RETURN QUERY SELECT artist_id FROM critic GROUP BY artist_id HAVING AVG (remarque) > crit;
    END
$$ LANGUAGE plpgsql;

-- Renvoie les artistes selon un profil donné;
CREATE OR REPLACE FUNCTION filtered_artist(id_profile INTEGER, proj_id INTEGER) RETURNS TABLE(id INTEGER) AS $$
    DECLARE
        roles INTEGER;
        lang VARCHAR;
        critic DOUBLE PRECISION;
        style VARCHAR;
    BEGIN
        roles = (SELECT type_project FROM project WHERE project_id = proj_id);
        SELECT profile.language, profile.critic, profile.style INTO lang, critic, style FROM profile WHERE profile_id = id_profile;
        IF (roles = 1) THEN
            -- Projet = film
            -- On renvoie les acteurs filtrés avec la langue et la critic minimum
            RETURN QUERY SELECT AC.id FROM filtered_actor(lang) as AC WHERE AC.id in (SELECT CR.id FROM filtered_critic(critic) as CR) ORDER BY AC.id;
            RETURN;
        ELSE
            -- On renvoie les musiciens filtrés avec le style et la critic minimum
            RETURN QUERY SELECT DISTINCT MU.id FROM filtered_musician(style) as MU WHERE MU.id in (SELECT CR.id FROM filtered_critic(critic) as CR) ORDER BY MU.id;
            RETURN;
        END IF;
    END
$$ LANGUAGE plpgsql;
