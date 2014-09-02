/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.mobile.models
{
	
	import mx.core.IStateClient;

	/**
	 * Model to keep track of changing states for specified targetView.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class TrackedViewState
	{
		
		public function TrackedViewState(targetView:IStateClient, toState:String, optionalParams:Object = null, recreateAtViewNavigate:Boolean = false)
		{
			
			this.targetView = targetView;
			this.fromState = targetView.currentState; // remember currentState so we could go back to this later
			this.toState = toState;
			this.optionalParams = optionalParams;
			this.recreateAtViewNavigate = recreateAtViewNavigate;
			
		}
		
		public var targetView:IStateClient;
		public var fromState:String;
		public var toState:String;
		public var optionalParams:Object;
		public var recreateAtViewNavigate:Boolean;
		
	}
	
}