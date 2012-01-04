package gov.nih.nci.system.applicationservice.impl;

import gov.nih.nci.iso21090.Ii;
import gov.nih.nci.iso21090.St;
import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.maservice.domain.ArrayReporter;
import gov.nih.nci.maservice.domain.BiologicalProcess;
import gov.nih.nci.maservice.domain.CellularComponent;
import gov.nih.nci.maservice.domain.DiseaseAssociation;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.domain.GeneAlias;
import gov.nih.nci.maservice.domain.HomologousAssociation;
import gov.nih.nci.maservice.domain.MolecularFunction;
import gov.nih.nci.maservice.domain.MolecularSequenceAnnotation;
import gov.nih.nci.maservice.domain.NucleicAcidSequenceVariation;
import gov.nih.nci.maservice.domain.Organism;
import gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism;
import gov.nih.nci.maservice.domain.DatabaseRelease;
import gov.nih.nci.maservice.errors.ErrorCodes;
import gov.nih.nci.maservice.errors.MAException;
import gov.nih.nci.maservice.util.GeneListSearchCriteria;
import gov.nih.nci.maservice.util.GeneSearchCriteria;
import gov.nih.nci.maservice.util.ReporterSearchCriteria;
import gov.nih.nci.maservice.util.DBReleaseSearchCriteria;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.MaApplicationService;
import gov.nih.nci.system.query.hibernate.HQLCriteria;
import gov.nih.nci.system.util.ClassCache;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.log4j.Logger;

/**
 * The Molecular Annotation(MA) Service extension of the ApplicationService, 
 * providing additional methods for MA Service based on its functional profiles.
 * 
 * @author <a href="mailto:sunj2@mail.nih.gov">Jim Sun</a>
 */
