/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.simplephysicsengine.utils
{
	
	import com.altoinu.flash.datamodels.Matrix3D;
	import com.altoinu.flash.datamodels.Plane3DSpace;
	import com.altoinu.flash.datamodels.Point3DSpace;
	import com.altoinu.flash.datamodels.Sphere3DSpace;
	import com.altoinu.flash.datamodels.Vector3DSpace;
	import com.altoinu.flash.simplephysicsengine.controllers.collision.SimplePhysicsObject3DHitArea;
	import com.altoinu.flash.simplephysicsengine.models.SimplePhysicsObject3DData;
	import com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D;
	
	/**
	 * Utility functions to do math involved in collisions in 3D space.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class CollisionMath
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Calculates final velocity vector if an object with <code>initialVelocity</code> vector deflects off of plane.
		 * 
		 * @param plane Plane to deflect off of.
		 * @param initialVelocity Velocity of the object.
		 * @param cor coefficient of restitution (COR), or bounciness, which is "fractional value representing the ratio of
		 * velocities after and before an impact" (http://en.wikipedia.org/wiki/Coefficient_of_Restitution). 1 would cause
		 * resulting Vector3DSpace to represent final velocity after elastic collision, while values &lt; 1 would make it
		 * inelastic collision. cor = 0 would make object stop at the collision surface. If value less than 0 is specified,
		 * it is automatically converted to 0.
		 * 
		 * @return 
		 * @see http://en.wikipedia.org/wiki/Deflection_%28physics%29
		 * 
		 */
		public static function getDeflection(plane:Plane3DSpace, initialVelocity:Vector3DSpace, cor:Number = 1):Vector3DSpace
		{
			
			//r=-2(i.n)n + i
			
			if (cor < 0)
				cor = 0;
			
			var n:Vector3DSpace = plane.normal;
			
			var dotProd:Number = Vector3DSpace.dotProduct(n, initialVelocity);
			var newVelocity:Vector3DSpace = new Vector3DSpace();
			newVelocity.x = (-2 * n.x * dotProd + initialVelocity.x) * cor;
			newVelocity.y = (-2 * n.y * dotProd + initialVelocity.y) * cor;
			newVelocity.z = (-2 * n.z * dotProd + initialVelocity.z) * cor;
			
			return newVelocity;
			
		}
		
		/**
		 * Deflects specified <code>ISimplePhysicsObject3D</code> against plane in 3D space. This changes the <code>velocity</code>
		 * value of the specified target.
		 * 
		 * <p>This method assumes target is touching the surface of the plane.</p>
		 * 
		 * @param target Object to apply deflection.
		 * @param plane Plane to deflect off of.
		 * @param cor coefficient of restitution (COR), or bounciness, which is "fractional value representing the ratio of
		 * velocities after and before an impact" (http://en.wikipedia.org/wiki/Coefficient_of_Restitution). 1 would cause
		 * resulting Vector3DSpace to represent final velocity after elastic collision, while values &lt; 1 would make it
		 * inelastic collision. cor = 0 would make object stop at the collision surface. If value less than 0 is specified,
		 * it is automatically converted to 0.
		 * 
		 */
		public static function applyDeflection(target:ISimplePhysicsObject3D, plane:Plane3DSpace, cor:Number = 1):void
		{
			
			var deflectionVector:Vector3DSpace = getDeflection(plane, target.velocity, cor);
			target.velocity.setValues(deflectionVector.x, deflectionVector.y, deflectionVector.z, target.rotationX, target.rotationY, target.rotationZ);
			
		}
		
		/**
		 * Calculates final velocity vector if a <code>deflectObj</code> with velocity <code>deflectObj.velocity</code> deflects off
		 * of <code>deflectSphere</code>.
		 * 
		 * <p>This method assumes that <code>deflectObj</code> is touching the surface of the deflectSphere.</p>
		 * 
		 * @param deflectSphere Sphere to deflect off of.
		 * @param deflectObj Object at coordinate <code>(deflectObj.x, deflectObj.y, deflectObj.z)</code> with velocity
		 * <code>deflectObj.velocity</code> to deflect.
		 * @param cor coefficient of restitution (COR), or bounciness, which is "fractional value representing the ratio of
		 * velocities after and before an impact" (http://en.wikipedia.org/wiki/Coefficient_of_Restitution). 1 would cause
		 * resulting Vector3DSpace to represent final velocity after elastic collision, while values &lt; 1 would make it
		 * inelastic collision. cor = 0 would make object stop at the collision surface. If value less than 0 is specified,
		 * it is automatically converted to 0.
		 * 
		 * @return 
		 * @see http://en.wikipedia.org/wiki/Deflection_%28physics%29
		 * 
		 */
		public static function getDeflectionAgainstSphere(deflectSphere:Sphere3DSpace, deflectObj:ISimplePhysicsObject3D, cor:Number = 1):Vector3DSpace
		{
			
			// Find plane normal to the point of contact
			var deflectionPointNormal:Vector3DSpace = new Vector3DSpace(deflectObj.x - deflectSphere.x,
																		deflectObj.y - deflectSphere.y,
																		deflectObj.z - deflectSphere.z);
			deflectionPointNormal.magnitude = deflectSphere.radius;
			
			// Point of deflection on the deflectSphere
			var deflectionPoint:Point3DSpace = new Point3DSpace(deflectSphere.x + deflectionPointNormal.x,
																deflectSphere.y + deflectionPointNormal.y,
																deflectSphere.z + deflectionPointNormal.z);
			var deflectionPlane:Plane3DSpace = new Plane3DSpace(deflectionPoint, deflectionPointNormal);
			
			return getDeflection(deflectionPlane, deflectObj.velocity, cor);
			
		}
		
		/**
		 * Deflects specified <code>ISimplePhysicsObject3D</code> against deflectSphere in 3D space. This method changes the
		 * <code>velocity</code> value and coordinate of the specified target.
		 * 
		 * @param target Object to apply deflection.
		 * @param deflectSphere Sphere to deflect off of.
		 * @param targetBaseHitArea Optional <code>SimplePhysicsObject3DHitArea</code> of <code>target</code>to base deflection off of.
		 * 
		 * <p>Default is null, which makes this method assume that the <code>target</code> is like a sphere with origin at
		 * <code>target</code>'s coordinate and radius as <code>(distance between target and deflectSphere) - deflectSphere.radius</code>
		 * (basically, a sphere touching the <code>deflectSphere</code> deflecting off of). If this hit area is defined, then the
		 * deflection is calculated based on that position of the <code>target</code> (ex. Deflection based off of the tip
		 * of rocket, instead of its origin coordinate).</p>
		 * 
		 * <p><code>baseHitArea</code>'s radius is also considered for calculation. So, if the radius is too small causing
		 * <code>baseHitArea</code> to not actually intersect with <code>deflectSphere</code>, then no deflection will occur and no
		 * values will be updated. If <code>baseHitArea.radius</code> is too large causing <code>baseHitArea</code> to overlap,
		 * then the method will offset the <code>target</code> accordingly.</p>
		 * 
		 * @param cor coefficient of restitution (COR), or bounciness, which is "fractional value representing the ratio of
		 * velocities after and before an impact" (http://en.wikipedia.org/wiki/Coefficient_of_Restitution). 1 would cause
		 * resulting Vector3DSpace to represent final velocity after elastic collision, while values &lt; 1 would make it
		 * inelastic collision. cor = 0 would make object stop at the collision surface. If value less than 0 is specified,
		 * it is automatically converted to 0.
		 * 
		 */
		public static function applyDeflectionAgainstSphere(target:ISimplePhysicsObject3D,
															deflectSphere:Sphere3DSpace,
															targetBaseHitArea:SimplePhysicsObject3DHitArea = null,
															cor:Number = 1):void
		{
			
			var deflectSpherePoint:Point3DSpace = new Point3DSpace(deflectSphere.x, deflectSphere.y, deflectSphere.z);
			
			// Base hit area
			if (targetBaseHitArea == null)
			{
				
				var targetPoint:Point3DSpace = new Point3DSpace(target.x, target.y, target.z);
				var targetToSphereDist:Number = targetPoint.distanceTo(deflectSpherePoint);
				
				var hitAreaRadius:Number;
				if (targetToSphereDist < deflectSphere.radius)
					hitAreaRadius = 0; // target is actually within the deflectSphere
				else
					hitAreaRadius = targetToSphereDist - deflectSphere.radius;
				
				targetBaseHitArea = new SimplePhysicsObject3DHitArea(0, 0, 0, hitAreaRadius);
				
			}
			
			// data representing position of target in global 3D space
			var actualTargetHitArea:SimplePhysicsObject3DData = new SimplePhysicsObject3DData();
			actualTargetHitArea.copyProperties(target);
			
			// offset actualTargetHitArea by wherever targetBaseHitArea is
			var worldM:Matrix3D = new Matrix3D();
			worldM.calculateMultiply(worldM, actualTargetHitArea.transform);
			
			var hitAreaM:Matrix3D = new Matrix3D();
			hitAreaM.copy(targetBaseHitArea.transform);
			hitAreaM.calculateMultiply(worldM, hitAreaM);
			
			actualTargetHitArea.transform.copy(hitAreaM);
			
			var hitPoint:Point3DSpace = new Point3DSpace(actualTargetHitArea.x, actualTargetHitArea.y, actualTargetHitArea.z);
			var hitPointToSphereDist:Number = hitPoint.distanceTo(deflectSpherePoint);
			
			if (hitPointToSphereDist <= (targetBaseHitArea.radius + deflectSphere.radius))
			{
				
				// target is touching the deflectSphere, so apply deflection
				if (hitPointToSphereDist < (targetBaseHitArea.radius + deflectSphere.radius))
				{
					
					// target is overlapping on the deflectSphere
					// TODO:
					//position = (1 / 2) * a * t * t + v * t + position0;
					//position distanceTo event.relativeHitArea[0] == position.radius + event.relativeHitArea[0].radius;
					
				}
				else
				{
					
					// target is touching the deflectSphere right on, no overlapping
					// actualTargetHitArea can be used as is
					
				}
				
				var newVelocityVector:Vector3DSpace = getDeflectionAgainstSphere(deflectSphere, actualTargetHitArea, cor);
				target.velocity.setValues(newVelocityVector.x, newVelocityVector.y, newVelocityVector.z,
										  target.velocity.rotationX, target.velocity.rotationY, target.velocity.rotationZ);
				
			}
			
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
		public function CollisionMath()
		{
			
			throw("You do not create an instance of CollisionMath.  Just call its static functions");
			
		}
		
	}
	
}