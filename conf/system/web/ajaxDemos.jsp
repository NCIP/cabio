<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html 
      PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" 
      xmlns:svg="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink">
      
<%@taglib prefix="s" uri="/struts-tags"%>

<head>
<title>AJAX with REST</title>

<link rel="stylesheet" type="text/css" href="/cabio41/styleSheet.css" />

<link rel="icon" type="image/x-ico" href="favicon.ico" />
<link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />

<script type="text/javascript" src="/cabio41/script.js"></script>
<script type="text/javascript" src="/cabio41/jquery-1.2.3.min.js"></script>

<style type="text/css">

table.example td.header {
  font-family:verdana, arial, helvetica, sans-serif;
  font-size: 10pt;
  font-weight:bold;
  padding-left:1em;
  background-color:#CCCCCC; /* constant: medium gray */
  border-top:1px solid #CCCCCC; /* constant: medium gray */
}

table.example td.body {
  font-family:arial,helvetica,verdana,sans-serif;
  font-size: 10pt;
  padding:1em;
  line-height:1.5em;
}

table.results {
  margin: 0px;
  border-collapse: collapse;
}

table.results th {
  background-color: #ddd;
  border: 1px solid #999;
  font-weight: bold;
  font-size: 8pt;
  line-height:1em;
  padding: 2px;
}

table.results td {
  border: 1px solid #999;
  font-size: 8pt;
  line-height:1em;
  padding: 3px;
}

tr.pages td {
    border: 0px;
}


</style>
                                 
<script language="javascript">

$(document).ajaxError(function(){
    if (window.console && window.console.error) {
        document.body.style.cursor = "default";
        console.error(arguments);
    }
});

deferred = "<img src='images/ajax-loading.gif'/>"

</script>

</head>
<body class="yui-skin-sam">
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">

    <%@ include file="WEB-INF/jsp/include/header.inc" %>
	
    <tr>
        <td height="100%" align="center" valign="top">
        <table summary="" cellpadding="0" cellspacing="0" border="0"
            height="100%" width="871">

            <%@ include file="WEB-INF/jsp/include/applicationHeader.inc"%>

            <tr>
                <td valign="top">
                <table summary="" cellpadding="0" cellspacing="0" border="0"
                    height="100%" width="100%">
                    <tr>
                        <td height="20" class="mainMenu"><%@ include
                            file="WEB-INF/jsp/include/mainMenu.inc"%></td>
                    </tr>

                    <!--_____ main content begins _____-->
                    <tr>
                        <td valign="top"><!-- target of anchor to skip menus --> <a
                            name="content" />
                        <table summary="" cellpadding="0" cellspacing="0" border="0"
                            class="contentPage" height="100%" width="100%">
                            
                            <tr>
                                <td width="100%" valign="top">

                                <table summary="" cellpadding="0" cellspacing="0" border="0"
                                    height="100%" width="100%">
                                    <tr>
                                        <td width="70%" valign="top"><!-- welcome begins -->
                                        <table summary="" cellpadding="0" cellspacing="0" border="0"
                                            width="100%" class="example">
                                            <tr>
                                                <td class="header" height="20">EXAMPLES OF AJAX WITH REST-API</td>
                                            </tr>
                                            <tr>
                                                <td class="body" valign="top">

These examples use caBIO's SDK-generated REST API to fetch XML data. 
The REST-API is called asynchronously with the jQuery Javascript library. 
All the source code is embedded in the page itself 
(use <span style="font-family: monotype; font-size: 8pt">View -> Source</span>).

                                                </td>
                                            </tr>
                                        </table>
                        
                                        <table summary="" cellpadding="2" cellspacing="0" border="0"
                                            width="100%" class="example">
                                            <tr>
                                                <td class="header" height="20">Gene->Reporters</td>
                                            </tr>
                                            <tr>
                                                <td class="body" align="left">
                                        
<script language="javascript">

function ex1_load() {

    $("#ex1_button").attr("disabled","disabled")
    $("#ex1_button").attr("value","Loading...")
    document.body.style.cursor = "wait";
    
    var symbol = $("#ex1_symbol").val()
    
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=ExpressionArrayReporter&Gene[@hugoSymbol="+symbol+"]&pageSize=10",  
             success: function(xml){

            $("#ex1_results").empty()
        
            $("queryResponse >class", xml).each(function(){
                reporter = $("field[name='name']", this).text();
                $("#ex1_results").append("<li>"+reporter+"</li>")
            })
            
            $("#ex1_button").removeAttr("disabled")
            $("#ex1_button").attr("value","Load")
            document.body.style.cursor = "default";
        }
    })
}
</script>

