/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.events
{
	
	import com.altoinu.flash.datamodels.Acceleration;
	import com.altoinu.flash.datamodels.Velocity;
	
	import flash.events.Event;
	
	/**
	 * The PhysicsEvent class represents events associated with physics.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class PhysicsEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The PhysicsEvent.ACCELERATED constant defines the value of the type property of an
		 * <code>accelerated</code> event object.
		 */
		public static const ACCELERATED:String = "accelerated";
		
		/**
		 * The PhysicsEvent.MOVED constant defines the value of the type property of an
		 * <code>moved</code> event object.
		 */
		public static const MOVED:String = "moved";
		
		/**
		 * The PhysicsEvent.COLLIDED constant defines the value of the type property of an
		 * <code>collided</code> event object.
		 */
		public static const COLLIDED:String = "collided";
		
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
		 * @param oldVelocity If event type is "accelerated," then this would hold old velocity values before update.
		 * @param newVelocity If event type is "accelerated," then this would hold new velocity values after update.
		 * @param acceleration Acceleration object that may have caused velocity change.
		 * 
		 */
		public function PhysicsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
									 oldVelocity:Velocity = null, newVelocity:Velocity = null,
									 acceleration:Acceleration = null)
		{
			
			super(type, bubbles, cancelable);
			
			_oldVelocity = oldVelocity;
			_newVelocity = newVelocity;
			_acceleration = acceleration;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  oldVelocity
		//--------------------------------------
		
		private var _oldVelocity:Velocity;
		
		/**
		 * Old velocity.
		 */
		public function get oldVelocity():Velocity
		{
			
			return _oldVelocity;
			
		}
		
		//--------------------------------------
		//  newVelocity
		//--------------------------------------
		
		private var _newVelocity:Velocity;
		
		/**
		 * New velocity.
		 */
		public function get newVelocity():Velocity
		{
			
			return _newVelocity;
			
		}
		
		//--------------------------------------
		//  acceleration
		//--------------------------------------
		
		private var _acceleration:Acceleration;
		
		/**
		 * Acceleration object that may have caused velocity change.
		 */
		public function get acceleration():Acceleration
		{
			
			return _acceleration;
			
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
			
			return new PhysicsEvent(type, bubbles, cancelable, oldVelocity, newVelocity, acceleration);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[PhysicsEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
			
		}
		
	}
	
}