/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table AR_REFSEQ_PROTEIN_TMP disable constraint SYS_C004273;
alter table AR_REFSEQ_PROTEIN_TMP disable constraint SYS_C004274;
alter table AR_REFSEQ_PROTEIN_TMP disable constraint SYS_C004275;

alter table AR_REFSEQ_PROTEIN_TMP disable primary key;

--EXIT;
