/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.materials
{
	
	import com.altoinu.flash.customcomponents.drawingboard.DrawingBoard;
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard;
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer;
	import com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent;
	import com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent;
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_SelectionTool;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.papervision3d.materials.MovieMaterial;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when image on the DrawingBoard or any of the DrawingLayer in it changes.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.IMAGE_UPDATED
	 */
	[Event(name="imageUpdated", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when Image_SelectionTool's transformation is updated on the DrawingBoard or any of the DrawingLayer in it.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.IMAGE_SELECTION_UPDATED
	 */
	[Event(name="imageSelectionUpdated", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when image is drawn on to the DrawingBoard or any of the DrawingLayer in it.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.DRAW
	 */
	[Event(name="draw", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when image is erased from the DrawingBoard or any of the DrawingLayer in it.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.ERASE
	 */
	[Event(name="erase", type="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent")]
	
	/**
	 *  Dispatched when an image is selected by <code>selectTool</code>.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent.SELECT
	 */
	[Event(name="select", type="com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent")]
	
	/**
	 * Material that uses <code>DrawingBoard</code> for its entire surface so the object
	 * it is applied to can have custom designs.
	 * 
	 * <p>You can access the actual <code>DrawingBoard</code> through property <code>designArea</code>.
	 * Any changes made in here will automatically show up as the material texture.</p>
	 * 
	 * @see com.altoinu.flash.customcomponents.drawingboard.DrawingBoard
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DrawingBoardMaterial extends MovieMaterial implements IDrawingBoard
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param drawingBoard
		 * @param transparent
		 * @param precise
		 * 
		 */
		public function DrawingBoardMaterial(drawingBoard:DrawingBoard = null, transparent:Boolean = false, precise:Boolean = false)
		{
			
			_designArea = drawingBoard; // Use specified asset as base material
			if (_designArea == null)
				_designArea = new DrawingBoard();
			
			designArea.addEventListener(DrawingBoardEvent.IMAGE_UPDATED, cloneDrawingBoardEvent);
			designArea.addEventListener(DrawingBoardEvent.IMAGE_SELECTION_UPDATED, cloneDrawingBoardEvent);
			designArea.addEventListener(DrawingBoardEvent.DRAW, cloneDrawingBoardEvent);
			designArea.addEventListener(DrawingBoardEvent.ERASE, cloneDrawingBoardEvent);
			designArea.addEventListener(ImageSelectionToolEvent.SELECT, onImageSelectOnDrawingBoard);
			
			// Specify rectangle so MovieMaterial clips what is visible
			var designAreaRectangle:Rectangle = new Rectangle(0, 0, (designArea.width > 0 ? designArea.width : designArea.canvasSize.width), (designArea.height > 0 ? designArea.height : designArea.canvasSize.height));
			
			super(designArea, transparent, true, precise, designAreaRectangle);
			
			// Interactive is true by default for DrawingBoardMaterial
			interactive = true;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  texture
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set texture(asset:Object):void
		{
			
			if (asset is DrawingBoard)
				super.texture = asset;
			else
				throw new Error("DrawingBoardMaterial.texture requires a DrawingBoard to be passed as the object.");
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties defined by IDrawingBoard
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  selectMode
		//--------------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectMode
		 */
		public function get selectMode():Boolean
		{
			
			return designArea.selectMode;
			
		}
		
		/**
		 * @private
		 */
		public function set selectMode(value:Boolean):void
		{
			
			designArea.selectMode = value;
			
		}
		
		//----------------------------------
		//  selectTool
		//----------------------------------
		
		[Bindable(event="selectToolChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectTool
		 */
		public function get selectTool():Image_SelectionTool
		{
			
			return designArea.selectTool;
			
		}
		
		/**
		 * @private
		 */
		public function set selectTool(newTool:Image_SelectionTool):void
		{
			
			designArea.selectTool = newTool;
			
			dispatchEvent(new Event("selectToolChange"));
			
		}
		
		//----------------------------------
		//  selectedLayerIndex
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectedLayerIndex
		 */
		public function get selectedLayerIndex():int
		{
			
			return designArea.selectedLayerIndex;
			
		}
		
		/**
		 * @private
		 */
		public function set selectedLayerIndex(value:int):void
		{
			
			designArea.selectedLayerIndex = value;
			
		}
		
		//----------------------------------
		//  selectedLayer
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectedLayer
		 */
		public function get selectedLayer():IDrawingLayer
		{
			
			return designArea.selectedLayer;
			
		}
		
		/**
		 * @private
		 */
		public function set selectedLayer(targetLayer:IDrawingLayer):void
		{
			
			designArea.selectedLayer = targetLayer;
			
		}
		
		//----------------------------------
		//  canvasSize
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#canvasSize
		 */
		public function get canvasSize():Rectangle
		{
			
			return designArea.canvasSize;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  designArea
		//--------------------------------------
		
		private var _designArea:DrawingBoard;
		
		/**
		 * Actual <code>DrawingBoard</code> where the design will be placed.  Default is
		 * a blank DrawingBoard object.  Whatever changes made in here will show up
		 * as the material texture.
		 */
		public function get designArea():DrawingBoard
		{
			
			return _designArea;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods defined by IDrawingBoard
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#addLayer()
		 */
		public function addLayer(drawingLayer:IDrawingLayer):IDrawingLayer
		{
			
			return designArea.addLayer(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#addLayerAt()
		 */
		public function addLayerAt(drawingLayer:IDrawingLayer, index:int):IDrawingLayer
		{
			
			return designArea.addLayerAt(drawingLayer, index);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#addLayers()
		 */
		public function addLayers(drawingLayerArray:Array):Array
		{
			
			return designArea.addLayers(drawingLayerArray);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#removeLayer()
		 */
		public function removeLayer(drawingLayer:IDrawingLayer):IDrawingLayer
		{
			
			return designArea.removeLayer(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#removeLayerAt()
		 */
		public function removeLayerAt(layerIndex:int):IDrawingLayer
		{
			
			return designArea.removeLayerAt(layerIndex);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#getDrawingLayers()
		 */
		public function getDrawingLayers():Vector.<IDrawingLayer>
		{
			
			return designArea.getDrawingLayers();
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#getLayerIndex()
		 */
		public function getLayerIndex(drawingLayer:IDrawingLayer):int
		{
			
			return designArea.getLayerIndex(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.DrawingBoard#clearContents()
		 */
		public function clearContents():Vector.<IDrawingLayer>
		{
			
			return designArea.clearContents();
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.DrawingBoard#getChildren()
		 */
		public function getChildren():Array
		{
			
			return designArea.getChildren();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods defined by IDrawable
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public function drawItemAt(drawingItem:DisplayObject, xLoc:Number = 0, yLoc:Number = 0, zLoc:Number = -1):DisplayObject
		{
			
			throw new Error("drawItemAt is not used with DrawingBoardMaterial.");
			
		}
		
		/**
		 * @private
		 */
		public function drawItem(drawingItem:DisplayObject):DisplayObject
		{
			
			throw new Error("drawItem is not used with DrawingBoardMaterial.");
			
		}
		
		/**
		 * @private
		 */
		public function eraseItemsAt(xLoc:Number, yLoc:Number, eraseAreaWidth:Number = 0, eraseAreaHeight:Number = 0, eraseShape:Class = null):Object
		{
			
			throw new Error("eraseItemsAt is not used with DrawingBoardMaterial.");
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
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