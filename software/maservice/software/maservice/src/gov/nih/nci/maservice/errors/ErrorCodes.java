package gov.nih.nci.maservice.errors;

public enum ErrorCodes {
	MAE00000("Fetal", "Remote System Error"), 
	MAE10001("Error", "Gene doesn't exist"),
	MAE10002("Error", "Specified microarray is not supported"),
	MAE10003("Error", "Reporter not found"),
        MAE10004("Error", "Unknown search type, it must be 'current', 'previous' or 'all'");
			
	private ErrorCodes(String condition, String desc) {
		this.condition = condition;
		this.desc = desc;
	}

	private String condition = null;
	private String desc = null;

	public String getDesc() {
		return desc;
	}
	
	public String getCondition() {
		return condition;
	}
	
	
}