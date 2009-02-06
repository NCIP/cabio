create or replace procedure NUCLEIC_ACID_SEQ31A2B_LD as

  cursor GTVCUR is
  (select ACCESSION_NUMBER, SEQUENCE_TYPE, DESCRIPTION, VALUE, 
  LENGTH from SEQUENCE_STG31A);

  aid number:=0;

begin

    for arec in GTVCUR loop
        
        aid := aid + 1;

        insert into SEQUENCE_STG31B (ACCESSION_NUMBER, SEQUENCE_TYPE, DESCRIPTION, VALUE, LENGTH)
        values (arec.ACCESSION_NUMBER, arec.SEQUENCE_TYPE, arec.DESCRIPTION, arec.VALUE, arec.LENGTH);

        if mod(aid, 500) = 0 then
            commit;
        end if;

    end loop;

    commit;

    insert into SEQUENCE_STG31B (ACCESSION_NUMBER, SEQUENCE_TYPE, DESCRIPTION, VALUE, LENGTH)
        select ACCESSION_NUMBER, SEQUENCE_TYPE, DESCRIPTION, VALUE, LENGTH from SEQUENCE_STG31C;

    commit;

end; 
/