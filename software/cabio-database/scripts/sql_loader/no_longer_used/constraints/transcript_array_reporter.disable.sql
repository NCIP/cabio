/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table TRANSCRIPT_ARRAY_REPORTER disable constraint SYS_C0021193;
alter table TRANSCRIPT_ARRAY_REPORTER disable constraint SYS_C004805;
alter table TRANSCRIPT_ARRAY_REPORTER disable constraint SYS_C004806;
alter table TRANSCRIPT_ARRAY_REPORTER disable constraint SYS_C004807;
alter table TRANSCRIPT_ARRAY_REPORTER disable constraint SYS_C004808;
alter table TRANSCRIPT_ARRAY_REPORTER disable constraint XSCRIPTARRREP;

alter table TRANSCRIPT_ARRAY_REPORTER disable primary key;

--EXIT;
