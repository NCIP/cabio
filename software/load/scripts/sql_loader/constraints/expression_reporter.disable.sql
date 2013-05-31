/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table EXPRESSION_REPORTER disable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER disable constraint SYS_C004434;
alter table EXPRESSION_REPORTER disable constraint SYS_C004435;
alter table EXPRESSION_REPORTER disable constraint SYS_C004436;
alter table EXPRESSION_REPORTER disable constraint EXPRREPBIGID;

alter table EXPRESSION_REPORTER disable primary key;

--EXIT;
