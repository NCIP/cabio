CREATE OR REPLACE PROCEDURE p_disable_constraint(p_table_name IN VARCHAR)
AS
 CURSOR c_disable_constraint IS
  select constraint_name from all_constraints
  where table_name = p_table_name;
BEGIN
 FOR I in c_disable_constraint
 LOOP
  EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' DISABLE CONSTRAINT ' || i.constraint_name;
 END LOOP;
END;
/

