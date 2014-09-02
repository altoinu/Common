/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.external.javascript.events
{
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * The AnchorToHTMLPageEvent class represents events associated with AnchorToHTMLPage.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AnchorToHTMLPageEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The AnchorToHTMLPageEvent.INITIALIZE_AT_ADD_TO_STAGE constant defines the value of the type property of an
		 * <code>initializeAtAddToStage</code> event object.
		 */
		public static const INITIALIZE_AT_ADD_TO_STAGE:String = "initializeAtAddToStage";
		
		/**
		 * The AnchorToHTMLPageEvent.DE_INITIALIZE_AT_REMOVE_FROM_STAGE constant defines the value of the type property of an
		 * <code>deInitializeAtRemoveFromStage</code> event object.
		 */
		public static const DE_INITIALIZE_AT_REMOVE_FROM_STAGE:String = "deInitializeAtRemoveFromStage";
		
		/**
		 * The AnchorToHTMLPageEvent.UPDATE_POSITION constant defines the value of the type property of an
		 * <code>updatePosition</code> event object.
		 */
		public static const UPDATE_POSITION:String = "updatePosition";
		
		/**
		 * The AnchorToHTMLPageEvent.REMOVE_COMPONENT constant defines the value of the type property of an
		 * <code>removeComponent</code> event object.
		 */
		public static const REMOVE_COMPONENT:String = "removeComponent";
		
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
		 * 
		 */
		public function AnchorToHTMLPageEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
											  jsMethod:String = "", elementID:String = "",
											  contentRect:Rectangle = null)
		{
			
			super(type, bubbles, cancelable);
			
			_jsMethod = jsMethod;
			_elementID = elementID;
			_contentRect = contentRect;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  jsMethod
		//----------------------------------
		
		private var _jsMethod:String;
		
		public function get jsMethod():String
		{
			
			return _jsMethod;
			
		}
		
		//----------------------------------
		//  elementID
		//----------------------------------
		
		private var _elementID:String;
		
		public function get elementID():String
		{
			
			return _elementID;
			
		}
		
		//----------------------------------
		//  contentRect
		//----------------------------------
		
		private var _contentRect:Rectangle;
		
		public function get contentRect():Rectangle
		{
			
			return _contentRect;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[AnchorToHTMLPageEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
			
		}
		
	}
	
}