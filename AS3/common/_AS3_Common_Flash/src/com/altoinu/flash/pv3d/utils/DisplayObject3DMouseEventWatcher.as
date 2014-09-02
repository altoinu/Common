/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.utils
{
	
	import com.altoinu.flash.pv3d.events.DisplayObject3DMouseEvent;
	
	import flash.events.EventDispatcher;
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;
	
	//----------------------------------
	//  events
	//----------------------------------
	
	/**
	 * Event dispatched when DisplayObject3DMouseEventWatcher catches something.
	 * 
	 * @eventType com.altoinu.flash.pv3d.events.DisplayObject3DMouseEvent.MOUSEACTION
	 */
	[Event(name="mouseAction", type="com.altoinu.flash.pv3d.events.DisplayObject3DMouseEvent")]

	/**
	 * Class to capture all mouse movements by InteractiveScene3DEvent on specified target in Papervision 3D scene so
	 * they can all be handled by one single event type "mouseAction."
	 *
	 * @author Kaoru Kawashima
	 */
	public class DisplayObject3DMouseEventWatcher extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 *
		 * @param mouseWatchTarget Target object to watch mouse events on.
		 */
		public function DisplayObject3DMouseEventWatcher(mouseWatchTarget:DisplayObject3D)
		{
			
			super();
			
			if (mouseWatchTarget != null)
			{
				
				_mouseWatchTarget = mouseWatchTarget;
				
				if (enabled)
					addEvents();
				
			}
			else
			{
				
				throw new Error("mouseWatchTarget cannot be null.");
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  mouseWatchTarget
		//----------------------------------
		
		private var _mouseWatchTarget:DisplayObject3D;
		
		/**
		 * Target object to watch mouse events on.
		 */
		public function get mouseWatchTarget():DisplayObject3D
		{
			
			return _mouseWatchTarget;
			
		}
		
		//----------------------------------
		//  enabled
		//----------------------------------
		
		/**
		 * @private
		 */
		private var _enabled:Boolean = true;
		
		/**
		 * Enables/disables user input.
		 * 
		 * @default true
		 */
		public function get enabled():Boolean
		{
			
			return _enabled;
			
		}
		
		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void
		{
			
			if (_enabled != value)
			{
				
				_enabled = value;
				
				if (value)
					addEvents();
				else
					removeEvents();
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function addEvents():void
		{
			
			// Watch all InteractiveScene3DEvent
			mouseWatchTarget.addEventListener(InteractiveScene3DEvent.OBJECT_ADDED, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.addEventListener(InteractiveScene3DEvent.OBJECT_MOVE, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE_OUTSIDE, onInteractiveScene3DEventDispatched);
			
		}
		
		private function removeEvents():void
		{
			
			// Stop watching
			mouseWatchTarget.removeEventListener(InteractiveScene3DEvent.OBJECT_ADDED, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.removeEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.removeEventListener(InteractiveScene3DEvent.OBJECT_MOVE, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.removeEventListener(InteractiveScene3DEvent.OBJECT_OVER, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.removeEventListener(InteractiveScene3DEvent.OBJECT_PRESS, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.removeEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, onInteractiveScene3DEventDispatched);
			mouseWatchTarget.removeEventListener(InteractiveScene3DEvent.OBJECT_RELEASE_OUTSIDE, onInteractiveScene3DEventDispatched);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event handler dispatched when InteractiveScene3DEvent is caught.
		 *
		 * @param event
		 */
		private function onInteractiveScene3DEventDispatched(event:InteractiveScene3DEvent):void
		{
			
			dispatchEvent(new DisplayObject3DMouseEvent(event));
			
		}
		
	}
	
}