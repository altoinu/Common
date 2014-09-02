/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * Stuff to get around IE issues.
 * 
 * Some other notes:
 * 
 * <!--[if IE 8]>
 * <script type="text/javascript">
 * 	isIE8 = true;
 * </script>
 * <![endif]-->
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.utils";
	var version = "1.3";

	// IE does not support console.log and breaks silently
	// if developer tools is not open. Dumb.
	if (!("console" in window)) {

		console = {
			log: function(arg) {
			}
		};

	}

	console.log(namespace + " - ie.js: " + version);

	'use strict';

	// Add ECMA262-5 method binding if not supported natively
	//
	if (!('bind' in Function.prototype)) {
		Function.prototype.bind = function(owner) {
			var that = this;
			if (arguments.length <= 1) {
				return function() {
					return that.apply(owner, arguments);
				};
			} else {
				var args = Array.prototype.slice.call(arguments, 1);
				return function() {
					return that.apply(owner, arguments.length === 0 ? args : args.concat(Array.prototype.slice.call(arguments)));
				};
			}
		};
	}

	// Add ECMA262-5 String methods if not supported natively
	//
	if (!('trim' in String.prototype)) {
		String.prototype.trim = function() {
			return this.replace(/^\s+/, '').replace(/\s+$/, '');
		};
	}
	if (!('indexOf' in String.prototype)) {
		String.prototype.indexOf = function(find, i /*opt*/) {
			if (i === undefined)
				i = 0;
			if (i < 0)
				i += this.length;
			if (i < 0)
				i = 0;
			for ( var n = this.length; i < n; i++)
				if (i in this && this.charAt(i) === find)
					return i;
			return -1;
		};
	}
	if (!('lastIndexOf' in String.prototype)) {
		String.prototype.lastIndexOf = function(find, i /*opt*/) {
			if (i === undefined)
				i = this.length - 1;
			if (i < 0)
				i += this.length;
			if (i > this.length - 1)
				i = this.length - 1;
			for (i++; i-- > 0;)
				/* i++ because from-argument is sadly inclusive */
				if (i in this && this.charAt(i) === find)
					return i;
			return -1;
		};
	}
	
	// Add ECMA262-5 Array methods if not supported natively
	//
	if (!('indexOf' in Array.prototype)) {
		Array.prototype.indexOf = function(find, i /*opt*/) {
			if (i === undefined)
				i = 0;
			if (i < 0)
				i += this.length;
			if (i < 0)
				i = 0;
			for ( var n = this.length; i < n; i++)
				if (i in this && this[i] === find)
					return i;
			return -1;
		};
	}
	if (!('lastIndexOf' in Array.prototype)) {
		Array.prototype.lastIndexOf = function(find, i /*opt*/) {
			if (i === undefined)
				i = this.length - 1;
			if (i < 0)
				i += this.length;
			if (i > this.length - 1)
				i = this.length - 1;
			for (i++; i-- > 0;)
				/* i++ because from-argument is sadly inclusive */
				if (i in this && this[i] === find)
					return i;
			return -1;
		};
	}
	if (!('forEach' in Array.prototype)) {
		Array.prototype.forEach = function(action, that /*opt*/) {
			for ( var i = 0, n = this.length; i < n; i++)
				if (i in this)
					action.call(that, this[i], i, this);
		};
	}
	if (!('map' in Array.prototype)) {
		Array.prototype.map = function(mapper, that /*opt*/) {
			var other = new Array(this.length);
			for ( var i = 0, n = this.length; i < n; i++)
				if (i in this)
					other[i] = mapper.call(that, this[i], i, this);
			return other;
		};
	}
	if (!('filter' in Array.prototype)) {
		Array.prototype.filter = function(filter, that /*opt*/) {
			var other = [], v;
			for ( var i = 0, n = this.length; i < n; i++)
				if (i in this && filter.call(that, v = this[i], i, this))
					other.push(v);
			return other;
		};
	}
	if (!('every' in Array.prototype)) {
		Array.prototype.every = function(tester, that /*opt*/) {
			for ( var i = 0, n = this.length; i < n; i++)
				if (i in this && !tester.call(that, this[i], i, this))
					return false;
			return true;
		};
	}
	if (!('some' in Array.prototype)) {
		Array.prototype.some = function(tester, that /*opt*/) {
			for ( var i = 0, n = this.length; i < n; i++)
				if (i in this && tester.call(that, this[i], i, this))
					return true;
			return false;
		};
	}

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
