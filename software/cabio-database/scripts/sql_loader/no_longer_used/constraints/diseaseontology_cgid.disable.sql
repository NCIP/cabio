/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table DISEASEONTOLOGY_CGID disable constraint PK_DISEASEONTOLOGY_CGID;
alter table DISEASEONTOLOGY_CGID disable constraint DO_DISEASEONTOLOGY;
alter table DISEASEONTOLOGY_CGID disable constraint SYS_C00179139;
alter table DISEASEONTOLOGY_CGID disable constraint SYS_C00179140;

--EXIT;
