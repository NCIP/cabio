<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags" %>

<table cellspacing="0" cellpadding="0" border="0" width="100%">
<tr><td width="20">&nbsp;</td>
<td>
<s:form name="simpleSearchForm" id="simpleSearchForm" method="post" 
        action="SimpleSearch" theme="ajax">
<strong>
  Select search type:
</strong>    
<br />
<br/>
<input type="radio"  name="simple" class="radio" value="freestyleSearch" onclick="javascript:onRadio(this,0);needGVal = true;">
Keyword Search&nbsp;<br />
<input type="text" name="freestyleSearchName" id="freestyleSearchName" value="" size="40" />&nbsp;
<br/><br/>
<b>Pre-configured queries</b><br/>
<input type="radio" checked="checked" name="simple" class="radio" value="rangeQuerySearch" onclick="javascript:onRadio(this,0);needGVal = true;">
Absolute/GridID Range Queries&nbsp;<br />

<input type="radio" name="simple" class="radio" value="kapMaiPlotGE" onclick="javascript:onRadio(this,1);needGVal = true;">
Microarray Reporter Lookup&nbsp;<br />

<input type="radio" name="simple" class="radio" value="kapMaiPlotGE" onclick="javascript:onRadio(this,1);needGVal = true;">
Gene Symbol Verification&nbsp;<br />

<input type="radio" name="simple" class="radio" value="kapMaiPlotCN" onclick="javascript:onRadio(this,2);needGVal = true;">
Cancer Genes<br/>
   
<!--     <hr width=100% color="#002185" size="1px" /> -->
<input type="text" name="quickSearchName" id="quickSearchName" value="" size="40" />&nbsp;
<br/>
<font color="red">(this input control will change dynamically based on the selection)</font>
<br/>
<br/>
<div style="text-align:center">
	 <s:submit id="submitButton" theme="ajax" value="Go" targets="searchresults"/>
</div>

</s:form>
</td>
</tr>
</table>