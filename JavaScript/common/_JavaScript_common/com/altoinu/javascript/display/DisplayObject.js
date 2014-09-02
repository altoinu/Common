/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * Elements for display objects
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * Requirements:
 * 
 * com.altoinu.javascript.utils.utils.js 1.1
 * com.altoinu.javascript.events.EventDispatcher.js 1.0
 * 
 * jQuery 1.8.3
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.display";
	var version = "1.8.2";
	console.log(namespace + " - DisplayObject.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);
	var EventDispatcher = $targetObject.com.altoinu.javascript.events.EventDispatcher;

	ns.DisplayObject = function() {

		// extends EventDispatcher
		EventDispatcher.call(this);
		var _super = {};
		for ( var _superProp in this) {

			_super[_superProp] = this[_superProp];

		}

		// --------------------------------------------------------------------------
		//
		// Private properties
		//
		// --------------------------------------------------------------------------

		var me = this;

		var div = $("<div/>");

		var invalidateDisplayFlag = false;
		var validateTimeOutID;

		// --------------------------------------------------------------------------
		//
		// Private methods
		//
		// --------------------------------------------------------------------------

		var updateDisplay = function() {

			invalidateDisplayFlag = false;

		};

		// --------------------------------------------------------------------------
		//
		// Public methods
		//
		// --------------------------------------------------------------------------

		this.getDiv = function() {

			return div;

		};

		this.invalidateDisplay = function() {

			if (!invalidateDisplayFlag) {

				invalidateDisplayFlag = true;

				validateTimeOutID = setTimeout(function() {

					me.validateNow();

				}, 1);

			}

		};

		this.validateNow = function() {

			updateDisplay();

		};

		this.getSize = function() {

			return {
				width: div.width(),
				height: div.height()
			};

		};

	};

	// extends DisplayObject
	ns.DisplayObject.prototype = new EventDispatcher();
	ns.DisplayObject.prototype.constructor = ns.DisplayObject;

	/**
	 * Using specified sprite sheet image, do frame by frame animation (similar
	 * to MovieClip in Flash).
	 * 
	 * @param spriteSheetURL
	 *            A single URL string or Array of URL strings to the sprite
	 *            sheet URL. If Array of URL strings is specified, then each are
	 *            played in sequence to display as one long MovieClip (image[0] ->
	 *            image[1] -> image[2]...). It may be necessary to split sprite
	 *            sheet images into separate files since certain devices like
	 *            iOS do not allow loading images that have larger than certain
	 *            pixels dimensions. In that case, make sure number of
	 *            rows/columns match across images.
	 * @param rows
	 *            Number of rows in each image, or Array of row heights in
	 *            pixels (array length is number of rows in this case).
	 * @param columns
	 *            Number of columns in each image, or Array of column width in
	 *            pixels (array length is number of columns in this case).
	 * @param frameRate
	 * @param frameOrigin
	 * @param cssClass
	 *            optional CSS class
	 * @param containerCSSClass
	 *            optional CSS class
	 * @param imageCSSClass
	 *            optional CSS class
	 * @returns {ns.SpriteSheetMovieClip}
	 * 
	 * Events
	 * SpriteSheetMovieClip.ON_START = "onStart" // At first frame, or last frame if reversing
	 * SpriteSheetMovieClip.ON_COMPLETE = "onComplete" // At last frame, or first frame if reversing
	 * SpriteSheetMovieClip.ON_PLAY = "onPlay" // When playing begins
	 * SpriteSheetMovieClip.ON_STOP = "onStop" // When playing stops
	 * SpriteSheetMovieClip.ON_ENTER_FRAME = "onEnterFrame" // At every frame
	 */
	ns.SpriteSheetMovieClip = function(spriteSheetURL, rows, columns, frameRate, frameOrigin, cssClass, containerCSSClass, imageCSSClass) {

		// extends DisplayObject
		ns.DisplayObject.call(this);
		var _super = {};
		for ( var _superProp in this) {

			_super[_superProp] = this[_superProp];

		}

		// --------------------------------------------------------------------------
		//
		// Private properties
		//
		// --------------------------------------------------------------------------

		var me = this;

		var containerCSS = {
			position: "absolute",
			width: "100%",
			height: "100%",
			overflow: "hidden"
		};
		var container = $("<div/>").css(containerCSS).appendTo(this.getDiv());

		var spriteSheetImageURLs = (spriteSheetURL instanceof Array ? spriteSheetURL : [
			spriteSheetURL
		]);
		var numImages = spriteSheetImageURLs.length;

		// Array.apply(null, new Array(rows)).map(Number.prototype.valueOf, rows);
		var frameRowNum = rows instanceof Array ? rows.length : rows;
		var frameRowHeights = rows instanceof Array ? rows : null;
		var frameColumnNum = columns instanceof Array ? columns.length : columns;
		var frameColumnWidths = columns instanceof Array ? columns : null;
		var framesPerImage = frameRowNum * frameColumnNum;

		// Array of Images to do actual loading of individual sprite sheet
		var imageElements = [];

		// Array of div element to actually display images
		var imageHolderDiv = [];

		// Div element currently displaying
		var currentImageDiv;

		var loadCount = 0;
		var currentFrame = 0;
		var lastFrame = 0;

		var playIntervalID;
		var reversing = false;
		var stopPlayingAtFrame = null;

		// --------------------------------------------------------------------------
		//
		// Public properties
		//
		// --------------------------------------------------------------------------

		this.frameRate = frameRate;
		this.frameOrigin = frameOrigin;

		/**
		 * Whether to start to beginning once it reaches end
		 */
		this.loop = false;

		/**
		 * Function to call when image loads
		 */
		this.onImageLoaded = null;

		/**
		 * Function to call when sequence starts playing at beginning frame 1 or
		 * last frame if playing reverse
		 */
		this.onStart = null;

		/**
		 * Function to call when sequence reaches last frame or frame 1 if
		 * playing reverse
		 */
		this.onComplete = null;

		/**
		 * Function to call when playing stops.
		 */
		this.onStop = null;
		
		/**
		 * Function to call on entering each frame
		 */
		this.onEnterFrame = null;

		var _divCSSClass;

		this.getDivCSSClass = function() {

			return _divCSSClass;

		};

		this.setDivCSSClass = function(value) {

			if (_divCSSClass != value) {

				var target = me.getDiv();
				if (_divCSSClass)
					target.removeClass(_divCSSClass);

				if (value)
					target.addClass(value);

				_divCSSClass = value;

				me.invalidateDisplay();

			}

		};

		var _containerCSSClass;

		this.getContainerCSSClass = function() {

			return _containerCSSClass;

		};

		this.setContainerCSSClass = function(value) {

			if (_containerCSSClass != value) {

				var target = container;
				if (_containerCSSClass)
					target.removeClass(_containerCSSClass);

				if (value)
					target.addClass(value);

				_containerCSSClass = value;

				me.invalidateDisplay();

			}

		};

		var _imageCSSClass;

		this.getImageCSSClass = function() {

			return _imageCSSClass;

		};

		this.setImageCSSClass = function(value) {

			if (_imageCSSClass != value) {

				var target = container.children();
				if (_imageCSSClass)
					target.removeClass(_imageCSSClass);

				if (value)
					target.addClass(value);

				_imageCSSClass = value;

				me.invalidateDisplay();

			}

		};

		// --------------------------------------------------------------------------
		//
		// Private methods
		//
		// --------------------------------------------------------------------------

		// Updates sprite to current frame
		var updateDisplay = function() {

			var currentImageIndex = me.getCurrentSpriteSheetImageIndex();
			var currentImage = imageElements[currentImageIndex];
			if (!currentImage)
				return;

			var currentImageFrame = me.getCurrentSpriteSheetImageFrame();

			// col then row
			// 1 - columns
			var targetCol = (currentImageFrame - 1) % frameColumnNum + 1;
			// 1 - rows
			var targetRow = Math.floor((currentImageFrame - 1) / frameColumnNum) + 1;

			// row then column
			// 1 - rows
			// var targetRow = (currentImageFrame - 1) % frameRowNum + 1;
			// 1 - columns
			// var targetCol = Math.floor((currentImageFrame - 1) / frameRowNum) + 1;

			// calculate root div, container dimensions
			// and background image pos

			var rootDivWidth;
			var containerWidth;
			var bgXPos;
			if (frameColumnWidths != null) {

				// root div width is largest of defined ones
				rootDivWidth = Math.max.apply(null, frameColumnWidths);
				// Use defined width for current col image
				containerWidth = frameColumnWidths[targetCol - 1];
				// add all widths up to current
				bgXPos = 0;
				frameColumnWidths.every(function(element, index, array) {

					if (index < targetCol - 1) {

						bgXPos -= element;
						return true;

					} else {

						return false;

					}

				});

			} else {

				// calculate based on image size
				rootDivWidth = currentImage.width / frameColumnNum;
				containerWidth = rootDivWidth;
				bgXPos = (targetCol - 1) * -rootDivWidth;

			}

			var rootDivHeight;
			var containerHeight;
			var bgYPos;
			if (frameRowHeights != null) {

				// root div height is largest of defined ones
				rootDivHeight = Math.max.apply(null, frameRowHeights);
				// Use defined height for current row image
				containerHeight = frameRowHeights[targetRow - 1];
				// add all heights up to current
				bgYPos = 0;
				frameRowHeights.every(function(element, index, array) {

					if (index < targetRow - 1) {

						bgYPos -= element;
						return true;

					} else {

						return false;

					}

				});

			} else {

				rootDivHeight = currentImage.height / frameRowNum;
				containerHeight = rootDivHeight;
				bgYPos = (targetRow - 1) * -rootDivHeight;

			}

			// root div
			var rootDiv = me.getDiv();
			if (rootDiv.width() != rootDivWidth) {

				rootDiv.css({
					width: rootDivWidth + "px",
				});

			}
			if (rootDiv.height() != rootDivHeight) {

				rootDiv.css({
					height: rootDivHeight + "px",
					"line-height": rootDivHeight + "px"
				});

			}

			// container
			if (container.height() != containerWidth)
				container.width(containerWidth);
			if (container.height() != containerHeight)
				container.height(containerHeight);

			// Align current frame to specified coordinate
			var currentFrameAlignCSS = {
				"left": "",
				"right": "",
				"top": "",
				"bottom": "",
			};
			var currentFrameOrigin;

			if ((me.frameOrigin == null) ||
				(!me.frameOrigin.hasOwnProperty("left") && !me.frameOrigin.hasOwnProperty("right") && (!me.frameOrigin.hasOwnProperty(currentImageFrame - 1) || (!me.frameOrigin[currentImageFrame - 1].hasOwnProperty("left") && !me.frameOrigin[currentImageFrame - 1].hasOwnProperty("right"))))) {

				currentFrameAlignCSS["left"] = "";
				currentFrameAlignCSS["right"] = "";

			} else {

				// left or right, but not both
				if (me.frameOrigin.hasOwnProperty("left")) {

					currentFrameAlignCSS["left"] = me.frameOrigin["left"] + "px";

				} else if (me.frameOrigin.hasOwnProperty("right")) {

					currentFrameAlignCSS["right"] = me.frameOrigin["right"] + "px";

				} else if (me.frameOrigin.hasOwnProperty(currentImageFrame - 1)) {

					currentFrameOrigin = me.frameOrigin[currentImageFrame - 1];

					if (currentFrameOrigin.hasOwnProperty("left"))
						currentFrameAlignCSS["left"] = currentFrameOrigin["left"] + "px";
					else if (currentFrameOrigin.hasOwnProperty("right"))
						currentFrameAlignCSS["right"] = currentFrameOrigin["right"] + "px";

				}

			}

			if ((me.frameOrigin == null) ||
				(!me.frameOrigin.hasOwnProperty("top") && !me.frameOrigin.hasOwnProperty("bottom") && (!me.frameOrigin.hasOwnProperty(currentImageFrame - 1) || (!me.frameOrigin[currentImageFrame - 1].hasOwnProperty("top") && !me.frameOrigin[currentImageFrame - 1].hasOwnProperty("bottom"))))) {

				currentFrameAlignCSS["top"] = "";
				currentFrameAlignCSS["bottom"] = "";

			} else {

				// top or bottom, but not both
				if (me.frameOrigin.hasOwnProperty("top")) {

					currentFrameAlignCSS["top"] = me.frameOrigin["top"] + "px";

				} else if (me.frameOrigin.hasOwnProperty("bottom")) {

					currentFrameAlignCSS["bottom"] = me.frameOrigin["bottom"] + "px";

				} else if (me.frameOrigin.hasOwnProperty(currentImageFrame - 1)) {

					currentFrameOrigin = me.frameOrigin[currentImageFrame - 1];

					if (currentFrameOrigin.hasOwnProperty("top"))
						currentFrameAlignCSS["top"] = currentFrameOrigin["top"] + "px";
					else if (currentFrameOrigin.hasOwnProperty("bottom"))
						currentFrameAlignCSS["bottom"] = currentFrameOrigin["bottom"] + "px";

				}

			}

			container.css(currentFrameAlignCSS);

			if (currentImageDiv != imageHolderDiv[currentImageIndex]) {

				// switch to imageHolderDiv with corresponding sprite sheet
				// image displaying
				if (currentImageDiv)
					currentImageDiv.css("visibility", "hidden");

				currentImageDiv = imageHolderDiv[currentImageIndex];
				currentImageDiv.css("visibility", "visible");

			}

			// Set div position
			var bgPos = bgXPos + "px " + bgYPos + "px";
			if (currentImageDiv.css("backgroundPosition") != bgPos)
				currentImageDiv.css("backgroundPosition", bgPos);

		};

		/**
		 * Function to be executed on interval to do playing
		 */
		var doPlayFrames = function() {

			if (me.isLoaded()) {

				var onStartFired = false;
				var onStopFired = false;
				
				if ((!reversing && (me.getCurrentFrame() == 1)) || (reversing && (me.getCurrentFrame() == me.getTotalFrames()))) {

					// starting normal play, at frame 1 or
					// starting reverse, at last frame
					onStartFired = true;
					doOnStart();

				}

				if (doPlayFrames.firstFrame) {
					
					doOnPlay();
					doPlayFrames.firstFrame = false;
					
				}
				
				doOnEnterFrame();

				if ((stopPlayingAtFrame == null) ||
					(!reversing && (me.getCurrentFrame() < stopPlayingAtFrame)) ||
					(reversing && (me.getCurrentFrame() > stopPlayingAtFrame))) {
					
					// Only play if we are not at frame
					// specified as where to stop at
					
					if (!reversing) {

						// normal play

						if (me.getCurrentFrame() != me.getTotalFrames())
							me.nextFrame();
						else if (me.loop) // loop from beginning
							me.setCurrentFrame(1);

					} else {

						// reverse play

						if (me.getCurrentFrame() != 1)
							me.prevFrame();
						else if (me.loop) // loop from end
							me.setCurrentFrame(me.getTotalFrames());

					}

					if ((!reversing && (me.getCurrentFrame() == 1)) || (reversing && (me.getCurrentFrame() == me.getTotalFrames()))) {

						if (!onStartFired)
							doOnStart();

					}
					
				}

				// If frame to stop at is specified and we reached that frame
				if ((stopPlayingAtFrame != null) && (me.getCurrentFrame() == stopPlayingAtFrame)) {
					
					// stop now
					onStopFired = true;
					doOnStop();
					
				}
				
				if ((!reversing && (me.getCurrentFrame() == me.getTotalFrames())) || (reversing && (me.getCurrentFrame() == 1))) {

					// reached last frame on normal play
					// or first frame on reverse play

					if (!me.loop && !onStopFired)
						doOnStop(); // We don't want to loop so stop here

					// onComplete is defined so call it
					doOnComplete();

				}

			}

		};
		doPlayFrames.firstFrame = false;
		
		var Event = com.altoinu.javascript.events.Event;

		var doOnStart = function() {

			me.dispatchEvent(new Event(ns.SpriteSheetMovieClip.ON_START));

			if (me.onStart)
				me.onStart.call(me);

		};
		
		var doOnPlay = function() {

			me.dispatchEvent(new Event(ns.SpriteSheetMovieClip.ON_PLAY));

			if (me.onPlay)
				me.onPlay.call(me);
			
		};
		
		var doOnStop = function() {
			
			me.dispatchEvent(new Event(ns.SpriteSheetMovieClip.ON_STOP));
			
			stopPlay();
			
			if (me.onStop)
				me.onStop.call(me);
			
		};

		var doOnComplete = function() {

			me.dispatchEvent(new Event(ns.SpriteSheetMovieClip.ON_COMPLETE));

			if (me.onComplete)
				me.onComplete.call(me);

		};

		var doOnEnterFrame = function() {

			me.dispatchEvent(new Event(ns.SpriteSheetMovieClip.ON_ENTER_FRAME));

			if (me.onEnterFrame)
				me.onEnterFrame.call(me);

		};

		var startPlay = function() {

			if (playIntervalID)
				clearInterval(playIntervalID);

			doPlayFrames.firstFrame = true;
			playIntervalID = setInterval(doPlayFrames, 1000 / me.frameRate);

		};

		var stopPlay = function() {

			if (playIntervalID) {

				clearInterval(playIntervalID);
				playIntervalID = null;

			}
			
			// clear frame to stop at, too
			stopPlayingAtFrame = null;

		};
		
		// --------------------------------------------------------------------------
		//
		// Overridden public methods
		//
		// --------------------------------------------------------------------------

		this.validateNow = function() {

			_super.validateNow.call(this);
			updateDisplay();

		};

		// --------------------------------------------------------------------------
		//
		// Public methods
		//
		// --------------------------------------------------------------------------

		/**
		 * Becomes true when all images are loaded.
		 */
		this.isLoaded = function() {

			return loadCount == spriteSheetImageURLs.length;

		};

		this.getCurrentSpriteSheetImageIndex = function() {

			return Math.ceil(me.getCurrentFrame() / framesPerImage) - 1;

		};

		this.getCurrentSpriteSheetImageFrame = function() {

			return ((me.getCurrentFrame() - 1) % framesPerImage) + 1;

		};

		/**
		 * Default 0 if images are not loaded yet (this.isLoaded() == false). or
		 * (row x columns x number of sprite sheets) if all images are loaded.
		 */
		this.getTotalFrames = function() {

			if (!me.isLoaded())
				return 0;
			if (lastFrame > 0)
				return lastFrame;
			else
				return framesPerImage * numImages;

		};

		/**
		 * Overrides last frame number. If specified value is 0 < value < (row x
		 * columns x number of sprite sheets) then that frame number will be the
		 * last, otherwise default is (row x columns x number of sprite sheets).
		 */
		this.setLastFrame = function(value) {

			if (value && isFinite(value) && (lastFrame != value) && (0 < value) && (value <= (framesPerImage * numImages)))
				lastFrame = value;
			else
				lastFrame = 0;

		};

		/**
		 * 0 if images are not loaded yet (this.isLoaded() == false). 1 -
		 * this.this.getTotalFrames() if all images are loaded.
		 */
		this.getCurrentFrame = function() {

			return currentFrame;

		};

		/**
		 * Must be set between 1 and getTotalFrames(), otherwise no effect.
		 */
		this.setCurrentFrame = function(value) {

			if (value && isFinite(value) && (me.getCurrentFrame() != value) && (0 < value) && (value <= me.getTotalFrames())) {

				currentFrame = value;

				me.invalidateDisplay();

			}

		};

		/**
		 * Advances to next frame. No effect if current frame is already at the
		 * end.
		 */
		this.nextFrame = function() {

			me.setCurrentFrame(me.getCurrentFrame() + 1);

		};

		/**
		 * Go to previous frame. No effect if current frame is already at the
		 * beginning.
		 */
		this.prevFrame = function() {

			me.setCurrentFrame(me.getCurrentFrame() - 1);

		};

		/**
		 * Starts playing sprite sheet MovieClip.
		 * 
		 * @param startFrame
		 *            If specified, this is where MovieClip will start playing
		 *            from.
		 * @param stopAtFrame
		 *            Frame number greater or equal to current frame number to
		 *            automatically stop at.
		 */
		this.play = function(startFrame, stopAtFrame) {

			// play from specified startFrame if defined
			if (isFinite(startFrame))
				me.setCurrentFrame(startFrame);
			// or play from 1 if movie is already at end
			else if (me.getCurrentFrame() >= me.getTotalFrames())
				me.setCurrentFrame(1);

			if (isFinite(stopAtFrame) && (me.getCurrentFrame() <= stopAtFrame))
				stopPlayingAtFrame = stopAtFrame;
			else
				stopPlayingAtFrame = null;
			
			reversing = false;
			startPlay();

		};

		/**
		 * Starts playing sprite sheet MovieClip in reverse.
		 * 
		 * @param startFrame
		 *            If specified, this is where MovieClip will start playing
		 *            from.
		 * @param stopAtFrame
		 *            Frame number smaller or equal to current frame number to
		 *            automatically stop at.
		 */
		this.reverse = function(startFrame, stopAtFrame) {

			// play from specified startFrame if defined
			if (isFinite(startFrame))
				me.setCurrentFrame(startFrame);
			// or play from last if movie is already at beginning
			else if (me.getCurrentFrame() <= 1)
				me.setCurrentFrame(me.getTotalFrames());

			if (isFinite(stopAtFrame) && (me.getCurrentFrame() >= stopAtFrame))
				stopPlayingAtFrame = stopAtFrame;
			else
				stopPlayingAtFrame = null;
			
			reversing = true;
			startPlay();

		};

		/**
		 * Stops sprite sheet MovieClip if already playing.
		 */
		this.stop = function() {

			stopPlay();
			
		};

		this.isPlaying = function() {

			return (playIntervalID != null);

		};

		this.isReversing = function() {

			return reversing;

		};

		// --------------------------------------------------------------------------
		//
		// Initializations
		//
		// --------------------------------------------------------------------------

		this.getDiv().css({
			width: 0,
			height: 0,
			"line-height": 0,
			overflow: "visible"
		});

		for (var i = 0; i < numImages; i++) {

			// Create div to hold on to this image
			var imageDiv = $("<div/>").css({
				position: "absolute",
				left: "0px",
				top: "0px",
				width: "100%",
				height: "100%",
				"background-image": "url('" + spriteSheetImageURLs[i] + "')",
				"background-repeat": "no-repeat",
				backgroundPosition: "0px 0px",
				overflow: "hidden",
				visibility: "hidden"
			}).appendTo(container);

			imageHolderDiv.push(imageDiv);

			// Load each image
			imageElements.push(new Image());

			$(imageElements[imageElements.length - 1]).one("load", function(event) {

				loadCount++;

				if (me.isLoaded()) {

					// All images have been loaded
					currentFrame = 1;

					if (me.onImageLoaded)
						me.onImageLoaded.call(me);

					// update display
					me.invalidateDisplay();

				}

			}).attr("src", spriteSheetImageURLs[i]);

		}

		me.setDivCSSClass(cssClass);
		me.setContainerCSSClass(containerCSSClass);
		me.setImageCSSClass(imageCSSClass);

	};

	// extends DisplayObject
	ns.SpriteSheetMovieClip.prototype = new ns.DisplayObject();
	ns.SpriteSheetMovieClip.prototype.constructor = ns.SpriteSheetMovieClip;

	// constants
	ns.SpriteSheetMovieClip.ON_START = "onStart";
	ns.SpriteSheetMovieClip.ON_COMPLETE = "onComplete";
	ns.SpriteSheetMovieClip.ON_PLAY = "onPlay";
	ns.SpriteSheetMovieClip.ON_STOP = "onStop";
	ns.SpriteSheetMovieClip.ON_ENTER_FRAME = "onEnterFrame";

	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
