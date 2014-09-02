/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.drawingboard
{
	
	import com.altoinu.flash.customcomponents.drawingboard.DrawingBoard;
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard;
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer;
	import com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent;
	import com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent;
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_SelectionTool;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when image on the <code>DrawingBoard</code> or any of the <code>DrawingLayer</code> in it changes.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.IMAGE_UPDATED
	 */
	[Event(name="imageUpdated", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when Image_SelectionTool's transformation is updated on the <code>DrawingBoard</code> or any of the <code>DrawingLayer</code> in it.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.IMAGE_SELECTION_UPDATED
	 */
	[Event(name="imageSelectionUpdated", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when image is drawn on to the <code>DrawingBoard</code> or any of the <code>DrawingLayer</code> in it.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.DRAW
	 */
	[Event(name="draw", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when a single image/element is cleared from <code>DrawingBoard</code> or any of the <code>DrawingLayer</code>
	 * in it. Unlike "erase" event, this event is dispatched every time something is removed. Use <code>erase</code> event to
	 * listen for erase operation to complete.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.IMAGE_REMOVED
	 */
	[Event(name="imageRemoved", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when image is erased from the <code>DrawingBoard</code> or any of the <code>DrawingLayer</code> in it.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.ERASE
	 */
	[Event(name="erase", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when image is grabbed by mouse to be dragged.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.MOUSE_GRAB
	 */
	[Event(name="mouseGrab", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when image is dropped on to <code>DrawingBoard</code> from mouse dragging.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.MOUSE_DROP
	 */
	[Event(name="mouseDrop", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when image is dropped, but did not get placed on <code>DrawingBoard</code>.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.MOUSE_DROP_MISS
	 */
	[Event(name="mouseDropMiss", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when an image is selected by <code>selectTool</code>.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent.SELECT
	 */
	[Event(name="select", type="com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent")]
	
	/**
	 *  Dispatched when an image is deselected.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent.DESELECT
	 */
	[Event(name="deselect", type="com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[DefaultProperty("elements")] 
	
	/**
	 * Flex UIComponent version of <codeL>DrawingBoard</code>.
	 * 
	 * @see com.altoinu.flash.customcomponents.drawingboard.DrawingBoard
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DrawingBoardUIComponent extends UIComponent implements IDrawingBoard
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DrawingBoardUIComponent()
		{
			
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * This is where all drawing happens
		 */
		protected var _drawingBoard:DrawingBoard;
		
		//--------------------------------------------------------------------------
		//
		//  IDrawingBoard properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  selectMode
		//----------------------------------
		
		private var _selectMode:Boolean = false;
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectMode
		 */
		public function get selectMode():Boolean
		{
			
			if (drawingBoard)
				return drawingBoard.selectMode;
			else
				return _selectMode;
			
		}
		
		/**
		 * @private
		 */
		public function set selectMode(value:Boolean):void
		{
			
			_selectMode = value;
			
			if (drawingBoard)
				drawingBoard.selectMode = value;
			
		}
		
		//----------------------------------
		//  selectTool
		//----------------------------------
		
		private var _selectTool:Image_SelectionTool = new Image_SelectionTool();
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectTool
		 */
		public function get selectTool():Image_SelectionTool
		{
			
			if (drawingBoard)
				return drawingBoard.selectTool;
			else
				return _selectTool;
			
		}
		
		/**
		 * @private
		 */
		public function set selectTool(newTool:Image_SelectionTool):void
		{
			
			_selectTool = newTool;
			
			if (drawingBoard)
				drawingBoard.selectTool = newTool;
			
		}
		
		//----------------------------------
		//  selectedLayerIndex
		//----------------------------------
		
		private var _selectedLayerIndex:int = -1;
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectedLayerIndex
		 */
		public function get selectedLayerIndex():int
		{
			
			if (drawingBoard)
				return drawingBoard.selectedLayerIndex;
			else
				return _selectedLayerIndex;
			
		}
		
		/**
		 * @private
		 */
		public function set selectedLayerIndex(value:int):void
		{
			
			_selectedLayerIndex = value;
			
			if (drawingBoard)
				drawingBoard.selectedLayerIndex = value;
			
		}
		
		//---------------------------------
		//  selectedLayer
		//----------------------------------
		
		private var _selectedLayer:IDrawingLayer;
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectedLayer
		 */
		public function get selectedLayer():IDrawingLayer
		{
			
			if (drawingBoard)
				return drawingBoard.selectedLayer;
			else
				return _selectedLayer;
			
		}
		
		/**
		 * @private
		 */
		public function set selectedLayer(targetLayer:IDrawingLayer):void
		{
			
			_selectedLayer = targetLayer;
			
			if (drawingBoard)
				drawingBoard.selectedLayer = targetLayer;
			
		}
		
		//----------------------------------
		//  canvasSize
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#canvasSize
		 */
		public function get canvasSize():Rectangle
		{
			
			if (drawingBoard)
				return drawingBoard.canvasSize;
			else
				return null;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  elements
		//----------------------------------
		
		private var _elements:Array;
		
		[ArrayElementType("com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer")]
		/**
		 * <code>DrawingLayers</code> to be added.
		 */
		public function set elements(value:Array):void
		{
			
			if (_elements != value)
			{
				
				// First, completely clear contents
				if (drawingBoard != null)
					clearContents();
				
				_elements = value;
				
				// and add new layers
				if (drawingBoard != null)
					addLayers(_elements);
				
			}
			
		}
		
		//----------------------------------
		//  imageMouseDragEnabled
		//----------------------------------
		
		private var _imageMouseDragEnabled:Boolean = false;
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.DrawingBoard#imageMouseDragEnabled
		 */
		public function get imageMouseDragEnabled():Boolean
		{
			
			if (drawingBoard)
				return drawingBoard.imageMouseDragEnabled;
			else
				return _imageMouseDragEnabled;
			
		}
		
		/**
		 * @private
		 */
		public function set imageMouseDragEnabled(value:Boolean):void
		{
			
			_imageMouseDragEnabled = value;
			
			if (drawingBoard)
				drawingBoard.imageMouseDragEnabled = value;
			
		}
		
		//----------------------------------
		//  drawingBoard
		//----------------------------------
		
		public function get drawingBoard():DrawingBoard
		{
			
			return _drawingBoard;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  IDrawingBoard methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#addLayer()
		 */
		public function addLayer(drawingLayer:IDrawingLayer):IDrawingLayer
		{
			
			return drawingBoard.addLayer(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#addLayerAt()
		 */
		public function addLayerAt(drawingLayer:IDrawingLayer, index:int):IDrawingLayer
		{
			
			return drawingBoard.addLayerAt(drawingLayer, index);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#addLayers()
		 */
		public function addLayers(drawingLayerArray:Array):Array
		{
			
			return drawingBoard.addLayers(drawingLayerArray);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#removeLayer()
		 */
		public function removeLayer(drawingLayer:IDrawingLayer):IDrawingLayer
		{
			
			return drawingBoard.removeLayer(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#removeLayerAt()
		 */
		public function removeLayerAt(layerIndex:int):IDrawingLayer
		{
			
			return drawingBoard.removeLayerAt(layerIndex);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#getDrawingLayers()
		 */
		public function getDrawingLayers():Vector.<IDrawingLayer>
		{
			
			return drawingBoard.getDrawingLayers();
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#getLayerIndex()
		 */
		public function getLayerIndex(drawingLayer:IDrawingLayer):int
		{
			
			return drawingBoard.getLayerIndex(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#clearContents()
		 */
		public function clearContents():Vector.<IDrawingLayer>
		{
			
			return drawingBoard.clearContents();
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#getChildren()
		 */
		public function getChildren():Array
		{
			
			return drawingBoard.getChildren();
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#drawItemAt()
		 */
		public function drawItemAt(drawingItem:DisplayObject, xLoc:Number=0, yLoc:Number=0, zLoc:Number=-1):DisplayObject
		{
			
			return drawingBoard.drawItemAt(drawingItem, xLoc, yLoc, zLoc);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#drawItem()
		 */
		public function drawItem(drawingItem:DisplayObject):DisplayObject
		{
			
			return drawingBoard.drawItem(drawingItem);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#eraseItemsAt()
		 */
		public function eraseItemsAt(xLoc:Number, yLoc:Number, eraseAreaWidth:Number=0, eraseAreaHeight:Number=0, eraseShape:Class=null):Object
		{
			
			return drawingBoard.eraseItemsAt(xLoc, yLoc, eraseAreaWidth, eraseAreaHeight, eraseShape);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods for mouse interaction
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.DrawingBoard#grabItem()
		 */
		public function grabItem(targetItem:Sprite):Sprite
		{
			
			return drawingBoard.grabItem(targetItem);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onCreationComplete(event:FlexEvent):void
		{
			
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			// create drawing board
			_drawingBoard = new DrawingBoard(width, height);
			this.addChild(drawingBoard);
			
			this.addLayers(_elements);
			
			drawingBoard.selectMode = _selectMode;
			drawingBoard.selectTool = _selectTool;
			drawingBoard.selectedLayerIndex = _selectedLayerIndex;
			drawingBoard.selectedLayer = _selectedLayer;
			
			drawingBoard.imageMouseDragEnabled = _imageMouseDragEnabled;
			
			// Events
			drawingBoard.addEventListener(DrawingBoardEvent.IMAGE_UPDATED, cloneDrawingBoardEvent);
			drawingBoard.addEventListener(DrawingBoardEvent.IMAGE_SELECTION_UPDATED, cloneDrawingBoardEvent);
			drawingBoard.addEventListener(DrawingBoardEvent.DRAW, cloneDrawingBoardEvent);
			drawingBoard.addEventListener(DrawingBoardEvent.IMAGE_REMOVED, cloneDrawingBoardEvent);
			drawingBoard.addEventListener(DrawingBoardEvent.ERASE, cloneDrawingBoardEvent);
			drawingBoard.addEventListener(DrawingBoardEvent.MOUSE_GRAB, cloneDrawingBoardEvent);
			drawingBoard.addEventListener(DrawingBoardEvent.MOUSE_DROP, cloneDrawingBoardEvent);
			drawingBoard.addEventListener(DrawingBoardEvent.MOUSE_DROP_MISS, cloneDrawingBoardEvent);
			drawingBoard.addEventListener(ImageSelectionToolEvent.SELECT, onImageSelectOnDrawingBoard);
			drawingBoard.addEventListener(ImageSelectionToolEvent.DESELECT, onImageSelectOnDrawingBoard);
			
		}
		
		private function cloneDrawingBoardEvent(event:DrawingBoardEvent):void
		{
			
			dispatchEvent(event.clone());
			
		}
		
		/**
		 * Event handler executed when something is selected on the <code>DrawingBoard</code>.
		 * @param event
		 * 
		 */
		private function onImageSelectOnDrawingBoard(event:ImageSelectionToolEvent):void
		{
			
			dispatchEvent(event.clone());
			
		}
		
	}
	
}