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
	 * The BannerSWFLoaderEvent class represents events associated with BannerSWFLoader.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class BannerSWFLoaderEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The BannerSWFLoaderEvent.BANNERANIMATIONCOMPLETE constant defines the value of the type property of
		 * an bannerAnimationComplete event object.
		 */
		public static const BANNERANIMATIONCOMPLETE:String = "bannerAnimationComplete";
		
		/**
		 * The BannerSWFLoaderEvent.BANNEREVENTDISPATCH constant defines the value of the type property of
		 * an bannerEventDispatch event object.
		 */
		public static const BANNEREVENTDISPATCH:String = "bannerEventDispatch";
		
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
		 * @param bannerEventType Banner event type dispatched from banner .swf loaded into BannerSWFLoader.
		 * @param parameter Optional parameter to be passed.
		 * 
		 */
		public function BannerSWFLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, bannerEventType:String = null, parameter:String=null)
		{
			
			super(type, bubbles, cancelable);
			
			_bannerEventType = bannerEventType;
			_parameter = parameter;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _bannerEventType:String = null;
		
		/**
		 * Banner event type dispatched from banner .swf loaded into BannerSWFLoader.
		 */
		public function get bannerEventType():String
		{
			
			return _bannerEventType;
			
		}
		
		private var _parameter:String = null;
		
		/**
		 * Optional parameter to be passed.
		 */
		public function get parameter():String
		{
			
			return _parameter;
			
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
			
			return "[BannerSWFLoaderEvent type=\""+type+"\" bubbles="+bubbles+" cancelable="+cancelable+" eventPhase="+eventPhase+" bannerEventType="+_bannerEventType+" parameter="+_parameter+"]"
			
		}
		
	}
	
}