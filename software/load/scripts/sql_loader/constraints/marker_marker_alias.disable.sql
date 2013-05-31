/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table MARKER_MARKER_ALIAS disable constraint SYS_C004590;
alter table MARKER_MARKER_ALIAS disable constraint SYS_C004591;

alter table MARKER_MARKER_ALIAS disable primary key;

--EXIT;
