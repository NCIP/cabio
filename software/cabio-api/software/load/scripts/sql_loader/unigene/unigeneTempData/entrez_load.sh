#!/bin/sh

#Add Entrez data in Gene, NucleicAcidSequence and update HUGO Symbol
sqlplus $1 @$LOAD/unigene/unigeneTempData/entrez.sql

exit
