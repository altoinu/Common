/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.twitter.events
{
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The TweetButtonEvent class represents events associated with TweetButtonArea.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class TweetButtonEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The TweetButtonEvent.TWEET_PARAMETER_CHANGE constant defines the value of the type property of an
		 * <code>tweetParameterChange</code> event object.
		 */
		public static const TWEET_PARAMETER_CHANGE:String = "tweetParameterChange";
		
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
		public function TweetButtonEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
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
		override public function clone():Event
		{
			
			return new TweetButtonEvent(type, bubbles, cancelable);
			
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