/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import gov.nih.nci.cabio.domain.Agent;
import gov.nih.nci.cabio.domain.NucleicAcidSequence;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.Protein;
import gov.nih.nci.cabio.pathways.ComplexComponent;
import gov.nih.nci.cabio.pathways.ComplexEntity;
import gov.nih.nci.cabio.pathways.EntityAccession;
import gov.nih.nci.cabio.pathways.EntityName;
import gov.nih.nci.cabio.pathways.FamilyMember;
import gov.nih.nci.cabio.pathways.Interaction;
import gov.nih.nci.cabio.pathways.PhysicalEntity;
import gov.nih.nci.cabio.pathways.PhysicalParticipant;
import gov.nih.nci.cabio.pathways.ProteinEntity;
import gov.nih.nci.cabio.pathways.ProteinSubunit;
import gov.nih.nci.cabio.pathways.RNAEntity;
import gov.nih.nci.cabio.pathways.SmallMoleculeEntity;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

/**
 * Demonstrates how to aggregate PID data from caBIO into a molecule report
 * similar to the one produced by PID. 
 * 
 * @author caBIO Team
 */
public class TestPID {

    private static CaBioApplicationService as;
    
    public static void main(String[] args) throws Exception {
        
        as = (CaBioApplicationService) 
            ApplicationServiceProvider.getApplicationService(); 
        
        // RNA example (http://pid.nci.nih.gov/MoleculePage?molid=101810)
        printEntity("Met-tRNA"); 
        
        // Compound example (http://pid.nci.nih.gov/MoleculePage?molid=560)
        printEntity("dinoprostone");
        
        // Protein example (http://pid.nci.nih.gov/MoleculePage?molid=501958)
        printEntity("VEGF"); 

        // Family example (http://pid.nci.nih.gov/MoleculePage?molid=100260)
        printEntity("VEGF R"); 
        
        // Complex example (http://pid.nci.nih.gov/MoleculePage?molid=100688)
        printEntity("VEGF/VEGF R"); 

        // Another family example (http://pid.nci.nih.gov/MoleculePage?molid=201132)
        printEntity("RAS family"); 
         
        // Protein used in 2 different complexes (http://pid.nci.nih.gov/MoleculePage?molid=503377)
        printEntity("GYS1");

        // Protein used in 2 different complexes (http://pid.nci.nih.gov/MoleculePage?molid=503376)
        printEntity("glycogen synthase 1 tetramer, I form"); 
        
        // Protein used in 2 different complexes (http://pid.nci.nih.gov/search/MoleculePage?molid=502721)
        printEntity("Ubiquinone"); 
    }
    
    private static final void printEntity(String name) throws Exception {

        List<PhysicalEntity> entities = getEntities(name);
        System.out.println("===========================");
        System.out.println("Print '"+name+"'");
        for(PhysicalEntity pe : entities) {
            printEntity(pe);
        }
    }
    
    private static final void printEntity(PhysicalEntity e) throws Exception {
                
        System.out.println("===========================");
        System.out.println("Names: "+getNames(e));
        System.out.println("Accessions: "+getAccessions(e));
        System.out.println("Molecule id: "+e.getId());
        
        if (e instanceof ProteinEntity) {
            ProteinEntity pe = (ProteinEntity)e;
            System.out.println("Molecule type: protein");
            System.out.print("Associations to caBIO Proteins: ");
            if (printList(pe.getProteinCollection())) {
                for (Protein protein : pe.getProteinCollection()) {
                    System.out.println("  Protein: "+protein.getPrimaryAccession()+" "+protein.getUniProtCode());
                }
            }
            System.out.print("Protein Subunits: ");
            if (printList(pe.getSubunitCollection())) {
                for (ProteinSubunit subunit : pe.getSubunitCollection()) {
                    System.out.println("  Subunit: "+getNames(subunit));
                }
            }
        }
        else if (e instanceof RNAEntity) {
            RNAEntity pe = (RNAEntity)e;
            System.out.println("Molecule type: RNA");
            System.out.print("Associations to caBIO NucleicAcidSequences: ");
            if (printList(pe.getNucleicAcidSequenceCollection())) {
                for (NucleicAcidSequence nas : pe.getNucleicAcidSequenceCollection()) {
                    System.out.println("  NucleicAcidSequence: "+nas.getAccessionNumber());
                }
            }
        }
        else if (e instanceof SmallMoleculeEntity) {
            SmallMoleculeEntity pe = (SmallMoleculeEntity)e;
            System.out.println("Molecule type: compound");
            System.out.print("Associations to caBIO Agents: ");
            if (printList(pe.getAgentCollection())) {
                for (Agent agent : pe.getAgentCollection()) {
                    System.out.println("  Agent: "+agent.getName());
                }
            }
        }
        else if (e instanceof ComplexEntity) {
            System.out.println("Molecule type: complex");
            System.out.print("Components: ");
            ComplexEntity pe = (ComplexEntity)e;
            if (printList(pe.getComplexComponentCollection())) {
                for (ComplexComponent comp : pe.getComplexComponentCollection()) {
                    System.out.println("  ComplexComponent: "+getNames(comp.getPhysicalEntity()));
                }
            }
        }
        else {
            System.out.println("ERROR: Unknown molecule type, "+e.getClass());
        }

        // Split the physical participants into complex components and "other" 
        // interaction uses, and figure out what families we're part of.
        Collection<PhysicalParticipant> participants = e.getPhysicalParticipantCollection();
        Collection<ComplexComponent> complexUses = new ArrayList<ComplexComponent>();
        Collection<PhysicalParticipant> interactionUses = new ArrayList<PhysicalParticipant>();
        Collection<PhysicalEntity> families = new HashSet<PhysicalEntity>();
        for(PhysicalParticipant pp : participants) {
            if (pp instanceof ComplexComponent) {
                complexUses.add((ComplexComponent)pp);
            }
            else if (pp instanceof FamilyMember) {
                families.addAll(((FamilyMember)pp).getFamilyCollection());
            }
            else {
                interactionUses.add(pp);
            }
        }

        System.out.print("Family members: ");
        if (printList(e.getMemberCollection())) {
            for (FamilyMember fm : e.getMemberCollection()) {
                System.out.println("  FamilyMember: "+getNames(fm.getPhysicalEntity()));
            }
        }
        
        System.out.println("Is member of family: "+getFamilyList(families));
        
        System.out.print("Uses in complexes: ");
        if (printList(complexUses)) {
            System.out.println("  Complex, Location, State, PTM");
            System.out.println("  -----------------------------");
            for(PhysicalParticipant pp : participants) {
                if (!(pp instanceof ComplexComponent)) continue;
                ComplexEntity complex = ((ComplexComponent)pp).getComplex();
                System.out.println("  "+getNames(complex)+", "+pp.getLocation()+", "+pp.getActivityState()+", "+pp.getPostTranslationalMod());
            }
        }

        System.out.print("Uses in interactions: ");
        if (printList(interactionUses)) {
            System.out.println("  Role, Location, State, PTM, Interaction, Source, Pathways");
            System.out.println("  ---------------------------------------------------------");
            for(PhysicalParticipant pp : interactionUses) {
                String role = getClassName(pp);
                Interaction interaction = pp.getInteraction();
                System.out.print("  "+role+", "+pp.getLocation()+", "+pp.getActivityState()+", "+pp.getPostTranslationalMod());
                if (interaction != null) {
                    System.out.println(", "+getClassName(interaction)+"#"+interaction.getId()+", "+interaction.getSource()+", "+getPathways(interaction));
                }
            }
        }

        System.out.println();
    }
    
