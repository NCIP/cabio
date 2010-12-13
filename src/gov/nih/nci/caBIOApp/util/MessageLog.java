/* BEGIN LIMS LICENSE

Copyright (c) 2001 Science Applications International Corporation (SAIC)
    with contributions from
    the National Cancer Institute Center for Bioinformatics

    This file is part of NCI LIMS (LIMS).

    LIMS is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    LIMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with LIMS; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

END LIMS LICENSE */

/* This class has been borrowed from the nci.lims.util package.
 * Much thanks to JP.
 */

package gov.nih.nci.caBIOApp.util;

import java.io.*;
import java.lang.*;
import java.util.*;

/**
 * This class performs common message logging. Log messages can take on
 * one of three varieties: informational, warning, or error. Each type of
 * log message is sent to its own destination; different types of messages
 * can share the same destination. In addition, logging can be turned on
 * and off for the individual logging types.
 *
 * @author	J.P. Zurilgen
 * @version	$Revision: 1.2 $
 */
public class MessageLog
{
   private static boolean errorOn = true, 
                          infoOn = true,
                          warningOn = true;
   private static PrintStream errorStream = System.err,
	                      infoStream = System.out,
	                      warningStream = System.out;

   private static boolean verboseOn = true;

  /*
   * Prints the strack trace to the error stream. If error logging is turned
   * off, no message is printed.
   *
   * @param	ex	Exception
   * @see	#setErrorStream(java.io.PrintStream)
   * @see       #printStackTrace(java.lang.Exception)
   */
   public static synchronized void printStackTrace( Exception ex )
   {
      if( errorOn )
      {
          ex.printStackTrace(errorStream);
          errorStream.flush( );
      }
   }

  /*
   * Prints an error message to the error stream. If error logging is turned
   * off, no message is printed.
   *
   * @param	s	message to print
   * @see	#setErrorStream(java.io.PrintStream)
   */
   public static synchronized void printError( String s )
   {
      if( errorOn )
      {
          errorStream.print ("[" + (new Date()).toString() + "] ");
	  errorStream.println( s );
          errorStream.flush( );
      }
   }

   public static synchronized void printInfo( String s, boolean verbose )
   {
       if ( infoOn && verbose )
       {
          infoStream.print ("[" + (new Date()).toString() + "] ");
	  infoStream.println( s );
          infoStream.flush( );
       }
   }

  /*
   * Prints an informational message to the informational stream. If
   * informational logging is turned off, no message is printed.
   *
   * @param	s	message to print
   * @see	#setInfoStream(java.io.PrintStream)
   */
   public static synchronized void printInfo( String s )
   {
       //printinfo( s, verboseOn );
       if ( infoOn && verboseOn )
       {
          infoStream.print ("[" + (new Date()).toString() + "] ");
	  infoStream.println( s );
          infoStream.flush( );
       }
   }

   public static synchronized void setVerboseOn( boolean on )
   {
       verboseOn = on;
   }

  /*
   * Prints a warning message to the warning stream. If warning logging is
   * turned off, no message is printed.
   *
   * @param	s	message to print
   * @see	#setWarningStream(java.io.PrintStream)
   */
   public static synchronized void printWarning( String s )
   {
      if( warningOn )
      {
          warningStream.print ("[" + (new Date()).toString() + "] ");
	  warningStream.println( s );
          warningStream.flush( );
      }
   }

  /**
   * Turns error logging on or off.
   *
   * @param	on	true to turn on, false to turn off
   */
   public static synchronized void setErrorOn( boolean on )
   {
     errorOn = on;
   }

  /**
   * Turns informational logging on or off.
   *
   * @param	on	true to turn on, false to turn off
   */
   public static synchronized void setInfoOn( boolean on )
   {
     infoOn = on;
   }

  /**
   * Turns warning logging on or off.
   *
   * @param	on	true to turn on, false to turn off
   */
   public static synchronized void setWarningOn( boolean on )
   {
     warningOn = on;
   }

  /**
   * Sets the stream where error log messages go.
   *
   * @param	ps	previously opened stream for messages
   */
   public static synchronized void setErrorStream( PrintStream ps )
   {
       errorStream = ps;
   }

  /**
   * Sets the stream where informational log messages go.
   *
   * @param	ps	previously opened stream for messages
   */
   public static synchronized void setInfoStream( PrintStream ps )
   {
       infoStream = ps;
   }

  /**
   * Sets the stream where warning log messages go.
   *
   * @param	ps	previously opened stream for messages
   */
   public static synchronized void setWarningStream( PrintStream ps )
   {
       warningStream = ps;
   }

  /**
   * Performs a total configuration of message logging. If both file and
   * display printing are requested, only display printing is performed.
   * If one type of logging is specified as both on and off, it is set to off.
   *
   * @param	filePrint	type of file logging: info, warning, error, or all
   * @param	file	for file logging, name of file to log to
   * @param	displayPrint	type of display logging: info, warning, error, or all
   * @param	toggleOn	types of logs to turn on: info, warning, error, or all
   * @param	toggleOff	types of logs to turn off: info, warning, error, or all
   */
       public static synchronized void setPrintArea( String filePrint, String file, String displayPrint, 
						     String toggleOn, String toggleOff )
    {
	if( filePrint != null ){
	    try
		{
PrintStream ps = new PrintStream( new FileOutputStream( file ), true );
		if( filePrint == "all" )
		{
		    setErrorStream( ps );
		    setInfoStream( ps );
		    setWarningStream( ps );
		}
		else if( filePrint == "error" )
		    setErrorStream( ps );
		else if( filePrint == "info" )
		    setInfoStream( ps );
		else if( filePrint == "warning" )
		    setWarningStream( ps );
	    }

	    catch( FileNotFoundException f )
	    {
		printError( "File not found!" );
	    }
	}

	if( displayPrint != null )
	{
	    if( displayPrint == "all" )
	    {
		setErrorStream( System.err );
		setInfoStream( System.out );
		setWarningStream( System.out );
	    }
	    else if( displayPrint == "error" )
	        setErrorStream( System.err );
	    else if( displayPrint == "info" )
		setInfoStream( System.out );
	    else if( displayPrint == "warning" )
		setWarningStream( System.out );
	}

	if( toggleOn != null )
	{
	    if( toggleOn == "all" )
	    {
		setErrorOn( true );
		setInfoOn( true );
		setWarningOn( true );
	    }

	    else if( toggleOn == "error" )
		setErrorOn( true );

	    else if( toggleOn == "info" )
		setInfoOn( true );

	    else if( toggleOn == "warning" )
		setWarningOn( true );
	}

	if( toggleOff != null )
	{
	    if( toggleOff == "all" )
	    {
		setErrorOn( false );
		setInfoOn( false );
		setWarningOn( false );
	    }

	    else if( toggleOff == "error" )
		setErrorOn( false );

	    else if( toggleOff == "info" )
		setInfoOn( false );

	    else if( toggleOff == "warning" )
		setWarningOn( false );
	}
     }

    public static PrintStream getErrorStream(){ return errorStream; }
    public static PrintStream getInfoStream(){ return infoStream; }
    public static PrintStream getWarningStream(){ return warningStream; }

}



