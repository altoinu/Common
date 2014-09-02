/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls
{
	
	import flash.events.Event;
	
	import mx.controls.VideoDisplay;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	use namespace mx_internal;
	
	/**
	 * VideoDisplay component with an option to smooth through property &quot;<code>smoothing</code>&quot;.
	 * 
	 * <p>This component is based on <code>mx.controls.VideoDisplay</code>. You may want to use spark VideoDisplay instead
	 * if working with Flex 4.</p>
	 * 
	 * @author Kaoru Kawashima
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion Flex 3
	 */
	public class VideoDisplaySmooth extends VideoDisplay
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function VideoDisplaySmooth()
		{
			
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  smoothing
		//----------------------------------
		
		private var _smoothing:Boolean = false;
		
		[Bindable(event="smoothingChange")]
		public function get smoothing():Boolean
		{
			
			return _smoothing;
			
		}
		
		public function set smoothing(value:Boolean):void
		{
			
			if (_smoothing != value)
			{
				
				_smoothing = value;
				
				if (videoPlayer)
					videoPlayer.smoothing = _smoothing;
				
				dispatchEvent(new Event("smoothingChange"));
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onCreationComplete(event:FlexEvent):void
		{
			
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			if (videoPlayer.smoothing != smoothing)
				videoPlayer.smoothing = smoothing;
			
		}
		
	}
	
}