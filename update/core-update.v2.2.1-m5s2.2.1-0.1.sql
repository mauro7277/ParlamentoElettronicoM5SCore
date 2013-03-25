-- Column: codice_fiscale

-- ALTER TABLE member DROP COLUMN codice_fiscale;
BEGIN;

ALTER TABLE member ADD COLUMN codice_fiscale character varying(16);
COMMENT ON COLUMN member.codice_fiscale IS 'Italian tax identification number (Codice fiscale)';
-- Function: codice_fiscale_insert_trigger()

-- DROP FUNCTION codice_fiscale_insert_trigger();

CREATE OR REPLACE FUNCTION codice_fiscale_insert_trigger()
  RETURNS trigger AS
$BODY$
    DECLARE myrec int;
    BEGIN
       myrec = length (NEW.codice_fiscale);
       
       IF myrec = 16 THEN
		--NEW.campo= 'ok';
		RETURN NEW;
	ELSE
		RAISE EXCEPTION 'Lunghezza non permessa';
      END IF;
      RETURN NULL;
         
   END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- Trigger: codice_fiscale_validation on member

-- DROP TRIGGER codice_fiscale_validation ON member;

CREATE TRIGGER codice_fiscale_validation
  BEFORE INSERT OR UPDATE
  ON member
  FOR EACH ROW
  EXECUTE PROCEDURE check_codice_fiscale();


COMMIT;
