/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls
{
	
	import flash.events.Event;
	
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	
	/**
	 * TextArea with auto resize option.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AutoResizeTextArea extends TextArea
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AutoResizeTextArea()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  autoResize
		//----------------------------------
		
		// auto resize setting
		private var _autoResizable:Boolean = false;
		
		// getter
		[Bindable(event="changeAutoResize")]
		public function get autoResize():Boolean
		{
			return _autoResizable;
		}
		
		// setter
		/**
		 * @private
		 */
		public function set autoResize(b:Boolean):void
		{
			
			_autoResizable = b;
			// if the text field component is created
			// and is auto resizable
			// we call the resize method
			if (this.mx_internal::getTextField() != null && _autoResizable == true)
				resizeTextArea();
			
			// dispatch event to make the autoResize 
			// property bindable
			dispatchEvent(new Event("changeAutoResize"));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  text
		//----------------------------------
		
		// setter override
		/**
		 * @private
		 */
		override public function set text(value:String):void
		{
			
			// calling super method 
			super.text = value;
			// if is auto resizable we call 
			// the resize method
			if (_autoResizable)
				resizeTextArea();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		// resize function for the text area
		private function resizeTextArea():void
		{
			
			// initial height value
			// if set to 0 scroll bars will 
			// appear to the resized text area 
			var totalHeight:uint = 10;
			// validating the object
			this.validateNow();
			// find the total number of text lines 
			// in the text area
			var noOfLines:int = this.mx_internal::getTextField().numLines;
			// iterating through all lines of 
			// text in the text area
			for (var i:int = 0; i < noOfLines; i++) 
			{
				
				// getting the height of one text line
				var textLineHeight:int = 
					this.mx_internal::getTextField().getLineMetrics(i).height;
				// adding the height to the total height
				totalHeight += textLineHeight;
				
			}
			
			// setting the new calculated height
			this.height = totalHeight;
			
		}
		
	}
	
}