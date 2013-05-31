/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table EXPR_REPORTER_PROTEIN_DOMAIN disable constraint SYS_C004439;
alter table EXPR_REPORTER_PROTEIN_DOMAIN disable constraint SYS_C004440;

alter table EXPR_REPORTER_PROTEIN_DOMAIN disable primary key;

--EXIT;
