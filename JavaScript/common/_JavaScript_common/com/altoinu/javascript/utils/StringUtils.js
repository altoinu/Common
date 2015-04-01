/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * Requirements:
 * 
 * com.altoinu.javascript.utils.utils.js 1.4
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {
	
	var namespace = "com.altoinu.javascript.utils";
	var version = "0.1";
	console.log(namespace + " - StringUtils.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	/**
	 * NumberUtils class
	 */
	ns.StringUtils = function() {

	};
	
	ns.StringUtils.stripHTML = function(s) {
		
		return s.replace(/<.*?>/g, "");
		
	}
	
})(window);
//You can change $targetObject here to something other than default reference
//to "window" object to store elements and classes under it
