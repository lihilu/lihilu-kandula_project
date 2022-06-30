-- creating schema: kandula
DROP SCHEMA IF EXISTS kandula CASCADE;

CREATE SCHEMA IF NOT EXISTS kandula;
AUTHORIZATION postgres;
 -- creating table instance scheduler with job id, instance id, and shutdown time
DROP TABLE IF EXISTS kandula.instances_scheduler CASCADE;

CREATE TABLE IF NOT EXISTS kandula.instances_scheduler
	(job_id SERIAL NOT NULL PRIMARY KEY,
    instance_id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    shutdown_time integer NOT NULL)

 ALTER TABLE IF EXISTS kandula.instances_scheduler
 OWNER to postgres;

-- create table job log with log id, job id, timestamp and action
DROP TABLE IF EXISTS kandula.job_log;

CREATE TABLE IF NOT EXISTS kandula.job_log
	(log_id SERIAL NOT NULL PRIMARY KEY,
     job_id integer NOT NULL,
     "time" timestamp NOT NULL,
     action character varying(20) COLLATE pg_catalog."default" NOT NULL)
