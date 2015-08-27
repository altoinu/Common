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
 * jQuery 1.8.1
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.display.UI";
	var version = "1.0.1";
	console.log(namespace + " - UI.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	/**
	 * Radio button element that can be CSS styled...and IE8 compatible! YAY
	 * (IE8 cannot handle :checked selector in CSS). To style radio button
	 * element, use CSS selectors: "(cssClass) input[type="radio"]([name="groupName"]) +
	 * img.selected" "(cssClass) input[type="radio"]([name="groupName"]) + img.unselected".
	 * 
	 * @param value
	 * @param labelText
	 * @param groupName
	 * @param cssClass
	 * @returns {ns.StyledRadioButton}
	 */
	var StyledRadioButton = function(value, labelText, groupName, cssClass) {

		// --------------------------------------------------------------------------
		//
		// Private properties
		//
		// --------------------------------------------------------------------------

		var me = this;

		var div = $("<div/>").addClass(cssClass);

		// hidden radio button to track group
		var radio = $("<input/>").attr({
			type: "radio",
			name: groupName,
			value: String(value),
		}).css({
			float: "left",
			display: "none"
		}).appendTo(div);

		var radioImg = $("<img/>").addClass("unselected").css({
			float: "left",
		}).appendTo(div);

		var label = $("<span/>").append(labelText).appendTo(div);

		// --------------------------------------------------------------------------
		//
		// Private methods
		//
		// --------------------------------------------------------------------------

		var getCSSClassSelector = function() {

			return cssClass ? "." + cssClass : "";

		};

		// --------------------------------------------------------------------------
		//
		// Public methods
		//
		// --------------------------------------------------------------------------

		this.getDiv = function() {

			return div;

		};

		this.isSelected = function() {

			return radio.is(':checked');

		};

		this.getValue = function() {

			return value;

		};

		this.getLabelText = function() {

			return labelText;

		};

		this.getGroupName = function() {

			return groupName;

		};

		// --------------------------------------------------------------------------
		//
		// Event handlers
		//
		// --------------------------------------------------------------------------

		radioImg.on("click", function() {

			var cssClassSelector = getCSSClassSelector();

			// first deselect all radio
			$(cssClassSelector + (cssClassSelector.length > 0 ? " " : "") + "input:radio[name='" + groupName + "'] + img.selected").removeClass("selected").addClass("unselected");
			$(cssClassSelector + (cssClassSelector.length > 0 ? " " : "") + "input:radio[name='" + groupName + "']").attr({
				checked: false
			});

			// then select this one
			radio.attr({
				checked: true
			});
			radioImg.removeClass("unselected").addClass("selected");

		});

		radio.on("change", function() {

			var cssClassSelector = getCSSClassSelector();

			// deselect all
			$(cssClassSelector + (cssClassSelector.length > 0 ? " " : "") + "input:radio[name='" + groupName + "'] + img.selected").removeClass("selected").addClass("unselected");

			// then select this one
			radioImg.removeClass("unselected").addClass("selected");

		});

	};

	ns.StyledRadioButton = StyledRadioButton;
	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
