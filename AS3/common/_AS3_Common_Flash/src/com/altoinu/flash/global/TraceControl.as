/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.global
{
	
	/**
	 * TraceControl adds extra functionality to trace() so it can control how texts are traced out when running Flash debugger.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class TraceControl
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		private static var _instance:TraceControl;
		
		//--------------------------------------------------------------------------
		//
		//  Class static methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns reference to an instance of a singleton.
		 * @return
		 */		 
		public static function getInstance():TraceControl
		{
			
			if(!_instance)
				_instance = new TraceControl();
			
			return _instance;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function TraceControl(prefix:String = "", suffix:String = "")
		{
			
			this.prefix = prefix;
			this.suffix = suffix;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Enables trace().  Normally, if you turn off tracing when compiling .swf it would turn off
		 * all traces, but by simply creating an instance of TraceControl and setting enable property
		 * you can choose which trace statements are displayed.
		 */
		public var enabled:Boolean = true;
		
		/**
		 * String to be added in front of all trace statements made from method <code>TraceControl.trace</code>.
		 */
		public var prefix:String = "";
		
		/**
		 * String to be added at the end of all trace statements made from method <code>TraceControl.trace</code>.
		 */
		public var suffix:String = "";
		
		//--------------------------------------------------------------------------
		//
		//  Method
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Traces specified text out to Flash debugger.  This method will have no effect if <code>enabled</code>
		 * is set to false.
		 * @param traceText
		 * 
		 */
		public function tracetext(traceText:String):void
		{
			
			if (enabled)
				trace(prefix + traceText + suffix);
			
		}
		
		/**
		 * Iterates through all properties of object o and traces them in a tree
		 * @param o The object to trace.
		 * @param level The level in the tree. Default is 0. Usually you should leave this at the default.
		 */
		public function traceAllProps(o:Object,level:int=0):void
		{
			if(!enabled)
				return;
				
			var spaces:String = "";
			for(var i:int=0;i<level-1;i++)
			{
				spaces += "    ";
			}
			if(level != 0)
				spaces += "+--- ";
			
			
			for(var prop:String in o)
			{
				trace(spaces + prop + ": " + o[prop]);
				traceAllProps(o[prop],level+1);
			}
		}
		
	}
	
}