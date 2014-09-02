/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.video
{
	
	import com.altoinu.flash.customcomponents.events.VideoPlayerEvent;
	import com.altoinu.flash.customcomponents.events.VideoPlayerMetaDataEvent;
	import com.altoinu.flash.datamodels.Vector3DSpace;
	import com.altoinu.flash.utils.MathUtils;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
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
	* Video connection buffering.
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
	 * Sprite object wrapper to help set up Video.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 11.1
	 * @playerversion AIR 3.5
	 * @productversion Flex 4.6
	 */
	public class VideoPlayer extends VideoPlayerAnchorBase
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function VideoPlayer()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var imStopped:Boolean = true;
		private var isWatchingPlayheadTime:Boolean = false;
		private var iWantToPlayImmediately:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var videoMetaData:Object;
		
		//--------------------------------------
		//  connection 
		//--------------------------------------
		
		private var _connection:NetConnection;
		
		/**
		 * "connection" to remote content
		 */
		protected function get connection():NetConnection
		{
			
			return _connection;
			
		}
		
		//--------------------------------------
		//  connection 
		//--------------------------------------
		
		private var _stream:NetStream;
		
		/**
		 * "stream" from connection to Flash Player
		 */
		protected function get stream():NetStream
		{
			
			return _stream;
			
		}
		
		//--------------------------------------
		//  streamAttachedToVideo 
		//--------------------------------------
		
		protected var _streamAttachedToVideo:Boolean = false;
		
		/*
		protected function get streamAttachedToVideo():Boolean
		{
		
		return _streamAttachedToVideo;
		
		}
		*/
		
		//--------------------------------------------------------------------------
		//
		//  Overridden public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  soundTransform 
		//--------------------------------------
		
		private var _soundTransform:SoundTransform;
		
		override public function get soundTransform():SoundTransform
		{
			
			if (stream)
				return stream.soundTransform;
			else
				return _soundTransform;
			
		}
		
		override public function set soundTransform(value:SoundTransform):void
		{
			
			_soundTransform = value;
			
			if (stream)
				stream.soundTransform = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  visible
		//--------------------------------------
		
		override public function set visible(value:Boolean):void
		{
			
			super.visible = value;
			
			invalidateDisplay();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var destroyOnInvisible:Boolean = false;
		
		//--------------------------------------
		//  video
		//--------------------------------------
		
		private var _video:Video = new Video();
		
		/**
		 * Video component that will do actual displaying.
		 */
		public function get video():Video
		{
			
			return _video;
			
		}
		
		//--------------------------------------
		//  source
		//--------------------------------------
		
		private var _source:String;
		
		/**
		 * URL of video to be played.
		 */
		public function get source():String
		{
			
			return _source;
			
		}
		
		public function set source(value:String):void
		{
			
			if (_source != value)
			{
				
				_source = value;
				
				// Clean up first
				shutDown();
				
				playNowIfItCan();
				
			}
			
		}
		
		//--------------------------------------
		//  autoPlay
		//--------------------------------------
		
		private var _autoPlay:Boolean = true;
		
		/**
		 * 
		 */
		public function get autoPlay():Boolean
		{
			
			return _autoPlay;
			
		}
		
		/**
		 * @private
		 */
		public function set autoPlay(value:Boolean):void
		{
			
			_autoPlay = value;
			
		}
		
		//--------------------------------------
		//  autoRewind
		//--------------------------------------
		
		private var _autoRewind:Boolean = false;
		
		public function get autoRewind():Boolean
		{
			
			return _autoRewind;
			
		}
		
		/**
		 * @private
		 */
		public function set autoRewind(value:Boolean):void
		{
			
			_autoRewind = value;
			
		}
		
		//--------------------------------------
		//  videoVisible
		//--------------------------------------
		
		private var _videoVisible:Boolean = true;
		
		/**
		 * Is video visible? If not then Video area will be covered by <code>backgroundColor</code>.
		 */
		public function get videoVisible():Boolean
		{
			
			return _videoVisible;
			
		}
		
		/**
		 * @private
		 */
		public function set videoVisible(value:Boolean):void
		{
			
			if (_videoVisible != value)
			{
				
				_videoVisible = value;
				
				invalidateDisplay();
				
			}
			
		}
		
		//--------------------------------------
		//  isPlaying
		//--------------------------------------
		
		private var __isPlaying:Boolean = false;
		
		protected function get _isPlaying():Boolean
		{
			
			return __isPlaying;
			
		}
		
		protected function set _isPlaying(value:Boolean):void
		{
			
			if (__isPlaying != value)
			{
				
				__isPlaying = value;
				
				if (value)
				{
					
					setPlayerState(VideoPlayerState.PLAYING);
					watchTime();
					imStopped = false;
					
				}
				else
				{
					
					setPlayerState(VideoPlayerState.STOPPED);
					imStopped = true;
					
				}
				
			}
			
		}
		
		public function get isPlaying():Boolean
		{
			
			return _isPlaying;
			
		}
		
		//--------------------------------------
		//  isPaused
		//--------------------------------------
		
		private var __isPaused:Boolean = false;
		
		protected function get _isPaused():Boolean
		{
			
			return __isPaused;
			
		}
		
		protected function set _isPaused(value:Boolean):void
		{
			
			if (__isPaused != value)
			{
				
				__isPaused = value;
				
				if (value)
				{
					
					setPlayerState(VideoPlayerState.PAUSED);
					watchTimeCancel();
					
				}
				else
				{
					
					setPlayerState(VideoPlayerState.PLAYING);
					watchTime();
					
				}
				
			}
			
		}
		
		public function get isPaused():Boolean
		{
			
			return _isPaused;
			
		}
		
		//--------------------------------------
		//  currentState
		//--------------------------------------
		
		private var __currentState:String = VideoPlayerState.DISCONNECTED;
		
		private function get _currentState():String
		{
			
			return __currentState;
			
		}
		
		private function set _currentState(value:String):void
		{
			
			if (__currentState != value)
			{
				
				__currentState = value;
				
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STATE_CHANGE, false, false, value));
				
			}
			
		}
		
		public function get currentState():String
		{
			
			return _currentState;
			
		}
		
		//--------------------------------------
		//  backBufferLength
		//--------------------------------------
		
		public function get backBufferLength():Number
		{
			
			return stream ? stream.backBufferLength : 0;
			
		}
		
		//--------------------------------------
		//  backBufferTime
		//--------------------------------------
		
		private var _backBufferTime:Number = NaN;
		
		public function get backBufferTime():Number
		{
			
			if (stream)
				return stream.backBufferTime;
			else
				return _backBufferTime;
			
		}
		
		/**
		 * @private
		 */
		public function set backBufferTime(value:Number):void
		{
			
			_backBufferTime = value;
			
			if (stream)
				stream.backBufferTime = value;
			
		}
		
		//--------------------------------------
		//  bufferLength
		//--------------------------------------
		
		public function get bufferLength():Number
		{
			
			return stream ? stream.bufferLength : 0;
			
		}
		
		//--------------------------------------
		//  bufferTime
		//--------------------------------------
		
		private var _bufferTime:Number = 0.1;
		
		public function get bufferTime():Number
		{
			
			if (stream)
				return stream.bufferTime;
			else
				return _bufferTime;
			
		}
		
		/**
		 * @private
		 */
		public function set bufferTime(value:Number):void
		{
			
			_bufferTime = value;
			
			if (stream)
				stream.bufferTime = value;
			
		}
		
		//--------------------------------------
		//  bufferTimeMax
		//--------------------------------------
		
		private var _bufferTimeMax:Number = 0;
		
		public function get bufferTimeMax():Number
		{
			
			if (stream)
				return stream.bufferTimeMax;
			else
				return _bufferTimeMax;
			
		}
		
		/**
		 * @private
		 */
		public function set bufferTimeMax(value:Number):void
		{
			
			_bufferTimeMax = value;
			
			if (stream)
				stream.bufferTimeMax = value;
			
		}
		
		//--------------------------------------
		//  bytesLoaded
		//--------------------------------------
		
		public function get bytesLoaded():uint
		{
			
			return stream ? stream.bytesLoaded : 0;
			
		}
		
		//--------------------------------------
		//  bytesLoaded
		//--------------------------------------
		
		public function get bytesTotal():uint
		{
			
			return stream ? stream.bytesTotal : 0;
			
		}
		
		//--------------------------------------
		//  maxPauseBufferTime 
		//--------------------------------------
		
		private var _maxPauseBufferTime:Number = NaN;
		
		public function get maxPauseBufferTime():Number
		{
			
			if (stream)
				return stream.maxPauseBufferTime;
			else
				return _maxPauseBufferTime;
			
		}
		
		/**
		 * @private
		 */
		public function set maxPauseBufferTime(value:Number):void
		{
			
			_maxPauseBufferTime = value;
			
			if (stream)
				stream.maxPauseBufferTime = value;
			
		}
		
		//--------------------------------------
		//  time 
		//--------------------------------------
		
		public function get time():Number
		{
			
			return stream ? stream.time : 0;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function connectStream():void
		{
			
			// Create NetStream object that will stream data from NetConnection
			_stream = new NetStream(connection);
			stream.client = {
				onCuePoint: onCuePoint,
				onImageData: onImageData,
				onMetaData: onMetaData,
				onPlayStatus: onPlayStatus,
				onSeekPoint: onSeekPoint,
				onTextData: onTextData,
				onXMPData: onXMPData
			};
			
			if (isFinite(_backBufferTime))
				stream.backBufferTime = _backBufferTime;
			
			stream.bufferTime = _bufferTime;
			stream.bufferTimeMax = _bufferTimeMax;
			
			if (isFinite(_maxPauseBufferTime))
				stream.maxPauseBufferTime = _maxPauseBufferTime;
			
			if (_soundTransform)
				stream.soundTransform = _soundTransform;
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
			
			// attach NetStream to video so it can be displayed
			attachNetStreamToVideo();
			
			playNowIfItCan(iWantToPlayImmediately);
			
		}
		
		private function shutDown():void
		{
			
			if (_video)
				_video.clear();
			
			if (stream)
			{
				
				removeNetStreamFromVideo();
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false);
				
				_stream = null;
				
			}
			
			if (connection)
			{
				
				connection.close();
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false);
				connection.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler, false);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false);
				
				_connection = null;
				
			}
			
			watchTimeCancel();
			
		}
		
		private function setPlayerState(newState:String):void
		{
			
			_currentState = newState;
			
			switch (newState)
			{
				
				case VideoPlayerState.LOADING:
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.LOADING_STATE_ENTERED, false, false, newState));
					break;
				
				/*
				case VideoPlayerState.BUFFERING:
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BUFFERING_STATE_ENTERED, false, false, newState));
				break;
				*/
				
				case VideoPlayerState.PLAYING:
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYING_STATE_ENTERED, false, false, newState));
					break;
				
				case VideoPlayerState.PAUSED:
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSED_STATE_ENTERED, false, false, newState));
					break;
				
				case VideoPlayerState.STOPPED:
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STOPPED_STATE_ENTERED, false, false, newState));
					break;
				
				case VideoPlayerState.DISCONNECTED:
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CLOSE, false, false, newState));
					break;
				
				case VideoPlayerState.REWINDING:
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.REWIND, false, false, newState));
					break;
				
				case VideoPlayerState.SEEKING:
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SEEKED, false, false, newState));
					break;
				
				case VideoPlayerState.CONNECTION_ERROR:
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CONNECTION_ERROR, false, false, newState));
					break;
				
			}
			
		}
		
		private function watchTime():void
		{
			
			if (!isWatchingPlayheadTime)
			{
				
				// Yes, I know, dirty
				isWatchingPlayheadTime = true;
				this.addEventListener(Event.ENTER_FRAME, watchPlayheadTime, false, 0, true);
				
			}
			
		}
		
		private function watchTimeCancel():void
		{
			
			if (isWatchingPlayheadTime)
			{
				
				isWatchingPlayheadTime = false;
				this.removeEventListener(Event.ENTER_FRAME, watchPlayheadTime, false);
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function resizeAndFitComponent():void
		{
			
			if (destroyOnInvisible)
			{
				
				if (visible)
				{
					
					backgroundLayer.visible = true;
					_video.visible = true;
					
				}
				else if (_video)
				{
					
					destroy();
					return;
					
				}
				
			}
			
			if (videoVisible && isFinite(_video.videoWidth) && (_video.videoWidth != 0) && isFinite(_video.videoHeight) && (_video.videoHeight != 0))
			{
				
				var videoRect:Rectangle = computeVideoRect(_video.videoWidth, _video.videoHeight);
				var videoLocalPoint:Point = globalToLocal(new Point(videoRect.x, videoRect.y));
				_video.x = (isFinite(this.width) ? this.width : _video ? _video.videoWidth : 0) / 2 - videoRect.width / 2;
				_video.y = (isFinite(this.height) ? this.height : _video ? _video.videoHeight : 0) / 2 - videoRect.height / 2;
				_video.width = videoRect.width;
				_video.height = videoRect.height;
				
				/*
				trace(videoRect);
				trace(videoLocalPoint);
				trace(_video.x, _video.y);
				*/
				
			}
			else
			{
				
				_video.x = 0;
				_video.y = 0;
				_video.width = 0;
				_video.height = 0;
				
			}
			
			//trace(videoVisible, visible, _video.videoWidth, _video.videoHeight, _video.x, _video.y, _video.width, _video.height);
			//trace(videoMetaData);
			addChild(_video);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function createConnection():void
		{
			
			shutDown(); // make sure previous instance of NetConnection and NetStream are gone
			
			// Create NetConnnection, which will be "connection" to video
			_connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
			connection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler, false, 0, true);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			connection.connect(null); // initiates connection
			
		}
		
		/**
		 * Attaches netstream to video.
		 * 
		 * @param stopStream
		 * 
		 * @return true if success, false if it cannot be attached for some reason.
		 * 
		 */
		protected function attachNetStreamToVideo(stopStream:Boolean = true):void
		{
			
			if (stream && stopStream)
			{
				
				stream.close();
				stream.dispose();
				
			}
			
			_video.attachNetStream(stream);
			_streamAttachedToVideo = true;
			
		}
		
		/**
		 * Removes netstream from video
		 * 
		 * @param stopStream
		 * 
		 */
		protected function removeNetStreamFromVideo(stopStream:Boolean = true):void
		{
			
			if (stream && stopStream)
			{
				
				stream.close();
				stream.dispose();
				
			}
			
			_video.attachNetStream(null);
			_streamAttachedToVideo = false;
			
		}
		
		/**
		 * Using VideoPlayer's current x/y/width/height, calculates global x y coordinates and width height
		 * dimensions that video object with specified videoWidth and videoHeight can fit exactly.
		 * 
		 * @param videoWidth
		 * @param videoHeight
		 * @return 
		 * 
		 */
		protected function computeVideoRect(videoWidth:uint, videoHeight:uint):Rectangle
		{
			
			// Calculates Rectangle that makes Video letterbox fit on center
			// TODO: top/bottom/left/right alignment or stretch fit implementation would be nice to have some day
			
			// container dimensions
			var viewRect:Rectangle = getViewRect();
			var containerWidth:Number = viewRect.width;
			var containerHeight:Number = viewRect.height;
			
			//trace("container: ", containerWidth, containerHeight);
			
			// This scale will allow videoWidth and videoHeight to fit in container dimensions
			var scaling:Number = MathUtils.getFitScale(
				new Rectangle(0, 0, videoWidth, videoHeight),
				new Rectangle(0, 0, containerWidth, containerHeight)
			);
			var videoRect:Rectangle = new Rectangle();
			videoRect.width = videoWidth * scaling;
			videoRect.height = videoHeight * scaling;
			
			var globalCoordinates:Point;
			if (parent)
				globalCoordinates = parent.localToGlobal(new Point(x, y));
			else
				globalCoordinates = new Point(x, y);
			
			videoRect.x = globalCoordinates.x + (containerWidth - (videoWidth * scaling)) / 2;
			videoRect.y = globalCoordinates.y + (containerHeight - (videoHeight * scaling)) / 2;
			
			//trace("videoRect: ", videoRect);
			return videoRect;
			
		}
		
		/**
		 * Returns Rectangle to define global coordinate and width/height of the video.
		 * @return 
		 * 
		 */
		protected function getViewRect():Rectangle
		{
			
			/*
			var topLeft:Point = localToGlobal(new Point(0, 0));
			var bottomRight:Point = localToGlobal(
			new Point(
			isFinite(this.width) ? this.width : _video ? _video.videoWidth : 0,
			isFinite(this.height) ? this.height : _video ? _video.videoHeight : 0
			)
			);
			
			return new Rectangle(topLeft.x, topLeft.y, bottomRight.x - topLeft.x, bottomRight.y - topLeft.y);
			*/
			
			// top left and bottom right coordinates
			var topLeft:Point = new Point(0, 0);
			var bottomRight:Point =  new Point(
				isFinite(this.width) ? this.width : _video ? _video.videoWidth : 0,
				isFinite(this.height) ? this.height : _video ? _video.videoHeight : 0
			);
			// vector from top left to bottom right
			var v:Vector3DSpace = new Vector3DSpace(bottomRight.x - topLeft.x, bottomRight.y - topLeft.y);
			
			// global top left and bottom right coordinates
			var topLeft_global:Point = localToGlobal(topLeft);
			var bottomRight_global:Point = localToGlobal(bottomRight);
			// vector from top left to bottom right in global coordinates
			var v_global:Vector3DSpace = new Vector3DSpace(bottomRight_global.x - topLeft_global.x, bottomRight_global.y - topLeft_global.y);
			
			// global mid point coordinates
			var mid_global:Point = new Point((bottomRight_global.x - topLeft_global.x) / 2, (bottomRight_global.y - topLeft_global.y) / 2);
			
			// Using vectors figure out to see if component is rotated on screen
			var angle:Number = Vector3DSpace.angleBetweenVectors(v, v_global);
			
			// Compensate for rotation
			v_global.rotateZ(-angle);
			
			var viewRect:Rectangle = new Rectangle(
				topLeft_global.x,
				topLeft_global.y,
				v_global.x,
				v_global.y
			);
			
			return viewRect;
			
		}
		
		protected function playNowIfItCan(forcePlay:Boolean = false):void
		{
			
			if (source)
			{
				
				if (!stream)
				{
					
					// If NetStream does not exist, it must be created first
					
					if (forcePlay)
						iWantToPlayImmediately = true; // remember that we wanted player to start playing if parameter indicated so
					
					createConnection();
					
				}
				else if (forcePlay || autoPlay)
				{
					
					// Start playing if forcePlay = true or if autoPlay
					stream.play(source);
					
					iWantToPlayImmediately = false;
					
				}
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Starts playing video.
		 * 
		 */
		public function play():void
		{
			
			if (_isPaused)
				resume(); // same as resume if paused
			else if (!_isPlaying)
				playNowIfItCan(true);
			
		}
		
		/**
		 * Stop video play and completely shuts down Video object.
		 */
		public function stop():void
		{
			
			if (_isPaused)
				resume();
			
			if (_isPlaying)
			{
				
				setPlayerState(VideoPlayerState.STOPPED);
				shutDown();
				
			}
			
			iWantToPlayImmediately = false;
			
		}
		
		public function pause():void
		{
			
			if (stream && _isPlaying && !_isPaused)
				stream.pause();
			
		}
		
		public function resume():void
		{
			
			if (stream && _isPaused)
				stream.resume();
			
		}
		
		public function seek(offset:Number):void
		{
			
			if (stream)
				stream.seek(offset);
			
		}
		
		public function step(frames:int):void
		{
			
			if (stream)
				stream.step(frames);
			
		}
		
		public function togglePause():void
		{
			
			if (stream)
				stream.togglePause();
			
		}
		
		public function destroy():void
		{
			
			backgroundLayer.visible = false;
			
			stop();
			shutDown();
			
			if (_video)
			{
				
				_video.width = 1;
				_video.height = 1;
				_video.x = -1;
				_video.y = -1;
				_video.visible = false;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		protected function netStatusHandler(event:NetStatusEvent):void
		{
			
			trace("* " + event.info.code);
			
			switch (event.info.code)
			{
				
				case "NetConnection.Connect.AppShutdown":
				case "NetConnection.Connect.IdleTimeout":
				case "NetConnection.Connect.InvalidApp":
				case "NetConnection.Connect.NetworkChange":
				case "NetConnection.Connect.Rejected":
				case "NetStream.Buffer.Empty":
				case "NetStream.Buffer.Flush":
				case "NetStream.Play.FileStructureInvalid":
				case "NetStream.Play.InsufficientBW": // client does not have sufficient bandwidth for normal play speed
				case "NetStream.Play.NoSupportedTrackFound": // no supported tracks (video, audio, data) detected
				case "NetStream.Play.PublishNotify":
				case "NetStream.Play.Reset":
				case "NetStream.Seek.Failed":
				case "NetStream.Seek.InvalidTime":
					break;
				
				case "NetStream.Buffer.Full":
					
					//setPlayerState(VideoPlayerState.BUFFERING);
					
					break;
				
				case "NetConnection.Connect.Closed": // connection.close() happened
					
					_isPlaying = false;
					invalidateDisplay();
					
					setPlayerState(VideoPlayerState.DISCONNECTED);
					
					break;
				
				case "NetConnection.Connect.Success": // initial connection success
					
					setPlayerState(VideoPlayerState.LOADING);
					
					connectStream();
					
					break;
				
				case "NetConnection.Connect.Failed":
					
					setPlayerState(VideoPlayerState.CONNECTION_ERROR);
					
					break;
				
				case "NetStream.Play.Start": // Video starts playing
					
					_isPlaying = true;
					invalidateDisplay();
					
					break;
				
				case "NetStream.Play.Stop": // Video stops playing when it reaches end
					
					_isPlaying = false;
					invalidateDisplay();
					
					break;
				
				case "NetStream.Play.Transition":
					
					invalidateDisplay();
					
					break;
				
				case "NetStream.Failed":
				case "NetStream.Play.Failed":
				case "NetStream.Play.StreamNotFound":
					
					setPlayerState(VideoPlayerState.CONNECTION_ERROR);
					
					break;
				
				case "NetStream.Pause.Notify":
					
					_isPaused = true;
					invalidateDisplay();
					
					break;
				
				case "NetStream.Unpause.Notify":
					
					_isPaused = false;
					invalidateDisplay();
					
					break;
				
				case "NetStream.Seek.Notify":
					
					setPlayerState(VideoPlayerState.SEEKING);
					
					break;
				
				case "NetStream.Seek.Complete":
					
					setPlayerState(VideoPlayerState.PLAYING);
					
					break;
				
				case "NetStream.Step.Notify":
					
					break;
				
			}
			
		}
		
		private function ioErrorEventHandler(event:IOErrorEvent):void
		{
			
			trace("IOErrorEvent: " + event);
			
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			
			trace("SecurityErrorEvent: " + event);
			
		}
		
		private function onVideoReachedEnd():void
		{
			
			watchTimeCancel();
			
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.COMPLETE, false, false, VideoPlayerState.STOPPED));
			
			if (autoRewind)
			{
				
				setPlayerState(VideoPlayerState.REWINDING);
				
				if (!autoPlay)
				{
					
					// just shut it down for now
					shutDown();
					
				}
				else
				{
					
					// Immediately restart
					seek(0);
					playNowIfItCan(true);
					
				}
				
			}
			
		}
		
		private function watchPlayheadTime(event:Event = null):void
		{
			
			if (videoMetaData && videoMetaData.hasOwnProperty("duration"))
			{
				
				var totalTime:Number = Math.floor(videoMetaData.duration * 10) / 10;
				/*
				var threshold:Number = totalTime * 0.25;
				if (threshold > 0.5)
				threshold = 0.5;
				*/
				
				//trace("watchPlayheadTime: " + imStopped, time, Math.floor(videoMetaData.duration * 10) / 10);
				if (imStopped && (time >= totalTime - 0.05))
				{
					
					// Video marked as stopped, and time has reached the end, complete
					onVideoReachedEnd();
					
				}
				
			}
			else if (videoMetaData)
			{
				
				// video meta data was received but no "duration"
				trace("ERROR - Video does not provide duration");
				watchTimeCancel();
				
			}
			
		}
		
		private function onCuePoint(info:Object):void
		{
			
			//trace("onCuePoint " + info);
			
		}
		
		private function onImageData(info:Object):void
		{
			
			//trace("onImageData " + info);
			
		}
		
		private function onMetaData(info:Object):void
		{
			
			trace("onMetaData " + info);
			
			// info.duration
			// info.height
			// info.width
			videoMetaData = info;
			invalidateDisplay();
			
			dispatchEvent(new VideoPlayerMetaDataEvent(VideoPlayerMetaDataEvent.METADATA_RECEIVED, false, false, info));
			
		}
		
		private function onPlayStatus(info:Object):void
		{
			
			//trace("onPlayStatus " + info);
			
			if (info)
			{
				
				if (info.hasOwnProperty("code"))
				{
					
					trace("- " + info.code);
					
					switch (info.code)
					{
						
						case "NetStream.Play.Complete":
							
							// This is not a good place because sometimes NetStream.Play.Complete never happens
							//dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.COMPLETE, false, false, VideoPlayerState.STOPPED));
							
							break;
						
					}
					
				}
				
			}
			
		}
		
		private function onSeekPoint(info:Object):void
		{
			
			//trace("onSeekPoint " + info);
			
		}
		
		private function onTextData(info:Object):void
		{
			
			//trace("onTextData " + info);
			
		}
		
		private function onXMPData(info:Object):void
		{
			
			//trace("onXMPData " + info);
			
		}
		
	}
	
}