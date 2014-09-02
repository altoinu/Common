/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.utils
{
	
	import com.altoinu.flash.datamodels.Axis3DSpace;
	import com.altoinu.flash.datamodels.Point3DSpace;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * Utility functions related to transformation of DisplayObject3D in Papervision 2.0.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DisplayObject3DTransformUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Rotates specified object at an arbitrary axis.  By using this method, you can rotate an object
		 * towards the direction you want to, no matter which direction the object is facing.  This method
		 * updates all three rotation properties (rotationX, rotationY, and rotationZ).
		 * 
		 * @param targetObject Object to rotate.
		 * @param angle Angle to rotate in radians.
		 * @param axis Axis to rotate at.
		 * 
		 */
		public static function rotateArbitrary(targetObject:DisplayObject3D, angle:Number, axis:Axis3DSpace):void
		{
			
			// This updates transformation matrix values to match current rotationX, rotationY, and rotationZ values
			targetObject.copyTransform(targetObject);
			
			// Figure out rotation transformation 
			if (axis == null)
				axis = new Axis3DSpace(new Point3DSpace(0, 0, 0), new Point3DSpace(0, 0, 1));
			
			var direction:Number3D = new Number3D(-axis.dx, -axis.dy, axis.dz);
			var originPoint:Number3D = new Number3D(targetObject.x, targetObject.y, targetObject.z);
			
			var v:Number = Math.sqrt(direction.x * direction.x + direction.y * direction.y);
			var w:Number = Math.sqrt(v * v + direction.z * direction.z);
			
			var oF:Matrix3D = new Matrix3D([1,0,0,-originPoint.x,
											0,1,0,-originPoint.y,
											0,0,1,-originPoint.z,
											0,0,0,1]);
			
			var iF:Matrix3D = Matrix3D.inverse(oF);
			
			var oG:Matrix3D;
			
			if(v != 0)
			{
				
				oG = new Matrix3D([direction.x/v,direction.y/v,0,0,
								   -direction.y/v,direction.x/v,0,0,
								   0,0,1,0,
								   0,0,0,1]);
				
			}
			else
			{
				
				oG = Matrix3D.IDENTITY;
				
			}
			
			var iG:Matrix3D = Matrix3D.inverse(oG);
			
			var oH:Matrix3D = new Matrix3D([direction.z/w,0,-v/w,0,
											0,1,0,0,
											v/w,0,direction.z/w,0,
											0,0,0,1]);
			
			var iH:Matrix3D = Matrix3D.inverse(oH);
			
			var W:Matrix3D = new Matrix3D([Math.cos(angle),-Math.sin(angle),0,0,
										   Math.sin(angle),Math.cos(angle),0,0,
										   0,0,1,0,
										   0,0,0,1]);
			
			var P:Matrix3D = Matrix3D.multiply(Matrix3D.multiply(Matrix3D.multiply(Matrix3D.multiply(Matrix3D.multiply(Matrix3D.multiply(iF,iG),iH),W),oH),oG),oF);
			
			targetObject.transform.calculateMultiply(P, targetObject.transform);
			
			// This updates rotationX rotationY and rotationZ values
			targetObject.copyTransform(targetObject);
			
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
		public function DisplayObject3DTransformUtil()
		{
			
			throw("You do not create an instance of DisplayObject3DTransformUtil.  Just call its static functions");
			
		}
		
	}
	
}