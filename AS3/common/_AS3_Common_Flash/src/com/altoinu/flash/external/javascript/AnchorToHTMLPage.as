/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.external.javascript
{
	
	import com.altoinu.flash.customcomponents.supportClasses.AnchorBase;
	import com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent;
	import com.altoinu.flash.utils.EnterFrameManager;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *  Dispatched when AnchorToHTMLPage component comes to view from Event.ADDED_TO_STAGE event
	 * and initialization of it is completed.
	 *
	 *  @eventType com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent.INITIALIZE_AT_ADD_TO_STAGE
	 */
	[Event(name="initializeAtAddToStage", type="com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent")]
	
	/**
	 *  Dispatched when AnchorToHTMLPage component goes out of view from Event.REMOVED_FROM_STAGE event
	 * and de-initialization of it is completed.
	 *
	 *  @eventType com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent.DE_INITIALIZE_AT_REMOVE_FROM_STAGE
	 */
	[Event(name="deInitializeAtRemoveFromStage", type="com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent")]
	
	/**
	 *  Dispatched after <code>updatePositionJSMethod</code> is called.
	 *
	 *  @eventType com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent.UPDATE_POSITION
	 */
	[Event(name="updatePosition", type="com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent")]
	
	/**
	 *  Dispatched after <code>removeJSMethod</code> is called.
	 *
	 *  @eventType com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent.REMOVE_COMPONENT
	 */
	[Event(name="removeComponent", type="com.altoinu.flash.external.javascript.events.AnchorToHTMLPageEvent")]
	
	/**
	 * Component that will constantly communicate its position and size to the HTML page Flash content
	 * is being displayed at via JavaScript method specified through ExternalInterface.
	 * 
	 * <p>This class may come in handy if you want something to automatically let the HTML page know
	 * of its relative position and size... Ex. to position a div element right at where this component is
	 * placed at.</p>
	 * 
	 * <p>AnchorToHTMLPage notifies HTML page using two JavaScript methods specified for properties
	 * <code>updatePositionJSMethod</code> and <code>removeJSMethod</code> along with some parameters.
	 * <code>updatePositionJSMethod</code> is called every time position, size, and/or visibility is updated
	 * through <code>ExternalInterface.call(updatePositionJSMethod, {id: elementID, x: contentCoordinate.x, y: contentCoordinate.y, width: contentWidth, height: contentHeight, options: options})</code>.
	 * <code>removeJSMethod</code> is called if AnchorToHTMLPage is gone from the view (visible = false, removed from stage)
	 * through <code>ExternalInterface.call(removeJSMethod, elementID)</code>. On HTML/JavaScript end,
	 * these methods can then use given parameters to perform specific actions (ex. positioning div element)</p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AnchorToHTMLPage extends AnchorBase
	{
		
		//--------------------------------------------------------------------------
		//
		//  Static properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Keep track of elements being created...
		 */
		private static var elementCount:int = 0;
		
		private static var enterFrameManager:EnterFrameManager;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param updatePositionJSMethod JavaScript function on the HTML page that <code>AnchorToHTMLPage</code> will call through.
		 * <code>ExternalInterface.call(updatePositionJSMethod, {id: elementID, x: contentCoordinate.x, y: contentCoordinate.y, width: contentWidth, height: contentHeight, options: options})</code>
		 * to notify HTML page of its position and size.
		 * 
		 * @param removeJSMethod JavaScript function on the HTML page that AnchorToHTMLPage will call through.
		 * <code>ExternalInterface.call(removeJSMethod, elementID)</code> to notify HTML page
		 * that <code>AnchorToHTMLPage</code> component has been removed from the view.
		 * 
		 * @param elementIDPrefix
		 * 
		 * @param options Any additional options to be passed to <code>updatePositionJSMethod</code>
		 * 
		 * @param targetDivID ID of DIV element on HTML page
		 * 
		 */
		public function AnchorToHTMLPage(updatePositionJSMethod:String,
										 removeJSMethod:String,
										 elementIDPrefix:String = "flash_JS_",
										 options:Object = null,
										 targetDivID:String = null)
		{
			
			super();
			
			_updatePositionJSMethod = updatePositionJSMethod;
			_removeJSMethod = removeJSMethod;
			_options = options;
			_targetDivID = targetDivID;
			
			if ((elementIDPrefix != null) && (elementIDPrefix != ""))
				_elementIDPrefix = elementIDPrefix;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var renderEvent:Boolean = false;
		
		//----------------------------------
		//  inView
		//----------------------------------
		
		private function get inView():Boolean
		{
			
			// Is it visible and on stage?
			return visible && (this.stage != null);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get visible():Boolean
		{
			
			return super.visible;
			
		}
		
		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			
			if (super.visible != value)
			{
				
				super.visible = value;
				
				invalidatePositionAndSize(); // invalidate position/size so it will be updated in next enterframe cycle
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  updatePositionJSMethod
		//----------------------------------
		
		private var _updatePositionJSMethod:String = "";
		
		/**
		 * JavaScript function on the HTML page that AnchorToHTMLPage will call through
		 * <code>ExternalInterface.call(updatePositionJSMethod, {id: elementID, x: contentCoordinate.x, y: contentCoordinate.y, width: contentWidth, height: contentHeight, options: options})</code>
		 * to notify HTML page of its position and size.
		 */
		public function get updatePositionJSMethod():String
		{
			
			return _updatePositionJSMethod;
			
		}
		
		//----------------------------------
		//  removeJSMethod
		//----------------------------------
		
		private var _removeJSMethod:String = "";
		
		/**
		 * JavaScript function on the HTML page that AnchorToHTMLPage will call through
		 * <code>ExternalInterface.call(removeJSMethod, elementID)</code> to notify HTML page
		 * that AnchorToHTMLPage component has been removed from the view.
		 */
		public function get removeJSMethod():String
		{
			
			return _removeJSMethod;
			
		}
		
		//----------------------------------
		//  elementIDPrefix
		//----------------------------------
		
		private var _elementIDPrefix:String = "flash_JS_";
		
		public function get elementIDPrefix():String
		{
			
			return _elementIDPrefix;
			
		}
		
		//----------------------------------
		//  elementID
		//----------------------------------
		
		protected var _elementID:String = "";
		
		/**
		 * ID that references current instance on the HTML page. This is passed with
		 * <code>updatePositionJSMethod</code> and <code>removeJSMethod</code> as parameters through
		 * <code>ExternalInterface.call</code> so JavaScript can use it to keep track of
		 * the calls being made from Flash.
		 * 
		 * <p>For example, this ID can be used to create HTML div element with <code>updatePositionJSMethod</code>
		 * and <code>removeJSMethod</code> can remove it later using the same ID.</p>
		 */
		public function get elementID():String
		{
			
			return _elementID;
			
		}
		
		//----------------------------------
		//  contentCoordinate
		//----------------------------------
		
		private var _contentCoordinate:Point;
		
		/**
		 * Coordinate of the component on stage. This is passed with
		 * <code>updatePositionJSMethod</code> as parameters through <code>ExternalInterface.call</code>.
		 */
		public function get contentCoordinate():Point
		{
			
			if (_contentCoordinate != null)
				return new Point(_contentCoordinate.x, _contentCoordinate.y);
			else
				return null;
			
		}
		
		//----------------------------------
		//  options
		//----------------------------------
		
		protected var _options:Object = null;
		
		/**
		 * Any optional additional parameters to be passed to <code>updatePositionJSMethod</code>.
		 */
		public function get options():Object
		{
			
			return _options;
			
		}
		
		/**
		 * @private
		 */
		public function set options(value:Object):void
		{
			
			if (_options != value)
			{
				
				_options = value;
				
				invalidatePositionAndSizeIfInView();
				
			}
			
		}
		
		//----------------------------------
		//  targetDivID
		//----------------------------------
		
		private var _targetDivID:String = "flashContainer";
		
		/**
		 * ID of DIV element on HTML page where this AnchorToHTMLPage will be relatively positioned.
		 * If corresponding DIV cannot be found the element will be placed at document body.
		 */
		public function get targetDivID():String
		{
			
			return _targetDivID;
			
		}
		
		/**
		 * @private
		 */
		public function set targetDivID(value:String):void
		{
			
			if (_targetDivID != value)
			{
				
				_targetDivID = targetDivID;
				
				invalidatePositionAndSizeIfInView();
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function resizeAndFitComponent():void
		{
			
			super.resizeAndFitComponent();
			
			if (inView)
				updatePosition();
			else // hidden or not on stage, so remove
				removeComponent();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes component when it comes to view from Event.ADDED_TO_STAGE event. Override this method
		 * to do any initializations when the component comes into view.
		 * 
		 */
		protected function initializeAtAddToStage():void {}
		
		/**
		 * De-initializes component when it goes out of view from Event.REMOVED_FROM_STAGE event.
		 * Override this method to do any de-initializations when the component is removed from view.
		 * 
		 */
		protected function deInitializeAtRemoveFromStage():void {}
		
		/**
		 * Method to do the actual JavaScript call
		 * <code>ExternalInterface.call(updatePositionJSMethod, {id: elementID, x: contentCoordinate.x, y: contentCoordinate.y, width: contentWidth, height: contentHeight, options: options, targetDivID: targetDivID})</code>
		 * 
		 * <p>Override this method to do anything a little different (ex. pass extra parameters)</p>
		 * 
		 * @param jsMethod updatePositionJSMethod
		 * @param id elementID
		 * @param contentRect
		 * @param options
		 * @param targetDivID
		 * @param extra
		 * 
		 */
		protected function executeUpdatePositionJSMethod(jsMethod:String,
														 id:String,
														 contentRect:Rectangle,
														 options:Object,
														 targetDivID:String = null,
														 extra:Object = null):void
		{
			
			// Parameters passed to jsMethod
			var parameters:Object = new Object();
			parameters.id = id;
			parameters.x = contentRect.x;
			parameters.y = contentRect.y;
			parameters.width = contentRect.width;
			parameters.height = contentRect.height;
			parameters.options = options;
			
			if (targetDivID)
				parameters.targetDivID = targetDivID;
			
			if (extra)
			{
				
				for (var extraParam:String in extra)
				{
					
					if ((extraParam != "id") &&
						(extraParam != "x") &&
						(extraParam != "y") &&
						(extraParam != "width") &&
						(extraParam != "height") &&
						(extraParam != "options") &&
						(extraParam != "targetDivID"))
					{
						
						parameters[extraParam] = extra[extraParam];
						
					}
					
				}
				
			}
			
			// Pass info to JavaScript
			ExternalInterface.call(jsMethod, parameters);
			
		}
		
		/**
		 * Method to do the actual JavaScript call
		 * <code>ExternalInterface.call(removeJSMethod, elementID)</code>
		 * 
		 * <p>Override this method to do anything a little different (ex. pass extra parameters)</p>
		 * 
		 * @param jsMethod removeJSMethod
		 * @param id elementID
		 * 
		 * @return
		 * 
		 */
		protected function executeRemoveJSMethod(jsMethod:String, id:String):void
		{
			
			ExternalInterface.call(jsMethod, id);
			
		}
		
		/**
		 * Updates the component.
		 * 
		 */
		protected final function invalidatePositionAndSizeIfInView():void
		{
			
			if (inView)
				invalidatePositionAndSize(); // invalidate position/size so it will be updated in next enterframe cycle
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Invalidates position and size of the component so it is updated in next enter frame cycle.
		 */
		public function invalidatePositionAndSize():void
		{
			
			// Update coordinate of the component
			_contentCoordinate = localToGlobal(new Point(x, y));
			
			invalidateDisplay();
			
		}
		
		/**
		 * Sets width and height at the same time.
		 * @param newWidth
		 * @param newHeight
		 * 
		 */
		public function setSize(newWidth:Number, newHeight:Number):void
		{
			
			width = newWidth;
			height = newHeight;
			
			invalidatePositionAndSizeIfInView();
			
		}
		
		/**
		 * Calls <code>ExternalInterface.call(updatePositionJSMethod, {id: elementID, x: contentCoordinate.x, y: contentCoordinate.y, width: contentWidth, height: contentHeight, options: options})</code>
		 * if AnchorToHTMLPage is in the view (visible and on stage).
		 * 
		 * @param suppressEvent
		 * 
		 */
		public function updatePosition(suppressEvent:Boolean = false):void
		{
			
			// Remove previous instance just in case
			removeComponent(true);
			
			if (inView)
			{
				
				// Add if component is visible and is on stage
				
				elementCount++;
				_elementID = elementIDPrefix + String(elementCount);
				
				var jsmethod:String = updatePositionJSMethod;
				var updateElementID:String = elementID;
				var contentRect:Rectangle = new Rectangle(contentCoordinate.x, contentCoordinate.y, width, height);
				executeUpdatePositionJSMethod(jsmethod, updateElementID, contentRect, options, targetDivID);
				
				if (!suppressEvent)
					dispatchEvent(new AnchorToHTMLPageEvent(AnchorToHTMLPageEvent.UPDATE_POSITION, false, false, jsmethod, updateElementID, contentRect));
				
			}
			
		}
		
		/**
		 * Calls <code>ExternalInterface.call(removeJSMethod, elementID)</code>.
		 * 
		 * @param suppressEvent
		 * 
		 */
		public function removeComponent(suppressEvent:Boolean = false):void
		{
			
			if ((elementID != null) && (elementID != ""))
			{
				
				var jsmethod:String = removeJSMethod;
				var updateElementID:String = elementID;
				executeRemoveJSMethod(removeJSMethod, updateElementID);
				
				if (!suppressEvent)
					dispatchEvent(new AnchorToHTMLPageEvent(AnchorToHTMLPageEvent.REMOVE_COMPONENT, false, false, jsmethod, updateElementID));
				
				_elementID = "";
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onAddedToStage(event:Event):void
		{
			
			if (!renderEvent)
			{
				
				// Start watching for render event
				
				if (enterFrameManager == null)
					enterFrameManager = new EnterFrameManager();
				
				enterFrameManager.addEnterFrameAction(onEnterFrameUpdatePositionAndSize);
				
				renderEvent = true;
				
				initializeAtAddToStage();
				
				dispatchEvent(new AnchorToHTMLPageEvent(AnchorToHTMLPageEvent.INITIALIZE_AT_ADD_TO_STAGE));
				
				onEnterFrameUpdatePositionAndSize();
				
			}
			
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			
			if (renderEvent)
			{
				
				enterFrameManager.removeEnterFrameAction(onEnterFrameUpdatePositionAndSize);
				renderEvent = false;
				
				deInitializeAtRemoveFromStage();
				
				dispatchEvent(new AnchorToHTMLPageEvent(AnchorToHTMLPageEvent.DE_INITIALIZE_AT_REMOVE_FROM_STAGE));
				
				invalidateDisplay();
				
			}
			
		}
		
		/**
		 * Event handler for Event.ENTER_FRAME event, executed everytime display list is rendered on screen.
		 * @param event
		 * 
		 */
		private function onEnterFrameUpdatePositionAndSize(event:Event = null):void
		{
			
			if (inView)
			{
				
				// Visible and on stage
				
				// Does position need updating?
				var currentCoord:Point = localToGlobal(new Point(x, y));
				if ((contentCoordinate == null) || (contentCoordinate.x != currentCoord.x) || (contentCoordinate.y != currentCoord.y))
					invalidatePositionAndSize();
				
			}
			else
			{
				
				invalidateDisplay();
				
			}
			
		}
		
	}
	
}
