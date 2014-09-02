/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls.external.javascript
{
	
	import com.altoinu.flash.external.javascript.AnchorToHTMLPage;
	import com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent;
	import com.altoinu.flex.customcomponents.mx.controls.supportClasses.HolderUIComponentBase;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * Base class to display AnchorToHTMLPage component in Flex.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AnchorToHTMLPageUIComponent extends HolderUIComponentBase
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
		public function AnchorToHTMLPageUIComponent()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  anchor
		//----------------------------------
		
		protected var _anchor:AnchorToHTMLPage;
		
		public function get anchor():AnchorToHTMLPage
		{
			
			return _anchor;
			
		}
		
		//----------------------------------
		//  updatePositionJSMethod
		//----------------------------------
		
		private var _updatePositionJSMethod:String = "addHTMLElement";
		
		/**
		 * @default "addHTMLElement"
		 * @copy com.altoinu.flash.external.javascript.AnchorToHTMLPage#updatePositionJSMethod
		 */
		public function get updatePositionJSMethod():String
		{
			
			if (anchor != null)
				return anchor.updatePositionJSMethod;
			else
				return _updatePositionJSMethod;
			
		}
		
		/**
		 * @private
		 */
		public function set updatePositionJSMethod(value:String):void
		{
			
			if (anchor != null)
				throw new Error("updatePositionJSMethod can only be set once.");
			
			_updatePositionJSMethod = value;
			
		}
		
		//----------------------------------
		//  removeJSMethod
		//----------------------------------
		
		private var _removeJSMethod:String = "removeHTMLElement";
		
		/**
		 * @default "removeHTMLElement"
		 * @copy com.altoinu.flash.external.javascript.AnchorToHTMLPage#removeJSMethod
		 */
		public function get removeJSMethod():String
		{
			
			if (anchor != null)
				return anchor.removeJSMethod;
			else
				return _removeJSMethod;
			
		}
		
		/**
		 * @private
		 */
		public function set removeJSMethod(value:String):void
		{
			
			if (anchor != null)
				throw new Error("removeJSMethod can only be set once.");
			
			_removeJSMethod = value;
			
		}
		
		//----------------------------------
		//  elementID
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.external.javascript.AnchorToHTMLPage#elementID
		 */
		public function get elementID():String
		{
			
			if (anchor != null)
				return anchor.elementID;
			else
				return null;
			
		}
		
		//----------------------------------
		//  options
		//----------------------------------
		
		private var _options:Object;
		
		[Bindable(event="optionsChange")]
		/**
		 * @copy com.altoinu.flash.external.javascript.AnchorToHTMLPage#options
		 */
		public function get options():Object
		{
			
			if (anchor != null)
				return anchor.options;
			else
				return _options;
			
		}
		
		/**
		 * @private
		 */
		public function set options(value:Object):void
		{
			
			_options = value;
			
			if (anchor != null)
				anchor.options = value;
			
			dispatchEvent(new Event("optionsChange"));
			
			/*
			if (anchor != null)
			throw new Error("options can only be set once.");
			
			_options = value;
			*/
			
		}
		
		//----------------------------------
		//  targetDivID
		//----------------------------------
		
		private var _targetDivID:String = "flashContainer";
		
		[Bindable(event="targetDivIDChange")]
		/**
		 * @copy com.altoinu.flash.external.javascript.AnchorToHTMLPage#targetDivID
		 */
		public function get targetDivID():String
		{
			
			if (anchor != null)
				return anchor.targetDivID;
			else
				return _targetDivID;
			
		}
		
		/**
		 * @private
		 */
		public function set targetDivID(value:String):void
		{
			
			_targetDivID = value;
			
			if (anchor != null)
				anchor.targetDivID = value;
			
			dispatchEvent(new Event("targetDivIDChange"));
			
		}
		
		//----------------------------------
		//  contentCoordinate
		//----------------------------------
		
		/**
		 * @copy com.altoinu.flash.external.javascript.AnchorToHTMLPage#contentCoordinate
		 */
		public function get contentCoordinate():Point
		{
			
			if (anchor != null)
				return anchor.contentCoordinate;
			else
				return null;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function initializeComponent():void
		{
			
			super.initializeComponent();
			
			// Initialize AnchorToHTMLPage component
			if (updatePositionJSMethod == null)
			{
				
				throw new Error("updatePositionJSMethod is not defined.");
				return;
				
			}
			else if (removeJSMethod == null)
			{
				
				throw new Error("removeJSMethod is not defined.");
				return;
				
			}
			
			if (anchor == null)
				_anchor = new AnchorToHTMLPage(updatePositionJSMethod, removeJSMethod, "flash_JS_", options, targetDivID);
			
			if (!anchor.hasEventListener(AnchorToHTMLPageEvent.INITIALIZE_AT_ADD_TO_STAGE))
			{
				
				anchor.addEventListener(AnchorToHTMLPageEvent.INITIALIZE_AT_ADD_TO_STAGE, onAnchorComponentAddedToStage, false, 0, true);
				anchor.addEventListener(AnchorToHTMLPageEvent.DE_INITIALIZE_AT_REMOVE_FROM_STAGE, onAnchorComponentRemovedFromStage, false, 0, true);
				
			}
			
			addChild(anchor);
			
		}
		
		override protected function destroyComponent():void
		{
			
			super.destroyComponent();
			
			if (anchor != null)
			{
				
				anchor.removeComponent();
				
				if (anchor.hasEventListener(AnchorToHTMLPageEvent.INITIALIZE_AT_ADD_TO_STAGE))
				{
					
					anchor.removeEventListener(AnchorToHTMLPageEvent.INITIALIZE_AT_ADD_TO_STAGE, onAnchorComponentAddedToStage, false);
					anchor.removeEventListener(AnchorToHTMLPageEvent.DE_INITIALIZE_AT_REMOVE_FROM_STAGE, onAnchorComponentRemovedFromStage, false);
					
				}
				
				if (anchor.parent)
					anchor.parent.removeChild(anchor);
				
				_anchor = null;
				
			}
			
		}
		
		override protected function resizeAndFitComponent(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			super.resizeAndFitComponent(unscaledWidth, unscaledHeight);
			
			if (anchor != null)
			{
				
				anchor.visible = (visible && enabled && (width > 0) && (height > 0)); // component visible when visible, enabled, and width and height > 0
				
				if (anchor.visible)
					anchor.setSize(unscaledWidth, unscaledHeight); // Tell the anchor component current size of the UIComponent so it can match
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onAnchorComponentAddedToStage(event:Event):void
		{
			
			invalidateDisplayList();
			
		}
		
		private function onAnchorComponentRemovedFromStage(event:Event):void
		{
			
			invalidateDisplayList();
			
		}
		
	}
	
}