/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index SNP_REPORTER_PHAST_CONS_lwr on SNP_REPORTER(lower(PHAST_CONSERVATION)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index SNP_REPORTER_NAME_lwr on SNP_REPORTER(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
