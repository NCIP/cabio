/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table LOCATION_TV disable constraint SYS_C004574;
alter table LOCATION_TV disable constraint SYS_C004575;

alter table LOCATION_TV disable primary key;

--EXIT;
