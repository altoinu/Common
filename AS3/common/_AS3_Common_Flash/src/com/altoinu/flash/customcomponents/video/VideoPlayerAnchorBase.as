/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.video
{
	
	import com.altoinu.flash.customcomponents.supportClasses.AnchorBase;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 * Base class to serve as a guide for Video object so it appears wherever this Sprite object is placed.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 11.1
	 * @playerversion AIR 3.5
	 * @productversion Flex 4.6
	 */
	public class VideoPlayerAnchorBase extends AnchorBase
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function VideoPlayerAnchorBase()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var backgroundLayer:Sprite = new Sprite();
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  backgroundColor
		//--------------------------------------
		
		private var _backgroundColor:uint = 0x000000;
		
		public function get backgroundColor():uint
		{
			
			return _backgroundColor;
			
		}
		
		/**
		 * @private
		 */
		public function set backgroundColor(value:uint):void
		{
			
			if (_backgroundColor != value)
			{
				
				_backgroundColor = value;
				
				invalidateDisplay();
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplay():void
		{
			
			// Resize and fit video component
			super.updateDisplay();
			
			// then based off of resized video draw background to cover the area that does not have video displayed
			drawBackground();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function drawBackground():void
		{
			
			var g:Graphics = backgroundLayer.graphics;
			g.clear();
			
			g.lineStyle(0);
			g.beginFill(backgroundColor);
			
			g.drawRect(
				0, 0,
				isFinite(width) ? width : 0, isFinite(height) ? height: 0
			);
			
			g.endFill();
			
			// Add to back
			addChildAt(backgroundLayer, 0);
			
		}
		
	}
	
}