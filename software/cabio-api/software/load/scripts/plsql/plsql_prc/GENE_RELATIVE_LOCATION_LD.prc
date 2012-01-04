CREATE OR REPLACE PROCEDURE gene_relative_location_LD
IS
	CURSOR affy_cur
   	IS
		select unique ag.ASSOCIATION_POSITION TYPE, ag.DISTANCE,
			g.GENE_ID GENE_ID, s.ID SNP_ID, z.PROBE_SET_ID
		from SNP_ASSOCIATED_GENE ag, ZSTG_SNP_AFFY z, GENE_TV g, SNP_TV s
		where ag.PROBESET_ID = z.PROBE_SET_ID
		and	ag.ASSOCIATED_GENE_SYMBOL = g.SYMBOL
		and z.DBSNP_RS_ID = s.DB_SNP_ID;

	CURSOR illumina_cur
   	IS
		select unique z.LOCATION TYPE, z.LOCATION_RELATIVE_TO_GENE DISTANCE,
			g.GENE_ID GENE_ID, s.ID SNP_ID, z.DBSNP_RS_ID PROBE_SET_ID
		from ZSTG_SNP_ILLUMINA z, GENE_TV g, SNP_TV s
		where z.GENE_SYMBOL = g.SYMBOL
		and z.DBSNP_RS_ID = s.DB_SNP_ID;

	aID number:=0;

BEGIN

	EXECUTE IMMEDIATE('TRUNCATE TABLE gene_relative_location REUSE STORAGE ');

	FOR grec IN affy_cur LOOP

		aID := aID + 1;

		insert into GENE_RELATIVE_LOCATION
			(ID, ORIENTATION, GENE_ID, SNP_ID, PROBE_SET_ID)
		values (aID, grec.TYPE, grec.GENE_ID, grec.SNP_ID, grec.PROBE_SET_ID);

		IF MOD (aID, 500) = 0
      	THEN
     		COMMIT;
      	END IF;

   	END LOOP;

	COMMIT;

	FOR grec IN illumina_cur LOOP

		aID := aID + 1;

		insert into GENE_RELATIVE_LOCATION (ID, ORIENTATION, GENE_ID, SNP_ID)
		values (aID, grec.type, grec.gene_id, grec.snp_id);

		IF MOD (aID, 500) = 0
      	THEN
     		COMMIT;
      	END IF;

   	END LOOP;

	COMMIT;

	update GENE_RELATIVE_LOCATION
	set ORIENTATION = 'downstream'
	where ORIENTATION = 'flanking_3UTR';

	update GENE_RELATIVE_LOCATION
	set ORIENTATION = 'upstream'
	where ORIENTATION = 'flanking_5UTR';

	update GENE_RELATIVE_LOCATION
	set ORIENTATION = 'CDS'
	where ORIENTATION = 'coding';

END;
/

