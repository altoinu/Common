/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.drawingboard
{
	
	import flash.display.DisplayObject;
	
	/**
	 * Interface for a class that can have images drawn into.
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface IDrawable
	{
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds <code>DisplayObject</code> to specified location.
		 *
		 * @param drawingItem <code>DisplayObject</code> to be placed on the layer.
		 * @param xLoc x coordinate.
		 * @param yLoc y coordinate.
		 * @param Xloc z location, which is the order of placement.  i+1th element will be on top of ith element.
		 * If set to &lt; 0, then the drawingItem will be placed on top of existing DisplayObjects.
		 *
		 * @return Reference to the DisplayObject drawingItem.
		 */
		function drawItemAt(drawingItem:DisplayObject, xLoc:Number = 0, yLoc:Number = 0, zLoc:Number = -1):DisplayObject
		
		/**
		 * Adds drawing item on top of existing images at coordinate 0, 0.
		 * 
		 * @param drawingItem Drawing item to be placed.
		 *
		 * @return Reference to the DisplayObject drawingItem.
		 */
		function drawItem(drawingItem:DisplayObject):DisplayObject;
		
		/**
		 * Erases (removeChild) drawing item(s) that are within erasing area defined by parameters.
		 * Any <code>DisplayObject</code> that is within the specified area will be removed.
		 * 
		 * <p>If <code>DisplayObject</code> that is within the specified area is a <code>Bitmap</code> and if
		 * <code>eraseShape</code> is defined, then the that <code>DisplayObject</code> gets pixels
		 * that overlap <code>eraseShape</code> set to transparent (alpha=0) instead of entire Bitmap being
		 * removed right away (entire Bitmap is removed if all pixels have become transparent).  This way, complex
		 * shaped eraser can be used.</p>
		 * 
		 * @param xLoc x coordinate of the erasing area (Left edge).
		 * @param yLoc y coordinate of the erasing area (Top edge).
		 * @param eraseAreaWidth Width of the erasing area.
		 * @param eraseAreaHeight Height of the erasing area.
		 * @param eraseShape Shape of the eraser.  This is only effective on drawing images that are Bitmap.
		 *
		 * @return Object containing two Arrays, Object.bitmaps which contains Bitmaps affected by this operation
		 * and Object.nonBitmaps which contains non-Bitmaps removed.
		 */
		function eraseItemsAt(xLoc:Number, yLoc:Number, eraseAreaWidth:Number = 0, eraseAreaHeight:Number = 0, eraseShape:Class = null):Object
		
	}
	
}