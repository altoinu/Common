/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.drawingboard
{
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	/**
	 * Interface for a class to hold several images to represent one visible image.
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface IDrawingLayer extends IDrawable, IEventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  name
		//----------------------------------
		
		/**
		 * Name of the layer.
		 */		
		function get name():String;
		
		/**
		 * @private
		 */
		function set name(value:String):void;
		
		//----------------------------------
		//  parentDrawingBoard
		//----------------------------------
		
		/**
		 * mouseEnabled
		 */		
		function get mouseEnabled():Boolean;
		
		/**
		 * @private
		 */
		function set mouseEnabled(value:Boolean):void;
		
		//----------------------------------
		//  parentDrawingBoard
		//----------------------------------
		
		/**
		 * DrawingBoard this layer is currently placed at.
		 */		
		function get parentDrawingBoard():IDrawingBoard;
		
		/**
		 * @private
		 */
		function set parentDrawingBoard(newDrawingBoard:IDrawingBoard):void;
		
		//----------------------------------
		//  bitmapSmoothing
		//----------------------------------
		
		function get bitmapSmoothing():Boolean;
		
		/**
		 * @private
		 */
		function set bitmapSmoothing(value:Boolean):void;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Clears the layer by removing all drawing items in it.
		 *
		 * @return Object containing two Arrays, Object.bitmaps which contains
		 * Bitmaps affected by erase operation and Object.nonBitmaps which contains non-Bitmaps removed.
		 */
		function clearContents():Array;
		
		/**
		 * Get array of <code>DisplayObjects</code> currently on the <code>IDrawingLayer</code>.
		 *
		 * @return Array of objects.  i+1th element is on top of ith element.
		 */
		function getChildren():Array;
		
		/**
		 * Moves specified targetDrawingItem up one level if it is on this <code>DrawingLayer</code>.
		 */
		function moveDrawingItemUp(targetDrawingItem:DisplayObject):void;
		
		/**
		 * Moves specified targetDrawingItem down one level if it is on this <code>DrawingLayer</code>.
		 */
		function moveDrawingItemDown(targetDrawingItem:DisplayObject):void;
		
	}
	
}