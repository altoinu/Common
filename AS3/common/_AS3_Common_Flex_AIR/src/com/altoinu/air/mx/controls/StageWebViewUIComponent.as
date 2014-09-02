/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.air.mx.controls
{
	
	import com.altoinu.flex.customcomponents.events.StageWebViewUIComponentEvent;
	import com.altoinu.flex.customcomponents.mx.controls.supportClasses.HolderUIComponentBase;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	/**
	 * Signals that the last load operation requested by loadString() or loadURL() method has completed.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Signals that an error has occurred.
	 * 
	 * @eventType flash.events.ErrorEvent.ERROR
	 */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 * Dispatched when this StageWebView object receives focus.
	 * 
	 * @eventType flash.events.FocusEvent.FOCUS_IN
	 */
	[Event(name="focusIn", type="flash.events.FocusEvent")]
	
	/**
	 * Dispatched when the StageWebView relinquishes focus.
	 * 
	 * @eventType flash.events.FocusEvent.FOCUS_OUT
	 */
	[Event(name="focusOut", type="flash.events.FocusEvent")]
	
	/**
	 * Signals that the location property of the StageWebView object has changed.
	 * 
	 * @eventType com.altoinu.flex.customcomponents.events.StageWebViewUIComponentEvent.LOCATION_CHANGE
	 */
	[Event(name="locationChange", type="com.altoinu.flex.customcomponents.events.StageWebViewUIComponentEvent")]
	
	/**
	 * Signals that the location property of the StageWebView object is about to change.
	 * 
	 * @eventType com.altoinu.flex.customcomponents.events.StageWebViewUIComponentEvent.LOCATION_CHANGING
	 */
	[Event(name="locationChanging", type="com.altoinu.flex.customcomponents.events.StageWebViewUIComponentEvent")]
	
	/**
	 * UIComponent to display StageWebView on top of it.
	 * 
	 * <p>
	 * <pre>
	 * &lt;controls:StageWebViewUIComponent width=&quote;100%&quote; height=&quote;100%&quote;
	 * 										source=&quote;{contentURL}&quote;/&gt;
	 * </pre>
	 * </p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class StageWebViewUIComponent extends HolderUIComponentBase
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StageWebViewUIComponent()
		{
			
			super();
			
			if (!StageWebView.isSupported)
				throw new Error("StageWebView not supported on this device...");
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private variables
		//
		//--------------------------------------------------------------------------
		
		private var stageWebViewBitmap:Bitmap;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properites
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  stageWebView
		//--------------------------------------
		
		private var _stageWebView:StageWebView;
		
		/**
		 * Reference to StageWebView on this UIComponent.
		 */
		protected function get stageWebView():StageWebView
		{
			
			return _stageWebView;
			
		}
		
		/**
		 * @private
		 */
		protected function set stageWebView(value:StageWebView):void
		{
			
			_stageWebView = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properites
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  source
		//--------------------------------------
		
		private var _source:String;
		
		[Bindable(event="sourceChange")]
		/**
		 * URL to load.
		 * 
		 * <p>TODO: currently StageWebViewUIComponent can only load external contents. Eventually
		 * I would like it to be able to load HTML String as well just like StageWebView component
		 * itself can do.</p>
		 */
		public function get source():String
		{
			
			return _source;
			
		}
		
		/**
		 * @private
		 */
		public function set source(value:String):void
		{
			
			if (_source !== value)
			{
				
				_source = value;
				
				_contentLoaded = false;
				loadHTMLContents();
				
				dispatchEvent(new Event("sourceChange"));
				
			}
			
		}
		
		//--------------------------------------
		//  contentLoaded
		//--------------------------------------
		
		private var __contentLoaded:Boolean = false;
		
		protected function get _contentLoaded():Boolean
		{
			
			return __contentLoaded;
			
		}
		
		/**
		 * @private
		 */
		protected function set _contentLoaded(value:Boolean):void
		{
			
			if (_contentLoaded != value)
			{
				
				__contentLoaded = value;
				
				dispatchEvent(new Event("contentLoadedChange"));
				
			}
			
		}
		
		[Bindable(event="contentLoadedChange")]
		/**
		 * Becomes true when contents inside StageWebView is completely loaded.
		 */
		public function get contentLoaded():Boolean
		{
			
			return _contentLoaded;
			
		}
		
		//--------------------------------------
		//  staticBitmapMode
		//--------------------------------------
		
		private var _staticBitmapMode:Boolean = false;
		
		[Bindable(event="staticBitmapModeChange")]
		/**
		 * When set to true, temporarily hides the actual StageWebView (but does not remove it)
		 * and replace the visible area with bitmap copy of the contents in StageWebView.
		 */
		public function get staticBitmapMode():Boolean
		{
			
			return _staticBitmapMode;
			
		}
		
		/**
		 * @private
		 */
		public function set staticBitmapMode(value:Boolean):void
		{
			
			if (_staticBitmapMode !== value)
			{
				
				_staticBitmapMode = value;
				
				invalidateDisplayList();
				
				dispatchEvent(new Event("staticBitmapModeChange"));
				
			}
			
		}
		
		//--------------------------------------
		//  history forward enabled
		//--------------------------------------
		
		[Bindable(event="complete")]
		[Bindable(event="error")]
		[Bindable(event="locationChange")]
		[Bindable(event="locationChanging")]
		/**
		 * Returns whether or not the history forward is enabled.
		 */
		public function get historyForwardEnabled():Boolean
		{
			
			return stageWebView.isHistoryForwardEnabled;
			
		}
		
		//--------------------------------------
		//  history back enabled
		//--------------------------------------
		
		[Bindable(event="complete")]
		[Bindable(event="error")]
		[Bindable(event="locationChange")]
		[Bindable(event="locationChanging")]
		/**
		 * Returns whether or not the history back is enabled.
		 */
		public function get historyBackEnabled():Boolean
		{
			
			return stageWebView.isHistoryBackEnabled;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function loadHTMLContents():void
		{
			
			if ((stageWebView != null) && (source != null))
				stageWebView.loadURL(source);
			
		}
		
		private function removePreviousBitmap():void
		{
			
			if (stageWebViewBitmap && stageWebViewBitmap.parent)
				stageWebViewBitmap.parent.removeChild(stageWebViewBitmap);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function initializeComponent():void
		{
			
			if (stageWebView == null)
			{
				
				stageWebView = new StageWebView();
				stageWebView.addEventListener(Event.COMPLETE, stageWebViewComplete, false, 0, true);
				stageWebView.addEventListener(ErrorEvent.ERROR, stageWebViewError, false, 0, true);
				stageWebView.addEventListener(FocusEvent.FOCUS_IN, stageWebViewFocusIn, false, 0, true);
				stageWebView.addEventListener(FocusEvent.FOCUS_OUT, stageWebViewFocusOut, false, 0, true);
				stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, stageWebViewLocationChange, false, 0, true);
				stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, stageWebViewLocationChanging, false, 0, true);
				
				loadHTMLContents();
				
			}
			
		}
		
		override protected function destroyComponent():void
		{
			
			if (stageWebView != null)
			{
				
				// Remove StageWebView from view
				
				stageWebView.removeEventListener(Event.COMPLETE, stageWebViewComplete, false);
				stageWebView.removeEventListener(ErrorEvent.ERROR, stageWebViewError, false);
				stageWebView.removeEventListener(FocusEvent.FOCUS_IN, stageWebViewFocusIn, false);
				stageWebView.removeEventListener(FocusEvent.FOCUS_OUT, stageWebViewFocusOut, false);
				stageWebView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, stageWebViewLocationChange, false);
				stageWebView.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, stageWebViewLocationChanging, false);
				
				stageWebView.dispose();
				stageWebView = null;
				
			}
			
		}
		
		override protected function resizeAndFitComponent(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			if (stageWebView != null)
			{
				
				if (this.stage && visible && enabled && !staticBitmapMode)
					stageWebView.stage = this.stage;
				else
					stageWebView.stage = null;
				
				// TODO: resize only when necessary?
				stageWebView.viewPort = getViewRect();
				
				if (staticBitmapMode)
					refreshWebViewBitmapImage();
				
			}
			
			if (!staticBitmapMode)
				removePreviousBitmap();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function refreshWebViewBitmapImage():void
		{
			
			if (stageWebView && staticBitmapMode)
			{
				
				// First, remove previous instance
				removePreviousBitmap();
				
				// Make a copy of stage view bitmap and put it on top
				stageWebViewBitmap = new Bitmap(getStageWebViewBitmapData());
				addChild(stageWebViewBitmap);
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns reference to StageWebView for this StageWebViewUIComponent.
		 * @return 
		 * 
		 */
		public function getStageWebView():StageWebView
		{
			
			return stageWebView;
			
		}
		
		/**
		 * Returns copy of current StageWebView.viewPort.
		 * @return 
		 * 
		 */
		public function getStageWebViewRect():Rectangle
		{
			
			if (stageWebView)
				return new Rectangle(stageWebView.viewPort.x, stageWebView.viewPort.y, stageWebView.viewPort.width, stageWebView.viewPort.height);
			else
				return new Rectangle(0, 0, 0, 0);
			
		}
		
		public function getStageWebViewBitmapData():BitmapData
		{
			
			if (stageWebView)
			{
				
				var stageNotSet:Boolean = false;
				if (!stageWebView.stage && stage)
				{
					
					// temporarily display StageWebView so bitmap data can be captured
					stageNotSet = true;
					stageWebView.stage = stage;
					
				}
				
				// draw BitmapData of current web view
				var stageWebViewBmp:BitmapData = new BitmapData(stageWebView.viewPort.width, stageWebView.viewPort.height);
				stageWebView.drawViewPortToBitmapData(stageWebViewBmp);
				
				if (stageNotSet)
					stageWebView.stage = null;
				
				// Figure out the scale
				var topLeft:Point = localToGlobal(new Point(0, 0));
				var bottomRight:Point = localToGlobal(new Point(this.width, this.height));
				var scaleFactor:Number = this.width / (bottomRight.x - topLeft.x);
				var scaledBitmapData:BitmapData = new BitmapData(stageWebView.viewPort.width * scaleFactor, stageWebView.viewPort.height * scaleFactor);
				
				var m:Matrix = new Matrix();
				m.scale(scaleFactor, scaleFactor);
				scaledBitmapData.draw(stageWebViewBmp, m, null, null, null, true);
				
				return scaledBitmapData;
				
			}
			else
			{
				
				return null;
				
			}
			
		}
		
		/**
		 * Takes the user forward to the previous browser page
		 */
		public function forward():void
		{
			
			stageWebView.historyForward();
			
		}
		
		/**
		 * Takes the user back to the previous browser page
		 */
		public function back():void
		{
			
			stageWebView.historyBack();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function stageWebViewLocationChange(event:LocationChangeEvent):void
		{
			
			onLocationChange(event);
			
			dispatchEvent(new StageWebViewUIComponentEvent(StageWebViewUIComponentEvent.LOCATION_CHANGE, false, false, event.location, event));
			
		}
		
		private function stageWebViewLocationChanging(event:LocationChangeEvent):void
		{
			
			onLocationChanging(event);
			
			dispatchEvent(new StageWebViewUIComponentEvent(StageWebViewUIComponentEvent.LOCATION_CHANGING, false, false, event.location, event));
			
		}
		
		private function stageWebViewComplete(event:Event):void
		{
			
			_contentLoaded = true;
			
			onComplete(event);
			
			dispatchEvent(event);
			
		}
		
		private function stageWebViewError(event:ErrorEvent):void
		{
			
			if (onError(event))
				dispatchEvent(event);
			
		}
		
		private function stageWebViewFocusIn(event:FocusEvent):void
		{
			
			onFocusIn(event);
			
			dispatchEvent(event);
			
		}
		
		private function stageWebViewFocusOut(event:FocusEvent):void
		{
			
			onFocusOut(event);
			
			dispatchEvent(event);
			
		}
		
		/**
		 * Event handler executed at locationChange event.
		 * @param event
		 * 
		 */
		protected function onLocationChange(event:LocationChangeEvent):void {}
		
		/**
		 * Event handler executed at locationChanging event.
		 * @param event
		 * 
		 */
		protected function onLocationChanging(event:LocationChangeEvent):void {}
		
		/**
		 * Event handler executed at complete event.
		 * @param event
		 * 
		 */
		protected function onComplete(event:Event):void {}
		
		/**
		 * Event handler executed at error event.
		 * @param event
		 * 
		 * @return true if error event should be dispatched, ignore if false
		 */
		protected function onError(event:ErrorEvent):Boolean { return true; }
		
		/**
		 * Event handler executed at focusIn event.
		 * @param event
		 * 
		 */
		protected function onFocusIn(event:FocusEvent):void {}
		
		/**
		 * Event handler executed at focusOut event.
		 * @param event
		 * 
		 */
		protected function onFocusOut(event:FocusEvent):void {}
		
	}
	
}
