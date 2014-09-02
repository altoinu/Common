/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls
{
	
	import com.altoinu.flash.customcomponents.ProcessingSpinner_Image;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	/**
	 * Image component that displays spinner animation while file is being loaded.
	 *  
	 * @author Kaoru Kawashima
	 * 
	 */	
	public class Image_WithLoadSpinner extends Image
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
		public function Image_WithLoadSpinner()
		{
			
			super();
			
			// Watch events
			this.addEventListener(Event.INIT, imageLoadInit);
			this.addEventListener(ProgressEvent.PROGRESS, imageLoadProgress);
			this.addEventListener(IOErrorEvent.IO_ERROR, imageLoadIOError);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, imageLoadSecurityError);
			this.addEventListener(Event.COMPLETE, imageLoadComplete);
			
			this.addEventListener(ResizeEvent.RESIZE, onImageResize);
			
			// Spinner holder
			spinnerHolder.setStyle("horizontalCenter", 0);
			spinnerHolder.setStyle("verticalCenter", 0);
			spinnerContainer.addChild(spinnerHolder);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var spinner:ProcessingSpinner_Image;
		private var spinnerHolder:UIComponent = new UIComponent();
		private var spinnerContainer:Canvas = new Canvas();
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  source
		//----------------------------------
		
		[Bindable("sourceChanged")]
		[Inspectable(category="General", defaultValue="", format="File")]
		/**
		 * @private
		 */		
		override public function set source(value:Object):void
		{
			
			if ((value != null) && (value != "") && !(value is Class) && !(value is Bitmap) && (super.source != value))
				addLoadSpinner(); // Since different source is specified, start loading animation
			else
				removeLoadSpinner(); // Otherwise, remove loading animation
			
			super.source = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  spinWing
		//----------------------------------
		
		private var _spinWing:Class;
		
		[Bindable(event="spinWingChange")]
		/**
		 * DisplayObject class to be used as a wing around spinner that will do the spinning animation.
		 * If null, then a 5 pixel gray line is used.
		 */
		public function get spinWing():Class
		{
			
			if (_spinWing != null)
				return _spinWing;
			else
				return GrayLine;
			
		}
		
		/**
		 * @private
		 */
		public function set spinWing(newSpinWing:Class):void
		{
			
			var updated:Boolean = false;
			
			if (_spinWing != newSpinWing)
				updated = true;
			
			_spinWing = newSpinWing;
			
			if (updated && (spinner != null))
				addLoadSpinner(true);
			
			dispatchEvent(new Event("spinWingChange"));
			
		}
		
		//----------------------------------
		//  numWings
		//----------------------------------
		
		private var _numWings:uint = 12;
		
		[Bindable(event="numWingsChange")]
		/**
		 * Number of wings in the spinner. 
		 */		
		public function get numWings():uint
		{
			
			return _numWings;
			
		}
		
		/**
		 * @private
		 */
		public function set numWings(value:uint):void
		{
			
			var updated:Boolean = false;
			
			if (_numWings != value)
				updated = true;
			
			_numWings = value;
			
			if (updated && (spinner != null))
				addLoadSpinner(true);
			
			dispatchEvent(new Event("numWingsChange"));
			
		}
		
		//----------------------------------
		//  spinnerRadius
		//----------------------------------
		
		private var _spinnerRadius:Number = 10;
		
		[Bindable(event="spinnerRadiusChange")]
		/**
		 * Radius of the spinner. 
		 */		
		public function get spinnerRadius():Number
		{
			
			return _spinnerRadius;
			
		}
		
		/**
		 * @private
		 */
		public function set spinnerRadius(value:Number):void
		{
			
			var updated:Boolean = false;
			
			if (_spinnerRadius != value)
				updated = true;
			
			_spinnerRadius = value;
			
			if (updated && (spinner != null))
				addLoadSpinner(true);
			
			dispatchEvent(new Event("spinnerRadiusChange"));
			
		}
		
		//----------------------------------
		//  smoothing
		//----------------------------------
		
		private var _smoothing:Boolean = false;
		
		[Bindable(event="smoothingChanged")]
		[Inspectable(category="Other", defaultValue="false")]
		/**
		 * Bitmap smoothing turned on when set to true.
		 */
		public function get smoothing():Boolean
		{
			
			return _smoothing;
			
		}
		
		/**
		 * @private
		 */
		public function set smoothing(value:Boolean):void
		{
			
			_smoothing = value;
			
			validateNow();
			
			dispatchEvent(new Event("smoothingChanged"));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			try
			{
				
				// Bitmap smoothing
				if ((content != null) && (content is Bitmap) && content.hasOwnProperty("smoothing"))
					Bitmap(content).smoothing = _smoothing;
				
			}
			catch (secError:SecurityError)
			{
				
				
			}
			
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function createSpinner():ProcessingSpinner_Image
		{
			
			if (spinner != null)
				destroySpinner(); // Make sure existing spinner is removed
			
			spinner = new ProcessingSpinner_Image(spinWing, numWings, spinnerRadius);
			spinner.rotation = -90;
			spinner.scaleX = -1;
			spinnerHolder.addChild(spinner); // add to spinner holder
			
			return spinner;
			
		}
		
		private function destroySpinner():ProcessingSpinner_Image
		{
			
			var targetSpinner:ProcessingSpinner_Image = spinner;
			
			if (spinner != null)
			{
				
				// stop
				spinner.stopSpin();
				
				// Remove from view
				if (spinner.parent != null)
					spinner.parent.removeChild(targetSpinner);
				
				// Clear reference to it
				spinner = null;
				
			}
			
			return targetSpinner;
			
		}
		
		/**
		 * Adds loading spin animation. 
		 * 
		 */		
		private function addLoadSpinner(refreshSpinner:Boolean = false):void
		{
			
			if (refreshSpinner || (spinner == null))
			{
				
				if (spinnerContainer.parent != null)
					spinnerContainer.parent.removeChild(spinnerContainer);
				
				// create new spinner
				createSpinner();
				
				
			}
			
			if (spinner != null)
			{
				
				// Display spinner container on top most layer
				addChild(spinnerContainer);
				
				// Start spinning
				if (!spinner.spinning)
					spinner.startSpin(-30, 500);
				
			}
			
		}
		
		/**
		 * Removes loading spin animation. 
		 * 
		 */		
		private function removeLoadSpinner():void
		{
			
			destroySpinner();
			
			if (spinnerContainer.parent != null)
				spinnerContainer.parent.removeChild(spinnerContainer);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onImageResize(event:ResizeEvent):void
		{
			
			spinnerContainer.width = width;
			spinnerContainer.height = height;
			
		}
		
		private function imageLoadInit(event:Event):void
		{
			
			addLoadSpinner();
			
		}
		
		/**
		 * ProgressEvent handler that is executed while a file is being loaded.  This function controls whether
		 * spin animation displays or not.
		 *  
		 * @param event
		 * 
		 */		
		private function imageLoadProgress(event:ProgressEvent):void
		{
			
			if (event.bytesLoaded < event.bytesTotal)
				addLoadSpinner();  // Still more to load, display spin animation
			else
				removeLoadSpinner(); // Fully loaded, hide spin animation
			
		}
		
		/**
		 * Event handler executed on IOErrorEvent, usually when image loading failed.
		 * 
		 * @param event
		 * 
		 */		
		private function imageLoadIOError(event:IOErrorEvent):void
		{
			
			// There will be no more loading, so remove spinner
			removeLoadSpinner();
			
		}
		
		/**
		 * Event handler executed on SecurityErrorEvent.
		 *  
		 * @param event
		 * 
		 */		
		private function imageLoadSecurityError(event:SecurityErrorEvent):void
		{
			
			// There will be no more loading, so remove spinner
			removeLoadSpinner();
			
		}
		
		/**
		 * Event handler executed after loading has finished. 
		 * @param event
		 * 
		 */		
		private function imageLoadComplete(event:Event):void
		{
			
			// Remove spin animation
			removeLoadSpinner();
			
		}
		
	}
	
}

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;

class GrayLine extends Sprite
{
	
	public function GrayLine()
	{
		
		super();
		
		var g:Graphics = this.graphics;
		g.moveTo(-2.5, 0);
		g.lineStyle(2, 0x999999, 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
		g.lineTo(2.5, 0);
		
	}
	
}
