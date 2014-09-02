/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.air.net
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 *  Dispatched after all the received data is decoded and placed in the data property of the URLLoader object.
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 *  Dispatched if a call to URLLoader.load() results in a fatal error that terminates the download.
	 *
	 *  @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 *  Dispatched if a call to URLLoader.load() attempts to load data from a server outside the security sandbox.
	 *
	 *  @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 *  Dispatched when the download operation commences following a call to the URLLoader.load() method.
	 *
	 *  @eventType flash.events.Event.OPEN
	 */
	[Event(name="open", type="flash.events.Event")]
	
	/**
	 *  Dispatched when data is received as the download operation progresses.
	 *
	 *  @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 *  Dispatched if a call to the load() method attempts to access data over HTTP, and Adobe AIR is able to detect and return the status code for the request.
	 *
	 *  @eventType flash.events.HTTPStatusEvent.HTTP_RESPONSE_STATUS
	 */
	[Event(name="httpResponseStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 *  Dispatched if a call to URLLoader.load() attempts to access data over HTTP.
	 *
	 *  @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
	 */
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 * Similar to URLLoader class, LocalStorageCache downloads data from a URL as text, binary
	 * data, or URL-encoded variables but at the same time stores in local folder under
	 * <code>File.cacheDirectory</code> or <code>File.applicationStorageDirectory</code>.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class LocalStorageCache extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		public static var deviceCacheFolder:String = "";
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Stores specified byteArray data to destination.
		 * 
		 * @param byteArray
		 * @param destination
		 * @return 
		 * 
		 */
		public static function storeToLocal(byteArray:ByteArray, destination:File):File
		{
			
			var fs:FileStream = new FileStream();
			fs.open(destination, FileMode.WRITE);
			fs.writeBytes(byteArray);
			fs.close();
			
			return destination;
			
		}
		
		/**
		 * Copy contents of source to local storage.
		 * @param source
		 * @param targetFileName
		 * @param useCacheDirectory If true (default), file is copied under <code>File.cacheDirectory</code>.
		 * If false, <code>File.applicationStorageDirectory</code> is used.
		 * @return 
		 * 
		 */
		public static function copyToLocal(source:File, targetFileName:String, useCacheDirectory:Boolean = true):File
		{
			
			var destination:File = getLocalFile(targetFileName, useCacheDirectory);
			source.copyTo(destination, true);
			
			return destination;
			
		}
		
		/**
		 * Get reference to local file in device cache folder for this app (File.cacheDirectory).
		 * 
		 * @param targetFileName
		 * @param useCacheDirectory If true (default), file under <code>File.cacheDirectory</code> is returned.
		 * If false, file under <code>File.applicationStorageDirectory</code> is chosen.
		 * @return 
		 * 
		 */
		public static function getLocalFile(targetFileName:String, useCacheDirectory:Boolean = true):File
		{
			
			var path:String = deviceCacheFolder + targetFileName;
			if (useCacheDirectory)
				return File.cacheDirectory.resolvePath(path);
			else
				return File.applicationStorageDirectory.resolvePath(path);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function LocalStorageCache(remoteDataRequest:URLRequest = null, targetFileName:String = null)
		{
			
			super();
			
			if (remoteDataRequest || targetFileName)
			{
				
				if (remoteDataRequest && targetFileName)
					load(remoteDataRequest, targetFileName);
				else
					throw new Error("You must specify both remoteDataRequest and targetFileName in order to load the file.");
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private variables
		//
		//--------------------------------------------------------------------------
		
		private var loadInProgress:Boolean = false;
		private var request:URLRequest;
		private var target:String;
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var loader:URLLoader;
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The data received from the load operation.
		 */
		public var data:*;
		
		/**
		 * The data received from the load operation, cached in local folder.
		 */
		public var cachedData:File;
		
		/**
		 * Controls whether the downloaded data is received as text (<code>URLLoaderDataFormat.TEXT</code>),
		 * raw binary data (<code>URLLoaderDataFormat.BINARY</code>), or URL-encoded variables (<code>URLLoaderDataFormat.VARIABLES</code>).
		 */
		public var dataFormat:String = URLLoaderDataFormat.TEXT;
		
		/**
		 * Indicates the number of bytes that have been loaded thus far during the load operation.
		 * 
		 * @default 0
		 */
		public function get bytesLoaded():uint
		{
			
			if (loader)
				return loader.bytesLoaded;
			else
				return 0;
			
		}
		
		/**
		 * Indicates the total number of bytes in the downloaded data.
		 * 
		 * @default 0
		 */
		public function get bytesTotal():uint
		{
			
			if (loader)
				return loader.bytesTotal;
			else
				return 0;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function clearLoaderEvents():void
		{
			
			if (loader)
			{
				
				loadInProgress = false;
				
				loader.removeEventListener(Event.COMPLETE, onDataLoadComplete, false);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onDataLoadIOError, false);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDataLoadSecurityError, false);
				loader.removeEventListener(Event.OPEN, dispatchEvent, false);
				loader.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent, false);
				loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, dispatchEvent, false);
				loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent, false);
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Closes the load operation in progress. Any load operation in progress is immediately terminated. If no URL is
		 * currently being streamed, an invalid stream error is thrown.
		 * 
		 */
		public function close():void
		{
			
			if (loader)
				loader.close();
			
		}
		
		private var cacheOrStorage:Dictionary = new Dictionary(true);
		
		/**
		 * Sends and loads data from the specified URL, and at the same time stores data in specified local folder
		 * under <code>File.cacheDirectory</code>.
		 * @param request
		 * @param targetFileName File name to be saved as.
		 * @param useCacheDirectory If true (default), file is copied under <code>File.cacheDirectory</code>.
		 * If false, <code>File.applicationStorageDirectory</code> is used.
		 * 
		 */
		public function load(request:URLRequest, targetFileName:String, useCacheDirectory:Boolean = true):void
		{
			
			if (!loadInProgress)
			{
				
				loadInProgress = true;
				
				loader = new URLLoader();
				cacheOrStorage[loader] = useCacheDirectory;
				loader.dataFormat = dataFormat;
				
				// reason why I am not extending URLLoader class...I wanted dto make sure these events are caught first before any other
				loader.addEventListener(Event.COMPLETE, onDataLoadComplete, false, int.MAX_VALUE, true);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onDataLoadIOError, false, int.MAX_VALUE, true);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDataLoadSecurityError, false, int.MAX_VALUE, true);
				loader.addEventListener(Event.OPEN, dispatchEvent, false, int.MAX_VALUE, true);
				loader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent, false, int.MAX_VALUE, true);
				loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, dispatchEvent, false, int.MAX_VALUE, true);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent, false, int.MAX_VALUE, true);
				
				this.request = request;
				this.target = targetFileName;
				loader.load(request);
				
			}
			else
			{
				
				// load already in progress
				throw new Error("Load is already in progress, wait until it is done");
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onDataLoadComplete(event:Event):void
		{
			
			clearLoaderEvents();
			
			data = loader.data;
			var useCacheDirectory:Boolean = cacheOrStorage[loader] as Boolean;
			delete cacheOrStorage[loader];
			var targetFile:File = getLocalFile(target, useCacheDirectory);
			
			if (loader.dataFormat == URLLoaderDataFormat.BINARY)
			{
				
				// write binary as ByteArray
				cachedData = storeToLocal(data as ByteArray, targetFile);
				
			}
			else
			{
				
				// store as string
				var writeData:ByteArray = new ByteArray();
				writeData.writeUTF(String(data));
				cachedData = storeToLocal(writeData, targetFile);
				
			}
			
			trace("Cached data:");
			trace("<-- " + request.url);
			trace("--> " + targetFile.url);
			
			dispatchEvent(event);
			
		}
		
		private function onDataLoadIOError(event:IOErrorEvent):void
		{
			
			clearLoaderEvents();
			
			dispatchEvent(event);
			
		}
		
		private function onDataLoadSecurityError(event:SecurityErrorEvent):void
		{
			
			clearLoaderEvents();
			
			dispatchEvent(event);
			
		}
		
	}
	
}