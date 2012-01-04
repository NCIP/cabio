package gov.nih.nci.caBIOApp.sod;

import gov.nih.nci.caBIOApp.util.AppConfig;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.SortedMap;
import java.util.StringTokenizer;
import java.util.TreeMap;

public class SODUtils {

    private static SODUtils _instance = null;
    private static SearchableObjectsDescription _sod = null;

    private SODUtils() {
        try {
            SODFactory fact = (SODFactory) Class.forName(
                AppConfig.getInstance().getSODFactoryClassname()).newInstance();
            _sod = fact.getSOD();
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw new RuntimeException("SODUtils.<init>, caught: "
                    + ex.getClass().getName() + ":" + ex.getMessage());
        }
    }

    public static SODUtils getInstance() {
        if (_instance == null) {
            _instance = new SODUtils();
        }
        return _instance;
    }

    public SearchableObject getSearchableObject(String objClassname) {
        return getSearchableObject(_sod, objClassname);
    }

    public SearchableObject getSearchableObject(
            SearchableObjectsDescription sod, String objClassname) {
        if (objClassname == null) {
            throw new IllegalArgumentException(
                    "SearchableObject classname is null");
        }

        boolean usingShortName = objClassname.indexOf(".") == -1;
        if (objClassname.endsWith("Impl")) {
            objClassname = objClassname.substring(0,
                objClassname.indexOf("Impl"));
        }

        SearchableObject theSo = null;
        for (Iterator i = sod.getSearchableObjects().iterator(); i.hasNext();) {
            SearchableObject so = (SearchableObject) i.next();
            String name = so.getClassname();
            if (usingShortName) {
                name = name.substring(name.lastIndexOf(".") + 1);
            }
            if (objClassname.equals(name)) {
                theSo = so;
                break;
            }
        }
        return theSo;
    }

    public Attribute getAttribute(SearchableObject so, String attName) {
        Attribute theAtt = null;
        if (attName == null) {
            throw new IllegalArgumentException("Attribute name is null");
        }

        for (Iterator i = so.getAttributes().iterator(); i.hasNext();) {
            Attribute anAtt = (Attribute) i.next();
            if (attName.equals(anAtt.getName())) {
                theAtt = anAtt;
                break;
            }
        }
        return theAtt;
    }

    public Association getAssociation(SearchableObject so, String assClassname) {
        if (assClassname == null) {
            throw new IllegalArgumentException("Association classname is null");
        }
        Association theAss = null;
        for (Iterator i = so.getAssociations().iterator(); i.hasNext();) {
            Association anAss = (Association) i.next();
            if (assClassname.equals(anAss.getClassname())) {
                theAss = anAss;
                break;
            }
        }
        return theAss;
    }

    public List getAssociatedObjects(SearchableObject so) {
        return getAssociatedObjects(_sod, so);
    }

    public List getAssociatedObjects(SearchableObjectsDescription sod,
            SearchableObject so) {
        List assocObjs = new ArrayList();
        List assoces = so.getAssociations();
        for (Iterator i = assoces.iterator(); i.hasNext();) {
            Association a = (Association) i.next();
            assocObjs.add(getSearchableObject(sod, a.getClassname()));
        }
        return assocObjs;
    }

    public static void main(String[] args) {

        try {
            /*
             * SODFactory fact = (SODFactory)Class.forName(
             * "gov.nih.nci.caBIO.ui.sod.SODFactoryImpl" ).newInstance();
             * SearchableObjectsDescription sod = fact.getSOD();
             */
            SODUtils sod = SODUtils.getInstance();
            for (Iterator i = sod.getSearchableObjects().iterator(); i.hasNext();) {
                SearchableObject so = (SearchableObject) i.next();
                so = sod.getSearchableObject(so.getClassname());
                System.out.println(so.getLabel());
                for (Iterator j = so.getAttributes().iterator(); j.hasNext();) {
                    Attribute a = (Attribute) j.next();
                    a = sod.getAttribute(so, a.getName());
                    System.out.println("\t" + a.getLabel());
                }
                for (Iterator k = so.getAssociations().iterator(); k.hasNext();) {
                    Association a = (Association) k.next();
                    a = sod.getAssociation(so, a.getClassname());
                    System.out.println("\t" + a.getLabel());
                }
            }
        }
        catch (Exception ex) {
            System.out.println("Exception: " + ex.getClass().getName() + ": "
                    + ex.getMessage());
            ex.printStackTrace();
        }
    }

    public String getBeanName(String objectName) {
        String beanName = null;
        if (objectName != null) {
            int idx = objectName.lastIndexOf(".");
            if (idx == -1) {
                beanName = objectName;
            }
            else {
                beanName = objectName.substring(idx + 1);
            }
        }
        return beanName;
    }

    public String getShortName(String objectName) {
        return getBeanName(objectName);
    }

    public List getSearchableObjects() {
        return _sod.getSearchableObjects();
    }

    public List getQueryableAttributes(SearchableObject so) {
        List qAtts = new ArrayList();
        List atts = so.getAttributes();
        for (Iterator i = atts.iterator(); i.hasNext();) {
            Attribute att = (Attribute) i.next();
            String cName = att.getCriterionName();
            if (cName != null && !"".equals(cName)) {
                qAtts.add(att);
            }
        }
        return qAtts;
    }

