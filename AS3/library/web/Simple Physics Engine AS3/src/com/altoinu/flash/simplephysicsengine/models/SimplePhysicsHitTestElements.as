/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.simplephysicsengine.models
{
	
	import com.altoinu.flash.simplephysicsengine.controllers.collision.SimplePhysicsObject3DHitArea;
	
	/**
	 * Data model to hold info used for hit tests.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class SimplePhysicsHitTestElements
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SimplePhysicsHitTestElements(currentTargetHitAreas:Vector.<SimplePhysicsObject3DHitArea> = null, collidedTargetHitAreas:Vector.<SimplePhysicsObject3DHitArea> = null)
		{
			
			if (currentTargetHitAreas == null)
				currentTargetHitAreas = new Vector.<SimplePhysicsObject3DHitArea>();
			
			if (collidedTargetHitAreas == null)
				collidedTargetHitAreas = new Vector.<SimplePhysicsObject3DHitArea>();
			
			this.currentTargetHitAreas = currentTargetHitAreas;
			this.collidedTargetHitAreas = collidedTargetHitAreas;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Array of SimplePhysicsObject3DHitArea of current ISimplePhysicsObject3D involved in the <code>isColliding</code>.
		 * Immediately after <code>isColliding</code>, this Array will hold SimplePhysicsObject3DHitArea that made
		 * <code>isColliding</code> true if any.
		 */
		public var currentTargetHitAreas:Vector.<SimplePhysicsObject3DHitArea>;
		
		/**
		 * Array of SimplePhysicsObject3DHitArea of ISimplePhysicsObject3D that collided into current object in the <code>isColliding</code>.
		 * Immediately after <code>isColliding</code>, this Array will hold SimplePhysicsObject3DHitArea that made
		 * <code>isColliding</code> true if any.
		 */
		public var collidedTargetHitAreas:Vector.<SimplePhysicsObject3DHitArea>;
		
	}
	
}