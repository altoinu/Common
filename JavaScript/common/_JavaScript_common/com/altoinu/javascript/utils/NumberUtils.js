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
	var version = "1.1.1";
	console.log(namespace + " - NumberUtils.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	/**
	 * NumberUtils class
	 */
	ns.NumberUtils = function() {

	};

	/**
	 * Convert numbers to words copyright 25th July 2006, by Stephen Chapman
	 * http://javascript.about.com permission to use this Javascript on your web
	 * page is granted provided that all of the code (including this copyright
	 * notice) is used exactly as shown (you can change the numbering system if
	 * you wish)
	 * 
	 * @param s
	 * @returns
	 */
	ns.NumberUtils.toWords = function(s) {

		// American Numbering System
		var th = [
			'',
			'thousand',
			'million',
			'billion',
			'trillion'
		];
		// uncomment this line for English Number System
		// var th = ['','thousand','million', 'milliard','billion'];

		var dg = [
			'zero',
			'one',
			'two',
			'three',
			'four',
			'five',
			'six',
			'seven',
			'eight',
			'nine'
		];
		var tn = [
			'ten',
			'eleven',
			'twelve',
			'thirteen',
			'fourteen',
			'fifteen',
			'sixteen',
			'seventeen',
			'eighteen',
			'nineteen'
		];
		var tw = [
			'twenty',
			'thirty',
			'forty',
			'fifty',
			'sixty',
			'seventy',
			'eighty',
			'ninety'
		];

		s = s.toString();
		s = s.replace(/[\, ]/g, '');
		if (s != parseFloat(s))
			return 'not a number';
		var x = s.indexOf('.');
		if (x == -1)
			x = s.length;
		if (x > 15)
			return 'too big';
		var n = s.split('');
		var str = '';
		var sk = 0;
		for (var i = 0; i < x; i++) {
			if ((x - i) % 3 == 2) {
				if (n[i] == '1') {
					str += tn[Number(n[i + 1])] + ' ';
					i++;
					sk = 1;
				} else if (n[i] != 0) {
					str += tw[n[i] - 2] + ' ';
					sk = 1;
				}
			} else if (n[i] != 0) {
				str += dg[n[i]] + ' ';
				if ((x - i) % 3 == 0)
					str += 'hundred ';
				sk = 1;
			}
			if ((x - i) % 3 == 1) {
				if (sk)
					str += th[(x - i - 1) / 3] + ' ';
				sk = 0;
			}
		}
		if (x != s.length) {
			var y = s.length;
			str += 'point ';
			for (var i = x + 1; i < y; i++)
				str += dg[n[i]] + ' ';
		}
		return str.replace(/\s+/g, ' ');

	};

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
	ns.NumberUtils.getFitScale = function(width, height, containerWidth, containerHeight, precision) {

		var decimalNum = (precision != null) && isFinite(precision) && (precision >= 0) ? Math.floor(precision) : 2;
		var fit_scale_x = containerWidth / width;
		var fit_scale_y = containerHeight / height;

		return Number(fit_scale_x <= fit_scale_y ? fit_scale_x : fit_scale_y).toFixed(decimalNum);

	};

	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
