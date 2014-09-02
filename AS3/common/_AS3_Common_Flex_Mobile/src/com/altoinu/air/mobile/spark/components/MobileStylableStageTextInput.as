/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.air.mobile.spark.components
{
	
	import spark.components.TextInput;
	
	[Style(name="backgroundVisible", inherit="no", type="Boolean")]
	[Style(name="backgroundImage", inherit="no", type="Class")]
	
	// not allowing different skinClass to be defined
	[Exclude(name="skinClass", kind="style")]
	
	/**
	 * TextInput which uses custom StageTextInputSkin which handles StageText visibility automatically depending on
	 * focused state, so when the component does not have focus the text in native text field does not display
	 * on top. This may be necessary when another DisplayObject (such as pop ups) need to be displayed on top of
	 * TextInput but still want StageText functionalities (ex. softKeyboardType).
	 * 
	 * <p>TODO: currently there is a bug where if text is specified before MobileStylableStageTextInput is in view
	 * it will not show because textDisplay.visible = false. In order to make it show, skin.invalidateDisplayList()
	 * needs to be called on at least one of MobileStylableStageTextInput after it displays on screen, ex. viewActivate event.
	 * I think this is because native text field component referenced by StageText is not ready until MobileStylableStageTextInput
	 * is on screen ready to go.</p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class MobileStylableStageTextInput extends TextInput
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MobileStylableStageTextInput()
		{
			
			super();
			
			setStyle("skinClass", MobileStylableStageTextInputSkin);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden public properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable("change")]
		[Bindable("textChanged")]
		override public function get text():String
		{
			
			return super.text;
			
		}
		
		/**
		 * @private
		 */
		override public function set text(value:String):void
		{
			
			super.text = value;
			
			if (skin)
				skin.invalidateDisplayList();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function setFocus():void
		{
			
			if (skin)
				skin.invalidateDisplayList();
			
			super.setFocus();
			
		}
		
	}
	
}

import com.altoinu.air.system.AIRAppUtils;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.SoftKeyboardEvent;

import mx.core.EventPriority;
import mx.core.FlexGlobals;
import mx.core.mx_internal;
import mx.events.TouchInteractionEvent;
import mx.managers.IFocusManagerComponent;

import spark.components.Application;
import spark.components.supportClasses.StyleableStageText;
import spark.components.supportClasses.StyleableTextField;
import spark.core.IDisplayText;
import spark.skins.mobile.StageTextInputSkin;

use namespace mx_internal;

class MobileStylableStageTextInputSkin extends StageTextInputSkin implements IFocusManagerComponent
{
	
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	private static const PADDING_TOP_OFFSET:Number = 0;//-12;
	
	private static const SKIN_INSTANCES:Vector.<MobileStylableStageTextInputSkin> = new Vector.<MobileStylableStageTextInputSkin>();
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	private static var showCount:Array = [];
	private static var hideCount:Array = [];
	
	private static var touchInteracting:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Class method
	//
	//--------------------------------------------------------------------------
	
