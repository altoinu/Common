/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.objects.parsers
{
	
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer;
	import com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent;
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_SelectionTool;
	import com.altoinu.flash.pv3d.events.DesignableDAEModelEvent;
	import com.altoinu.flash.pv3d.materials.DrawingBoardMaterial;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * Dispatched when Collada file has been loaded.
	 * 
	 * @eventType org.papervision3d.events.FileLoadEvent.LOAD_COMPLETE
	 */
	[Event(name="loadComplete", type="org.papervision3d.events.FileLoadEvent")]
	
	/**
	 * Dispatched as Collada file loads.
	 * 
	 * @eventType org.papervision3d.events.FileLoadEvent.LOAD_PROGRESS
	 */
	[Event(name="loadProgress", type="org.papervision3d.events.FileLoadEvent")]
	
	/**
	 * Dispatched when Collada file failed to load.
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 
	 * 
	 * @eventType org.papervision3d.events.FileLoadEvent.ANIMATIONS_COMPLETE
	 */
	[Event(name="animationsComplete", type="org.papervision3d.events.FileLoadEvent")]
	
	/**
	 * 
	 * 
	 * @eventType org.papervision3d.events.FileLoadEvent.ANIMATIONS_PROGRESS
	 */
	[Event(name="animationsProgress", type="org.papervision3d.events.FileLoadEvent")]
	
	/**
	 *  Dispatched when an image is selected by <code>selectTool</code>.
	 *
	 *  @eventType com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent.SELECT
	 */
	[Event(name="select", type="com.altoinu.flash.customcomponents.drawingboard.events.ImageSelectionToolEvent")]
	
	/**
	 *  Dispatched at mouse down on selectTool.
	 *
	 *  @eventType com.altoinu.flash.pv3d.events.DesignableDAEModelEvent.SELECTTOOL_MOUSE_DOWN
	 */
	[Event(name="selecttoolMouseDown", type="com.altoinu.flash.pv3d.events.DesignableDAEModelEvent")]
	
	/**
	 *  Dispatched at mouse up on selectTool.
	 *
	 *  @eventType com.altoinu.flash.pv3d.events.DesignableDAEModelEvent.SELECTTOOL_MOUSE_UP
	 */
	[Event(name="selecttoolMouseUp", type="com.altoinu.flash.pv3d.events.DesignableDAEModelEvent")]
	
	/**
	 * <code>DAE</code> object which strictly uses <code>DrawingBoardMaterial</code> for the collada
	 * model loaded and provides properties and methods to easily customize the looks.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DesignableDAEModel extends DAE implements IDesignableModel
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param objectName Name of the actual object in the collada that will be loaded.  This is needed
		 * so DesignableDAEModel can figure out where to place DesignableMaterial by referencing it as
		 * <code>DAE.getChildByName(DAE.ROOTNODE_NAME, true).getChildByName(objectName, true);</code> Usually
		 * this id can be looked up in the .dae under <code>&lt;library_visual_scenes&gt;&lt;visual_scene&gt;&lt;node
		 * id=&quot;objectName&quot;&gt;</code>.
		 * 
		 * @param asset The url, an XML object or a ByteArray specifying the COLLADA file.
		 * @param autoPlay Whether to start the _animation automatically.
		 * @param name Optional name for the DAE.
		 * @param loop      
		 * @param material DrawingBoardMaterial to be used as the texture to hold all customized design.
		 * 
		 */
		public function DesignableDAEModel(objectName:String, asset:* = null, autoPlay:Boolean = true, name:String = null, loop:Boolean = false, material:DrawingBoardMaterial = null)
		{
			
			super(autoPlay, name, loop);
			
			// Remember the object's name
			this.objectName = objectName;
			
			// Set material
			if (material != null)
				this.designMaterial = material;
			
			this.addEventListener(FileLoadEvent.LOAD_COMPLETE, onDAELoadComplete);
			
			if (asset != null)
				load(asset); // Start loading DAE right away
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _currentMouseDownTool:Image_SelectionTool;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  material
		//--------------------------------------
		
		/**
		 * Material property is overridden for DesignableDAEModel to simply serve as a reference to designMaterial.
		 */
		override public function get material():MaterialObject3D
		{
			
			return designMaterial;
			
		}
		
		/**
		 * @private
		 */
		override public function set material(material:MaterialObject3D):void
		{
			
			designMaterial = DrawingBoardMaterial(material);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties defined by IDesignableModel
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
			
			return _designMaterial.selectMode;
			
		}
		
		/**
		 * @private
		 */
		public function set selectMode(value:Boolean):void
		{
			
			_designMaterial.selectMode = value;
			
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
			
			return _designMaterial.selectTool;
			
		}
		
		/**
		 * @private
		 */
		public function set selectTool(newTool:Image_SelectionTool):void
		{
			
			if (_designMaterial.selectTool != null)
			{
				
				if (_currentMouseDownTool != null)
				{
					
					// previous select tool was being mouse down
					// release
					_currentMouseDownTool.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, 0, 0, null, false, false, false, false, 0));
					
					// Set null
					_currentMouseDownTool = null;
					
				}
				
				_designMaterial.selectTool.removeEventListener(MouseEvent.MOUSE_DOWN, onSelectToolMouseDown);
				_designMaterial.selectTool.removeEventListener(MouseEvent.MOUSE_UP, onSelectToolMouseUp);
				
			}
			
			_designMaterial.selectTool = newTool;
			
			if (_designMaterial.selectTool != null)
			{
				
				_designMaterial.selectTool.addEventListener(MouseEvent.MOUSE_DOWN, onSelectToolMouseDown);
				_designMaterial.selectTool.addEventListener(MouseEvent.MOUSE_UP, onSelectToolMouseUp);
				
			}
			
			dispatchEvent(new Event("selectToolChange"));
			
		}
		
		//--------------------------------------
		//  designMaterial
		//--------------------------------------
		
		private var _designMaterial:DrawingBoardMaterial;
		
		/**
		 * @copy com.altoinu.flash.pv3d.objects.parsers.IDesignableModel#designMaterial
		 */
		public function get designMaterial():DrawingBoardMaterial
		{
			
			return _designMaterial;
			
		}
		
		/**
		 * @private
		 */
		public function set designMaterial(value:DrawingBoardMaterial):void
		{
			
			setMaterial(value);
			
		}
		
		//--------------------------------------
		//  modelLoaded
		//--------------------------------------
		
		private var _modelLoaded:Boolean = false;
		
		/**
		 * @copy com.altoinu.flash.pv3d.objects.parsers.IDesignableModel#modelLoaded
		 */
		public function get modelLoaded():Boolean
		{
			
			return _modelLoaded;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties defined by IDrawingBoard
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  selectedLayerIndex
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectedLayerIndex
		 */
		public function get selectedLayerIndex():int
		{
			
			return _designMaterial.selectedLayerIndex;
			
		}
		
		/**
		 * @private
		 */
		public function set selectedLayerIndex(value:int):void
		{
			
			_designMaterial.selectedLayerIndex = value;
			
		}
		
		//----------------------------------
		//  selectedLayer
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#selectedLayer
		 */
		public function get selectedLayer():IDrawingLayer
		{
			
			return _designMaterial.selectedLayer;
			
		}
		
		/**
		 * @private
		 */
		public function set selectedLayer(targetLayer:IDrawingLayer):void
		{
			
			_designMaterial.selectedLayer = targetLayer;
			
		}
		
		//----------------------------------
		//  canvasSize
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#canvasSize
		 */
		public function get canvasSize():Rectangle
		{
			
			return _designMaterial.canvasSize;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/*
		 * If set to true, image item selected by <code>selectTool</code> while <code>selectMode = true</code>
		 * can be dragged with mouse.
		 */
		//public var mouseDragMode:Boolean = false;
		
		//--------------------------------------
		//  objectName
		//--------------------------------------
		
		private var _objectName:String;
		
		/**
		 * Name of the actual object in the collada that will be loaded.  This is needed
		 * so <code>DesignableDAEModel</code> can figure out where to place <code>DesignableMaterial</code> by referencing it as
		 * <code>DAE.getChildByName(DAE.ROOTNODE_NAME, true).getChildByName(objectName, true);</code>.
		 */
		public function get objectName():String
		{
			
			return _objectName;
			
		}
		
		/**
		 * @private
		 */
		public function set objectName(value:String):void
		{
			
			if (_objectName != value)
			{
				
				_objectName = value;
				
				// Reset material
				setMaterial(designMaterial);
				
			}
			
		}
		
		//--------------------------------------
		//  modelObject
		//--------------------------------------
		
		/**
		 * Returns the reference to the actual model object that was loaded.
		 */
		public function get modelObject():DisplayObject3D
		{
			
			var DAERoot:DisplayObject3D = getChildByName(DAE.ROOTNODE_NAME, true);
			
			if (DAERoot != null)
				return DAERoot.getChildByName(objectName, true);
			else
				return null;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Loads the COLLADA.
		 * @param asset asset The url, an XML object or a ByteArray specifying the COLLADA file.
		 * @param materials This parameter is ignored for DesignableDAEModel.  DrawingBoardMaterial needs to be set
		 * through property <code>designMaterial</code> separately.
		 * @param asynchronousParsing
		 * 
		 */
		override public function load(asset:*, materials:MaterialsList = null, asynchronousParsing:Boolean = false):void
		{
			
			super.load(asset, null, asynchronousParsing);
			
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
			
			return _designMaterial.addLayer(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#addLayerAt()
		 */
		public function addLayerAt(drawingLayer:IDrawingLayer, index:int):IDrawingLayer
		{
			
			return _designMaterial.addLayerAt(drawingLayer, index);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#addLayers()
		 */
		public function addLayers(drawingLayerArray:Array):Array
		{
			
			return _designMaterial.addLayers(drawingLayerArray);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#removeLayer()
		 */
		public function removeLayer(drawingLayer:IDrawingLayer):IDrawingLayer
		{
			
			return _designMaterial.removeLayer(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#removeLayerAt()
		 */
		public function removeLayerAt(layerIndex:int):IDrawingLayer
		{
			
			return _designMaterial.removeLayerAt(layerIndex);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#getDrawingLayers()
		 */
		public function getDrawingLayers():Vector.<IDrawingLayer>
		{
			
			return _designMaterial.getDrawingLayers();
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard#getLayerIndex()
		 */
		public function getLayerIndex(drawingLayer:IDrawingLayer):int
		{
			
			return _designMaterial.getLayerIndex(drawingLayer);
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.DrawingBoard#clearContents()
		 */
		public function clearContents():Vector.<IDrawingLayer>
		{
			
			return _designMaterial.clearContents();
			
		}
		
		/**
		 * @copy com.altoinu.flash.customcomponents.drawingboard.DrawingBoard#getChildren()
		 */
		public function getChildren():Array
		{
			
			return _designMaterial.getChildren();
			
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
			
			throw new Error("drawItemAt is not used with DesignableDAEModel.");
			
		}
		
		/**
		 * @private
		 */
		public function drawItem(drawingItem:DisplayObject):DisplayObject
		{
			
			throw new Error("drawItem is not used with DesignableDAEModel.");
			
		}
		
		/**
		 * @private
		 */
		public function eraseItemsAt(xLoc:Number, yLoc:Number, eraseAreaWidth:Number = 0, eraseAreaHeight:Number = 0, eraseShape:Class = null):Object
		{
			
			throw new Error("eraseItemsAt is not used with DesignableDAEModel.");
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Sets <code>DrawingBoardMaterial</code> to the collada model.
		 * 
		 * @param newMaterial
		 * 
		 */
		private function setMaterial(newMaterial:DrawingBoardMaterial):void
		{
			
			if (newMaterial != null)
			{
				
				if (_designMaterial != null)
					_designMaterial.removeEventListener(ImageSelectionToolEvent.SELECT, onImageSelectOnDrawingBoard);
				
				_designMaterial = newMaterial;
				
				if (_designMaterial != null)
					_designMaterial.addEventListener(ImageSelectionToolEvent.SELECT, onImageSelectOnDrawingBoard);
				
				var modelRef:DisplayObject3D = modelObject;
				if (modelRef != null)
					modelRef.material = _designMaterial; // Apply this material to the object
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onDAELoadComplete(event:FileLoadEvent):void
		{
			
			_modelLoaded = true;
			
			// Set material
			setMaterial(designMaterial);
			
		}
		
		/**
		 * Event handler executed at mouse down on selectTool.
		 * 
		 * @param event
		 * 
		 */
		private function onSelectToolMouseDown(event:MouseEvent):void
		{
			
			_currentMouseDownTool = selectTool;
			dispatchEvent(new DesignableDAEModelEvent(DesignableDAEModelEvent.SELECTTOOL_MOUSE_DOWN, false, false));
			
		}
		
		/**
		 * Event handler executed at mouse up on selectTool.
		 * 
		 * @param event
		 * 
		 */
		private function onSelectToolMouseUp(event:MouseEvent):void
		{
			
			_currentMouseDownTool = null;
			dispatchEvent(new DesignableDAEModelEvent(DesignableDAEModelEvent.SELECTTOOL_MOUSE_UP, false, false));
			
		}
		
		/**
		 * Event handler executed when something is selected on the <code>DrawingBoard</code>.
		 * @param event
		 * 
		 */
		private function onImageSelectOnDrawingBoard(event:ImageSelectionToolEvent):void
		{
			
			// and dispatch the same event
			dispatchEvent(event.clone());
			
		}
		
	}
	
}