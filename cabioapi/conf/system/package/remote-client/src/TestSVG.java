import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.common.util.SVGManipulator;
import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Document;

/*
 * <!-- LICENSE_TEXT_START -->
 * Copyright 2001-2004 SAIC. Copyright 2001-2003 SAIC. This software was developed in conjunction with the National Cancer Institute,
 * and so to the extent government employees are co-authors, any rights in such works shall be subject to Title 17 of the United States Code, section 105.
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the disclaimer of Article 3, below. Redistributions
 * in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other
 * materials provided with the distribution.
 * 2. The end-user documentation included with the redistribution, if any, must include the following acknowledgment:
 * "This product includes software developed by the SAIC and the National Cancer Institute."
 * If no such end-user documentation is to be included, this acknowledgment shall appear in the software itself,
 * wherever such third-party acknowledgments normally appear.
 * 3. The names "The National Cancer Institute", "NCI" and "SAIC" must not be used to endorse or promote products derived from this software.
 * 4. This license does not authorize the incorporation of this software into any third party proprietary programs. This license does not authorize
 * the recipient to use any trademarks owned by either NCI or SAIC-Frederick.
 * 5. THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED WARRANTIES, (INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE) ARE DISCLAIMED. IN NO EVENT SHALL THE NATIONAL CANCER INSTITUTE,
 * SAIC, OR THEIR AFFILIATES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * <!-- LICENSE_TEXT_END -->
 */

/**
 * TestSVG.java demonstartes how to use the SVGManipulation class to change the
 * apprearance of a pathway diagram associated with a given pathway.
 * 
 * @author caBIO Team
 */
public class TestSVG {

    public static void main(String[] args) throws Exception {

        System.out.println("*** TestSVG...");
        
        ApplicationService appService = 
            ApplicationServiceProvider.getApplicationService();

        /**  Example used in the Developer Guide */

        System.out.println("Retrieving Pathway from cabio");
        Pathway pw = new Pathway();
        pw.setName("h_freePathway");

        List resultList = appService.search(Pathway.class, pw);
        if (resultList.size() != 1) {
            System.err.println("Pathway lookup returned "
                    + resultList.size() + " results.");
            return;
        }

        Pathway returnedPw = (Pathway) resultList.get(0);

        // Generate SVGManipulator with pathway diagram
        SVGManipulator svgM = new SVGManipulator(returnedPw);
        // Get SVG diagram
        Document orgSvgDoc = svgM.getSvgDiagram();
        // Save the svg diagram
        svgM.saveXMLDoc("orginal.svg", orgSvgDoc);

        // Reset the SVG diagram to it's original state and
        // disable all the genes
        svgM.reset();
        svgM.disableAllGenes();
        Document disableGenesDoc = svgM.getSvgDiagram();
        svgM.saveXMLDoc("disableGenesDoc.svg", disableGenesDoc);

        // Reset SVG diagram to it's original state and disable
        // all the nodes
        svgM.reset();
        svgM.disableAllNodes();
        Document disableNodesDoc = svgM.getSvgDiagram();
        svgM.saveXMLDoc("disableNodesDoc.svg", disableNodesDoc);

        // Reset SVG diagram to it's Original state and change
        // the display colors for each gene
        svgM.reset();
        Gene[] genes = new Gene[2];
        String[] colors = new String[2];

        Gene gene1 = new Gene();
        gene1.setClusterId(new Long(443914));
        gene1.setSymbol("SOD1");
        List resultList1 = appService.search(Gene.class, gene1);
        if (resultList1.size() > 0) genes[0] = (Gene) resultList1.get(0);

        Gene gene2 = new Gene();
        gene2.setClusterId(new Long(241570));
        gene2.setSymbol("TNF");
        List resultList2 = appService.search(Gene.class, gene2);
        if (resultList2.size() > 0) genes[1] = (Gene) resultList2.get(0);

        colors[0] = "255,50,50";
        colors[1] = "0,255,255";
        svgM.setSvgColors(genes, colors);

        Document geneColor = svgM.getSvgDiagram();
        svgM.saveXMLDoc("geneColor.svg", geneColor);

        // Retrieve Color for each Gene
        System.out.println("Gene 1 color: " + svgM.getSvgColor(genes[0]));
        System.out.println("Gene 2 color: " + svgM.getSvgColor(genes[1]));
        String svgString = svgM.toString();
        System.out.println("toString:\n" + svgString);

        svgM.reset();

        svgM.setGeneInfoLocation(
            "http://127.0.0.1:8080/cabio40/GetHTML?query=Gene&amp;GeneAlias[@name=%%]");
            
        // Change the color of a Gene in the SVG diagram
        Map<String,String> geneColors = new HashMap<String,String>();
        geneColors.put("nfkb", "0,255,255");
        geneColors.put("gpx", "0,255, 255");

        svgM.setSvgColors(geneColors);

        Document d = svgM.getSvgDiagram();
        svgM.saveXMLDoc("geneMap.svg", d);

    }
}
