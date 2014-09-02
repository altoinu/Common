/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.events
{
	
	import flash.events.Event;
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	
	/**
	 * Event dispatched by the DisplayObject3DMouseEventWatcher which watches InteractiveScene3DEvent.
	 *
	 * @author Kaoru Kawashima
	 */
	public class DisplayObject3DMouseEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constant
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event type "mouseAction" dispatched when DisplayObject3DMouseEventWatcher catches something.
		 */
		public static const MOUSE_ACTION:String = "mouseAction";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param event
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function DisplayObject3DMouseEvent(event:InteractiveScene3DEvent, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			
			_interactiveEvent = event;
			
			super(MOUSE_ACTION, bubbles, cancelable);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  interactiveEvent
		//--------------------------------------
		
		private var _interactiveEvent:InteractiveScene3DEvent;
		
		/**
		 * Actual event dispatched by UserMouseControl.
		 */
		public function get interactiveEvent():InteractiveScene3DEvent
		{
			
			return _interactiveEvent;
			
		}
		
		//--------------------------------------
		//  eventDispatched
		//--------------------------------------
		
		[Deprecated(replacement="interactiveEvent")]
		public function get eventDispatched():InteractiveScene3DEvent
		{
			
			return interactiveEvent;
			
		}
		
		
	}
	
}