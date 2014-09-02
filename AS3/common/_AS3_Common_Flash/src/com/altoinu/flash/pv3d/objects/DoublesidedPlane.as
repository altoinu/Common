/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.objects
{
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	/**
	 * Double sided Plane, that uses MaterialsList "front" and "back."
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DoublesidedPlane extends DisplayObject3D 
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates a double sided plane.
		 * @param materialsList Material to use for "front" and "back."
		 * @param width
		 * @param height
		 * @param segmentsW
		 * @param segmentsH
		 * @param name
		 * @param interactive
		 * 
		 */
		public function DoublesidedPlane(materialsList:MaterialsList = null, width:Number = 0, height:Number = 0, segmentsW:Number = 1, segmentsH:Number = 1, name:String = null, interactive:Boolean = false)
		{
			
			super(name);
			
			_front = new Plane(materialsList.getMaterialByName("front"), width, height, segmentsW, segmentsH);
			_front.material.doubleSided = false;
			_front.material.smooth = true;
			_front.material.interactive = interactive;
			_front.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, rethrowEvent);
			_front.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, rethrowEvent);
			_front.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, rethrowEvent);
			this.addChild(_front, "front");
			
			_back = new Plane(materialsList.getMaterialByName("back"), width, height, segmentsW, segmentsH);
			_back.material.doubleSided = false;
			_back.material.smooth = true;
			_back.material.interactive = interactive;
			//_back.material.opposite = true;
			_back.rotationY =180;
			_back.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, rethrowEvent);
			_back.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, rethrowEvent);
			_back.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, rethrowEvent);
			this.addChild(_back, "back");
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Whether or not the DoublesidedPlane is interactive.
		 */
		public function get interactive():Boolean
		{
			
			return _front.material.interactive;
			
		}
		
		/**
		 * @private
		 */
		public function set interactive(value:Boolean):void
		{
			
			_front.material.interactive = value;
			_back.material.interactive = value;
			
		}
		
		//----------------------------------
		//  front
		//----------------------------------
		
		private var _front:Plane;
		
		/**
		 * Front side plane.
		 */
		public function get front():Plane
		{
			
			return _front;
			
		}
		
		//----------------------------------
		//  back
		//----------------------------------
		
		private var _back:Plane;
		
		/**
		 * Backside plane.
		 */
		public function get back():Plane
		{
			
			return _back;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function rethrowEvent(event:InteractiveScene3DEvent):void
		{
			
			var evt:InteractiveScene3DEvent = new InteractiveScene3DEvent(event.type, this, event.sprite, event.face3d, event.x, event.y, event.renderHitData, event.bubbles, event.cancelable);
			dispatchEvent(evt);
			
		}
		
	}
	
}