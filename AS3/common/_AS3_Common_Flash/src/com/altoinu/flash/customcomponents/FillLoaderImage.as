/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * Component to display portion of the specified image with specified mask on top to do
	 * "filling up" effect (ex. preloader).
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class FillLoaderImage extends Sprite
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param revealImage Image that is revealed as FillLoaderImage fills up.
		 * @param maskImage Image that is used as the mask to reveal revealImage as FillLoaderImage fills up.
		 * @param progress Number between 0 and 1 indicating the amount filled, where 0 is nothing and 1 is 
		 * completely filled.
		 * 
		 */
		public function FillLoaderImage(revealImage:DisplayObject, maskImage:DisplayObject, progress:Number = 0.5)
		{
			
			super();
			
			this.revealImage = revealImage;
			this.maskImage = maskImage;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  revealImage
		//----------------------------------
		
		private var _revealImage:DisplayObject;
		
		/**
		 * Image that is revealed as FillLoaderImage fills up. This image will be placed
		 * at 0, 0 in FillLoaderImage automatically.
		 */
		public function get revealImage():DisplayObject
		{
			
			return _revealImage;
			
		}
		
		/**
		 * @private
		 */
		public function set revealImage(newImage:DisplayObject):void
		{
			
			// Reveal previous image
			if ((revealImage != null) && (revealImage.parent != this))
				revealImage.parent.removeChild(revealImage);
			
			if (revealImage != null)
				revealImage.mask = null;
			
			_revealImage = newImage;
			
			// add image to bottom
			if (revealImage != null)
			{
				
				revealImage.x = 0;
				revealImage.y = 0;
				addChildAt(revealImage, 0);
				
				// set mask
				revealImage.mask = maskImage;
				
			}
			
			setMaskPosition();
			
		}
		
		//----------------------------------
		//  maskImage
		//----------------------------------
		
		private var _maskImage:DisplayObject;
		
		/**
		 * Image that is used as the mask to reveal revealImage as FillLoaderImage fills up.
		 * This image will be placed at 0, 0 in FillLoaderImage automatically.
		 */
		public function get maskImage():DisplayObject
		{
			
			return _maskImage;
			
		}
		
		/**
		 * @private
		 */
		public function set maskImage(newImage:DisplayObject):void
		{
			
			// Remove previous mask
			if ((maskImage != null) && (maskImage.parent != this))
				maskImage.parent.removeChild(maskImage);
			
			if (revealImage != null)
				revealImage.mask = null;
			
			_maskImage = newImage;
			
			// add image to top
			if (maskImage != null)
			{
				
				maskImage.x = 0;
				maskImage.y = 0;
				addChild(maskImage);
				
			}
			
			// Set new mask
			if (revealImage != null)
				revealImage.mask = maskImage;
			
			setMaskPosition();
			
		}
		
		//----------------------------------
		//  progress
		//----------------------------------
		
		private var _progress:Number = 0.5;
		
		/**
		 * Number between 0 and 1 indicating the amount filled, where 0 is nothing and 1 is 
		 * completely filled.
		 */
		public function get progress():Number
		{
			
			return _progress;
			
		}
		
		/**
		 * @private
		 */
		public function set progress(value:Number):void
		{
			
			if (value < 0)
				value = 0;
			else if (value > 1)
				value = 1;
			
			_progress = value;
			
			setMaskPosition();
			
		}
		
		//----------------------------------
		//  direction
		//----------------------------------
		
		private var _direction:String = FillLoaderImageDirection.UP;
		
		/**
		 * Direction of the fill. Possible values are FillLoaderImageDirection.RIGHT, FillLoaderImageDirection.LEFT,
		 * FillLoaderImageDirection.UP, and FillLoaderImageDirection.DOWN.
		 * 
		 * @default "up"
		 */
		public function get direction():String
		{
			
			return _direction;
			
		}
		
		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			
			if ((value != FillLoaderImageDirection.DOWN) && (value != FillLoaderImageDirection.LEFT) && (value != FillLoaderImageDirection.RIGHT) && (value != FillLoaderImageDirection.UP))
			{
				
				throw new Error("Specified direction \"" + value + "\" is not a valid value for FillLoaderImage.")
				
			}
			else
			{
				
				_direction = value;
				setMaskPosition();
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Positions mask at specified progress position and direction.
		 * 
		 */
		private function setMaskPosition():void
		{
			
			if (maskImage != null)
			{
				
				var revealWidth:Number = (revealImage != null ? revealImage.width : 0);
				var revealHeight:Number = (revealImage != null ? revealImage.height : 0);
				
				switch (direction)
				{
					
					case FillLoaderImageDirection.RIGHT:
					{
						
						maskImage.x = -maskImage.width + progress * revealWidth;
						maskImage.y = 0;
						break;
						
					}
					
					case FillLoaderImageDirection.LEFT:
					{
						
						maskImage.x = revealWidth - progress * revealWidth;
						maskImage.y = 0;
						break;
						
					}
					
					case FillLoaderImageDirection.DOWN:
					{
						
						maskImage.x = 0;
						maskImage.y = -maskImage.height + progress * revealHeight;
						break;
						
					}
					
					case FillLoaderImageDirection.UP:
					default:
					{
						
						maskImage.x = 0;
						maskImage.y = revealHeight - progress * revealHeight;
						break;
						
					}
					
				}
				
			}
			
		}
		
	}
	
}