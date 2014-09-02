/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.events
{
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class VideoPlayerMetaDataEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The VideoPlayerMetaDataEvent.METADATA_RECEIVED constant defines the value of the type property of an
		 * <code>metadataReceived</code> event object.
		 */
		public static const METADATA_RECEIVED: String = "metadataReceived";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function VideoPlayerMetaDataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
													  info:Object = null, vp:uint = 0)
		{
			
			super(type, bubbles, cancelable);
			
			this.info = info;
			this.vp = vp;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var info:Object;
		public var vp:uint;
		
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
			
			return new VideoPlayerMetaDataEvent(type, bubbles, cancelable, info, vp);
			
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