/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	/**
	 * Utility functions you can use on BitmapData.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class BitmapDataUtils
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns a new BitmapData which is a copy of specified BitmapData resized to specified size.
		 * 
		 * @param sourceBitmapData Source BitmapData to create scaled BitmapData from.
		 * @param newWidth Width of the new BitmapData.
		 * @param newHeight Height of the new BitmapData.
		 * @param transparent
		 * @param fillColor
		 * @param smoothing
		 * @param maintainAspectRatio true/false to maintain or stretch the BitmapData. If set to false, then the resulting
		 * BitmapData will be stretched to fill the entire area. If set to true, then resulting BitmapData
		 * is scaled to fit into the center of the specified area without aspect ratio changing and any empty area filled
		 * with fillColor.
		 * @return 
		 * 
		 */
		public static function resize(sourceBitmapData:BitmapData, newWidth:Number, newHeight:Number, transparent:Boolean = true, fillColor:uint = 0x000000, smoothing:Boolean = false, maintainAspectRatio:Boolean = true):BitmapData
		{
			
			// Create a temporary bitmap and scale to new size
			var tempBitmap:Bitmap = new Bitmap(sourceBitmapData, "auto", smoothing);
			
			var xScaling:Number = newWidth / tempBitmap.width;
			var yScaling:Number = newHeight / tempBitmap.height;
			
			if (maintainAspectRatio)
			{
				
				tempBitmap.scaleX = (xScaling < yScaling) ? xScaling : yScaling;
				tempBitmap.scaleY = tempBitmap.scaleX;
				
			}
			else
			{
				
				tempBitmap.scaleX = xScaling;
				tempBitmap.scaleY = yScaling;
				
			}
			
			// Center bitmap
			var tempBitmapContainer:Sprite = new Sprite();
			tempBitmapContainer.addChild(tempBitmap);
			tempBitmap.x = newWidth / 2 - tempBitmap.width / 2;
			tempBitmap.y = newHeight / 2 - tempBitmap.height / 2;
			
			// Create new bitmapdata from tempBitmapContainer
			var newBitmapData:BitmapData = new BitmapData(newWidth, newHeight, transparent, fillColor);
			newBitmapData.draw(tempBitmapContainer);
			
			return newBitmapData;
			
		}
		
		[Deprecated(replacement="com.altoinu.flash.utils.ColorUtils.separateARGBValue()")]
		/**
		 * Given ARGB hex number color code (ex. 0xFFFFFFFF for white), returns Array containing values for alpha, red, green and blue.
		 * This would be useful if you want to check on specific color channel or alpha level.
		 * <pre>
		 * if (alphaValue &lt; 0x88) // If alpha value is less than 128 (50%)
		 * </pre>
		 * 
		 * @param color
		 * @return Four element Array containing uint values for each color in form: [alpha, red, green, blue]
		 * 
		 */
		public static function separateARGBValue(color:uint):Array
		{
			
			return ColorUtils.separateARGBValue(color);
			
			/*
			var alphaValue:uint = color >>> 24;
			var redValue:uint = color >>> 16 & 0xFF;
			var greenValue:uint = color >>> 8 & 0xFF;
			var blueValue:uint = color & 0xFF;
			
			return [alphaValue, redValue, greenValue, blueValue];
			*/
			
		}
		
		[Deprecated(replacement="com.altoinu.flash.utils.ColorUtils.buildARGBColorValue()")]
		/**
		 * Given four hex number between 0x00 and 0xFF (0 and 255), returns full combined ARGB value.
		 * @param alphaValue
		 * @param redValue
		 * @param greenValue
		 * @param blueValue
		 * @return 
		 * 
		 */
		public static function buildARGBColorValue(alphaValue:uint = 0x00, redValue:uint = 0x00, greenValue:uint = 0x00, blueValue:uint = 0x00):uint
		{
			
			return ColorUtils.buildARGBColorValue(alphaValue, redValue, greenValue, blueValue);
			
			/*
			if (alphaValue > 0xFF)
			alphaValue = 0xFF;
			if (redValue > 0xFF)
			redValue = 0xFF;
			if (greenValue > 0xFF)
			greenValue = 0xFF;
			if (blueValue > 0xFF)
			blueValue = 0xFF;
			
			return alphaValue << 24 | redValue << 16 | greenValue << 8 | blueValue;
			*/
			
		}
		
		/**
		 * Using multiple BitmapData provided in Array, builds one single BitmapData with all of those in it.
		 * 
		 * <p>Note: all images will be scaled to same size to fit into the specified number of rows and columns.</p>
		 * 
		 * @param sourceBitmapData Array of source BitmapData. If number of BitmapData is less than rows * columns, then
		 * the empty area will remain blank (transparent or fillColor-ed). If it is larger, then all images at indices
		 * larger than rows * columns are ignored.
		 * @param width Width of the resulting BitmapData.
		 * @param height Height of the resulting BitmapData.
		 * @param direction Direction to fill collage with sourceBitmapData, either BitmapDataUtilsCollageDirection.HORIZONTAL
		 * or BitmapDataUtilsCollageDirection.VERTICAL. Default is "horizontal."
		 * @param rows Number of rows.
		 * @param columns Number of columns.
		 * @param transparent
		 * @param fillColor
		 * @param smoothing
		 * @param maintainAspectRatio true/false to maintain or stretch each BitmapData. If set to false, then the resulting
		 * BitmapData for each sourceBitmapData will be stretched to fill the area for it. If set to true, then resulting BitmapData
		 * is scaled to fit into the center of the specified area without aspect ratio changing and any empty area filled
		 * with fillColor.
		 * @return 
		 * 
		 */
		public static function buildCollage(sourceBitmapData:Array, width:Number, height:Number, direction:String = "horizontal", rows:int = 4, columns:int = 2, transparent:Boolean = true, fillColor:uint = 0x000000, smoothing:Boolean = false, maintainAspectRatio:Boolean = true):BitmapData
		{
			
			var collage:BitmapData = new BitmapData(width, height, transparent, fillColor);
			
			if (rows <= 0)
			{
				
				throw new Error("0 or negative rows is not allowed.");
				return null;
				
			}
			
			if (columns <= 0)
			{
				
				throw new Error("0 or negative columns is not allowed.");
				return null;
				
			}
			
			if ((direction != BitmapDataUtilsCollageDirection.HORIZONTAL) && (direction != BitmapDataUtilsCollageDirection.VERTICAL))
				direction = BitmapDataUtilsCollageDirection.HORIZONTAL;
			
			var imageWidth:Number = width / columns;
			var imageHeight:Number = height / rows;
			
			var tempBitmapData:BitmapData;
			var currentRow:int = 0;
			var currentCol:int = 0;
			var numSources:int = sourceBitmapData.length;
			for (var i:int = 0; i < numSources; i++)
			{
				
				tempBitmapData = resize(sourceBitmapData[i], imageWidth, imageHeight, transparent, fillColor, smoothing, maintainAspectRatio);
				var copyToPoint:Point = new Point(currentCol * imageWidth, currentRow * imageHeight);
				collage.copyPixels(tempBitmapData, new Rectangle(0, 0, imageWidth, imageHeight), copyToPoint);
				
				if (direction == BitmapDataUtilsCollageDirection.VERTICAL)
				{
					
					currentRow++;
					if (rows <= currentRow)
					{
						
						currentRow = 0;
						currentCol++;
						
						if (columns <= currentCol)
							break; // No more space to fit
						
					}
					
				}
				else
				{
					
					currentCol++;
					if (columns <= currentCol)
					{
						
						currentCol = 0;
						currentRow++;
						
						if (rows <= currentRow)
							break; // No more space to fit
						
					}
					
				}
				
			}
			
			return collage;
			
		}
		
		/**
		 * A utility method to grab a raw snapshot of a UI component as BitmapData.
		 * 
		 * @param source A UI component that implements <code>flash.display.IBitmapDrawable</code>
		 * @param matrix A Matrix object used to scale, rotate, or translate the
		 * coordinates of the captured bitmap. If you do not want to apply a matrix
		 * transformation to the image, set this parameter to an identity matrix,
		 * created with the default new Matrix() constructor, or pass a null value.
		 * @param colorTransform
		 * @param blendMode
		 * @param clipRect
		 * @param smoothing
		 * @param transparent
		 * @param fillColor
		 * @return BitmapData representing the captured snapshot.
		 */
		public static function captureBitmapData(source:IBitmapDrawable, matrix:Matrix=null,
												 colorTransform:ColorTransform=null, blendMode:String=null,
												 clipRect:Rectangle=null, smoothing:Boolean=false,
												 transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF):BitmapData
		{
			var data:BitmapData;
			
			var width:int = source["width"];
			var height:int = source["height"];
			
			// We default to an identity matrix which will match screen resolution
			if (matrix == null)
				matrix = new Matrix(1, 0, 0, 1);
			
			var scaledWidth:Number = width * matrix.a;
			var scaledHeight:Number = height * matrix.d;
			var reductionScale:Number = 1;
			
			// Cap width to BitmapData max of 2880 pixels
			if (scaledWidth > MAX_BITMAP_DIMENSION)
			{
				reductionScale = scaledWidth / MAX_BITMAP_DIMENSION;
				scaledWidth = MAX_BITMAP_DIMENSION;
				scaledHeight = scaledHeight / reductionScale;
				
				matrix.a = scaledWidth / width;
				matrix.d = scaledHeight / height;
			}
			
			// Cap height to BitmapData max of 2880 pixels
			if (scaledHeight > MAX_BITMAP_DIMENSION)
			{
				reductionScale = scaledHeight / MAX_BITMAP_DIMENSION;
				scaledHeight = MAX_BITMAP_DIMENSION;
				scaledWidth = scaledWidth / reductionScale;
				
				matrix.a = scaledWidth / width;
				matrix.d = scaledHeight / height;
			}
			
			data = new BitmapData(scaledWidth, scaledHeight, transparent, fillColor);
			data.draw(source, matrix, colorTransform, blendMode, clipRect, smoothing);
			
			return data;
		}
		
		/**
		 * A utility method to grab a snapshot of a component, scaled to a specific
		 * resolution (in dpi).
		 * 
		 * @param source A UI component that implements <code>flash.display.IBitmapDrawable</code>
		 * @param dpi The resolution in dots per inch. If a resolution is not
		 * provided the current on-screen resolution is used by default.
		 * @param scaleLimited  The maximum width or height of a bitmap in Flash is
		 * 2880 pixels - if scaleLimited is set to true the resolution will be
		 * reduced proportionately to fit within 2880 pixels, otherwise, if
		 * scaleLimited is false, smaller snapshot windows will be taken and
		 * stitched together to capture a larger image. The default is true.
		 * @param smoothing
		 * @param transparent
		 * @param fillColor
		 * @return A ByteArray holding an encoded captured snapshot and
		 * associated image metadata.
		 */
		public static function captureImage(source:IBitmapDrawable, dpi:Number=0, scaleLimited:Boolean=true,
											smoothing:Boolean = false, transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF):ByteArray
		{
			
			// Calculate scaling factor based on current screen resolution (dpi)
			var screenDPI:Number = Capabilities.screenDPI;
			if (dpi <= 0)
				dpi = screenDPI;
			
			// Create a transformation matrix to scale image to desired resolution
			var scale:Number = dpi / screenDPI;    
			var matrix:Matrix = new Matrix(scale, 0, 0, scale);
			
			var width:int = source["width"] * matrix.a;
			var height:int = source["height"] * matrix.d;
			
			var bytes:ByteArray;
			
			// If scaleLimited, we limit snapshot to a maximum of 2880x2880
			// pixels irrespective of the requested dpi
			if (scaleLimited || (width <= MAX_BITMAP_DIMENSION && height <= MAX_BITMAP_DIMENSION))
			{
				var data:BitmapData = captureBitmapData(source, matrix, null, null, null, smoothing, transparent, fillColor);
				var bitmap:Bitmap = new Bitmap(data);
				bytes = data.getPixels(new Rectangle(0, 0, bitmap.width, bitmap.height));
			}
			else
			{
				// We scale to the requested dpi and try to capture the
				// entire snapshot as a raw bitmap ByteArray
				var bounds:Rectangle = new Rectangle(0, 0, width, height);
				bytes = captureAll(source, bounds, matrix, null, null, null, smoothing, transparent, fillColor);
			}
			
			return bytes;
		}
		
		private static const MAX_BITMAP_DIMENSION:int = 2880;
		
		/**
		 * Attempts to capture as much of an image for the requested bounds by
		 * splitting the scaled source into rectangular windows that fit inside
		 * the maximum size of a single BitmapData instance, i.e. 2880x2880 pixels,
		 * and stitching the windows together into a larger bitmap with the raw
		 * pixels returned as a ByteArray. This ByteArray is limited to around
		 * 256MB so scaled images with an area equivalent to about 8192x8192 will
		 * result in out of memory errors.
		 */
		private static function captureAll(source:*, bounds:Rectangle, matrix:Matrix,
										   colorTransform:ColorTransform=null, blendMode:String=null,
										   clipRect:Rectangle=null, smoothing:Boolean=false,
										   transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF):ByteArray
		{
			var currentMatrix:Matrix = matrix.clone();
			var topLeft:Rectangle = bounds.clone();
			var topRight:Rectangle;
			var bottomLeft:Rectangle;
			var bottomRight:Rectangle;
			
			// Check if the requested bounds exceeds the maximum width for 
			// a bitmap...
			if (bounds.width > MAX_BITMAP_DIMENSION)
			{
				topLeft.width = MAX_BITMAP_DIMENSION;
				
				topRight = new Rectangle();
				topRight.x = topLeft.width;
				topRight.y = bounds.y;
				topRight.width = bounds.width - topLeft.width;
				topRight.height = bounds.height;
			}
			
			// Check if the requested bounds exceeds the maximum height for 
			// a bitmap...
			if (bounds.height > MAX_BITMAP_DIMENSION)
			{
				topLeft.height = MAX_BITMAP_DIMENSION;
				if (topRight != null)
					topRight.height = topLeft.height;
				
				bottomLeft = new Rectangle();
				bottomLeft.x = bounds.x;
				bottomLeft.y = topLeft.height;
				bottomLeft.width = topLeft.width;
				bottomLeft.height = bounds.height - topLeft.height;
				
				if (bounds.width > MAX_BITMAP_DIMENSION)
				{
					bottomRight = new Rectangle();
					bottomRight.x = topLeft.width;
					bottomRight.y = topLeft.height;
					bottomRight.width = bounds.width - topLeft.width;
					bottomRight.height = bounds.height - topLeft.height;
				}
			}
			
			// Capture top-left window
			currentMatrix.translate(-topLeft.x, -topLeft.y);
			topLeft.x = 0;
			topLeft.y = 0;
			var data:BitmapData = new BitmapData(topLeft.width, topLeft.height, transparent, fillColor);
			data.draw(source, currentMatrix, colorTransform, blendMode, clipRect, smoothing);
			var pixels:ByteArray = data.getPixels(topLeft);
			pixels.position = 0;
			
			// If bounds width exceeded maximum dimensions for a bitmap, we 
			// also need to capture the top-right window (recursively, until we
			// have a window width less that the max). These right side rows have
			// to be merged to the right of each left side row.
			if (topRight != null)
			{
				currentMatrix = matrix.clone();
				currentMatrix.translate(-topRight.x, -topRight.y);
				topRight.x = 0;
				topRight.y = 0;
				var topRightPixels:ByteArray = captureAll(source, topRight, currentMatrix);
				pixels = mergePixelRows(pixels, topLeft.width, topRightPixels, topRight.width, topRight.height);
			}
			
			// If bounds height exceeded the maximum dimension for a bitmap, we
			// also need to capture the bottom-left window (recursively, until we
			// have a window height less than the max). These rows are appended 
			// to the end of the current 32-bit, 4 channel bitmap as a ByteArray.
			if (bottomLeft != null)
			{
				currentMatrix = matrix.clone();
				currentMatrix.translate(-bottomLeft.x, -bottomLeft.y);
				bottomLeft.x = 0;
				bottomLeft.y = 0;
				var bottomLeftPixels:ByteArray = captureAll(source, bottomLeft, currentMatrix);
				
				// If both the bounds width and bounds height exceeded the maximum
				// dimensions for a bitmap, we now must to capture the bottom-right
				// window (recursively, until we have a window with less than the
				// max width and/or height). These right side rows have to be merged
				// to the right of each left side row.
				if (bottomRight != null)
				{
					currentMatrix = matrix.clone();
					currentMatrix.translate(-bottomRight.x, -bottomRight.y);
					bottomRight.x = 0;
					bottomRight.y = 0;
					var bottomRightPixels:ByteArray = captureAll(source, bottomRight, currentMatrix);
					bottomLeftPixels = mergePixelRows(bottomLeftPixels, bottomLeft.width, bottomRightPixels, bottomRight.width, bottomRight.height);
				}
				
				// Append bottomLeft pixels to the end of the ByteArray of pixels
				pixels.position = pixels.length;
				pixels.writeBytes(bottomLeftPixels);
			}
			pixels.position = 0;
			
			return pixels;
		}
		
		/**
		 * @private
		 * Copies the rows of the right hand side of an image onto the ends of
		 * the rows of the left hand side of an image. The left and right hand
		 * sides must be of equal height.
		 */
		private static function mergePixelRows(left:ByteArray, leftWidth:int,
											   right:ByteArray, rightWidth:int, rightHeight:int):ByteArray
		{
			var merged:ByteArray = new ByteArray();
			var leftByteWidth:int = leftWidth*4;
			var rightByteWidth:int = rightWidth*4;
			
			for (var i:int = 0; i < rightHeight; i++)
			{
				merged.writeBytes(left, i*leftByteWidth, leftByteWidth); 
				merged.writeBytes(right, i*rightByteWidth, rightByteWidth);
			}
			
			merged.position = 0;
			return merged;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BitmapDataUtils()
		{
			
			throw("You do not create an instance of BitmapDataUtils.  Just call its static functions");
			
		}
		
	}
	
}