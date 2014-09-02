/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.utils
{
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * Utility functions to deal with Math in 3D world in Papervision 2.0.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DisplayObject3DMath
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Given local coordinates in specified container, find global coordinates in the scene.
		 * 
		 * @param localCoordinates
		 * @param container Container <code>DisplayObject3D</code> where <code>localCoordinates</code> is based off of. This
		 * is needed so the rotation of the container will be considered when calculating global coordinate.
		 * 
		 * @return 
		 * 
		 */
		public static function localToGlobal(localCoordinates:Number3D, container:DisplayObject3D):Number3D
		{
			
			var containerWorldM:Matrix3D = new Matrix3D();
			containerWorldM.calculateMultiply(containerWorldM, container.transform);
			
			// calculate local to global coordinate
			var m:Matrix3D = new Matrix3D();
			var localCoordObj:DisplayObject3D = new DisplayObject3D();
			localCoordObj.x = localCoordinates.x;
			localCoordObj.y = localCoordinates.y;
			localCoordObj.z = localCoordinates.z;
			m.copy(localCoordObj.transform);
			m.calculateMultiply(containerWorldM, m);
			
			return new Number3D(m.n14, m.n24, m.n34);
			
			/*
			// Temporarily create object at local coordinate
			var localCoordObj:DisplayObject3D = new DisplayObject3D;
			localCoordObj.x = localCoordinates.x;
			localCoordObj.y = localCoordinates.y;
			localCoordObj.z = localCoordinates.z;
			container.addChild(localCoordObj);
			
			// calculate local to global coordinate
			var m:Matrix3D = new Matrix3D();
			m.copy(localCoordObj.transform);
			m.calculateMultiply(DisplayObject3D(localCoordObj.parent).world, m);
			var globalCoordinate:Number3D = new Number3D(m.n14, m.n24, m.n34);
			
			container.removeChild(localCoordObj);
			
			return globalCoordinate;
			*/
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.  You do not create an instance of this class... just call its static functions
		 * 
		 */
		public function DisplayObject3DMath()
		{
			
			throw("You do not create an instance of DisplayObject3DMath.  Just call its static functions");
			
		}
		
	}
	
}