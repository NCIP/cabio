CREATE OR REPLACE FORCE VIEW CABIODEV.CHR_TEMP
(ID, CHROMOSOMAL_START_POSITION, CHROMOSOMAL_END_POSITION, CHR_CYTOBAND, CHROMOSOME_ID)
AS 
( 
	select xxxx.ID, CHROMOSOMAL_START_POSITION, CHROMOSOMAL_END_POSITION, chr_cytoband, chromosome_ID from 
	(select ID, CHROMOSOMAL_START_POSITION, CHROMOSOMAL_END_POSITION 
	 from physical_location where id < 1783) xxxx, 
	(SELECT rownum id, cb_start, cb_end_pos, chr_cytoband, chromosome_ID from 
        (Select cp.cb_start cb_start, cp.cb_end_pos cb_end_pos, 
		cp.chr_cytoband chr_cytoband, c.chromosome_ID chromosome_ID 
	FROM cytoband_position cp, chromosome c 
	where cp.chromosome = c.chromosome_number and c.Taxon_ID = 5)) yyyy 
	where xxxx.ID = yyyy.id);


