/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls
{
	
	import com.altoinu.flash.global.TraceControl;
	import com.altoinu.flex.customcomponents.events.BannerSWFLoaderEvent;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * Dispatched by .swf loaded to indicate when banner animation has ended.
	 * 
	 * @eventType com.altoinu.flex.customcomponents.events.BannerSWFLoaderEvent.BANNERANIMATIONCOMPLETE
	 */
	[Event(name="bannerAnimationComplete", type="com.altoinu.flex.customcomponents.events.BannerSWFLoaderEvent")]
	
	/**
	 * Dispatched when any of the event specified by <code>bannerEvents</code> is dispatched from .swf loaded.
	 * 
	 * @eventType com.altoinu.flex.customcomponents.events.BannerSWFLoaderEvent.BANNEREVENTDISPATCH
	 */
	[Event(name="bannerEventDispatch", type="com.altoinu.flex.customcomponents.events.BannerSWFLoaderEvent")]
	
	/**
	 * Special SWFLoader that assists communication between loaded SWF and Flex application.
	 * 
	 * <p>The .swf file can be either an infinitely looping animation, or an animation that can be controlled
	 * by the banner loader.</p>
	 * 
	 * <p>If the banner is going to be controlled it needs to have following functionalities:
	 * <ul>
	 * 	<li><code>public function startAnimation():void</code> REQUIRED</li>
	 * 	<li><code>public function stopAnimation():void</code> optional</li>
	 * 	<li><code>public function resetAnimation():void </code> REQUIRED</li>
	 * 	<li><code>public function loginStateChange(loggedIn:Boolean):void</code> optional</li>
	 * 	<li><code>public function themeChange(newTheme:String):void</code> optional</li>
	 * 	<li><code>dispatchEvent(new Event("animationEnded"));</code> when animation ends, so BannerSWFLoader can tell when it has ended.</li>
	 * </ul></p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class BannerSWFLoader extends Image_WithLoadSpinner
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  Functions in the banner that are
		//  called from BannerSWFLoader
		//--------------------------------------
		
		private static const START_ANIMATION:String = "startAnimation";
		private static const STOP_ANIMATION:String = "stopAnimation";
		private static const RESET_ANIMATION:String = "resetAnimation";
		private static const LOGIN_STATE_CHANGE:String = "loginStateChange";
		private static const THEME_CHANGE:String = "themeChange";
		
		private static const ANIMATION_ENDED_EVENTTYPE:String = "animationEnded";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function BannerSWFLoader()
		{
			
			super();
			
			addEventListener(Event.OPEN, onBannerLoadStart);
			addEventListener(Event.COMPLETE, onBannerLoadComplete);
			addEventListener(FlexEvent.INITIALIZE, onInitialize);
			
			// Disabled TraceControl by default
			DEBUGTRACER.enabled = false;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Tracer.
		 */
		private const DEBUGTRACER:TraceControl = new TraceControl();
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _addedBannerEventType:Array;
		
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
			
			if ((super.source != value) && (content != null))
			{
				
				// New banner will be loaded, so make sure event listeners are removed
				content.removeEventListener(ANIMATION_ENDED_EVENTTYPE, onBannerAnimationEnd);
				removeBannerEvents();
				
			}
			
			// Load new banner
			super.source = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  bannerEvents
		//----------------------------------
		
		private var _bannerEvents:XMLList;
		
		[Bindable(event="bannerEventsUpdate")]
		/**
		 * XMLList defining events that BannerSWFLoader will listen for from the SWF it loaded.  When an Event specified
		 * in this list is caught from the SWF, BannerSWFLoader dispatches BannerSWFLoaderEvent type "bannerEventDispatch"
		 * so it can be listened by BannerSWFLoader.addEventListner method.
		 * 
		 * <p>Each XML element must be in following format:
		 * <listing>
		 * &lt;event type="event type name" parameter="optional parameter"/&gt;
		 * </listing></p>
		 * 
		 * <p>
		 * <ul>
		 * 	<li>event type name - Event type dispatched from banner SWF.</li>
		 * 	<li>optional parameter - Optional parameter to be passed with BannerSWFLoaderEvent.</li>
		 * </ul>
		 * </p>
		 * 
		 * <p>If there are multiple events with same event type name, then BannerSWFLoader will dispatch event
		 * "bannerEventDispatch" for each instance of it for every event caught from the SWF.  For example, if there
		 * are two "click" events, every time SWF dispatches "click" BannerSWFLoader dispatches two "bannderEventDispatch"
		 * events.</p>
		 */
		public function get bannerEvents():XMLList
		{
			
			return _bannerEvents;
			
		}
		
		/**
		 * @private
		 */
		public function set bannerEvents(value:XMLList):void
		{
			
			if (_loadCompleted)
			{
				
				// Banner is already loaded, attach specified events.
				
				// First, remove the previous ones
				removeBannerEvents();
				
				// Add each event
				_addedBannerEventType = [];
				for each (var newEventDef:Object in value)
				{
					
					if (_addedBannerEventType.indexOf(String(newEventDef.@type)) == -1)
					{
						
						// This event type has not been added yet, so let's add it
						content.addEventListener(String(newEventDef.@type), executeBannerEvent);
						
						// and remember it
						_addedBannerEventType.push(String(newEventDef.@type));
						
					}
					
				}
				
			}
			
			if (_bannerEvents != value)
			{
				
				_bannerEvents = value;
				
				dispatchEvent(new Event("bannerEventsUpdate"));
				
			}
			
		}
		
		//----------------------------------
		//  showLoggedInState
		//----------------------------------
		
		private var _showLoggedInState:Boolean;
		
		[Bindable(event="showLoggedInStateUpdate")]
		/**
		 * Switches the banner to logged in state or logged out state.  When changed, it will execute <code>
		 * public function loginStateChange(loggedIn:Boolean):void</code> in the loaded .swf.
		 */
		public function get showLoggedInState():Boolean
		{
			
			return _showLoggedInState;
			
		}
		
		/**
		 * @private
		 */
		public function set showLoggedInState(value:Boolean):void
		{
			
			// Call function to switch banner's log in state
			if (content != null)
			{
				
				if (content.hasOwnProperty(LOGIN_STATE_CHANGE) && (content[LOGIN_STATE_CHANGE] is Function))
					content[LOGIN_STATE_CHANGE](value);
				
			}
			
			if (_showLoggedInState != value)
			{
				
				_showLoggedInState = value;
				
				dispatchEvent(new Event("showLoggedInStateUpdate"));
				
			}
			
		}
		
		//----------------------------------
		//  theme
		//----------------------------------
		
		private var _theme:String;
		
		[Bindable(event="themeupdate")]
		/**
		 * Theme of the banner.  When changed, it will execute <code>public function themeChange(newTheme:String):void</code>
		 * in the loaded .swf.
		 */
		public function get theme():String
		{
			
			return _theme;
			
		}
		
		/**
		 * @prvate
		 */
		public function set theme(value:String):void
		{
			
			// Call function to switch banner's theme
			if (content != null)
			{
				
				if (content.hasOwnProperty(THEME_CHANGE) && (content[THEME_CHANGE] is Function))
					content[THEME_CHANGE](value);
				
			}
			
			if (_theme != value)
			{
				
				_theme = value;
				
				dispatchEvent(new Event("themeupdate"));
				
			}
			
		}
		
		//----------------------------------
		//  loadCompleted
		//----------------------------------
		
		private var _loadCompleted:Boolean = false;
		
		[Bindable(event="loadcompleteupdate")]
		/**
		 * True when banner has been loaded completely.
		 */
		public function get loadCompleted():Boolean
		{
			
			return _loadCompleted;
			
		}
		
		//----------------------------------
		//  animationRunning
		//----------------------------------
		
		private var _animationRunning:Boolean = false;
		
		[Bindable(event="animationRunningupdate")]
		/**
		 * Whether the animation of the banner is running (true) or not (false).  Changing this property triggers
		 * functions <code>public function startAnimation():void</code>, <code>public function stopAnimation():void</code>,
		 * and <code>public function resetAnimation():void</code> in the loaded swf.
		 */
		public function get animationRunning():Boolean
		{
			
			return _animationRunning;
			
		}
		
		/**
		 * @private
		 */
		public function set animationRunning(value:Boolean):void
		{
			
			// Make sure animation is stopped
			if (content != null)
			{
				
				if (content.hasOwnProperty(STOP_ANIMATION) && (content[STOP_ANIMATION] is Function))
					content[STOP_ANIMATION]();
				
			}
			
			if ((value) && (stage != null))
			{
				
				DEBUGTRACER.tracetext("Start animation: "+this);
				
				// Start animation
				if ((content != null) && (loadCompleted))
				{
					
					if (!content.hasOwnProperty(START_ANIMATION) ||
						!(content[START_ANIMATION] is Function))
					{
						
						throw new Error("Animation cannot be started for "+source+"... Your banner is missing "+START_ANIMATION+" function.");
						
					}
					else if (!content.hasOwnProperty(RESET_ANIMATION) ||
							 !(content[RESET_ANIMATION] is Function))
					{
						
						throw new Error("Animation cannot be started for "+source+"... Your banner is missing "+RESET_ANIMATION+" function.");
						
					}
					else
					{
						
						// First reset
						content[RESET_ANIMATION]();
						// Then start
						content[START_ANIMATION]();
						
					}
				
				}
				
			}
			else
			{
				
				DEBUGTRACER.tracetext("Stop animation: "+this);
				
			}
			
			if (_animationRunning != value)
			{
				
				_animationRunning = value;
				dispatchEvent(new Event("animationRunningupdate"));
				
			}
			
		}
		
		//----------------------------------
		//  debugTracerEnabled
		//----------------------------------
		
		[Bindable(event="debugtracerenabledupdate")]
		[Inspectable(category="Other", enumeration="true,false", defaultValue="true")]
		/**
		 * Sets whether the traces from BannerSWFLoader is enabled or not.
		 */
		public function get debugTracerEnabled():Boolean
		{
			
			return DEBUGTRACER.enabled;
			
		}
		
		/**
		 * @prvate
		 */
		public function set debugTracerEnabled(value:Boolean):void
		{
			
			if (DEBUGTRACER.enabled != value)
			{
				
				DEBUGTRACER.enabled = value;
				dispatchEvent(new Event("debugtracerenabledupdate"));
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Starts banner animation from the beginning by triggering animationRunning = true.
		 * 
		 */
		public function startAnimation():void
		{
			
			animationRunning = true;
			
		}
		
		/**
		 * Stops banner animation by triggering animationRunning = false.
		 * 
		 */
		public function stopAnimation():void
		{
			
			animationRunning = false;
			
		}
		
		/**
		 * Resets banner animation by calling <code>public function resetAnimation():void</code> in the loaded .swf.
		 * 
		 */
		public function resetAnimation():void
		{
			
			if (content != null)
			{
				
				if (!content.hasOwnProperty(RESET_ANIMATION) || !(content[RESET_ANIMATION] is Function))
					throw new Error("Animation cannot be reset for "+source+"... Your banner is missing resetAnimation function.");
				else
					content[RESET_ANIMATION]();
				
			}
			
		}
		
		/**
		 * @private
		 */
		private function removeBannerEvents():void
		{
			
			if ((_addedBannerEventType != null) && (_addedBannerEventType.length > 0))
			{
				
				var numEvents:int = _addedBannerEventType.length;
				for (var i:int = 0; i < numEvents; i++)
				{
					
					content.removeEventListener(_addedBannerEventType[i], executeBannerEvent);
					
				}
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Listener
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event handler executed at initialization.
		 * @param event
		 * 
		 */
		private function onInitialize(event:FlexEvent):void
		{
			
			DEBUGTRACER.prefix = "====";
			
		}
		
		/**
		 * Event handler executed when banner starts loading.
		 * @param event
		 * 
		 */
		private function onBannerLoadStart(event:Event):void
		{
			
			_loadCompleted = false;
			dispatchEvent(new Event("loadcompleteupdate"));
			
		}
		
		/**
		 * Event handler executed when banner has loaded.
		 * @param event
		 * 
		 */
		private function onBannerLoadComplete(event:Event):void
		{
			
			DEBUGTRACER.tracetext("Banner load complete: "+this);
			
			_loadCompleted = true;
			
			// Execute script in the banner to set it to logged/not logged in state
			showLoggedInState = showLoggedInState;
			
			// Set theme
			theme = theme;
			
			// Update banner events
			bannerEvents = bannerEvents;
			
			// Watch for animation end
			content.removeEventListener(ANIMATION_ENDED_EVENTTYPE, onBannerAnimationEnd);
			content.addEventListener(ANIMATION_ENDED_EVENTTYPE, onBannerAnimationEnd);
			
			// Make sure animation is stopped/started
			animationRunning = animationRunning
			
			// Dispatch events
			dispatchEvent(new Event("loadcompleteupdate")); 
							
		}
		
		/**
		 * Event handler executed after banner SWF loads completely.
		 * @param event
		 * 
		 */
		private function onBannerAnimationEnd(event:Event):void
		{
			
			DEBUGTRACER.tracetext("'"+ANIMATION_ENDED_EVENTTYPE+"' event received from banner... Banner animation has finished");
			
			dispatchEvent(new BannerSWFLoaderEvent(BannerSWFLoaderEvent.BANNERANIMATIONCOMPLETE));
			
		}
		
		/**
		 * Executes the custom event assigned to this banner swf.
		 * @param event
		 * 
		 */
		private function executeBannerEvent(event:Event):void
		{
			
			var eventParameter:String;
			
			for each (var eventDef:Object in _bannerEvents)
			{
				
				if (eventDef.@type == event.type)
				{
					
					DEBUGTRACER.tracetext("'"+event.type+"' event received from banner, execute parameter: "+eventDef.@parameter);
					eventParameter = eventDef.@parameter;
					dispatchEvent(new BannerSWFLoaderEvent(BannerSWFLoaderEvent.BANNEREVENTDISPATCH, false, false, event.type, eventParameter));
					
				}
				
			}
			
		}
		
	}
	
}