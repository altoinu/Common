/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.simplephysicsengine.objects
{
	
	import com.altoinu.flash.simplephysicsengine.controllers.SimplePhysicsController;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.papervision3d.view.BasicView;
	
	/**
	 * Papervision BasicView component that displays and applies physics to all ISimplePhysicsObject3D (SimplePhysicsPV3DObject3D)
	 * in the scene.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @see com.altoinu.flash.simplephysicsengine.objects.ISimplePhysicsObject3D
	 * @see com.altoinu.flash.simplephysicsengine.objects.SimplePhysicsPV3DObject3D
	 * 
	 */
	public class SimplePhysicsPV3DBasicView extends BasicView
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param viewportWidth		Width of the viewport 
		 * @param viewportHeight	Height of the viewport
		 * @param scaleToStage		Whether you viewport should scale with the stage
		 * @param interactive		Whether your scene should be interactive
		 * @param cameraType		A String for the type of camera. @see org.papervision3d.cameras.CameraType
		 * 
		 */	
		public function SimplePhysicsPV3DBasicView(viewportWidth:Number = 640, viewportHeight:Number = 480, scaleToStage:Boolean = true, interactive:Boolean = false, cameraType:String = "Target")
		{
			
			super(viewportWidth, viewportHeight, scaleToStage, interactive, cameraType);
			
			setRenderFrameEvent();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Used by renderer and stage physics.
		 */
		private var _previousRenderTime:int = 0;
		
		private var _isDoingEnterFrameRendering:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  stagePhysics
		//--------------------------------------
		
		private var _stagePhysics:SimplePhysicsController = new SimplePhysicsController();
		
		/**
		 * Physics controller on this game stage.
		 */
		public function get stagePhysics():SimplePhysicsController
		{
			
			return _stagePhysics;
			
		}
		
		//--------------------------------------
		//  rendering
		//--------------------------------------
		
		/**
		 * @private
		 */
		private var _rendering:Boolean = false;
		
		/**
		 * If set to true, then SimplePhysicsPV3DBasicView renders screen every frame.
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
			
			if (_rendering != value)
			{
				
				_rendering = value;
				
				setRenderFrameEvent();
				
			}
			
		}
		
		//--------------------------------------
		//  renderEveryFrame
		//--------------------------------------
		
		[Deprecated(replacement="rendering")]
		/**
		 * If set to true, then SimplePhysicsPV3DBasicView renders screen every frame.
		 */
		public function get renderEveryFrame():Boolean
		{
			
			return rendering;
			
		}
		
		[Deprecated(replacement="rendering")]
		/**
		 * @private
		 */
		public function set renderEveryFrame(value:Boolean):void
		{
			
			rendering = value;
			
		}
		
		//--------------------------------------
		//  applyPhysicsEveryFrame
		//--------------------------------------
		
		private var _applyPhysicsEveryFrame:Boolean = true;
		
		/**
		 * If set to true, then stagePhysics is applied to all ISimplePhysicsObject3D on SimplePhysicsPV3DBasicView.
		 */
		public function get applyPhysicsEveryFrame():Boolean
		{
			
			return _applyPhysicsEveryFrame;
			
		}
		
		/**
		 * @private
		 */
		public function set applyPhysicsEveryFrame(value:Boolean):void
		{
			
			if (_applyPhysicsEveryFrame != value)
			{
				
				_applyPhysicsEveryFrame = value;
				
				setRenderFrameEvent();
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Starts enterframe event listener to render Papervision stage every frame.
		 */
		override public function startRendering():void
		{
			
			rendering = true;
			
		}
		
		/**
		 * Stops Papervision render started by startPaperVisionRender.
		 */
		override public function stopRendering(reRender:Boolean = false, cacheAsBitmap:Boolean = false):void
		{
			
			rendering = false;
			
			if (reRender)
				onRenderTick();
			
			viewport.containerSprite.cacheAsBitmap = cacheAsBitmap;
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function singleRender():void
		{
			
			//renderer.renderScene(scene, camera, viewport);
			super.singleRender();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		[Deprecated(replacement="startRendering")]
		/**
		 * Starts enterframe event listener to render Papervision stage every frame.
		 */
		public function startPaperVisionRender():void
		{
			
			startRendering();
			
		}
		
		[Deprecated(replacement="stopRendering")]
		/**
		 * Stops Papervision render started by startPaperVisionRender.
		 */
		public function stopPaperVisionRender():void
		{
			
			stopRendering();
			
		}
		
		private function setRenderFrameEvent():void
		{
			
			if (rendering)// || applyPhysicsEveryFrame)
			{
				
				// Start render
				if (!_isDoingEnterFrameRendering)
				{
					
					_isDoingEnterFrameRendering = true;
					_previousRenderTime = getTimer();
					addEventListener(Event.ENTER_FRAME, processView);
					
				}
				
			}
			else
			{
				
				// Stop render
				removeEventListener(Event.ENTER_FRAME, processView);
				_isDoingEnterFrameRendering = false;
				
			}
			
			singleRender();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Applies physics and renders viewport.
		 * @param event
		 * 
		 */
		public function processView(event:Event = null):void
		{
			
			var millisecondsElapsed:int = getTimer() - _previousRenderTime;
			_previousRenderTime = getTimer();
			
			if (applyPhysicsEveryFrame)
				stagePhysics.apply(scene.objects, millisecondsElapsed); // Figure out the physics
			
			if (rendering)
				singleRender(); // Then render
			
		}
		
		[Deprecated(replacement="processView")]
		/**
		 * Renders game stage viewport.
		 * @param event
		 * 
		 */
		public function renderGameStage(event:Event = null):void
		{
			
			processView(event);
			
		}
		
	}
	
}