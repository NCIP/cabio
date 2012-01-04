package gov.nih.nci.cabio.annotations;

import gov.nih.nci.cabio.domain.ArrayReporter;
import gov.nih.nci.cabio.domain.CytobandPhysicalLocation;
import gov.nih.nci.cabio.domain.ExonArrayReporter;
import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneAlias;
import gov.nih.nci.cabio.domain.Microarray;
import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.system.applicationservice.ApplicationException;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Convenience API for Microarray Annotations in caBIO. These methods provide
 * bulk access to reporter annotations and other useful shortcuts. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public interface ArrayAnnotationService {

    /**
     * Given an array and list of reporter names, return a mapping of those
     * reporter names to HUGO gene symbols.
     * @param arrayPlatform Microarray name
     * @param reporterIds List of reporters on the specified microarray
     * @return mapping of reporter names to lists of gene symbols
     * @throws ApplicationException system error
     */
    public abstract Map<String, Collection<String>> getGenesForReporters(
            String arrayPlatform, Collection<String> reporterIds)
            throws ApplicationException;

    /**
     * Given an array and a list of HUGO gene symbols, return a mapping of 
     * those gene symbols to reporters on the specified array.
     * @param arrayPlatform Microarray name
     * @param geneSymbols list of HUGO gene symbols 
     * @return mapping of genes to lists of reporters
     * @throws ApplicationException system error
     */
    public abstract Map<String, Collection<String>> getReportersForGenes(
            String arrayPlatform, Collection<String> geneSymbols)
            throws ApplicationException;

    /**
     * Returns all ArrayReporters on a given array platform.
     * @param arrayPlatform name of Microarray
     * @return collection of ArrayReporter objects
     * @throws ApplicationException system error
     */
    public abstract Collection<ArrayReporter> getReportersForPlatform(
            String arrayPlatform) throws ApplicationException;

    /**
     * Given an array and list of reporter names, return the 
     * ExpressionArrayReporter objects corresponding to the reporter names, 
     * populated with the following annotations:
     * <ul>
     * <li>gene
     * </ul>
     * @param arrayPlatform expression microarray name
     * @param reporterIds list of reporter names
     * @return list of prepopulated array reporters
     * @throws ApplicationException system error
     */
    public abstract Collection<ExpressionArrayReporter> 
            getExpressionReporterAnnotations(String arrayPlatform, 
            Collection<String> reporterIds) throws ApplicationException;

    /**
     * Given an array and list of reporter names, return the 
     * ExonArrayReporter objects corresponding to the reporter names.
     * 
     * @param arrayPlatform exon microarray name
     * @param reporterIds list of reporter names
     * @return list of prepopulated array reporters
     * @throws ApplicationException system error
     */
    public abstract Collection<ExonArrayReporter> 
            getExonReporterAnnotations(String arrayPlatform, 
            Collection<String> reporterIds) throws ApplicationException;
    
    /**
     * Given an array and list of reporter names, return the 
     * SNPArrayReporter objects corresponding to the reporter names, 
     * populated with the following annotations:
     * <ul>
     * <li>SNP
     * </ul>
     * @param arrayPlatform SNP microarray name
     * @param reporterIds list of reporter names
     * @return list of prepopulated array reporters
     * @throws ApplicationException system error
     */
    public abstract Collection<SNPArrayReporter> 
            getSNPReporterAnnotations(String arrayPlatform, 
            Collection<String> reporterIds) throws ApplicationException;

    /**
     * Returns a collection of the requested genes, populated with the 
     * following annotations:
     * <ul>
     * <li>chromosome
     * </ul>
     * @param geneSymbols list of HUGO gene symbols
     * @return collection of Genes prepopulated with associated annotations
     * @throws ApplicationException system error
     */
    public abstract Collection<Gene> getGeneAnnotations(
            Collection<String> geneSymbols) throws ApplicationException;

    /**
     * Returns all the cytobands on the specified chromosome (found on the 
     * reference assembly).
     * @param chromosomeNumber the number of the chromosome
     * @return list of cytoband physical locations
     * @throws ApplicationException system error
     */
    public abstract List<CytobandPhysicalLocation> getCytobandPositions(
            String chromosomeNumber) throws ApplicationException;

    /**
     * Returns all the cytobands on the specified chromosome of the given 
     * assembly.
     * @param chromosomeNumber the number of the chromosome
     * @param assembly the assembly to consider
     * @return list of cytoband physical locations
     * @throws ApplicationException system error
     */
    public abstract List<CytobandPhysicalLocation> getCytobandPositions(
            String chromosomeNumber, String assembly) 
            throws ApplicationException;

    /**
     * Returns the Microarray with the given name.
     * @param platformName Microarray name
     * @return Microarray of interest
     * @throws ApplicationException system error
     */
    public abstract Microarray getMicroarray(String platformName)
            throws ApplicationException;

    /**
     * Returns the genes with the given HUGO symbol.
     * @param symbol HUGO gene symbol
     * @return The Genes of interest
     * @throws ApplicationException system error
     */
    public abstract Collection<Gene> getGenesForSymbol(String hugoSymbol)
            throws ApplicationException;

    /**
     * Returns the aliases associated with the given gene sumbol. 
     * @param symbol HUGO gene symbol
     * @return collection of GeneAlias objects
     * @throws ApplicationException system error
     */
    public abstract Collection<GeneAlias> getAliasesForGene(String symbol)
            throws ApplicationException;
    
    /**
     * Returns all reporter names for the specified SNP on the given array.
     * @param arrayPlatform Microarray name
     * @param dbSnpIds dbSNP Ids
     * @return Collection of reporter names
     * @throws ApplicationException system error
     */
    public abstract HashMap<String, Collection<String>> getReportersForSnps(
            String arrayPlatform, List<String> dbSnpIds) throws ApplicationException;
    
    /**
     * Returns the specified SNP preloaded with annotations. 
     * 
     * @param arrayPlatform Microarray name
     * @param dbSnpIds list of dbSNP Ids
     * @return SNP objects preloaded with associations
     * @throws ApplicationException system error
     */
    public abstract Collection<SNP> getSNPAnnotations(List<String> dbSnpIds)
            throws ApplicationException;

    /**
     * Returns the  genes associated with the given dBSNP id by array 
     * annotations (relative locations).
     * @param dbSnpId dbSNP Id
     * @return Collection of HUGO gene symbols
     * @throws ApplicationException system error
     */
    public abstract Collection<Gene> getGenesForDbSnpId(String dbSnpId) 
            throws ApplicationException;

    /**
     * Returns all the SNPs within the specified range of the given gene on 
     * the specified assembly.
     * @param symbol HUGO gene symbol 
     * @param kbUpstream distance upstream
     * @param kbDownstream distance downstream
     * @param assembly genome assembly for SNP and Gene locations
     * @return List of SNPs
     * @throws ApplicationException system error
     */
    public abstract Collection<SNP> getSnpsNearGene(
            String symbol, Long kbUpstream, Long kbDownstream, String assembly)
            throws ApplicationException;
    
    /**
     * Returns all the SNPs within the specified range of the given gene, on 
     * the reference assembly.
     * @param symbol HUGO gene symbol 
     * @param kbUpstream distance upstream
     * @param kbDownstream distance downstream
     * @return List of SNPs
     * @throws ApplicationException system error
     */
    public abstract Collection<SNP> getSnpsNearGene(
            String symbol, Long kbUpstream, Long kbDownstream)
            throws ApplicationException;
}