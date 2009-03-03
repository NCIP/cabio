LOAD DATA 
 
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr1_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr2_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr3_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr4_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr5_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr6_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr7_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr8_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr9_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr10_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr11_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr12_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr13_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr14_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr15_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr16_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr17_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr18_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chr19_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chrX_est_mouse_stage.dat'
INFILE '$CABIO_DATA_DIR/temp/relative_clone/chrY_est_mouse_stage.dat'
 
APPEND
 
INTO TABLE zstg_mouse_est
 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "	"
 
(qname, tname, tstart, tend, chromosome_no, chromosome_id)
