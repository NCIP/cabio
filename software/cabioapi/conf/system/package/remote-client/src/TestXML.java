
import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.common.util.XMLUtility;
import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.io.File;
import java.io.FileWriter;
import java.util.Iterator;
import java.util.List;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Source;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

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
 * TestXML.java demonstartes various ways to serialize / deserialize object 
 * using the XMLUtility class.
 * 
 * @author caBIO Team
 */
public class TestXML {
    
	public static void main(String[] args) throws Exception {

		System.out.println("*** TestClient...");

		ApplicationService appService = 
            ApplicationServiceProvider.getApplicationService();

        XMLUtility myUtil = new XMLUtility();
        
		try {
			System.out.println("Scenario 1: Retrieving a Gene based on a Gene Symbol.");
			Gene gene = new Gene();
			gene.setSymbol("brca2");
			
			List resultList = appService.search(Gene.class, gene);
			System.out.println("Result list size: " + resultList.size()	+ "\n");
			long startTime = System.currentTimeMillis();
			for (Iterator resultsIterator = resultList.iterator(); resultsIterator.hasNext();) {                    
                Gene returnedGene = (Gene) resultsIterator.next();
                System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                System.out.println("Gene object right after search: \n\n");
                System.out.println("   Id: " + returnedGene.getId() + "\n");
                System.out.println("   Fullname: " + returnedGene.getFullName() + "\n");
                System.out.println("   ClusterId: " + returnedGene.getClusterId() + "\n");
                System.out.println("   Symbol: " + returnedGene.getSymbol() + "\n\n\n");
                
                File myFile = new File("./test1.xml");
                FileWriter myWriter = new FileWriter(myFile);
                myUtil.toXML(returnedGene, myWriter);
                DocumentBuilder parser = DocumentBuilderFactory.newInstance().newDocumentBuilder();
                Document document = parser.parse(myFile);
                SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
                
                Source schemaFile = new StreamSource(new File("conf/gov.nih.nci.cabio.domain.xsd"));
                Schema schema = factory.newSchema(schemaFile);
                Validator validator = schema.newValidator();
                System.out.println("Validating gene against the schema......\n\n");
                validator.validate(new DOMSource(document));
                System.out.println("Gene has been validated!!!\n\n");
                
                Gene myGene = (Gene) myUtil.fromXML(myFile);                        
                System.out.println("Retrieving gene from xml ....\n\n");
                System.out.println("   Id: " + myGene.getId() + "\n");
                System.out.println("   Fullname: " + myGene.getFullName() + "\n");
                System.out.println("   ClusterId: " + myGene.getClusterId() + "\n");
                System.out.println("   Symbol: " + myGene.getSymbol() + "\n");
                System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            }                        
		
			long endTime = System.currentTimeMillis();
			System.out.println("latency in miliseconds = " + (endTime - startTime));

		} catch (Exception e) {
			e.printStackTrace();
		}
        
		try {
            System.out.println("===================================================");
            System.out.println("\n\n\nScenario 2: Retrieving a Chromosome based on number");
            Chromosome chromosome = new Chromosome();
            chromosome.setNumber("M*");
  
                List resultList1 = appService.search(Chromosome.class, chromosome);
                System.out.println("Result list size: " + resultList1.size() + "\n");
            long startTime = System.currentTimeMillis();
            for (Iterator resultsIterator1 = resultList1.iterator(); resultsIterator1.hasNext();) {
                Chromosome returnedCRF = (Chromosome) resultsIterator1.next();
                System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                System.out.println("Chromosome object right after search: \n\n");
                System.out.println("   Id: " + returnedCRF.getId() + "\n");
                System.out.println("   Number: " + returnedCRF.getNumber() + "\n");                     
           
                File myFile1 = new File("./test3.xml");
                FileWriter myWriter1 = new FileWriter(myFile1);
                myUtil.toXML(returnedCRF, myWriter1);
                DocumentBuilder parser1 = DocumentBuilderFactory.newInstance().newDocumentBuilder();
                Document document1 = parser1.parse(myFile1);
                SchemaFactory factory1 = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
                //Source schemaFile1 = new StreamSource(new File("C:/cacore/lib/gov.nih.nci.cadsr.domain.xsd"));
                //Schema schema1 = factory1.newSchema(schemaFile1);
                //Validator validator1 = schema1.newValidator();
                //System.out.println("Validating CaseReportForm ......\n\n");
                //validator1.validate(new DOMSource(document1));
                //System.out.println("CaseReportForm has been validated!!!\n\n");

                Chromosome myCRF = (Chromosome) myUtil.fromXML(myFile1);
                System.out.println("Retrieving Chromosome from xml ....\n\n");
                System.out.println("   Id: " + myCRF.getId() + "\n");
                System.out.println("   Number: "+ myCRF.getNumber() + "\n");
                System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");                        
            }
			long endTime = System.currentTimeMillis();
			System.out.println("latency in miliseconds = "+ (endTime - startTime));

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}