/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.drawingboard.events
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The ImageRotateToolEvent class represents events associated with ImageRotateTool.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ImageRotateToolEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The ImageRotateToolEvent.ROTATE constant defines the value of the type property of an
		 * <code>rotate</code> event object.
		 */
		public static const ROTATE:String = "rotate";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param type The event type; indicates the action that caused the event.
		 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
		 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
		 * @param relativeObject DisplayObject involved in this event.
		 * @param angle Angle in degrees relativeObject rotated.
		 * @param rotatePoint Point of rotation, where 0, 0 is top left.
		 * 
		 */
		public function ImageRotateToolEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, relativeObject:DisplayObject = null, angle:Number = NaN, rotatePoint:Point = null)
		{
			
			super(type, bubbles, cancelable);
			
			_relativeObject = relativeObject;
			_angle = angle;
			_rotatePoint = rotatePoint;
			
		}
		
		//--------------------------------------
		//  relativeObject
		//--------------------------------------
		
		private var _relativeObject:DisplayObject;
		
		/**
		 * DisplayObject involved in this event.
		 */
		public function get relativeObject():DisplayObject
		{
			
			return _relativeObject;
			
		}
		
		//--------------------------------------
		//  angle
		//--------------------------------------
		
		private var _angle:Number;
		
		/**
		 * Angle in degrees relativeObject rotated.
		 */
		public function get angle():Number
		{
			
			return _angle;
			
		}
		
		//--------------------------------------
		//  rotatePoint
		//--------------------------------------
		
		private var _rotatePoint:Point;
		
		/**
		 * Point of rotation, where 0, 0 is top left.
		 */
		public function get rotatePoint():Point
		{
			
			return _rotatePoint;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			
			return new ImageRotateToolEvent(type, bubbles, cancelable, relativeObject, angle, rotatePoint);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			var eventClassName:String = getQualifiedClassName(this);
			return "[" + eventClassName.substring(eventClassName.lastIndexOf("::") + 2) + " type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
			
		}
		
	}
	
}