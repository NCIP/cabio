package gov.nih.nci.maservice.errors;

import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.iso21090.St;

public class MAException extends ApplicationException {
	private St code;
	private St message;
	private St severity;
	private St type;
	
	public  MAException()
	{
		super();
	}

	public  MAException(St code, St message, St severity, St type)
	{
		super();
		this.code = code;
		this.message = message;
		this.severity = severity;
		this.type = type;		
	}
	
	public  MAException(St code, St severity, St type, Throwable cause)
	{
		this(cause);
		this.code = code;
		if ( this.message == null)
		{
			 this.message = new St();
		}
		this.message.setValue( cause.getMessage());
		this.severity = severity;
		this.type = type;
	}

	public  MAException(Throwable cause)
	{		
	    super(cause);
	}
	
	public St getCode() {
		return code;
	}
	public void setCode(St code) {
		this.code = code;
	}
	public String getMessage() {
		return message.getValue();
	}
	public void setMessage(St message) {
		this.message = message;
	}
	
	public St getSeverity() {
		return severity;
	}
	public void setSeverity(St severity) {
		this.severity = severity;
	}
	public St getType() {
		return type;
	}
	public void setType(St type) {
		this.type = type;
	}
}
