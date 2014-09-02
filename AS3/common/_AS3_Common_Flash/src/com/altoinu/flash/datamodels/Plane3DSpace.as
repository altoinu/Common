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
	 * Plane in 3D space.
	 * 
	 * @author Kaoru Kawashima
	 * @see http://en.wikipedia.org/wiki/Plane_%28geometry%29
	 * 
	 */
	public class Plane3DSpace
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private static const ERROR_DEFINING_TWO_VECTORS:String = "Two vectors used to define a plane must not be parallel.";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param point Point on the Plane.
		 * @param vector1 If <code>vector2</code> is not defined, then this would be a nonzero vector normal to the plane.
		 * If <code>vector2</code> is defined, then this is simply one of the vectors on the plane.
		 * @param vector2 Optional second vector on plane not parallel to <code>vector1</code>. If this is defined, then the plane
		 * is region that contains point1, <code>vector1</code> and <code>vector2</code> on it.
		 * 
		 */
		public function Plane3DSpace(point:Point3DSpace, vector1:Vector3DSpace, vector2:Vector3DSpace = null)
		{
			
			// Define plane by point and normal vector1
			this.point = point;
			this.vector1 = vector1;
			
			if (vector2 != null)
			{
				
				// vector2 is actually defined
				// Define plane by point and two vectors on it
				if (!Vector3DSpace.areParallel(vector1, vector2))
					this.vector2 = vector2;
				else
					throw new Error("Two vectors used to define a plane must not be parallel.");
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  point
		//----------------------------------
		
		private var _point:Point3DSpace = new Point3DSpace(0, 0, 0);
		
		public function get point():Point3DSpace
		{
			
			return _point;
			
		}
		
		/**
		 * @private
		 */
		public function set point(newPoint:Point3DSpace):void
		{
			
			if (newPoint == null)
				throw new Error("You must define point for Plane3DSpace.");
			else
				_point = newPoint;
			
		}
		
		//----------------------------------
		//  vector1
		//----------------------------------
		
		private var _vector1:Vector3DSpace = new Vector3DSpace(0, 1, 0);
		
		public function get vector1():Vector3DSpace
		{
			
			return _vector1;
			
		}
		
		/**
		 * @private
		 */
		public function set vector1(newVector:Vector3DSpace):void
		{
			
			if (newVector == null)
				throw new Error("You must define vector1 for Plane3DSpace.");
			else if ((vector2 != null) && Vector3DSpace.areParallel(newVector, vector2))
				throw new Error(ERROR_DEFINING_TWO_VECTORS);
			else
				_vector1 = newVector;
			
		}
		
		//----------------------------------
		//  vector2
		//----------------------------------
		
		private var _vector2:Vector3DSpace;
		
		public function get vector2():Vector3DSpace
		{
			
			return _vector2;
			
		}
		
		/**
		 * @private
		 */
		public function set vector2(newVector:Vector3DSpace):void
		{
			
			if ((newVector != null) && Vector3DSpace.areParallel(vector1, newVector))
				throw new Error(ERROR_DEFINING_TWO_VECTORS);
			else
				_vector2 = newVector;
			
		}
		
		//----------------------------------
		//  normal
		//----------------------------------
		
		/**
		 * Returns axis normal (perpendicular) to the plane.
		 * 
		 * <p>If <code>vector2</code> is not defined, then this is simply vector1. If <code>vector2</code> is defined,
		 * then this will be axis perpendicular to both of them.</p>
		 * 
		 */
		public function get normal():Vector3DSpace
		{
			
			if (vector2 == null)
				return vector1.normalized;
			else
				return Vector3DSpace.crossProduct(vector1, vector2);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function toString():String
		{
			
			return "[Plane3DSpace "+point+" "+vector1+(vector2 != null ? " "+vector2 : "")+"]";
			
		}
		
	}
	
}