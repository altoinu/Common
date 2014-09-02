/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.pv3d
{
	
	import com.altoinu.flash.customcomponents.drawingboard.imageEditTools.proto.Image_UpdateTool;
	import com.altoinu.flash.pv3d.objects.parsers.DesignableDAEModel;
	import com.altoinu.flash.pv3d.view.DesignableDAEModelView;
	import com.altoinu.flex.customcomponents.events.PV3DFlexEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	/**
	 * DesignableDAEModelView component for Flex.
	 * 
	 * @see com.altoinu.flash.pv3d.view.DesignableDAEModelView
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DesignableDAEModelViewFlex extends BasicViewPV3D2Flex
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
		public function DesignableDAEModelViewFlex()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  targetModel
		//--------------------------------------
		
		private var _targetModel:DesignableDAEModel;
		
		[Bindable(event="targetModelChange")]
		/**
		 * @copy com.altoinu.flash.pv3d.view.DesignableDAEModelView#targetModel
		 */
		public function get targetModel():DesignableDAEModel
		{
			
			if ((pv3DView != null) && (pv3DView is DesignableDAEModelView))
				return DesignableDAEModelView(pv3DView).targetModel;
			else
				return _targetModel;
			
		}
		
		/**
		 * @private
		 */
		public function set targetModel(daeModel:DesignableDAEModel):void
		{
			
			_targetModel = daeModel;
			
			if ((pv3DView != null) && (pv3DView is DesignableDAEModelView))
				DesignableDAEModelView(pv3DView).targetModel = _targetModel;
			
			dispatchEvent(new Event("targetModelChange"));
			
		}
		
		//--------------------------------------
		//  mouseDrawEraseEnabled
		//--------------------------------------
		
		private var _mouseDrawEraseEnabled:Boolean = true;
		
		[Bindable(event="mouseDrawEraseEnabledChanged")]
		[Inspectable(category="Other", enumeration="true,false", defaultValue="true")]
		/**
		 * @copy com.altoinu.flash.pv3d.view.DesignableDAEModelView#mouseDrawEraseEnabled
		 */
		public function get mouseDrawEraseEnabled():Boolean
		{
			
			if (pv3DView != null)
				return DesignableDAEModelView(pv3DView).mouseDrawEraseEnabled;
			else
				return _mouseDrawEraseEnabled;
			
		}
		
		/**
		 * @private
		 */
		public function set mouseDrawEraseEnabled(value:Boolean):void
		{
			
			_mouseDrawEraseEnabled = value;
			
			if (pv3DView != null)
			{
				
				DesignableDAEModelView(pv3DView).mouseDrawEraseEnabled = value;
				
				dispatchEvent(new Event("mouseDrawEraseEnabledChanged"));
				
			}
			
		}
		
		//--------------------------------------
		//  mouseInteractionEnabled
		//--------------------------------------
		
		[Deprecated(replacement="mouseDrawEraseEnabled")]
		[Bindable(event="mouseDrawEraseEnabledChanged")]
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
		//  mouseDragSelectionEnabled
		//--------------------------------------
		
		private var _mouseDragSelectionEnabled:Boolean = true;
		
		[Bindable(event="mouseDragSelectionEnabledChanged")]
		[Inspectable(category="Other", enumeration="true,false", defaultValue="true")]
		/**
		 * @copy com.altoinu.flash.pv3d.view.DesignableDAEModelView#mouseDragSelectionEnabled
		 */
		public function get mouseDragSelectionEnabled():Boolean
		{
			
			if (pv3DView != null)
				return DesignableDAEModelView(pv3DView).mouseDragSelectionEnabled;
			else
				return _mouseDragSelectionEnabled;
			
		}
		
		/**
		 * @private
		 */
		public function set mouseDragSelectionEnabled(value:Boolean):void
		{
			
			_mouseDragSelectionEnabled = value;
			
			if (pv3DView != null)
			{
				
				DesignableDAEModelView(pv3DView).mouseDragSelectionEnabled = value;
				
				dispatchEvent(new Event("mouseDragSelectionEnabledChanged"));
				
			}
			
		}
		
		//--------------------------------------
		//  currentTool
		//--------------------------------------
		
		private var _currentTool:Image_UpdateTool;
		
		[Bindable(event="currentToolChanged")]
		/**
		 * @copy com.altoinu.flash.pv3d.view.DesignableDAEModelView#currentTool
		 */
		public function get currentTool():Image_UpdateTool
		{
			
			if (pv3DView != null)
				return DesignableDAEModelView(pv3DView).currentTool;
			else
				return _currentTool;
			
		}
		
		/**
		 * @private
		 */
		public function set currentTool(newTool:Image_UpdateTool):void
		{
			
			_currentTool = newTool;
			
			if (pv3DView != null)
			{
				
				DesignableDAEModelView(pv3DView).currentTool = newTool;
				
				dispatchEvent(new Event("currentToolChanged"));
				
			}
			
		}
		
		//--------------------------------------
		//  designableDAEModelView
		//--------------------------------------
		
		/**
		 * DesignableDAEModelView component.  This is the same as <code>basicView</code>
		 * but has type DesignableDAEModelView for code completion convenience.
		 * 
		 * @see org.papervision3d.view.BasicView
		 */
		public function get designableDAEModelView():DesignableDAEModelView
		{
			
			return DesignableDAEModelView(basicView);
			
		}
		
		//--------------------------------------
		//  currentDragImage
		//--------------------------------------
		
		/**
		 * @copy com.altoinu.flash.pv3d.view.DesignableDAEModelView#currentDragImage
		 */
		public function get currentDragImage():DisplayObject
		{
			
			return DesignableDAEModelView(basicView).currentDragImage;
			
		}
		
		//--------------------------------------
		//  isMouseDraggingImage
		//--------------------------------------
		
		/**
		 * @copy com.altoinu.flash.pv3d.view.DesignableDAEModelView#isMouseDraggingImage
		 */
		public function get isMouseDraggingImage():Boolean
		{
			
			return DesignableDAEModelView(basicView).isMouseDraggingImage;
			
		}
		
		//--------------------------------------
		//  isSelectToolMouseDragging
		//--------------------------------------
		
		/**
		 * @copy com.altoinu.flash.pv3d.view.DesignableDAEModelView#isSelectToolMouseDragging
		 */
		public function get isSelectToolMouseDragging():Boolean
		{
			
			return DesignableDAEModelView(basicView).isSelectToolMouseDragging;
			
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
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Method overridden for DesignableDAEModelViewFlex to use <code>DesignableDAEModelView</code>
		 * instead of regular BasicView.
		 * 
		 * @param viewportWidth
		 * @param viewportHeight
		 * @param autoScaleToStage
		 * @param interactive
		 * @param cameraType
		 * 
		 */
		override protected function createBasicView(viewportWidth:Number, viewportHeight:Number, autoScaleToStage:Boolean=true, interactive:Boolean=false, cameraType:String="Target"):void
		{
			
			//super.createBasicView(viewportWidth, viewportHeight, autoScaleToStage, interactive, cameraType);
			// Instead of creating normal BasicView, use DesignableDAEModelView
			pv3DView = new DesignableDAEModelView(targetModel, viewportWidth, viewportHeight, autoScaleToStage, interactive, cameraType);
			this.addChild(pv3DView);
			
			dispatchEvent(new PV3DFlexEvent(PV3DFlexEvent.BASICVIEW_CREATED, false, false));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function onCreationCompleteInitializePV3DView(event:FlexEvent):void
		{
			
			super.onCreationCompleteInitializePV3DView(event);
			
			// Trigger setters that requires property pv3DView
			mouseDragSelectionEnabled = mouseDragSelectionEnabled;
			mouseDrawEraseEnabled = mouseDrawEraseEnabled;
			currentTool = currentTool;
			
		}
		
	}
	
}