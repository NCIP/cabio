package gov.nih.nci.cabio.portal.portlet;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.HashSet;
import java.util.Set;

/**
 * Utilities for dealing with reflection. 
 * TODO: These methods should be moved to caBIO's ReflectionUtils.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ClassUtils {

    /**
     * Given a Hibernate class like 
     * gov.nih.nci.cabio.domain.GeneOntology$$EnhancerByCGLIB$$3582c014
     * this will remove the enchancer portion and return just
     * "gov.nih.nci.cabio.domain.GeneOntology"
     * @param className
     * @return
     */
    public static String removeEnchancer(Class clazz) {
        return removeEnchancer(clazz.getName());
    }
    
    /**
     * Given a Hibernate class name like 
     * "gov.nih.nci.cabio.domain.GeneOntology$$EnhancerByCGLIB$$3582c014"
     * this will remove the enchancer portion and return just
     * "gov.nih.nci.cabio.domain.GeneOntology"
     * @param className
     * @return
     */
    public static String removeEnchancer(String className) {
        return className.split("\\$\\$")[0];
    }
    
    /**
     * Returns true if the given association is a non-collection type.
     * @param clazz
     * @param assocName
     * @return
     */
    public static boolean isSingular(Class clazz, String assocName) {
        
        Class checkClass = clazz;
        
        while (checkClass != null) {
            Field[] classFields = checkClass.getDeclaredFields();
            if(classFields!=null) {
                for(int i=0;i<classFields.length;i++) {
                    if (classFields[i].getName().equals(assocName)) {
                        Class type = classFields[i].getType();
                        String typeName = type.getName();
                        return (!type.isPrimitive() && 
                                !typeName.startsWith("java") && 
                                !"java.util.Collection".equals(typeName));
                    }
                }
            }
            checkClass = checkClass.getSuperclass();
        }
        
        throw new IllegalArgumentException(
            "Association "+assocName+" not found in "+clazz);
    }
    
    /**
     * Returns the type at the end of the given association. If the association 
     * is 1-to-1 or many-to-1 then there is only one object at the end of the
     * association, and this just returns its type. But if the association is 
     * 1-to-many or many-to-many then there is a Collection on the other end,
     * and this returns the parameterized generic type of the Collection. 
     * @param clazz
     * @param assocName
     * @return
     */
    public static Class getAssociationType(Class clazz, String assocName) {
        
        Class checkClass = clazz;
        while (checkClass != null) {
            Field[] classFields = checkClass.getDeclaredFields();
            if(classFields!=null) {
                for(int i=0;i<classFields.length;i++) {
                    Type generic = classFields[i].getGenericType();
                    if (classFields[i].getName().equals(assocName)) {
                        if (generic instanceof Class) {
                            return classFields[i].getType();
                        }
                        if (generic instanceof ParameterizedType) {
                            ParameterizedType ptype = (ParameterizedType)generic;
                            return (Class)ptype.getActualTypeArguments()[0];
                        }
                    }
                }
            }
            checkClass = checkClass.getSuperclass();
        }

        return null;
    }
    
    /**
     * Borrowed from ClassCache.java in the caCORE SDK.
     * @param clazz
     * @return
     */
    public static Field[] getFields(Class clazz) {
        
        Set<Field> allFields = new HashSet<Field>();
        Class checkClass = clazz;
        
        while (checkClass != null) {
            Field[] classFields = checkClass.getDeclaredFields();
            if(classFields!=null) {
                for(int i=0;i<classFields.length;i++) {
                    Class type = classFields[i].getType();
                    String typeName = type.getName();
                    if (!Modifier.isStatic(classFields[i].getModifiers()) 
                            && ((type.isPrimitive() || 
                                (typeName.startsWith("java") && 
                                !"java.util.Collection".equals(typeName))))) {
                        allFields.add(classFields[i]);
                    }
                }
            }
            checkClass = checkClass.getSuperclass();
        }
        
        Field[] fieldArray = new Field[allFields.size()];
        allFields.toArray(fieldArray);
        return fieldArray;
    }
}
