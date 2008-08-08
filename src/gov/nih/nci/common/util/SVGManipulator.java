package gov.nih.nci.common.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

/**
 * Utilities for manipulating SVG protein images.
 * 
 * @author <a href="mailto:lethai@mail.nih.gov">Thai Le</a>
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class SVGManipulator {

    private static Logger log = Logger.getLogger(SVGManipulator.class);
    
    public static final String BIOCARTA_STRING = "BioCarta";

    /**
     * A string representation of the SVG Diagram
     */
    private String svgString;

    /**
     * The DOM document represented an SVG Diagram
     */
    private Document svgDiagram;

    /**
     * The DOM document represented an SVG Diagram
     */
    private Document originalSvg;

    /**
     * The SVG file name of this pathway diagram SVG.
     */
    private String name;

    /**
     * Constructor - accepts pathways as an object, use reflection to get its
     * name and svgString through getName and getDiagram methods respectively.
     * It also converts the svgString into svgDiagram document.
     * 
     * @param pathway Object
     */
    public SVGManipulator(Object pathway) throws Exception {
        this.svgString = (String) ReflectionUtils.get(pathway, "diagram");
        this.name = (String) ReflectionUtils.get(pathway, "name");
        getSvgDiagram();
    }

    /**
     * This method returns pathway diagrame name
     * 
     * @return pathway diagram name
     */
    public String getName() {
        return this.name;
    }

    /**
     * Sets the URL for Genes within the svg document. The URL should have "%%"
     * in the place where the gene symbol will be interpolated. If not, then
     * the gene symbol will be dropped along with the rest of the URL.
     * 
     * @param geneInfoLocation
     */
    public void setGeneInfoLocation(String geneInfoLocation) throws Exception {
        
        // check if svg has been changed
        String svgString = getSvgString();
        if (svgString == null) return; // nothing to do
        
        if (geneInfoLocation.contains("%%")) {
            String[] parts = geneInfoLocation.split("%%");
            this.svgString = svgString.replaceAll(
                "/CMAP.*?BCID=(.*?)\"", parts[0]+"$1"+parts[1]+"\"");
        }
        else {
            this.svgString = svgString.replaceAll(
                "/CMAP.*?BCID=(.*?)\"", geneInfoLocation);
        }
        
        if (svgDiagram != null) {
            // set the current parsed document to null and reparse the string
            this.svgDiagram = null;
            this.svgDiagram = getSvgDiagram();
        }
    }

    /**
     * disableAllGenes - go through the svg document, look for genes, and
     * disable them.
     */
    public void disableAllGenes() throws Exception {
        Document svg = getSvgDiagram();
        if (svg == null) return;
        // go through svg document, look for genes and disable them
        NodeList svgnodes = svg.getDocumentElement().getChildNodes();
        for (int i = 0; i < svgnodes.getLength(); i++) {
            // examine g nodes only
            if (!svgnodes.item(i).getNodeName().equals("g")) continue;
            // process list of "g" child nodes
            NodeList kids = svgnodes.item(i).getChildNodes();
            for (int j = 0; j < kids.getLength(); j++) {
                Node node = kids.item(j);
                // only interested in node if it's an element
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    // get list of nodes for "g" child node
                    NodeList gkids = node.getChildNodes();
                    for (int k = 0; k < gkids.getLength(); k++) {
                        Node gknode = gkids.item(k);
                        if (gknode.getNodeType() == Node.ELEMENT_NODE) {
                            if (gknode.hasAttributes()) {
                                // get node attributes
                                NamedNodeMap gkattrmap = gknode.getAttributes();
                                // get cmap object reference
                                Node objref = gkattrmap.getNamedItemNS(
                                    "http://www.celebration.saic.com/nci_cmap",
                                    "objectName");
                                // ignore node, if no objectName ref
                                if (objref == null) continue;
                                // add diable filter to colorspec
                                Node styleNode = gkattrmap
                                        .getNamedItem("style");
                                String styleStr = styleNode.getNodeValue();
                                styleStr = updateFilter(styleStr,
                                    "#TransparentFilter");
                                styleNode.setNodeValue(styleStr);

                            }
                        }
                    } // end for "g" child node list of nodes
                } // end if element node
            } // end for "g" child nodes
        } // end for childnodes
    }

    /**
     * disableAllNodes - disable all nodes within svg document
     */
    public void disableAllNodes() throws Exception {
        Document svg = getSvgDiagram();
        if (svg == null) return;
        // go through svg document, look for nodes and disable them
        NodeList svgnodes = svg.getDocumentElement().getChildNodes();
        for (int i = 0; i < svgnodes.getLength(); i++) {
            // examine g nodes only
            // if ( !svgnodes.item(i).getNodeName().equals("g" ))continue;
            // process list of "g" child nodes
            NodeList kids = svgnodes.item(i).getChildNodes();
            for (int j = 0; j < kids.getLength(); j++) {
                Node node = kids.item(j);
                // only interested in node if it's an element
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    // get list of nodes for "g" child node
                    NodeList gkids = node.getChildNodes();
                    for (int k = 0; k < gkids.getLength(); k++) {
                        Node gknode = gkids.item(k);
                        if (gknode.getNodeType() == Node.ELEMENT_NODE) {
                            if (gknode.hasAttributes()) {
                                // get node attributes
                                NamedNodeMap gkattrmap = gknode.getAttributes();
                                // add diable filter to colorspec
                                Node styleNode = gkattrmap
                                        .getNamedItem("style");
                                if (styleNode != null) {
                                    String styleStr = styleNode.getNodeValue();
                                    styleStr = updateFilter(styleStr,
                                        "#TransparentFilter");
                                    styleNode.setNodeValue(styleStr);
                                    // XMLUtility.setXlinkNameSpace(gknode);
                                }
                            }
                        }
                    } // end for "g" child node list of nodes
                } // end if element node
            } // end for "g" child nodes
        } // end for childnodes
    }

    /**
     * build svg as a document and return it
     * 
     * @return Document
     */
    public Document getSvgDiagram() throws Exception {
        if (this.svgDiagram == null) {
            if (this.svgString != null) {
                DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory
                        .newInstance();
                documentBuilderFactory.setNamespaceAware(true);
                DocumentBuilder documentBuilder = documentBuilderFactory
                        .newDocumentBuilder();
                StringReader stringIn = new StringReader(svgString);
                svgDiagram = documentBuilder
                        .parse(new InputSource(stringIn));

                if (this.originalSvg == null) {
                    DocumentBuilderFactory documentBuilderFactory0 = DocumentBuilderFactory
                            .newInstance();
                    documentBuilderFactory0.setNamespaceAware(true);
                    DocumentBuilder documentBuilder0 = documentBuilderFactory0
                            .newDocumentBuilder();
                    StringReader stringIn0 = new StringReader(svgString);
                    this.originalSvg = documentBuilder0
                            .parse(new InputSource(stringIn0));
                }
            }
        }
        return svgDiagram;
    }

    /**
     * sets svgDiagram document
     * 
     * @param svg
     */
    public void setSvgDiagram(Document svg) throws Exception {
        String tempString = null;
        this.svgDiagram = svg;
        if (originalSvg == null) {
            StringWriter stringOut = new StringWriter();
            OutputFormat outformat = new OutputFormat();
            outformat.setIndenting(true);
            XMLSerializer xmlserializer = new XMLSerializer(outformat);
            xmlserializer.setOutputCharStream(stringOut);
            xmlserializer.serialize(svg);
            tempString = stringOut.toString();

            DocumentBuilderFactory documentBuilderFactory0 = DocumentBuilderFactory
                    .newInstance();
            documentBuilderFactory0.setNamespaceAware(true);
            DocumentBuilder documentBuilder0 = documentBuilderFactory0
                    .newDocumentBuilder();
            StringReader stringIn0 = new StringReader(tempString);
            this.originalSvg = documentBuilder0.parse(new InputSource(
                    stringIn0));
        }
    }

    /**
     * Sets the String representing this SVG
     * 
     * @param svgString
     */
    public void setSvgString(String svgString) {
        this.svgString = svgString;
        this.svgDiagram = null;
    }

    /**
     * Returns the String representing the SVG Document.
     * 
     * @return the SVG String for the svg document
     */
    public String getSvgString() throws Exception {
        // check if svg has been changed
        if (this.svgDiagram != null) {
            // set up xml serialization stuff
            StringWriter stringOut = new StringWriter();
            OutputFormat outformat = new OutputFormat();
            outformat.setIndenting(true);
            XMLSerializer xmlserializer = new XMLSerializer(outformat);
            xmlserializer.setOutputCharStream(stringOut);
            xmlserializer.serialize(svgDiagram);
            svgString = stringOut.toString();
        }
        return svgString;
    }

    /**
     * Get the current color of the specified gene within the SVG diagram. With
     * current cabio domain model, to get bcid for a given gene object: <li>
     * call getGeneAliasCollection method of the Gene object <li> iterate
     * through this collection (GeneAlias object), call getType() method, check
     * its value, if it matches BioCarta then call getName() method to get bcid.
     * Break through the loop when this occurs.<br> When bcid value is found,
     * go through svg document, look for the bcid found, if there is a match,
     * return the color for that, if not, return null.
     * 
     * @param gene The gene to get the color for
     * @return the color of the gene as a comma seperated list of rgb values (eg
     *         "10,20,255")
     */
    public String getSvgColor(Object gene) throws Exception {
        // return the current color of the object mapped to the gene identifier
        // passed in
        // get gene bcid's. We are going to assume a major hack here to simplify
        // matters.
        // The hack is to only take the first BCID we get from the gene. This
        // way we only return
        // a single color. This has a major shortcoming in that it is *possible*
        // to have more than one
        // BCID per gene. Apparaently, most(all?) of the CVG diagrams assume a
        // 1-1 mapping, so this
        // assumption should handle all cases for now...

        Document svg = getSvgDiagram();
        if (svg == null) return null;
        // use reflection to get gene information and invoke it method
        // to get GeneAliasCollection. From GeneAlias, get BCIDs
        List<String> bcids = new ArrayList<String>();

        // use the gene symbol
        String geneSymbol = (String)
            ReflectionUtils.get(gene, "symbol");
        bcids.add(geneSymbol.toLowerCase());

        Collection c = (Collection)
            ReflectionUtils.get(gene, "geneAliasCollection");

        for (Iterator itr = c.iterator(); itr.hasNext();) {
            Object geneAlias = itr.next();
            String aliasType = (String)
                ReflectionUtils.get(geneAlias, "type");
            if (aliasType.equals(BIOCARTA_STRING)) {
                String bcid = (String)
                    ReflectionUtils.get(geneAlias, "name");
                bcids.add(bcid.toLowerCase());
            }
        }

        // go through svg document, return color for the specified bcid
        String color = null;
        NodeList svgnodes = svg.getDocumentElement().getChildNodes();
        for (int i = 0; i < svgnodes.getLength(); i++) {
            // examine g nodes only
            if (!svgnodes.item(i).getNodeName().equals("g")) continue;
            // process list of "g" child nodes
            NodeList kids = svgnodes.item(i).getChildNodes();
            for (int j = 0; j < kids.getLength(); j++) {
                Node node = kids.item(j);
                // only interested in node if it's an element
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    // get list of nodes for "g" child node
                    NodeList gkids = node.getChildNodes();
                    for (int k = 0; k < gkids.getLength(); k++) {
                        Node gknode = gkids.item(k);
                        if (gknode.getNodeType() == Node.ELEMENT_NODE) {
                            if (gknode.hasAttributes()) {
                                // get node attributes
                                NamedNodeMap gkattrmap = gknode.getAttributes();
                                // get cmap object reference
                                Node objref = gkattrmap.getNamedItemNS(
                                    "http://www.celebration.saic.com/nci_cmap",
                                    "objectName");
                                // ignore node, if no objectName ref
                                if (objref == null) continue;
                                String obname = objref.getNodeValue();
                                for (String bcid : bcids) {
                                    if (obname.equals(bcid)) {
                                        Node colref = gkattrmap
                                                .getNamedItem("style");
                                        String colspec = colref.getNodeValue();
                                        int rgbstart = colspec.indexOf("rgb(");
                                        String t = colspec
                                                .substring(rgbstart + 4);
                                        int reststart = t.indexOf(')');
                                        color = t.substring(0, reststart);
                                    }
                                }
                            }
                        }
                    } // end for "g" child node list of nodes
                } // end if element node
            } // end for "g" child nodes
        } // end for childnodes
        return color;
    }

    /**
     * This method goes through the svg document, set the color given for each
     * bcid found in each genes array. For genes[0], set colors[0], etc. To find
     * the bcid for the specified gene, use the same logic as in
     * getSvgColor(Object gene) method.
     * 
     * @param genes
     * @param colors
     */
    public void setSvgColors(Object[] genes, String[] colors) throws Exception {
        Document svg = getSvgDiagram();
        if (svg == null) return;
        // next build a hashmap of BCID and colors
        Map<String,String> colortab = new HashMap<String,String>();

        for (int i = 0; i < genes.length; i++) {
            Collection c = (Collection)
                ReflectionUtils.get(genes[i], "geneAliasCollection");

            // map the gene symbol to the new gene color
            String geneSymbol = (String)
                ReflectionUtils.get(genes[i], "symbol");
            colortab.put(geneSymbol.toLowerCase(), colors[i]);

            // map all the gene's aliases to the new gene color
            for (Iterator itr = c.iterator(); itr.hasNext();) {
                Object geneAlias = itr.next();
                String aliasType = (String)
                    ReflectionUtils.get(geneAlias, "type");

                if (aliasType.equals(BIOCARTA_STRING)) {
                    String bcid = (String)
                        ReflectionUtils.get(geneAlias, "name");
                    colortab.put(bcid.toLowerCase(), colors[i]);
                }
            }
        }
            
        // now go through svg document, change colors for those
        // components that map to the BCID
        NodeList svgnodes = svg.getDocumentElement().getChildNodes();
        for (int i = 0; i < svgnodes.getLength(); i++) {
            // examine g nodes only
            if (!svgnodes.item(i).getNodeName().equals("g")) continue;
            // process list of "g" child nodes
            NodeList kids = svgnodes.item(i).getChildNodes();
            for (int j = 0; j < kids.getLength(); j++) {
                Node node = kids.item(j);
                // only interested in node if it's an element
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    // get list of nodes for "g" child node
                    NodeList gkids = node.getChildNodes();
                    for (int k = 0; k < gkids.getLength(); k++) {
                        Node gknode = gkids.item(k);
                        if (gknode.getNodeType() == Node.ELEMENT_NODE) {
                            if (gknode.hasAttributes()) {
                                // get node attributes
                                NamedNodeMap gkattrmap = gknode.getAttributes();
                                // get cmap object reference
                                Node objref = gkattrmap.getNamedItemNS(
                                    "http://www.celebration.saic.com/nci_cmap",
                                    "objectName");
                                // ignore node, if no objectName ref
                                if (objref == null) continue;
                                String obname = objref.getNodeValue();
                                // get existing color then update to new color
                                Node colref = gkattrmap.getNamedItem("style");
                                if (colortab.containsKey(obname.toLowerCase())) {
                                    String newcolor = colorMap(
                                        colref.getNodeValue(), colortab.get(obname));
                                    newcolor = updateFilter(newcolor,
                                        "#OpaqueFilter");
                                    colref.setNodeValue(newcolor);
                                }
                            }
                        }
                    } // end for "g" child node list of nodes
                } // end if element node
            } // end for "g" child nodes
        } // end for childnodes

    }

    /**
     * This is an overloaded method instead the parameter contain a Map with key
     * as bcid and value is color. Use this method when bcid(s) are known.
     * @param geneColors Hastable key containing BCID, value contain color value.
     */
    public void setSvgColors(Map geneColors) throws Exception {
        Document svg = getSvgDiagram();
        if (svg == null) return;

        NodeList svgnodes = svg.getDocumentElement().getChildNodes();
        for (int i = 0; i < svgnodes.getLength(); i++) {
            // examine g nodes only
            if (!svgnodes.item(i).getNodeName().equals("g")) continue;
            // process list of "g" child nodes
            NodeList kids = svgnodes.item(i).getChildNodes();
            for (int j = 0; j < kids.getLength(); j++) {
                Node node = kids.item(j);
                // only interested in node if it's an element
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    // get list of nodes for "g" child node
                    NodeList gkids = node.getChildNodes();
                    for (int k = 0; k < gkids.getLength(); k++) {
                        Node gknode = gkids.item(k);
                        if (gknode.getNodeType() == Node.ELEMENT_NODE) {
                            // System.out.println(" gkNode=" +
                            // gknode.getNodeName() +
                            // " val=" + gknode.getNodeValue() +
                            // " attr=" + gknode.hasAttributes());
                            if (gknode.hasAttributes()) {
                                // get node attributes
                                NamedNodeMap gkattrmap = gknode.getAttributes();
                                // get cmap object reference
                                Node objref = gkattrmap.getNamedItemNS(
                                    "http://www.celebration.saic.com/nci_cmap",
                                    "objectName");
                                // ignore node, if no objectName ref
                                if (objref == null) continue;
                                String obname = objref.getNodeValue();
                                // get existing color then update to new color
                                Node colref = gkattrmap.getNamedItem("style");
                                // System.out.println(" svg=" +
                                // svgnodes.item(i).getNodeName()+
                                // " kid=" + name+
                                // " knode=" + gknode.getNodeName()+
                                // " New color f="+colref.getNodeValue()+
                                // "t=" + colorMap(colref.getNodeValue(),
                                // (String)geneColors.get(obname)));
                                if (geneColors.containsKey(obname)) {
                                    String newcolor = colorMap(colref
                                            .getNodeValue(),
                                        (String) geneColors.get(obname));
                                    newcolor = updateFilter(newcolor,
                                        "#OpaqueFilter");
                                    colref.setNodeValue(newcolor);
                                }
                            }
                        }
                    } // end for "g" child node list of nodes
                } // end if element node
            } // end for "g" child nodes
        } // end for childnodes

    }

    /**
     *
     */
    public String toString() {
        String tempString = null;
        if (svgDiagram != null) {
            try {
                StringWriter stringOut = new StringWriter();
                OutputFormat outformat = new OutputFormat();
                outformat.setIndenting(true);
                XMLSerializer xmlserializer = new XMLSerializer(outformat);
                xmlserializer.setOutputCharStream(stringOut);
                xmlserializer.serialize(svgDiagram);
                tempString = stringOut.toString();
            }
            catch (Exception e) {
                log.error("toString failed",e);
            }
        }
        StringBuffer buf = new StringBuffer();
        buf.append("PathwayDiagram:\r\n");
        buf.append(" Name: [").append(name).append("]\r\n");
        buf.append(" svg: [").append(tempString).append("]\r\n");
        return buf.toString();
    }

    /**
     * This method reset the svg document and return the original svg document.
     * 
     * @return The original SVG document
     */
    public Document reset() throws Exception {
        this.svgDiagram = null;

        String tempString = null;

        if (originalSvg != null) {
            StringWriter stringOut = new StringWriter();
            OutputFormat outformat = new OutputFormat();
            outformat.setIndenting(true);
            XMLSerializer xmlserializer = new XMLSerializer(outformat);
            xmlserializer.setOutputCharStream(stringOut);
            xmlserializer.serialize(this.originalSvg);
            tempString = stringOut.toString();

            DocumentBuilderFactory documentBuilderFactory0 = DocumentBuilderFactory
                    .newInstance();
            documentBuilderFactory0.setNamespaceAware(true);
            DocumentBuilder documentBuilder0 = documentBuilderFactory0
                    .newDocumentBuilder();
            StringReader stringIn0 = new StringReader(tempString);
            this.svgDiagram = documentBuilder0.parse(new InputSource(
                    stringIn0));
        }
        return this.svgDiagram;
    }

    /**
     * save the document in the specified filename.
     * 
     * @param fileName
     * @param doc
     * @return true - document is saved, false otherwise
     */
    public boolean saveXMLDoc(String fileName, Document doc) {
        File xmlOutputFile = new File(fileName);
        FileOutputStream fos;
        Transformer transformer = null;
        try {
            fos = new FileOutputStream(xmlOutputFile);
        }
        catch (FileNotFoundException e) {
            log.error("saveXMLDoc failed",e);
            return false;
        }
        // Use a Transformer for output
        TransformerFactory transformerFactory = TransformerFactory
                .newInstance();
        try {
            transformer = transformerFactory.newTransformer();
        }
        catch (TransformerConfigurationException e) {
            log.error("saveXMLDoc failed",e);
            return false;
        }

        DOMSource source = new DOMSource(doc);
        StreamResult result = new StreamResult(fos);
        try {
            transformer.transform(source, result);
        }
        catch (TransformerException e) {
            log.error("saveXMLDoc failed",e);
            return false;
        }
        // System.out.println("XML file saved.");
        return true;
    }

    /* Private methods */

    /**
     * Update the filter attribute within an SVG style parameter list. ex,
     * convert
     * curr="visibility:inherit;fill:rgb(0,128,0);filter:url(#OpaqueFilter)"
     * to="visibility:inherit;fill:rgb(0,128,0);filter:url(#TransparentFilter)
     * given the filterSpec of "TransparentFilter"
     * 
     * @param source
     * @param filterSpec
     * @return The updated string with the new filter:url specified.
     */
    private String updateFilter(String source, String filterSpec) {
        StringBuffer resultbuff = new StringBuffer();
        if (source == null) return "filter:url(" + filterSpec + ')';
        try {
            // remove OpaqueFilter and Transparent if they exist
            source = source.replaceAll("filter:url(#OpaqueFilter)", "");
            source = source.replaceAll("filter:url(#TransparentFilter)", "");
           
            if (filterSpec.equals("#TransparentFilter")) {
                resultbuff.append(source).append(
                    ";filter:url(#TransparentFilter)");
            }
            else if (filterSpec.equals("#OpaqueFilter")) {
                resultbuff.append(source).append(";filter:url(#OpaqueFilter)");
            }
        }
        catch (Exception e) {
            resultbuff.append(source);
            log.error("Exception: " + e.getMessage());
        }
        return resultbuff.toString();
    }

    /**
     * Replace the color specifier in a string. The input is assumed to contain
     * text of "rgb(val,val,val)". There may be other words, chars in the
     * string. This method replaces the rgb values with those in the passed in
     * new string. <p> ex curr="visibility:inherit;fill:rgb(0,128,0)"
     * newcolor="255,0,255" returns "visibility:inherit;fill:rgb(255,0,255)"
     * 
     * @param currColor The source string
     * @param newColor The new rgb values to insert in the rgb specifier of the
     *        source string
     * @return The updated string with the RGB value modified, or the original
     *         string if a substitution was unable to be made.
     */
    private String colorMap(String currColor, String newColor) {
        // return appropriate color directive for the passed in bcid id using
        // the
        // passed in currcolor string as the template.
        // ie it could be : visibility:inherit;fill:rgb(0,128,0)
        // or : rgb(0,128,0)
        // the important part seems to be "rbg(x,x,x)"
        String result = null;
        if (newColor == null || newColor.equals("null")) return currColor;
        try {
            int rgbstart = currColor.indexOf("rgb(");
            result = currColor.substring(0, rgbstart + 4) + newColor;
            String t = currColor.substring(rgbstart + 1);
            int reststart = t.indexOf(')');
            result += t.substring(reststart);
        }
        catch (Exception e) {
            result = currColor;
            log.error("Exception: " + e.getMessage());
        }
        return result;
    }

}