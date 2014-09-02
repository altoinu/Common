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
	 * The PV3DFlexEvent class represents events associated Papervision 3D in Flex.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class PV3DFlexEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The PV3DFlexEvent.BASICVIEW_CREATED constant defines the value of the type property of an
		 * <code>basicviewCreated</code> event object.
		 */
		public static const BASICVIEW_CREATED:String = "basicviewCreated";
		
		/**
		 * The PV3DFlexEvent.AUTO_SCALE_TO_STAGE_CHANGE constant defines the value of the type property of an
		 * <code>autoScaleToStageChange</code> event object.
		 */
		public static const AUTO_SCALE_TO_STAGE_CHANGE:String = "autoScaleToStageChange";
		
		/**
		 * The PV3DFlexEvent.INTERACTIVE_CHANGE constant defines the value of the type property of an
		 * <code>interactiveChange</code> event object.
		 */
		public static const INTERACTIVE_CHANGE:String = "interactiveChange";
		
		/**
		 * The PV3DFlexEvent.RENDER_STATE_CHANGE constant defines the value of the type property of an
		 * <code>renderStateChange</code> event object.
		 */
		public static const RENDER_STATE_CHANGE:String = "renderStateChange";
		
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
		 */
		public function PV3DFlexEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
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
			
			return "[PV3DFlexEvent type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" eventPhase="+eventPhase+"]"
			
		}
		
	}
	
}