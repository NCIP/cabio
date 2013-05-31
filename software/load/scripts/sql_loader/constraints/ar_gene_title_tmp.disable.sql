/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table AR_GENE_TITLE_TMP disable constraint SYS_C004225;
alter table AR_GENE_TITLE_TMP disable constraint SYS_C004226;
alter table AR_GENE_TITLE_TMP disable constraint SYS_C004227;

alter table AR_GENE_TITLE_TMP disable primary key;

--EXIT;
