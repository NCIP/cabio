CREATE OR REPLACE PROCEDURE toggle_constraints(p_table_name IN VARCHAR, p_enabled IN BOOLEAN)
AS
	CURSOR c_constraints IS
		select constraint_name from all_constraints
		where table_name = p_table_name;
BEGIN
	FOR I in c_constraints
	LOOP
		IF p_enabled = TRUE THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' ENABLE CONSTRAINT ' || i.constraint_name;
		ELSE
			EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' DISABLE CONSTRAINT ' || i.constraint_name;
		END IF;
	END LOOP;
END;
/