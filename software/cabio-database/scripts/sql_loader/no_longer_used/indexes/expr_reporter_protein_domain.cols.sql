/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index EXPR_REPMAIN_PROTEIN_DO on EXPR_REPORTER_PROTEIN_DOMAIN(PROTEIN_DOMAIN_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EXPR_REPMAIN_EXPR_REPOR on EXPR_REPORTER_PROTEIN_DOMAIN(EXPR_REPORTER_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
