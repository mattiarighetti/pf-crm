DROP TABLE IF EXISTS "paesi";
CREATE TABLE "paesi" (
	"paese_id" int4 NOT NULL,
	"denominazione" varchar(100),
	"sigla" char(3)
)
WITH (OIDS=FALSE);
ALTER TABLE "paesi" OWNER TO "www-data";
ALTER TABLE "paesi" ADD CONSTRAINT "paesi_pkey" PRIMARY KEY ("paese_id") NOT DEFERRABLE INITIALLY IMMEDIATE;