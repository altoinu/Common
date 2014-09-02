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
	 * Point (x, y, z) in 3D space.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class Point3DSpace extends Number3D
	{
		
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
		public function Point3DSpace(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			
			super(x, y, z);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		override public function toString():String
		{
			
			return "[Point3DSpace: " + x + "," + y + "," + z + "]";
			
		}
		
		override public function clone():Number3D
		{
			
			return new Point3DSpace(x, y, z);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function distanceTo(point:Point3DSpace):Number
		{
			
			var xDist:Number = x - point.x;
			var yDist:Number = y - point.y;
			var zDist:Number = z - point.z;
			
			return Math.sqrt(xDist * xDist + yDist * yDist + zDist * zDist);
			
		}
		
	}
	
}