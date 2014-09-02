/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.simplephysicsengine.objects
{
	
	import com.altoinu.flash.datamodels.Acceleration;
	import com.altoinu.flash.datamodels.Velocity;
	import com.altoinu.flash.simplephysicsengine.controllers.collision.SimplePhysicsObject3DHitArea;
	import com.altoinu.flash.simplephysicsengine.models.SimplePhysicsHitTestElements;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * Base interface to define properties and methods for any objects controlled by simple physics engine.
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface ISimplePhysicsObject3D extends IEventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  x
		//--------------------------------------
		
		function get x():Number;
		
		/**
		 * @private
		 */
		function set x(value:Number):void;
		
		//--------------------------------------
		//  y
		//--------------------------------------
		
		function get y():Number;
		
		/**
		 * @private
		 */
		function set y(value:Number):void;
		
		//--------------------------------------
		//  z
		//--------------------------------------
		
		function get z():Number;
		
		/**
		 * @private
		 */
		function set z(value:Number):void;
		
		//--------------------------------------
		//  rotationX
		//--------------------------------------
		
		function get rotationX():Number;
		
		/**
		 * @private
		 */
		function set rotationX(value:Number):void;
		
		//--------------------------------------
		//  rotationY
		//--------------------------------------
		
		function get rotationY():Number;
		
		/**
		 * @private
		 */
		function set rotationY(value:Number):void;
		
		//--------------------------------------
		//  rotationZ
		//--------------------------------------
		
		function get rotationZ():Number;
		
		/**
		 * @private
		 */
		function set rotationZ(value:Number):void;
		
		//----------------------------------
		//  enablePhysics
		//----------------------------------
		
		/**
		 * If set to false, then this object will be completely ignored by SimplePhysicsController
		 * and no physics will be applied (collision, move and accelerate).
		 * 
		 * @default true
		 */
		function get enablePhysics():Boolean;
		
		/**
		 * @private
		 */
		function set enablePhysics(value:Boolean):void;
		
		//----------------------------------
		//  enableExternalForce
		//----------------------------------
		
		/**
		 * If false, then this object's physics will not be affected by anything other than its own
		 * velocity and acceleration when SimplePhysicsController is applied.
		 * 
		 * <p>Collision is still detected, so if you want to have a stationary collidable object, set this
		 * property to false.</p>
		 * 
		 * <p>External forces
		 * <ul>
		 * 	<li>SimplePhysicsController.gravity</li>
		 * 	<li>(TODO: friction)</li>
		 * 	<li>(TODO: gravity/wind/magnetic force from other <code>ISimplePhysicsObject3D</code>)</li>
		 * </ul>
		 * </p>
		 * 
		 * <p>This property will have no effect if <code>enablePhysics == false</code>.</p>
		 * 
		 * @default true
		 */
		function get enableExternalForce():Boolean;
		
		/**
		 * @private
		 */
		function set enableExternalForce(value:Boolean):void;
		
		//----------------------------------
		//  enableCollision
		//----------------------------------
		
		/**
		 * If set to true, this <code>ISimplePhysicsObject3D</code> object becomes a "hit area," so any another
		 * <code>ISimplePhysicsObject3D</code>s that also have <code>enableCollision</code> property set to
		 * true will react to this object (such as dispatching <code>SimplePhysicsObject3DEvent.COLLIDED</code>
		 * event, and do collisions).
		 * 
		 * <p></p>
		 * 
		 * <p>This property will have no effect if <code>enablePhysics == false</code>.</p>
		 * 
		 * @default false
		 */
		function get enableCollision():Boolean;
		
		/**
		 * @private
		 */
		function set enableCollision(value:Boolean):void;
		
		//----------------------------------
		//  enableCollisionReaction
		//----------------------------------
		
		/**
		 * If set to false, dispatching of <code>SimplePhysicsObject3DEvent.COLLIDED</code> event from this
		 * <code>ISimplePhysicsObject3D</code> when this object collides into another
		 * <code>ISimplePhysicsObject3D</code> is disabled. This property may become necessary
		 * if you have two <code>ISimplePhysicsObject3D</code> with property <code>enablePhysics == true</code>,
		 * but only want one of them dispatching events.
		 * 
		 * <p>By default, this property is true, so <code>ISimplePhysicsObject3D</code> will react to collisions if
		 * <code>enableCollision == true</code> (ex. two <code>ISimplePhysicsObject3D</code> will both dispatch event
		 * <code>SimplePhysicsObject3DEvent.COLLIDED</code> when they collide to each other); however, sometimes you may
		 * not be concerned about the collision to itself but just as a "hit area" for other <code>ISimplePhysicsObject3D</code>s
		 * to collide against (ex. Huge brick wall that will never going to move but still have balls bounce off of it).
		 * Setting this to false tells <code>SimplePhysicsController</code> to not do logic to check on this object's collision against
		 * another which should help CPU usage. (So, for example, you would set huge brick wall to <code>enableCollision == true</code>,
		 * but <code>enableCollisionReaction == false</code> since it will be fixed to its position to serve as something for
		 * others to collide into but it does not do anything itself.)</p> 
		 * 
		 * <p>This property will have not effect if <code>enablePhysics == false</code> or
		 * <code>enableCollision == false</code>.</p>
		 * 
		 * @default true
		 */
		
		function get enableCollisionReaction():Boolean;
		
		function set enableCollisionReaction(value:Boolean):void;
		
		//----------------------------------
		//  mass
		//----------------------------------
		
		/**
		 * Mass of this object.
		 * 
		 * @default 1
		 */
		function get mass():Number;
		
		/**
		 * @private
		 */
		function set mass(value:Number):void;
		
		//----------------------------------
		//  velocity
		//----------------------------------
		
		/**
		 * Velocity (units/millisecond) the object is traveling at specified in vector format.
		 */
		function get velocity():Velocity;
		
		/**
		 * @private
		 */
		function set velocity(value:Velocity):void;
		
		//----------------------------------
		//  acceleration
		//----------------------------------
		
		/**
		 * Acceleration (units/millisecond ^ 2) applied to this object's velocity
		 * (ex. car accelerating) when SimplePhysicsController is applied.
		 */
		function get acceleration():Acceleration;
		
		/**
		 * @private
		 */
		function set acceleration(value:Acceleration):void;
		
		//----------------------------------
		//  hitRegion
		//----------------------------------
		
		/**
		 * Array of SimplePhysicsObject3DHitArea to define areas within <code>ISimplePhysicsObject3D</code> that are actually
		 * considered for <code>isColliding</code> method.  Think of this as a sphere filling up the body of an object.
		 * This way simple physics engine can calculate collision based on these sphere bodies instead of trying to figure
		 * out each individual colliding point in 3D space, which requires tremendous CPU power.  The more
		 * <code>SimplePhysicsObject3DHitArea</code> defined, the more precise the collision detection will be.
		 * 
		 * <p>If you set this property to empty Array [] or null, then <code>isColliding</code> method will always be false
		 * because there is no SimplePhysicsObject3DHitArea defined.</p>
		 * 
		 */
		function get hitRegion():Vector.<SimplePhysicsObject3DHitArea>;
		
		/**
		 * @private
		 */
		function set hitRegion(value:Vector.<SimplePhysicsObject3DHitArea>):void;
		
		//----------------------------------
		//  hitTestObjectAreas
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.models.SimplePhysicsHitTestElements#objHitAreas
		 */
		function get hitTestObjectAreas():Vector.<SimplePhysicsObject3DHitArea>;
		
		//----------------------------------
		//  hitTestObjectCollidedAreas
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.models.SimplePhysicsHitTestElements#collidedAreas
		 */
		function get hitTestObjectCollidedAreas():Vector.<SimplePhysicsObject3DHitArea>;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Checks to see if <code>ISimplePhysicsObject3D</code> hit any other <code>ISimplePhysicsObject3D</code>.
		 * (<code>ISimplePhysicsObject3D</code> version of hitTestObject method)
		 * 
		 * <p>To be considered as a hit, both <code>ISimplePhysicsObject3D</code> must have properties <code>enablePhysics</code> and
		 * <code>enableCollision</code> set to <code>true</code> and have at least one of the SimplePhysicsObject3DHitArea specified for
		 * <code>hitRegion</code> overlaps with each other.</p>
		 * 
		 * @param obj
		 * @param multiplier
		 * @return SimplePhysicsHitTestElements if there was a hit, null if not a hit.
		 * 
		 */
		function isColliding(obj:ISimplePhysicsObject3D, multiplier:Number = 1):SimplePhysicsHitTestElements
		
		/**
		 * Using current velocity and rotation velocity, repositions <code>ISimplePhysicsObject3D</code>.  This method updates
		 * <code>ISimplePhysicsObject3D</code>'s <code>x</code>, <code>y</code>, <code>z</code>, <code>rotationX</code>,
		 * <code>rotationY</code>, and <code>rotationZ</code> properties.
		 * 
		 * @param millisecondsElapsed Multiplies the velocity and rotation velocity when moving the object.
		 * @param acceleration Acceleration in units / millisecond ^ 2 applied while moving.  If this is specified,
		 * <code>velocity</code> property will also be updated.
		 */
		function move(millisecondsElapsed:int = 1, acceleration:Acceleration = null):void;
		
		/**
		 * Create a new object with exact same properties of this <code>ISimplePhysicsObject3D</code>.
		 * 
		 * @return 
		 * 
		 */
		function clonePosition():ISimplePhysicsObject3D;
		
		/**
		 * Copies properties from specified <code>ISimplePhysicsObject3D</code>.
		 * @param sourceObj
		 * 
		 */
		function copyProperties(sourceObj:ISimplePhysicsObject3D):void;
		
	}
	
}