/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table AR_REPRESENTATIVE_PUBLIC_ID disable constraint SYS_C004282;
alter table AR_REPRESENTATIVE_PUBLIC_ID disable constraint SYS_C004283;
alter table AR_REPRESENTATIVE_PUBLIC_ID disable constraint SYS_C004284;

alter table AR_REPRESENTATIVE_PUBLIC_ID disable primary key;

--EXIT;
