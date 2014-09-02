/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	import com.altoinu.flash.events.TimerCountDownEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  On time update 
	 *
	 *  @eventType com.altoinu.flash.events.TimerCountDownEvent.TICK
	 */
	[Event(name="tick", type="com.altoinu.flash.events.TimerCountDownEvent")]
	
	/**
	 *  Dispatched when the TimerCountDown has finished counting down. Timer will stop automatically. 
	 *
	 *  @eventType com.altoinu.flash.events.TimerCountDownEvent.COMPLETE
	 */
	[Event(name="complete", type="com.altoinu.flash.events.TimerCountDownEvent")]
	
	/**
	 * Counts time down from a starting point and has properties to fetch seconds, minutes, hours, and days. 
	 * 
	 */	
	public class TimerCountDown extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * On time update 
		 */		
		public static const TICK:String = TimerCountDownEvent.TICK;
		
		/**
		 * Dispatched when the TimerCountDown has finished counting down. Timer will stop automatically. 
		 */		
		public static const COMPLETE:String = TimerCountDownEvent.COMPLETE;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param tickInterval Time in milliseconds between "tick" event.
		 * @param countDownSeconds Time you want to count to in seconds. If less than 0, then it defaults to
		 * 60.
		 * 
		 */
		public function TimerCountDown(tickInterval:Number = 50, countDownSeconds:Number = 60)
		{
			
			trace("TimerCountDown v1.02");
			
			this.tickInterval = tickInterval;
			
			if (isNaN(countDownSeconds) || (countDownSeconds <= 0))
				countDownSeconds = 60;
			
			_countDownSeconds = countDownSeconds;
			calculateTimeLeft(_countDownSeconds * 1000);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var countTimer:Timer;
		
		private var _countDownSeconds:Number = 60;
		
		private var started:Boolean = false;
		private var endDate:Number;
		private var pausedStarted:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  tickInterval
		//----------------------------------
		
		private var _tickInterval:Number = 50;
		
		/**
		 * Time in milliseconds between "tick" event.
		 */
		public function get tickInterval():Number
		{
			
			return _tickInterval;
			
		}
		
		/**
		 * @private
		 */
		public function set tickInterval(value:Number):void
		{
			
			_tickInterval = value;
			
			if ((countTimer != null) && countTimer.running)
			{
				
				// Timer is already running, reinitialize it
				createAndStartTimer();
				
			}
			
		}
		
		//----------------------------------
		//  days
		//----------------------------------
		
		private var _days:String;
		
		/**
		 * Days left 
		 */
		public function get days():String
		{
			
			return _days;
			
		}
		
		//----------------------------------
		//  daysNumber
		//----------------------------------
		
		private var _daysNumber:Number;
		
		/**
		 * Days left 
		 */
		public function get daysNumber():Number
		{
			
			return _daysNumber;
			
		}
		
		//----------------------------------
		//  hours
		//----------------------------------
		
		private var _hours:String;
		
		/**
		 *	Hours left (automatically includes 0s) 
		 */
		public function get hours():String
		{
			
			return _hours;
			
		}
		
		//----------------------------------
		//  hoursNumber
		//----------------------------------
		
		private var _hoursNumber:Number;
		
		/**
		 *	Hours left
		 */
		public function get hoursNumber():Number
		{
			
			return _hoursNumber;
			
		}
		
		//----------------------------------
		//  minutes
		//----------------------------------
		
		private var _minutes:String;
		
		/**
		 *  Minutes left (automatically includes 0s) 
		 */
		public function get minutes():String
		{
			
			return _minutes;
			
		}
		
		//----------------------------------
		//  minutesNumber
		//----------------------------------
		
		private var _minutesNumber:Number;
		
		/**
		 *  Minutes left
		 */
		public function get minutesNumber():Number
		{
			
			return _minutesNumber;
			
		}
		
		//----------------------------------
		//  seconds
		//----------------------------------
		
		private var _seconds:String;
		
		/**
		 *  Seconds left (automatically includes 0s) 
		 */
		public function get seconds():String
		{
			
			return _seconds;
			
		}
		
		//----------------------------------
		//  secondsNumber
		//----------------------------------
		
		private var _secondsNumber:Number;
		
		/**
		 *  Seconds left
		 */
		public function get secondsNumber():Number
		{
			
			return _secondsNumber;
			
		}
		
		//----------------------------------
		//  totalTimeLeft
		//----------------------------------
		
		private var _totalTimeLeft:Number;
		
		/**
		 * Total time left in milliseconds.
		 */
		public function get totalTimeLeft():Number
		{
			
			return _totalTimeLeft;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function toString():String
		{
			
			return "[TimerCountDown: " + days + " days, " + hours + " hours, " + minutes + " minutes, " + seconds + " seconds]";
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Starts the timer count down 
		 * @param countDownSeconds Time you want to count to in seconds. If less than 0,
		 * then it uses the value specified in constructor.
		 * 
		 */		
		public function start(countDownSeconds:Number = 0):void
		{
			
			if (!started)
			{
				
				started = true;
				
				if (countDownSeconds <= 0)
					countDownSeconds = _countDownSeconds;
				
				var date:Date = new Date();
				endDate = date.getTime() + (countDownSeconds * 1000);
				//endDate = endDate - date.getTime();
				
				createAndStartTimer();
				
			}
			
		}
		
		/**
		 * Pause the countdown timer 
		 * 
		 */		
		public function pause():void
		{
			
			if (started && countTimer.running)
			{
				
				var pauseDate:Date = new Date();
				pausedStarted = endDate - pauseDate.getTime();
				
				stopAndRemoveTimer();
				
			}
			
		}
		
		/**
		 * Resume countdown timer 
		 * 
		 */		
		public function resume():void
		{
			
			if (started && !countTimer.running)
			{
				
				//var timeLeft:Number = (endDate - now.getTime()) ;
				//endDate = endDate-pausedStarted;
				//endDate+=endDate-pausedStarted;
				
				var now:Date = new Date();
				endDate = now.getTime() + pausedStarted;
				
				createAndStartTimer();
				
			}
			
		}
		
		/**
		 * Stops currently running timer and resets.
		 * 
		 * @param countDownSeconds If set, TimerCountDown resets to this time.
		 * 
		 */
		public function reset(countDownSeconds:Number = NaN):void
		{
			
			stopAndRemoveTimer();
			
			started = false;
			
			if (isFinite(countDownSeconds))
				_countDownSeconds = countDownSeconds;
			
			calculateTimeLeft(_countDownSeconds * 1000);
			
		}
		
		private function createAndStartTimer():void
		{
			
			// Remove previous instance of timer
			stopAndRemoveTimer();
			
			// Create new timer and start
			countTimer = new Timer(tickInterval);
			countTimer.addEventListener(TimerEvent.TIMER, updateTime);
			countTimer.start();
			
		}
		
		private function stopAndRemoveTimer():void
		{
			
			if (countTimer != null)
			{
				
				countTimer.removeEventListener(TimerEvent.TIMER, updateTime);
				countTimer.stop();
				
			}
			
		}
		
		private function calculateTimeLeft(timeLeft:Number):void
		{
			
			_secondsNumber = Math.floor(timeLeft / 1000);
			_minutesNumber = Math.floor(_secondsNumber / 60);
			_hoursNumber = Math.floor(_minutesNumber / 60);
			_daysNumber = Math.floor(_hoursNumber / 24);
	
			_secondsNumber %= 60;
			_minutesNumber %= 60;
			_hoursNumber %= 24;
	
			var sec:String = _secondsNumber.toString();
			var min:String = _minutesNumber.toString();
			var hrs:String = _hoursNumber.toString();
			var d:String = daysNumber.toString();
	
			if (sec.length < 2)
				sec = "0" + sec;
			
			if (min.length < 2)
				min = "0" + min;
			
			if (hrs.length < 2)
				hrs = "0" + hrs;
			
			//var time:String = d + ":" + hrs + ":" + min + ":" + sec;
	
			//time_txt.text = time;
			_minutes = min;
			_seconds = sec;
			_hours = hrs;
			_days = d;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function updateTime(e:TimerEvent):void
		{
			
			var now:Date = new Date();
			var timeLeft:Number = endDate - now.getTime();
			
			if (timeLeft < 0)
				timeLeft = 0;
			
			_totalTimeLeft = timeLeft;
			calculateTimeLeft(timeLeft);
			
			dispatchEvent(new TimerCountDownEvent(TimerCountDownEvent.TICK));
			
			//if ((secondsNumber == minutesNumber == hoursNumber == daysNumber) && (secondsNumber == 0))
			if (timeLeft <= 0)
			{
				
				stopAndRemoveTimer();
				
				started = false;
				
				dispatchEvent(new TimerCountDownEvent(TimerCountDownEvent.COMPLETE));
				
			}
			
		}
		
	}
	
}