package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.pathways.ComplexComponent;
import gov.nih.nci.cabio.pathways.ComplexEntity;
import gov.nih.nci.cabio.pathways.EntityName;
import gov.nih.nci.cabio.pathways.FamilyMember;
import gov.nih.nci.cabio.pathways.Input;
import gov.nih.nci.cabio.pathways.Interaction;
import gov.nih.nci.cabio.pathways.Macroprocess;
import gov.nih.nci.cabio.pathways.Output;
import gov.nih.nci.cabio.pathways.Participant;
import gov.nih.nci.cabio.pathways.PhysicalEntity;
import gov.nih.nci.cabio.pathways.PhysicalParticipant;
import gov.nih.nci.cabio.pathways.PositiveControl;
import gov.nih.nci.cabio.pathways.ProteinEntity;
import gov.nih.nci.cabio.pathways.RNAEntity;
import gov.nih.nci.cabio.pathways.SmallMoleculeEntity;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import junit.framework.TestCase;

/**
 * Tests for data from the Pathway Interaction Database in the caBIO model.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class PIDTest extends TestCase {
    
    private final CaBioApplicationService appService = AllTests.getService();
    
    /**
     * Tests an example RNA entity's uses in interactions. 
     */
    public void testRNAEntityInteractionUses() throws Exception {

        String name = "Met-tRNA";
        List<PhysicalEntity> all = getEntities(name);
        assertEquals("Number of results for "+name,1,all.size());
        RNAEntity rna = (RNAEntity)all.get(0);

        List<PhysicalParticipant> usesInInteractions = getUsesInInteractions(rna);        
        assertEquals("Interaction uses for "+name, 1, usesInInteractions.size());
        
        PhysicalParticipant pp = usesInInteractions.get(0);
        assertTrue("Expected input role for "+name, pp instanceof Input);
        
        Interaction interaction = pp.getInteraction();
        assertNotNull("Expected not null interaction for "+name, interaction);
        assertEquals("Source of interaction for "+name,"BioCarta", interaction.getSource());
        
        Collection<Pathway> pathways = interaction.getPathwayCollection();
        assertEquals("Number of pathways with interactions where "+name+" is input", 1, pathways.size());
        assertEquals("h_eif2Pathway",pathways.iterator().next().getName());
    }

    /**
     * Tests an example RNA entity's uses in complexes.
     */
    public void testRNAEntityComplexUses() throws Exception {

        String name = "Met-tRNA";
        List<PhysicalEntity> all = getEntities(name);
        assertEquals("Number of results for "+name,1,all.size());
        RNAEntity rna = (RNAEntity)all.get(0);

        List<ComplexComponent> usesInComplexes = getUsesInComplexes(rna);
        assertEquals("Complex uses for "+name, 2, usesInComplexes.size());
        
        boolean matchFirst = false;
        boolean matchSecond = false;
        
        for(ComplexComponent cc : usesInComplexes) {
            if (hasName(cc.getComplex(), "48S/S6")) matchFirst = true;
            if (hasName(cc.getComplex(), "43S Ribosome")) matchSecond = true;
        }
        
        assertTrue("Expected "+name+" to be part of complex 48S/S6",matchFirst);
        assertTrue("Expected "+name+" to be part of complex 43S Ribosome",matchSecond);
        
    }

    /**
     * Tests an example compound's uses in families.
     */
    public void testCompoundFamilyUses() throws Exception {
        
        String name = "dinoprostone";
        List<PhysicalEntity> all = getEntities(name);
        assertEquals("Number of results for "+name,1,all.size());
        SmallMoleculeEntity compound = (SmallMoleculeEntity)all.get(0);

        List<FamilyMember> usesInFamilies = getUsesInFamilies(compound);
        assertEquals("Family uses for "+name, 1, usesInFamilies.size());
        
        FamilyMember member = usesInFamilies.get(0);
        Collection<PhysicalEntity> families = member.getFamilyCollection();
        assertEquals("Families for "+name, 1, families.size());
    
        String fname = "cAMP activators";
        assertHasName("Family for "+name, fname, families.iterator().next());
    }

    /**
     * Tests an example compound's uses in complexes.
     */
    public void testCompoundComplexUses() throws Exception {
        
        String name = "dinoprostone";
        List<PhysicalEntity> all = getEntities(name);
        assertEquals("Number of results for "+name,1,all.size());
        SmallMoleculeEntity compound = (SmallMoleculeEntity)all.get(0);

        List<ComplexComponent> usesInComplexes = getUsesInComplexes(compound);
        assertEquals("Complex uses for "+name, 4, usesInComplexes.size());
        
        boolean[] matches = new boolean[4];
        
        for(ComplexComponent cc : usesInComplexes) {
            ComplexEntity c = cc.getComplex();
            if (hasName(c, "Prostaglandin E2/EP1R")) matches[0] = true;
            if (hasName(c, "Prostaglandin E2/EP2R")) matches[1] = true;
            if (hasName(c, "Prostaglandin E2/EP3R")) matches[2] = true;
            if (hasName(c, "Prostaglandin E2/EP4R")) matches[3] = true;
        }
        
        for(int i=0; i<matches.length; i++) {
            assertTrue("Expected "+name+
                " to be part of complex Prostaglandin E2/EP"+(i+1)+"R",matches[i]);
        }
    }
    
    /**
     * Tests a protein families to ensure it has all its members.
     */
    public void testFamily() throws Exception {
        
        String name = "RAS family";
        List<PhysicalEntity> all = getEntities(name);
        assertEquals("Number of results for "+name,1,all.size());
        ProteinEntity protein = (ProteinEntity)all.get(0);
     
        Collection<FamilyMember> members = protein.getMemberCollection();
        assertEquals("Family members in "+name, 5, members.size());

        List<ComplexComponent> usesInComplexes = getUsesInComplexes(protein);
        assertEquals("Complex uses for "+name, 6, usesInComplexes.size());
    }

    /**
     * Tests a complex and its components.
     */
    public void testComplex() throws Exception {

        String name = "VEGF/VEGF R";
        List<PhysicalEntity> all = getEntities(name);
        assertEquals("Number of results for "+name,1,all.size());
        ComplexEntity complex = (ComplexEntity)all.get(0);

        Collection<ComplexComponent> components = complex.getComplexComponentCollection();
        assertEquals("Complex components in "+name, 2, components.size());
        
        boolean matchFirst = false;
        boolean matchSecond = false;
        
        for(ComplexComponent cc : components) {
            if (hasName(cc.getPhysicalEntity(), "VEGF")) matchFirst = true;
            if (hasName(cc.getPhysicalEntity(), "VEGF R")) matchSecond = true;
        }
        
        assertTrue("Expected VEGF to be part of complex "+name,matchFirst);
        assertTrue("Expected VEGF R to be part of complex "+name,matchSecond);
    }
    
    /**
     * Tests a complex which has a component repeated several times.
     */
    public void testRepeatedComponentInComplex() throws Exception {
    
        String name = "glycogen synthase 1 tetramer, I form";
        List<PhysicalEntity> all = getEntities(name);
        assertEquals("Number of results for "+name,1,all.size());
        ComplexEntity complex = (ComplexEntity)all.get(0);
     
        Collection<ComplexComponent> components = complex.getComplexComponentCollection();
        assertEquals("Complex components in "+name, 4, components.size());
        
        Long componentId = components.iterator().next().getPhysicalEntity().getId();
        for(ComplexComponent component : components) {
            assertEquals("Expected 4 identical components in "+name, componentId, component.getPhysicalEntity().getId());
        }
    }

    /**
     * Starts with a pathway which is expected to have a single macroprocess,
     * and tests for participants in that macroprocess.
     */
    public void testMacroprocess() throws Exception {
    
        String name = "h_caspasePathway";
        Pathway pathway = new Pathway();
        pathway.setName(name);
        List<Pathway> results = appService.search(Pathway.class, pathway);
        assertEquals("Number of results for "+name,1,results.size());
        pathway = results.get(0);
        
        Macroprocess mp = null;
        for(Interaction interaction : pathway.getInteractionCollection()) {
            if (interaction instanceof Macroprocess) {
                mp = (Macroprocess)interaction;
            }
        }
        
        assertNotNull("Expected to find macroprocess in "+name,mp);
        assertEquals("Macroprocess in "+name,"degradation",mp.getName());
        
        Collection<Participant> parts = mp.getParticipantCollection();
        assertEquals("Number of participants in macroprocess for "+name,3,parts.size());
        
        boolean foundInput = false;
        boolean foundOutput = false;
        boolean foundControl = false;
        
        for(Participant part : parts) {
            PhysicalParticipant pp = (PhysicalParticipant)part;
            PhysicalEntity pe = pp.getPhysicalEntity();
            if (pp instanceof Input) {
                assertHasName("Input to Macroprocess in "+name,"ICAD/CAD",pe);
                foundInput = true;
            }
            if (pp instanceof Output) {
                assertHasName("Input to Macroprocess in "+name,"DFFB",pe);
                assertEquals("Location for output of macroprocess in "+name,"cytoplasm",((Output)part).getLocation());
                foundOutput = true;
            }
            if (pp instanceof PositiveControl) {
                assertHasName("PositiveControl to Macroprocess in "+name,"CASP3",pe);
                foundControl = true;
            }
        }
        
        assertTrue("Expected Input to Macroprocess in "+name,foundInput);
        assertTrue("Expected Output to Macroprocess in "+name,foundOutput);
        assertTrue("Expected PositiveControl to Macroprocess in "+name,foundControl);
     
    }
    
    private void assertHasName(String msg, String name, PhysicalEntity entity) {
        if (hasName(entity, name)) return;
        assertEquals(msg, name, getNames(entity));
    }
    
    /* 
     * UTILITY FUNCITONS FOR DEALING WITH THE PID MODEL 
     * TODO: expose as part of caBIO API in a future release 
     */

    /**
     * Returns a comma-delimited list of names for the given PhysicalEntity.
     */
    private String getNames(PhysicalEntity e) {
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
     * Returns true if the given entity has the specified name. 
     * @param entity Entity to check
     * @param name Name to check for
     * @return true if entity has the name, false otherwise
     */
    private boolean hasName(PhysicalEntity entity, String name) {
        for (EntityName en : entity.getEntityNameCollection()) {
            if (name.equals(en.getName())) return true;
        }
        return false;
    }
    
    /**
     * Returns all PhysicalEntities with the given name. At most, this will
     * return one entity per source (e.g. Biocarta, Reactome, Nature). 
     * @param name EntityName.name
     * @return PhysicalEntities with the given name
     * @throws Exception
     */
    private List<PhysicalEntity> getEntities(String name) throws ApplicationException {
        List<PhysicalEntity> all = new ArrayList<PhysicalEntity>();
        EntityName entityName = new EntityName();
        entityName.setName(name);
        List<EntityName> results = appService.search(EntityName.class, entityName);
        for(EntityName en : results) {
            all.addAll(en.getPhysicalEntityCollection());
        }
        return all;
    }
    
    /**
     * Returns a list of ComplexComponents which enumerate the uses of the
     * given entity in complexes.
     * @param e Entity
     * @return ComplexComponents using the specified entity
     */
    private List<ComplexComponent> getUsesInComplexes(PhysicalEntity e) {
        Collection<PhysicalParticipant> participants = e.getPhysicalParticipantCollection();
        List<ComplexComponent> results = new ArrayList<ComplexComponent>();
        for(PhysicalParticipant pp : participants) {
            if (pp instanceof ComplexComponent) {
                results.add((ComplexComponent)pp);
            }
        }
        return results;
    }

    /**
     * Returns a list of FamilyMembers which enumerate the uses of the given
     * entity in PhysicalEntity families. 
     * @param e Entity
     * @return FamilyMembers using the specified entity
     */
    private List<FamilyMember> getUsesInFamilies(PhysicalEntity e) {
        Collection<PhysicalParticipant> participants = e.getPhysicalParticipantCollection();
        List<FamilyMember> results = new ArrayList<FamilyMember>();
        for(PhysicalParticipant pp : participants) {
            if (pp instanceof FamilyMember) {
                results.add((FamilyMember)pp);
            }
        }
        return results;
    }
    
    /**
     * Returns a list of PhysicalParticipants for the given entity, excluding
     * FamilyMembers and ComplexComponents.
     * @param e Entity
     * @return PhysicalParticipants using the specified entity in an interaction
     */
    private List<PhysicalParticipant> getUsesInInteractions(PhysicalEntity e) {
        Collection<PhysicalParticipant> participants = e.getPhysicalParticipantCollection();
        List<PhysicalParticipant> results = new ArrayList<PhysicalParticipant>();
        for(PhysicalParticipant pp : participants) {
            if (!(pp instanceof ComplexComponent) && !(pp instanceof FamilyMember)) {
                results.add(pp);
            }
        }
        return results;
    }

}
