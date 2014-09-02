/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.datamodels
{
	public dynamic class FlashVars
	{
		private static var _modelLocator:FlashVars;
		
		public function FlashVars(h:Function = null):void
		{
			
			if (!(h === hidden))
				throw new Error("FlashVars can only be accessed through FlashVars.getInstance().");
				
		}
		
		public static function addModel(modelId:String, model:Object):void
		{
			
			getInstance()[modelId] = model;
			
		}
		
		public static function getInstance():FlashVars
		{
			
			if(!_modelLocator){
				_modelLocator = new FlashVars(hidden);
			}
			
			return _modelLocator;
			
		}
		
		// This was bombing on me because getter/setter types did not match
		//public static function get parameters():FlashVars
		public static function get parameters():Object
		{
			return getInstance();
		}
		
		public static function set parameters(_parameters:Object):void
		{
			for(var paramName:String in _parameters){
				addModel(paramName, _parameters[paramName]);
			}
		}
		
		
		private static function hidden():void {}
	}
}