/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls.supportClasses
{
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	/**
	 * Base class to act as place holder for components. To be used for DisplayObject class not directly
	 * supported by Flex layout
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class HolderUIComponentBase extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function HolderUIComponentBase()
		{
			
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Proteceted properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  componentOnStage
		//--------------------------------------
		
		private var __componentOnStage:Boolean = false;
		
		[Bindable(event="componentOnStageChange")]
		private function get _componentOnStage():Boolean
		{
			
			return __componentOnStage;
			
		}
		
		/**
		 * @private
		 */
		private function set _componentOnStage(value:Boolean):void
		{
			
			if (__componentOnStage != value)
			{
				
				__componentOnStage = value;
				
				componentCreateOrDestroy();
				
				dispatchEvent(new Event("componentOnStageChange"));
				
			}
			
		}
		
		[Bindable(event="componentOnStageChange")]
		protected function get componentOnStage():Boolean
		{
			
			return __componentOnStage;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden public properites
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  enabled
		//--------------------------------------
		
		/**
		 * @private
		 */
		override public function set enabled(value:Boolean):void
		{
			
			super.enabled = value;
			
			componentCreateOrDestroy();
			
		}
		
		//--------------------------------------
		//  visible
		//--------------------------------------
		
		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			
			super.visible = value;
			
			invalidateDisplayList();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function componentCreateOrDestroy():void
		{
			
			// TODO: Currently if enabled set to false, this would destroyComponent().
			// We probably don't want to do that once we come up with a proper way to
			// destroy somewhere else
			if (componentOnStage && enabled)
				initializeComponent();
			else
				destroyComponent(); // not on stage, not enabled. Destroy
			
			invalidateDisplayList();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			resizeAndFitComponent(unscaledWidth, unscaledHeight);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes instance of component to be used on this UIComponent.
		 * 
		 */
		protected function initializeComponent():void {}
		
		/**
		 * Destroys instance of component.
		 * 
		 */
		protected function destroyComponent():void {}
		
		/**
		 * Resizes component to fit HolderUIComponentBase. This method is called at updateDisplayList.
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected function resizeAndFitComponent(unscaledWidth:Number, unscaledHeight:Number):void {}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns Rectangle to define area component should be displayed over.
		 * @return 
		 * 
		 */
		public function getViewRect():Rectangle
		{
			
			var tl:Point = localToGlobal(new Point(0, 0));
			var br:Point = localToGlobal(new Point(this.width, this.height));
			return new Rectangle(tl.x, tl.y, br.x - tl.x, br.y - tl.y);
			
			/*
			// top left and bottom right coordinates
			var topLeft:Point = new Point(0, 0);
			var bottomRight:Point = new Point(this.width, this.height);
			var v:Vector3DSpace = new Vector3DSpace(bottomRight.x - topLeft.x, bottomRight.y - topLeft.y);
			
			// global top left and bottom right coordinates
			var topLeft_global:Point = localToGlobal(topLeft);
			var bottomRight_global:Point = localToGlobal(bottomRight);
			var v_global:Vector3DSpace = new Vector3DSpace(bottomRight_global.x - topLeft_global.x, bottomRight_global.y - topLeft_global.y);
			
			// global mid point coordinates
			var mid_global:Point = new Point((bottomRight_global.x - topLeft_global.x) / 2, (bottomRight_global.y - topLeft_global.y) / 2);
			
			// Using vectors figure out to see if component is rotated on screen
			var angle:Number = Vector3DSpace.angleBetweenVectors(v, v_global);
			*/
			
			/*
			trace("==============" + angle, Vector3DSpace.angleToDegrees(angle));
			trace("-v");
			trace(topLeft, bottomRight);
			trace(v);
			trace("--global");
			trace(topLeft_global, bottomRight_global);
			trace(v_global);
			trace("---mid" + mid_global);
			*/
			
			/*
			v_global.rotateZ(-angle);
			var viewRect:Rectangle = new Rectangle(
				topLeft_global.x,
				topLeft_global.y,
				v_global.x,
				v_global.y
			);
			*/
			
			/*
			trace("-----" + v_global);
			trace(new Rectangle(topLeft_global.x, topLeft_global.y, bottomRight_global.x - topLeft_global.x, bottomRight_global.y - topLeft_global.y));
			trace(viewRect);
			*/
			
			//return viewRect;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onAddedToStage(event:Event):void
		{
			
			_componentOnStage = true;
			
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			
			_componentOnStage = false;
			
		}
		
	}
	
}