    /**
     * Utility function for printing lists.
     */
    private static final boolean printList(Collection c) {
        if (c.isEmpty()) {
            System.out.println("NONE");
            return false;
        }
        else {
            System.out.println();
            return true;
        }
    }

    /**
     * Returns the basic class name, stripping off the extra information
     * added by Hibernate proxies.
     */
    private static final String getClassName(Object obj) {
        String name = obj.getClass().getSimpleName();
        name = name.substring(0, name.indexOf('$'));
        return name;
    }
    
    /**
     * Returns a comma-delimited list of names for the given PhysicalEntity.
     */
    private static final String getNames(PhysicalEntity e) throws Exception {
        if (e == null) return "PhysicalEntity";
        StringBuffer sb = new StringBuffer();
        int i = 0;
        for(EntityName en : e.getEntityNameCollection()) {
            if (i++>0) sb.append(", ");
            sb.append(en.getName());
        }
        return sb.toString();
    }

    /**
     * Returns a slash-delimited list of pathways.
     */
    private static final String getPathways(Interaction interaction) throws Exception {
        if (interaction == null) return "null";
        StringBuffer sb = new StringBuffer();
        int i = 0;
        for(Pathway p : interaction.getPathwayCollection()) {
            if (i++>0) sb.append("/");
            sb.append(p.getName());
        }
        if (sb.length()==0) return "NONE";
        return sb.toString();
    }

    /**
     * Returns a comma-delimited list of accession numbers for the given PhysicalEntity.
     */
    private static final String getFamilyList(Collection<PhysicalEntity> families) throws Exception {
        StringBuffer sb = new StringBuffer();
        int i = 0;
        for(PhysicalEntity f : families) {
            if (i++>0) sb.append(", ");
            sb.append(f.getEntityNameCollection().iterator().next().getName());
        }
        if (sb.length()==0) return "NONE";
        return sb.toString();
    }
    
    /**
     * Returns a comma-delimited list of accession numbers for the given PhysicalEntity.
     */
    private static final String getAccessions(PhysicalEntity e) throws Exception {
        StringBuffer sb = new StringBuffer();
        int i = 0;
        for(EntityAccession ea : e.getEntityAccessionCollection()) {
            if (i++>0) sb.append(", ");
            sb.append(ea.getAccession()+" ("+ea.getDatabase()+")");
        }
        if (sb.length()==0) return "NONE";
        return sb.toString();
    }

    /**
     * Returns all the PhysicalEntity objects which have names matching the 
     * specified string. 
     */
    private static final List<PhysicalEntity> getEntities(String name) throws Exception {

        List<PhysicalEntity> all = new ArrayList<PhysicalEntity>();
        
        EntityName entityName = new EntityName();
        entityName.setName(name);
        
        List<EntityName> results = as.search(EntityName.class, entityName);
        for(EntityName en : results) {
            all.addAll(en.getPhysicalEntityCollection());
        }
        
        return all;
    }
    
}