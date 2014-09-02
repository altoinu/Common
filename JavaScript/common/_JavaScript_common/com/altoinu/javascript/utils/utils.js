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
		for (var i = 0; i < numPaths; i++) {

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

	/**
	 * Given array where each element has multi ID pattern
	 * {id: {"name1": "value1", "name2": "value2", ...}, someother: data, another: data2, ...}
	 * find element with matching ID pattern targetIDs.
	 * 
	 * ex. {id: {id1: "value1", id2: "value2", id3: "value3"}, ...}
	 * - {id1: "value1", id2: "value2", id3: "value3"} match
	 * - {id1: "value1", id2: "blah", id3: "value3"} not match (id2 not match)
	 * - {id1: "value1", id3: "value3"} not match (id2 missing)
	 * - {id1: "value1", id2: "value2", id3: "value3", id4: "value4"} not match (extra id4)
	 * 
	 * If one of "name-i" == null (name exists but value set to null),
	 * then corresponding ID in targetIDs will be ignored whether it exists or not.
	 * ex. {id: {id1: "value1", id2: "value2", id3: null}, ...}
	 * - {id1: "value1", id2: "value2"} match (id3 can be missing)
	 * - {id1: "value1", id2: "value2", id3: "value3"} match (id3 can exist with any value)
	 * - {id1: "value1", id2: "blah"} not match (id2 not match)
	 * - {id1: "value1", id2: "blah", id3: "value3"} not match (id2 not match)
	 * 
	 * If matching ID pattern is found, that entire object is returned
	 * Null is returned if none match.
	 */
	ns.getItemWithMultiIDs = function(arrayOfMultiIDObj, targetIDs) {

		/*
		console.log(arrayOfMultiIDObj);
		
		console.log(arrayOfMultiIDObj[0]);
		console.log(arrayOfMultiIDObj[0].id.hasOwnProperty("cargo"));
		console.log(arrayOfMultiIDObj[0].id["cargo"]);
		console.log(arrayOfMultiIDObj[0].id["cargo"] != null);
		console.log(arrayOfMultiIDObj[0].id["cargo"] == null);
		console.log(arrayOfMultiIDObj[0].id["cargo"] == undefined);
		console.log(arrayOfMultiIDObj[0].id["cargo"] !== null);
		console.log(arrayOfMultiIDObj[0].id["cargo"] === null);
		console.log(arrayOfMultiIDObj[0].id["cargo"] === undefined);
		 */

		var matchedItem = null;

		if (arrayOfMultiIDObj) {

			arrayOfMultiIDObj.some(function(item, index, array) {

				//console.log(item);
				var matchedIDs = [];

				// Check if specified targetIDs exist and values match in current item
				for ( var targetIDProp in targetIDs) {

					if (item.id.hasOwnProperty(targetIDProp) && ((item.id[targetIDProp] === null) || (item.id[targetIDProp] == targetIDs[targetIDProp]))) {

						// One ID of targetIDs exists in this item and
						// its value can be anything (item.id[targetIDProp] === null) or values match

						// this ID is a match
						matchedIDs.push(targetIDProp); // remember this ID for now

					} else {

						// One ID of targetIDs is not in this item,
						// or its value does not match the corresponding one

						// this item is not match
						//console.log("not match: " + targetIDProp);
						return false;

					}

				}

				// At this point, so far all targetIDs match in this item.
				// Check to see if there are any IDs in item.id
				for ( var itemIDProp in item.id) {

					if ((matchedIDs.indexOf(itemIDProp) == -1) && (item.id[itemIDProp] !== null)) {

						// This ID does not exist in targetIDs
						// and since it is not null, it has to match the
						// corresponding one in targetID but it is not

						// this item is not a match
						//console.log("not match, missing: " + itemIDProp);
						return false;

					}

				}

				// If we get here, this item.id matches targetIDs
				//console.log("woot");
				matchedItem = item;
				return true;

			});

		}

		//console.log("matched item?");
		//console.log(matchedItem);
		return matchedItem;

	};

	// Create namespace on $targetObject and set object in it
	return ns.setObjects($targetObject, namespace, ns);

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
