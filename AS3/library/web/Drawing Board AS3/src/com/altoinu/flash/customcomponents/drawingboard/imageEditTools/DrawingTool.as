﻿/** * This Source Code Form is subject to the terms of the Mozilla Public * License, v. 2.0. If a copy of the MPL was not distributed with this file, * You can obtain one at http://mozilla.org/MPL/2.0/. *  * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com */package com.altoinu.flash.customcomponents.drawingboard.imageEditTools{			import com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent;
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_UpdateTool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;	import com.altoinu.flash.customcomponents.drawingboard.IDrawable;
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard;
		//--------------------------------------	//  Events	//--------------------------------------		/**	 *  Dispatched when DrawingTool draws.	 *	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.DRAW	 */	[Event(name="draw", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]		/**	 * Base class of all drawing tool (ex. pen, paint brush, stamp).  This class is responsible for	 * placing drawing images on the DrawingBoard.	 * 	 * <p>DrawingTool holds reference to the Class Definition or Linkage ID of an image.  Using this	 * through method <code>drawImage</code> it creates multiple instances of same image to produce	 * drawing effect on the specified <code>DrawingLayer</code>.</p>	 *	 * @author Kaoru Kawashima	 */	public class DrawingTool extends Image_UpdateTool	{				//--------------------------------------------------------------------------		//		//  Constructor		//		//--------------------------------------------------------------------------				/**		 * Constructor.		 *		 * @param drawImage Class which this DraingTool will place on the DrawingBoard.  This must be DisplayObject or class that		 * is based on it.		 */		public function DrawingTool(drawImage:Class)		{						super(drawImage);						// Make sure the class is a DisplayObject.  If this line does not work, then Flash will error			try			{				var testObject:DisplayObject = new drawImage();			}			catch (e:Error)			{				throw new Error("For a DrawingTool, you must specify a class that is a DisplayObject or extends from it.");			}					}				//--------------------------------------------------------------------------		//		//  Overridden properties		//		//--------------------------------------------------------------------------				//----------------------------------		//  width		//----------------------------------				private var _width:Number = -1;		/**		 * Width of the drawing image when it is placed on the DrawingBoard.		 * If &lt; 0, then default size will be used.  This property is overridden		 * to change the actual size of the image being drawn instead of the		 * DrawingTool size.		 * 		 * @default Width of the specified drawing image.		 */				override public function get width():Number		{						if (_width >= 0)			{								// Width is defined				return _width;							}			else			{								// Get default width				var newDrawingItem:* = new drawingImage();				return newDrawingItem.width *= _scaleX;							}					}				/**		 * @private		 */				override public function set width(value:Number):void		{						// Convert new width into correct number using set scale			var currentScale:Number = scaleX;			_width = value * currentScale;						if (_width < 0)				_width = -1;						var newDrawingItem:* = new drawingImage();			var defaultWidth:Number = newDrawingItem.width;						_scaleX = _width / defaultWidth;						//_width = value * _scaleX;					}				//----------------------------------		//  height		//----------------------------------				private var _height:Number = -1;				/**		 * Height of the drawing image when it is placed on the DrawingBoard.		 * If &lt; 0, then default size will be used.  This property is overridden		 * to change the actual size of the image being drawn instead of the		 * DrawingTool size.		 * 		 * @default Height of the specified drawing image.		 */				override public function get height():Number		{						if (_height >= 0)			{								// Height is defined				return _height;							}			else			{								// Get default height				var newDrawingItem:* = new drawingImage();				return newDrawingItem.height *= _scaleY;							}					}				/**		 * @private		 */				override public function set height(value:Number):void		{						// Convert new height into correct number using set scale			var currentScale:Number = scaleY;			_height = value * currentScale;						if (_height < 0)				_height = -1;						var newDrawingItem:* = new drawingImage();			var defaultHeight:Number = newDrawingItem.height;						_scaleY = _height / defaultHeight;						//_height = value * _scaleY;					}				//----------------------------------		//  scaleX		//----------------------------------				private var _scaleX:Number = 1;				/**		 * Horizontal scale of the drawing image when it is placed on the DrawingBoard.		 * 1 is the 100% size. This property is overridden		 * to change the actual size of the image being drawn instead of the		 * DrawingTool size.		 * 		 * @default 1		 */				override public function get scaleX():Number		{						return _scaleX;					}				/**		 * @private		 */				override public function set scaleX(value:Number):void		{						if (_width >= 0)			{								// Scale current width if it is set				_width = _width / _scaleX * value;							}			else			{								// set width				var newDrawingItem:* = new drawingImage();				_width = newDrawingItem.width * value;							}						_scaleX = value;					}				//----------------------------------		//  scaleX		//----------------------------------				private var _scaleY:Number = 1;				/**		 * Vertical scale of the drawing image when it is placed on the DrawingBoard.		 * 1 is the 100% size.  This property is overridden		 * to change the actual size of the image being drawn instead of the		 * DrawingTool size.		 * 		 * @default 1		 */				override public function get scaleY():Number		{						return _scaleY;					}				/**		 * @private		 */				override public function set scaleY(value:Number):void		{						if (_height >= 0)			{								// Scale current height if it is set				_height = _height / _scaleY * value;							}			else			{								// Get default height				var newDrawingItem:* = new drawingImage();				_height = newDrawingItem.height * value;							}						_scaleY = value;					}				//--------------------------------------------------------------------------		//		//  Properties		//		//--------------------------------------------------------------------------				/**		 * If this property is set to true, then each instance of the drawing image		 * drawn using <code>drawImage</code> is set as Bitmap.  Any image drawn as Bitmap		 * cannot be animated unlike instances placed as MovieClips, but when it is erased		 * using EraserTool, only part of it is erased instead of the whole image for other		 * types of <code>DisplayObject</code>.		 */		public var bitmapMode:Boolean = false;				/**		 * Bitmap smoothing on bitmap images drawn when <code>bitmapMode</code> is set to		 * true.		 */		public var bitmapSmoothing:Boolean = false;				/**		 * Units in X direction to offset the actual point a drawing image is placed when method		 * <code>drawImage</code> is executed.		 */		public var drawOffsetX:Number = 0;				/**		 * Units in Y direction to offset the actual point a drawing image is placed when method		 * <code>drawImage</code> is executed.		 */		public var drawOffsetY:Number = 0;				//----------------------------------		//  drawingImage		//----------------------------------				/**		 * The DisplayObject class used as brush.  DrawingTool will place this image on the DrawingBoard.		 */		public function get drawingImage():Class		{						return updateShape;					}				//--------------------------------------------------------------------------		//		//  Protected methods		//		//--------------------------------------------------------------------------				/**		 * Creates a new instance of <code>DisplayObject</code> to be drawn by this <code>DrawingTool</code>.		 * This method also sets x, y, width and height of the new <code>DisplayObject</code> according to		 * the properties set.		 * @return 		 * 		 */		protected function generateNewDrawingImage():DisplayObject		{						// Initialize new drawing item to be placed on the drawing board using DrawingTool properties			var newDrawingItem:DisplayObject = new drawingImage();						if (_width >= 0)				newDrawingItem.width = _width;			else				newDrawingItem.width *= _scaleX;						if (_height >= 0)				newDrawingItem.height = _height;			else				newDrawingItem.height *= _scaleY;						var xLoc:Number = 0;			var yLoc:Number = 0;						if (bitmapMode)			{								// Convert it to Bitmap				var bitmapData:BitmapData = new BitmapData(newDrawingItem.width, newDrawingItem.height, true, 0x00000000);								var brushBounds:Rectangle = newDrawingItem.getBounds(newDrawingItem);				var sizeTransForm:Matrix = new Matrix(scaleX, 0, 0, scaleY,													  -(brushBounds.x * scaleX), -(brushBounds.y * scaleY));				bitmapData.draw(newDrawingItem, sizeTransForm, null, null, null, bitmapSmoothing);				newDrawingItem = new Bitmap(bitmapData);								// Set x and y for this item				xLoc = (brushBounds.x * scaleX);				yLoc = (brushBounds.y * scaleY);							}						xLoc += drawOffsetX;			yLoc += drawOffsetY;						newDrawingItem.x = xLoc;			newDrawingItem.y = yLoc;						return newDrawingItem;					}				//--------------------------------------------------------------------------		//		//  Public methods		//		//--------------------------------------------------------------------------				/**		 * Places an instance of drawing image defined for this DrawingTool on to the targetLayer.		 *		 * @param target IDrawable to place drawing image into.		 * @param xLoc x coordinate to place drawing item at.		 * @param yLoc y coordinate to place drawing item at.		 * @param zLoc z, which is the order of placement.  i+1th element will be on top of ith element.  If set to &lt; 0 or NaN, then the 		 * drawing item will be placed on top of existing DisplayObjects.  This only has effect if drawingLayer is defined.		 *		 * @return Reference to the new drawing item.		 */		public function drawImage(target:IDrawable, xLoc:Number = 0, yLoc:Number = 0, zLoc:Number = NaN):DisplayObject		{						if (isNaN(zLoc) || (zLoc < 0))				zLoc = -1;						// Create new instance of drawing image			var newDrawingItem:DisplayObject = generateNewDrawingImage();;			newDrawingItem.x += xLoc;			newDrawingItem.y += yLoc;						// Draw on board or specific layer			var drawX:Number = newDrawingItem.x;			var drawY:Number = newDrawingItem.y;			target.drawItemAt(newDrawingItem, newDrawingItem.x, newDrawingItem.y, zLoc);						// Target IDrawingLayer to draw on			var drawingTarget:IDrawable;			if (target is IDrawingBoard)				drawingTarget = IDrawingBoard(target).selectedLayer; // Use currently selected layer since that is where newDrawingItem is placed			else				drawingTarget = target;						// Event for this DrawingTool			dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.DRAW, false, false, newDrawingItem, null, drawingTarget, new Point(drawX, drawY)));						return newDrawingItem;					}				/**		 * Creates duplicate DrawingTool.		 * 		 * @return 		 * 		 */		public function clone():DrawingTool		{						var drawingToolClass:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;			var copy:DrawingTool = new drawingToolClass(drawingImage);			copy.width = width;			copy.height = height;			copy.bitmapMode = bitmapMode;			copy.bitmapSmoothing = bitmapSmoothing;			copy.drawOffsetX = drawOffsetX;			copy.drawOffsetY = drawOffsetY;						return copy;					}			}	}