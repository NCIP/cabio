/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.common.util;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;


/**
 * PrintUtils consists of methods that prints data to a Standard Output Device.
 *
 * @author caBIO Team
 * @version 1.0
 */
public class PrintUtils {

    private static Logger log = Logger.getLogger(PrintUtils.class);

    /**
     * Prints the objects in a given list
     * @param resultList Specifies the objects that needs to printed return
     */
    public void printResults(List resultList) {

        int recordNum = 1;
        for (Iterator rList = resultList.iterator(); rList.hasNext();) {
            Object result = rList.next();
            Class resultClass = result.getClass();
            String className = resultClass.getName();
            if (className.startsWith("java.lang")
                    || className.equalsIgnoreCase("java.util.Date")) {
                for (int i = 0; i < resultList.size(); i++) {
                    System.out.println(resultList.get(i));
                }
            }
            else {

                String attribName = null;
                Field[] fields = getAllFields(resultClass);
                Method[] methods = getAllMethods(resultClass);
                List methodList = new ArrayList();
                List methodForObject = new ArrayList();
                List methodForObjects = new ArrayList();

                System.out.println("\n(" + recordNum + "). Class name = "
                        + className + "\n");

                for (int f = 0; f < fields.length; f++) {
                    fields[f].setAccessible(true);
                    String fieldClassName = fields[f].getType().getName();
                    String fieldName = fields[f].getName().substring(0, 1)
                            .toUpperCase()
                            + fields[f].getName().substring(1);

                    for (int i = 0; i < methods.length; i++) {
                        String methodName = methods[i].getName();
                        if (methodName.endsWith(fieldName)
                                && methodName.startsWith("get")) {

                            if (fieldClassName.startsWith(resultClass
                                    .getPackage().getName())) {
                                methodForObject.add(methods[i]);
                            }
                            else if (fieldClassName.endsWith("Collection")) {
                                methodForObjects.add(methods[i]);
                            }
                            else {
                                methodList.add(methods[i]);
                            }
                            break;
                        }
                    }

                }

                int count = 1;
                for (Iterator iList = methodList.iterator(); iList.hasNext();) {
                    Method meth = (Method) iList.next();
                    attribName = meth.getName().substring(3);
                    try {
                        System.out.println("--> " + attribName + " - "
                                + meth.invoke(result, new Object[] {}));
                        count++;
                    }
                    catch (Exception ex) {
                        log.error("ERROR: " + ex.getMessage());
                    }

                }
                recordNum++;
            }
        }
        System.out.println("\n\n" + resultList.size() + " \trecords found");

    }

    /**
     * Gets all the fields of a given class
     *
     * @param resultClass - Specifies the class name
     * @return - returns all the fields of a class
     */
    public Field[] getAllFields(Class resultClass) {
        List fieldList = new ArrayList();
        try {

            while (resultClass != null && !resultClass.isInterface()
                    && !resultClass.isPrimitive()) {
                Field[] fields = resultClass.getDeclaredFields();
                for (int i = 0; i < fields.length; i++) {
                    fields[i].setAccessible(true);
                    fieldList.add(fields[i]);
                }

                if (!resultClass.getSuperclass().getName().equalsIgnoreCase(
                    "java.lang.Object")) {
                    resultClass = resultClass.getSuperclass();
                }
                else {
                    break;
                }

            }
        }
        catch (Exception ex) {
            log.error("ERROR: " + ex.getMessage());
        }

        Field[] fields = new Field[fieldList.size()];
        for (int i = 0; i < fieldList.size(); i++) {
            fields[i] = (Field) fieldList.get(i);
        }
        return fields;
    }

    /**
     * Gets all the methods of a given class
     *
     * @param resultClass - Specifies the class name
     * @return - Returns all the methods
     */

    public Method[] getAllMethods(Class resultClass) {

        List methodList = new ArrayList();
        try {
            while (resultClass != null && !resultClass.isInterface()
                    && !resultClass.isPrimitive()) {
                Method[] method = resultClass.getDeclaredMethods();
                for (int i = 0; i < method.length; i++) {
                    method[i].setAccessible(true);
                    methodList.add(method[i]);
                }

                if (!resultClass.getSuperclass().getName().equalsIgnoreCase(
                    "java.lang.Object")) {
                    resultClass = resultClass.getSuperclass();
                }
                else {
                    break;
                }
            }
        }
        catch (Exception ex) {
            log.error("ERROR: " + ex.getMessage());
        }

        Method[] methods = new Method[methodList.size()];
        for (int i = 0; i < methodList.size(); i++) {
            methods[i] = (Method) methodList.get(i);
        }
        return methods;
    }

}
