package gov.nih.nci.maservice.util;

import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.iso21090.St;

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
@XmlSeeAlso({gov.nih.nci.maservice.util.SearchCriteria.class})
@XmlType(name = "GeneSearchCriteria", namespace="gme://caCORE.caCORE/3.2/gov.nih.nci.maservice.util", propOrder = {"symbolOrAlias", "organism"})
@XmlRootElement(name="GeneSearchCriteria", namespace="gme://caCORE.caCORE/3.2/gov.nih.nci.maservice.util")
public class GeneSearchCriteria extends SearchCriteria implements Serializable, CycleRecoverable
{
	/**
	* An attribute to allow serialization of the domain objects
	*/
	private static final long serialVersionUID = 1234567890L;

	
	/**
	* 
	**/
	
	private St symbolOrAlias;
	/**
	* Retrieves the value of the symbolOrAlias attribute
	* @return symbolOrAlias
	**/
    @XmlElement(namespace="gme://caCORE.caCORE/3.2/gov.nih.nci.maservice.util")
    @XmlJavaTypeAdapter(JAXBISOAdapter.class)
	public St getSymbolOrAlias(){
		return symbolOrAlias;
	}

	/**
	* Sets the value of symbolOrAlias attribute
	**/

	public void setSymbolOrAlias(St symbolOrAlias){
		this.symbolOrAlias = symbolOrAlias;
	}
	
	/**
	* An associated gov.nih.nci.maservice.domain.Organism object
	**/
	
	@XmlElement(name="organism", 
				type=Organism.class,
				namespace="gme://caCORE.caCORE/3.2/gov.nih.nci.maservice.domain")
	private Organism organism;
	/**
	* Retrieves the value of the organism attribute
	* @return organism
	**/
	@XmlTransient
	public Organism getOrganism(){
		return organism;
	}
	/**
	* Sets the value of organism attribute
	**/

	public void setOrganism(Organism organism){
		this.organism = organism;
	}
			    public Object onCycleDetected(Context arg0) {
		return null;
	}

	
}