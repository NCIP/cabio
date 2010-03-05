rem -----------------------------------------------------------------------
rem Filename:   bigid_unique_constraints.sql
rem Purpose:    Script to spool a listing of all referential integrity statements 
rem Notes:      Will generate scripts to enable and disable all referential integrity constraints
rem Author:     Anonymous
rem -----------------------------------------------------------------------

set linesize 800;
set pagesize 10000;
set long 50;
set trimspool on;
set termout off;
set echo off;
set feedback off;
set heading off;
set verify off;
set serveroutput on;

col dummy       noprint format a10 wrap word;
col dummy2      noprint format a1 wrap word;
col index_name  noprint format a1 wrap word;
col command     format a10 wrap word;

spool $LOAD/constraints/disable.bigid.sql

SELECT 'alter table ' || A.TABLE_NAME || ' disable constraint ' ||
       A.CONSTRAINT_NAME || ';'
  FROM USER_constraints A, USER_CONS_COLUMNS B
 WHERE A.TABLE_NAME = B.table_name AND A.CONSTRAINT_TYPE IN ('U', 'C') AND
       A.CONSTRAINT_NAME = B.CONSTRAINT_NAME AND B.COLUMN_NAME = 'BIG_ID' and upper(B.TABLE_NAME) NOT LIKE 'ZSTG_%';

SELECT 'EXIT;'
  FROM DUAL;
spool off;

spool $LOAD/constraints/enable.bigid.sql
DECLARE
CURSOR disabledConstraints is select a.constraint_name from user_constraints a, user_cons_columns b 
where a.table_name = b.table_name and a.constraint_type in ('U', 'C') and 
a.constraint_name = b.constraint_name and b.column_name = 'BIG_ID';

a_rec disabledConstraints%ROWTYPE;

CURSOR constraintCols is select x.constraint_name, x.constraint_type,
x.table_name,  b.column_name, b.POSITION, z.tablespace_name from
user_constraints x, user_cons_columns b, user_tables z where
x.constraint_type in ('U','C') and
x.constraint_name = b.constraint_name and x.table_name = z.table_name and 
b.column_name = 'BIG_ID' and x.constraint_name=a_rec.constraint_name and lower(z.table_name) not like 'zstg_%'; 


colNames varchar2(4500) := NULL;
constraintName varchar2(2500) := NULL;
tableName varchar2(2500) := NULL;
tablespaceName varchar2(2500) := NULL;
indexName varchar2(2500) := NULL;

p_rec constraintCols%ROWTYPE;

BEGIN

OPEN disabledConstraints;
LOOP
Fetch disabledConstraints into a_rec;
EXIT when disabledConstraints%NOTFOUND;

        OPEN constraintCols;

        LOOP
        FETCH constraintCols into p_rec;
        EXIT when constraintCols%NOTFOUND;

                if colNames is NULL then
                colNames := p_rec.column_name;
                else
                colNames := colNames ||','|| p_rec.column_name;
                end if;

                constraintName := p_rec.constraint_name;
                indexName := p_rec.constraint_name || '_idx';
                tablespaceName := p_rec.tablespace_name;
                tableName := p_rec.table_name;
        END LOOP;

        CLOSE constraintCols;


    if colNames is not null then

        dbms_output.put_line('create unique index '|| indexName||' on '||tableName);        
	    dbms_output.put_line('('||colNames||') tablespace ' || nvl(tablespaceName,GLOBALS.GET_PRODUCTION_TABLESPACE) ||';');
        dbms_output.put_line('alter table '|| tableName || ' enable constraint '|| constraintName || ' using index ' || indexName ||';');

        colNames  := NULL;
        constraintName := NULL;
        indexName := NULL;
        tableName  := NULL;
        tablespaceName  := NULL;

   end if;

END LOOP;
COMMIT;
CLOSE disabledConstraints;
END;
/
spool off;

spool $LOAD/constraints/enable.bigid.sql append

SELECT 'alter table ' || A.TABLE_NAME || ' enable constraint ' ||
       A.CONSTRAINT_NAME || ';'
  FROM USER_constraints A, USER_CONS_COLUMNS B
 WHERE A.TABLE_NAME = B.table_name AND A.CONSTRAINT_TYPE IN ('U', 'C') AND
       A.CONSTRAINT_NAME = B.CONSTRAINT_NAME AND B.COLUMN_NAME = 'BIG_ID';

SELECT 'EXIT;'
  FROM DUAL;
spool off;

set heading on;
set pagesize 100;
set termout on;
set termout on;
set echo on;
set feedback on;
set heading on;
set verify on;

exit;
