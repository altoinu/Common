/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.air.system
{
	
	import com.altoinu.air.mobile.system.IOSDeviceNames;
	import com.altoinu.air.mobile.system.MobileDeviceMapValues;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	/**
	 * Helper methods for mobile AIR app.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class AIRAppUtils
	{
		
		private static const IOS_DEVICES:Array =
			[IOSDeviceNames.IPHONE_SIMULATOR]
			.concat(IOSDeviceNames.getiPhones(), IOSDeviceNames.getiPads(), IOSDeviceNames.getiPodTouches());
		
		/*
		private static const IOS_DEVICES:Array = [
			IOSDeviceNames.IPHONE_SIMULATOR,
			IOSDeviceNames.IPHONE_1G,
			IOSDeviceNames.IPHONE_3G,
			IOSDeviceNames.IPHONE_3GS,
			IOSDeviceNames.IPHONE_4,
			IOSDeviceNames.IPHONE_4S,
			IOSDeviceNames.IPHONE_5PLUS,
			IOSDeviceNames.IPAD_1,
			IOSDeviceNames.IPAD_2,
			IOSDeviceNames.IPAD_3,
			IOSDeviceNames.IPAD_4PLUS,
			IOSDeviceNames.TOUCH_1G,
			IOSDeviceNames.TOUCH_2G,
			IOSDeviceNames.TOUCH_3G,
			IOSDeviceNames.TOUCH_4G,
			IOSDeviceNames.TOUCH_5PLUS
		];
		*/
		
		/**
		 * Checks to see if device AIR app is running on is iOS device.
		 * @return One of device names defined in <code>com.altoinu.flash.mobile.system.IOSDeviceNames</code> or null if device is not iOS.
		 * 
		 */
		public static function isiOSDevice():String
		{
			
			var osInfo:Array = Capabilities.os.split(" ");
			var versionInfo:String = Capabilities.version.substr(0,3);
			
			/*
			if (osInfo[0] + " " + osInfo[1] != "iPhone OS")
			{
				
				return null;
				
			}
			
			// ordered from specific (iPhone1,1) to general (iPhone)
			for each (var device:String in IOS_DEVICES)
			{	
				
				if (osInfo[3].indexOf(device) != -1)
					return device;
				
			}
			
			return null;
			*/
			
			if (((osInfo.length >= 4) && (osInfo[0] + " " + osInfo[1] == "iPhone OS")) ||
				(versionInfo == "IOS"))
			{
				
				// iOS device or AIR simulator running in iOS mode
				
				if (osInfo.length >= 4)
				{
					
					// ordered from specific (iPhone1,1) to general (iPhone)
					for each (var device:String in IOS_DEVICES)
					{	
						
						if (osInfo[3].indexOf(device) != -1)
							return device; // This is the iOS device currently running on
						
					}
					
				}
				
				// assume AIR debugger running iOS mode
				return IOSDeviceNames.IPHONE_AIR_DEBUGGER;
				
			}
			else
			{
				
				// Not iOS
				return null;
				
			}
			
		}
		
		/**
		 * Checks to see if device is iOS 6 or higher.
		 * @return 
		 * 
		 */
		public static function isiOS6Plus():Boolean
		{
			
			if (isiOSDevice())
			{
				
				var osInfo:Array = Capabilities.os.split(" ");
				var version:String = osInfo[2]; // index 2 should contain version
				var majorVersion:String = version.split(".")[0];
				
				return Number(majorVersion) >= 6;
				
			}
			else
			{
				
				return false;
				
			}
			
		}
		
		/**
		 * Checks to see if device AIR app is running on is Android device.
		 * @return 
		 * 
		 */
		public static function isAndroidDevice():Boolean
		{
			
			var os:String = Capabilities.version.substr(0,3);
			return (os == "AND");
			
		}
		
		/**
		 * Returns URLRequest object to open map on mobile device. Android and iOS 5 and earlier - Google Map, iOS 6+ - Apple Map
		 * @return 
		 * 
		 * @see http://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Articles/MapLinks.html
		 */
		public static function getDeviceMapURLRequest():URLRequest
		{
			
			// TODO: We need to detect iOS 6 here because Google Maps is gone since that version
			// for iOS 6 >= we need to use URL http://maps.apple.com/maps
			// http://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Articles/MapLinks.html
			
			if (isiOS6Plus())
				return new URLRequest("http://maps.apple.com/maps"); // Apple Map for iOS6+
			else
				return new URLRequest("http://maps.google.com/maps"); // Google Map for everything else
			
		}
		
		/**
		 * Opens directions in map on the device. Android and iOS 5 and earlier - Google Map, iOS 6+ - Apple Map
		 * @param saddr Start address or lat,long coordinate (ex. "42.7325, -84.5556"),
		 * or set to <code>MobileDeviceMapValues.CURRENT_LOCATION</code> or empty string "" for current GPS location
		 * @param daddr Destination address or lat,long coordinate (ex. "42.7325, -84.5556")
		 * @param extraMapParameters Any extra map parameters to be included.
		 * See iOS: http://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Articles/MapLinks.html
		 * 
		 * @see http://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Articles/MapLinks.html
		 */
		public static function showMapDirections(saddr:String = "Current Location", daddr:String = "", extraMapParameters:URLVariables = null):void
		{
			
			var directionsReq:URLRequest = getDeviceMapURLRequest();
			var directionsParam:URLVariables = extraMapParameters ? extraMapParameters : new URLVariables();
			
			// Start location
			if (saddr && (saddr != "") && (saddr != MobileDeviceMapValues.CURRENT_LOCATION))
			{
				
				directionsParam.saddr = saddr;
				
			}
			else
			{
				
				// start address will be current location on device
				
				if (isiOSDevice()) // For iOS device
					if (!isiOS6Plus()) {
						directionsParam.saddr = MobileDeviceMapValues.CURRENT_LOCATION; // TODO: apparently, this does not work if iOS system setting is not set as English
					} else {
						directionsParam.saddr = ""; // iOS 6 Maps doesn't support "saddr=Current+Location" like the previous versions did (dumb)
					}
				else // everything else (assuming Android)
					directionsParam.saddr = ""; // For current location, empty string in start address
				
			}
			
			// Destination
			directionsParam.daddr = daddr;
			
			if (isAndroidDevice()) // Android specific parameters
			{
				
				directionsParam.sensor = "true";
				
			}
			
			directionsReq.data = directionsParam;
			
			// device will detect Apple/Google Map URL through URL scheme
			navigateToURL(directionsReq, "_blank");
			
		}
		
	}
	
}