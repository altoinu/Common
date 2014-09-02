/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.controls
{
	
	import com.altoinu.flash.customcomponents.events.StageVideoPlayerEvent;
	import com.altoinu.flash.customcomponents.events.VideoPlayerEvent;
	import com.altoinu.flash.customcomponents.events.VideoPlayerMetaDataEvent;
	import com.altoinu.flash.customcomponents.video.StageVideoPlayer;
	import com.altoinu.flash.customcomponents.video.VideoPlayerState;
	import com.altoinu.flex.customcomponents.mx.controls.supportClasses.HolderUIComponentBase;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.FlexGlobals;
	
	/**
	 * StageVideo available.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.StageVideoPlayerEvent.AVAILABLE
	 */
	[Event(name="availble", type="com.altoinu.flash.customcomponents.events.StageVideoPlayerEvent")]
	
	/**
	 * StageVideo unavailable.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.StageVideoPlayerEvent.UNAVAILABLE
	 */
	[Event(name="unavailble", type="com.altoinu.flash.customcomponents.events.StageVideoPlayerEvent")]
	
	/**
	 * Video state change.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.STATE_CHANGE
	 */
	[Event(name="stateChange", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video started playing.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.PLAYING_STATE_ENTERED
	 */
	[Event(name="playingStateEntered", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video paused.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.PAUSED_STATE_ENTERED
	 */
	[Event(name="pausedStateEntered", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video started playing.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.STOPPED_STATE_ENTERED
	 */
	[Event(name="stoppedStateEntered", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video reached the end.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.COMPLETE
	 */
	[Event(name="complete", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video rewinded.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.REWIND
	 */
	[Event(name="rewind", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video seeked.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.SEEKED
	 */
	[Event(name="seeked", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video connection opened.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.LOADING_STATE_ENTERED
	 */
	[Event(name="loadingStateEntered", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/*
	* Video connection closed.
	* 
	* @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.BUFFERING_STATE_ENTERED
	*/
	//[Event(name="bufferingStateEntered", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video connection closed.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.CLOSE
	 */
	[Event(name="close", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video connection error.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerEvent.CONNECTION_ERROR
	 */
	[Event(name="connectionError", type="com.altoinu.flash.customcomponents.events.VideoPlayerEvent")]
	
	/**
	 * Video metadata received.
	 * 
	 * @eventType com.altoinu.flash.customcomponents.events.VideoPlayerMetaDataEvent.METADATA_RECEIVED
	 */
	[Event(name="metadataReceived", type="com.altoinu.flash.customcomponents.events.VideoPlayerMetaDataEvent")]
	
	/**
	 * UIComponent to display StageVideoPlayer on top of it.
	 * 
	 * <p>Note: make sure to have no DisplayObject on top of StageVideoPlayer area (x, y, width, height)
	 * since StageVideo sits on a layer behind everything. Don't forget about other StageVideo limitations, too.</p>
	 * 
	 * <p>Also, make sure you use videos that are h.264 encoded to get hardware acceleartion to kick in (FAST).
	 * Normal .flvs can still be played but they will be software rendered.</p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 11.1
	 * @playerversion AIR 3.5
	 * @productversion Flex 4.6
	 */
	public class StageVideoPlayerUIComponent extends HolderUIComponentBase
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StageVideoPlayerUIComponent()
		{
			
			super();
			
			this.addEventListener(Event.ACTIVATE,onActivate,false,0,true);
			this.addEventListener(Event.DEACTIVATE,onDeactivate,false,0,true);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properites
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  stageVideoPlayer
		//--------------------------------------
		
		private var _stageVideoPlayer:StageVideoPlayer;
		
		protected function get stageVideoPlayer():StageVideoPlayer
		{
			
			return _stageVideoPlayer;
			
		}
		
		/**
		 * @private
		 */
		protected function set stageVideoPlayer(value:StageVideoPlayer):void
		{
			
			_stageVideoPlayer = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden public properites
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  visible
		//--------------------------------------
		
		override public function set visible(value:Boolean):void
		{
			
			super.visible = value;
			
			if (stageVideoPlayer)
				stageVideoPlayer.visible = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properites
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  backgroundColor
		//--------------------------------------
		
		private var _backgroundColor:uint = 0x000000;
		
		[Bindable(event="backgroundColorChange")]
		public function get backgroundColor():uint
		{
			
			return stageVideoPlayer ? stageVideoPlayer.backgroundColor : _backgroundColor;
			
		}
		
		/**
		 * @private
		 */
		public function set backgroundColor(value:uint):void
		{
			
			if (_backgroundColor !== value)
			{
				
				_backgroundColor = value;
				
				if (stageVideoPlayer)
					stageVideoPlayer.backgroundColor = value;
				
				dispatchEvent(new Event("backgroundColorChange"));
				
			}
			
		}
		
		//--------------------------------------
		//  source
		//--------------------------------------
		
		private var _source:String;
		
		[Bindable(event="sourceChange")]
		/**
		 * URL to video to play.
		 */
		public function get source():String
		{
			
			return stageVideoPlayer ? stageVideoPlayer.source : _source;
			
		}
		
		/**
		 * @private
		 */
		public function set source(value:String):void
		{
			
			if (_source !== value)
			{
				
				_source = value;
				
				loadVideo();
				
				dispatchEvent(new Event("sourceChange"));
				
			}
			
		}
		
		//--------------------------------------
		//  autoPlay
		//--------------------------------------
		
		private var _autoPlay:Boolean = true;
		
		[Bindable(event="autoPlayChange")]
		/**
		 * @default true
		 */
		public function get autoPlay():Boolean
		{
			
			return stageVideoPlayer ? stageVideoPlayer.autoPlay : _autoPlay;
			
		}
		
		/**
		 * @private
		 */
		public function set autoPlay(value:Boolean):void
		{
			
			if (_autoPlay != value)
			{
				
				_autoPlay = value;
				
				if (stageVideoPlayer)
					stageVideoPlayer.autoPlay = value;
				
				dispatchEvent(new Event("autoPlayChange"));
				
			}
			
		}
		
		//--------------------------------------
		//  autoRewind
		//--------------------------------------
		
		private var _autoRewind:Boolean = false;
		
		[Bindable(event="autoRewindChange")]
		/**
		 * @default false
		 */
		public function get autoRewind():Boolean
		{
			
			return stageVideoPlayer ? stageVideoPlayer.autoRewind : _autoRewind;
			
		}
		
		/**
		 * @private
		 */
		public function set autoRewind(value:Boolean):void
		{
			
			if (_autoRewind != value)
			{
				
				_autoRewind = value;
				
				if (stageVideoPlayer)
					stageVideoPlayer.autoRewind = value;
				
				dispatchEvent(new Event("autoRewindChange"));
				
			}
			
		}
		
		//--------------------------------------
		//  isPlaying
		//--------------------------------------
		
		[Bindable(event="playingStateEntered")]
		[Bindable(event="stoppedStateEntered")]
		public function get isPlaying():Boolean
		{
			
			return stageVideoPlayer ? stageVideoPlayer.isPlaying : false;
			
		}
		
		//--------------------------------------
		//  isPaused
		//--------------------------------------
		
		[Bindable(event="pausedStateEntered")]
		[Bindable(event="playingStateEntered")]
		public function get isPaused():Boolean
		{
			
			return stageVideoPlayer ? stageVideoPlayer.isPaused : false;
			
		}
		
		//--------------------------------------
		//  currentVideoState
		//--------------------------------------
		
		[Bindable(event="stateChange")]
		public function get currentVideoState():String
		{
			
			return stageVideoPlayer ? stageVideoPlayer.currentState : VideoPlayerState.DISCONNECTED;
			
		}
		
		//--------------------------------------
		//  time 
		//--------------------------------------
		
		// TODO: make this bindable read only property
		public function get time():Number
		{
			
			return stageVideoPlayer ? stageVideoPlayer.time : NaN;
			
		}
		
		//--------------------------------------
		//  destroyOnInvisible
		//--------------------------------------
		
		private var _destroyOnInvisible:Boolean = false;
		
		[Bindable(event="destroyOnInvisibleChange")]
		public function get destroyOnInvisible():Boolean
		{
			
			return stageVideoPlayer ? stageVideoPlayer.destroyOnInvisible : _destroyOnInvisible;
			
		}
		
		/**
		 * @private
		 */
		public function set destroyOnInvisible(value:Boolean):void
		{
			
			if (_destroyOnInvisible != value)
			{
				
				_destroyOnInvisible = value;
				
				if (stageVideoPlayer)
					stageVideoPlayer.destroyOnInvisible = value;
				
				dispatchEvent(new Event("backgroundColorChange"));
				
			}
			
		}
		
		//-------------------------------------
		// destroyOnDeactivate
		//-------------------------------------
		
		private var _destroyOnDeactivate:Boolean = false;
		
		[Bindable(event="destroyOnDeactivateChange")]
		/**
		 *  If set to true, the component will be destroyed when the stage is deactivated,
		 * and constructed again when it's activated
		 * 
		 */
		public function get destroyOnDeactivate():Boolean
		{
			
			return _destroyOnDeactivate;
			
		}
		
		public function set destroyOnDeactivate(value:Boolean):void
		{
			
			_destroyOnDeactivate = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function loadVideo():void
		{
			
			if (stageVideoPlayer)
				stageVideoPlayer.source = _source;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes instance of StageVideoPlayer to be used on this UIComponent.
		 * 
		 */
		override protected function initializeComponent():void
		{
			
			if (!stageVideoPlayer)
				stageVideoPlayer = new StageVideoPlayer();
			
			trace("constructing video player");
			stageVideoPlayer.backgroundColor = _backgroundColor;
			stageVideoPlayer.autoPlay = _autoPlay;
			stageVideoPlayer.autoRewind = _autoRewind;
			stageVideoPlayer.destroyOnInvisible = _destroyOnInvisible;
			stageVideoPlayer.visible = visible;
			
			stageVideoPlayer.addEventListener(StageVideoPlayerEvent.AVAILABLE, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(StageVideoPlayerEvent.UNAVAILABLE, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.STATE_CHANGE, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.PLAYING_STATE_ENTERED, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.PAUSED_STATE_ENTERED, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.STOPPED_STATE_ENTERED, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.COMPLETE, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.REWIND, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.SEEKED, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.LOADING_STATE_ENTERED, onVideoPlayerEvent, false, 0, true);
			//stageVideoPlayer.addEventListener(VideoPlayerEvent.BUFFERING_STATE_ENTERED, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.CLOSE, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerEvent.CONNECTION_ERROR, onVideoPlayerEvent, false, 0, true);
			stageVideoPlayer.addEventListener(VideoPlayerMetaDataEvent.METADATA_RECEIVED, onVideoPlayerMetaDataEvent, false, 0, true);
			
			addChild(stageVideoPlayer);
			
			loadVideo();
			
		}
		
		override protected function destroyComponent():void
		{
			
			if (stageVideoPlayer != null)
			{
				
				trace("destroying video player");
				stageVideoPlayer.stop();
				
				stageVideoPlayer.removeEventListener(StageVideoPlayerEvent.AVAILABLE, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(StageVideoPlayerEvent.UNAVAILABLE, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.STATE_CHANGE, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.PLAYING_STATE_ENTERED, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.PAUSED_STATE_ENTERED, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.STOPPED_STATE_ENTERED, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.COMPLETE, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.REWIND, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.SEEKED, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.LOADING_STATE_ENTERED, onVideoPlayerEvent, false);
				//stageVideoPlayer.removeEventListener(VideoPlayerEvent.BUFFERING_STATE_ENTERED, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.CLOSE, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerEvent.CONNECTION_ERROR, onVideoPlayerEvent, false);
				stageVideoPlayer.removeEventListener(VideoPlayerMetaDataEvent.METADATA_RECEIVED, onVideoPlayerMetaDataEvent, false);
				
				stageVideoPlayer.destroy();
				
				removeChild(stageVideoPlayer);
				
				//stageVideoPlayer = null;
				
			}
			
		}
		
		override protected function resizeAndFitComponent(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			if (stageVideoPlayer)
			{
				
				if (this.stage && enabled)
				{
					
					var newScale:Number = 1;
					var newWidth:Number = 0;
					var newHeight:Number = 0;
					
					if (FlexGlobals.topLevelApplication.hasOwnProperty("runtimeDPI") &&
						FlexGlobals.topLevelApplication.hasOwnProperty("applicationDPI"))
					{
						
						// check screen scaleFactor
						var scaleFactor:Number = FlexGlobals.topLevelApplication["runtimeDPI"] / FlexGlobals.topLevelApplication["applicationDPI"];
						
						// if scaleFactor != 1 then we must be running in high (low?) res screen, like iOS retina
						// We need to compensate for it
						newScale = 1 / scaleFactor;
						
					}
					else
					{
						
						newScale = 1;
						
					}
					
					if (stageVideoPlayer.scaleX != newScale)
					{
						
						stageVideoPlayer.scaleX = newScale;
						stageVideoPlayer.scaleY = newScale;
						
					}
					
					var rect:Rectangle = getViewRect();
					
					if (stageVideoPlayer.width != rect.width)
						stageVideoPlayer.width = rect.width;
					
					if (stageVideoPlayer.height != rect.height)
						stageVideoPlayer.height = rect.height;
					
					if (stageVideoPlayer.videoVisible != visible)
						stageVideoPlayer.videoVisible = visible;
					
				}
				else
				{
					
					if (stageVideoPlayer.scaleX != 1)
					{
						
						stageVideoPlayer.scaleX = 1;
						stageVideoPlayer.scaleY = 1;
						
					}
					
					if (stageVideoPlayer.width != 0)
						stageVideoPlayer.width = 0;
					
					if (stageVideoPlayer.height != 0)
						stageVideoPlayer.height = 0;
					
				}
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns reference to StageVideoPlayer for this StageVideoPlayerUIComponent.
		 * @return 
		 * 
		 */
		public function getStageVideoPlayer():StageVideoPlayer
		{
			
			return stageVideoPlayer;
			
		}
		
		/**
		 * Starts playing video.
		 * 
		 */
		public function play():void
		{
			
			if (stageVideoPlayer)
			{
				
				stageVideoPlayer.play();
				stageVideoPlayer.videoVisible = true;
				
			}
			
			invalidateDisplayList();
			
		}
		
		/**
		 * Stop video play and completely shuts down StageVideo.
		 */
		public function stop():void
		{
			
			if (stageVideoPlayer)
				stageVideoPlayer.stop();
			
			invalidateDisplayList();
			
		}
		
		public function pause():void
		{
			if (stageVideoPlayer)
				stageVideoPlayer.pause();
			
			invalidateDisplayList();
			
		}
		
		public function resume():void
		{
			
			if (stageVideoPlayer)
			{
				
				stageVideoPlayer.resume();
				stageVideoPlayer.videoVisible = true;
				
			}
			
			invalidateDisplayList();
			
		}
		
		public function seek(offset:Number):void
		{
			
			if (stageVideoPlayer)
				stageVideoPlayer.seek(offset);
			
			invalidateDisplayList();
			
		}
		
		public function step(frames:int):void
		{
			
			if (stageVideoPlayer)
				stageVideoPlayer.step(frames);
			
			invalidateDisplayList();
			
		}
		
		public function togglePause():void
		{
			
			if (stageVideoPlayer)
				stageVideoPlayer.togglePause();
			
			invalidateDisplayList();
			
		}
		
		public function destroy():void
		{
			
			if (stageVideoPlayer)
				stageVideoPlayer.destroy();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onVideoPlayerEvent(event:VideoPlayerEvent):void
		{
			
			dispatchEvent(event); // pass same event
			
		}
		
		private function onVideoPlayerMetaDataEvent(event:VideoPlayerMetaDataEvent):void
		{
			
			dispatchEvent(event); // pass same event
			
		}
		
		private function onActivate(event:Event):void
		{
			
			//if(_destroyOnDeactivate)
			//initializeComponent();
			
		}
		
		private function onDeactivate(event:Event):void
		{
			
			//if(_destroyOnDeactivate)
			//destroyComponent();
			
		}
		
	}
	
}