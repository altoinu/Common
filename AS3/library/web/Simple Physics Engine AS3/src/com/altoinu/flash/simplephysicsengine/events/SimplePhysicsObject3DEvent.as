/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.simplephysicsengine.events
{
	
	import com.altoinu.flash.datamodels.Acceleration;
	import com.altoinu.flash.datamodels.Velocity;
	import com.altoinu.flash.events.PhysicsEvent;
	import com.altoinu.flash.simplephysicsengine.controllers.collision.SimplePhysicsObject3DHitArea;
	import com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D;
	
	import flash.events.Event;
	
	/**
	 * The SimplePhysicsObject3DEvent class represents events associated with ISimplePhysicsObject3D.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class SimplePhysicsObject3DEvent extends PhysicsEvent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The SimplePhysicsObject3DEvent.MOVED constant defines the value of the type property of an
		 * <code>moved</code> event object.
		 */
		public static const MOVED:String = "moved";
		
		/**
		 * The SimplePhysicsObject3DEvent.COLLIDED constant defines the value of the type property of an
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
		 * @param oldVelocity Velocity of the ISimplePhysicsObject3D before the event.
		 * @param newVelocity Velocity of the ISimplePhysicsObject3D after the event.
		 * @param acceleration Acceleration object that may have caused velocity change.
		 * @param collidedObject Object target has collided into, if event type is "collided."
		 * @param currentTargetHitAreas Array of SimplePhysicsObject3DHitAreas involved in this event.
		 * @param collidedObjectHitAreas Array of SimplePhysicsObject3DHitAreas of collidedObject involved in this event.
		 * 
		 */
		public function SimplePhysicsObject3DEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
												   oldVelocity:Velocity = null,
												   newVelocity:Velocity = null,
												   acceleration:Acceleration = null,
												   collidedObject:ISimplePhysicsObject3D = null,
												   currentTargetHitAreas:Vector.<SimplePhysicsObject3DHitArea> = null,
												   collidedObjectHitAreas:Vector.<SimplePhysicsObject3DHitArea> = null)
		{
			
			super(type, bubbles, cancelable, oldVelocity, newVelocity, acceleration);
			
			_collidedObject = collidedObject;
			_currentTargetHitAreas = currentTargetHitAreas;
			_collidedObjectHitAreas = collidedObjectHitAreas;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  oldVelocity
		//--------------------------------------
		
		/**
		 * Velocity of the ISimplePhysicsObject3D before the event.  This will be 0 if
		 * the target ISimplePhysicsObject3D has enablePhysics property set to false.
		 */
		override public function get oldVelocity():Velocity
		{
			
			return super.oldVelocity;
			
		}
		
		//--------------------------------------
		//  acceleration
		//--------------------------------------
		
		/**
		 * Acceleration (if any) that caused velocity to change.  This will be 0 if
		 * the target ISimplePhysicsObject3D has enablePhysics property set to false.
		 */
		override public function get acceleration():Acceleration
		{
			
			return super.acceleration;
			
		}
		
		//--------------------------------------
		//  collidedObject
		//--------------------------------------
		
		private var _collidedObject:ISimplePhysicsObject3D;
		
		/**
		 * Object target has collided into, if event type is "collided."
		 */
		public function get collidedObject():ISimplePhysicsObject3D
		{
			
			return _collidedObject;
			
		}
		
		//--------------------------------------
		//  currentTargetHitAreas
		//--------------------------------------
		
		private var _currentTargetHitAreas:Vector.<SimplePhysicsObject3DHitArea>;
		
		/**
		 * Array of SimplePhysicsObject3DHitArea involved in this event.
		 */
		public function get currentTargetHitAreas():Vector.<SimplePhysicsObject3DHitArea>
		{
			
			if (_currentTargetHitAreas != null)
				return _currentTargetHitAreas;
			else
				return new Vector.<SimplePhysicsObject3DHitArea>();
			
		}
		
		//--------------------------------------
		//  collidedObjectHitAreas
		//--------------------------------------
		
		private var _collidedObjectHitAreas:Vector.<SimplePhysicsObject3DHitArea>;
		
		/**
		 * Array of ISimplePhysicsObject3DHitArea of collidedObject involved in this event.
		 */
		public function get collidedObjectHitAreas():Vector.<SimplePhysicsObject3DHitArea>
		{
			
			if (_collidedObjectHitAreas != null)
				return _collidedObjectHitAreas;
			else
				return new Vector.<SimplePhysicsObject3DHitArea>();
			
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
			
			return new SimplePhysicsObject3DEvent(type, bubbles, cancelable,
												  oldVelocity.clone() as Velocity,
												  newVelocity.clone() as Velocity,
												  acceleration.clone() as Acceleration,
												  collidedObject,
												  currentTargetHitAreas.concat(),
												  collidedObjectHitAreas.concat());
			
		}
		
		override public function toString():String
		{
			
			return "[SimplePhysicsObject3DEvent type=\""+type+"\" cancelable=\""+cancelable+"\" eventPhase=\""+eventPhase+"\"]";
			
		}
		
	}
	
}