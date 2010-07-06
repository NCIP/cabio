package gov.nih.nci.maservice.util;


import com.sun.xml.bind.CycleRecoverable;
import gov.nih.nci.system.client.util.xml.JAXBISOAdapter;
import gov.nih.nci.system.client.util.xml.JAXBISOIvlPqAdapter;
import gov.nih.nci.system.client.util.xml.JAXBISOIvlRealAdapter;
import gov.nih.nci.system.client.util.xml.JAXBISOIvlTsAdapter;
import gov.nih.nci.system.client.util.xml.JAXBISOIvlIntAdapter;
import gov.nih.nci.system.client.util.xml.JAXBISODsetAdAdapter;
import gov.nih.nci.system.client.util.xml.JAXBISODsetIiAdapter;
import gov.nih.nci.system.client.util.xml.JAXBISODsetCdAdapter;
import gov.nih.nci.system.client.util.xml.JAXBISODsetTelAdapter;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import java.io.Serializable;


/**
	* 
	**/

@XmlAccessorType(XmlAccessType.NONE)
@XmlSeeAlso({gov.nih.nci.maservice.util.GeneSearchCriteria.class, gov.nih.nci.maservice.util.ReporterSearchCriteria.class})
@XmlType(name = "SearchCriteria", namespace="gme://caCORE.caCORE/3.2/gov.nih.nci.maservice.util", propOrder = {})
@XmlRootElement(name="SearchCriteria", namespace="gme://caCORE.caCORE/3.2/gov.nih.nci.maservice.util")
public class SearchCriteria  implements Serializable, CycleRecoverable
{
	/**
	* An attribute to allow serialization of the domain objects
	*/
	private static final long serialVersionUID = 1234567890L;

	    public Object onCycleDetected(Context arg0) {
		return null;
	}

	
}