/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index SNP_TVP_TV_AMINO_ACID_lwr on SNP_TV(lower(AMINO_ACID_CHANGE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index SNP_TVP_TV_CODING_STA_lwr on SNP_TV(lower(CODING_STATUS)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index SNP_TVP_TV_FLANK_lwr on SNP_TV(lower(FLANK)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index SNP_TVP_TV_ALLELE_B_lwr on SNP_TV(lower(ALLELE_B)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index SNP_TVP_TV_ALLELE_A_lwr on SNP_TV(lower(ALLELE_A)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index SNP_TVP_TV_VALIDATION_lwr on SNP_TV(lower(VALIDATION_STATUS)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index SNP_TVP_TV_DB_SNP_ID_lwr on SNP_TV(lower(DB_SNP_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
