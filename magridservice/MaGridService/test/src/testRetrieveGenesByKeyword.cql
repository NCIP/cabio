<ns1:CQLQuery xmlns:ns1="http://CQL.caBIG/1/gov.nih.nci.cagrid.CQLQuery">
 <ns1:Target name="gov.nih.nci.maservice.domain.Gene">
  <ns1:Group logicRelation="AND"> 
   <ns1:Association name="gov.nih.nci.iso21090.St" roleName="symbol">
    <ns1:Attribute name="value" predicate="IS_NOT_NULL" value="" />
   </ns1:Association>
   <ns1:Association name="gov.nih.nci.maservice.domain.Organism" roleName="organism">
    <ns1:Association name="gov.nih.nci.iso21090.St" roleName="commonName">
      <ns1:Attribute name="value" predicate="LIKE" value="human" />
    </ns1:Association>
   </ns1:Association>
   <ns1:Association name="gov.nih.nci.iso21090.St" roleName="fullName">
    <ns1:Group logicRelation="AND"> 
     <ns1:Attribute name="value" predicate="LIKE" value="%breast%" />
     <ns1:Attribute name="value" predicate="LIKE" value="%cancer%" />
    </ns1:Group> 
   </ns1:Association>
  </ns1:Group> 
 </ns1:Target>
 <ns1:QueryModifier countOnly="false">
  <ns1:AttributeNames>symbol.value</ns1:AttributeNames>
  <ns1:AttributeNames>fullName.value</ns1:AttributeNames>
  <ns1:AttributeNames>organism.commonName.value</ns1:AttributeNames>
 </ns1:QueryModifier>   
</ns1:CQLQuery>
