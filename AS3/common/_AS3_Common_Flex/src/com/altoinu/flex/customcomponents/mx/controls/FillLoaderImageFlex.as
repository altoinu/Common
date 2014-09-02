/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls
{
	
	import com.altoinu.flash.customcomponents.FillLoaderImage;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	/**
	 * FillLoaderImage Flex component.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @see com.altoinu.flash.customcomponents.FillLoaderImage
	 */
	public class FillLoaderImageFlex extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private const FILLIMAGE:FillLoaderImage = new FillLoaderImage(new Sprite(), new Sprite(), 0);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function FillLoaderImageFlex()
		{
			
			super();
			
			addChild(FILLIMAGE);
			
			revealImage = revealImage;
			maskImage = maskImage;
			progress = progress;
			direction = direction;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  revealImage
		//----------------------------------
		
		[Bindable(event="revealImageChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.FillLoaderImage#revealImage
		 */
		public function get revealImage():DisplayObject
		{
			
			return FILLIMAGE.revealImage;
			
		}
		
		/**
		 * @private
		 */
		public function set revealImage(newImage:DisplayObject):void
		{
			
			FILLIMAGE.revealImage = newImage;
			
			dispatchEvent(new Event("revealImageChange"));
			
		}
		
		//----------------------------------
		//  maskImage
		//----------------------------------
		
		[Bindable(event="maskImageChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.FillLoaderImage#maskImage
		 */
		public function get maskImage():DisplayObject
		{
			
			return FILLIMAGE.maskImage;
			
		}
		
		/**
		 * @private
		 */
		public function set maskImage(newImage:DisplayObject):void
		{
			
			FILLIMAGE.maskImage = newImage;
			
			dispatchEvent(new Event("maskImageChange"));
			
		}
		
		//----------------------------------
		//  progress
		//----------------------------------
		
		[Bindable(event="progressChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.FillLoaderImage#progress
		 */
		public function get progress():Number
		{
			
			return FILLIMAGE.progress;
			
		}
		
		/**
		 * @private
		 */
		public function set progress(value:Number):void
		{
			
			FILLIMAGE.progress = value;
			
			dispatchEvent(new Event("progressChange"));
			
		}
		
		//----------------------------------
		//  direction
		//----------------------------------
		
		[Bindable(event="directionChange")]
		[Inspectable(category="General", enumeration="left,right,up,down", defaultValue="up")]
		/**
		 * @copy com.altoinu.flash.customcomponents.FillLoaderImage#direction
		 */
		public function get direction():String
		{
			
			return FILLIMAGE.direction;
			
		}
		
		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			
			FILLIMAGE.direction = value;
			
			dispatchEvent(new Event("directionChange"));
			
		}
		
	}
	
}