    public List getDisplayableAttributes(SearchableObject so) {
        List dAtts = new ArrayList();
        List atts = so.getAttributes();
        List lps = so.getLabelProperties();
        for (Iterator i = atts.iterator(); i.hasNext();) {
            Attribute att = (Attribute) i.next();
            String name = att.getName();
            if (lps.contains(name)) {
                dAtts.add(att);
            }
        }
        return dAtts;
    }

    public Association getAssociationWithPath(SearchableObject so, List path) {
        Association theAssoc = null;
        List assocs = so.getAssociations();
        search: for (Iterator i = assocs.iterator(); i.hasNext();) {
            Association anAssoc = (Association) i.next();
            List pathItems = anAssoc.getPathItems();
            int numItems = pathItems.size();
            if (numItems == path.size() - 1) {
                for (int j = 0; j < numItems; j++) {
                    String given = (String) path.get(j);
                    String compareTo = ((PathItem) pathItems.get(j)).getClassname();

                    if (compareTo.equals(given)) {
                        if (j == numItems - 1) {
                            String s = (String) path.get(j + 1);
                            if (s.equals(anAssoc.getClassname())) {
                                theAssoc = anAssoc;
                                break search;
                            }
                        }
                    }
                    else {
                        break;
                    }
                }
            }
        }
        return theAssoc;
    }

    public Association getAssociationWithRole(String objectName, String role) {
        SearchableObject so = getSearchableObject(objectName);
        if (so == null) {
            throw new RuntimeException("No SearchableObject found for "
                    + objectName);
        }
        return getAssociationWithRole(so, role);
    }

    public Association getAssociationWithRole(SearchableObject so,
            String roleName) {
        if (so == null) {
            throw new IllegalArgumentException("SearchableObject is null");
        }
        if (roleName == null) {
            throw new IllegalArgumentException("roleName is null");
        }
        Association theAssoc = null;
        List assocs = so.getAssociations();
        for (Iterator i = assocs.iterator(); i.hasNext();) {
            Association anAssoc = (Association) i.next();
            if (roleName.equals(anAssoc.getRole())) {
                theAssoc = anAssoc;
                break;
            }
        }
        return theAssoc;
    }

    public PathItem getPathItemWithOrder(List pathItems, int order) {
        PathItem thePathItem = null;
        for (Iterator i = pathItems.iterator(); i.hasNext();) {
            PathItem aPathItem = (PathItem) i.next();
            if (order == aPathItem.getOrder()) {
                thePathItem = aPathItem;
                break;
            }
        }
        return thePathItem;
    }

    public boolean isOntological(String beanName) {
        SearchableObject so = getSearchableObject(beanName);
        if (so == null) {
            throw new RuntimeException("Couldn't find SearchableObject for "
                    + beanName);
        }
        return so.getOntological();
    }

    public String getBeanNameFromPath(String path) {
        String beanName = null;
        if (path != null) {
            if (path.indexOf(".") == -1) {
                beanName = getBeanName(path);
            }
            else {
                StringTokenizer st = new StringTokenizer(path, ".");
                SearchableObject root = getSearchableObject(st.nextToken());
                String role = st.nextToken();
                Association nextAssoc = getAssociationWithRole(root, role);
                if (nextAssoc == null) {
                    throw new RuntimeException("Assocation not found for "
                            + root.getClassname() + " and " + role);
                }
                while (st.hasMoreTokens()) {
                    role = st.nextToken();
                    Association prev = nextAssoc;
                    nextAssoc = getAssociationWithRole(prev.getClassname(),
                        role);
                    if (nextAssoc == null) {
                        throw new RuntimeException("Assocation not found for "
                                + prev.getClassname() + " and " + role);
                    }
                }
                beanName = getBeanName(nextAssoc.getClassname());
            }
        }
        return beanName;
    }

    public static List sortAssociations(List assocs) {
        List result = new ArrayList();
        SortedMap map = new TreeMap();
        for (Iterator i = assocs.iterator(); i.hasNext();) {
            Association a = (Association) i.next();
            map.put(a.getLabel(), a);
        }
        for (Iterator i = map.keySet().iterator(); i.hasNext();) {
            result.add(map.get(i.next()));
        }
        return result;
    }

    public static List sortAttributes(List atts) {
        List result = new ArrayList();
        SortedMap map = new TreeMap();
        for (Iterator i = atts.iterator(); i.hasNext();) {
            Attribute a = (Attribute) i.next();
            map.put(a.getLabel(), a);
        }
        for (Iterator i = map.keySet().iterator(); i.hasNext();) {
            result.add(map.get(i.next()));
        }
        return result;
    }

    public static List sortSearchableObjects(List sos) {
        List result = new ArrayList();
        SortedMap map = new TreeMap();
        for (Iterator i = sos.iterator(); i.hasNext();) {
            SearchableObject a = (SearchableObject) i.next();
            map.put(a.getLabel(), a);
        }
        for (Iterator i = map.keySet().iterator(); i.hasNext();) {
            result.add(map.get(i.next()));
        }
        return result;
    }
}