Simple example showing asynchronous loading of a collection. On clicking "Load", 
the first 10 associated ArrayReporter objects of the given Gene are loaded and displayed.<br/><br/>

HUGO Gene Symbol: <input id="ex1_symbol" type="text" value="brca1"/>
<button id="ex1_button" onclick="ex1_load()">Load</button><br/>
Reporters: <ul style="margin:0px" id="ex1_results"></ul>
<br/>        
                                                </td>
                                            </tr>
                                                
                                            <tr>
                                                <td class="header" height="20">Gene Symbol Verification</td>
                                            </tr>
                                            <tr>
                                                <td class="body" align="left">

<script language="javascript">
    
function ex2_lookup_taxon(id, clusterId) {

    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=Taxon&Gene[@id="+id+"]",  
             success: function(xml){

            ab = $("field[name='abbreviation']", xml).text();
            $("#gene_"+id).empty().append(ab+"."+clusterId)
        }
    })
}
    
function ex2_verify() {

    $("#ex2_symbol").attr("disabled","disabled")
    $("#ex2_button").attr("disabled","disabled")
    $("#ex2_button").attr("value","Loading...")
    document.body.style.cursor = "wait";
    
    var symbol = $("#ex2_symbol").val()
    
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=Gene&Gene[@symbol="+symbol+"]&pageSize=10",  
             success: function(xml){

            $("#ex2_results").empty()
                
            if ( $("queryResponse",xml).length == 0 ) {
                $("#ex2_symbol").css("background-color","#FC6")
            }
            else {
                $("#ex2_results").append("<tr><th></th><th>Symbol</th><th>UniGene Id</th><th>Description</th><th>Details</th></tr>")
                    
                $("queryResponse>class", xml).each(function(){
                    id = $("field[name='id']", this).text();
                    fullName = $("field[name='fullName']", this).text();
                    symbol = $("field[name='symbol']", this).text();
                    clusterId = $("field[name='clusterId']", this).text();
                    
                    $("#ex2_results").append("<tr><td><input type='radio' name='ex2_gene_group'></td><td>"+symbol+"</td>"+
                        "<td id='gene_"+id+"'>"+deferred+"</td>"+
                        "<td>"+fullName+"</td><td align='center'>"+
                        "<a href='/cabio41/GetHTML?query=Gene&Gene[id="+id+"]' target='_new'>"+
                        "<img src='images/red_arrow.gif' border='0'/></td></tr>")
                    
                    ex2_lookup_taxon(id, clusterId)
                    
                })
                
                $("input[name='ex2_gene_group']:first").attr("checked","checked")
                
                $("#ex2_symbol").css("background-color","#3F0")
            }
            $("#ex2_symbol").removeAttr("disabled")
            $("#ex2_button").removeAttr("disabled")
            $("#ex2_button").attr("value","Verify")
            document.body.style.cursor = "default";
        }
    })
    
}

function ex2_reset() {
    $("#ex2_symbol").css("background-color","#fff")
}
</script>

Example showing multiple ajax calls. This will query for genes with the given 
symbol and color the text field green if the symbol exists, and orange if not. 
The matching gene are displayed in a table. An additional ajax call is needed 
per item in the list, to fetch each gene's taxon. 
<br/><br/>

Gene: <input id="ex2_symbol" type="text" value="IL6" onkeyup="ex2_reset()"/>
<button id="ex2_button" onclick="ex2_verify()">Verify</button>
<br/><br/>
<table class="results" id="ex2_results"></table>
<br/>


                                                </td>
                                            </tr>
                                                
                                            <tr>
                                                <td class="header" height="20">Microarray Reporter Lookup</td>
                                            </tr>
                                            <tr>
                                                <td class="body" align="left">

<script language="javascript">
    
var arrays_loaded = false 
   
function ex3_load_arrays() {

    if (arrays_loaded) return;
    arrays_loaded = true;
            
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=Microarray&Microarray[@type=oligo]",  
             success: function(xml){

            var options = $("select#ex3_arrays").html()
            $("queryResponse>class", xml).each(function(){
                id = $("field[name='id']", this).text();
                desc = $("field[name='description']", this).text();
                manu = $("field[name='manufacturer']", this).text();
                options += '<option value="'+id+'">'+manu+" "+desc+'</option>';
            })
            
            $("select#ex3_arrays").html(options)
        }
    })
}
    
