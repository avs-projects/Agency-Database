DROP TABLE IF EXISTS accounting CASCADE;
DROP TABLE IF EXISTS actor CASCADE;
DROP TABLE IF EXISTS artist CASCADE;
DROP TABLE IF EXISTS contract_agency_artist CASCADE;
DROP TABLE IF EXISTS contract_producer_artist CASCADE;
DROP TABLE IF EXISTS critic CASCADE;
DROP TABLE IF EXISTS demand CASCADE;
DROP TABLE IF EXISTS language CASCADE;
DROP TABLE IF EXISTS musician CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS producer CASCADE;
DROP TABLE IF EXISTS project CASCADE;
DROP TABLE IF EXISTS profile CASCADE;
DROP TABLE IF EXISTS propose CASCADE;
DROP TABLE IF EXISTS participate CASCADE;

CREATE TABLE artist
(
    artist_id        SERIAL PRIMARY KEY,
    name_artist      VARCHAR NOT NULL,
    firstname_artist VARCHAR NOT NULL,
    birthday_artist  DATE    NOT NULL CHECK (birthday_artist < current_date)
);

CREATE TABLE producer
(
    producer_id        SERIAL PRIMARY KEY,
    name_producer      VARCHAR NOT NULL,
    firstname_producer VARCHAR NOT NULL
);

CREATE TABLE profile
(
    profile_id SERIAL PRIMARY KEY,
    language   VARCHAR,
    critic     DOUBLE PRECISION CHECK (critic BETWEEN 0.0 and 10.0),
    style      VARCHAR
);

CREATE TABLE actor
(
    artist_id INTEGER PRIMARY KEY REFERENCES artist ON DELETE CASCADE
);

CREATE TABLE contract_agency_artist
(
    contract_aa_id         SERIAL PRIMARY KEY,
    artist_id              INTEGER          NOT NULL REFERENCES artist ON DELETE CASCADE,
    type_contract          BOOLEAN          NOT NULL,
    start_date_contract_aa DATE,
    end_date_contract_aa   DATE CHECK (contract_agency_artist.end_date_contract_aa >
                                       contract_agency_artist.start_date_contract_aa),
    percentage             DOUBLE PRECISION NOT NULL CHECK (percentage BETWEEN 0.0 and 100.0)
);

CREATE TABLE project
(
    project_id          SERIAL PRIMARY KEY,
    type_project        INTEGER NOT NULL CHECK (type_project in (1, 2, 3)),
    date_project        DATE    NOT NULL,
    profit_project      INTEGER NOT NULL,
    description_project VARCHAR NOT NULL
);

CREATE TABLE demand
(
    demand_id         SERIAL PRIMARY KEY,
    producer_id       INTEGER NOT NULL REFERENCES producer ON DELETE CASCADE,
    project_id        INTEGER NOT NULL REFERENCES project ON DELETE CASCADE,
    profile_id        INTEGER NOT NULL REFERENCES profile ON DELETE CASCADE,
    start_date_demand DATE    NOT NULL,
    end_date_demand   DATE    NOT NULL CHECK (demand.end_date_demand > demand.start_date_demand)
);

CREATE TABLE contract_producer_artist
(
    contract_pa_id         SERIAL PRIMARY KEY,
    demand_id              INTEGER          NOT NULL REFERENCES demand ON DELETE CASCADE,
    artist_id              INTEGER          NOT NULL REFERENCES artist ON DELETE CASCADE,
    earning                DOUBLE PRECISION NOT NULL CHECK (earning > 0.0),
    profit_sharing         DOUBLE PRECISION NOT NULL CHECK (profit_sharing BETWEEN 0.0 and 100.0),
    start_date_contract_pa DATE             NOT NULL,
    end_date_contract_pa   DATE             NOT NULL CHECK (contract_producer_artist.end_date_contract_pa >
                                                            contract_producer_artist.start_date_contract_pa),
    clause                 DOUBLE PRECISION NOT NULL,
    clause_profit          DOUBLE PRECISION NOT NULL
);

CREATE TABLE payment
(
    payment_id     SERIAL PRIMARY KEY,
    contract_pa_id INTEGER          NOT NULL REFERENCES contract_producer_artist ON DELETE CASCADE,
    amount_payment DOUBLE PRECISION NOT NULL CHECK (amount_payment > 0),
    date_payment   DATE             NOT NULL
);

CREATE TABLE accounting
(
    accounting_id  SERIAL PRIMARY KEY,
    payment_id     INTEGER          NOT NULL REFERENCES payment ON DELETE CASCADE,
    contract_aa_id INTEGER          NOT NULL REFERENCES contract_agency_artist ON DELETE CASCADE,
    amount         DOUBLE PRECISION NOT NULL CHECK (amount > 0.0),
    costs          DOUBLE PRECISION NOT NULL CHECK (costs > 0.0)
);

CREATE TABLE critic
(
    critic_id SERIAL PRIMARY KEY,
    artist_id INTEGER          NOT NULL REFERENCES artist ON DELETE CASCADE,
    remarque  DOUBLE PRECISION NOT NULL CHECK (remarque BETWEEN 0.0 and 10.0)
);

CREATE TABLE language
(
    actor_id INTEGER NOT NULL REFERENCES actor ON DELETE CASCADE,
    country  VARCHAR,
    PRIMARY KEY (actor_id, country)
);

CREATE TABLE musician
(
    musician_id SERIAL PRIMARY KEY,
    artist_id   INTEGER NOT NULL REFERENCES artist ON DELETE CASCADE,
    style       VARCHAR NOT NULL
);

CREATE TABLE propose
(
    propose_id SERIAL PRIMARY KEY,
    artist_id  INTEGER NOT NULL REFERENCES artist ON DELETE CASCADE,
    demand_id  INTEGER NOT NULL REFERENCES demand ON DELETE CASCADE,
    result     BOOLEAN NOT NULL
);

CREATE TABLE participate
(
    project_id INTEGER NOT NULL REFERENCES project ON DELETE CASCADE,
    artist_id  INTEGER NOT NULL REFERENCES artist ON DELETE CASCADE,
    PRIMARY KEY (project_id, artist_id)
);
