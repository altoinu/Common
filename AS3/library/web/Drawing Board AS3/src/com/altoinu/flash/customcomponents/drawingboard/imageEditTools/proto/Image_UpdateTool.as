/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto
{
	
	/**
	 * Base class of image tools used on DrawingBoard that modifies the actual images by adding
	 * new or erasing existing images on DrawingLayer.
	 * 
	 * @see com.altoinu.flash.customcomponents.drawingboard.DrawingBoard
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class Image_UpdateTool extends Image_InteractTool
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Image_UpdateTool(updateShape:Class = null)
		{
			
			super();
			
			_updateShape = updateShape;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  updateShape
		//----------------------------------
		
		protected var _updateShape:Class;
		
		/**
		 * DisplayObject class used as shape of this update tool.
		 */
		public function get updateShape():Class
		{
			
			return _updateShape;
			
		}
		
	}
	
}