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
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	public class ProcessingSpinnerImageFlex extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private static const SPIN_SHIFT_ANGLE:Number = 30;
		private static const SPIN_REV_TIME:Number = 500;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function ProcessingSpinnerImageFlex()
		{
			
			super();
			
			this.addEventListener(ResizeEvent.RESIZE, onResize);
			
			//_spinLoader = new ProcessingGraySpinner(numWings, radius);
			_spinLoader = new ProcessingSpinner_Image(spinnerWing, numWings, radius);
			
			addLoadSpinner();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _spinLoader:ProcessingSpinner_Image;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  spinnerWing
		//----------------------------------
		
		private var _spinnerWing:Class;
		
		public function get spinnerWing():Class
		{
			
			if (_spinLoader != null)
				return _spinLoader.spinnerWing;
			else if (_spinnerWing != null)
				return _spinnerWing;
			else
				return GrayLine;
			
		}
		
		public function set spinnerWing(wing:Class):void
		{
			
			_spinnerWing = wing;
			
			if (_spinLoader != null)
				_spinLoader.spinnerWing = wing;
			
		}
		
		//----------------------------------
		//  numWings
		//----------------------------------
		
		private var _numWings:uint = 12;
		
		[Bindable(event="numWingsChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.ProcessingSpinner_Image#numWings
		 */
		public function get numWings():uint
		{
			
			if (_spinLoader == null)
				return _numWings;
			else
				return _spinLoader.numWings;
			
		}
		
		/**
		 * @private
		 */
		public function set numWings(value:uint):void
		{
			
			if (value < 2)
				value = 2;
			
			_numWings = value;
			
			if (_spinLoader != null)
				_spinLoader.numWings = value;
			
			dispatchEvent(new Event("numWingsChange"));
			
		}
		
		//----------------------------------
		//  radius
		//----------------------------------
		
		private var _radius:Number = 10;
		
		[Bindable(event="radiusChange")]
		/**
		 * @copy com.altoinu.flash.customcomponents.ProcessingSpinner_Image#radius
		 */
		public function get radius():Number
		{
			
			if (_spinLoader == null)
				return _radius;
			else
				return _spinLoader.radius;
			
		}
		
		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			
			_radius = value;
			
			if (_spinLoader != null)
				_spinLoader.radius = value;
			
			width = radius * 2;
			height = radius * 2;
			
			dispatchEvent(new Event("radiusChange"));
			
		}
		
		//--------------------------------------
		//  spinning
		//--------------------------------------
		
		private var _spinning:Boolean = false;
		
		[Bindable(event="spinningChange")]
		/**
		 * True when spin animation is in progress. 
		 */		
		public function get spinning():Boolean
		{
			
			return _spinning;
			
		}
		
		/**
		 * @private
		 */
		public function set spinning(value:Boolean):void
		{
			
			_spinning = value;
			
			if (_spinning)
				_spinLoader.startSpin(SPIN_SHIFT_ANGLE, SPIN_REV_TIME);
			else
				_spinLoader.stopSpin();
			
			dispatchEvent(new Event("spinningChange"));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function positionSpinner():void
		{
			
			if (_spinLoader != null)
			{
				
				_spinLoader.x = width / 2;
				_spinLoader.y = height / 2;
				
			}
			
		}
		
		private function addLoadSpinner():void
		{
			
			addChild(_spinLoader);
			
			width = radius * 2;
			height = radius * 2;
			
			if (_spinning)
				_spinLoader.startSpin(SPIN_SHIFT_ANGLE, SPIN_REV_TIME);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onResize(event:ResizeEvent):void
		{
			
			// on resize, relocate spinner position
			positionSpinner();
			
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
