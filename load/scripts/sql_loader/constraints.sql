rem -----------------------------------------------------------------------
rem Filename:   constraints.sql
rem Purpose:    Script to spool a listing of all disable and enable constraints statements 
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

VAR tabName VARCHAR2(50);
COLUMN tabName NEW_VALUE tabName;
SELECT lower('&1') AS TABNAME
  FROM DUAL;

spool $LOAD/constraints/&tabName..disable.sql 

SELECT 'alter table ' || TABLE_NAME || ' disable constraint ' || 
       CONSTRAINT_NAME || ';'
  FROM USER_constraints 
 WHERE UPPER(TABLE_NAME) = UPPER('&1') AND CONSTRAINT_TYPE NOT IN ('R', 'P') ;

SELECT 'alter table ' || TABLE_NAME || ' disable primary key;' 
  FROM USER_constraints
 WHERE UPPER(TABLE_NAME) = UPPER('&1') AND CONSTRAINT_TYPE ='P';


SELECT '--EXIT;'
  FROM DUAL;
spool off;

spool $LOAD/constraints/&tabName..enable.sql 
DECLARE 
CURSOR disabledConstraints is select constraint_name from user_constraints where constraint_type in ('U', 'P') and upper(table_name) = upper('&1');

a_rec disabledConstraints%ROWTYPE;

CURSOR constraintCols is select x.constraint_name, x.constraint_type, 
x.table_name,  b.column_name, b.POSITION, z.tablespace_name from 
user_constraints x, user_cons_columns b, user_tables z where 
constraint_type in ('U','P') and 
x.constraint_name = b.constraint_name and 
b.column_name <> 'BIG_ID' and upper(x.table_name) = upper('&1') and x.table_name = z.table_name and x.constraint_name = a_rec.constraint_name;

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
	dbms_output.put_line('('||colNames||') tablespace ' || nvl(tablespaceName,'CABIO') ||';'); 
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

spool $LOAD/constraints/&tabName..enable.sql append
SELECT 'alter table ' || A.TABLE_NAME || ' enable constraint ' ||
       A.CONSTRAINT_NAME || ';'
  FROM USER_constraints A, user_cons_columns X 
 WHERE UPPER(A.TABLE_NAME) = UPPER('&1') AND CONSTRAINT_TYPE NOT IN ('R') and A.CONSTRAINT_NAME = X.CONSTRAINT_NAME AND X.COLUMN_NAME <> 'BIG_ID';

SELECT 'alter table ' || TABLE_NAME || ' enable primary key;' 
  FROM USER_constraints
  WHERE UPPER(TABLE_NAME) = UPPER('&1') AND CONSTRAINT_TYPE ='P';

SELECT '--EXIT;'
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

--exit;
