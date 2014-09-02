﻿/** * This Source Code Form is subject to the terms of the Mozilla Public * License, v. 2.0. If a copy of the MPL was not distributed with this file, * You can obtain one at http://mozilla.org/MPL/2.0/. *  * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com */package com.altoinu.flash.customcomponents.drawingboard{		import com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent;	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_InteractTool;	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_SelectionTool;		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.InteractiveObject;	import flash.display.MovieClip;	import flash.geom.Matrix;	import flash.geom.Point;	import flash.geom.Rectangle;
		//--------------------------------------	//  Events	//--------------------------------------		/**	 *  Dispatched when image on the DrawingLayer changes.	 *	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.IMAGE_UPDATED	 */	[Event(name="imageUpdated", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]		/**	 *  Dispatched when Image_SelectionTool's transformation is updated on the DrawingLayer.	 *	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.IMAGE_SELECTION_UPDATED	 */	[Event(name="imageSelectionUpdated", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]		/**	 *  Dispatched when image is drawn on to the <code>DrawingLayer</code>.	 *	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.DRAW	 */	[Event(name="draw", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]		/**	 *  Dispatched when a single image/element is cleared from the <code>DrawingLayer</code>. Unlike "erase" event,	 * this event is dispatched every time something is removed. Use <code>erase</code> event to	 * listen for erase operation to complete.	 *	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.IMAGE_REMOVED	 */	[Event(name="imageRemoved", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]		/**	 *  Dispatched when image is erased from the <code>DrawingBoard</code> or any of the <code>DrawingLayer</code> in it.	 * Non-bitmap objects are completely removed if they are found in the <code>erasedItems.nonBitmaps</code>,	 * but <code>Bitmap</code> objects in <code>erasedItems.bitmaps</code> may still exist on <code>DrawingLayer</code>	 * if only part of it is erased.	 *	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.ERASE	 */	[Event(name="erase", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]		/**	 * Single drawing layer which holds multiple <code>DisplayObject</code> items to represent a	 * image on one single layer.	 *	 * @author Kaoru Kawashima	 */	public class DrawingLayer extends MovieClip implements IDrawingLayer, IDrawable	{				//--------------------------------------------------------------------------		//		//  Contructor		//		//--------------------------------------------------------------------------				/**		 * Constructor.		 */		public function DrawingLayer()		{						super();					}				//--------------------------------------------------------------------------		//		//  Properties		//		//--------------------------------------------------------------------------				//----------------------------------		//  mouseEnabled		//----------------------------------				/**		 * @inheritDoc		 */		override public function get mouseEnabled():Boolean		{						return super.mouseEnabled;					}				/**		 * @inheritDoc		 */		override public function set mouseEnabled(enabled:Boolean):void		{						super.mouseEnabled = enabled;					}				//----------------------------------		//  parentDrawingBoard		//----------------------------------				private var _parentDrawingBoard:IDrawingBoard;				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer#parentDrawingBoard		 */				public function get parentDrawingBoard():IDrawingBoard		{						return _parentDrawingBoard;					}				/**		 * @private		 */		public function set parentDrawingBoard(newDrawingBoard:IDrawingBoard):void		{						_parentDrawingBoard = newDrawingBoard;					}				//----------------------------------		//  bitmapSmoothing		//----------------------------------				private var _bitmapSmoothing:Boolean = false;				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawable#bitmapSmoothing		 */		public function get bitmapSmoothing():Boolean		{						return _bitmapSmoothing;					}				/**		 * @private		 */		public function set bitmapSmoothing(value:Boolean):void		{						if (_bitmapSmoothing != value)			{								_bitmapSmoothing = value;								var existingBitmapLayer:Bitmap = getExistingBitmapLayer();				if (existingBitmapLayer != null)					existingBitmapLayer.smoothing = bitmapSmoothing;							}					}				//----------------------------------		//  drawingItems		//----------------------------------				/**		 * Array of DisplayObjects currently on the DrawingLayer.		 */		public function get drawingItems():Array		{						return getChildren();					}				//--------------------------------------------------------------------------		//		//  Overridden methods		//		//--------------------------------------------------------------------------				/**		 * addChild method is overridden to simply use method <code>drawItemAt</code>.		 * 		 * @param obj		 * @return 		 * 		 */		override public function addChild(obj:DisplayObject):DisplayObject		{						return drawItemAt(obj, obj.x, obj.y);					}				/**		 * addChildAt method is overridden to simply use method <code>drawItemAt</code>.		 * 		 * @param obj		 * @return 		 * 		 */		override public function addChildAt(obj:DisplayObject, index:int):DisplayObject		{						return drawItemAt(obj, obj.x, obj.y, index);					}				/**		 * @private		 */		override public function removeChild(child:DisplayObject):DisplayObject		{						var removedItems:Object = new Object();			removedItems.bitmaps = [];			removedItems.nonBitmaps = [];						super.removeChild(child);						if (!(child is Image_SelectionTool))			{								if (child is Bitmap)					removedItems.bitmaps.push(child);				else if (child is InteractiveObject)					removedItems.nonBitmaps.push(child);								dispatchImageRemoveEvent(child);							}						return child;					}				/**		 * @private		 */		override public function removeChildAt(index:int):DisplayObject		{						var removedItems:Object = new Object();			removedItems.bitmaps = [];			removedItems.nonBitmaps = [];						var child:DisplayObject = this.getChildAt(index);			super.removeChildAt(index)						if (!(child is Image_SelectionTool))			{								if (child is Bitmap)					removedItems.bitmaps.push(child);				else if (child is InteractiveObject)					removedItems.nonBitmaps.push(child);								dispatchImageRemoveEvent(child);							}						return child;					}				//--------------------------------------------------------------------------		//		//  Methods defined by IDrawingLayer		//		//--------------------------------------------------------------------------				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer#clearContents()		 */				public function clearContents():Array		{						var allRemovedItems:Array = [];						var removedItems:Object = new Object();			removedItems.bitmaps = [];			removedItems.nonBitmaps = [];						var drawingItemArray:Array = getChildren();			var numItems:Number = drawingItemArray.length;						if ((drawingItemArray != null) && (numItems > 0))			{								for (var i:int = 0; i < numItems; i++)				{										var removedItem:DisplayObject = drawingItemArray[i];					if ((removedItem.parent != null) && (removedItem.parent == this))						removeChild(removedItem);										if (removedItem is Bitmap)						removedItems.bitmaps.push(removedItem);					else if (!(removedItem is Image_SelectionTool))						removedItems.nonBitmaps.push(removedItem);										allRemovedItems.push(removedItem);									}							}						return allRemovedItems;					}				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer#getChildren()		 */				public function getChildren():Array		{						var childArray:Array = [];						if (numChildren > 0)			{								for (var i:int = 0; i < numChildren; i++)				{										childArray.push(getChildAt(i));									}							}						return childArray;					}				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer#moveDrawingItemUp()		 */				public function moveDrawingItemUp(targetDrawingItem:DisplayObject):void		{						if ((targetDrawingItem != null) &&				(targetDrawingItem.parent == this) &&				(parentDrawingBoard != null))			{								// Target item is on this layer				var currentIndex:Number = getChildIndex(targetDrawingItem);								if ((currentIndex < numChildren - 2) ||					((currentIndex < numChildren - 1) && (parentDrawingBoard.selectTool.target != targetDrawingItem)))				{										// First find another drawing item right above targetDrawingItem that is touching it					var swapTarget:DisplayObject;					var swapTargetIndex:Number = currentIndex;					do					{												swapTargetIndex++;												swapTarget = getChildAt(swapTargetIndex);											}					while ((!targetDrawingItem.hitTestObject(swapTarget) || (swapTarget is Image_InteractTool)) &&						(swapTargetIndex < numChildren - 1));										// then place target item at that index					if (!(swapTarget is Image_InteractTool))						super.addChildAt(targetDrawingItem, swapTargetIndex);										if (parentDrawingBoard.selectTool)						parentDrawingBoard.selectTool.positionHighlight(); // Reposition selection highlight									}							}					}				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer#moveDrawingItemDown()		 */				public function moveDrawingItemDown(targetDrawingItem:DisplayObject):void		{						if ((targetDrawingItem != null) &&				(targetDrawingItem.parent == this) &&				(parentDrawingBoard != null))			{								// Target item is on this layer				var currentIndex:Number = getChildIndex(targetDrawingItem);								if (currentIndex > 0)				{										// Move target item one level down under item that is touching it					var swapTarget:DisplayObject;					var swapTargetIndex:Number = currentIndex;					do					{												swapTargetIndex--;						swapTarget = getChildAt(swapTargetIndex);											}					while ((!targetDrawingItem.hitTestObject(swapTarget) || (swapTarget is Image_InteractTool)) &&						(swapTargetIndex > 0));										if (!(swapTarget is Image_InteractTool))						super.addChildAt(targetDrawingItem, swapTargetIndex);										if (parentDrawingBoard.selectTool)						parentDrawingBoard.selectTool.positionHighlight(); // Reposition selection highlight									}							}					}				//--------------------------------------------------------------------------		//		//  Methods defined by IDrawable		//		//--------------------------------------------------------------------------				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawable#drawItemAt()		 * 		 * <p>This function has no effect if it is not added to any <code>IDrawingBoard</code> or		 * <code>selectMode</code> property of the <code>IDrawingBoard</code> is set to true.</p>		 * 		 */		public function drawItemAt(drawingItem:DisplayObject, xLoc:Number = 0, yLoc:Number = 0, zLoc:Number = -1):DisplayObject		{						if ((parentDrawingBoard != null) &&				((!parentDrawingBoard.selectMode) || (parentDrawingBoard.selectMode && (drawingItem is Image_SelectionTool))))			{								if (drawingItem is Bitmap)				{										var existingBitmapLayer:Bitmap = getExistingBitmapLayer();										// Copy new bitmap drawingItem to existing bitmap object in this layer					var sourceBitmap:Bitmap = drawingItem as Bitmap;					var copyBitmapData:BitmapData = new BitmapData(sourceBitmap.width, sourceBitmap.height, true, 0x00000000);					copyBitmapData.draw(sourceBitmap, null, sourceBitmap.transform.colorTransform, null, null, sourceBitmap.smoothing);										existingBitmapLayer.bitmapData.copyPixels(copyBitmapData,						new Rectangle(0, 0, sourceBitmap.width, sourceBitmap.height),						new Point(xLoc, yLoc),						null,						null,						true);									}				else				{										// add new DisplayObject to the layer					if (zLoc < 0)						super.addChild(drawingItem);					else						super.addChildAt(drawingItem, zLoc);										// Set coordinates					drawingItem.x = xLoc;					drawingItem.y = yLoc;									}								if (!(drawingItem is Image_SelectionTool))					dispatchDrawEvent(drawingItem, new Point(xLoc, yLoc));							}						return drawingItem;					}				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawable#drawItem()		 * 		 * <p>This function has no effect if it is not added to any <code>IDrawingBoard</code> or		 * <code>selectMode</code> property of the <code>IDrawingBoard</code> is set to true.</p>		 * 		 */		public function drawItem(drawingItem:DisplayObject):DisplayObject		{						return drawItemAt(drawingItem);					}				/**		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawable#eraseItemsAt()		 * 		 * <p>This function has no effect if it is not added to any <code>IDrawingBoard</code> or		 * <code>selectMode</code> property of the <code>IDrawingBoard</code> is set to true.</p>		 * 		 */		public function eraseItemsAt(xLoc:Number, yLoc:Number, eraseAreaWidth:Number = 0, eraseAreaHeight:Number = 0, eraseShape:Class = null):Object		{						var erasedItems:ErasedItems = new ErasedItems();						if ((numChildren > 0) &&				(parentDrawingBoard != null) &&				!parentDrawingBoard.selectMode)			{								var eraserBrush:DisplayObject;				var eraserArea:BitmapData;				var sizeTransForm:Matrix				var removeCompletely:Array = [];								if (eraseShape != null)				{										// Eraser shape defined.  Erase area drawn during bitmapMode = true using this information					eraserBrush = new eraseShape();										var eraserBounds:Rectangle = eraserBrush.getBounds(eraserBrush);					var eraserScaleX:Number = eraseAreaWidth / eraserBrush.width;					var eraserScaleY:Number = eraseAreaHeight / eraserBrush.height;					sizeTransForm = new Matrix(eraserScaleX, 0, 0, eraserScaleY,						-(eraserBounds.x * eraserScaleX), -(eraserBounds.y * eraserScaleY));										try					{												eraserArea = new BitmapData(eraserBrush.width * eraserScaleX, eraserBrush.height * eraserScaleY, true, 0x00000000); // Basically draws over bitmap with alpha = 0 bitmap											}					catch (e:Error)					{												// invalid size for eraser, cannot erase						return erasedItems;											}										eraserArea.draw(eraserBrush, sizeTransForm, null, null, null);					// Set x and y for this item					xLoc += (eraserBounds.x * eraserScaleX);					yLoc += (eraserBounds.y * eraserScaleY);									}								// Which items do we have to remove?				var drawingItemArray:Array = drawingItems;				var numItems:int = drawingItemArray.length;				for (var childX:int = 0; childX < numItems; childX++)				{										var imageItem:DisplayObject = drawingItemArray[childX];										if (!(imageItem is Image_SelectionTool) &&						(eraserHitTest(imageItem, xLoc, yLoc, eraseAreaWidth, eraseAreaHeight)))					{												// Current item is within erasing area						if (imageItem is Bitmap)						{														// and it is a Bitmap item, so erase part of it							var eraseTarget:Bitmap = Bitmap(imageItem);														var startX:Number = xLoc - eraseTarget.x;							var startY:Number = yLoc - eraseTarget.y;							var endX:Number = startX + eraseAreaWidth;							var endY:Number = startY + eraseAreaHeight;														if (startX < 0)								startX = 0;							if (startY < 0)								startY = 0;														if (endX > eraseTarget.width)								endX = eraseTarget.width;							if (endY > eraseTarget.height)								endY = eraseTarget.height;														for (var i:int = startX; i <= endX; i++)							{																for (var j:int = startY; j <= endY; j++)								{																		if (eraseShape == null)									{																				// No eraser shape defined, erase rectangular area										eraseTarget.bitmapData.setPixel32(i, j, 0x00000000);																			}									else									{																				// Erase (set to transparent) the pixels on eraseTarget which corresponds to the										// non-transparent area of the eraserArea										var eraseX:int = i + (eraseTarget.x - xLoc);										var eraseY:int = j + (eraseTarget.y - yLoc);																				if (eraserArea.getPixel32(eraseX, eraseY) > 0x00FFFFFF)											eraseTarget.bitmapData.setPixel32(i, j, 0x00000000);																			}																	}															}														// Is this image now entirely erased?  Check to see if all pixel is alpha=0							var allBlank:Boolean = true;							checkToSeeIfAllBlank: for (var ii:int = 0; ii < eraseTarget.bitmapData.width; ii++)							{																for (var jj:int = 0; jj < eraseTarget.bitmapData.height; jj++)								{																		if (eraseTarget.bitmapData.getPixel32(ii, jj) != 0x00000000)									{																				allBlank = false;  // There is a pixel that is not blank										break checkToSeeIfAllBlank;																			}																	}															}														if (allBlank)							{																// Yes, so mark it to be removed completely								//if ((eraseTarget.parent != null) && (super == eraseTarget.parent)) // TODO: was this OK?								if ((eraseTarget.parent != null) && (this == eraseTarget.parent))									removeCompletely.push(eraseTarget);															}														// Remember the reference to each item							erasedItems.bitmaps.push(eraseTarget);													}						else						{														// Remember the reference to each item							erasedItems.nonBitmaps.push(imageItem);													}											}									}								// Remove Bitmaps where pixels turned into all alpha=0				// Non-Bitmap items are completely removed right away instead				// unlike Bitmaps which are partially erased				removeCompletely = removeCompletely.concat(erasedItems.nonBitmaps);				var numEraseItems:int = removeCompletely.length;				for (var removeX:int = 0; removeX < numEraseItems; removeX++)				{										var removedItem:DisplayObject = removeChild(removeCompletely[removeX]);										if ((parentDrawingBoard != null) &&						(parentDrawingBoard.selectTool != null) &&						(parentDrawingBoard.selectTool.target == removedItem))					{												// Deselect removed item						parentDrawingBoard.selectTool.target = null;											}									}								// Dispatch event to notify items that were erased				if ((erasedItems.bitmaps.length > 0) || (erasedItems.nonBitmaps.length > 0))					dispatchEraseEvent(eraseShape, eraseAreaWidth, eraseAreaHeight, erasedItems, new Point(xLoc, yLoc));							}						return erasedItems;					}				//--------------------------------------------------------------------------		//		//  Protected methods		//		//--------------------------------------------------------------------------				protected function dispatchDrawEvent(drawingItem:DisplayObject = null, relativePoint:Point = null):void		{						dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.IMAGE_UPDATED, false, false, drawingItem, null, this, relativePoint));			dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.DRAW, false, false, drawingItem, null, this, relativePoint));						if (parentDrawingBoard != null)			{								parentDrawingBoard.dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.IMAGE_UPDATED, false, false, drawingItem, null, this, relativePoint));				parentDrawingBoard.dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.DRAW, false, false, drawingItem, null, this, relativePoint));							}					}				protected function dispatchEraseEvent(eraseShape:Class = null, eraseAreaWidth:Number = NaN, eraseAreaHeight:Number = NaN, erasedItems:Object = null, relativePoint:Point = null):void		{						dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.IMAGE_UPDATED, false, false, null, erasedItems, this, relativePoint));			dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.ERASE, false, false, null, erasedItems, this, relativePoint));						if (parentDrawingBoard != null)			{								parentDrawingBoard.dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.IMAGE_UPDATED, false, false, null, erasedItems, this, relativePoint));				parentDrawingBoard.dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.ERASE, false, false, null, erasedItems, this, relativePoint));							}					}				protected function dispatchImageRemoveEvent(removedItem:DisplayObject = null):void		{						dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.IMAGE_UPDATED, false, false, removedItem, null, this));			dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.IMAGE_REMOVED, false, false, removedItem, null, this));						if (parentDrawingBoard != null)			{								parentDrawingBoard.dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.IMAGE_UPDATED, false, false, removedItem, null, this));				parentDrawingBoard.dispatchEvent(new DrawingBoardEvent(DrawingBoardEvent.IMAGE_REMOVED, false, false, removedItem, null, this));							}					}				//--------------------------------------------------------------------------		//		//  Private methods		//		//--------------------------------------------------------------------------				/**		 * Method to always get reference back to single bitmap layer in this <code>DrawingLayer</code>.		 * If it does not exist, creates it		 */		private function getExistingBitmapLayer():Bitmap		{						var existingBitmapLayer:Bitmap;			var nextLayerItem:DisplayObject;			var numItemsInLayer:Number = numChildren;			for (var i:int = 0; i < numItemsInLayer; i++)			{								nextLayerItem = getChildAt(i);				if (nextLayerItem is Bitmap)				{										existingBitmapLayer = nextLayerItem as Bitmap;					break;									}							}						if ((parentDrawingBoard != null) && (existingBitmapLayer == null)) // If Bitmap object to hold all bitmap data does not exist			{								// Create new one in this layer				var bitmapDataHolder:BitmapData = new BitmapData(parentDrawingBoard.canvasSize.width, parentDrawingBoard.canvasSize.height, true, 0x000000);				existingBitmapLayer = super.addChild(new Bitmap(bitmapDataHolder)) as Bitmap;				existingBitmapLayer.smoothing = bitmapSmoothing;							}						return existingBitmapLayer;					}				/**		 * Checks to see if targetImage falls within the range specified.		 * 		 * @param targetImage		 * @param eraserX		 * @param eraserY		 * @param eraserW		 * @param eraserH		 * 		 * @return True if targetImage does fall within the specified range.		 */		private function eraserHitTest(targetImage:DisplayObject, eraserX:Number, eraserY:Number, eraserW:Number = 0, eraserH:Number = 0):Boolean		{						var hit:Boolean = false; // assume no						var targetImageBound:Rectangle = targetImage.getBounds(targetImage);			var targetImageLeft:Number = targetImage.x + (targetImageBound.x * targetImage.scaleX);			var targetImageTop:Number = targetImage.y + (targetImageBound.y * targetImage.scaleY);									if (((targetImageLeft >= eraserX) && (targetImageLeft <= eraserX + eraserW)) ||				((targetImageLeft + targetImage.width >= eraserX) && (targetImageLeft + targetImage.width <= eraserX + eraserW)) ||				((targetImageLeft <= eraserX) && (targetImageLeft + targetImage.width >= eraserX + eraserW)))			{								if (((targetImageTop >= eraserY) && (targetImageTop <= eraserY + eraserH)) ||					((targetImageTop + targetImage.height >= eraserY) && (targetImageTop + targetImage.height <= eraserY + eraserH)) ||					((targetImageTop <= eraserY) && (targetImageTop + targetImage.height >= eraserY + eraserH)))				{										hit = true;									}							}						return hit;					}			}	}// Class to keep track of erased itemsclass ErasedItems{		public function ErasedItems()	{			}		public var bitmaps:Array = [];	public var nonBitmaps:Array = [];	}