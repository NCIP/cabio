/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

select 'drop index ' || A.index_name || ';' from user_indexes  A where lower(A.table_name) = lower('zstg_gene_agent_evid_cgid')
                                                 *
ERROR at line 1:
ORA-01013: user requested cancel of current operation



SQL> 
SQL> exit
