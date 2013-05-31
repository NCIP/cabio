<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<table width="<template:get name="width"/>" 
       border="<template:get name="border"/>" 
       cellspacing="0" cellpadding="0" >
 <tr>
  <td>
   <table width="100%" cellspacing="0" cellpadding="10">
    <tr>
     <th><template:get name="label"/></th>
    </tr>
    <tr>
     <td><template:get name="content"/></td>
    </tr>
   </table>
  </td>
 </tr>
</table>
