/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.grididloader;

import gov.nih.nci.grididloader.BigEntity.EntityJoin;
import gov.nih.nci.grididloader.BigEntity.Join;
import gov.nih.nci.grididloader.BigEntity.TableJoin;

import java.io.FileWriter;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentFactory;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

/**
 * Entity configuration reader/writer. 
 *
 */
/**
 * @author caBIO Team
 * @version 1.0
 */
public class Config {

    /** All the entities, loaded from the configuration file */
    private final Collection<BigEntity> entities = new ArrayList<BigEntity>();

    /**
     * Loads the entity mapping from a steam of an XML formatted file.
     * @throws Exception
     */
    public void loadXMLMapping(InputStream xmlMappingStream) throws Exception {
        final SAXReader xmlReader = new SAXReader();
        loadXMLMapping(xmlReader.read(xmlMappingStream));
    }

    /**
     * Loads the entity mapping from an XML formatted file.
     * @throws Exception
     */
    public void loadXMLMapping(String xmlMappingFile) throws Exception {
        final SAXReader xmlReader = new SAXReader();
        loadXMLMapping(xmlReader.read(xmlMappingFile));
    }
    
    /**
     * Loads the entity mapping from an XML document DOM.
     * @throws Exception
     */
    public void loadXMLMapping(Document xmlMappingDoc) throws Exception {
        
        final Element mapping = xmlMappingDoc.getRootElement();
        final String mappingPackage = mapping.attribute("package").getText();
        
        // Damn you 1.4 iteration API!
        Iterator elementIterator = mapping.elementIterator();
        
        Map<String,BigEntity> entityMap = new HashMap<String,BigEntity>();
        
        // for each <entity>
        while (elementIterator.hasNext()) {
            final Element entityElement = (Element)elementIterator.next();
            final String className = entityElement.attribute("class").getText();
            final String tableName = entityElement.attribute("table").getText();
            final boolean serial = (entityElement.attribute("parallel") != null) &&
                    "false".equals(entityElement.attribute("parallel").getText());
            final String primaryKey = entityElement.element("primary-key").getText();
            final Element logicalElement = entityElement.element("logical-key");

            final Map<String,Join> joinMap = new HashMap<String,Join>();
            final Collection<Join> joins = new ArrayList<Join>();
            final List<String> attributeList = new ArrayList<String>();
            
            // use the sb to create commaDelimitedFields
            final StringBuffer sb = new StringBuffer(tableName);
            sb.append(".");
            sb.append(primaryKey);
            
            // for each <property>
            final Iterator logicalIterator = logicalElement.elementIterator();
            while (logicalIterator.hasNext()) {

                final Element propertyElement = (Element)logicalIterator.next();
                final String attr = propertyElement.getText();
                final Attribute foreignTableAttr = propertyElement.attribute("table");
                final Attribute foreignEntityAttr = propertyElement.attribute("entity");

                // comma before every logical key property
                sb.append(",");
                
                // foreign attribute?
                if (foreignTableAttr != null) {
                    final String foreignKey = propertyElement.attribute("foreign-key").getText();
                    final String foreignTable = foreignTableAttr.getText();
                    final String foreignTablePK = propertyElement.attribute("primary-key").getText();
                    
                    TableJoin join = null;
                    // have we already seen this join on this foreign key?
                    String key = foreignTable+"~"+foreignKey;
                    if (joinMap.containsKey(key)) {
                        join = (TableJoin)joinMap.get(key);
                    }
                    else {
                        join = new TableJoin(foreignKey, foreignTable, foreignTablePK);
                        joinMap.put(key, join);
                        joins.add(join);
                    }
    
                    // add this attribute to the join
                    join.addAttribute(attr);
                }
                // join to an entire entity 
                else if (foreignEntityAttr != null) {
                    final String foreignKey = propertyElement.attribute("foreign-key").getText();
                    final String foreignEntity = foreignEntityAttr.getText();
                    BigEntity joinEntity = entityMap.get(foreignEntity);
                    if (joinEntity == null) {
                        System.err.println("ERROR: Invalid reference to "+
                                foreignEntity+" in "+className);
                    }
                    else {
                        Join join = new EntityJoin(foreignKey, joinEntity);
                        joins.add(join);
                    }
                }
                // a regular attribute
                else {
                    attributeList.add(attr);
                }
            }

            String[] attributes = new String[attributeList.size()];
            attributeList.toArray(attributes);
            
            BigEntity entity = new BigEntity(tableName, mappingPackage, className, 
                    primaryKey, attributes, joins, !serial);
            entities.add(entity);
            entityMap.put(entity.getClassName(), entity);
        }
    }
    
    /**
     * Serialized the entity mapping to an XML format.
     * @param xmlMappingFile
     * @throws Exception
     */
    public void saveXMLMapping(String xmlMappingFile) throws Exception {

        Document doc = DocumentFactory.getInstance().createDocument();
        Element mapping = doc.addElement("mapping");
        String mappingPackage = null;
        
        for(BigEntity entity : entities) {
            String packageName = entity.getPackageName();
            String className = entity.getClassName();
            
            if (mappingPackage == null) {
                mappingPackage = packageName;
            }
            else if (!mappingPackage.equals(packageName)) {
                System.err.println("ERROR: inconsistent package, "+
                        mappingPackage+" != "+packageName);
            }
            
            // create entity
            Element entityElement = mapping.addElement("entity")
                .addAttribute("class", className)
                .addAttribute("table", entity.getTableName());
            entityElement.addElement("primary-key").addText(entity.getPrimaryKey());
            Element logicalElement = entityElement.addElement("logical-key");
            
            // add joined attributes
            Map<String,String> seenAttrs = new HashMap<String,String>();
            Collection<Join> joins = entity.getJoins();
            for(Join join : joins) {
                if (join instanceof TableJoin) {
                    TableJoin tableJoin = (TableJoin)join;
                    for(String attr : tableJoin.getAttributes()) {
                        logicalElement.addElement("property").
                            addAttribute("table", tableJoin.getForeignTable()).
                            addAttribute("primary-key", tableJoin.getForeignTablePK()).
                            addAttribute("foreign-key", tableJoin.getForeignKey()).
                            addText(attr);
                        seenAttrs.put(attr, null);
                    }
                }
                else {
                    EntityJoin entityJoin = (EntityJoin)join;
                    logicalElement.addElement("property").
                        addAttribute("entity", entityJoin.getEntity().getClassName()).
                        addAttribute("foreign-key", entityJoin.getForeignKey());
                }
            }
            
            // add all the leftover non-joined attributes
            for(String attr : entity.getAttributes()) {
                if (!seenAttrs.containsKey(attr)) {
                    logicalElement.addElement("property").addText(attr);
                }
            }
        }
        
        mapping.addAttribute("package", mappingPackage);
        
        // write to file
        OutputFormat outformat = OutputFormat.createPrettyPrint();
        XMLWriter writer = new XMLWriter(new FileWriter(xmlMappingFile), outformat);
        writer.write(doc);
        writer.flush();
    }

    /**
     * Returns the loaded configuration. This method will return an empty list
     * until one of the load*() methods is successfully called.
     */
    public Collection<BigEntity> getEntities() {
        return entities;
    }
}
