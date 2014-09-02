/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.supportClasses
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AnchorBase extends Sprite
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AnchorBase()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var invalidateDisplayFlag:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  width
		//--------------------------------------
		
		private var _width:Number = NaN;
		
		override public function get width():Number
		{
			
			return _width;
			
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			
			if (_width != value)
			{
				
				_width = value;
				invalidateDisplay();
				
			}
			
		}
		
		//--------------------------------------
		//  height
		//--------------------------------------
		
		private var _height:Number = NaN;
		
		override public function get height():Number
		{
			
			return _height;
			
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			
			if (_height != value)
			{
				
				_height = value;
				invalidateDisplay();
				
			}
			
		}
		
		//--------------------------------------
		//  scaleX
		//--------------------------------------
		
		override public function get scaleX():Number
		{
			
			return super.scaleX;
			
		}
		
		/**
		 * @private
		 */
		override public function set scaleX(value:Number):void
		{
			
			if (super.scaleX != value)
			{
				
				super.scaleX = value;
				invalidateDisplay();
				
			}
			
		}
		
		//--------------------------------------
		//  scaleY
		//--------------------------------------
		
		override public function get scaleY():Number
		{
			
			return super.scaleY;
			
		}
		
		/**
		 * @private
		 */
		override public function set scaleY(value:Number):void
		{
			
			if (super.scaleY != value)
			{
				
				super.scaleY = value;
				invalidateDisplay();
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function updateDisplay():void
		{
			
			// Resize and fit component
			resizeAndFitComponent();
			
		}
		
		/**
		 * Override this method to do layout.
		 * 
		 */
		protected function resizeAndFitComponent():void {}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Marks this element as display list need update in next frame cycle
		 * 
		 */
		public function invalidateDisplay():void
		{
			
			if (!invalidateDisplayFlag)
			{
				
				invalidateDisplayFlag = true;
				
				this.addEventListener(Event.ENTER_FRAME, onEnterFrameValidateNow, false, 0, true);
				
			}
			
		}
		
		/**
		 * If this element is marked as display list need update (from invalidateDisplay())
		 * then display list will be updated
		 * 
		 */
		public function validateNow():void       
		{
			
			if (invalidateDisplayFlag)
			{
				
				updateDisplay();
				
				invalidateDisplayFlag = false;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onEnterFrameValidateNow(event:Event):void
		{
			
			EventDispatcher(event.currentTarget).removeEventListener(Event.ENTER_FRAME, onEnterFrameValidateNow, false);
			
			validateNow();
			
		}
		
	}
	
}