public class MaApplicationServiceImpl extends ApplicationServiceImpl 
                           implements MaApplicationService {
    
    private static Logger log = Logger.getLogger(MaApplicationServiceImpl.class);
   
    public MaApplicationServiceImpl(ClassCache classCache) {
        super(classCache);
    }

    /**
     * getGeneBySymbol method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return the gene(s) named by the specified gene symbol or gene alias and the genes organism.
     * @throws MAException
     */
    public List<Gene> getGenesBySymbol(GeneSearchCriteria geneSearchCriteria)
	       throws MAException {
		List<Gene> genes = null;
		try
		{
		    String hql = composeGeneHQL(geneSearchCriteria);
            genes = query(new HQLCriteria(hql.toString()));
		} 
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return genes;
	}

    /**
     * getGeneBySymbol method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return the gene(s) named by the specified gene symbol or gene alias and the genes organism.
     * @throws MAException
     */
    public List<Gene> getGenesBySymbol(GeneListSearchCriteria geneListSearchCriteria)
           throws MAException {
        List<Gene> genes = null;
        try
        {
            String hql = composeGeneListHQL(geneListSearchCriteria);      
            genes = query(new HQLCriteria(hql.toString()));
        } 
        catch ( ApplicationException e)
        {
            createMAExceptionFromApplicationException(e);
        }
        
        return genes;
    }
    
    /**
     * getAgentAssociations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the AgentAssociation class.
     * @throws MAException
     */    
	public List<AgentAssociation> getAgentAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {		
		List<Gene> genes = null;
		List<AgentAssociation> list = null; 
		try
		{
	        Gene gene = composeGeneExample(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        if ( genes==null || genes.size() == 0)
	        {
	        	// throws MAException as in specification
	        	createMAException( ErrorCodes.MAE10001);
	        }
	        
	        list = new ArrayList<AgentAssociation>();
            for (Gene g: genes)
            {
               Collection<MolecularSequenceAnnotation> msac = 
                   getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof AgentAssociation) {
		                list.add((AgentAssociation)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		} 
		catch (MAException me)
		{
			 throw me;
		}
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return list;
		
	}

    /**
     * getBiologicalProcesses method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the BiologicalProcess class.
     * @throws MAException
     */    	
	public List<BiologicalProcess> getBiologicalProcesses(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<BiologicalProcess> list = null; 
		try
		{
	        Gene gene = composeGeneExample(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);

	        if ( genes==null || genes.size() == 0)
	        {
	        	// throws MAException as in specification
	        	createMAException( ErrorCodes.MAE10001);
	        }
	        
	        list = new ArrayList<BiologicalProcess>();
            for (Gene g: genes)
            {
               Collection<MolecularSequenceAnnotation> msac = 
                   getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof BiologicalProcess) {
		                list.add((BiologicalProcess)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop	        
		} 
		catch (MAException me)
		{
			 throw me;
		}
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return list;
	}

    /**
     * getCellularLocations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the CellularComponent class.
     * @throws MAException
     */	
	public List<CellularComponent> getCellularLocations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<CellularComponent> list = null; 
		try
		{
	        Gene gene = composeGeneExample(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);

	        if ( genes==null || genes.size() == 0)
	        {
	        	// throws MAException as in specification
	        	createMAException( ErrorCodes.MAE10001);
	        }
	        	        
	        list = new ArrayList<CellularComponent>();
            for (Gene g: genes)
            {
                Collection<MolecularSequenceAnnotation> msac = 
                    getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof CellularComponent) {
		                list.add((CellularComponent)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		}
		catch (MAException me)
		{
			 throw me;
		}		
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return list;
	}

    /**
     * getDiseaseAssociations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the DiseaseAssociation class.
     * @throws MAException
     */	
	public List<DiseaseAssociation> getDiseaseAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<DiseaseAssociation> list = null; 
		try
		{
	        Gene gene = composeGeneExample(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);

	        if ( genes==null || genes.size() == 0)
	        {
	        	// throws MAException as in specification
	        	createMAException( ErrorCodes.MAE10001);
	        }
	        
	        list = new ArrayList<DiseaseAssociation>();
            for (Gene g: genes)
            {
                Collection<MolecularSequenceAnnotation> msac = 
                    getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof DiseaseAssociation) {
		                list.add((DiseaseAssociation)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		}
		catch (MAException me)
		{
			 throw me;
		}		
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return list;
	}

    /**
     * getFunctionalAssociations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the MolecularFunction class.
     * @throws MAException
     */	
	public List<MolecularFunction> getFunctionalAssociations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<MolecularFunction> list = null; 
		try
		{
	        Gene gene = composeGeneExample(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);

	        if ( genes==null || genes.size() == 0)
	        {
	        	// throws MAException as in specification
	        	createMAException( ErrorCodes.MAE10001);
	        }
	        
	        list = new ArrayList<MolecularFunction>();
            for (Gene g: genes)
            {
                Collection<MolecularSequenceAnnotation> msac = 
                    getAssociation(g, "molecularSequenceAnnotationCollection");
	           for (MolecularSequenceAnnotation msa: msac)
	           {
		           if ( msa instanceof MolecularFunction) {
		                list.add((MolecularFunction)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		}
		catch (MAException me)
		{
			 throw me;
		}		
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return list;
	}

    /**
     * getGeneByMicroarrayReporter method
     * @param reporterSearchCriteria The criteria containing a reporter name and a microarray design to search within.
     * @return Return Fully-populated instance(s) of Gene class.
     * @throws MAException
     */
	public List<Gene> getGenesByMicroarrayReporter(
			ReporterSearchCriteria reporterSearchCriteria) throws MAException {
		List<ArrayReporter> reporters = null;		
		List<Gene> genes = null; 
		try
		{
	        ArrayReporter reporter = this.composeArrayReporterCriteria(reporterSearchCriteria);
	        reporters = this.search(ArrayReporter.class, reporter);

	        if ( reporters==null || reporters.size() == 0)
	        {
	        	// throws MAException as in specification
	        	createMAException( ErrorCodes.MAE10003);
	        }
	        
	        genes = new ArrayList<Gene>();
            for (ArrayReporter ar: reporters)
            {
                Collection<Gene> gs = getAssociation(ar, "geneCollection");
                genes.addAll(gs);
            }  // end of reporters loop
		}
		catch (MAException me)
		{
			 throw me;
		}		
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return genes;
	}

    /**
     * getHomologousGene method which returns genes homologous gene in a specified organism
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of Gene class.
     * @throws MAException
     */		
	public List<Gene> getHomologousGenes(Organism organism,
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<Gene> homologousGenes = null; 
		try
		{
	        Gene gene = composeGeneExample(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        if ( genes==null || genes.size() == 0)
	        {
	        	// throws MAException as in specification
	        	createMAException( ErrorCodes.MAE10001);
	        }
	        
	        homologousGenes = new ArrayList<Gene>();
            for (Gene g: genes)
            {
               Collection<HomologousAssociation> hac = getAssociation(g, "homologousAssociationCollection");
	           for ( HomologousAssociation ha: hac)
	           {
	                Collection<Gene> hg = getAssociation(ha, "homologousGene");
	                if (hg.size()==1)
	                    homologousGenes.add(hg.iterator().next());
	           }
            }  // end of genes loop
	        
		}
		catch (MAException me)
		{
			 throw me;
		}		
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return homologousGenes;
	}

    /**
     * getStructuralVariations method.
     * @param geneSearchCriteria The criteria containing gene symbol or alias and an Organism to search within
     * @return Return Fully-populated instance(s) of the SingleNucleotidePolymorphism class.
     * @throws MAException
     */	
	public List<SingleNucleotidePolymorphism> getStructuralVariations(
			GeneSearchCriteria geneSearchCriteria) throws MAException {
		List<Gene> genes = null;
		List<SingleNucleotidePolymorphism> list = null; 
		try
		{
	        Gene gene = composeGeneExample(geneSearchCriteria);
	        genes = this.search(Gene.class, gene);
	        
	        if ( genes==null || genes.size() == 0)
	        {
	        	// throws MAException as in specification
	        	createMAException( ErrorCodes.MAE10001);
	        }
	        
	        list = new ArrayList<SingleNucleotidePolymorphism>();
            for (Gene g: genes)
            {
                Collection<NucleicAcidSequenceVariation> msac = 
                    getAssociation(g, "nucleicAcidSequenceVariationCollection");
	           for (NucleicAcidSequenceVariation msa: msac)
	           {
		           if ( msa instanceof SingleNucleotidePolymorphism) {
		                list.add((SingleNucleotidePolymorphism)msa);
		           }
	           } // finish collecting the AgentAssociation
            }  // end of genes loop
	        
		}
		catch (MAException me)
		{
			 throw me;
		}		
		catch ( ApplicationException e)
		{
			createMAExceptionFromApplicationException(e);
		}
		
		return list;
	}	
	
	private Gene composeGeneExample(GeneSearchCriteria geneSearchCriteria)
	{
        Gene gene = new Gene();
        //gene.setSymbol(geneSearchCriteria.getSymbolOrAlias());
        gene.setOrganism(geneSearchCriteria.getOrganism());
        
        // try all the Symbol as GeneAlias 
        GeneAlias alias = new GeneAlias();
        Ii  gid = new Ii();
        gid.setExtension(geneSearchCriteria.getSymbolOrAlias().getValue());        
        alias.setIdentifier(gid);
        Collection<GeneAlias> gac = new ArrayList<GeneAlias>();
        gac.add(alias);
        
        gene.setGeneAliasCollection(gac);
        
	    return gene;
	}	
	
    private String composeGeneHQL(GeneSearchCriteria geneSearchCriteria)
    {
        Collection<String> symbols = new ArrayList<String>();
        symbols.add(geneSearchCriteria.getSymbolOrAlias().getValue());
        GeneListSearchCriteria geneListSearchCriteria = new GeneListSearchCriteria();
        geneListSearchCriteria.setOrganism(geneSearchCriteria.getOrganism());
        geneListSearchCriteria.setSymbolsOrAliases(symbols);
        return composeGeneListHQL(geneListSearchCriteria);
    }
    
	private String composeGeneListHQL(GeneListSearchCriteria geneListSearchCriteria)
	{
        Organism o = geneListSearchCriteria.getOrganism();
        
        StringBuffer sb = new StringBuffer(
            "select distinct gene from gov.nih.nci.maservice.domain.Gene gene ");
        sb.append("join gene.geneAliasCollection gac ");
        if (o != null) {
            sb.append("join gene.organism o ");
        }
        sb.append("where ");

        sb.append("( ");
        
        int i=0;
        for(String symbol : geneListSearchCriteria.getSymbolsOrAliases()) {
            if (i++>0) sb.append(" or ");
            String v = symbol.toLowerCase().replaceAll("\\*", "%");
            sb.append("lower(gac.identifier.extension) like '"+v+"' ");
        }

        sb.append(") ");
        
        if (o != null) {
            if (o.getCommonName() != null && o.getCommonName().getValue() != null) 
                sb.append("and lower(o.commonName.value) = '"+o.getCommonName().getValue().toLowerCase()+"' ");
    
            if (o.getNcbiTaxonomyId() != null && o.getNcbiTaxonomyId().getExtension() != null) 
                sb.append("and lower(o.ncbiTaxonomyId.extension) = '"+o.getNcbiTaxonomyId().getExtension().toLowerCase()+"' ");
    
            if (o.getScientificName() != null && o.getScientificName().getValue() != null) 
                sb.append("and lower(o.scientificName.value) = '"+o.getScientificName().getValue().toLowerCase()+"' ");
    
            if (o.getId() != null) 
                sb.append("and o.id = '"+o.getId().getExtension()+"' ");
        }
    
	    return sb.toString();
	}	

	private ArrayReporter composeArrayReporterCriteria(ReporterSearchCriteria reporterSearchCriteria)
	{
        ArrayReporter reporter = new ArrayReporter();
        reporter.setName(reporterSearchCriteria.getReporterName());
        reporter.setMicroarray(reporterSearchCriteria.getMicroarray());
	    return reporter;
	}	

	private void createMAException(ErrorCodes errCode) throws MAException
	{	
    	St code = new St();
    	code.setValue(errCode.toString());
    	
    	St message = new St();
    	message.setValue(errCode.getDesc());
    	
    	St severity =  new St();
    	severity.setValue(errCode.getCondition());
    	
    	St type = new St();	        	
    	type.setValue("MA Service");
    	    	
        throw new MAException(code, message, severity, type);	
	}
	
	private void createMAExceptionFromApplicationException(ApplicationException e) throws MAException
	{
		ErrorCodes errCode = ErrorCodes.MAE00000;
    	St code = new St();    	
    	code.setValue(errCode.toString());
    	
    	St severity =  new St();
    	severity.setValue(errCode.getCondition());
    	
    	St type = new St();	        	
    	type.setValue("MA Service Application");
    	    	
        throw new MAException(code, severity, type, e );			
	}



        public List<DatabaseRelease> getDatabaseReleases(DBReleaseSearchCriteria dbSearchCriteria) throws MAException {
               String searchType = dbSearchCriteria.getSearchType().getValue();
               List<DatabaseRelease> releases = null;
               String hqlString=null;

               if(searchType == null || !(searchType.equalsIgnoreCase("current") ||  searchType.equalsIgnoreCase("previous") || searchType.equalsIgnoreCase("all"))){
                  createMAException( ErrorCodes.MAE10004);
               }else if( searchType.equalsIgnoreCase("current")){
                  hqlString = "select r " 
	                        + "   FROM gov.nih.nci.maservice.domain.DatabaseRelease r inner join fetch r.sourceDatabaseCollection "
	 	                + " where  r.isCurrent.value = true "; 

               } else if( searchType.equalsIgnoreCase("previous")){
                  hqlString = "select r " 
	                        + " FROM gov.nih.nci.maservice.domain.DatabaseRelease r inner join fetch r.sourceDatabaseCollection "
	 	                + " where r.releaseDate.value=" 
	 	                + " (select max(r2.releaseDate.value) from gov.nih.nci.maservice.domain.DatabaseRelease r2 "
	 	                + " where r2.isCurrent.value = false )";
               } else{
                   hqlString = "select r " +
                        "   FROM gov.nih.nci.maservice.domain.DatabaseRelease r inner join fetch r.sourceDatabaseCollection ";
 	    
               }
            


               
               try{
                   
                   releases = query(new HQLCriteria(hqlString));
               } catch ( ApplicationException e){
                       createMAExceptionFromApplicationException(e);
               }

               return releases;
       }


}
