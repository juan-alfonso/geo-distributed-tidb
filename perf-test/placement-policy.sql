CREATE DATABASE demo_db;
USE demo_db;

CREATE PLACEMENT POLICY even_distribution_nl_ams
PRIMARY_REGION="nl-ams"
REGIONS="nl-ams,de-fra-2,gb-lon"
SCHEDULE="EVEN";

CREATE PLACEMENT POLICY even_distribution_de_fra
PRIMARY_REGION="de-fra-2"
REGIONS="nl-ams,de-fra-2,gb-lon"
SCHEDULE="EVEN";

CREATE PLACEMENT POLICY even_distribution_gb_lon
PRIMARY_REGION="gb-lon"
REGIONS="nl-ams,de-fra-2,gb-lon"
SCHEDULE="EVEN";

CREATE TABLE test_data_partitioned (
    id BIGINT NOT NULL AUTO_RANDOM,
    region     VARCHAR(10) NOT NULL
                CHECK (region IN ('nl-ams','de-fra-2','gb-lon')),
    payload VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id, region)
) PARTITION BY LIST COLUMNS (region) (
    PARTITION p_region_nl_ams VALUES IN('nl-ams') PLACEMENT POLICY even_distribution_nl_ams,
    PARTITION p_region_de_fra VALUES IN('de-fra-2') PLACEMENT POLICY even_distribution_de_fra,
    PARTITION p_region_gb_lon VALUES IN('gb-lon') PLACEMENT POLICY even_distribution_gb_lon
);




