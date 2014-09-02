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
	 * Vector in 3D space defined by two Point3DSpace from point1 to point2.
	 * This cannot be zero vector (points are at exactly same spot).
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class Axis3DSpace
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private static const SAMEPOINT_ERROR:String = "Two points cannot be the same to define Axis3DSpace.";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param point1
		 * @param point2
		 * 
		 */
		public function Axis3DSpace(point1:Point3DSpace, point2:Point3DSpace)
		{
			
			if ((point1 == null) || (point2 == null))
			{
				
				throw new Error("Two points are required to define Axis3DSpace.");
				
			}
			else if (point1.isEqual(point2))
			{
				
				throw new Error(SAMEPOINT_ERROR);
				
			}
			else
			{
				
				_point1 = point1;
				_point2 = point2;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dx
		//----------------------------------
		
		/**
		 * x direction vector of the axis.
		 */
		public function get dx():Number
		{
			
			return point2.x - point1.x;
			
		}
		
		//----------------------------------
		//  dy
		//----------------------------------
		
		/**
		 * y direction vector of the axis.
		 */
		public function get dy():Number
		{
			
			return point2.y - point1.y;
			
		}
		
		//----------------------------------
		//  dz
		//----------------------------------
		
		/**
		 * z direction vector of the axis.
		 */
		public function get dz():Number
		{
			
			return point2.z - point1.z;
			
		}
		
		//----------------------------------
		//  point1
		//----------------------------------
		
		private var _point1:Point3DSpace;
		
		public function get point1():Point3DSpace
		{
			
			return _point1;
			
		}
		
		/**
		 * @private
		 */
		public function set point1(newPoint:Point3DSpace):void
		{
			
			//if ((_point1 == null) || (newPoint == null) || !_point1.isEqual(newPoint))
			
			if (!newPoint.isEqual(point2))
				_point1 = newPoint;
			else
				throw new Error(SAMEPOINT_ERROR);
			
		}
		
		//----------------------------------
		//  point2
		//----------------------------------
		
		private var _point2:Point3DSpace;
		
		public function get point2():Point3DSpace
		{
			
			return _point2;
			
		}
		
		/**
		 * @private
		 */
		public function set point2(newPoint:Point3DSpace):void
		{
			
			//if ((_point2 == null) || (newPoint == null) || !_point2.isEqual(newPoint))
			if (!newPoint.isEqual(point1))
				_point2 = newPoint;
			else
				throw new Error(SAMEPOINT_ERROR);
			
		}
		
		//----------------------------------
		//  normalized
		//----------------------------------
		
		/**
		 * Returns normalized axis (same direction, but with norm (length) 1) that starts at point1.
		 * 
		 */
		public function get normalized():Axis3DSpace
		{
			
			var dxpow:Number = dx * dx;
			var dypow:Number = dy * dy;
			var dzpow:Number = dz * dz;
			var mod:Number = Math.sqrt(dxpow + dypow + dzpow);
			
			mod = 1 / mod;
			var firstPoint:Point3DSpace = point1.clone() as Point3DSpace;
			var secondPoint:Point3DSpace = new Point3DSpace((point2.x - point1.x) * mod, (point2.y - point1.y) * mod, (point2.z - point1.z) * mod);
			
			return new Axis3DSpace(firstPoint, secondPoint);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function toString():String
		{
			
			return "[Axis3DSpace:\n point1 - " + point1 + "\n point2 - " + point2 + "\n " + dx + "," + dy + "," + dz + "]";
			
		}
		
		public function clone():Axis3DSpace
		{
			
			return new Axis3DSpace(point1.clone() as Point3DSpace, point2.clone() as Point3DSpace);
			
		}
		
	}
	
}