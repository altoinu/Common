/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * Requirements:
 * 
 * com.altoinu.javascript.utils.utils.js 1.1
 * 
 * jQuery 1.8.1
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.display";
	var version = "1.4";
	console.log(namespace + " - TimerDisplay.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	/**
	 * Stop watch like time display.
	 * 
	 * @param timerCSSClass
	 * @returns {ns.TimerDisplay}
	 */
	ns.TimerDisplay = function(timerCSSClass) {

		// --------------------------------------------------------------------------
		//
		// Private properties
		//
		// --------------------------------------------------------------------------

		var me = this;

		var div = $("<div/>").addClass(timerCSSClass);

		var startTime = 0;
		var endTime = 0;
		var countFromTime = 0;
		var isCountUp = false;
		var updateTimerInterval;

		// --------------------------------------------------------------------------
		//
		// Private methods
		//
		// --------------------------------------------------------------------------

		var updateTimer = function() {

			endTime = (new Date()).getTime();

			var currentTime;
			if (countFromTime > 0) {

				// timer started from specified time

				// if counting up, current time is
				// specified time + elapsed
				// if counting down, current time is
				// specified time - elapsed
				currentTime = countFromTime + ((isCountUp ? 1 : -1) * me.getElapsedTime());

				if (currentTime < 0)
					currentTime = 0;

			} else {

				// timer started from 0, so current time is same as elapsed
				currentTime = me.getElapsedTime();

			}

			// Mod by 1 seconds = 1000 milliseconds -> remaining is millisec
			var currentMillisec = currentTime % 1000;
			// Mod by 1 min = 60 seconds -> remaining is seconds
			var currentSeconds = Math.floor(currentTime / 1000) % 60;
			// Mod by 1 hour = 60 seconds = 1000 * 60 milliseconds -> remaining
			// is minutes
			var currentMin = Math.floor(currentTime / (1000 * 60)) % 60;

			var timeDisplay = "";
			if (me.displayMinutes)
				timeDisplay += ((me.displayMinLeadingZero && (currentMin < 10) ? "0" : "") + currentMin);
			if (me.displaySeconds)
				timeDisplay += ((me.displayMinutes ? ":" : "") + (currentSeconds < 10 ? "0" : "") + currentSeconds);
			if (me.displayMilliseconds)
				timeDisplay += ((me.displaySeconds ? "." : "") + (currentMillisec < 100 ? "0" : "") + (currentMillisec < 10 ? "0" : "") + currentMillisec);

			div.html(timeDisplay);

			if ((countFromTime > 0) && (currentTime == 0)) {

				// stop count down
				if (updateTimerInterval)
					clearInterval(updateTimerInterval);

				if (me.countDownOnComplete)
					me.countDownOnComplete();

			}

		};

		// --------------------------------------------------------------------------
		//
		// Public properties
		//
		// --------------------------------------------------------------------------

		this.displayMinutes = true;
		this.displaySeconds = true;
		this.displayMilliseconds = true;

		this.displayMinLeadingZero = true;

		/**
		 * If counting down, this method will be called when timer reaches 0.
		 */
		this.countDownOnComplete = null;

		// --------------------------------------------------------------------------
		//
		// Public methods
		//
		// --------------------------------------------------------------------------

		this.getDiv = function() {

			return div;

		};

		/**
		 * Starts timer.
		 * 
		 * @param countStartFrom
		 *            If not specified (default), timer counts up, starting from
		 *            0. If a number in milliseconds is specified then timer
		 *            will start counting from that time.
		 * @param countUp
		 *            If countStartFrom is specified, timer will count down from
		 *            that time then automatically stop when it reaches 0 if
		 *            this value is set to false (default). If true, then timer
		 *            will count up.
		 */
		this.start = function(countStartFrom, countUp) {

			if (!updateTimerInterval) {

				startTime = (new Date()).getTime();

				if (isFinite(countStartFrom) && (countStartFrom > 0)) {

					countFromTime = countStartFrom;

					// double ! converts any value to true/false
					// undefined, null, 0, "" -> false
					// all other values -> true
					isCountUp = !!countUp;

				} else {

					countFromTime = 0;
					isCountUp = true;

				}

				updateTimer();
				updateTimerInterval = setInterval(updateTimer, 20);

			}

		};

		this.stop = function() {

			if (updateTimerInterval) {

				updateTimer();
				clearInterval(updateTimerInterval);
				updateTimerInterval = null;

			}

		};

		this.getElapsedTime = function() {

			return endTime - startTime;

		};

	};

	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
