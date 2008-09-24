/**
 * Summary formatting for caBIO domain objects. 
 */
var caBioFormats = function() {
    return {
    
    summary : {
	    "gov.nih.nci.cabio.domain.Agent":{
	        "title":["EVSId"],
	        "desc":["name","comment"]
	    },
	    "gov.nih.nci.cabio.domain.Anomaly":{
	        "title":["description"]
	    },
	    "gov.nih.nci.cabio.domain.ClinicalTrialProtocol":{
	        "title":["title"],
	        "desc":["leadOrganizationId","leadOrganizationName"]
	    },
	    "gov.nih.nci.cabio.domain.DiseaseOntology":{
	        "title":["EVSId"],
	        "desc":["name"]
	    },
	    "gov.nih.nci.cabio.domain.Evidence":{
	        "title":["sentence"],
	        "desc":["comments"],
	        "ids":["pubmedId"]
	    },
	    "gov.nih.nci.cabio.domain.Gene":{
	        "title":["symbol"],
	        "desc":["fullName"]
	    },
	    "gov.nih.nci.cabio.domain.GeneAlias":{
	        "title":["name"],
	        "desc":["type"]
	    },
	    "gov.nih.nci.cabio.domain.GeneOntology":{
	        "title":["name"]
	    },
	    "gov.nih.nci.cabio.domain.Histopathology":{
	        "title":["grossDescription"],
	        "desc":["comments"]
	    },
	    "gov.nih.nci.cabio.domain.Library":{
	        "title":["name"],
	        "desc":["keyword"]
	    },
	    "gov.nih.nci.cabio.domain.Microarray":{
	        "title":["manufacturer","name"],
	        "desc":["description"]
	    },
	    "gov.nih.nci.cabio.domain.OrganOntology":{
	        "title":["name"]
	    },
	    "gov.nih.nci.cabio.domain.Pathway":{
	        "title":["name", "displayValue"],
	        "desc":["description"]
	    },
	    "gov.nih.nci.cabio.domain.Protein":{
	        "title":["primaryAccession","name"],
	        "desc":["keywords"]
	    },
	    "gov.nih.nci.cabio.domain.ProteinAlias":{
	        "title":["name"]
	    },
	    "gov.nih.nci.cabio.domain.Protocol":{
	        "title":["name"],
	        "desc":["type"]
	    },
	    "gov.nih.nci.cabio.domain.ProtocolAssociation":{
	        "title":["CTEPNAME"],
	        "desc":["diseaseCategory"]
	    },
	    "gov.nih.nci.cabio.domain.Tissue":{
	        "title":["name", "displayValue"],
	        "desc":["description"]
	    },
	    "gov.nih.nci.cabio.domain.Vocabulary":{
	        "title":["coreTerm"],
	        "desc":["generalTerm"]
	    }
    }
        
    };
}();
        