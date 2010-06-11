package gov.nih.nci.maservice.errors;

import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.iso21090.St;
import gov.nih.nci.iso21090.Cd;


public class MAException extends ApplicationException {
	private Cd code;
	private St message;
	private Cd severity;
	private Cd type;
	public Cd getCode() {
		return code;
	}
	public void setCode(Cd code) {
		this.code = code;
	}
	public String getMessage() {
		return message.getValue();
	}
	public void setMessage(St message) {
		this.message = message;
	}
	public Cd getSeverity() {
		return severity;
	}
	public void setSeverity(Cd severity) {
		this.severity = severity;
	}
	public Cd getType() {
		return type;
	}
	public void setType(Cd type) {
		this.type = type;
	}
}
