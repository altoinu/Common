/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.datamodels
{
	
	/**
	 * Vector in 3D space.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class Vector3DSpace extends Number3D
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------
		
		private static const toDEGREES:Number = 180 / Math.PI;
		private static const toRADIANS:Number = Math.PI / 180;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		public static function angleToDegrees(radians:Number):Number
		{
			
			return radians *= toDEGREES;
			
		}
		
		public static function angleToRadians(degrees:Number):Number
		{
			
			return degrees *= toRADIANS;
			
		}
		
		public static function add(vector1:Vector3DSpace, vector2:Vector3DSpace):Vector3DSpace
		{
			
			return new Vector3DSpace(vector1.x + vector2.x, vector1.y + vector2.y, vector1.z + vector2.z);
			
		}
		
		public static function subtract(vector1:Vector3DSpace, vector2:Vector3DSpace):Vector3DSpace
		{
			
			return new Vector3DSpace(vector1.x - vector2.x, vector1.y - vector2.y, vector1.z - vector2.z);
			
		}
		
		/**
		 * Calculates dot product.
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function dotProduct(vector1:Vector3DSpace, vector2:Vector3DSpace):Number
		{
			
			return vector1.x * vector2.x + vector1.y * vector2.y + vector1.z * vector2.z;
			
		}
		
		/**
		 * Calculates cross product of two vectors.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function crossProduct(vector1:Vector3DSpace, vector2:Vector3DSpace):Vector3DSpace
		{
			
			return new Vector3DSpace(vector1.y * vector2.z - vector1.z * vector2.y,
				vector1.z * vector2.x - vector1.x * vector2.z,
				vector1.x * vector2.y - vector1.y * vector2.x);
			
		}
		
		/**
		 * Calculates angle in radians between two vectors.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function angleBetweenVectors(vector1:Vector3DSpace, vector2:Vector3DSpace):Number
		{
			
			var dotProd:Number = dotProduct(vector1, vector2);
			var ratio:Number = dotProd / (vector1.magnitude * vector2.magnitude);
			var angle:Number = Math.acos(ratio);
			
			if (!isNaN(angle))
			{
				
				angle %= (2 * Math.PI); // Make sure angle is in between 0 and 2 * Math.PI
				
				return angle;
				
			}
			else
			{
				
				// if angle is NaN, then it means ratio was either 1 or -1
				// which indicates angle is 0 or 180
				return ratio > 0 ? 0 : Math.PI;
				
			}
			
		}
		
		/**
		 * Checks to see if two vectors are parallel to each other.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function areParallel(vector1:Vector3DSpace, vector2:Vector3DSpace):Boolean
		{
			
			var a:Number = Math.sqrt(Math.pow(vector1.x, 2) + Math.pow(vector1.y, 2) + Math.pow(vector1.z, 2));
			var b:Number = Math.sqrt(Math.pow(vector2.x, 2) + Math.pow(vector2.y, 2) + Math.pow(vector2.z, 2));
			
			return Math.abs(dotProduct(vector1, vector2)) == Math.abs(a * b);
			
		}
		
		/**
		 * Checks to see if two vectors are parallel to each other and also pointing towards the same direction.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function areParallelSameDirection(vector1:Vector3DSpace, vector2:Vector3DSpace):Boolean
		{
			
			return dotProduct(vector1.normalized, vector2.normalized) == 1;
			
		}
		
		/**
		 * Checks to see if two axes are parallel to each other but pointing in opposite direction.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function areParallelOppositeDirection(vector1:Vector3DSpace, vector2:Vector3DSpace):Boolean
		{
			
			return dotProduct(vector1.normalized, vector2.normalized) == -1;
			
		}
		
		/**
		 * Checks to see if two axes are orthogonal (meeting at right angles) to each other.
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function areOrthogonal(vector1:Vector3DSpace, vector2:Vector3DSpace):Boolean
		{
			
			return dotProduct(vector1.normalized, vector2.normalized) == 0;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param x
		 * @param y
		 * @param z
		 * 
		 */
		public function Vector3DSpace(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			
			super(x, y, z);
			
		}
		
		//----------------------------------
		//  magnitude
		//----------------------------------
		
		/**
		 * Magnitude of the vector. Setting this value will cause x, y, and z to be adjusted.
		 */
		public function get magnitude():Number
		{
			
			return Math.sqrt(x * x + y * y + z * z);
			
		}
		
		/**
		 * @private
		 */
		public function set magnitude(value:Number):void
		{
			
			var oldValues:Array = [x, y, z];
			
			// Multiply the x, y, and z by using the ratio between new value and current magnitude
			// ex. If current magnitude is 3 and new magnitude is 6, then x, y, z will be multiplied by 2.
			var multiple:Number = value / magnitude;
			x *= multiple;
			y *= multiple;
			z *= multiple;
			
		}
		
		//----------------------------------
		//  normalized
		//----------------------------------
		
		/**
		 * Returns normalized axis (same direction, but with norm (length) 1).
		 * 
		 */
		public function get normalized():Vector3DSpace
		{
			
			/*
			var mod:Number = magnitude;
			
			mod = 1 / mod;
			
			return new Vector3DSpace(x * mod, y * mod, z * mod);
			*/
			
			var copy:Vector3DSpace = clone() as Vector3DSpace;
			copy.magnitude = 1;
			return copy;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[Vector3DSpace: " + x + "," + y + "," + z + "]";
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Number3D
		{
			
			return new Vector3DSpace(x, y, z);
			
		}
		
		/**
		 * Sets the magnitude of vector to 1 so it becomes a unit vector.
		 * 
		 */
		override public function normalize():void
		{
			
			magnitude = 1;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * @param angle - in radians
		 * 
		 */
		public function rotateX(angle:Number):void
		{
			
			var cosRY:Number = Math.cos(angle);
			var sinRY:Number = Math.sin(angle);
			
			var temp:Vector3DSpace = clone() as Vector3DSpace;
			
			y = (temp.y * cosRY) - (temp.z * sinRY);
			z = (temp.y * sinRY) + (temp.z * cosRY);
			
		}	
		
		/**
		 * 
		 * @param angle - in radians
		 * 
		 */
		public function rotateY(angle:Number):void
		{
			
			var cosRY:Number = Math.cos(angle);
			var sinRY:Number = Math.sin(angle);
			
			var temp:Vector3DSpace = clone() as Vector3DSpace;
			
			x = (temp.x * cosRY) + (temp.z * sinRY);
			z = (temp.x* - sinRY) + (temp.z * cosRY);
			
			
		}
		
		/**
		 * 
		 * @param angle - in radians
		 * 
		 */
		public function rotateZ(angle:Number):void
		{
			
			var cosRY:Number = Math.cos(angle);
			var sinRY:Number = Math.sin(angle);
			
			var temp:Vector3DSpace = clone() as Vector3DSpace;	
			
			x = (temp.x * cosRY) - (temp.y * sinRY);
			y = (temp.x * sinRY) + (temp.y * cosRY);
			
		}
			
	}
	
}