CREATE OR REPLACE procedure PHYSICAL_L_EXON_LD as

  	V_MAXROW NUMBER := 0;

 	CURSOR EXON_REPORTER_CUR IS
 	(
		select r.ID EXON_REPORTER_ID, c.CHROMOSOME_ID, 
			z.START_LOCATION, z.STOP_LOCATION
		from ZSTG_EXON_AFFY z, EXON_REPORTER r, CHROMOSOME c
		where z.PROBE_SET_ID = r.NAME
		and SUBSTR(z.SEQNAME,4) = c.CHROMOSOME_NUMBER (+)
    	and c.TAXON_ID = 5
  	);

 	CURSOR TRANSCRIPT_CUR IS
 	(
		select t.ID TRANSCRIPT_ID, c.CHROMOSOME_ID, 
			z.START_LOCATION, z.STOP_LOCATION
		from ZSTG_EXON_TRANS_AFFY z, TRANSCRIPT t, CHROMOSOME c
		where z.TRANSCRIPT_CLUSTER_ID = t.MANUFACTURER_ID
		and SUBSTR(z.SEQNAME,4) = c.CHROMOSOME_NUMBER (+)
    	and c.TAXON_ID = 5
  	);
  
	aID number:=0;

BEGIN

	SELECT MAX(ID) INTO V_MAXROW FROM LOCATION_TV;

    IF V_MAXROW IS NULL THEN
        V_MAXROW := 0;
    END IF;

	FOR aRec in EXON_REPORTER_CUR LOOP
		aID := aID + 1;
	
		INSERT INTO PHYSICAL_LOCATION(ID,
                          EXON_REPORTER_ID,
                          chromosome_id,
                          chromosomal_start_position,
                          chromosomal_end_position)
		VALUES
		(V_MAXROW + aID,	
		aRec.EXON_REPORTER_ID,
		aRec.chromosome_id,
		aRec.START_LOCATION,
		aRec.STOP_LOCATION);

      	INSERT INTO LOCATION_TV(ID, CHROMOSOME_ID)
		VALUES (aID + V_MAXROW, aRec.chromosome_id);
		
		IF MOD(aID, 500) = 0 THEN
			COMMIT;
		END IF;

	END LOOP;

	FOR aRec in TRANSCRIPT_CUR LOOP
		aID := aID + 1;

		INSERT INTO PHYSICAL_LOCATION(ID,
                          TRANSCRIPT_ID,
                          chromosome_id,
                          chromosomal_start_position,
                          chromosomal_end_position)
		VALUES
		(V_MAXROW + aID,
		aRec.TRANSCRIPT_ID,
		aRec.chromosome_id,
		aRec.START_LOCATION,
		aRec.STOP_LOCATION);

      	INSERT INTO LOCATION_TV(ID, CHROMOSOME_ID)
		VALUES (aID + V_MAXROW, aRec.chromosome_id);
		
		IF MOD(aID, 500) = 0 THEN
			COMMIT;
		END IF;

	END LOOP;
	
COMMIT;

END; 
/

