/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.utils
{
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class Camera3DUtils
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Positions the camera so the view will look like driver view position where camera is behind specified DisplayObject3D.
		 * 
		 * @param camera3D FreeCamera3D to be repositioned.
		 * @param target3DObject DisplayObject3D used as a reference point for camera3D to get driver view.
		 * @param unitsAboveObject Units above target3DObject camera3D will be placed at.  This is not necessarily the positive Y
		 * direction since it will depend on the direction target3DObject is facing.
		 * @param unitsBehindObject Units behind target3DObject camera3D will be placed at.
		 * 
		 * @param cameraPositionAngleOffsets Object in the form of {x: x angle, y: y angle, z: z angle} to specify how much angle to
		 * offset the camera positioning from target.  By setting one or more of these values, camera3D position behind the target3DObject
		 * can be offset so the view is not necessarily from directly behind but from sides.  For example, if you set y, camera3D will still be
		 * looking in the direction of target3DObject but from the side instead of directly behind.  You can use this parameter
		 * to do things like slightly showing the side of the car while it is turning, or have the camera follow the car from the side
		 * (90 degrees for y) or from the front (180 degrees for y).
		 * 
		 * @param cameraLookAngleOffsets Object in the form of {x: x angle, y: y angle, z: z angle} to specify how much angle to offset
		 * the direction camera is looking from the postion behind the target3DObject.  By setting one or more of these values, the direction
		 * camera3D can be offset after it is positioned behind the target3DObject.  You can use this parameter to do things like
		 * looking left and right from the driver view position.  The key difference between cameraPositionAngleOffsets and this parameter
		 * is that the former will always have target3DObject in the view no matter what angles are set but cameraLookAngleOffsets can lose
		 * it from the view because camera will look away from the target3DObject.
		 * 
		 * @param zoom Changes camera zoom if set to > 0.
		 * @param focus Changes camera focus if set to > 0.
		 */
		public static function setDriverViewPosition(camera3D:Camera3D, target3DObject:DisplayObject3D,
											  unitsAboveObject:Number = 0, unitsBehindObject:Number = 0,
											  cameraPositionAngleOffsets:Object = null, cameraLookAngleOffsets:Object = null,
											  zoom:Number = -1, focus:Number = -1):void
		{
			
			// First, make camera look at same direction from same spot as target3DObject
			//camera3D.copyPosition(target3DObject);
			camera3D.transform.copy(target3DObject.transform);
			camera3D.rotationX = target3DObject.rotationX;
			camera3D.rotationY = target3DObject.rotationY;
			camera3D.rotationZ = target3DObject.rotationZ;
			
			if (cameraPositionAngleOffsets != null)
			{
				
				// Offset camera look direction angle
				if (cameraPositionAngleOffsets.hasOwnProperty("x"))
					camera3D.rotationX -= cameraPositionAngleOffsets.x;
				
				if (cameraPositionAngleOffsets.hasOwnProperty("y"))
					camera3D.rotationY -= cameraPositionAngleOffsets.y;
				
				if (cameraPositionAngleOffsets.hasOwnProperty("z"))
					camera3D.rotationZ -= cameraPositionAngleOffsets.z;
				
			}
			
			// Then position it above target3DObject by units specified
			camera3D.moveUp(unitsAboveObject);
			
			// and behind target3DObject to the direction it is facing
			camera3D.moveBackward(unitsBehindObject);
			
			if (cameraLookAngleOffsets != null)
			{
				
				// Also, make camera look up/down at specified angle from the position above and behind the target3DObject
				if (cameraLookAngleOffsets.hasOwnProperty("x"))
					camera3D.rotationX += cameraLookAngleOffsets.x;
				
				if (cameraLookAngleOffsets.hasOwnProperty("y"))
					camera3D.rotationY += cameraLookAngleOffsets.y;
				
				if (cameraLookAngleOffsets.hasOwnProperty("z"))
					camera3D.rotationZ += cameraLookAngleOffsets.z;
				
			}
			
			// Set zoom and focus
			if (zoom >= 0)
				camera3D.zoom = zoom;
			
			if (focus >= 0)
				camera3D.focus = focus;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * Constructor.  You do not create an instance of this class... just call its static functions
		 */
		public function Camera3DUtils()
		{
			
			throw("You do not create an instance of Camera3DUtils.  Just call its static functions.");
			
		}
		
	}
	
}