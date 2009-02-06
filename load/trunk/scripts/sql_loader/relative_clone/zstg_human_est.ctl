LOAD DATA 
 
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr1_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr2_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr3_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr4_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr5_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr6_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr7_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr8_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr9_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr10_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr11_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr12_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr13_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr14_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr15_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr16_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr17_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr18_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr19_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr20_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr21_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chr22_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chrX_est_human_stage.dat'
INFILE '/cabio/cabiodb/cabio_data/temp/relative_clone/chrY_est_human_stage.dat'
 
APPEND
 
INTO TABLE zstg_human_est 
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
(qname, tname, tstart, tend, chromosome_no, chromosome_id)
