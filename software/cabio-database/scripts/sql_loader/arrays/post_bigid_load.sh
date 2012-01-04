#!/usr/bin/sh
sqlplus $1 @ArrayReporterCH.sql  &
sqlplus $1 @ArrayReporter.sql & 
sqlplus $1 @RelativeLocationCH.sql & 
sqlplus $1 @RelativeLocation.sql  &

#sqlplus $1 @RelLoc_pre.sql  
#perl generate_nondup_relloc.pl
#$SQLLDR $1 readsize=1000000 parallel=true control=RelLocCH.ctl log=RelLocCH.log bad=RelLocCH.bad errors=50000 direct=true silent=(HEADER)
#sqlplus $1 @RelLoc_post.sql  

sqlplus $1 @TranscriptArrayReporter.sql &
wait
exit;
