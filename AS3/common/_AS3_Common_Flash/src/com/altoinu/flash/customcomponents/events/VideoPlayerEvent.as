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
	
	public class VideoPlayerEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The VideoPlayerEvent.STATE_CHANGE constant defines the value of the type property of an
		 * <code>stateChange</code> event object.
		 */
		public static const STATE_CHANGE:String = "stateChange";
		
		/**
		 * The VideoPlayerEvent.PLAYING_STATE_ENTERED constant defines the value of the type property of an
		 * <code>playingStateEntered</code> event object.
		 */
		public static const PLAYING_STATE_ENTERED:String = "playingStateEntered";
		
		/**
		 * The VideoPlayerEvent.PAUSED_STATE_ENTERED constant defines the value of the type property of an
		 * <code>pausedStateEntered</code> event object.
		 */
		public static const PAUSED_STATE_ENTERED:String = "pausedStateEntered";
		
		/**
		 * The VideoPlayerEvent.STOPPED_STATE_ENTERED constant defines the value of the type property of an
		 * <code>stoppedStateEntered</code> event object.
		 */
		public static const STOPPED_STATE_ENTERED:String = "stoppedStateEntered";
		
		/**
		 * The VideoPlayerEvent.COMPLETE constant defines the value of the type property of an
		 * <code>complete</code> event object.
		 */
		public static const COMPLETE:String = "complete";
		
		/**
		 * The VideoPlayerEvent.REWIND constant defines the value of the type property of an
		 * <code>rewind</code> event object.
		 */
		public static const REWIND:String = "rewind";
		
		/**
		 * The VideoPlayerEvent.SEEKED constant defines the value of the type property of an
		 * <code>seeked</code> event object.
		 */
		public static const SEEKED:String = "seeked";
		
		/**
		 * The VideoPlayerEvent.LOADING_STATE_ENTERED constant defines the value of the type property of an
		 * <code>loadingStateEntered</code> event object.
		 */
		public static const LOADING_STATE_ENTERED: String = "loadingStateEntered"
		
		/**
		 * The VideoPlayerEvent.BUFFERING_STATE_ENTERED constant defines the value of the type property of an
		 * <code>bufferingStateEntered</code> event object.
		 */
		public static const BUFFERING_STATE_ENTERED: String = "bufferingStateEntered"
		
		/**
		 * The VideoPlayerEvent.CLOSE constant defines the value of the type property of an
		 * <code>close</code> event object.
		 */
		public static const CLOSE:String = "close";
		
		/**
		 * The VideoPlayerEvent.CONNECTION_ERROR constant defines the value of the type property of an
		 * <code>connectionError</code> event object.
		 */
		public static const CONNECTION_ERROR:String = "connectionError";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function VideoPlayerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
										 state:String = null, playheadTime:Number = NaN, vp:uint = 0)
		{
			
			super(type, bubbles, cancelable);
			
			this.state = state;
			this.playheadTime = playheadTime;
			this.vp = vp;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var state:String;
		public var playheadTime:Number;
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
			
			return new VideoPlayerEvent(type, bubbles, cancelable, state, playheadTime, vp);
			
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