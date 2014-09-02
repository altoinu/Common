/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.simplephysicsengine.models
{
	
	import com.altoinu.flash.datamodels.Acceleration;
	import com.altoinu.flash.datamodels.Matrix3D;
	import com.altoinu.flash.datamodels.Quaternion;
	import com.altoinu.flash.datamodels.Velocity;
	import com.altoinu.flash.simplephysicsengine.controllers.collision.SimplePhysicsObject3DHitArea;
	import com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Data model representing ISimplePhysicsObject3D in 3D space.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class SimplePhysicsObject3DData extends EventDispatcher implements ISimplePhysicsObject3D
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private static const toDEGREES 	:Number = 180/Math.PI;
		private static const toRADIANS 	:Number = Math.PI/180;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function SimplePhysicsObject3DData()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _rot:Quaternion = new Quaternion();
		private var _tempMatrix:Matrix3D = Matrix3D.IDENTITY;
		
		/*
		private function getTransformMatrixValueAt(row:int, col:int):Number
		{
			
			if ((row < 0) || (4 < row) || (col < 0) || (4 < col))
				return NaN;
			
			return _transform.rawData[((col - 1) * 4 + row) - 1];
			
		}
		
		private function setTransformMatrixValueAt(row:int, col:int, value:Number):void
		{
			
			if ((row < 0) || (4 < row) || (col < 0) || (4 < col))
			{
				
				throw new Error("Invalid row/col for Matrix");
				return null;
				
			}
			
			var rawData:Vector.<Number> = _transform.rawData.concat();
			rawData[((col - 1) * 4 + row) - 1] = value;
			_transform.copyRawDataFrom(rawData);
			
		}
		*/
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  transform
		//----------------------------------
		
		private var _transform:Matrix3D = new Matrix3D();
		
		public function get transform():Matrix3D
		{
			
			return _transform;
			
		}
		
		//----------------------------------
		//  x
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#x
		 */
		public function get x():Number
		{
			
			return transform.n14;
			
		}
		
		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			
			transform.n14 = value;
			
		}
		
		//----------------------------------
		//  y
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#y
		 */
		public function get y():Number
		{
			
			return transform.n24;
			
		}
		
		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			
			transform.n24 = value;
			
		}
		
		//----------------------------------
		//  z
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#z
		 */
		public function get z():Number
		{
			
			return transform.n34;
			
		}
		
		/**
		 * @private
		 */
		public function set z(value:Number):void
		{
			
			transform.n34 = value;
			
		}
		
		//----------------------------------
		//  rotationX
		//----------------------------------
		
		private var _rotationX:Number = 0;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#rotationX
		 */
		public function get rotationX():Number
		{
			
			return _rotationX * toDEGREES;
			
		}
		
		/**
		 * @private
		 */
		public function set rotationX(value:Number):void
		{
			
			_rotationX = value * toRADIANS;
			updateTransform();
			
		}
		
		//----------------------------------
		//  rotationY
		//----------------------------------
		
		private var _rotationY:Number = 0;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#rotationY
		 */
		public function get rotationY():Number
		{
			
			return _rotationY * toDEGREES;
			
		}
		
		/**
		 * @private
		 */
		public function set rotationY(value:Number):void
		{
			
			_rotationY = value * toRADIANS;
			updateTransform();
			
		}
		
		//----------------------------------
		//  rotationZ
		//----------------------------------
		
		private var _rotationZ:Number = 0;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#rotationZ
		 */
		public function get rotationZ():Number
		{
			
			return _rotationZ * toDEGREES;
			
		}
		
		/**
		 * @private
		 */
		public function set rotationZ(value:Number):void
		{
			
			_rotationZ = value * toRADIANS;
			updateTransform();
			
		}
		
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
		
		/**
		 * @private
		 */
		public function set enableExternalForce(value:Boolean):void
		{
			
			_enableExternalForce = value;
			
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
		
		private var _velocity:Velocity;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#velocity
		 * 
		 * <p>Setting this value to an instance of velocity does not actually make it remember
		 * the reference to it but instead calls <code>clone()</code> method to copy all properties.</p>
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
			
			_velocity = value.clone() as Velocity;
			
		}
		
		//----------------------------------
		//  acceleration
		//----------------------------------
		
		private var _acceleration:Acceleration;
		
		/**
		 * @copy com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D#acceleration
		 * 
		 * <p>Setting this value to an instance of acceleration does not actually make it remember
		 * the reference to it but instead calls <code>clone()</code> method to copy all properties.</p>
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
			
			_acceleration = value.clone() as Acceleration;
			
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
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public function isColliding(obj:ISimplePhysicsObject3D, multiplier:Number=1):SimplePhysicsHitTestElements
		{
			
			return null;
			
		}
		
		/**
		 * @private
		 */
		public function move(millisecondsElapsed:int=1, acceleration:Acceleration=null):void
		{
			
		}
		
		/**
		 * @private
		 */
		public function clonePosition():ISimplePhysicsObject3D
		{
			
			return null;
			
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
			velocity = sourceObj.velocity;
			acceleration = sourceObj.acceleration;
			hitRegion = sourceObj.hitRegion.concat();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function updateTransform():void
		{
			
			_rot.setFromEuler(_rotationY, _rotationZ, _rotationX);
			
			// Rotation
			transform.copy3x3( _rot.matrix );
			
			// Scale
			_tempMatrix.reset(); 
			_tempMatrix.n11 = 1;//this._scaleX;
			_tempMatrix.n22 = 1;//this._scaleY;
			_tempMatrix.n33 = 1;//this._scaleZ;
			transform.calculateMultiply(transform, _tempMatrix);
			
		}
		
	}
	
}