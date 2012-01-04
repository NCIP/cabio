package gov.nih.nci.caBIOApp.sod;

import gov.nih.nci.caBIOApp.util.ConfigurationException;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.InputStream;

import javax.xml.bind.Dispatcher;

public class SODFactoryImpl implements SODFactory {

    private static SearchableObjectsDescriptionImpl description = null;

    public SearchableObjectsDescription getSOD() throws ConfigurationException {
        if (description == null) {
            unmarshalDescription();
        }
        return description;
    }

    private void unmarshalDescription() throws ConfigurationException {
        String filename = System.getProperty("gov.nih.nci.caBIO.ui.sod.filename");
        if (filename == null) filename = "searchable-objects-description.xml";
        ClassLoader cl = this.getClass().getClassLoader();
        InputStream in = cl.getResourceAsStream(filename);

        try {
            Dispatcher d = SearchableObjectsDescriptionImpl.newDispatcher();
            d.register(SearchableObjectsDescriptionImpl.class,
                SearchableObjectsDescriptionImplImpl.class);
            d.register(SearchableObjectImpl.class,
                SearchableObjectImplImpl.class);
            description = (SearchableObjectsDescriptionImpl) d.unmarshal(in);
        }
        catch (Exception ex) {
            throw new ConfigurationException("Error unmarshalling "
                    + "SearchableObjectsDescription", ex);
        }
        finally {
            if (in != null) {
                try {
                    in.close();
                }
                catch (Exception ex) {
                    MessageLog.printStackTrace(ex);
                }
            }
        }
    }

}
