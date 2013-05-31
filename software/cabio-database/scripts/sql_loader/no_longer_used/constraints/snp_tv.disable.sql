/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table SNP_TV disable constraint SNPTVUNIQ;
alter table SNP_TV disable constraint SYS_C004745;
alter table SNP_TV disable constraint SYS_C004746;
alter table SNP_TV disable constraint SYS_C004747;
alter table SNP_TV disable constraint SYS_C004748;

alter table SNP_TV disable primary key;

--EXIT;
