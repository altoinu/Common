/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.air.mobile.system
{
	
	/**
	 * Constants for iOS device names.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class IOSDeviceNames
	{
		
		public static const IPHONE_AIR_DEBUGGER:String = "iPhoneAIRDebugger";
		public static const IPHONE_SIMULATOR:String = "x86_64";
		public static const IPHONE_1G:String = "iPhone1,1"; // first gen is 1,1
		public static const IPHONE_3G:String = "iPhone1"; // second gen is 1,2
		public static const IPHONE_3GS:String = "iPhone2"; // third gen is 2,1
		public static const IPHONE_4:String = "iPhone3"; // normal:3,1 verizon:3,3
		public static const IPHONE_4S:String = "iPhone4"; // 4S is 4,1
		public static const IPHONE_5PLUS:String = "iPhone";
		public static const TOUCH_1G:String = "iPod1,1";
		public static const TOUCH_2G:String = "iPod2,1";
		public static const TOUCH_3G:String = "iPod3,1";
		public static const TOUCH_4G:String = "iPod4,1";
		public static const TOUCH_5PLUS:String = "iPod";
		public static const IPAD_1:String = "iPad1"; // iPad1 is 1,1
		public static const IPAD_2:String = "iPad2"; // wifi:2,1 gsm:2,2 cdma:2,3
		public static const IPAD_3:String = "iPad3"; // (guessing)
		public static const IPAD_4PLUS:String = "iPad";
		
		public static function getiPodTouches():Array
		{
			
			return [
				IOSDeviceNames.TOUCH_1G,
				IOSDeviceNames.TOUCH_2G,
				IOSDeviceNames.TOUCH_3G,
				IOSDeviceNames.TOUCH_4G,
				IOSDeviceNames.TOUCH_5PLUS
			];
			
		}
		
		public static function getiPhones():Array
		{
			
			return [
				IOSDeviceNames.IPHONE_1G,
				IOSDeviceNames.IPHONE_3G,
				IOSDeviceNames.IPHONE_3GS,
				IOSDeviceNames.IPHONE_4,
				IOSDeviceNames.IPHONE_4S,
				IOSDeviceNames.IPHONE_5PLUS,
			];
			
		}
		
		public static function getiPads():Array
		{
			
			return [
				IOSDeviceNames.IPAD_1,
				IOSDeviceNames.IPAD_2,
				IOSDeviceNames.IPAD_3,
				IOSDeviceNames.IPAD_4PLUS,
			];
			
		}
		
	}
	
}