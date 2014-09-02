/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.air.net
{
	
	import com.altoinu.flash.utils.EnterFrameManager;
	import com.altoinu.flash.utils.URLUtils;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 *  Dispatched when any child of the LoaderMax instance dispatches a PROGRESS event
	 *
	 *  @eventType com.greensock.events.LoaderEvent.CHILD_PROGRESS
	 */
	[Event(name="childProgress", type="com.greensock.events.LoaderEvent")]
	
	/**
	 *  Dispatched when data is received as the download operation progresses.
	 *
	 *  @eventType com.greensock.events.LoaderEvent.PROGRESS
	 */
	[Event(name="progress", type="com.greensock.events.LoaderEvent")]
	
	/**
	 *  Dispatched when any child of the LoaderMax instance completes. So if a LoaderMax contains
	 * 5 loaders, the CHILD_COMPLETE event will be dispatched 5 times during the course of the
	 * LoaderMax's load.
	 *
	 *  @eventType com.greensock.events.LoaderEvent.CHILD_COMPLETE
	 */
	[Event(name="childComplete", type="com.greensock.events.LoaderEvent")]
	
	/**
	 *  Dispatched when the loader completes.
	 *
	 *  @eventType com.greensock.events.LoaderEvent.COMPLETE
	 */
	[Event(name="complete", type="com.greensock.events.LoaderEvent")]
	
	/**
	 *  Dispatched when the loader experiences some type of error, like a SECURITY_ERROR or IO_ERROR.
	 *
	 *  @eventType com.greensock.events.LoaderEvent.ERROR
	 */
	[Event(name="error", type="com.greensock.events.LoaderEvent")]
	
	/**
	 * Similar to URLLoader class, LoadAndLocalCacheUtil downloads data from a URL binary data,
	 * but at the same time stores in local folder under <code>File.cacheDirectory</code>.
	 * 
	 * <p>Required: LoaderMax http://www.greensock.com/loadermax/</p>
	 * 
	 * <listing>
	 * // Example
	 * var loader:LoadAndStoreLocalCacheUtil = new LoadAndStoreLocalCacheUtil();
	 * loader.addEventListener(LoaderEvent.COMPLETE, onCacheLoadComplete);
	 * loader.load(assetFileURLs, "myFolder/path", "http://www.example.com/assets/path/");
	 * </listing>
	 * 
	 * @author kaoru
	 * 
	 */
	public class LoadAndStoreLocalCacheUtil extends EventDispatcher
	{
		
		private static const EM:EnterFrameManager = new EnterFrameManager();
		
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
		 * Copy contents of source to device local cache folder.
		 * @param source
		 * @param targetFileName
		 * @return 
		 * 
		 */
		public static function copyToLocal(source:File, fileName:String):File
		{
			
			var destination:File = getLocalFile(fileName);
			source.copyTo(destination, true);
			
			return destination;
			
		}
		
		/**
		 * Get reference to local file in device cache folder
		 * (<code>File.cacheDirectory</code>).
		 * 
		 * @param targetFileName
		 * @return 
		 * 
		 */
		public static function getLocalFile(fileName:String):File
		{
			
			return File.cacheDirectory.resolvePath(fileName);
			
		}
		
		/**
		 * Get reference to local file in device cache folder corresponding to specified
		 * URL and localPath(optional).
		 * @param url
		 * @param localPath
		 * @return 
		 * 
		 */
		public static function getLocalCacheFile(url:String, localPath:String = ""):File
		{
			
			localPath = localPath != null ? localPath : "";
			
			var localFilePath:String;
			var protocol:String = URLUtils.getProtocol(url);
			if (protocol != "")
			{
				
				// If absolute path (protocol specified), then drop protocol&domain
				//var server:String = URLUtils.getServerNameWithPort(url);
				//localFilePath = url.substr(url.indexOf(server) + server.length);
				localFilePath = url.substr(protocol.length + 3);
				
			}
			else
			{
				
				localFilePath = url;
				
			}
			
			localFilePath = localPath
				+ (localPath.charAt(localPath.length - 1) != "/" ? "/" : "")
				+ localFilePath;
			
			return getLocalFile(localFilePath);
			
		}
		
		/**
		 * Returns specified file's modificationDate, or creationDate
		 * if modificationDate does not exist.
		 * 
		 * @param file
		 * @return Date, or null if neither exists.
		 * 
		 */
		public static function getFileDate(file:File):Date
		{
			
			if (file)
				return file.modificationDate ? file.modificationDate : file.creationDate;
			else
				return null;
			
		}
		
		/**
		 * Checks to see if asset file(s) at specified URL(s) is already cached locally or needs updating.
		 * Cache for a specified URL is considered to be out of date if corresponding cache file does not
		 * exist locally, data at remote location does not provide "Last-Modified" or "Date", or data at
		 * remote location has newer "Last-Modified" or "Date."
		 * 
		 * <p>In order to obtain "Last-Modified" or "Date," this method will briefly do URLStream to
		 * specified URL to obtain response headers for those information (but stops after that without
		 * finishing the loading).</p>
		 * 
		 * @param urlOrRequest URL string, URLRequest object, or Array of URL string or URLRequest objects.
		 * For relative path URL (ex. assets/images/picture.jpg), corresponding cache data will be under
		 * <code>File.cacheDirectory + file path</code>. For absolute path URL
		 * (ex. http://www.example.com/assets/images/picture.jpg), cache will be under
		 * <code>File.cacheDirectory + root file path</code> (full path minus protocol&domain).
		 * 
		 * @param onResponse <code>Function(needUpdate:Array, upToDate:Array)</code>
		 * to be called once cache status for all specified are checked. Both parameters
		 * <code>needUpdate</code> and <code>upToDate</code> are Arrays containing URLs that need cache
		 * updated and ones that do not, respectively. Each Array parameters will contain object in format
		 * <code>{urlRequest: URLRequest object, url: original URL}</code>
		 * 
		 * @param targetCacheFolder Folder path prepended to cache file path under cache directory
		 * (<code>File.cacheDirectory + targetCacheFolder + file path</code>).
		 * 
		 * @param rootURL Value to be prepended to relative URL in <code>urlOrRequest</code>.
		 * For example if URL specified is &quot;image1.jpg&quot;, value of <code>rootURL</code>
		 * is added to beginning of it so it becomes <code>rootURL + image1.jpg</code>. Use this
		 * parameter to turn relative URL to absolute
		 * (ex. &quot;http://www.example.com/&quot; + &quot;image1.jpg&quot;).
		 * <p>Note: If <code>urlOrRequest</code> is URLRequest object, then its URL will be modified.</p>
		 * <p>This parameter will not have any effect on absolute URLs specified.</p>
		 * 
		 */
		public static function doesCacheNeedUpdate(urlOrRequest:*,
												   onResponse:Function,
												   targetCacheFolder:String = "",
												   rootURL:String = null):void
		{
			
			// convert to Array if it is not
			var urls:Array = (!(urlOrRequest is Array) ? [urlOrRequest] : urlOrRequest as Array);
			var numURLs:int = urls.length;
			var needUpdate:Array = [];
			var upToDate:Array = [];
			
			var checkComplete:Function = function():void
			{
				
				numURLs--;
				if (numURLs == 0)
				{
					
					// No more asset to check on
					onResponse(needUpdate, upToDate);
					
				}
				
			};
			
			var onUpdateNeeded:Function = function(urlReq:URLRequest, originalURL:String):void
			{
				
				needUpdate.push({urlRequest: urlReq, url: originalURL});
				checkComplete();
				
			};
			
			var onUpdateNotNeeded:Function = function(urlReq:URLRequest, originalURL:String):void
			{
				
				upToDate.push({urlRequest: urlReq, url: originalURL});
				checkComplete();
				
			};
			
			for (var i: int = 0; i < numURLs; i++)
			{
				
				checkFileUpdateStatus(urls[i], onUpdateNeeded, onUpdateNotNeeded, targetCacheFolder, rootURL);
				
			}
			
		}
		
		/**
		 * Checks to see if an asset file at specified URL is already cached locally or needs updating.
		 * 
		 * @param urlOrRequest Single URL string or URLRequest object. For relative path
		 * URL (ex. assets/images/picture.jpg), corresponding cache data will be under
		 * <code>File.cacheDirectory + file path</code>. For absolute path URL
		 * (ex. http://www.example.com/assets/images/picture.jpg), cache will be under
		 * <code>File.cacheDirectory + root file path</code> (full path minus protocol&domain).
		 * 
		 * @param needsUpdateFunc <code>Function(urlReq:URLRequest, originalURL:String):void</code>
		 * to be called if local cache file for specified URL needs updating.
		 * 
		 * @param noNeedForUpdateFunc <code>Function(urlReq:URLRequest, originalURL:String):void</code>
		 * to be called if local cache file for specified URL does not need updating.
		 * 
		 * @param targetCacheFolder Folder path prepended to cache file path under cache directory
		 * (<code>File.cacheDirectory + targetCacheFolder + file path</code>.
		 * 
		 * @param rootURL Value to be prepended to relative URL in <code>urlOrRequest</code>.
		 * For example if URL specified is &quot;image1.jpg&quot;, value of <code>rootURL</code>
		 * is added to beginning of it so it becomes <code>rootURL + image1.jpg</code>. Use this
		 * parameter to turn relative URL to absolute
		 * (ex. &quot;http://www.example.com/&quot; + &quot;image1.jpg&quot;).
		 * <p>This parameter will not have any effect if absolute URL specified for <code>urlOrRequest</code>.</p>
		 * 
		 */
		private static function checkFileUpdateStatus(urlOrRequest:*,
													  needsUpdateFunc:Function,
													  noNeedForUpdateFunc:Function = null,
													  targetCacheFolder:String = "",
													  rootURL:String = null):void
		{
			
			var urlData:LoadURLData = buildURLReq(urlOrRequest, rootURL);
			var cacheFile:File = getLocalCacheFile(urlData.originalURL, targetCacheFolder != null ? targetCacheFolder : "");
			
			if (!cacheFile.exists)
			{
				
				// Cache file does not exist, so we need to update no matter what
				trace(urlData.originalURL + " - no cache file ---> Load!");
				EM.callLater(needsUpdateFunc, [urlData.urlReq, urlData.originalURL]);
				// using callLater so it mimics the case using URLStream below
				
			}
			else
			{
				
				// Cache file exists
				
				// Use URLStream to load response header for the specfied URL
				var headerLoader:URLStream = new URLStream();
				var headerLoadHandler:Function = function(event:Event):void
				{
					
					headerLoader.removeEventListener(Event.COMPLETE, headerLoadHandler);
					headerLoader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, headerLoadHandler);
					headerLoader.removeEventListener(IOErrorEvent.IO_ERROR, headerLoadHandler);
					headerLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, headerLoadHandler);
					
					if (event.type == HTTPStatusEvent.HTTP_RESPONSE_STATUS)
					{
						
						var responseEvent:HTTPStatusEvent = event as HTTPStatusEvent;
						
						// Stop URL stream
						headerLoader.close();
						
						// extract dates from response header
						var remoteFileCreationDate:Date;
						var remoteFileModificationDate:Date;
						var numHeaders:int = responseEvent.responseHeaders.length;
						for (var i:int = 0; i < numHeaders; i++)
						{
							
							if (URLRequestHeader(responseEvent.responseHeaders[i]).name == "Date")
							{
								
								remoteFileCreationDate = new Date(
									Date.parse(URLRequestHeader(responseEvent.responseHeaders[i]).value)
								);
								//trace("---- Date: " + remoteFileCreationDate);
								
								if (remoteFileCreationDate && remoteFileModificationDate)
									break;
								
							}
							else if (URLRequestHeader(responseEvent.responseHeaders[i]).name == "Last-Modified")
							{
								
								remoteFileModificationDate = new Date(
									Date.parse(URLRequestHeader(responseEvent.responseHeaders[i]).value)
								);
								//trace("---- Last-Modified: " + remoteFileModificationDate);
								
								if (remoteFileCreationDate && remoteFileModificationDate)
									break;
								
							}
							
						}
						
						// Check to see if corresponding file exists in cache, or if it does then if it is old.
						// We will ignore files that already exist in local cache and have newer "Last-Modified"/"Date."
						
						//trace("===");
						//trace(cacheFile.nativePath);
						//trace(cacheFile.exists);
						
						var remoteFileDate:Date = remoteFileModificationDate ? remoteFileModificationDate : remoteFileCreationDate;
						
						if (!remoteFileDate ||
							!cacheFile.exists ||
							remoteFileDate.getTime() > getFileDate(cacheFile).getTime())
						{
							
							// Remote file date does not exist, or
							// cache file does not exist, or
							// remote file date is newer than cache file date
							
							if (!remoteFileDate)
								trace(urlData.originalURL + " - no remote file date --> Load");
							else if (!cacheFile.exists)
								trace(urlData.originalURL + " - no cache file --> Load");
							else if (remoteFileDate.getTime() > getFileDate(cacheFile).getTime())
								trace(urlData.originalURL + " - newer remote file: " + remoteFileDate + " vs local: " + getFileDate(cacheFile) + " --> Load");
							
							// We will load this file
							needsUpdateFunc(urlData.urlReq, urlData.originalURL);
							
						}
						else if (noNeedForUpdateFunc != null)
						{
							
							noNeedForUpdateFunc(urlData.urlReq, urlData.originalURL);
							
						}
						
					}
					else if ((event.type == IOErrorEvent.IO_ERROR)
						|| (event.type == SecurityErrorEvent.SECURITY_ERROR))
					{
						
						// Some kind of error
						trace(event);
						
						// just have LoaderMax load it and let it dispatch error event
						// if it does not exist in local cache
						if (!cacheFile.exists)
							needsUpdateFunc(urlData.urlReq, urlData.originalURL);
						else if (noNeedForUpdateFunc != null)
							noNeedForUpdateFunc(urlData.urlReq, urlData.originalURL);
						
					}
					else // event.type == Event.COMPLETE
					{
						
						// complete event would be dispatched without httpResponseStatus
						// if URLRequest pointed to local file (ex File.applicationDirectory)
						trace(event);
						
						// load this file if it does not exist in local cache
						if (!cacheFile.exists)
							needsUpdateFunc(urlData.urlReq, urlData.originalURL);
						else if (noNeedForUpdateFunc != null)
							noNeedForUpdateFunc(urlData.urlReq, urlData.originalURL);
						
					}
					
				};
				
				headerLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, headerLoadHandler);
				headerLoader.addEventListener(IOErrorEvent.IO_ERROR, headerLoadHandler);
				headerLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, headerLoadHandler);
				headerLoader.addEventListener(Event.COMPLETE, headerLoadHandler);
				
				// load URLRequest as is, otherwise create URLRequest with urlData.loadSourceURL and load it
				headerLoader.load(urlData.urlReq);
				
			}
			
		}
		
		/**
		 * Deletes cache file corresponding to specified URL.
		 * 
		 * @param urlOrRequest URL string, URLRequest object, or Array of URL strings or URLRequest
		 * objects. For relative path URL (ex. assets/images/picture.jpg), corresponding cache data
		 * will be under <code>File.cacheDirectory + file path</code>. For absolute path URL
		 * (ex. http://www.example.com/assets/images/picture.jpg), cache will be under
		 * <code>File.cacheDirectory + root file path</code> (full path minus protocol&domain).
		 * 
		 * @param targetCacheFolder Folder path prepended to cache file path under cache directory
		 * (<code>File.cacheDirectory + targetCacheFolder + file path</code>.
		 * 
		 */
		public static function deleteCache(urlOrRequest:*, targetCacheFolder:String = ""):void
		{
			
			// convert to Array if it is not
			var urls:Array = (!(urlOrRequest is Array) ? [urlOrRequest] : urlOrRequest as Array);
			
			var originalURL:String;
			var cacheFile:File;
			var numURLs:int = urls.length;
			for (var i: int = 0; i < numURLs; i++)
			{
				
				originalURL = (urls[i] is URLRequest ? URLRequest(urls[i]).url : urls[i] as String);
				cacheFile = getLocalCacheFile(originalURL, targetCacheFolder != null ? targetCacheFolder : "");
				
				if (cacheFile.exists)
				{
					
					try
					{
						
						cacheFile.deleteFile();
						
					}
					catch (e:Error)
					{
						
						trace("Error deleting cache file: " + cacheFile.nativePath);
						
					}
					
				}
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function LoadAndStoreLocalCacheUtil(arrayOfUrlOrRequest:Array = null,
												   targetCacheFolder:String = null,
												   rootURL:String = null)
		{
			
			super();
			
			// start immediate load if parameters are specified
			if (arrayOfUrlOrRequest)
				load(arrayOfUrlOrRequest, targetCacheFolder, rootURL);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var loadInProgress:Boolean = false;
		
		private var loadCacheTargetFolder:String;
		
		private var loadQueue:LoaderMax;
		private var loadQueueData:Dictionary; // dictionary[DataLoader] = Original URL String
		private var loadQueueCount:int;
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  numChildren
		//----------------------------------
		
		public function get numChildren():uint
		{
			
			if (loadQueue)
				return loadQueue.numChildren;
			else
				return 0;
			
		}
		
		//----------------------------------
		//  bytesLoaded
		//----------------------------------
		
		/**
		 * Indicates the number of bytes that have been loaded thus far during the load operation.
		 * 
		 * @default 0
		 */
		public function get bytesLoaded():uint
		{
			
			if (loadQueue)
				return loadQueue.bytesLoaded;
			else
				return 0;
			
		}
		
		//----------------------------------
		//  bytesTotal
		//----------------------------------
		
		/**
		 * Indicates the total number of bytes in the downloaded data.
		 * 
		 * @default 0
		 */
		public function get bytesTotal():uint
		{
			
			if (loadQueue)
				return loadQueue.bytesTotal;
			else
				return 0;
			
		}
		
		//----------------------------------
		//  bytesTotal
		//----------------------------------
		
		private var _loadQueueProgress:Number = 0;
		
		/**
		 * A value between 0 and 1 indicating the overall progress of the loader
		 * 
		 * @default 0
		 */
		public function get progress():Number
		{
			
			/*
			(Bug in LoaderMax?) Sometimes LoaderMax.progress == 0 in middle of loading...
			I think it happens at brief moment when there are no data in progress of loading
			(ex. 5 files, 2 of them are 100% completed and 3 are still 0% but none are in between 0-100)
			and LoaderMax is handling it incorrectly internally. So I am doing this hacky thing to
			keep load progress increasing, preventing it from jumping back to 0
			*/
			if (loadQueue)
				return _loadQueueProgress;
				//return loadQueue.progress;
			else
				return 0;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function buildURLReq(urlOrRequest:*, rootURL:String = null):LoadURLData
		{
			
			var originalURL:String;
			var loadSourceURL:*;
			var urlReq:URLRequest;
			
			if (urlOrRequest is String)
			{
				
				// remember original URL
				originalURL = String(urlOrRequest);
				
				// If rootURL is defined and specified URL is relative, prepend with it
				if ((rootURL != null) && (URLUtils.getProtocol(originalURL) == ""))
					loadSourceURL = rootURL
						+ (rootURL.charAt(rootURL.length - 1) != "/" ? "/" : "")
						+ originalURL; 
				else
					loadSourceURL = originalURL;
				
				urlReq = new URLRequest(loadSourceURL);
				
			}
			else if (urlOrRequest is URLRequest)
			{
				
				// remember original URL
				originalURL = URLRequest(urlOrRequest).url;
				
				// If rootURL is defined and specified URL is relative, prepend with it
				if ((rootURL != null) && (URLUtils.getProtocol(originalURL) == ""))
					URLRequest(urlOrRequest).url = rootURL
						+ (rootURL.charAt(rootURL.length - 1) != "/" ? "/" : "")
						+ originalURL;
				
				loadSourceURL = URLRequest(urlOrRequest);
				urlReq = loadSourceURL;
				
			}
			else
			{
				
				throw new Error("URL String or URLRequest object expected.");
				return null;
				
			}
			
			return new LoadURLData(originalURL, loadSourceURL, urlReq);
			
		}
		
		private function addDataLoader(urlReq:URLRequest, originalURL:String):void
		{
			
			var loader:DataLoader = new DataLoader(urlReq, {format: "binary", autoDispose: true});
			loadQueue.append(loader);
			loadQueueData[loader] = originalURL; // remember corresponding data
			
		}
		
		private function removeLoadQueueEvents(loadQueue:LoaderMax):void
		{
			
			if (loadQueue.hasEventListener(LoaderEvent.COMPLETE))
			{
				
				loadQueue.removeEventListener(LoaderEvent.COMPLETE, assetLoadCompleteHandler);
				
			}
			else
			{
				
				loadQueue.removeEventListener(LoaderEvent.CHILD_PROGRESS, assetLoadChildProgressHandler);
				loadQueue.removeEventListener(LoaderEvent.PROGRESS, assetLoadProgressHandler);
				loadQueue.removeEventListener(LoaderEvent.CHILD_COMPLETE, assetLoadChildCompleteHandler);
				loadQueue.removeEventListener(LoaderEvent.ERROR, assetLoadErrorHandler);
				
			}
			
		}
		
		private function cleanUp(loadQueue:LoaderMax):void
		{
			
			loadInProgress = false;
			removeLoadQueueEvents(loadQueue);
			loadQueue = null;
			_loadQueueProgress = 0;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Sends and loads data from the specified URL, and at the same time stores data in specified
		 * local folder under <code>File.cacheDirectory</code>.
		 * 
		 * @param arrayOfUrlOrRequest Array of URL strings and/or URLRequest objects. For relative path
		 * URL (ex. assets/images/picture.jpg), data will be stored under <code>File.cacheDirectory +
		 * relative path</code>. For absolute path URL (ex. http://www.example.com/assets/images/picture.jpg),
		 * data will be stored under <code>File.cacheDirectory + root path</code> (full path minus
		 * protocol&domain).
		 * 
		 * @param targetCacheFolder Folder path prepended to each file path under cache directory
		 * (<code>File.cacheDirectory + targetCacheFolder + file path</code>.
		 * 
		 * @param rootURL Value to be prepended to relative URLs in <code>arrayOfUrlOrRequest</code>.
		 * For example if URLs specified are &quot;image1.jpg&quot; and &quot;image2.jpg&quot;, value of <code>rootURL</code>
		 * is added to beginning of them all so they become <code>rootURL + image1.jpg</code> and
		 * <code>rootURL + image2.jpg</code>. Use this parameter to turn relative URLs to absolute
		 * (ex. &quot;http://www.example.com/&quot; + &quot;image1.jpg&quot;).
		 * <p>Note: If <code>urlOrRequest</code> is URLRequest object, then its URL will be modified.</p>
		 * <p>This parameter will not have any effect on absolute URLs specified.</p>
		 * 
		 */
		public function load(arrayOfUrlOrRequest:Array,
							 targetCacheFolder:String = "",
							 rootURL:String = null):void
		{
			
			if (!loadInProgress)
			{
				
				var loadFileCheckCount:int = arrayOfUrlOrRequest.length;
				if (loadFileCheckCount <= 0)
				{
					
					throw new Error("No URLs specified");
					return;
					
				}
				
				loadInProgress = true;
				loadCacheTargetFolder = targetCacheFolder != null ? targetCacheFolder : "";
				
				// Set up LoaderMax that will do actual loading of the new asset files later
				var loadQueueParams:Object = {};
				loadQueueParams.name = "loadQueue";
				loadQueue = new LoaderMax(loadQueueParams);
				_loadQueueProgress = 0; // reset load progress
				loadQueueData = new Dictionary(true);
				loadQueueCount = 0;
				
				var onResponse:Function = function(needUpdate:Array, upToDate:Array):void
				{
					
					// This is how many URLs need cache updated
					loadQueueCount = needUpdate.length;
					
					if (loadQueueCount > 0)
					{
						
						for (var i:int = 0; i < loadQueueCount; i++)
						{
							
							addDataLoader(needUpdate[i].urlRequest as URLRequest, needUpdate[i].url as String);
							
						}
						
						// Start queue load
						loadQueue.maxConnections = 5;
						loadQueue.addEventListener(LoaderEvent.CHILD_PROGRESS, assetLoadChildProgressHandler);
						loadQueue.addEventListener(LoaderEvent.PROGRESS, assetLoadProgressHandler);
						loadQueue.addEventListener(LoaderEvent.CHILD_COMPLETE, assetLoadChildCompleteHandler);
						loadQueue.addEventListener(LoaderEvent.ERROR, assetLoadErrorHandler);
						
					}
					else
					{
						
						// Nothing to load, so we will just let LoaderMax dispatch complete event
						loadQueue.addEventListener(LoaderEvent.COMPLETE, assetLoadCompleteHandler);
						
					}
					
					loadQueue.load();
					
				};
				
				doesCacheNeedUpdate(arrayOfUrlOrRequest, onResponse, targetCacheFolder, rootURL);
				
			}
			else
			{
				
				// load already in progress
				throw new Error("Load is already in progress, wait until it is done");
				
			}
			
		}
		
		public function getCurrentLoaderMaxQueue():LoaderMax
		{
			
			return loadQueue;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function assetLoadChildProgressHandler(event:LoaderEvent):void
		{
			
			//trace("child progress: " + event.target.progress + " " + event.currentTarget.progress);
			dispatchEvent(event);
			
		}
		
		private function assetLoadProgressHandler(event:LoaderEvent):void
		{
			
			//trace("progress: " + event.target.progress + " " + event.currentTarget.progress);
			if (loadQueue.progress > _loadQueueProgress)
				_loadQueueProgress = loadQueue.progress;
			
			dispatchEvent(event);
			
		}
		
		private function assetLoadChildCompleteHandler(event:LoaderEvent):void
		{
			
			var loader:DataLoader = event.target as DataLoader;
			var originalURL:String = loadQueueData[loader] as String;
			delete loadQueueData[loader];
			
			// Store in cache
			var cacheFile:File = getLocalCacheFile(originalURL, loadCacheTargetFolder);
			storeToLocal(loader.content as ByteArray, cacheFile);
			
			trace("child load complete: " + event.target + " -> " + cacheFile.nativePath);
			
			// complete
			dispatchEvent(event);
			
			checkIfLoadComplete(event);
			
		}
		
		private function assetLoadCompleteHandler(event:LoaderEvent):void
		{
			
			trace("load queue complete");
			
			dispatchEvent(event);
			
			if (loadQueueCount == 0)
				cleanUp(event.currentTarget as LoaderMax); // If everything has finished loading, clean up.
			
		}
		
		private function assetLoadErrorHandler(event:LoaderEvent):void
		{
			
			trace("error occured: " + event.text);
			
			var loader:DataLoader = event.target as DataLoader;
			var originalURL:* = loadQueueData[loader] as String;
			delete loadQueueData[loader];
			
			// error
			dispatchEvent(event);
			
			checkIfLoadComplete(event);
			
		}
		
		private function checkIfLoadComplete(event:LoaderEvent):void
		{
			
			// count update
			loadQueueCount--;
			
			// If everything has finished loading, clean up.
			if (loadQueueCount == 0)
			{
				
				cleanUp(event.currentTarget as LoaderMax);
				
				dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE, event.target, event.text, event.data));
				
			}
			
		}
		
	}
	
}

import flash.net.URLRequest;

class LoadURLData
{
	
	public function LoadURLData(originalURL:String = null, loadSourceURL:* = null, urlReq:URLRequest = null)
	{
		
		this.originalURL = originalURL;
		this.loadSourceURL = loadSourceURL;
		this.urlReq = urlReq;
		
	}
	
	public var originalURL:String;
	public var loadSourceURL:*;
	public var urlReq:URLRequest;
	
}