function ex3_loadassoc(erid) {

    // Load ExpressionArrayReporter
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=Gene&ExpressionArrayReporter[@id="+erid+"]",  
             success: function(xml){

            fullName = $("field[name='fullName']", xml).text();
            symbol = $("field[name='symbol']", xml).text();
            var html = fullName+" ("+symbol+")"
            $("#ex3_gene").html(html)
           
        }
    })
    
    // Load Chromosome
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=Chromosome&ArrayReporterPhysicalLocation/ArrayReporter[@id="+erid+"]",  
             success: function(xml){
             
            number = $("field[name='number']", xml).text();
            $("#ex3_chrom").html(number)
        }
    })
    
    // Load PhysicalLocation
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=ArrayReporterPhysicalLocation&ExpressionArrayReporter[@id="+erid+"]",  
             success: function(xml){

            start = $("field[name='chromosomalStartPosition']", xml).text();
            end = $("field[name='chromosomalEndPosition']", xml).text();
            $("#ex3_loc").html(start+"-"+end)
        }
    })
    
    // Load ProteinDomains
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=ProteinDomain&ExpressionArrayReporter[@id="+erid+"]",  
             success: function(xml){

            var html = ""
            $("queryResponse>class", xml).each(function(){
                desc = $("field[name='description']", this).text();
                html += (html.length ? ", " : "") + desc
            })
            $("#ex3_pds").html(html)
        }
    })
    
}


function ex3_load() {

    var name = $("#ex3_reporter").val()
    var maid = $("#ex3_arrays").val()
    
    if (isNaN(parseInt(maid))) {
        alert("Please select a microarray from the dropdown list.")
        return false
    }

    $("#ex3_symbol").attr("disabled","disabled")
    $("#ex3_button").attr("disabled","disabled")
    $("#ex3_button").attr("value","Loading...")
    document.body.style.cursor = "wait";
    
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=ExpressionArrayReporter&ExpressionArrayReporter[@name="+name+"]/Microarray[@id="+maid+"]",  
             success: function(xml){

            $("#ex3_results").empty()
                
            if ( $("queryResponse",xml).length == 0 ) {
                $("#ex3_symbol").css("background-color","#FC6")
                $("#ex3_results").html("No reporter found with that name.")
            }
            else if ( $("queryResponse",xml).length > 1 ) {
                $("#ex3_symbol").css("background-color","#FC6")
                $("#ex3_results").html("Error: more than 1 reporter returned.")
            }
            else {
                id = $("field[name='id']", xml).text();
                sequenceSource = $("field[name='sequenceSource']", xml).text();
                sequenceType = $("field[name='sequenceType']", xml).text();
            
                var rows = ''
                rows += "<tr><th>Name</th><td>"+name+"</td></tr>"
                rows += "<tr><th>Source</th><td>"+sequenceSource+"</td></tr>"
                rows += "<tr><th>Type</th><td>"+sequenceType+"</td></tr>"
                rows += "<tr><th>Gene</th><td id='ex3_gene'>"+deferred+"</td></tr>"
                rows += "<tr><th>Chromosome</th><td id='ex3_chrom'>"+deferred+"</td></tr>"
                rows += "<tr><th>Location</th><td id='ex3_loc'>"+deferred+"</td></tr>"
                rows += "<tr><th>InterPro</th><td id='ex3_pds'>"+deferred+"</td></tr>"
                rows += "<tr><th>Details</th><td class='nopad'>"
                rows += "<a href='/cabio41/GetHTML?query=ArrayReporter&ArrayReporter[@id="+id+"]' target='_new'>"
                rows += "<img src='images/red_arrow.gif' border='0'/></td></tr>"
                
                $("#ex3_results").append("<table class='results'>"+rows+"</table>")
                $("#ex3_symbol").css("background-color","#fff")
                
                ex3_loadassoc(id)
            }
            $("#ex3_symbol").removeAttr("disabled")
            $("#ex3_button").removeAttr("disabled")
            $("#ex3_button").attr("value","View")
            document.body.style.cursor = "default";
        }
    })
    
}

</script>

Complex example demonstrating two concepts:
<ol style="margin:0px">
<li>The Microarray select list is only populated when the user clicks on it</li>
<li>When the View button is clicked, 5 ajax calls are run in parallel to load
various data about a given reporter.</li>
</ol>
<br/>
To use the default example reporter, choose the first array in the list and click View.
Some other good exemplars to try: 221509_at, 204389_at, 209062_x_at.
<br/><br/>

