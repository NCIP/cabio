/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index TAPK_idx on TARGET_AGENT
(AGENT_ID,TARGET_ID) tablespace CABIO_FUT;
alter table TARGET_AGENT enable constraint TAPK using index TAPK_idx;

alter table TARGET_AGENT enable constraint SYS_C004771;
alter table TARGET_AGENT enable constraint SYS_C004772;
alter table TARGET_AGENT enable constraint TAPK;
alter table TARGET_AGENT enable constraint TAPK;

alter table TARGET_AGENT enable primary key;

--EXIT;
