/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when watchTarget has been added to the display list.
	 *  @eventType flash.events.Event.ADDED
	 */
	[Event(name="added", type="flash.events.Event")]
	/**
	 *  Dispatched when watchTarget has been added to stage.
	 *  @eventType flash.events.Event.ADDED_TO_STAGE
	 */
	[Event(name="addedToStage", type="flash.events.Event")]
	
	/**
	 *  Dispatched when watchTarget has completely loaded and added to stage.  After this event is dispatched,
	 * all properties of <code>watchTarget</code> should be available.
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Utility class to simply watch specified DisplayObject, whether it is an instance or a document class,
	 * to be added to the stage and loaded completely.  LoadToStageWatcher is useful if you want to know when
	 * <code>loaderInfo</code> becomes available.  In the constructor of any DisplayObject class, <code>loaderInfo</code>
	 * property is available right away for a document class DisplayObject, but it is null if DisplayObject is an
	 * instance until it is added to the stage so you cannot do operations like
	 * DisplayObject.loaderInfo.addEventListner(Event.COMPLETE....  Even at that point some of loaderInfo property
	 * (ex. .loader) are still not available until completely loaded.  If you do not know if a DisplayObject is an
	 * instance just waiting to be added to stage or a document class of an .fla then LoadToStageWatcher can do the
	 * heavy lifting of figuring out when the target DisplayObject becomes completely available however it is created.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class LoadToStageWatcher extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 * @param watchTarget
		 * 
		 */
		public function LoadToStageWatcher(watchTarget:DisplayObject)
		{
			
			super();
			
			_watchTarget = watchTarget
			
			// Wait before doing anything until watchTarget is completely loaded and added to stage
			// Once it has been loaded, then dispatch event to notify
			_watchTarget.addEventListener(Event.ADDED, onLoaderAddToDisplayList);
			_watchTarget.addEventListener(Event.ADDED_TO_STAGE, onLoaderAddToStage);
			
			if (_watchTarget.loaderInfo != null)
			{
				
				// loaderInfo property exists which means that it is probably the the document class.
				// Let's wait until everything is loaded.
				trace("LoaderInfo available, probably document class.  Wait for load: "+_watchTarget);
				_watchTarget.loaderInfo.addEventListener(Event.COMPLETE, onLoaderLoadComplete);
				
			}
			else
			{
				
				// loaderInfo property does not exist which means that it is not the document class
				// and is not added to stage yet.  You cannot do .loaderInfo.addEventListener(Event.COMPLETE,...
				// so let's make it wait until it is added.
				trace("LoaderInfo not available, probably an instance.  Wait for add to stage: "+_watchTarget);
				_waitForLoaderInfoInit = true;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _addComplete:Boolean = false;
		private var _addToStageComplete:Boolean = false;
		private var _loadComplete:Boolean = false;
		private var _waitForLoaderInfoInit:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  watchTarget
		//----------------------------------
		
		private var _watchTarget:DisplayObject;
		
		/**
		 * Target DisplayObject being watched by LoadToStageWatcher to be loaded completely
		 * and added to stage.
		 */
		public function get watchTarget():DisplayObject
		{
			
			return _watchTarget;
			
		}
		
		//----------------------------------
		//  watchTargetLoaded
		//----------------------------------
		
		private var _watchTargetLoaded:Boolean = false;
		
		[Bindable(event="complete")]
		/**
		 * Becomes true once <code>watchTarget</code> has been loaded and added to stage.
		 */
		public function get watchTargetLoaded():Boolean
		{
			
			return _watchTargetLoaded;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Method executed after specified <code>watchTarget</code> has finished loading and added to stage.
		 * 
		 */
		private function onLoadDone():void
		{
			
			_watchTargetLoaded = true;
			
			// Dispatch Event to notify that watchTarget has finished loading
			// and added to stage
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		private function checkForLoaderInfoInit():void
		{
			
			// This class was waiting to be added
			try
			{
				
				var loaderItem:* = _watchTarget.loaderInfo.loader; // If this line bombs, then loaderInfo has not been loaded completely yet
				
				// If it has loaded, then this class has loaded completely
				// probably because it was placed on the stage as an instance of a symbol
				// in Flash IDE.  So proceed to load complete
				onLoaderLoadComplete();
				
			}
			catch (e:Error)
			{
				
				// but loaderInfo has not finished loading yet.
				// So let's wait until LoaderInfo has everything
				_watchTarget.loaderInfo.addEventListener(Event.INIT, onLoaderLoadComplete);
				
			}
			
		}
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Records complete when added to display list.
		 */
		private function onLoaderAddToDisplayList(event:Event):void
		{
			
			DisplayObject(event.currentTarget).removeEventListener(Event.ADDED, onLoaderAddToDisplayList);
			
			trace("Add to displaylist: "+_watchTarget);
			_addComplete = true;
			
			dispatchEvent(event);
			
			// If load has finished completely, start initialization
			if (_addComplete && _addToStageComplete && _loadComplete)
			{
				
				// If load has finished completely, start initialization
				onLoadDone();
				
			}
			
		}
		
		/**
		 * @private
		 * Records complete when added to stage.
		 */
		private function onLoaderAddToStage(event:Event):void
		{
			
			DisplayObject(event.currentTarget).removeEventListener(Event.ADDED_TO_STAGE, onLoaderAddToStage);
			
			trace("Add to stage: "+_watchTarget);
			_addToStageComplete = true;
			
			dispatchEvent(event);
			
			if (_addComplete && _addToStageComplete && _loadComplete)
			{
				
				// If load has finished completely, start initialization
				onLoadDone();
				
			}
			else if (_waitForLoaderInfoInit && (_watchTarget.loaderInfo != null))
			{
				
				checkForLoaderInfoInit();
				
			}
			
		}
		
		/**
		 * @private
		 * Records complete when load completes.
		 */
		private function onLoaderLoadComplete(event:Event = null):void
		{
			
			trace("Load complete: "+_watchTarget);
			if (event != null)
			{
				
				LoaderInfo(event.currentTarget).removeEventListener(Event.INIT, onLoaderLoadComplete);
				LoaderInfo(event.currentTarget).removeEventListener(Event.COMPLETE, onLoaderLoadComplete);
				
			}
			
			_loadComplete = true;
			
			// If load has finished completely, start initialization
			if (_addComplete && _addToStageComplete && _loadComplete)
				onLoadDone();
			
		}
		
	}
	
}