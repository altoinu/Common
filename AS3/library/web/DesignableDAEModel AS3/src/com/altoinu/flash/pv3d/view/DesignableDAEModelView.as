/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.view
{
	
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer;
	import com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent;
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.DrawingTool;
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.EraserTool;
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_SelectionTool;
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_UpdateTool;
	import com.altoinu.flash.pv3d.events.DesignableDAEModelEvent;
	import com.altoinu.flash.pv3d.objects.parsers.DesignableDAEModel;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.papervision3d.core.render.data.RenderHitData;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.view.BasicView;
	
	/**
	 * Papervision 2.0 BasicView used to display DesignableDAEModel for 3D
	 * model drawing area.
	 * 
	 * <p>This class also attaches necessary mouse events on the viewport to
	 * allow drawing/erasing by mouse. In order to be able to draw/erase, make sure following
	 * properties are set:
	 * <ul>
	 * 	<li><code>mouseDrawEraseEnabled == true</code></li>
	 * 	<li><code>targetModel.designMaterial.interactive == true</code></li>
	 * 	<li><code>viewport.interactive == true</code></li>
	 * 	<li><code>targetModel.selectMode == false</code></li>
	 * 	<li><code>currentTool</code> - Image_UpdateTool (ex. DrawingTool and EraserTool) to use on surface.</li>
	 * 	<li><code>targetModel.selectedLayer</code> - <code>DrawingLayer</code> on <code>targetModel</code> to draw/erase on.</li>
	 * </ul>
	 * </p>
	 * 
	 * <p>Also, any objects drawn by <code>DrawingTool</code> set in <code>currentTool</code> while <code>DrawingTool.bitmapMode == true</code>
	 * can be dragged by mouse if following conditions are set:
	 * <ul>
	 * 	<li><code>mouseDragSelectionEnabled == true</code></li>
	 * 	<li><code>targetModel.designMaterial.interactive == true</code></li>
	 * 	<li><code>viewport.interactive == true</code></li>
	 * 	<li><code>targetModel.selectMode == true</code></li>
	 * 	<li><code>targetModel.selectTool.target</code> has something selected</li>
	 * </ul>
	 * </p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @see com.altoinu.flash.customcomponents.drawingboard.DrawingTool
	 * 
	 */
	public class DesignableDAEModelView extends BasicView
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param targetModel		Model to be drawn on.
		 * @param viewportWidth		Width of the viewport 
		 * @param viewportHeight	Height of the viewport
		 * @param scaleToStage		Whether you viewport should scale with the stage
		 * @param interactive		Whether your scene should be interactive
		 * @param cameraType		A String for the type of camera. @see org.papervision3d.cameras.CameraType
		 * 
		 */	
		public function DesignableDAEModelView(targetModel:DesignableDAEModel = null, viewportWidth:Number = 640, viewportHeight:Number = 480, scaleToStage:Boolean = true, interactive:Boolean = false, cameraType:String = "Target")
		{
			
			super(viewportWidth, viewportHeight, scaleToStage, interactive, cameraType);
			
			if (targetModel != null)
				this.targetModel = targetModel;
			
			// Add mouse events to viewport to handle drawing
			viewport.addEventListener(MouseEvent.MOUSE_DOWN, onMouseSurfaceDownStartDraw);
			viewport.addEventListener(MouseEvent.MOUSE_UP, onMouseSurfaceUpStopDraw);
			viewport.addEventListener(MouseEvent.ROLL_OUT, onMouseSurfaceUpStopDraw);
			viewport.addEventListener(MouseEvent.MOUSE_MOVE, onMouseSurfaceInteract);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _drawing:Boolean = false;
		
		private var _dragPoint:Point;
		private var _dropTargetLayer:IDrawingLayer;
		
		private var _currentMouseDragSelectTool:Image_SelectionTool;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Drawing/Erasing by mouse enable/disable.  This may come in handy if you want to disable
		 * drawing but still want interactivity on the Papervision model.
		 */
		public var mouseDrawEraseEnabled:Boolean = true;
		
		/**
		 * If set to true, image item selected by <code>targetModel.selectTool</code> while
		 * <code>targetModel.selectMode = true</code> can be dragged with mouse.
		 */
		public var mouseDragSelectionEnabled:Boolean = true;
		
		/**
		 * <code>Image_UpdateTool</code> (ex. <code>DrawingTool</code> or <code>EraserTool</code>) currently chosen to be
		 * used by mouse interaction.  <code>DesignableDAEModelView</code> will use this tool to either
		 * draw or erase by mouse interaction.
		 */
		public var currentTool:Image_UpdateTool;
		
		//--------------------------------------
		//  mouseInteractionEnabled
		//--------------------------------------
		
		[Deprecated(replacement="mouseDrawEraseEnabled")]
		public function get mouseInteractionEnabled():Boolean
		{
			
			return mouseDrawEraseEnabled;
			
		}
		
		/**
		 * @private
		 */
		public function set mouseInteractionEnabled(value:Boolean):void
		{
			
			mouseDrawEraseEnabled = value;
			
		}
		
		//--------------------------------------
		//  mouseDragSelection
		//--------------------------------------
		
		[Deprecated(replacement="mouseDragSelectionEnabled")]
		public function get mouseDragSelection():Boolean
		{
			
			return mouseDragSelectionEnabled;
			
		}
		
		/**
		 * @private
		 */
		public function set mouseDragSelection(value:Boolean):void
		{
			
			mouseDragSelectionEnabled = value;
			
		}
		
		//--------------------------------------
		//  targetModel
		//--------------------------------------
		
		private var _targetModel:DesignableDAEModel;
		
		/**
		 * Model where all drawing occurs on.
		 */
		public function get targetModel():DesignableDAEModel
		{
			
			return _targetModel;
			
		}
		
		/**
		 * @private
		 */
		public function set targetModel(daeModel:DesignableDAEModel):void
		{
			
			if ((_targetModel != null) && (_targetModel.scene == scene))
			{
				
				// Remove previous targetModel and events
				scene.removeChild(_targetModel);
				_targetModel.removeEventListener(ImageSelectionToolEvent.SELECT, onImageSelectOnDrawingBoard);
				_targetModel.removeEventListener(DesignableDAEModelEvent.SELECTTOOL_MOUSE_DOWN, onSelectToolMouseDown);
				_targetModel.removeEventListener(DesignableDAEModelEvent.SELECTTOOL_MOUSE_UP, onSelectToolMouseUp);
				
			}
			
			_targetModel = daeModel;
			
			if (_targetModel != null)
			{
				
				// Add new target model and events
				scene.addChild(_targetModel);
				_targetModel.addEventListener(ImageSelectionToolEvent.SELECT, onImageSelectOnDrawingBoard);
				_targetModel.addEventListener(DesignableDAEModelEvent.SELECTTOOL_MOUSE_DOWN, onSelectToolMouseDown);
				_targetModel.addEventListener(DesignableDAEModelEvent.SELECTTOOL_MOUSE_UP, onSelectToolMouseUp);
				
			}
			
		}
		
		//--------------------------------------
		//  currentDragImage
		//--------------------------------------
		
		private var _currentDragImage:DisplayObject;
		
		/**
		 * Image currently being dragged by mouse.
		 */
		public function get currentDragImage():DisplayObject
		{
			
			return _currentDragImage;
			
		}
		
		//--------------------------------------
		//  isMouseDraggingImage
		//--------------------------------------
		
		/**
		 * Is there some image being dragged?
		 */
		public function get isMouseDraggingImage():Boolean
		{
			
			return (_currentDragImage != null);
			
		}
		
		//--------------------------------------
		//  isSelectToolMouseDragging
		//--------------------------------------
		
		/**
		 * Returns true when <code>targetModel.selectTool</code> and its target on <code>targetModel</code> is being dragged
		 * by mouse on DesignableDAEModelView.
		 */
		public function get isSelectToolMouseDragging():Boolean
		{
			
			return _currentMouseDragSelectTool != null;
			
		}
		
		//--------------------------------------
		//  selectToolMouseDragging
		//--------------------------------------
		
		[Deprecated(replacement="isSelectToolMouseDragging")]
		public function get selectToolMouseDragging():Boolean
		{
			
			return isSelectToolMouseDragging;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Starts image dragging by mouse.  Use this method to drag DisplayObject on stage
		 * so it can later be dropped on to the model.  In order to stop dragging, call
		 * method <code>stopMouseDragAndDrop</code>.
		 * 
		 * <p>This temporarily disables drawing/erasing on the targetModel.</p>
		 * 
		 * @param dragImage Image to drag by mouse.
		 * @param dropTargetLayer <code>DrawingLayer</code> where <code>dragImage</code> will be dropped
		 * when method <code>stopMouseDragAndDrop</code> is called while mouse pointer is on
		 * <code>targetModel</code>.  If this is not specified, then <code>targetModel.selectedLayer</code>
		 * is used.  If no layer is selected, then top most layer is used.
		 * @param dragPoint Point to drag image at.
		 * 
		 * @return Reference to the image currently being dragged, or null if it cannot be dragged.
		 * 
		 */
		public function startMouseDrag(dragImage:DisplayObject, dropTargetLayer:IDrawingLayer = null, dragPoint:Point = null):DisplayObject
		{
			
			if (_currentDragImage == null)
			{
				
				_currentDragImage = dragImage;
				
				if (dropTargetLayer == null)
				{
					
					// No target layer has been specified
					var allLayers:Vector.<IDrawingLayer> = targetModel.designMaterial.designArea.getDrawingLayers();
					var numLayers:int = allLayers.length;
					if (numLayers > 0)
					{
						
						// There are layers
						
						if (targetModel.selectedLayer != null)
							dropTargetLayer = targetModel.selectedLayer; // Use selected layer
						else
							dropTargetLayer = allLayers[numLayers - 1];
						
					}
					else
					{
						
						// No layers.... error
						throw new Error("targetModel does not have any layers to drop image into.");
						return null;
						
					}
					
				}
				
				if (dragPoint == null)
					dragPoint = new Point(0, 0);
				
				_dragPoint = dragPoint;
				_dropTargetLayer = dropTargetLayer;
				
				// Add to stage
				stage.addChild(dragImage);
				
				// and start dragging it
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveDragImage);
				
				return _currentDragImage;
				
			}
			else
			{
				
				return null;
				
			}
			
		}
		
		/**
		 * Stops mouse drag of the image initiated by the method <code>startMouseDrag</code>,
		 * and drops the image on to the <code>targetModel</code> if it is under the mouse pointer.
		 * 
		 * @return true if image is placed successfully on to the <code>dropTargetLayer</code>
		 * specified in method <code>startMouseDrag</code>, false if image could not be placed.
		 * 
		 */
		public function stopMouseDragAndDrop():Boolean
		{
			
			// Stop dragging image
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveDragImage);
			
			// Remove image from view
			if (_currentDragImage.parent != null)
				_currentDragImage.parent.removeChild(_currentDragImage);
			
			// and drop it to whever mouse is pointing at
			var dropped:Boolean = dropImageAtMousePoint(_currentDragImage, _dropTargetLayer);
			
			_currentDragImage = null;
			_dragPoint = null;
			_dropTargetLayer = null;
			
			return dropped;
			
		}
		
		/**
		 * Drops specified image on to the specified targetLayer at where mouse is pointing at.  In order for
		 * this method to work, <code>DesignableDAEModelView</code> must be placed on stage, and
		 * <code>viewport</code> and <code>targetModel.designMaterial</code> must be set as interactive.
		 * 
		 * <p>You can use this method with mouseUp event to do drag and drop effect.</p>
		 * 
		 * @param dropImage
		 * @param targetLayer
		 * @return true if image is placed successfully, false if image could not be placed.
		 * 
		 */
		public function dropImageAtMousePoint(dropImage:DisplayObject, targetLayer:IDrawingLayer = null):Boolean
		{
			
			if (this.stage == null)
			{
				
				throw new Error("DesignableDAEModelView is must be placed on the stage in order for it to figure out where mouse pointer is.");
				return false;
				
			}
			if (!viewport.interactive)
			{
				
				throw new Error("DesignableDAEModelView.viewport is not interactive.");
				return false;
				
			}
			if (!targetModel.designMaterial.interactive)
			{
				
				throw new Error("targetModel.designMaterial is not interactive.");
				return false;
				
			}
			
			if (viewport.containerSprite.hitTestPoint(stage.mouseX, stage.mouseY))
			{
				
				// User dropped on top of the model viewer
				
				if (targetLayer == null)
				{
					
					// No target layer has been specified
					var allLayers:Vector.<IDrawingLayer> = targetModel.designMaterial.designArea.getDrawingLayers();
					var numLayers:int = allLayers.length;
					if (numLayers > 0)
					{
						
						// There are layers
						
						if (targetModel.selectedLayer != null)
							targetLayer = targetModel.selectedLayer; // Use selected layer
						else
							targetLayer = allLayers[numLayers - 1];
						
					}
					else
					{
						
						// No layers.... error
						throw new Error("targetModel does not have any layers to drop image into.");
						return false;
						
					}
					
				}
				
				// Rotate image
				var point1:Point = new Point(viewport.interactiveSceneManager.currentMousePos.x,
											viewport.interactiveSceneManager.currentMousePos.y);
											
				var rhd1:RenderHitData = this.viewport.hitTestPoint2D(point1) as RenderHitData;
				var rhpoint1:Point = new Point(rhd1.u, rhd1.v);
											
				var point2:Point = new Point(point1.x, point1.y + 10);
											
				var rhd2:RenderHitData = this.viewport.hitTestPoint2D(point2) as RenderHitData;
				var rhpoint2:Point = new Point(rhd2.u, rhd2.v);
				
				var itemRotation:Number = Math.atan2(rhpoint1.y - rhpoint2.y, rhpoint1.x - rhpoint2.x) / (Math.PI / 180) + 90;
				
				dropImage.rotation = itemRotation;
				
				// Draw image
				targetLayer.drawItemAt(dropImage,
									   viewport.interactiveSceneManager.virtualMouse.x - _dragPoint.x,
									   viewport.interactiveSceneManager.virtualMouse.y - _dragPoint.y);
				
				// Render once so image will show up
				singleRender();
				
				return true;
				
			}
			else
			{
				
				// Mouse is not on the viewport
				return false;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onMouseSurfaceDownStartDraw(event:MouseEvent):void
		{
			
			_drawing = true;
			onMouseSurfaceInteract(event);
			
		}
		
		private function onMouseSurfaceUpStopDraw(event:MouseEvent):void
		{
			
			_drawing = false;
			
		}
		
		/**
		 * Event handler to handle user mouse interaction on the surface material.
		 * @param event
		 * 
		 */
		private function onMouseSurfaceInteract(event:MouseEvent):void
		{
			
			if (mouseDrawEraseEnabled &&
				(targetModel != null) && (targetModel.designMaterial != null) &&
				targetModel.designMaterial.interactive &&
				viewport.interactive &&
				!targetModel.selectMode &&
				(currentDragImage == null) &&
				_drawing &&
				event.buttonDown)
			{
				
				// Mouse drawing is enabled
				// Target model is specified
				// Select mode is off
				// Nothing is being dragged at the moment
				// user has mouse button down.
				// Draw or erase here
				var targetLayer:IDrawingLayer = targetModel.selectedLayer;
				
				if ((currentTool != null) && (targetLayer != null))
				{
					
					var locX:Number = viewport.interactiveSceneManager.virtualMouse.x;
					var locY:Number = viewport.interactiveSceneManager.virtualMouse.y;
					
					//trace("Mouse interaction on: "+_targetModel.designMaterial.designArea+" selectedLayer: "+_targetModel.selectedLayer+" "+locX+","+locY);
					
					if (currentTool is DrawingTool)
						DrawingTool(currentTool).drawImage(targetLayer, locX, locY);
					else if (currentTool is EraserTool)
						EraserTool(currentTool).eraseImage(targetLayer, locX, locY);
					
				}
				
			}
			
		}
		
		/**
		 * Event handler executed to drag image on stage.
		 * @param event
		 * 
		 */
		private function onMouseMoveDragImage(event:MouseEvent):void
		{
			
			_currentDragImage.x = stage.mouseX - _dragPoint.x;
			_currentDragImage.y = stage.mouseY - _dragPoint.x;
			
		}
		
		/**
		 * Event handler executed when something is selected on the <code>DrawingBoard</code>.
		 * @param event
		 * 
		 */
		private function onImageSelectOnDrawingBoard(event:ImageSelectionToolEvent):void
		{
			
			// Something is selected, update view.
			singleRender();
			
		}
		
		/**
		 * Mouse down handler on selectTool on targetModel which initiates mouse dragging
		 * of the drawing images on the <code>DrawingBoardMaterial</code>.
		 * @param event
		 * 
		 */
		private function onSelectToolMouseDown(event:DesignableDAEModelEvent):void
		{
			
			if (mouseDragSelectionEnabled &&
				(targetModel != null) &&
				targetModel.selectMode &&
				(targetModel.selectTool != null) &&
				(targetModel.selectTool.target != null) &&
				(targetModel.modelObject != null) &&
				!isSelectToolMouseDragging)
			{
				
				// Mouse drag enabled
				// Select mode is on
				// targetModel.selectTool has something selected
				// dae has been loaded
				// nothing else is currently being dragged
				
				// Start dragging object under the mouse
				targetModel.modelObject.addEventListener(InteractiveScene3DEvent.OBJECT_MOVE, onObjectMouseMove);
				targetModel.modelObject.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, onObjectMouseUp);
				
				_currentMouseDragSelectTool = targetModel.selectTool;
				
			}
			
		}
		
		/**
		 * Mouse up handler on _currentMouseDragSelectTool.
		 * @param event
		 * 
		 */
		private function onSelectToolMouseUp(event:DesignableDAEModelEvent):void
		{
			
			onObjectMouseUp();
			
		}
		
		/**
		 * Object mouse up event, stops mouse dragging of the selected drawing image.
		 * @param event
		 * 
		 */
		private function onObjectMouseUp(event:InteractiveScene3DEvent = null):void
		{
			
			targetModel.modelObject.removeEventListener(InteractiveScene3DEvent.OBJECT_MOVE, onObjectMouseMove);
			targetModel.modelObject.removeEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, onObjectMouseUp);
			
			_currentMouseDragSelectTool = null;
			
		}
		
		/**
		 * Mouse move on the model object does the actual mouse dragging of the selected image.
		 * @param event
		 * 
		 */
		private function onObjectMouseMove(event:InteractiveScene3DEvent):void
		{
			
			if (mouseDragSelectionEnabled &&
				targetModel.selectMode &&
				(targetModel.selectTool.target != null))
			{
				
				// Move grabbed (selected) item
				var moveToX:Number = event.x;
				var moveToY:Number = event.y;
				
				targetModel.selectTool.moveTarget(moveToX, moveToY);
				
			}
			
		}
		
	}
	
}