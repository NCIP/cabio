/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table AR_OMIM_ID disable constraint SYS_C004258;
alter table AR_OMIM_ID disable constraint SYS_C004259;
alter table AR_OMIM_ID disable constraint SYS_C004260;

alter table AR_OMIM_ID disable primary key;

--EXIT;
