/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * Classes and methods to do CSS related operations.
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * Requirements:
 * 
 * com.altoinu.javascript.utils.utils.js 1.1
 * 
 * jQuery 1.7.2
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.css";
	var version = "1.0.1";
	console.log(namespace + " - Transform.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	// --------------------------------------------------------------------------
	//
	// Constants
	//
	// --------------------------------------------------------------------------

	var TRANSFORM_MATRIX_REGEX = /matrix\((-?\d*\.?\d+),\s*0,\s*0,\s*(-?\d*\.?\d+),\s*0,\s*0\)/;

	var CSSTransform = function() {
		var me = this;
	};

	/**
	 * Gets jQuery.css value of transform for specified element.
	 * 
	 * @param selector
	 * @returns
	 */
	CSSTransform.getTransformMatrix = function(selector) {

		var jqobj = selector ? $(selector) : null;
		return jqobj ?
				(jqobj.css("transform") || jqobj.css("-mx-transform") || jqobj.css("-moz-transform") || jqobj.css("-o-transform") || jqobj.css("-webkit-transform") || null)
				: null;

	};

	/**
	 * Gets CSS transform scale values for specified element.
	 * 
	 * @param selector
	 * @returns {scaleX: x, scaleY: y} or null if CSS transform is not specified
	 *          or not supported by browser.
	 */
	CSSTransform.getScale = function(selector) {

		var transform = CSSTransform.getTransformMatrix(selector);

		if (transform) {

			var matches = transform.match(TRANSFORM_MATRIX_REGEX);
			var scaleX = matches && isFinite(Number(matches[1])) ? Number(matches[1]) : 1;
			var scaleY = matches && isFinite(Number(matches[2])) ? Number(matches[2]) : 1;

			return {
				scaleX: scaleX,
				scaleY: scaleY
			};

		} else {

			return null;

		}

	};

	ns.CSSTransform = CSSTransform;
	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
