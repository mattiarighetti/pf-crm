DROP TABLE IF EXISTS "provincie";
CREATE TABLE "provincie" (
	"provincia_id" int4 NOT NULL,
	"denominazione" varchar(150),
	"paese_id" int4,
	"sigla" char(3)
)
WITH (OIDS=FALSE);
ALTER TABLE "provincie" OWNER TO "www-data";
ALTER TABLE "provincie" ADD CONSTRAINT "provincie_pkey" PRIMARY KEY ("provincia_id") NOT DEFERRABLE INITIALLY IMMEDIATE;