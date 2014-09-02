/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.drawingboard
{
	
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_SelectionTool;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	/**
	 * Interface for a class that manages image layers. 
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface IDrawingBoard extends IDrawable, IEventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  selectMode
		//----------------------------------
		
		/**
		 * When this set to true, drawing on any layer is disabled and images on
		 * <code>selectedLayer</code> become selectable by mouse click.
		 */
		function get selectMode():Boolean;
		
		/**
		 * @private
		 */
		function set selectMode(value:Boolean):void;
		
		//----------------------------------
		//  selectTool
		//----------------------------------
		
		/**
		 * Image selection tool.  When <code>selectMode == true</code>, this is the <code>Image_SelectionTool</code>
		 * used to select the item clicked by mouse pointer.
		 */
		function get selectTool():Image_SelectionTool;
		
		/**
		 * @private
		 */
		function set selectTool(newTool:Image_SelectionTool):void;
		
		//----------------------------------
		//  selectedLayerIndex
		//----------------------------------
		
		/**
		 * Index number of the currently selected layer.
		 */
		function get selectedLayerIndex():int;
		
		/**
		 * @private
		 */
		function set selectedLayerIndex(value:int):void;
		
		//----------------------------------
		//  selectedLayer
		//----------------------------------
		
		/**
		 * Currently selected layer.
		 */
		function get selectedLayer():IDrawingLayer;
		
		/**
		 * @private
		 */
		function set selectedLayer(targetLayer:IDrawingLayer):void;
		
		//----------------------------------
		//  canvasSize
		//----------------------------------
		
		/**
		 * Returns canvas size of the drawing board.
		 */
		function get canvasSize():Rectangle;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds new drawing layer to the top of the DrawingBoard.
		 * 
		 * @param drawingLayer New drawing layer to be added.
		 * 
		 * @return The IDrawingLayer instance that you pass in the <code>drawingLayer</code> parameter.
		 * 
		 */
		function addLayer(drawingLayer:IDrawingLayer):IDrawingLayer;
		
		/**
		 * Adds new drawing layer to specified index on this DrawingBoard.
		 *
		 * @param drawingLayer New drawing layer to be added.
		 * @param index Index number where new drawing layer will be added to.
		 *
		 * @return The IDrawingLayer instance that you pass in the <code>drawingLayer</code> parameter.
		 */
		function addLayerAt(drawingLayer:IDrawingLayer, index:int):IDrawingLayer;
		
		/**
		 * Adds multiple new drawing layers to top of this DrawingBoard.
		 *
		 * @param drawingLayerArray Array of new drawing layers to be added.  Non-IDrawingLayers will be ignored.
		 *
		 * @return The IDrawingLayer Array that you pass in the <code>drawingLayerArray</code> parameter minus non-IDrawingLayer.
		 */
		function addLayers(drawingLayerArray:Array):Array;
		
		/**
		 * Removes drawing layer.
		 *
		 * @param drawingLayer Drawing layer to be removed.
		 *
		 * @return Reference to removed drawing layer.
		 */
		function removeLayer(drawingLayer:IDrawingLayer):IDrawingLayer;
		
		/**
		 * Removes drawing layer at specified index.
		 *
		 * @param index Index number where drawing layer will be removed from.
		 *
		 * @return Reference to removed drawing layer.
		 */
		function removeLayerAt(layerIndex:int):IDrawingLayer;
		
		/**
		 * Gets array of <code>IDrawingLayers</code> currently on the <code>DrawingBoard</code>.
		 * 
		 * @return Array of <code>IDrawingLayers</code>.
		 * 
		 */
		function getDrawingLayers():Vector.<IDrawingLayer>;
		
		/**
		 * Get index number of a layer, where i-th layer is behind i+1-th layer.
		 *
		 * @param drawingLayer IDrawingLayer.
		 *
		 * @return Index number of a drawingLayer.  if drawingLayer is not a part of this DrawingBoard, then -1 is returned.
		 */
		function getLayerIndex(drawingLayer:IDrawingLayer):int
		
		/**
		 * Clears drawing board by removing all layers
		 * @return 
		 * 
		 */
		function clearContents():Vector.<IDrawingLayer>;
		
		/**
		 * Get array of contents.
		 *
		 * @return Array of objects removed.  i+1th element is on top of ith element.
		 */
		function getChildren():Array;
		
	}
	
}