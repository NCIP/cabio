LOAD DATA  
  
 
INFILE '$CABIO_DATA_DIR/pid/dump/pid_data.dat' 
  
APPEND 
  
INTO TABLE zstg_pid_dump 
REENABLE DISABLED_constraints  
FIELDS TERMINATED BY "|" 
trailing nullcols 
( identifier, 
  field1, 
  field2, 
  field3, 
  field4, 
  field5, 
  field6 
) 
