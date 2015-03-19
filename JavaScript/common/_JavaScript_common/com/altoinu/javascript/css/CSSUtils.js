/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * @author Kaoru Kawashima http://www.altoinu.com
 *
 * Requirements:
 * 
 * jQuery 1.8.3
 * com.altoinu.javascript.utils.utils.js 1.3
 * 
 */
(function($targetObject, $) {
	
	var namespace = "com.altoinu.javascript.css";
	var version = "1.0.1";
	console.log(namespace + " - CSSUtils.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	ns.CSSUtils = function() {
	};
	
	/**
	 * Shrinks selected label element font size until it fits parent
	 * container without line break.
	 * 
	 * The target labelElement must have css white-space: pre;
	 * (and float: left; I think. haven't tested this yet)
	 */
	ns.CSSUtils.shrinkFontSizeToFit = function(labelElement, initialFontSize) {
		
		var labelContainerWidth = labelElement.parent().width();
		var fontSize = initialFontSize;
		if (labelElement.width() > labelContainerWidth) {

			// Name too long to fit! Shrink it
			while ((labelElement.width() > labelContainerWidth) && (fontSize > 1)) {

				// Try decreasing font size until characters fits
				labelElement.css("font-size", --fontSize + "px");

			}

		}
		
	};
	
})(window, window.jQuery);
//You can change $targetObject here to something other than default reference
//to "window" object to store elements and classes under it
