/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.pv3d
{
	
	import com.altoinu.flex.customcomponents.events.PV3DFlexEvent;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.Viewport3D;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when basicView Papervision component being displayed is created.
	 * 
	 *  @eventType com.altoinu.flex.customcomponents.events.PV3DFlexEvent.BASICVIEW_CREATED
	 */
	[Event(name="basicviewCreated", type="com.altoinu.flex.customcomponents.events.PV3DFlexEvent")]
	
	/**
	 *  Dispatched when basicView's <code>autoScaleToStage</code> property is changed.
	 * 
	 *  @eventType com.altoinu.flex.customcomponents.events.PV3DFlexEvent.AUTO_SCALE_TO_STAGE_CHANGE
	 */
	[Event(name="autoScaleToStageChange", type="com.altoinu.flex.customcomponents.events.PV3DFlexEvent")]
	
	/**
	 *  Dispatched when basicView's <code>interactive</code> property is changed.
	 * 
	 *  @eventType com.altoinu.flex.customcomponents.events.PV3DFlexEvent.INTERACTIVE_CHANGE
	 */
	[Event(name="interactiveChange", type="com.altoinu.flex.customcomponents.events.PV3DFlexEvent")]
	
	/**
	 *  Dispatched when basicView's <code>rendering</code> property is changed.
	 * 
	 *  @eventType com.altoinu.flex.customcomponents.events.PV3DFlexEvent.RENDER_STATE_CHANGE
	 */
	[Event(name="renderStateChange", type="com.altoinu.flex.customcomponents.events.PV3DFlexEvent")]
	
	/**
	 * Papervision 2.0 BasicView component for Flex.
	 * 
	 * @see org.papervision3d.view.BasicView
	 * @author Kaoru Kawashima
	 * 
	 */
	public class BasicViewPV3D2Flex extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function BasicViewPV3D2Flex()
		{
			
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteInitializePV3DView);
			this.addEventListener(ResizeEvent.RESIZE, onResize);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _viewEnterFrameRendering:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		private var _pv3DView:BasicView;
		
		[Bindable(event="basicviewCreated")]
		/**
		 * @private
		 * Actual protected variable holding reference to the BasicView component.
		 */
		protected function get pv3DView():BasicView
		{
			
			return _pv3DView;
			
		}
		
		/**
		 * @private
		 */
		protected function set pv3DView(newView:BasicView):void
		{
			
			_pv3DView = newView;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  basicView
		//--------------------------------------
		
		/**
		 * BasicView Papervision component being displayed in BasicViewPV3D2Flex.
		 * @see org.papervision3d.view.BasicView
		 */
		public function get basicView():BasicView
		{
			
			return pv3DView;
			
		}
		
		//--------------------------------------
		//  cameraType
		//--------------------------------------
		
		private var _cameraType:String;
		
		[Bindable(event="cameraTypeChange")]
		[Inspectable(category="Other", enumeration="Target,Free,Debug,Spring", defaultValue="Target")]
		/**
		 * A String for the type of camera.  This property can only be set once.
		 * 
		 * <p>Possible values:
		 * <ul>
		 * 	<li>"Debug" - DebugCamera3D</li>
		 * 	<li>"Free" - Camera3D with no target</li>
		 * 	<li>"Spring"</li>
		 *	<li>"Target" - Camera3D targeting x:0, y:0, z:0</li>
		 * </ul></p>
		 * 
		 * @default "Target"
		 * @see org.papervision3d.cameras.CameraType
		 */
		public function get cameraType():String
		{
			
			return _cameraType;
			
		}
		
		/**
		 * @private
		 */
		public function set cameraType(value:String):void
		{
			
			if ((_cameraType == null) || (_cameraType == value))
			{
				
				_cameraType = value;
				
				dispatchEvent(new Event("cameraTypeChange"));
				
			}
			else
			{
				
				throw new Error("cameraType is already set.  You cannot change this property once it is set.");
				
			}
			
		}
		
		//--------------------------------------
		//  autoScaleToStage
		//--------------------------------------
		
		private var _autoScaleToStage:Boolean = true;
		
		[Bindable(event="autoScaleToStageChange")]
		[Inspectable(category="Other", defaultValue="true")]
		/**
		 * Whether the viewport should scale with the stage.
		 * 
		 * @copy org.papervision3d.view.Viewport3D#autoScaleToStage
		 * @default true
		 */
		public function get autoScaleToStage():Boolean
		{
			
			return _autoScaleToStage;
			
		}
		
		/**
		 * @private
		 */
		public function set autoScaleToStage(value:Boolean):void
		{
			
			_autoScaleToStage = value;
			
			if (pv3DView != null)
				pv3DView.viewport.autoScaleToStage = _autoScaleToStage;
			
			dispatchEvent(new PV3DFlexEvent(PV3DFlexEvent.AUTO_SCALE_TO_STAGE_CHANGE, false, false));
			
		}
		
		//--------------------------------------
		//  interactive
		//--------------------------------------
		
		private var _interactive:Boolean = false;
		
		[Bindable(event="interactiveChange")]
		[Inspectable(category="Other", defaultValue="false")]
		/**
		 * Whether the scene should be interactive.
		 * 
		 * @copy org.papervision3d.view.Viewport3D#interactive
		 * @default false
		 */
		public function get interactive():Boolean
		{
			
			return _interactive;
			
		}
		
		/**
		 * @private
		 */
		public function set interactive(value:Boolean):void
		{
			
			_interactive = value;
			
			if (pv3DView != null)
				pv3DView.viewport.interactive = _interactive;
			
			dispatchEvent(new PV3DFlexEvent(PV3DFlexEvent.INTERACTIVE_CHANGE, false, false));
			
		}
		
		//--------------------------------------
		//  rendering
		//--------------------------------------
		
		private var _rendering:Boolean = false;
		
		[Bindable(event="renderStateChange")]
		[Inspectable(category="Other", defaultValue="false")]
		/**
		 * If set to true, BasicView renders every frame.
		 * @default false
		 */
		public function get rendering():Boolean
		{
			
			return _rendering;
			
		}
		
		/**
		 * @private
		 */
		public function set rendering(value:Boolean):void
		{
			
			_rendering = value;
			
			if (pv3DView != null)
			{
				
				if (_rendering && !_viewEnterFrameRendering)
				{
					
					pv3DView.startRendering();
					_viewEnterFrameRendering = true;
					
				}
				else if (!_rendering && _viewEnterFrameRendering)
				{
					
					pv3DView.stopRendering();
					_viewEnterFrameRendering = false;
					
				}
				
			}
			
			dispatchEvent(new PV3DFlexEvent(PV3DFlexEvent.RENDER_STATE_CHANGE, false, false));
			
		}
		
		//--------------------------------------
		//  camera
		//--------------------------------------
		
		[Bindable(event="basicviewCreated")]
		public function get camera():CameraObject3D
		{
			
			if (pv3DView != null)
				return pv3DView.camera;
			else
				return null;
			
		}
		
		//--------------------------------------
		//  scene
		//--------------------------------------
		
		[Bindable(event="basicviewCreated")]
		public function get scene():Scene3D
		{
			
			if (pv3DView != null)
				return pv3DView.scene;
			else
				return null;
			
		}
		
		//--------------------------------------
		//  viewport
		//--------------------------------------
		
		[Bindable(event="basicviewCreated")]
		public function get viewport():Viewport3D
		{
			
			if (pv3DView != null)
				return pv3DView.viewport;
			else
				return null;
			
		}
		
		//--------------------------------------
		//  renderer
		//--------------------------------------
		
		[Bindable(event="basicviewCreated")]
		public function get renderer():BasicRenderEngine
		{
			
			if (pv3DView != null)
				return pv3DView.renderer;
			else
				return null;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy org.papervision3d.view.BasicView#startRendering()
		 */
		public function startRendering():void
		{
			
			// Trigger rendering through setter
			rendering = true;
			
		}
		
		/**
		 * @copy org.papervision3d.view.BasicView#stopRendering()
		 */
		public function stopRendering(reRender:Boolean = false, cacheAsBitmap:Boolean = false):void
		{
			
			// Trigger rendering through setter
			rendering = false;
			
		}
		
		/**
		 * @copy org.papervision3d.view.BasicView#singleRender()
		 */
		public function singleRender():void
		{
			
			if (pv3DView != null)
				pv3DView.singleRender();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates the Papervision PasicView component at creationComplete event of the BasicViewPV3D2Flex,
		 * and displays it by addChild.
		 * 
		 * @param viewportWidth
		 * @param viewportHeight
		 * @param autoScaleToStage
		 * @param interactive
		 * @param cameraType
		 * 
		 */
		protected function createBasicView(viewportWidth:Number, viewportHeight:Number, autoScaleToStage:Boolean = true, interactive:Boolean = false, cameraType:String = "Target"):void
		{
			
			trace("BasicViewPV3D2Flex set up: "+width+"x"+height+", autoScaleToStage: "+_autoScaleToStage+", interactive: "+_interactive+", cameraType: "+_cameraType);
			pv3DView = new BasicView(viewportWidth, viewportHeight, autoScaleToStage, interactive, cameraType);
			this.addChild(pv3DView);
			
			dispatchEvent(new PV3DFlexEvent(PV3DFlexEvent.BASICVIEW_CREATED, false, false));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creation complete handler.  Sets up BasicView.
		 * @param event
		 * 
		 */
		protected function onCreationCompleteInitializePV3DView(event:FlexEvent):void
		{
			
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteInitializePV3DView);
			
			if (cameraType == null)
				cameraType = CameraType.TARGET;
			
			createBasicView(width, height, autoScaleToStage, interactive, cameraType);
			
			// Trigger rendering through setter
			rendering = _rendering;
			
		}
		
		/**
		 * Resize event handler to resize the basic view.
		 * @param event
		 * 
		 */
		private function onResize(event:ResizeEvent):void
		{
			
			if (pv3DView != null)
			{
				
				//pv3DView.viewportWidth = width;
				//pv3DView.viewportHeight = height;
				pv3DView.viewport.width = width;
				pv3DView.viewport.height = height;
				
			}
			
		}
		
	}
	
}