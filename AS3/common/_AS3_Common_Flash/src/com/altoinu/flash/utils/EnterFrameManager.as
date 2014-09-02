/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Class to manage multiple methods within same ENTER_FRAME event to save on CPU usage.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class EnterFrameManager extends Sprite
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function EnterFrameManager()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var actions:Array = [];
		private var callLaterMethod:Vector.<Function> = new Vector.<Function>();
		private var callLaterArgs:Vector.<Array> = new Vector.<Array>();
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Adds a method.
		 * @param method
		 * 
		 */
		public function addEnterFrameAction(method:Function):void
		{
			
			if (actions.indexOf(method) == -1)
			{
				
				if (actions.length == 0) // start enterFrame if first method added
					this.addEventListener(Event.ENTER_FRAME, update);
				
				actions.push(method);
				
			}
			
		}
		
		/**
		 * Removes specified method.
		 * @param method
		 * 
		 */
		public function removeEnterFrameAction(method:Function):void
		{
			
			var actionsIndex:int = actions.indexOf(method);
			if (actionsIndex != -1)
			{
				
				actions.splice(actionsIndex, 1);
				
				if (actions.length == 0) // remove enterFrame if last method removed
					this.removeEventListener(Event.ENTER_FRAME, update);
				
			}
			
		}
		
		/**
		 * Similar to Flex callLater methods but for environments without Flex framework.
		 * @param method
		 * @param args
		 * 
		 */
		public function callLater(method:Function, args:Array = null):void
		{
			
			if (actions.length == 0) // start enterFrame if first method added
				this.addEventListener(Event.ENTER_FRAME, update);
			
			actions.push(method);
			callLaterMethod.push(method);
			callLaterArgs.push(args ? args : []);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function update(event:Event):void
		{
			
			var method:Function;
			var i:int = 0;
			while (i < actions.length)
			{
				
				method = actions[i];
				var callLaterMethodIndex:int = callLaterMethod.indexOf(method);
				
				if (callLaterMethodIndex != -1)
				{
					
					// This is a callLater method, call only once
					method.apply(this, callLaterArgs[callLaterMethodIndex]);
					
					// Remove method from array since it only gets called once
					actions.splice(i, 1);
					callLaterMethod.splice(callLaterMethodIndex, 1);
					callLaterArgs.splice(callLaterMethodIndex, 1);
					
				}
				else
				{
					
					// Normal enterFrame handler
					method();
					
					i++;
					
				}
				
			}
			
			if (actions.length == 0) // remove enterFrame if last method removed
				this.removeEventListener(Event.ENTER_FRAME, update);
			
		}
		
	}
	
}