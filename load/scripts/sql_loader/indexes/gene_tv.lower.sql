/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_TVE_TV_SOURCE_lwr on GENE_TV(lower(SOURCE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_TVE_TV_HUGO_SYMBO_lwr on GENE_TV(lower(HUGO_SYMBOL)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_TVE_TV_SYMBOL_lwr on GENE_TV(lower(SYMBOL)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_TVE_TV_FULL_NAME_lwr on GENE_TV(lower(FULL_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
