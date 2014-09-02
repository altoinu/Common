/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.drawingboard.events
{
	
	import com.altoinu.flash.customcomponents.drawingboard.IDrawable;
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingLayer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The DrawingBoardEvent class represents events associated with DrawingBoard.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class DrawingBoardEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The DrawingBoardEvent.IMAGE_UPDATED constant defines the value of the type property of an
		 * <code>imageUpdated</code> event object.
		 */
		public static const IMAGE_UPDATED:String = "imageUpdated";
		
		/**
		 * The DrawingBoardEvent.IMAGE_SELECTION_UPDATED constant defines the value of the type property of an
		 * <code>imageSelectionUpdated</code> event object.
		 */
		public static const IMAGE_SELECTION_UPDATED:String = "imageSelectionUpdated";
		
		/**
		 * The DrawingBoardEvent.DRAW constant defines the value of the type property of an
		 * <code>draw</code> event object.
		 */
		public static const DRAW:String = "draw";
		
		/**
		 * The DrawingBoardEvent.ERASE constant defines the value of the type property of an
		 * <code>erase</code> event object.
		 */
		public static const ERASE:String = "erase";
		
		/**
		 * The DrawingBoardEvent.IMAGE_REMOVED constant defines the value of the type property of an
		 * <code>imageRemoved</code> event object.
		 */
		public static const IMAGE_REMOVED:String = "imageRemoved";
		
		/**
		 * The DrawingBoardEvent.MOUSE_GRAB constant defines the value of the type property of an
		 * <code>mouseGrab</code> event object.
		 */
		public static const MOUSE_GRAB:String = "mouseGrab";
		
		/**
		 * The DrawingBoardEvent.MOUSE_DROP constant defines the value of the type property of an
		 * <code>mouseDrop</code> event object.
		 */
		public static const MOUSE_DROP:String = "mouseDrop";
		
		/**
		 * The DrawingBoardEvent.MOUSE_DROP_MISS constant defines the value of the type property of an
		 * <code>mouseDropMiss</code> event object.
		 */
		public static const MOUSE_DROP_MISS:String = "mouseDropMiss";
		
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
		 * @param relativeImage Image drawn at event "draw."
		 * @param erasedItems For "erase" event, Object containing two Arrays, Object.bitmaps which contains
		 * Bitmaps affected by erase operation and Object.nonBitmaps which contains non-Bitmaps removed.
		 * @param drawingTarget IDrawable involved in this event.
		 * @param relativePoint Point where draw or erase happened.
		 * @param eraseShape Shape of the eraser for "erase" event.
		 * @param eraseAreaWidth Width of the eraser for "erase" event.
		 * @param eraseAreaHeight Height of the eraser for "erase" event.
		 * 
		 */
		public function DrawingBoardEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
										  relativeImage:DisplayObject = null, erasedItems:Object = null,
										  drawingTarget:IDrawable = null, relativePoint:Point = null,
										  eraseShape:Class = null, eraseAreaWidth:Number = NaN, eraseAreaHeight:Number = NaN)
		{
			
			super(type, bubbles, cancelable);
			
			_relativeImage = relativeImage;
			_drawingTarget = drawingTarget;
			_relativePoint = relativePoint;
			_erasedItems = erasedItems;
			_eraseShape = eraseShape;
			_eraseAreaWidth = eraseAreaWidth;
			_eraseAreaHeight = eraseAreaHeight;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  relativeImage
		//--------------------------------------
		
		private var _relativeImage:DisplayObject;
		
		/**
		 * Image drawn at event "draw."
		 */
		public function get relativeImage():DisplayObject
		{
			
			return _relativeImage;
			
		}
		
		//--------------------------------------
		//  relativeLayer
		//--------------------------------------
		
		[Deprecated(replacement="com.altoinu.flash.customcomponents.drawingboard.events.DrawingBoardEvent.drawingTarget")]
		public function get relativeLayer():IDrawingLayer
		{
			
			if (drawingTarget is IDrawingLayer)
				return drawingTarget as IDrawingLayer;
			else
				return null;
			
		}
		
		//--------------------------------------
		//  drawingTarget
		//--------------------------------------
		
		private var _drawingTarget:IDrawable;
		
		/**
		 * IDrawable involved in this event.
		 */
		public function get drawingTarget():IDrawable
		{
			
			return _drawingTarget;
			
		}
		
		//--------------------------------------
		//  relativePoint
		//--------------------------------------
		
		private var _relativePoint:Point;
		
		/**
		 * Point where draw or erase happened.
		 */
		public function get relativePoint():Point
		{
			
			return _relativePoint;
			
		}
		
		//--------------------------------------
		//  erasedItems
		//--------------------------------------
		
		private var _erasedItems:Object;
		
		/**
		 * For "erase" event, Object containing two Arrays, Object.bitmaps which contains
		 * Bitmaps affected by erase operation and Object.nonBitmaps which contains non-Bitmaps removed.
		 */
		public function get erasedItems():Object
		{
			
			return _erasedItems;
			
		}
		
		//--------------------------------------
		//  eraseShape
		//--------------------------------------
		
		private var _eraseShape:Class;
		
		/**
		 * Shape of the eraser for "erase" event.
		 */
		public function get eraseShape():Class
		{
			
			return _eraseShape;
			
		}
		
		//--------------------------------------
		//  eraseAreaWidth
		//--------------------------------------
		
		private var _eraseAreaWidth:Number;
		
		/**
		 * Width of the eraser for "erase" event.
		 */
		public function get eraseAreaWidth():Number
		{
			
			return _eraseAreaWidth;
			
		}
		
		//--------------------------------------
		//  eraseAreaHeight
		//--------------------------------------
		
		private var _eraseAreaHeight:Number;
		
		/**
		 * Height of the eraser for "erase" event.
		 */
		public function get eraseAreaHeight():Number
		{
			
			return _eraseAreaHeight;
			
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
			
			return new DrawingBoardEvent(type, bubbles, cancelable,
				relativeImage, erasedItems, drawingTarget, relativePoint, eraseShape, eraseAreaWidth, eraseAreaHeight);
			
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