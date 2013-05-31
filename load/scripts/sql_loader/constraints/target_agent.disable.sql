/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table TARGET_AGENT disable constraint SYS_C004771;
alter table TARGET_AGENT disable constraint SYS_C004772;

alter table TARGET_AGENT disable primary key;

--EXIT;
