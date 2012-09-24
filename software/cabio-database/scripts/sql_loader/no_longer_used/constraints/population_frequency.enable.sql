create unique index SYS_C004646_idx on POPULATION_FREQUENCY
(ID) tablespace CABIO_FUT;
alter table POPULATION_FREQUENCY enable constraint SYS_C004646 using index SYS_C004646_idx;

alter table POPULATION_FREQUENCY enable constraint SYS_C004638;
alter table POPULATION_FREQUENCY enable constraint SYS_C004639;
alter table POPULATION_FREQUENCY enable constraint SYS_C004640;
alter table POPULATION_FREQUENCY enable constraint SYS_C004641;
alter table POPULATION_FREQUENCY enable constraint SYS_C004642;
alter table POPULATION_FREQUENCY enable constraint SYS_C004643;
alter table POPULATION_FREQUENCY enable constraint SYS_C004644;
alter table POPULATION_FREQUENCY enable constraint SYS_C004645;
alter table POPULATION_FREQUENCY enable constraint SYS_C004646;

alter table POPULATION_FREQUENCY enable primary key;

--EXIT;
