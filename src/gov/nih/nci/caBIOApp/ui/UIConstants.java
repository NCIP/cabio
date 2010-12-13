package gov.nih.nci.caBIOApp.ui;

public interface UIConstants{

  public static final String pkg = "gov.nih.nci.caBIOApp.ui";
    

  public static final String NEXT_STEP_KEY = "nextStep";
  public static final String LAST_STEP_KEY = "lastStep";
  public static final String WORKFLOW_STATE_KEY = pkg + ".workflowState";
  //public static final String SEARCHABLE_OBJECTS_DESC_KEY = pkg + ".searchableObjectsDesc";
  //public static final String EDIT_CRITERIA_OUTPUT_KEY = pkg + ".editCriteriaOutput";
  //public static final String UPLOADED_DATA_MAPPING_KEY = pkg + ".uploadedDataMapping";
  //public static final String SELECTED_OBJECTS_KEY = pkg + ".selectedObjects";
  //public static final String PROPERTY_KEY = pkg + ".property";
  //public static final String SEARCH_CRITERIA_KEY = pkg + ".selectedCriteria";

  /*  A List of all uploaded spreadsheets available during the user's session.
   *  Scope: session
   */
  public static final String SPREADSHEETS_KEY = pkg + ".spreadsheets";

  /*  The one Spreadsheet on which the user will perform some action.
   *  Scope: session
   */
  public static final String SELECTED_SPREADSHEET_KEY = pkg + ".selectedSpreadsheet";

  /*  The SearchableObjectsDescription.
   *  Scope: application/ServletContext
   */
  public static final String SOD_KEY = pkg + ".sod.SearchableObjectsDescription";

  /*  A HashMap of classname - attribute name pairs. Represents all attributes
   *  selected by the user on which to perform some action.
   *  Scope: session
   */
  public static final String SELECTED_ATTRIBUTES = pkg + "selectedAttributes";

  public static final int FROM_OTHER_ACTION = 0;
  public static final int FROM_PARENT_ACTION = 1;
  public static final int FROM_THIS_ACTION = 2;
  public static final int FROM_CHILD_ACTION = 3;
  public static final int FROM_SUB_ACTION = 4;

}
