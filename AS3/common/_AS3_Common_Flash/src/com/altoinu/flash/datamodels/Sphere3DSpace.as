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
	 * Sphere in 3D space at (x, y, z) with radius.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class Sphere3DSpace
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param point If null, then it will be 0, 0, 0.
		 * @param radius Must be positive. Negative numbers are automatically converted to positive.
		 * 
		 */
		public function Sphere3DSpace(point:Point3DSpace = null, radius:Number = 0)
		{
			
			this.point = point;
			this.radius = radius;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  x
		//----------------------------------
		
		/**
		 * X coordinate of the sphere.
		 */
		public function get x():Number
		{
			
			if (point == null)
				point = new Point3DSpace(0, 0, 0);
			
			return point.x;
			
		}
		
		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			
			if (point == null)
				point = new Point3DSpace(0, 0, 0);
			
			point.x = value;
			
		}
		
		//----------------------------------
		//  y
		//----------------------------------
		
		/**
		 * Y coordinate of the sphere.
		 */
		public function get y():Number
		{
			
			if (point == null)
				point = new Point3DSpace(0, 0, 0);
			
			return point.y;
			
		}
		
		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			
			if (point == null)
				point = new Point3DSpace(0, 0, 0);
			
			point.y = value;
			
		}
		
		//----------------------------------
		//  z
		//----------------------------------
		
		/**
		 * Z coordinate of the sphere.
		 */
		public function get z():Number
		{
			
			if (point == null)
				point = new Point3DSpace(0, 0, 0);
			
			return point.z;
			
		}
		
		/**
		 * @private
		 */
		public function set z(value:Number):void
		{
			
			if (point == null)
				point = new Point3DSpace(0, 0, 0);
			
			point.z = value;
			
		}
		
		//----------------------------------
		//  point
		//----------------------------------
		
		private var _point:Point3DSpace;
		
		/**
		 * 3D coordinate of the sphere in Point3DSpace. Modifying this will change
		 * x, y, and z properties. If set to null, then they will be set to 0, 0, 0.
		 */
		public function get point():Point3DSpace
		{
			
			if (_point == null)
				_point = new Point3DSpace(0, 0, 0);
			
			return _point;
			
		}
		
		/**
		 * @private
		 */
		public function set point(value:Point3DSpace):void
		{
			
			if (value == null)
				value = new Point3DSpace(0, 0, 0);
			
			_point = value;
			
		}
		
		//----------------------------------
		//  radius
		//----------------------------------
		
		private var _radius:Number = 0;
		
		/**
		 * Must be positive. Negative numbers are automatically converted to positive.
		 */
		public function get radius():Number
		{
			
			return _radius;
			
		}
		
		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			
			_radius = Math.abs(value);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			
			return "[Sphere3DSpace: point: "+point+" radius: "+radius+"]";
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():Sphere3DSpace
		{
			
			return new Sphere3DSpace(point.clone() as Point3DSpace, radius);
			
		}
		
	}
	
}