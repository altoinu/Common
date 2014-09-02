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
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.utils";
	var version = "1.1";
	console.log(namespace + " - ArrayUtils.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	/**
	 * ArrayUtils class
	 */
	ns.ArrayUtils = function() {

	};

	/**
	 * Array shuffling
	 * 
	 * @param array
	 *            Array to be shuffled
	 * @param copy
	 *            A flag used to determine if a copy of the array is returned or
	 *            if the original array is changed. False will modify the
	 *            original array, True will return a new array. Default false.
	 */
	ns.ArrayUtils.shuffle = function(array, copy) {

		var returnArray = [];
		var orgArray = array.slice();

		while (orgArray.length > 0) {

			var r = Math.floor(Math.random() * orgArray.length);
			returnArray.push(orgArray.splice(r, 1)[0]);

		}

		if (copy) {

			console.log("Copy!");
			return returnArray;

		} else {

			console.log("Modified!");
			for ( var i = 0, arrayLength = array.length; i < arrayLength; i++) {

				array[i] = returnArray[i];

			}

			return;

		}

	};

	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
