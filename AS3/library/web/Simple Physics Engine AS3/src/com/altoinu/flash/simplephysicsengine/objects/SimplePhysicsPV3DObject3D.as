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
	import com.altoinu.flash.events.PhysicsEvent;
	import com.altoinu.flash.pv3d.utils.DisplayObject3DMath;
	import com.altoinu.flash.simplephysicsengine.controllers.collision.SimplePhysicsObject3DHitArea;
	import com.altoinu.flash.simplephysicsengine.events.SimplePhysicsObject3DEvent;
	import com.altoinu.flash.simplephysicsengine.models.SimplePhysicsHitTestElements;
	
	import org.papervision3d.core.geom.Vertices3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	
	/**
	 * Event dispatched when any of the x, y, or z velocity value changes (when object is accelerated).
	 * 
	 * @eventType com.altoinu.flash.events.PhysicsEvent.ACCELERATED
	 */
	[Event(name="accelerated", type="com.altoinu.flash.events.PhysicsEvent")]
	
	/**
	 * Event dispatched when SimplePhysicsPV3DObject3D moved by SimplePhysicsController.
	 * 
	 * @eventType com.altoinu.flash.simplephysicsengine.events.SimplePhysicsObject3DEvent.MOVED
	 */
	[Event(name="moved", type="com.altoinu.flash.simplephysicsengine.events.SimplePhysicsObject3DEvent")]
	
	/**
	 * Event dispatched when SimplePhysicsPV3DObject3D collides into another object after SimplePhysicsController
	 * is applied.
	 * 
	 * @eventType com.altoinu.flash.simplephysicsengine.events.SimplePhysicsObject3DEvent.COLLIDED
	 */
	[Event(name="collided", type="com.altoinu.flash.simplephysicsengine.events.SimplePhysicsObject3DEvent")]
	
	/**
	 * Papervision 3D Base class that represents object in simple physics engine .
	 * Any classes extending this can be affected by SimplePhysicsController.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class SimplePhysicsPV3DObject3D extends Vertices3D implements ISimplePhysicsObject3D
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param viewHitRegion
		 * @param vertices
		 * @param name
		 * 
		 */
		public function SimplePhysicsPV3DObject3D(viewHitRegion:Boolean = false, vertices:Array = null, name:String = null)
		{
			
			super(vertices, name);
			
			_viewHitRegion = viewHitRegion;
			
			// initialize velocity by calling setter
			velocity = _velocity;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _viewHitRegion:Boolean;
		private var _hitRegionDisplayObject3D:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  enablePhysics
		//----------------------------------
		
		private var _enablePhysics:Boolean = true;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#enablePhysics
		 */
		public function get enablePhysics():Boolean
		{
			
			return _enablePhysics;
			
		}
		
		/**
		 * @private
		 */
		public function set enablePhysics(value:Boolean):void
		{
			
			_enablePhysics = value;
			
		}
		
		//----------------------------------
		//  ignorePhysics
		//----------------------------------
		
		[Deprecated(replacement="enablePhysics")]
		/**
		 * @private
		 */
		public function get ignorePhysics():Boolean
		{
			
			return !enablePhysics;
			
		}
		
		[Deprecated(replacement="enablePhysics")]
		/**
		 * @private
		 */
		public function set ignorePhysics(value:Boolean):void
		{
			
			enablePhysics = !value;
			
		}
		
		//----------------------------------
		//  enableExternalForce
		//----------------------------------
		
		private var _enableExternalForce:Boolean = true;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#enableExternalForce
		 */
		public function get enableExternalForce():Boolean
		{
			
			return _enableExternalForce;
			
		}
		
		public function set enableExternalForce(value:Boolean):void
		{
			
			_enableExternalForce = value;
			
		}
		
		//----------------------------------
		//  ignoreExternalForce
		//----------------------------------
		
		[Deprecated(replacement="enableExternalForce")]
		/**
		 * @private
		 */
		public function get ignoreExternalForce():Boolean
		{
			
			return !enableExternalForce;
			
		}
		
		[Deprecated(replacement="enableExternalForce")]
		/**
		 * @private
		 */
		public function set ignoreExternalForce(value:Boolean):void
		{
			
			enableExternalForce = !value;
			
		}
		
		//----------------------------------
		//  enableCollision
		//----------------------------------
		
		private var _enableCollision:Boolean = false;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#enableCollision
		 */
		public function get enableCollision():Boolean
		{
			
			return _enableCollision;
			
		}
		
		/**
		 * @private
		 */
		public function set enableCollision(value:Boolean):void
		{
			
			_enableCollision = value;
			
		}
		
		//----------------------------------
		//  collidable
		//----------------------------------
		
		[Deprecated(replacement="enableCollision")]
		public function get collidable():Boolean
		{
			
			return enableCollision;
			
		}
		
		[Deprecated(replacement="enableCollision")]
		/**
		 * @private
		 */
		public function set collidable(value:Boolean):void
		{
			
			enableCollision = value;
			
		}
		
		//----------------------------------
		//  enableCollisionReaction
		//----------------------------------
		
		private var _enableCollisionReaction:Boolean = true;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#enableCollisionReaction
		 */
		public function get enableCollisionReaction():Boolean
		{
			
			return _enableCollisionReaction;
			
		}
		
		/**
		 * @private
		 */
		public function set enableCollisionReaction(value:Boolean):void
		{
			
			_enableCollisionReaction = value;
			
		}
		
		//----------------------------------
		//  mass
		//----------------------------------
		
		private var _mass:Number = 1;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#mass
		 */
		public function get mass():Number
		{
			
			return _mass;
			
		}
		
		/**
		 * @private
		 */
		public function set mass(value:Number):void
		{
			
			_mass = value;
			
		}
		
		//----------------------------------
		//  velocity
		//----------------------------------
		
		private var _velocity:Velocity = new Velocity();
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#velocity
		 */
		public function get velocity():Velocity
		{
			
			return _velocity;
			
		}
		
		/**
		 * @private
		 */
		public function set velocity(value:Velocity):void
		{
			
			if (_velocity != null)
				_velocity.removeEventListener(PhysicsEvent.ACCELERATED, onObjectAccelerated);
			
			_velocity = value;
			
			// Make sure velocity is always defined
			if (_velocity == null)
				_velocity = new Velocity();
			
			_velocity.addEventListener(PhysicsEvent.ACCELERATED, onObjectAccelerated);
			
		}
		
		//----------------------------------
		//  acceleration
		//----------------------------------
		
		private var _acceleration:Acceleration = new Acceleration();
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#acceleration
		 */
		public function get acceleration():Acceleration
		{
			
			return _acceleration;
			
		}
		
		/**
		 * @private
		 */
		public function set acceleration(value:Acceleration):void
		{
			
			_acceleration = value;
			
			// Make sure acceleration is always defined
			if (_acceleration == null)
				_acceleration = new Acceleration();
			
		}
		
		//----------------------------------
		//  hitRegion
		//----------------------------------
		
		private var _hitRegion:Vector.<SimplePhysicsObject3DHitArea>;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#hitRegion
		 */
		public function get hitRegion():Vector.<SimplePhysicsObject3DHitArea>
		{
			
			return _hitRegion;
			
		}
		
		/**
		 * @private
		 */
		public function set hitRegion(value:Vector.<SimplePhysicsObject3DHitArea>):void
		{
			
			_hitRegion = value;
			
			var numHitRegions:uint;
			if ((_hitRegionDisplayObject3D != null) && (_hitRegionDisplayObject3D.length > 0))
			{
				
				// Remove all hit regions
				numHitRegions = _hitRegionDisplayObject3D.length;
				for (var i:uint = 0; i < numHitRegions; i++)
				{
					
					Sphere(_hitRegionDisplayObject3D[i]).parent.removeChild(Sphere(_hitRegionDisplayObject3D[i]));
					
				}
				
				_hitRegionDisplayObject3D = null;
				
			}
			
			if ((_hitRegion != null) && (_hitRegion.length > 0))
			{
				
				_hitRegionDisplayObject3D = [];
				numHitRegions = _hitRegion.length;
				for (var j:uint = 0; j < numHitRegions; j++)
				{
					
					if (_viewHitRegion)
					{
						
						// Display hit region
						var hitregionWireFrame:WireframeMaterial = new WireframeMaterial();
						var newHitRegionIndicator:Sphere = new Sphere(hitregionWireFrame, _hitRegion[j].radius, 4, 4);
						newHitRegionIndicator.x = _hitRegion[j].x;
						newHitRegionIndicator.y = _hitRegion[j].y;
						newHitRegionIndicator.z = _hitRegion[j].z;
						this.addChild(newHitRegionIndicator);
						
						_hitRegionDisplayObject3D.push(newHitRegionIndicator);
						
					}
					
					/*
					// Check to make sure all objects are SimplePhysicsObject3DHitArea
					if (_hitRegion[j] is SimplePhysicsObject3DHitArea)
					{
						
						if (_viewHitRegion)
						{
							
							// Display hit region
							var hitregionWireFrame:WireframeMaterial = new WireframeMaterial();
							var newHitRegionIndicator:Sphere = new Sphere(hitregionWireFrame, SimplePhysicsObject3DHitArea(_hitRegion[j]).radius, 4, 4);
							newHitRegionIndicator.x = SimplePhysicsObject3DHitArea(_hitRegion[j]).x;
							newHitRegionIndicator.y = SimplePhysicsObject3DHitArea(_hitRegion[j]).y;
							newHitRegionIndicator.z = SimplePhysicsObject3DHitArea(_hitRegion[j]).z;
							this.addChild(newHitRegionIndicator);
							
							_hitRegionDisplayObject3D.push(newHitRegionIndicator);
							
						}
						
					}
					else
					{
						
						throw new Error("Array specified for hitRegion contains object that is not a SimplePhysicsObject3DHitArea.");
						
					}
					*/
					
				}
				
			}
			
		}
		
		//----------------------------------
		//  hitTestObjectAreas
		//----------------------------------
		
		private var _hitTestObjectAreas:Vector.<SimplePhysicsObject3DHitArea> = new Vector.<SimplePhysicsObject3DHitArea>();
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#hitTestObjectAreas
		 */
		public function get hitTestObjectAreas():Vector.<SimplePhysicsObject3DHitArea>
		{
			
			return _hitTestObjectAreas;
			
		}
		
		//----------------------------------
		//  hitTestObjectCollidedAreas
		//----------------------------------
		
		private var _hitTestObjectCollidedAreas:Vector.<SimplePhysicsObject3DHitArea> = new Vector.<SimplePhysicsObject3DHitArea>();
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#hitTestObjectCollidedAreas
		 */
		public function get hitTestObjectCollidedAreas():Vector.<SimplePhysicsObject3DHitArea>
		{
			
			return _hitTestObjectCollidedAreas;
			
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#isColliding
		 */
		override public function hitTestObject(obj:DisplayObject3D, multiplier:Number = 1):Boolean
		{
			
			// Assume false
			_hitTestObjectAreas = new Vector.<SimplePhysicsObject3DHitArea>();
			_hitTestObjectCollidedAreas = new Vector.<SimplePhysicsObject3DHitArea>();
			
			if ((obj is ISimplePhysicsObject3D) && (hitRegion != null))
				return isColliding(obj as ISimplePhysicsObject3D, multiplier) != null;
			else
				return super.hitTestObject(obj, multiplier); // Do regular hit test
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function addChild(child:DisplayObject3D, name:String = null):DisplayObject3D
		{
			
			if (child is ISimplePhysicsObject3D)
			{
				
				throw new Error("You cannot add ISimplePhysicsObject3D to another ISimplePhysicsObject3D.");
				return null;
				
			}
			else
			{
				
				return super.addChild(child, name);
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChildren(parent:DisplayObject3D):DisplayObjectContainer3D
		{
			
			return super.addChildren(parent);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#isColliding()
		 */
		public function isColliding(obj:ISimplePhysicsObject3D, multiplier:Number = 1):SimplePhysicsHitTestElements
		{
			
			// Assume false
			var hitTestElements:SimplePhysicsHitTestElements = new SimplePhysicsHitTestElements();
			
			if ((hitRegion != null) && (hitRegion.length > 0) &&
				(obj.hitRegion != null) && (obj.hitRegion.length > 0))
			{
				
				// How about when compared to individual hitRegion?
				
				copyPosition(this);
				copyTransform(this);
				
				// Is the obj intersecting with one of the hitRegion?
				var selfHitArea:SimplePhysicsObject3DHitArea;
				var selfHitAreaAbsPos:SimplePhysicsObject3DHitArea;
				
				var objHitArea:SimplePhysicsObject3DHitArea;
				var objHitAreaAbsPos:SimplePhysicsObject3DHitArea;
				
				var selfHitAreaAbsCoordinate:Number3D;
				var objHitAreaAbsCoordinate:Number3D;
				var numHitAreas:int = hitRegion.length;
				for (var i:int = 0; i < numHitAreas; i++)
				{
					
					// Check to see if obj hits any of the HitArea defined for this SimplePhysicsPV3DObject3D
					selfHitArea = hitRegion[i];
					
					// Global pos of the hit area
					selfHitAreaAbsCoordinate = DisplayObject3DMath.localToGlobal(new Number3D(selfHitArea.x, selfHitArea.y, selfHitArea.z), this);
					//selfHitAreaAbsCoordinate = new Number3D(selfHitArea.x + x, selfHitArea.y + y, selfHitArea.z + z);
					selfHitAreaAbsPos = new SimplePhysicsObject3DHitArea(selfHitAreaAbsCoordinate.x,
																		 selfHitAreaAbsCoordinate.y,
																		 selfHitAreaAbsCoordinate.z,
																		 selfHitArea.radius);
					
					// Check to see if selfHitAreaAbsPos hits any of the hitRegion defined for the obj
					var numTargetHitAreas:uint = obj.hitRegion.length;
					for (var j:uint = 0; j < numTargetHitAreas; j++)
					{
						
						objHitArea = obj.hitRegion[j];
						
						if (obj is DisplayObject3D)
						{
							
							DisplayObject3D(obj).copyPosition(obj);
							DisplayObject3D(obj).copyTransform(obj);
							
							objHitAreaAbsCoordinate = DisplayObject3DMath.localToGlobal(new Number3D(objHitArea.x, objHitArea.y, objHitArea.z), obj as DisplayObject3D);
							
						}
						else
						{
							
							objHitAreaAbsCoordinate = new Number3D(objHitArea.x + obj.x, objHitArea.y + obj.y, objHitArea.z + obj.z);
							
						}
						
						objHitAreaAbsPos = new SimplePhysicsObject3DHitArea(objHitAreaAbsCoordinate.x,
																			objHitAreaAbsCoordinate.y,
																			objHitAreaAbsCoordinate.z,
																			objHitArea.radius);
						
						if (selfHitAreaAbsPos.hitTest(objHitAreaAbsPos))
						{
							
							if (hitTestElements.currentTargetHitAreas.indexOf(selfHitArea) == -1)
								hitTestElements.currentTargetHitAreas.push(selfHitArea);
							if (hitTestElements.collidedTargetHitAreas.indexOf(objHitArea) == -1)
								hitTestElements.collidedTargetHitAreas.push(objHitArea);
							
						}
						
					}
					
				}
				
			}
			
			_hitTestObjectAreas = hitTestElements.currentTargetHitAreas;
			_hitTestObjectCollidedAreas = hitTestElements.collidedTargetHitAreas;
			
			if (hitTestElements.currentTargetHitAreas.length > 0)
				return hitTestElements;
			else
				return null;
			
		}
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#move()
		 */
		public function move(millisecondsElapsed:int = 1, acceleration:Acceleration = null):void
		{
			
			// do position calculation based on velocity, acceleration and time
			var updateAcceleration:Boolean = true;
			if (acceleration == null)
			{
				
				acceleration = new Acceleration(0, 0, 0, 0, 0, 0);
				updateAcceleration = false;
				
			}
			
			var oldVelocity:Velocity = _velocity.clone() as Velocity;
			
			x += (_velocity.x * millisecondsElapsed + 0.5 * acceleration.x * Math.pow(millisecondsElapsed, 2));
			y += (_velocity.y * millisecondsElapsed + 0.5 * acceleration.y * Math.pow(millisecondsElapsed, 2));
			z += (_velocity.z * millisecondsElapsed + 0.5 * acceleration.z * Math.pow(millisecondsElapsed, 2));
			rotationX += (_velocity.rotationX * millisecondsElapsed + 0.5 * acceleration.rotationX * Math.pow(millisecondsElapsed, 2));
			rotationY += (_velocity.rotationY * millisecondsElapsed + 0.5 * acceleration.rotationY * Math.pow(millisecondsElapsed, 2));
			rotationZ += (_velocity.rotationZ * millisecondsElapsed + 0.5 * acceleration.rotationZ * Math.pow(millisecondsElapsed, 2));
			
			// Update velocity using new acceleration
			var moveEvent:SimplePhysicsObject3DEvent;
			if (updateAcceleration)
			{
				
				_velocity.accelerate(acceleration, millisecondsElapsed);
				moveEvent = new SimplePhysicsObject3DEvent(SimplePhysicsObject3DEvent.MOVED, false, false,
														   oldVelocity, _velocity, acceleration);
				
			}
			else
			{
				
				moveEvent = new SimplePhysicsObject3DEvent(SimplePhysicsObject3DEvent.MOVED, false, false,
														   oldVelocity, _velocity);
				
			}
			
			// And dispatchEvent indicating that this object has moved
			dispatchEvent(moveEvent);
			
		}
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#clonePosition()
		 */
		public function clonePosition():ISimplePhysicsObject3D
		{
			
			var copy:SimplePhysicsPV3DObject3D = new SimplePhysicsPV3DObject3D();
			copy.copyProperties(this);
			
			return copy;
			
		}
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#copyProperties()
		 */
		public function copyProperties(sourceObj:ISimplePhysicsObject3D):void
		{
			
			x = sourceObj.x;
			y = sourceObj.y;
			z = sourceObj.z;
			rotationX = sourceObj.rotationX;
			rotationY = sourceObj.rotationY;
			rotationZ = sourceObj.rotationZ;
			enablePhysics = sourceObj.enablePhysics;
			enableExternalForce = sourceObj.enableExternalForce;
			enableCollision = sourceObj.enableCollision;
			enableCollisionReaction = sourceObj.enableCollisionReaction;
			mass = sourceObj.mass;
			velocity = sourceObj.velocity.clone() as Velocity;
			acceleration = sourceObj.acceleration.clone() as Acceleration;
			hitRegion = sourceObj.hitRegion.concat();
			
		}
		
		public function destroy():void
		{
			
			for (var prop:String in children)
			{
				
				DisplayObject3D(children[prop]).material = null;
				removeChild(DisplayObject3D(children[prop]));
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onObjectAccelerated(event:PhysicsEvent):void
		{
			
			dispatchEvent(event.clone());
			
		}
		
	}
	
}