DROP TABLE IF EXISTS "tipoevento";
CREATE TABLE "tipoevento" (
	"tipo_id" int4 NOT NULL,
	"descrizione" varchar(100)
)
WITH (OIDS=FALSE);
ALTER TABLE "tipoevento" OWNER TO "www-data";
ALTER TABLE "tipoevento" ADD CONSTRAINT "tipoevento_pkey" PRIMARY KEY ("tipo_id") NOT DEFERRABLE INITIALLY IMMEDIATE;