Microarray: <select id='ex3_arrays' onFocus='ex3_load_arrays()'>
<option>Select...</option>
</select>
Reporter: <input id="ex3_reporter" type="text" value="1552400_a_at"/>
<button id="ex3_button" onclick="ex3_load()">View</button>
<br/><br/>
<div id="ex3_results"></div>
<br/>


                                                </td>
                                            </tr>
                                                
                                            <tr>
                                                <td class="header" height="20">Pagination</td>
                                            </tr>
                                            <tr>
                                                <td class="body" align="left">

<script language="javascript">
    
var currPage = 0;
var chroms_loaded = false;
   
function ex4_load_chroms() {

    if (chroms_loaded) return;
    chroms_loaded = true;
            
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=Chromosome&Taxon[@id=5]",  
             success: function(xml){

            var options = $("select#ex4_chroms").html()
            $("queryResponse>class", xml).each(function(){
                id = $("field[name='id']", this).text();
                number = $("field[name='number']", this).text();
                options += '<option value="'+id+'">'+number+'</option>';
            })
            
            $("select#ex4_chroms").html(options)
        }
    })
}

function ex4_prev() {
    currPage--;
    ex4_load(currPage)
}

function ex4_next() {
    currPage++;
    ex4_load(currPage)
}

function ex4_load(page) {

    var cid = $("#ex4_chroms").val()
    var symbol = $("#ex4_symbol").val()
    
    if (isNaN(parseInt(cid))) {
        alert("Please select a microarray from the dropdown list.")
        return false
    }
    
    $("#ex4_symbol").attr("disabled","disabled")
    $("#ex4_button").attr("disabled","disabled")
    $("#ex4_button").attr("value","Loading...")
    document.body.style.cursor = "wait";
    
    $.ajax({ type: "GET", dataType: "xml",
             url: "/cabio41/GetXML", 
             data: "query=Cytoband&Chromosome[@id="+cid+"]&pageSize=10&pageNumber="+page,  
             success: function(xml){

            currPage = page
            lastPage = parseInt($("pages",xml).attr("count"))

            $("#ex4_results").empty()
            
            if ( $("queryResponse",xml).length == 0 ) {
                $("#ex4_symbol").css("background-color","#FC6")
            }
            else {
                prev = (page > 1)?"<a href='javascript:ex4_prev()'>Previous Page</a>":""
                next = (page < lastPage)?"<a href='javascript:ex4_next()'>Next Page</a>":""
                
                var html = "<tr class='pages'><td colspan='3'><table width='100%'><td>"
                html += prev+"</td><td align='right'>"+next+"</td></td></table></td></tr>"
                html += "<tr><th>Name</th><th>Grid Id</th><th>Details</th></tr>"
                
                $("queryResponse>class", xml).each(function(){
                    id = $("field[name='id']", this).text();
                    name = $("field[name='name']", this).text();
                    bigid = $("field[name='bigid']", this).text();
                    
                    html += "<tr><td>"+name+"</td><td>"+bigid+"</td><td align='center'>"
                    html += "<a href='/cabio41/GetHTML?query=SNP&SNP[@id="+id+"]' target='_new'>"
                    html += "<img src='images/red_arrow.gif' border='0'/></td></tr>"
                })
                
                $("#ex4_results").append(html)
                $("#ex4_symbol").css("background-color","#3F0")
            }
            $("#ex4_symbol").removeAttr("disabled")
            $("#ex4_button").removeAttr("disabled")
            $("#ex4_button").attr("value","Verify")
            document.body.style.cursor = "default";
        }
    })
    
}

</script>

Demonstrates simple pagination of results. As with the previous example, the 
drop down list is loaded on demand. If there are more than 10 results, a 
"Next Page" link is displayed which updates the table asynchronously. 
<br/><br/>

Chromosome: <select id='ex4_chroms' onFocus='ex4_load_chroms()'>
<option>Select...</option>
</select>
<button id="ex4_button" onclick="ex4_load(1)">Query</button>
<br/><br/>
<table class="results" id="ex4_results" width="50%"></table>
<br/>


                                                </td>
                                            </tr>
                                                
                            
                                        </table>
                                        <!-- sidebar ends --></td>
                                    </tr>
                                </table></td>
                            </tr>
                        </table></td>
                    </tr>
                    <!--_____ main content ends _____-->

                    <tr>
                        <td height="20" class="footerMenu"><!-- application ftr begins -->
                        <%@ include file="WEB-INF/jsp/include/applicationFooter.inc"%> <!-- application ftr ends -->

                        </td>
                    </tr>
                </table>
                </td>
            </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td><%@ include file="WEB-INF/jsp/include/footer.inc"%></td>
    </tr>
</table>
</body>
</html>



