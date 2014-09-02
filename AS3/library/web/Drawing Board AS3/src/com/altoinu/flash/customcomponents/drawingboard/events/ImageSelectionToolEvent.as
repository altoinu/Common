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
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The ImageSelectionToolEvent class represents events associated with Image_SelectionTool.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ImageSelectionToolEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The ImageSelectionToolEvent.SELECT constant defines the value of the type property of an
		 * <code>select</code> event object.
		 */
		public static const SELECT:String = "select";
		
		/**
		 * The ImageSelectionToolEvent.SELECT constant defines the value of the type property of an
		 * <code>select</code> event object.
		 */
		public static const DESELECT:String = "deselect";
		
		/**
		 * The ImageSelectionToolEvent.TARGET_MOVE constant defines the value of the type property of an
		 * <code>targetMove</code> event object.
		 */
		public static const TARGET_MOVE:String = "targetMove";
		
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
		 * @param selectedImage Image selected at "select" event.
		 * @param deselectedImage Previous image selected at "select" event, now deselected.
		 * 
		 */
		public function ImageSelectionToolEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
												selectedImage:DisplayObject = null, deselectedImage:DisplayObject = null)
		{
			
			super(type, bubbles, cancelable);
			
			_selectedImage = selectedImage;
			_deselectedImage = deselectedImage;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  selectedImage
		//--------------------------------------
		
		private var _selectedImage:DisplayObject;
		
		/**
		 * Image selected.
		 */
		public function get selectedImage():DisplayObject
		{
			
			return _selectedImage;
			
		}
		
		//--------------------------------------
		//  deselectedImage
		//--------------------------------------
		
		private var _deselectedImage:DisplayObject;
		
		/**
		 * Previous image selected, now deselected.
		 */
		public function get deselectedImage():DisplayObject
		{
			
			return _deselectedImage;
			
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
			
			return new ImageSelectionToolEvent(type, bubbles, cancelable, selectedImage, deselectedImage);
			
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