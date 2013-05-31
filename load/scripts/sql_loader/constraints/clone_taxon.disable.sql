/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table CLONE_TAXON disable constraint SYS_C004341;
alter table CLONE_TAXON disable constraint SYS_C004342;

alter table CLONE_TAXON disable primary key;

--EXIT;
