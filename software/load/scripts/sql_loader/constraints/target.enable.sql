/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021189_idx on TARGET
(LOCUS_ID,TARGET_NAME,TARGET_TYPE) tablespace CABIO_FUT;
alter table TARGET enable constraint SYS_C0021189 using index SYS_C0021189_idx;
create unique index PK_TARGET_idx on TARGET
(TARGET_ID) tablespace CABIO_FUT;
alter table TARGET enable constraint PK_TARGET using index PK_TARGET_idx;

alter table TARGET enable constraint SYS_C0021189;
alter table TARGET enable constraint SYS_C0021189;
alter table TARGET enable constraint SYS_C0021189;
alter table TARGET enable constraint SYS_C004764;
alter table TARGET enable constraint SYS_C004765;
alter table TARGET enable constraint SYS_C004766;
alter table TARGET enable constraint SYS_C004767;
alter table TARGET enable constraint PK_TARGET;

alter table TARGET enable primary key;

--EXIT;
