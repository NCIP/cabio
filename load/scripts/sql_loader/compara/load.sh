$SQLLDR $1 readsize=1000000 rows=100000 control=compara_methods.ctl log=compara_methods.log bad=compara_methods.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=compara_species.ctl log=compara_species.log bad=compara_species.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=compara_regions.ctl log=compara_regions.log bad=compara_regions.bad direct=true skip=1 errors=50000
$SQLPLUS $1 @compara_postprocess.sql