	private static function toggleTextDisplayVisibility():void
	{
		
		// This method toggles visibility of textDisplay element (StageText) in all instances of MobileStylableStageTextInputSkin.
		// On Android, switching focus to another MobileStylableStageTextInput would cause soft keyboard to jump between hide
		// and show state if it was already displayed but textDisplay in that element is visible == false.
		// By having all MobileStylableStageTextInputSkin keeping textDisplay.visible == true, focus can safely jump between
		// MobileStylableStageTextInputs without soft keyboard doing hide/show crazily.
		// Also if none of MobileStylableStageTextInput wants to display (not have focus) we would need to set
		// visiblility of textDisplay to false for all instances in that case so StageText is hidden, otherwise we cannot
		// place any other Flash DisplayObject on top.
		var numSkins:int = SKIN_INSTANCES.length;
		for (var i:int = 0; i < numSkins; i++)
		{
			
			/*
			if (SKIN_INSTANCES[i].textDisplay.getStageText().viewPort.width == 0)
			{
			
			SKIN_INSTANCES[i].mobileStyStgTxtInput_internal::updateStageTextPosition();
			SKIN_INSTANCES[i].invalidateDisplayList();
			SKIN_INSTANCES[i].validateNow();
			
			}
			
			trace(SKIN_INSTANCES[i].textDisplay.getStageText(), SKIN_INSTANCES[i].textDisplay.getStageText().text, SKIN_INSTANCES[i].textDisplay.getStageText().viewPort, SKIN_INSTANCES[i].width, SKIN_INSTANCES[i].height, SKIN_INSTANCES[i].textDisplay.width, SKIN_INSTANCES[i].textDisplay.height);
			*/
			
			if (!touchInteracting && (showCount.length > 0))
			{
				
				// At least one MobileStylableStageTextInputSkin wants to display
				// We will make all of them display
				//trace("==============SHOW");
				SKIN_INSTANCES[i].mobileStyStgTxtInput_internal::showStageText();
				
			}
			else // if (hideCount.length > 0)
			{
				
				// Hide all textDisplays
				//trace("==============HIDE");
				SKIN_INSTANCES[i].mobileStyStgTxtInput_internal::hideStageText();
				
			}
			
		}
		/*
		if (!touchInteracting && (showCount.length > 0))
		showCount.length;
		*/
		// reset
		showCount = [];
		hideCount = [];
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function MobileStylableStageTextInputSkin()
	{
		
		super();
		
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true);
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private properties
	//
	//--------------------------------------------------------------------------
	
	private var textDisplayJustInitialized:Boolean = false;
	private var focused:Boolean = false;
	private var backgroundChanged:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Protected properties
	//
	//--------------------------------------------------------------------------
	
	protected var backgroundElement:InteractiveObject;
	protected var stageTextCopy:Bitmap;
	
	//--------------------------------------------------------------------------
	//
	//  namespace
	//
	//--------------------------------------------------------------------------
	
	// used only within this skin class
	public namespace mobileStyStgTxtInput_internal;
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	private function getUnscaledTextWidth(unscaledWidth:Number):Number
	{
		
		var paddingLeft:Number = getStyle("paddingLeft");
		var paddingRight:Number = getStyle("paddingRight");
		var paddingTop:Number = getStyle("paddingTop");
		var paddingBottom:Number = getStyle("paddingBottom");
		
		return Math.max(0, unscaledWidth - paddingLeft - paddingRight);
		
	}
	
	private function getUnscaledTextHeight(unscaledHeight:Number):Number
	{
		
		var paddingLeft:Number = getStyle("paddingLeft");
		var paddingRight:Number = getStyle("paddingRight");
		var paddingTop:Number = getStyle("paddingTop");
		var paddingBottom:Number = getStyle("paddingBottom");
		
		//trace(unscaledHeight, paddingTop, paddingBottom, Math.max(0, unscaledHeight - (paddingTop + PADDING_TOP_OFFSET) - paddingBottom));
		return Math.max(0, unscaledHeight - (paddingTop + PADDING_TOP_OFFSET) - paddingBottom);
		
	}
	
	private function getTextY(unscaledHeight:Number, element:IDisplayText):Number
	{
		
		var paddingLeft:Number = getStyle("paddingLeft");
		var paddingRight:Number = getStyle("paddingRight");
		var paddingTop:Number = getStyle("paddingTop");
		var paddingBottom:Number = getStyle("paddingBottom");
		
		var textHeight:Number = getElementPreferredHeight(element);
		
		return Math.round(0.5 * (getUnscaledTextHeight(unscaledHeight) - textHeight)) + (paddingTop + PADDING_TOP_OFFSET);
		
	}
	
	private function isBackgroundVisible():Boolean
	{
		
		return (getStyle("backgroundVisible") != false);
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	override protected function createChildren():void
	{
		
		super.createChildren();
		
		textDisplayJustInitialized = true;
		
	}
	
	override protected function commitProperties():void
	{
		
		super.commitProperties();
		
		if (backgroundChanged)
		{
			
			// backgroundImage Style changed so we want to update it
			backgroundChanged = false;
			
			var backgroundClass:Class = getStyle("backgroundImage");
			var backgroundVisible:Boolean = isBackgroundVisible();
			
			// Remove previous background first
			if (backgroundElement && backgroundElement.parent)
			{
				
				backgroundElement.parent.removeChild(backgroundElement);
				backgroundElement = null;
				
			}
			
			if (backgroundClass && backgroundVisible)
			{
				
				// new background defined, so let's add it at bottom
				backgroundElement = new backgroundClass();
				addChildAt(backgroundElement, 0);
				
			}
			
		}
		
	}
	
	override public function styleChanged(styleProp:String):void
	{
		
		var allStyles:Boolean = !styleProp || styleProp == "styleName";
		
		if (allStyles ||
			(styleProp == "backgroundVisible") ||
			(styleProp == "backgroundImage"))
		{
			
			// backgroundImage changed
			backgroundChanged = true;
			invalidateProperties();
			
		}
		
		super.styleChanged(styleProp);
		
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		if (textDisplayJustInitialized)
		{
			
			// Skin was just initialized so we want to check to see if we need to show StageText or not
			textDisplayJustInitialized = false;
			this.mobileStyStgTxtInput_internal::toggleStageTextView();
			
		}
		
	}
	
	// This will be called by updateDisplayList in super class
	override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
	{
		
		super.layoutContents(unscaledWidth, unscaledHeight);
		
		var unscaledTextWidth:Number = getUnscaledTextWidth(unscaledWidth);
		var unscaledTextHeight:Number = getUnscaledTextHeight(unscaledHeight);
		
		// Correctly position textDisplay
		if (textDisplay)
		{
			
			textDisplay.commitStyles();
			
			var paddingLeft:Number = getStyle("paddingLeft");
			var paddingRight:Number = getStyle("paddingRight");
			var paddingTop:Number = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			
			setElementSize(textDisplay, unscaledTextWidth, unscaledTextHeight);
			setElementPosition(textDisplay, paddingLeft, getTextY(unscaledHeight, textDisplay));
			
			this.mobileStyStgTxtInput_internal::toggleStageTextView();
			
		}
		
		if (promptDisplay)
		{
			
			if (promptDisplay is StyleableTextField)
				StyleableTextField(promptDisplay).commitStyles();
			
			var promptHeight:Number = getElementPreferredHeight(promptDisplay);
			
			setElementSize(promptDisplay, unscaledTextWidth, promptHeight);
			setElementPosition(promptDisplay, paddingLeft, getTextY(unscaledHeight, promptDisplay));
			
		}
		
		// position & size backgroundElement
		if (backgroundElement)
		{
			
			setElementSize(backgroundElement, unscaledWidth, unscaledHeight);
			setElementPosition(backgroundElement, 0, 0);
			
		}
		
	}
	
	override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
	{
		
		// overridden to prevent default background from being drawn if background image is defined
		if (isBackgroundVisible() && !backgroundElement)
			super.drawBackground(unscaledWidth, unscaledHeight);
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * This makes bitmap copy of StageText so it can be displayed while textDisplay is hidden
	 * 
	 */
	protected function setBitmapStageTextCopy():void
	{
		
		removeBitmapStageTextCopy();
		
		stageTextCopy = new Bitmap(StyleableStageText(textDisplay).captureBitmapData());
		stageTextCopy.scaleX = stageTextCopy.scaleY = (FlexGlobals.topLevelApplication.applicationDPI / FlexGlobals.topLevelApplication.runtimeDPI);
		
		var paddingLeft:Number = getStyle("paddingLeft");
		stageTextCopy.x = paddingLeft;
		stageTextCopy.y = getTextY(unscaledHeight, textDisplay);
		
		if (backgroundElement)
			addChildAt(stageTextCopy, getChildIndex(backgroundElement) + 1); // make sure it is above background
		else
			addChildAt(stageTextCopy, 0);
		
	}
	
	protected function removeBitmapStageTextCopy():void
	{
		
		if (stageTextCopy && stageTextCopy.parent)
			stageTextCopy.parent.removeChild(stageTextCopy);
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Internal methods
	//
	//--------------------------------------------------------------------------
	
	mobileStyStgTxtInput_internal function updateStageTextPosition():void
	{
		
		// In order to update StageText position in StyleableStageText, invalidateViewPortFlag needs to be set to true and
		// invalidateProperties() needs to be called, but they are both private and cannot be directly accessed from outside.
		// I am calling move() here instead since it happens to do those two actions (with same x y so nothing changes).
		// Yes, I know, this is dirty trick, but it works. Hey, after so many dirty tricks I have pulled off in orrder to make
		// this app work, what's another one, right?
		textDisplay.move(textDisplay.x, textDisplay.y);
		StyleableStageText(textDisplay).invalidateDisplayList();
		
	}
	
	/**
	 * Shows textDisplay (StageText)
	 * 
	 */
	mobileStyStgTxtInput_internal function showStageText():void
	{
		
		if (textDisplay)
		{
			
			textDisplay.visible = true;
			
			// StageText was displayed, so update its position to make sure it lines up with MobileStylableStageTextInputSkin.
			// This is necessary in some situations because as of Flex 4.6 there is a bug in StyleableStageText where StageText
			// does not always align with component (ex. StageText position is not updated if Scroller scrolls TextInput
			// that uses StageTextSkin/StyleableStageText).
			this.mobileStyStgTxtInput_internal::updateStageTextPosition();
			
			// callLater prevents softkeyboard being jumpy when focus is changed programmatically
			callLater(removeBitmapStageTextCopy);
			
		}
		
	}
	
	/**
	 * Hides textDisplay (StageText) and displays bitmap copy of it
	 * 
	 */
	mobileStyStgTxtInput_internal function hideStageText():void
	{
		
		if (textDisplay)
		{
			
			setBitmapStageTextCopy();
			
			StyleableStageText(textDisplay).invalidateDisplayList();
			
			// callLater prevents softkeyboard being jumpy when focus is changed programmatically
			callLater(function():void
			{
				
				textDisplay.visible = false;
				
			});
			
		}
		
	}
	
	/**
	 * This method will mark this skin as wanting to either show or hide StageText
	 * 
	 */
	mobileStyStgTxtInput_internal function toggleStageTextView():void
	{
		
		if ((showCount.length == 0) && (hideCount.length == 0))
			callLater(toggleTextDisplayVisibility); // This method will toggle visibility of all StageTexts later at once
		
		if (focused)
		{
			
			// When focused, we want stageText to show
			
			if (showCount.indexOf(this) == -1)
				showCount.push(this); // keep track of how may MobileStylableStageTextInputSkin wants to display
			
		}
		else
		{
			
			// when unfocused, we want stageText to hide
			
			if (hideCount.indexOf(this) == -1)
				hideCount.push(this); // keep track of how may MobileStylableStageTextInputSkin wants to hide
			
		}
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function onAddedToStageHandler(event:Event):void
	{
		
		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false);
		
		this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true);
		
		this.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING, onTouchInteractionStart, false, 0, true);
		this.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, onTouchInteractionEnd, false, 0, true);
		this.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true);
		this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
		
		if (SKIN_INSTANCES.indexOf(this) == -1)
		{
			
			SKIN_INSTANCES.push(this);
			
			if (SKIN_INSTANCES.length == 1)
			{
				
				// First instance of the skin added to stage
				
				// We want to watch soft keyboard activate/deactivate
				appActivated = true;
				var app:Application = FlexGlobals.topLevelApplication as Application;
				app.addEventListener(Event.ACTIVATE, onAppActivateHandler, false, 0, true);
				app.addEventListener(Event.DEACTIVATE, onAppDeactivateHandler, false, 0, true);
				app.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onAppSoftKeyboardActivateHandler, false, 0, true);
				app.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onAppSoftKeyboardDeactivateHandler, false, 0, true);
				
			}
			
		}
		
		this.mobileStyStgTxtInput_internal::toggleStageTextView();
		
	}
	
	private function onRemovedFromStageHandler(event:Event):void
	{
		
		this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false);
		
		this.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING, onTouchInteractionStart, false);
		this.removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, onTouchInteractionEnd, false);
		this.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn, false);
		this.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false);
		
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true);
		
		if (SKIN_INSTANCES.indexOf(this) != -1)
		{
			
			SKIN_INSTANCES.splice(SKIN_INSTANCES.indexOf(this), 1);
			
			if (SKIN_INSTANCES.length == 0)
			{
				
				// That was last instance of the skin
				
				var app:Application = FlexGlobals.topLevelApplication as Application;
				app.removeEventListener(Event.ACTIVATE, onAppActivateHandler, false);
				app.removeEventListener(Event.DEACTIVATE, onAppDeactivateHandler, false);
				app.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onAppSoftKeyboardActivateHandler, false);
				app.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onAppSoftKeyboardDeactivateHandler, false);
				
			}
			
		}
		
	}
	
	private function onTouchInteractionStart(event:TouchInteractionEvent):void
	{
		
		// When touch interaction starts (ex. swipe to scroll) we will temporarily hide StageText until it ends
		touchInteracting = true;
		
		this.mobileStyStgTxtInput_internal::toggleStageTextView();
		
	}
	
	private function onTouchInteractionEnd(event:TouchInteractionEvent):void
	{
		
		touchInteracting = false;
		
		this.mobileStyStgTxtInput_internal::toggleStageTextView();
		
	}
	
	private function onFocusIn(event:FocusEvent):void
	{
		
		focused = true;
		
		this.mobileStyStgTxtInput_internal::toggleStageTextView();
		
		if ((textDisplay != null) && (event.target != textDisplay))
			textDisplay.setFocus(); // textDisplay was not the one that actually got focus (probably skin itself) so we want to give textDisplay focus here
		
	}
	
	private function onFocusOut(event:FocusEvent):void
	{
		
		focused = false;
		
		this.mobileStyStgTxtInput_internal::toggleStageTextView();
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Static Event handlers
	//
	//--------------------------------------------------------------------------
	
	private static var appActivated:Boolean = true;
	private static var softKeyboardActivated:Boolean = true;
	private static var softKeyboardTarget:DisplayObject;
	
	/**
	 * @private
	 * Watch specified keyTarget when soft keyboard is activated.
	 * @param keyTarget
	 * 
	 */
	private static function watchSoftKeyboardTarget(keyTarget:DisplayObject):void
	{
		
		if (softKeyboardTarget)
			clearSoftKeyboardTarget();
		
		softKeyboardTarget = keyTarget;
		
		// If the display object that activates the softkeyboard is removed without
		// losing focus, the runtime may not dispatch a deactivate event.  So the
		// framework adds a REMOVE_FROM_STAGE event listener to the target and manually
		// clears the focus.
		softKeyboardTarget.addEventListener(Event.REMOVED_FROM_STAGE, 
			softKeyboardTarget_removeFromStageHandler, 
			false, EventPriority.DEFAULT, true);
		
		// On iOS, if the softKeyboard target is removed from the stage as a result
		// of a user input with another focusable component, the application will not
		// receive a SOFT_KEYBOARD_DEACTIVATE event, only the target will.
		if (AIRAppUtils.isiOSDevice() != null)
		{
			
			softKeyboardTarget.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, 
				onAppSoftKeyboardDeactivateHandler, false, 
				EventPriority.DEFAULT, true);
			
		}
		
	}
	
	/**
	 *  @private
	 *  This method clears the cached softKeyboard target and removes the
	 *  removeFromStage handler that is added in the softKeyboardActivateHandler
	 *  method.
	 */
	private static function clearSoftKeyboardTarget():void
	{
		
		if (softKeyboardTarget)
		{
			
			softKeyboardTarget.removeEventListener(Event.REMOVED_FROM_STAGE, softKeyboardTarget_removeFromStageHandler, false);
			
			if (AIRAppUtils.isiOSDevice() != null)
			{
				
				softKeyboardTarget.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, 
					onAppSoftKeyboardDeactivateHandler, false);
				
			}
			
			softKeyboardTarget = null;
			
		}
		
	}
	
	private static function onAppActivateHandler(event:Event):void
	{
		
		appActivated = true;
		
	}
	
	private static function onAppDeactivateHandler(event:Event):void
	{
		
		appActivated = false;
		
	}
	
	/**
	 * @private
	 * Soft keyboard activate handler.
	 * @param event
	 * 
	 */
	private static function onAppSoftKeyboardActivateHandler(event:SoftKeyboardEvent):void
	{
		
		if (appActivated)
		{
			
			if (FlexGlobals.topLevelApplication.stage.softKeyboardRect.height > 0)
				softKeyboardActivated = true;
			
			watchSoftKeyboardTarget(event.target as DisplayObject);
			
			// When soft keyboard activates, we want to update StageText position on screen because
			// I think there is a bug in Flex 4.6 that does not make this happen all the time
			for each (var textSkin:MobileStylableStageTextInputSkin in SKIN_INSTANCES)
			{
				
				textSkin.mobileStyStgTxtInput_internal::updateStageTextPosition();
				
			}
			
		}
		
	}
	
	/**
	 *  @private
	 *  Called when a softKeyboard activation target is removed from the
	 *  stage.  If the target has stage focus, then the focus is set to null.
	 *  This will cause a SOFT_KEYBOARD_DEACTIVATE event to be dispatched.
	 */ 
	private static function softKeyboardTarget_removeFromStageHandler(event:Event):void
	{
		
		// clearSoftKeyboardTarget() is called in response to the SOFT_KEYBOARD_DEACTIVATE
		// event and will clear the removeFromStage listener and softKeyboardDeactivate 
		// events from the target.
		
		softKeyboardActivated = false;
		clearSoftKeyboardTarget();
		
		// When soft keyboard dectivates, we want to update StageText position on screen because
		// I think there is a bug in Flex 4.6 that does not make this happen all the time
		for each (var textSkin:MobileStylableStageTextInputSkin in SKIN_INSTANCES)
		{
			
			textSkin.mobileStyStgTxtInput_internal::updateStageTextPosition();
			
		}
		
	}
	
	/**
	 * @private
	 * Soft keyboard deactivate handler.
	 * @param event
	 * 
	 */
	private static function onAppSoftKeyboardDeactivateHandler(event:SoftKeyboardEvent):void
	{
		
		softKeyboardActivated = false;
		clearSoftKeyboardTarget();
		
		// When soft keyboard dectivates, we want to update StageText position on screen because
		// I think there is a bug in Flex 4.6 that does not make this happen all the time
		for each (var textSkin:MobileStylableStageTextInputSkin in SKIN_INSTANCES)
		{
			
			textSkin.mobileStyStgTxtInput_internal::updateStageTextPosition();
			
		}
		
	}
	
}