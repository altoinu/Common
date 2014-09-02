/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.drawingboard.imageEditTools
{
	
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 * DrawingTool with color transform option.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ColorBrushTool extends DrawingTool
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 *
		 * @param drawImage Class which this DraingTool will place on the DrawingBoard.  This must be DisplayObject or class that
		 * is based on it.
		 * @param color Color of the brush.
		 * 
		 */
		public function ColorBrushTool(drawImage:Class, color:uint = 0x000000)
		{
			
			super(drawImage);
			
			this.color = color;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Color transform to apply to the drawing image.  Set this to null to apply no color transform.
		 */
		public var colorTransform:ColorTransform = new ColorTransform();
		
		//----------------------------------
		//  color
		//----------------------------------
		
		/**
		 * Color of the brush.  Changing this value will cause color set for <code>colorTransform</code>
		 * to change.
		 * 
		 * @default 0x000000 (Black)
		 */
		public function get color():uint
		{
			
			if (colorTransform != null)
				return colorTransform.color;
			else
				return null;
			
		}
		
		/**
		 * @private
		 */
		public function set color(newColor:uint):void
		{
			
			if (colorTransform != null)
				colorTransform = new ColorTransform(); // Make new ColorTransform object to apply color.
			
			colorTransform.color = newColor;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function generateNewDrawingImage():DisplayObject
		{
			
			var newDrawingItem:DisplayObject = super.generateNewDrawingImage();
			
			if (colorTransform != null)
				newDrawingItem.transform.colorTransform = colorTransform; // Apply color transform
			
			return newDrawingItem;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():DrawingTool
		{
			
			var newTool:ColorBrushTool = super.clone() as ColorBrushTool;
			newTool.color = color;
			
			return newTool;
			
		}
		
	}
	
}