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
 * com.altoinu.javascript.utils.utils.js 1.3
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.utils";
	var version = "1.1";
	console.log(namespace + " - NetUtils.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	/**
	 * NetUtils class
	 */
	ns.NetUtils = function() {

	};

	/**
	 * Convert data URL string to Blob.
	 * 
	 * ex.
	 * var formData = new FormData();
	 * var blob = NetUtils.dataURItoBlob(canvas.toDataURL("image/jpeg"));
	 * formData.append("imageFile", blob, "image.jpg");
	 * 
	 * @param dataURI
	 * @returns {Blob}
	 */
	ns.NetUtils.dataURItoBlob = function(dataURI) {
		'use strict'
		var byteString, mimestring;

		if (dataURI.split(',')[0].indexOf('base64') !== -1) {
			byteString = atob(dataURI.split(',')[1]);
		} else {
			byteString = decodeURI(dataURI.split(',')[1]);
		}

		mimestring = dataURI.split(',')[0].split(':')[1].split(';')[0];

		var content = new Array();
		for (var i = 0; i < byteString.length; i++) {
			content[i] = byteString.charCodeAt(i);
		}

		return new Blob([
			new Uint8Array(content)
		], {
			type: mimestring
		});
	};

	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
