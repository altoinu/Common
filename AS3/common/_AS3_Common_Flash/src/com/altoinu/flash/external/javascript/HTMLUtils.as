/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.external.javascript
{
	
	import com.altoinu.flash.global.TraceControl;
	
	import flash.external.ExternalInterface;
	
	/**
	 * Utility functions to deal with HTML element &lt;div&gt;.
	 * 
	 * Note: Methods in this class uses flash.external.ExternalInterface to access JavaScript methods.
	 * Make sure AllowScriptAccess is set to allow calling JavaScript from Flash.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class HTMLUtils
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const DEBUG_TRACER:TraceControl = new TraceControl("===Cookie: ");
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates new HTML DIV component on the current HTML page.
		 * 
		 * @param newNodeID ID of the new DIV element to be created.
		 * @param divcontent String containing HTML to be placed into the new DIV element.
		 * @param nodeParentID ID of the parent DIV container to place new DIV element into.
		 * If this is undefined or if specified HTML element is not a DIV, then the new DIV
		 * element is placed on document.body.
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * 
		 * @return 
		 * 
		 */
		public static function writeDiv(newNodeID:String,
										divcontent:String,
										nodeParentID:String = "",
										x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):Object
		{
			
			if (!ExternalInterface.available)
			{
				
				DEBUG_TRACER.tracetext("Error HTMLElementDiv.writeDiv - ExternalInterface not available");
				return null;
				
			}
			
			var writeDiv_JS:String = "function (divcontent, nodeParentID)" + 
									 "{" + 
									 "	" + 
									 "	var myElement;" + 
									 "	var node;" + 
									 "	" + 
									 "	if (document.getElementById)" + 
									 "	{" + 
									 "		" + 
									 "		if ((nodeParentID != null) && (nodeParentID != ''))" + 
									 "			node = document.getElementById(nodeParentID);" + 
									 "		" + 
									 "		if ((node == undefined) || (node == null) || (node.tagName != 'DIV'))" + 
									 "			node = document.body;" + 
									 "		" + 
									 "		if (node)" + 
									 "		{" + 
									 "			" + 
									 "			var offsetX = (node != document.body) ? node.offsetLeft : 0;" + 
									 "			var offsetY = (node != document.body) ? node.offsetTop : 0;" + 
									 "			myElement = document.createElement('DIV');" + 
									 "			myElement.setAttribute('style', 'position: absolute; left: '+("+x+"+offsetX)+'px; top: '+("+y+"+offsetY)+'px; width: "+width+"px; height: "+height+"px;');" + 
									 "			myElement.setAttribute('id', '"+newNodeID+"');" + 
									 "			myElement.innerHTML = divcontent;" + 
									 "			" + 
									 "			node.appendChild(myElement);" + 
									 "			" + 
									 "		}" + 
									 "		" + 
									 "	}" + 
									 "	" + 
									 "	return '"+newNodeID+"';" + 
									 "	" + 
									 "}";
			
			return ExternalInterface.call(writeDiv_JS, divcontent, nodeParentID);
			
		}
		
		/**
		 * Removes specified DIV element on the HTML page.
		 * @param targetNodeID
		 * 
		 */
		public static function clearDiv(targetNodeID:String):void
		{
			
			if (!ExternalInterface.available)
			{
				
				DEBUG_TRACER.tracetext("Error HTMLElementDiv.clearDiv - ExternalInterface not available");
				return;
				
			}
			
			var clearDiv_JS:String = "function ()" + 
									 "{" + 
									 "	" + 
									 "	var node;" + 
									 "	var element;" + 
									 "	" + 
									 "	if (document.getElementById)" + 
									 "	{" + 
									 "		" + 
									 "		element = document.getElementById(\""+targetNodeID+"\");" + 
									 "		" + 
									 "		element.parentNode.removeChild(element);" + 
									 "		" + 
									 "	}" + 
									 "	" + 
									 "}";
			
			ExternalInterface.call(clearDiv_JS);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Contructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function HTMLUtils()
		{
			
			throw("You do not create an instance of HTMLDiv class.  Just call its static functions.");
			
		}
		
		
	}
	
}