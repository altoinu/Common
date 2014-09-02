/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.mobile.events
{
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IFlexDisplayObject;
	
	/**
	 * The ViewDataTrackingNavigatorEvent class represents events associated with ViewDataTrackingNavigator.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ViewDataTrackingNavigatorEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/**
		 * The ViewDataTrackingNavigatorEvent.VIEW_ACTIVATED constant defines the value of the type property of an
		 * <code>viewActivated</code> event object.
		 * 
		 * @eventType trackedViewPush
		 */
		public static const VIEW_ACTIVATED:String = "viewActivated";
		
		/**
		 * The ViewDataTrackingNavigatorEvent.TRACKED_VIEW_PUSH constant defines the value of the type property of an
		 * <code>trackedViewPush</code> event object.
		 * 
		 * @eventType trackedViewPush
		 */
		public static const TRACKED_VIEW_PUSH:String = "trackedViewPush";
		
		/**
		 * The ViewDataTrackingNavigatorEvent.TRACKED_VIEW_POP constant defines the value of the type property of an
		 * <code>trackedViewPop</code> event object.
		 * 
		 * @eventType trackedViewPop
		 */
		public static const TRACKED_VIEW_POP:String = "trackedViewPop";
		
		/**
		 * The ViewDataTrackingNavigatorEvent.NO_MORE_PREVIOUS_PAGES constant defines the value of the type property of an
		 * <code>noMorePpreviousPages</code> event object.
		 * 
		 * @eventType noMorePpreviousPages
		 */
		public static const NO_MORE_PREVIOUS_PAGES:String = "noMorePpreviousPages";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * @param viewClassOrViewObject
		 * @param data
		 * 
		 */
		public function ViewDataTrackingNavigatorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
													   viewClassOrViewObject:Object = null, data:Object = null)
		{
			
			super(type, bubbles, cancelable);
			
			if (viewClassOrViewObject is IFlexDisplayObject)
				_viewObject = viewClassOrViewObject as IFlexDisplayObject;
			else if (viewClassOrViewObject is Class)
				_viewClass = viewClassOrViewObject as Class;
			
			_viewClassOrViewObject = viewClassOrViewObject;
			
			this.data = data;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Data to pass when pusing the view. This will get writted to the
		 * data property of the pushed view instance. 
		 */		
		public var data:Object;
		
		//--------------------------------------
		//  viewClassOrViewObject
		//--------------------------------------
		
		private var _viewClassOrViewObject:Object;
		
		public function get viewClassOrViewObject():Object
		{
			
			return _viewClassOrViewObject;
			
		}
		
		//--------------------------------------
		//  viewClass
		//--------------------------------------
		
		private var _viewClass:Class;
		
		public function get viewClass():Class
		{
			
			return _viewClass;
			
		}
		
		//--------------------------------------
		//  viewObject
		//--------------------------------------
		
		private var _viewObject:IFlexDisplayObject;
		
		public function get viewObject():IFlexDisplayObject
		{
			
			return _viewObject;
			
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
			
			return new ViewDataTrackingNavigatorEvent(type, bubbles, cancelable, viewClassOrViewObject, data);
			
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