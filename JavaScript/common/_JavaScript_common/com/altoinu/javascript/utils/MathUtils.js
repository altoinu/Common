/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * Math utility methods
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * Requirements:
 * 
 * com.altoinu.javascript.utils.utils.js 1.3
 * 
 * jQuery 2.1.1
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 * @param $
 * @returns {___anonymous873_874}
 */
(function($targetObject, $) {

	var namespace = "com.altoinu.javascript.utils";
	var version = "1.0.1";
	console.log(namespace + " - MathUtils.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	var MathUtils = function() {
		var me = this;
	};

	/**
	 * Returns random integer between min and max.
	 * @param min
	 * @param max
	 */
	MathUtils.randRange = function(min, max) {

		return Math.floor(Math.random() * (max - min + 1)) + min;

	}

	/**
	 * Given container rectangle containerWidth x containerHeight,
	 * find scale that allows a rectangle defined by
	 * width x height to fit exactly in that container.
	 * 
	 * @params width
	 * @params height
	 * @params containerWidth
	 * @params containerHeight
	 * @params precision Number of decimal points
	 */
	MathUtils.getFitScale = function(width, height, containerWidth, containerHeight, precision) {

		var decimalNum = (precision != null) && isFinite(precision) && (precision >= 0) ? Math.floor(precision) : 2;
		var fit_scale_x = containerWidth / width;
		var fit_scale_y = containerHeight / height;

		return Number(fit_scale_x <= fit_scale_y ? fit_scale_x : fit_scale_y).toFixed(decimalNum);

	};

	ns.MathUtils = MathUtils;
	return ns;

})(window, window.jQuery);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
