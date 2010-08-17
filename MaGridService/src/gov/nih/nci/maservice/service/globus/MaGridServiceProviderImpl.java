package gov.nih.nci.maservice.service.globus;

import gov.nih.nci.maservice.service.MaGridServiceImpl;

import java.rmi.RemoteException;

/** 
 * DO NOT EDIT:  This class is autogenerated!
 *
 * This class implements each method in the portType of the service.  Each method call represented
 * in the port type will be then mapped into the unwrapped implementation which the user provides
 * in the MaGridServiceImpl class.  This class handles the boxing and unboxing of each method call
 * so that it can be correclty mapped in the unboxed interface that the developer has designed and 
 * has implemented.  Authorization callbacks are automatically made for each method based
 * on each methods authorization requirements.
 * 
 * @created by Introduce Toolkit version 1.3
 * 
 */
public class MaGridServiceProviderImpl{
	
	MaGridServiceImpl impl;
	
	public MaGridServiceProviderImpl() throws RemoteException {
		impl = new MaGridServiceImpl();
	}
	

    public gov.nih.nci.maservice.stubs.GetGenesBySymbolResponse getGenesBySymbol(gov.nih.nci.maservice.stubs.GetGenesBySymbolRequest params) throws RemoteException, gov.nih.nci.maservice.stubs.types.MolecularAnnotationServiceException {
    gov.nih.nci.maservice.stubs.GetGenesBySymbolResponse boxedResult = new gov.nih.nci.maservice.stubs.GetGenesBySymbolResponse();
    boxedResult.setGene(impl.getGenesBySymbol(params.getGeneSearchCriteria().getGeneSearchCriteria()));
    return boxedResult;
  }

    public gov.nih.nci.maservice.stubs.GetAgentAssociationsResponse getAgentAssociations(gov.nih.nci.maservice.stubs.GetAgentAssociationsRequest params) throws RemoteException, gov.nih.nci.maservice.stubs.types.MolecularAnnotationServiceException {
    gov.nih.nci.maservice.stubs.GetAgentAssociationsResponse boxedResult = new gov.nih.nci.maservice.stubs.GetAgentAssociationsResponse();
    boxedResult.setAgentAssociation(impl.getAgentAssociations(params.getGeneSearchCriteria().getGeneSearchCriteria()));
    return boxedResult;
  }

    public gov.nih.nci.maservice.stubs.GetBiologicalProcessesResponse getBiologicalProcesses(gov.nih.nci.maservice.stubs.GetBiologicalProcessesRequest params) throws RemoteException {
    gov.nih.nci.maservice.stubs.GetBiologicalProcessesResponse boxedResult = new gov.nih.nci.maservice.stubs.GetBiologicalProcessesResponse();
    boxedResult.setBiologicalProcess(impl.getBiologicalProcesses(params.getGeneSearchCriteria().getGeneSearchCriteria()));
    return boxedResult;
  }

    public gov.nih.nci.maservice.stubs.GetCellularLocationsResponse getCellularLocations(gov.nih.nci.maservice.stubs.GetCellularLocationsRequest params) throws RemoteException {
    gov.nih.nci.maservice.stubs.GetCellularLocationsResponse boxedResult = new gov.nih.nci.maservice.stubs.GetCellularLocationsResponse();
    boxedResult.setCellularComponent(impl.getCellularLocations(params.getGeneSearchCriteria().getGeneSearchCriteria()));
    return boxedResult;
  }

    public gov.nih.nci.maservice.stubs.GetDiseaseAssociationsResponse getDiseaseAssociations(gov.nih.nci.maservice.stubs.GetDiseaseAssociationsRequest params) throws RemoteException {
    gov.nih.nci.maservice.stubs.GetDiseaseAssociationsResponse boxedResult = new gov.nih.nci.maservice.stubs.GetDiseaseAssociationsResponse();
    boxedResult.setDiseaseAssociation(impl.getDiseaseAssociations(params.getGeneSearchCriteria().getGeneSearchCriteria()));
    return boxedResult;
  }

    public gov.nih.nci.maservice.stubs.GetFunctionalAssociationsResponse getFunctionalAssociations(gov.nih.nci.maservice.stubs.GetFunctionalAssociationsRequest params) throws RemoteException {
    gov.nih.nci.maservice.stubs.GetFunctionalAssociationsResponse boxedResult = new gov.nih.nci.maservice.stubs.GetFunctionalAssociationsResponse();
    boxedResult.setMolecularFunction(impl.getFunctionalAssociations(params.getGeneSearchCriteria().getGeneSearchCriteria()));
    return boxedResult;
  }

    public gov.nih.nci.maservice.stubs.GetStructuralVariationsResponse getStructuralVariations(gov.nih.nci.maservice.stubs.GetStructuralVariationsRequest params) throws RemoteException {
    gov.nih.nci.maservice.stubs.GetStructuralVariationsResponse boxedResult = new gov.nih.nci.maservice.stubs.GetStructuralVariationsResponse();
    boxedResult.setSingleNucleotidePolymorphism(impl.getStructuralVariations(params.getGeneSearchCriteria().getGeneSearchCriteria()));
    return boxedResult;
  }

    public gov.nih.nci.maservice.stubs.GetHomologousGenesResponse getHomologousGenes(gov.nih.nci.maservice.stubs.GetHomologousGenesRequest params) throws RemoteException {
    gov.nih.nci.maservice.stubs.GetHomologousGenesResponse boxedResult = new gov.nih.nci.maservice.stubs.GetHomologousGenesResponse();
    boxedResult.setGene(impl.getHomologousGenes(params.getOrganism().getOrganism(),params.getGeneSearchCriteria().getGeneSearchCriteria()));
    return boxedResult;
  }

    public gov.nih.nci.maservice.stubs.GetGenesByMicroarrayReporterResponse getGenesByMicroarrayReporter(gov.nih.nci.maservice.stubs.GetGenesByMicroarrayReporterRequest params) throws RemoteException {
    gov.nih.nci.maservice.stubs.GetGenesByMicroarrayReporterResponse boxedResult = new gov.nih.nci.maservice.stubs.GetGenesByMicroarrayReporterResponse();
    boxedResult.setGene(impl.getGenesByMicroarrayReporter(params.getReporterSearchCriteria().getReporterSearchCriteria()));
    return boxedResult;
  }

}
