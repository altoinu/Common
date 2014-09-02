/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * Basic utility methods
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.utils";
	var version = "1.3";
	console.log(namespace + " - utils.js: " + version);

	if (!$targetObject) {

		throw "$targetObject object must be specified";
		return;

	}

	var ns = function() {
	};

	/**
	 * Creates namespace (ex specified as "com.altoinu.package.path.etc...) under
	 * specified targetWindow object if it does not exists. Ex.
	 * "com.altoinu.package.path.game" would create objects targetWindow == {com:
	 * {altoinu: {package: {path: {game: {}}}}}}
	 * 
	 * @param targetWindow
	 * @param targetNamespace
	 *            namespace in string, each package separated by period. Ex.
	 *            "com.altoinu.package.path.game"
	 * @returns Object at the end of namespace hierarchy. Ex. If namespace =
	 *          "com.altoinu.package.path.game" then reference to game is
	 *          returned.
	 */
	ns.createNamespace = function(targetWindow, targetNamespace) {

		if (!targetWindow) {

			throw "targetWindow object must be specified";
			return;

		}

		var path = targetNamespace.split(".");
		var numPaths = path.length;
		var currentPath = targetWindow;
		for ( var i = 0; i < numPaths; i++) {

			if (!(path[i] in currentPath))
				currentPath[path[i]] = {};

			currentPath = currentPath[path[i]];

		}

		return currentPath;

	};

	/**
	 * Creates namespace (ex specified as "com.altoinu.package.path.etc...) under
	 * specified targetWindow object if it does not exists, then assigns all
	 * objects in sourceObj to it.
	 * 
	 * @param targetWindow
	 * @param targetNamespace
	 *            namespace in string, each package separated by period. Ex.
	 *            "com.altoinu.package.path.game"
	 * @param sourceObj
	 * @returns
	 */
	ns.setObjects = function(targetWindow, targetNamespace, sourceObj) {

		// Create namespace on targetWindow
		var target = ns.createNamespace(targetWindow, targetNamespace);

		// Make all objects in sourceObj available in namespace created
		for ( var property in sourceObj) {

			target[property] = sourceObj[property];

		}

		return sourceObj;

	};

	/**
	 * Checks to see if Flash plugin is installed.
	 * 
	 * @returns true/false
	 */
	ns.hasFlash = function() {

		try {

			var fo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
			if (fo)
				return true;

		} catch (e) {

			if (navigator.mimeTypes["application/x-shockwave-flash"] != undefined)
				return true;

		}

		return false;

	};

	// Create namespace on $targetObject and set object in it
	return ns.setObjects($targetObject, namespace, ns);

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
