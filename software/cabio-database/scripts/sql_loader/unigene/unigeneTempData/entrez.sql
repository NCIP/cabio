set echo on
delete from gene_tv where source='Entrez';
update gene_tv set entrez_id=null where source='Unigene';
commit;
update zstg_entrez_gene x set x.cabio_chr_id = (select c.CHROMOSOME_ID from chromosome c where c.CHROMOSOME_NUMBER = x.CHR and c.TAXON_ID = x.TAX_ID);
commit;

update gene_tv g set g.ENTREZ_ID = 
(select distinct min(entrez_id) from zstg_entrez_gene x where 
g.TAXON_ID = x.TAX_ID and g.CHROMOSOME_ID=x.CABIO_CHR_ID and 
(g.SYMBOL = x.SYMBOL or g.HUGO_SYMBOL = x.SYMBOL)) where g.source='Unigene';
commit;

update gene_tv g set source='Unigene, Entrez' where source='Unigene' and entrez_id is not null;
commit;

delete from gene_nucleic_acid_sequence where gene_id not in (select distinct gene_id from gene_nucleic_acid_sequence);
commit;
update zstg_entrez_gene x set x.chr = x.chr_map_location where x.chr is null;
commit;


VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

SELECT MAX(GENE_ID) + 1 AS V_MAXROW
  FROM gene_tv;

DROP SEQUENCE genetv_ID;
CREATE SEQUENCE genetv_ID START WITH &V_MAXROW INCREMENT BY 1;
ALTER TRIGGER genetv_ID_trigger ENABLE;
insert into gene_tv(full_name, symbol, chromosome_id, taxon_id, hugo_symbol, source, entrez_id) select distinct description, symbol, cabio_chr_id, tax_id, symbol, 'Entrez', entrez_id from zstg_entrez_gene where cabio_chr_id is not null and symbol <> '-' and symbol in (select distinct symbol from zstg_entrez_gene minus (select distinct symbol from gene_tv union select distinct hugo_symbol from gene_tv));
 commit;

SELECT MAX(ID) + 1 AS V_MAXROW FROM nucleic_acid_sequence;
DROP SEQUENCE nas_ID;
CREATE SEQUENCE nas_ID START WITH &V_MAXROW INCREMENT BY 1;
ALTER TRIGGER nas_ID_trigger ENABLE;


--insert into nucleic_acid_sequence
-- around 30,000 rows
/* insert into nucleic_acid_sequence(accession_number, version, sequence_type, value, length, description, discriminator) select substr(refseq_accession, 0, instr(refseq_accession,'.')-1), substr(refseq_accession, instr(refseq_accession,'.')+1), '1', seq, length(seq), description,
'MessengerRNA' from zstg_refseq_mrna where substr(refseq_accession, 0, instr(refseq_accession,'.')-1) in (select substr(refseq_accession, 0, instr(refseq_accession,'.')-1) from zstg_refseq_mrna minus select distinct accession_number from nucleic_acid_sequence);
*/

insert into nucleic_acid_sequence(accession_number, version, sequence_type, value, length, description, discriminator) 
select substr(refseq_accession, 0, instr(refseq_accession,'.')-1), substr(refseq_accession, instr(refseq_accession,'.')+1), '1', seq, 
	   length(seq), description, 'MessengerRNA' 
from zstg_refseq_mrna 
where substr(refseq_accession, 0, instr(refseq_accession,'.')-1) 
in (select substr(refseq_accession, 0, instr(refseq_accession,'.')-1) 
    from zstg_refseq_mrna 
	minus 
	select distinct accession_number 
	from nucleic_acid_sequence)
and rowid in
(select min(rowid)
from zstg_refseq_mrna 
where substr(refseq_accession, 0, instr(refseq_accession,'.')-1) 
in (select substr(refseq_accession, 0, instr(refseq_accession,'.')-1) 
    from zstg_refseq_mrna 
	minus 
	select distinct accession_number 
	from nucleic_acid_sequence)
	group by substr(refseq_accession, 0, instr(refseq_accession,'.')-1), 
       substr(refseq_accession, instr(refseq_accession,'.')+1), '1', length(seq), description, 'MessengerRNA');

commit;

-- creates 17126 rows
insert into gene_nucleic_acid_sequence(gene_id, gene_sequence_id)
select distinct g.GENE_ID, n.ID from gene_tv g, nucleic_acid_sequence n, zstg_gene2refseq z where g.ENTREZ_ID = z.GENEID and g.taxon_id=decode(z.tax_id,9606,5,10090,6) and substr(z.RNA_NUCLEOTIDE_ACC, 0, instr(z.RNA_NUCLEOTIDE_ACC,'.')-1) = n.ACCESSION_NUMBER minus select distinct gene_id, gene_sequence_id from gene_nucleic_acid_sequence;

commit;  

exit;
