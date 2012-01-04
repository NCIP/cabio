Introduction:

To download the code, use 
CVSROOT=":pserver:anonymous@cvs.globus.org:/home/globdev/CVS/globus-packages" 
and then cvs checkout ws-handlesystem.  

To create the handle tables:
create table nas (
	na raw(512) primary key
);
create table handles
(
  prefix       raw(255) not null,
  handle       raw(255) not null,
  idx          number not null,
  type         raw(255),
  data         raw(345),
  ttl_type     number,
  ttl          number,
  timestamp    number,
  refs         varchar2(16),
  admin_read   varchar2(5),
  admin_write  varchar2(5),
  pub_read     varchar2(5),
  pub_write    varchar2(5)
);	
create index handle_idx on handles(handle);

============= COPYRIGHT AND LICENSE ============================================

The CaCORE Software License, Version 1.0

Copyright 2001-2005 SAIC. This software was developed in conjunction with the
National Cancer Institute, and so to the extent government employees are co-authors,
any rights in such works shall be subject to Title 17 of the United States Code,
section 105. Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list
   of conditions and the disclaimer of Article 5, below. Redistributions in binary 
   form must reproduce the above copyright notice, this list of conditions and the
   disclaimer of Article 5 in the documentation and/or other materials provided with
   the distribution.
   
2. The end-user documentation included with the redistribution, if any, must include
   the following acknowledgment: "This product includes software developed by SAIC and
   the National Cancer Institute." If no such end-user documentation is to be included,
   this acknowledgment shall appear in the software itself, wherever such third-party
   acknowledgments normally appear.
   
3. The names "The National Cancer Institute", "NCI" and "SAIC" must not be used to
   endorse or promote products derived from this software. This license does not
   authorize the licensee to use any trademarks owned by either NCI or SAIC.
   
4. This license does not authorize or prohibit the incorporation of this software into
   any third party proprietary programs. Licensee is expressly made responsible for
   obtaining any permission required to incorporate this software into third party
   proprietary programs and for informing licensee's end-users of their obligation
   to secure any required permissions before incorporating this software into third
   party proprietary software programs.
   
5. THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED WARRANTIES, (INCLUDING,
   BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT AND
   FITNESS FOR A PARTICULAR PURPOSE) ARE DISCLAIMED. IN NO EVENT SHALL THE NATIONAL
   CANCER INSTITUTE, SAIC, OR THEIR AFFILIATES BE LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
   ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

