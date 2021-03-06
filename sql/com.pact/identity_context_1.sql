-- AUTO-GENERATED BY schema-ddl DO NOT EDIT
-- Generator: schema-ddl 0.2.0
-- Generated: 2016-03-18 11:00

CREATE SCHEMA IF NOT EXISTS atomic;

CREATE TABLE IF NOT EXISTS atomic.com_pact_identity_context_1 (
    "schema_vendor"  VARCHAR(128)  ENCODE RUNLENGTH NOT NULL,
    "schema_name"    VARCHAR(128)  ENCODE RUNLENGTH NOT NULL,
    "schema_format"  VARCHAR(128)  ENCODE RUNLENGTH NOT NULL,
    "schema_version" VARCHAR(128)  ENCODE RUNLENGTH NOT NULL,
    "root_id"        CHAR(36)      ENCODE RAW       NOT NULL,
    "root_tstamp"    TIMESTAMP     ENCODE LZO       NOT NULL,
    "ref_root"       VARCHAR(255)  ENCODE RUNLENGTH NOT NULL,
    "ref_tree"       VARCHAR(1500) ENCODE RUNLENGTH NOT NULL,
    "ref_parent"     VARCHAR(255)  ENCODE RUNLENGTH NOT NULL,
    "decaf"          BOOLEAN       ENCODE RAW,
    "email"          VARCHAR(4096) ENCODE LZO,
    "first_name"     VARCHAR(4096) ENCODE LZO,
    "frequency"      VARCHAR(4096) ENCODE LZO,
    "grind"          BOOLEAN       ENCODE RAW,
    "id"             VARCHAR(4096) ENCODE LZO,
    "last_name"      VARCHAR(4096) ENCODE LZO,
    "preparation"    VARCHAR(4096) ENCODE LZO,
    "product_type"   VARCHAR(4096) ENCODE LZO,
    "randomise"      BOOLEAN       ENCODE RAW,
    "sku"            VARCHAR(4096) ENCODE LZO,
    "voucher_code"   VARCHAR(4096) ENCODE LZO,
    FOREIGN KEY (root_id) REFERENCES atomic.events(event_id)
)
DISTSTYLE KEY
DISTKEY (root_id)
SORTKEY (root_tstamp);

COMMENT ON TABLE atomic.com_pact_identity_context_1 IS 'iglu:com.pact/identity_context/jsonschema/1-0-2';
