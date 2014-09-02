/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.events
{
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The PageSelectorEvent class represents events associated with PageSelector.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class PageSelectorEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The PageSelectorEvent.PAGE_SELECTED constant defines the value of the type property of
		 * an pageSelected event object.
		 */
		public static const PAGE_SELECTED:String = "pageSelected";
		
		/**
		 * The PageSelectorEvent.PAGE_SELECTED_CLICK constant defines the value of the type property of
		 * an pageSelectedClick event object.
		 */
		public static const PAGE_SELECTED_CLICK:String = "pageSelectedClick";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param type The event type; indicates the action that caused the event.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
		 * @param previousPageNumber Page number previously selected.
		 * @param newPageNumber Page number selected now.
		 */
		public function PageSelectorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, previousPageNumber:int = -1, newPageNumber:int = -1)
		{
			
			super(type, bubbles, cancelable);
			
			_previousPageNumber = previousPageNumber;
			_newPageNumber = newPageNumber;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  previousPageNumber
		//----------------------------------
		
		private var _previousPageNumber:int = -1;
		
		/**
		 * Previously selected page number.
		 */
		public function get previousPageNumber():int
		{
			
			return _previousPageNumber;
			
		}
		
		//----------------------------------
		//  newPageNumber
		//----------------------------------
		
		private var _newPageNumber:int = -1;
		
		/**
		 * Page number selected now.
		 */
		public function get newPageNumber():int
		{
			
			return _newPageNumber;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			
			return new PageSelectorEvent(type, bubbles, cancelable, previousPageNumber, newPageNumber);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			var eventClassName:String = getQualifiedClassName(this);
			return "[" + eventClassName.substring(eventClassName.lastIndexOf("::") + 2) + " type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
			
		}
		
	}
	
}