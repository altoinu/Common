/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents.video
{
	
	import com.altoinu.flash.customcomponents.events.StageVideoPlayerEvent;
	import com.altoinu.flash.datamodels.Vector3DSpace;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	
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
	 * Sprite object wrapper to help set up StageVideo. If StageVideo is not available, it will fall back to
	 * normal flash.media.Video.
	 * 
	 * <p>Still somewhat in works. Currently it only does http streamed video, and since StageVideoAnchorBase
	 * only uses <code>stage.stageVideos[0]</code> only one instance of StageVideoPlayer can be used. TODO</p>
	 * 
	 * <p>Remember to enable renderMode=direct in order for StageVideo to work.</p>
	 * 
	 * <p>Note: make sure to have no DisplayObject on top of StageVideoPlayer area (x, y, width, height)
	 * since StageVideo sits on a layer behind everything. Don't forget about other StageVideo limitations, too.</p>
	 * 
	 * <p>Also, make sure you use videos that are h.264 encoded to get hardware acceleartion to kick in (FAST).
	 * Normal .flvs can still be played but they will be software rendered.</p>
	 * 
	 * <p>I have only tested this with stage.align = StageAlign.TOP_LEFT and StageScaleMode.NO_SCALE so far.
	 * Video may get weird scale/position with other modes for now</p>
	 * 
	 * <p>TODO: currently normal video player fallback (renderMode=auto cpu) does not work on iOS...</p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 11.1
	 * @playerversion AIR 3.5
	 * @productversion Flex 4.6
	 */	
	public class StageVideoPlayer extends VideoPlayer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StageVideoPlayer()
		{
			
			super();
			
			/*
			// Try to initialize immediately
			var initialized:Boolean = initializeStageVideo();
			
			// If initialize not success, then wait for necessary events
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStagePrepareStageVideo, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			if (stage)
				waitForStageVideo(); // wait for StageVideo becomes available on stage
			*/
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var addedToStageEventListening:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  stageVideo
		//--------------------------------------
		
		private var _stageVideo:StageVideo;
		
		public function get stageVideo():StageVideo
		{
			
			return _stageVideo;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function resizeAndFitComponent():void
		{
			
			if (_stageVideo)
			{
				
				// Set _stageVideo.viewPort to the same coordinate and size of this component
				if (stream && videoVisible && visible && isFinite(_stageVideo.videoWidth) && (_stageVideo.videoWidth != 0) && isFinite(_stageVideo.videoHeight) && (_stageVideo.videoHeight != 0))
					_stageVideo.viewPort = computeVideoRect(_stageVideo.videoWidth, _stageVideo.videoHeight);
				else
					_stageVideo.viewPort = new Rectangle(0, 0, 0, 0);
				
				//trace(stream, videoVisible, visible, _stageVideo.videoWidth, _stageVideo.videoHeight, videoMetaData);
				//trace(_stageVideo.viewPort);
				
			}
			else
			{
				
				super.resizeAndFitComponent();
				
			}
			
		}
		
		override protected function drawBackground():void
		{
			
			if (isFinite(width) && isFinite(height))
			{
				
				if (!_stageVideo || !videoVisible || !isPlaying || !visible)
				{
					
					super.drawBackground();
					
				}
				else
				{
					
					// Since StageVideo displays behind everything in Flash Player, we are only drawing
					// frame around the video and leaving middle blank so StageVideo can be seen through
					
					var g:Graphics = backgroundLayer.graphics;
					g.clear();
					
					g.lineStyle(0);
					g.beginFill(backgroundColor);
					
					var globalCoordinates:Point;
					if (parent)
						globalCoordinates = parent.localToGlobal(new Point(x, y));
					else
						globalCoordinates = new Point(x, y);
					
					var container:Rectangle = new Rectangle(globalCoordinates.x, globalCoordinates.y, width, height);
					var videoRect:Rectangle = _stageVideo.viewPort;
					
					g.drawRect(
						0,
						0,
						videoRect.x - container.x,
						videoRect.y - container.y); // tl
					
					g.drawRect(
						videoRect.x - container.x,
						0,
						videoRect.width,
						videoRect.y - container.y); // tc
					
					g.drawRect(
						(videoRect.x - container.x) + videoRect.width,
						0,
						container.width - ((videoRect.x - container.x) + videoRect.width),
						videoRect.y - container.y); // tr
					
					g.drawRect(
						0,
						videoRect.y - container.y,
						videoRect.x - container.x,
						videoRect.height); // ml
					
					g.drawRect(
						(videoRect.x - container.x) + videoRect.width,
						videoRect.y - container.y,
						container.width - ((videoRect.x - container.x) + videoRect.width),
						videoRect.height); // mr
					
					g.drawRect(
						0,
						(videoRect.y - container.y) + videoRect.height,
						videoRect.x - container.x,
						container.height - ((videoRect.y - container.y) + videoRect.height)); // bl
					
					g.drawRect(
						videoRect.x - container.x,
						(videoRect.y - container.y) + videoRect.height,
						videoRect.width,
						container.height - ((videoRect.y - container.y) + videoRect.height)); // bc
					
					g.drawRect(
						(videoRect.x - container.x) + videoRect.width,
						(videoRect.y - container.y) + videoRect.height,
						container.width - ((videoRect.x - container.x) + videoRect.width),
						container.height - ((videoRect.y - container.y) + videoRect.height)); // br
					
					g.endFill();
					
					// Add to back
					addChildAt(backgroundLayer, 0);
					
				}
				
			}
			else
			{
				
				backgroundLayer.graphics.clear();
				
				// Add to back
				addChildAt(backgroundLayer, 0);
				
			}
			
		}
		
		/**
		 * @inherit
		 */
		override protected function attachNetStreamToVideo(stopStream:Boolean = true):void
		{
			
			if (_stageVideo)
			{
				
				// attach NetStream to StageVideo so video can be displayed
				trace("Enabling StageVideo");
				
				super.removeNetStreamFromVideo(stopStream);
				
				_stageVideo.attachNetStream(stream);
				_streamAttachedToVideo = true;
				
			}
			else
			{
				
				// Try to initialize stage video while normal video playing
				var initialized:Boolean = initializeStageVideo();
				
				if (initialized)
				{
					
					// try again
					attachNetStreamToVideo(stopStream);
					
				}
				else
				{
					
					trace("Temporarily using normal Video");
					
					// Use normal video for now
					super.attachNetStreamToVideo(stopStream);
					
					// If initialize not success, then wait for necessary events
					if (stage)
					{
						
						// wait for StageVideo becomes available on stage
						waitForStageVideo();
						
					}
					else if (!addedToStageEventListening)
					{
						
						// wait for stage to become available
						addedToStageEventListening = true;
						this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStagePrepareStageVideo, false, 0, true);
						
					}
					
				}
				
			}
			
		}
		
		/**
		 * @inherit
		 */
		override protected function removeNetStreamFromVideo(stopStream:Boolean = true):void
		{
			
			super.removeNetStreamFromVideo(stopStream);
			
			if (_stageVideo)
				_stageVideo.attachNetStream(null);
			
		}
		
		/**
		 * Returns Rectangle to define global coordinate and width/height of the video.
		 * @return 
		 * 
		 */
		override protected function getViewRect():Rectangle
		{
			
			if (_stageVideo)
			{
				
				/*
				var topLeft:Point = localToGlobal(new Point(0, 0));
				var bottomRight:Point = localToGlobal(
				new Point(
				isFinite(this.width) ? this.width : _stageVideo ? _stageVideo.videoWidth : 0,
				isFinite(this.height) ? this.height : _stageVideo ? _stageVideo.videoHeight : 0
				)
				);
				
				return new Rectangle(topLeft.x, topLeft.y, bottomRight.x - topLeft.x, bottomRight.y - topLeft.y);
				*/
				
				// top left and bottom right coordinates
				var topLeft:Point = new Point(0, 0);
				var bottomRight:Point =  new Point(
					isFinite(this.width) ? this.width : _stageVideo ? _stageVideo.videoWidth : 0,
					isFinite(this.height) ? this.height : _stageVideo ? _stageVideo.videoHeight : 0
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
			else
			{
				
				return super.getViewRect();
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private var onStageVideoStateHandlerAdded:Boolean = false;
		
		private function waitForStageVideo():void
		{
			
			if (!onStageVideoStateHandlerAdded)
			{
				
				// wait for StageVideo becomes available on stage
				this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
				stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState, false, 0, true);
				onStageVideoStateHandlerAdded = true;
				
			}
			
		}
		
		private function waitForStageVideoRemove():void
		{
			
			if (onStageVideoStateHandlerAdded)
			{
				
				// wait for StageVideo becomes available on stage
				this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false);
				stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState, false);
				onStageVideoStateHandlerAdded = false;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initialze StageVideo object.
		 * 
		 * @return true if StageVideo object is initialized. If false, the we first need to wait for
		 * <code>StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY</code> event.
		 * 
		 */
		protected function initializeStageVideo():Boolean
		{
			
			if (_stageVideo)
			{
				
				// Already initialized, do nothing
				return true;
				
			}
			else if (stage && stage.stageVideos && (stage.stageVideos.length > 0))
			{
				
				// stageVideo not defined yet so do normal initialization now
				
				// remember reference to this stage video
				_stageVideo = stage.stageVideos[0]; // TODO: maybe in future we need to not always pick stageVideo[0]
				_stageVideo.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoRenderStateChange, false);
				_stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoRenderStateChange, false, 0, true);
				
				/*
				// reattach stream to video
				if (stream)
					attachNetStreamToVideo();
				*/
				
				/*
				if (_stageVideo)
				{
					
					// stageVideo just got initialized
					
					if (autoPlay && source)
						play(); // Start playing if autoPlay and source already specified
					
				}
				*/
				
				return true;
				
			}
			else
			{
				
				// StageVideo not ready yet
				return false;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------		
		
		override public function destroy():void
		{
			
			super.destroy();
			
			if (_stageVideo)
			{
				
				_stageVideo.viewPort = new Rectangle(0,0,0,0);
				_stageVideo.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoRenderStateChange, false);
				_stageVideo = null;
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers
		//
		//--------------------------------------------------------------------------
		
		override protected function netStatusHandler(event:NetStatusEvent):void
		{
			
			/*
			switch (event.info.code)
			{
			
			case "NetConnection.Connect.Closed": // connection.close() happened
			
			if (_stageVideo)
			_stageVideo.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoRenderStateChange, false);
			
			break;
			
			case "NetStream.Play.Start": // Video starts playing
			
			if (_stageVideo)
			{
			
			_stageVideo.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoRenderStateChange, false);
			_stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoRenderStateChange, false, 0, true);
			
			}
			
			break;
			
			default:
			
			break;
			
			}
			*/
			
			super.netStatusHandler(event);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onAddedToStagePrepareStageVideo(event:Event):void
		{
			
			if (addedToStageEventListening)
			{
				
				addedToStageEventListening = false;
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStagePrepareStageVideo, false);
				
			}
			
			// wait for StageVideo becomes available on stage
			waitForStageVideo();
			
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			
			waitForStageVideoRemove();
			
		}
		
		private function onStageVideoState(event:StageVideoAvailabilityEvent):void
		{
			
			// At this point, StageVideo can be used/not available
			
			waitForStageVideoRemove();
			
			trace("onStageVideoState: " + event.availability);
			if (event.availability == StageVideoAvailability.AVAILABLE)
			{
				
				// initialize and attach netstream
				initializeStageVideo();
				attachNetStreamToVideo(false);
				
				dispatchEvent(new StageVideoPlayerEvent(StageVideoPlayerEvent.AVAILABLE, false, false, VideoPlayerState.DISCONNECTED));
				
				// and play if necessary
				if (_isPlaying)
					playNowIfItCan(true);
				
			}
			else
			{
				
				// no StageVideo
				dispatchEvent(new StageVideoPlayerEvent(StageVideoPlayerEvent.UNAVAILABLE, false, false, VideoPlayerState.DISCONNECTED));
				
			}
			
		}
		
		private function stageVideoRenderStateChange(event:StageVideoEvent):void
		{
			
			trace("stageVideoRenderStateChange (rendering at): " + event.status);       
			invalidateDisplay();
			
		}
		
	}
	
}