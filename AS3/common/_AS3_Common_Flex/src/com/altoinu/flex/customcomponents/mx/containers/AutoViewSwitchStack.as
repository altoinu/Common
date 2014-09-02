/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.containers
{
	
	import com.altoinu.flex.customcomponents.events.ViewSwitchEvent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.ViewStack;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched at the beginning of each switching cycle, which is either when a component is displayed
	 * or cycle has been started/restarted by changing <code>autoAdvance</code> to true.  AutoViewSwitchStack
	 * will switch the view to the next component after current component is displayed for time specified
	 * by property <code>displayTime</code>.
	 *
	 *  @eventType com.altoinu.flex.customcomponents.events.ViewSwitchEvent.CYCLESTART
	 */
	[Event(name="cyclestart", type="com.altoinu.flex.customcomponents.events.ViewSwitchEvent")]
	
	/**
	 *  Dispatched at the end of a switching cycle before currently displaying component is switched to
	 * the next one.
	 * 
	 *  @eventType com.altoinu.flex.customcomponents.events.ViewSwitchEvent.CYCLEEND
	 */
	[Event(name="cycleend", type="com.altoinu.flex.customcomponents.events.ViewSwitchEvent")]
	
	/**
	 *  Dispatched at the end of the entire sequence of contents before switching to the first element
	 * at selectedIndex == 0.
	 * 
	 *  @eventType com.altoinu.flex.customcomponents.events.ViewSwitchEvent.SEQUENCE_END
	 */
	[Event(name="sequenceEnd", type="com.altoinu.flex.customcomponents.events.ViewSwitchEvent")]
	
	/**
	 * Viewstack to automatically switch displaying contents using timer.
	 * @author Kaoru Kawashima
	 * 
	 */	
	public class AutoViewSwitchStack extends ViewStack
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
		public function AutoViewSwitchStack()
		{
			
			super();
			
			// This will trigger cycle timer
			toggleCycleTimer();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _mainContentSwitcherTimer:Timer;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable]
		/**
		 * Indices specified here will not display for every one if limitedViews is true.
		 */
		public var limitedViewIndices:Array;
		
		[Bindable]
		[Inspectable(category="Other", defaultValue="false")]
		/**
		 * If this is true, then components and indices specified by limitedViewIndices will not display.
		 */
		public var limitViewableItems:Boolean = false;
		
		//----------------------------------
		//  displayTime
		//----------------------------------
		
		private var _displayTime:Number = 1000;
		
		[Bindable(event="cycleTimeUpdated")]
		/**
		 * The time each component will be displayed in milliseconds.  If this value is changed while
		 * <code>autoAdvance</code> is true, then it will restart the cycle so whatever component that is
		 * currently displaying will remain for specified time, then switch.
		 * 
		 * <p>If 0 or negative number is specified, then the cycle will be forced to stop until positive
		 * number is specified.</p>
		 * 
		 * @default 1000
		 */
		public function get displayTime():Number
		{
			
			return _displayTime;
			
		}
		/**
		 * @private
		 */		
		public function set displayTime(value:Number):void
		{
			
			if (_displayTime != value)
			{
				
				_displayTime = value;
				dispatchEvent(new Event("cycleTimeUpdated"));
				
				// This will trigger cycle timer
				toggleCycleTimer();
				
			}
			
		}
		
		//----------------------------------
		//  autoAdvance
		//----------------------------------
		
		private var _autoAdvance:Boolean = true;
		
		[Bindable(event="autoAdvanceUpdated")]
		[Inspectable(category="Other", defaultValue="true")]
		/**
		 * If true, display content switching is currently running.  If false, then the contents are not
		 * switching automatically.
		 * 
		 * <p>Setting this property to true will have no effect if <code>displayTime</code> is 0 or a negative
		 * number until it becomes positive (then it will automatically start the cycle).</p>
		 * 
		 * @default true
		 */		
		public function get autoAdvance():Boolean
		{
			
			return _autoAdvance;
			
		}
		
		/**
		 * @private
		 */		
		public function set autoAdvance(value:Boolean):void
		{
			
			if (_autoAdvance != value)
			{
				
				_autoAdvance = value;
				dispatchEvent(new Event("autoAdvanceUpdated"));
				
				// This will trigger cycle timer
				toggleCycleTimer();
				
			}
			
		}
		
		//----------------------------------
		//  nextContentIndex
		//----------------------------------
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		/**
		 * Index of next content to be displayed.
		 */
		public function get nextContentIndex():int
		{
			
			var nextIndex:int;
			if (selectedIndex < getChildren().length - 1)
				nextIndex = selectedIndex + 1;
			else
				nextIndex = 0;
			
			if ((limitViewableItems) && (limitedViewIndices != null))
			{
				
				if (limitedViewIndices.indexOf(nextIndex) != -1)
				{
					// This index is not allowed for this user.  Pick another
					while (limitedViewIndices.indexOf(nextIndex) != -1)
					{
						
						if (nextIndex < getChildren().length - 1)
							nextIndex++;
						else
							nextIndex = 0;
						
					}
					
				}
				
			}
			
			return nextIndex;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function toggleCycleTimer():void
		{
			
			if ((_autoAdvance) && (_displayTime > 0))
			{
				
				// Start the cycle
				waitThenSwitch(); // Go!
				
			}
			else
			{
				
				// Stop the cycle because either autoAdvance is false or
				// display time specified is negative
				if (_mainContentSwitcherTimer != null)
					_mainContentSwitcherTimer.reset();
				
			}
			
		}
		
		/**
		 * Starts one cycle.
		 * 
		 */
		private function waitThenSwitch():void
		{
			
			// Sets up a new instance of switch timer that handles one switching cycle.
			if (_mainContentSwitcherTimer != null)
			{
				
				// Clear out the previous instance of cycle timer in case it is running
				_mainContentSwitcherTimer.reset();
				_mainContentSwitcherTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, mainContentSwitch);
				
			}
			
			_mainContentSwitcherTimer = new Timer(_displayTime, 1);
			_mainContentSwitcherTimer.addEventListener(TimerEvent.TIMER_COMPLETE, mainContentSwitch);
			
			// and start cycle
			_mainContentSwitcherTimer.start();
			dispatchEvent(new ViewSwitchEvent(ViewSwitchEvent.CYCLESTART));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Timer handler to do the actual switching of the content displayed. 
		 * @param event
		 * 
		 */		
		private function mainContentSwitch(event:TimerEvent):void
		{
			
			// Dispatch event!
			dispatchEvent(new ViewSwitchEvent(ViewSwitchEvent.CYCLEEND));
			
			// Assign new index to the selectedIndex to switch view
			var next:int = nextContentIndex;
			
			if (next == 0)
				dispatchEvent(new ViewSwitchEvent(ViewSwitchEvent.SEQUENCE_END, false, false));
			
			selectedIndex = nextContentIndex;
			
			// Restart timer if still autoAdvancing
			toggleCycleTimer();
			
		}
		
	}
	
}