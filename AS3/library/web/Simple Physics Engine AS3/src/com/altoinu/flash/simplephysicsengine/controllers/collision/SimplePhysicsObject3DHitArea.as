/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.simplephysicsengine.controllers.collision
{
	
	import com.altoinu.flash.datamodels.Matrix3D;
	import com.altoinu.flash.datamodels.Quaternion;
	
	/**
	 * Hit area of ISimplePhysicsObject3D.  Since Papervision considers each object as if is is a sphere (it only
	 * checks to see if objects are within the vertices farthest from center of each object), if more detailed
	 * collision detection is needed, then HitAreas must be defined for ISimplePhysicsObject3D.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class SimplePhysicsObject3DHitArea
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param x
		 * @param y
		 * @param z
		 * @param radius
		 * 
		 */
		public function SimplePhysicsObject3DHitArea(x:Number, y:Number, z:Number, radius:Number)
		{
			
			transform.n14 = x;
			transform.n24 = y;
			transform.n34 = z;
			_radius = radius;
			
			updateTransform();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _rot:Quaternion = new Quaternion();
		private var _tempMatrix:Matrix3D = Matrix3D.IDENTITY;
		
		// Internal
		protected var _rotationX:Number = 0;
		protected var _rotationY:Number = 0;
		protected var _rotationZ:Number = 0;
		
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
		
		//--------------------------------------
		//  x
		//--------------------------------------
		
		public function get x():Number
		{
			
			return transform.n14;
			
		}
		
		//--------------------------------------
		//  y
		//--------------------------------------
		
		public function get y():Number
		{
			
			return transform.n24;
			
		}
		
		//--------------------------------------
		//  z
		//--------------------------------------
		
		public function get z():Number
		{
			
			return transform.n34;
			
		}
		
		//--------------------------------------
		//  radius
		//--------------------------------------
		
		private var _radius:Number;
		
		public function get radius():Number
		{
			
			return _radius;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Calculates distance to this HitArea to specified HitArea.
		 * @param targetHitArea
		 * @return 
		 * 
		 */
		public function distanceTo(targetHitArea:SimplePhysicsObject3DHitArea):Number
		{
			
			var xDiff:Number = x - targetHitArea.x;
			var yDiff:Number = y - targetHitArea.y;
			var zDiff:Number = z - targetHitArea.z;
			return Math.sqrt(Math.pow(xDiff, 2) + Math.pow(yDiff, 2) + Math.pow(zDiff, 2));
			
		}
		
		/**
		 * If true, then specified HitArea is intersecting this HitArea.
		 * @param targetHitArea
		 * @return 
		 * 
		 */
		public function hitTest(targetHitArea:SimplePhysicsObject3DHitArea):Boolean
		{
			
			return (distanceTo(targetHitArea) <= (radius + targetHitArea.radius));
			
		}
		
		/**
		 * Creates exact copy of current Object3DHitArea.
		 * @return 
		 * 
		 */
		public function clone():SimplePhysicsObject3DHitArea
		{
			
			return new SimplePhysicsObject3DHitArea(x, y, z, radius);
			
		}
		
		public function toString():String
		{
			
			return "[SimplePhysicsObject3DHitArea x: "+x+" y: "+y+" z: "+z+" radius: "+radius+"]";
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function updateTransform():void
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