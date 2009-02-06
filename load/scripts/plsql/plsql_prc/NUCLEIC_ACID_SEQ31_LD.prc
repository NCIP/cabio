CREATE OR REPLACE procedure NUCLEIC_ACID_SEQ31_LD as

  cursor GTVCUR is
  (select a.ID id, a.ACCESSION_NUMBER accession_number, a.VERSION version,
        a.SEQUENCE_TYPE sequence_type, a.CLONE_ID clone_id,
        b.VALUE value, b.LENGTH length, b.DESCRIPTION description
    from HSMM_SEQ_STG31 a, SEQUENCE_STG31B b
    where a.ACCESSION_NUMBER = b.ACCESSION_NUMBER);

  aid number:=0;

begin

   execute immediate('truncate table NUCLEIC_ACID_SEQUENCE reuse storage');

   for arec in GTVCUR loop
      aid := aid + 1;

      insert into NUCLEIC_ACID_SEQUENCE (ID, ACCESSION_NUMBER, VERSION,
      	SEQUENCE_TYPE, DESCRIPTION, CLONE_ID, VALUE, LENGTH)
      values
        (arec.id, arec.accession_number, arec.version, arec.sequence_type,
        	arec.description, arec.clone_id, arec.value, arec.length);

      if mod(aid, 500) = 0 then
         commit;
      end if;

   end loop;

commit;

end;
/

