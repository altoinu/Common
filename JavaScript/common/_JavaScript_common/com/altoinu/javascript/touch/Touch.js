/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * Touch related stuff
 * 
 * Requirements:
 * 
 * com.altoinu.javascript.utils.utils.js 1.1
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.touch";
	var version = "1.2";
	console.log(namespace + " - Touch.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	/**
	 * Touch class
	 */
	ns.Touch = function() {

	};

	/**
	 * Checks to see if running on device that supports touch input.
	 * 
	 * @return true/false
	 */
	ns.Touch.isTouchDevice = function() {

		// Check in the actual "window" object instead of $targetObject
		// to see if touch related events exist
		return !!('ontouchstart' in window) // works on most browsers
				|| !!('onmsgesturechange' in window); // works on ie10

	};

	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
