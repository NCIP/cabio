package gov.nih.nci.maservice.errors;

import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.iso21090.St;
import gov.nih.nci.iso21090.Cd;


public class MAException extends ApplicationException {
	private Cd code;
	private St message;
	private Cd severity;
	private Cd type;
	
	public  MAException()
	{
		super();
	}
	
	public  MAException(Cd code, Cd severity, Cd type, Throwable cause)
	{
		this(cause);
		this.code = code;
		this.severity = severity;
		this.type = type;
	}

	public  MAException(Throwable cause)
	{		
	    super(cause);
	    this.message.setValue(cause.getMessage());
	}
	
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
