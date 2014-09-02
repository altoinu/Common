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
	
	/**
	 * The MediaControllerEvent class represents events associated with MediaController.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class MediaControllerEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The MediaControllerEvent.SOURCECHANGE constant defines the value of the type property of an sourceChange event object.
		 */
		public static const SOURCECHANGE:String = "sourceChange";
		
		/**
		 * The MediaControllerEvent.STATECHANGE constant defines the value of the type property of an stateChange event object.
		 */
		public static const STATECHANGE:String = "stateChange";
		
		/**
		 * The MediaControllerEvent.MEDIALENGTHUPDATE constant defines the value of the type property of an mediaLengthUpdate event object.
		 */
		public static const MEDIALENGTHUPDATE:String = "mediaLengthUpdate";
		
		/**
		 * The MediaControllerEvent.MEDIAPOSITIONUPDATE constant defines the value of the type property of an mediaPositionUpdate event object.
		 */
		public static const MEDIAPOSITIONUPDATE:String = "mediaPositionUpdate";
		
		/**
		 * The MediaControllerEvent.VOLUMEUPDATE constant defines the value of the type property of an volumeUpdate event object.
		 */
		public static const VOLUMEUPDATE:String = "volumeUpdate";
		
		/**
		 * The MediaControllerEvent.MUTEUPDATE constant defines the value of the type property of an muteUpdate event object.
		 */
		public static const MUTEUPDATE:String = "muteUpdate";
		
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
		 * 
		 */
		public function MediaControllerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			
			super(type, bubbles, cancelable);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[MediaControllerEvent type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" eventPhase="+eventPhase+"]"
			
		}
		
	}
	
}