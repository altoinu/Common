/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.mobile.components
{
	
	import com.altoinu.flex.mobile.events.ViewDataTrackingNavigatorEvent;
	import com.altoinu.flex.mobile.models.TrackedViewState;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.components.ViewNavigator;
	import spark.transitions.ViewTransitionBase;
	
	use namespace mx_internal;
	
	/**
	 *  Dispatched after a view is pushed into this ViewDataTrackingNavigator to be tracked.
	 *
	 *  @eventType com.altoinu.flex.mobile.events.ViewDataTrackingNavigatorEvent.TRACKED_VIEW_PUSH
	 *  
	 */
	[Event(name="trackedViewPush", type="com.altoinu.flex.mobile.events.ViewDataTrackingNavigatorEvent")]
	
	/**
	 *  Dispatched after a view which this ViewDataTrackingNavigator was tracking is popped (removed) from stack.
	 *
	 *  @eventType com.altoinu.flex.mobile.events.ViewDataTrackingNavigatorEvent.TRACKED_VIEW_POP
	 *  
	 */
	[Event(name="trackedViewPop", type="com.altoinu.flex.mobile.events.ViewDataTrackingNavigatorEvent")]
	
	/**
	 *  Dispatched when trying to pop view but already on first page.
	 *
	 *  @eventType com.altoinu.flex.mobile.events.ViewDataTrackingNavigatorEvent.NO_MORE_PREVIOUS_PAGES
	 *  
	 */
	[Event(name="noMorePpreviousPages", type="com.altoinu.flex.mobile.events.ViewDataTrackingNavigatorEvent")]
	
	/**
	 * ViewNavigator component that keeps track of views added and data passed to them.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ViewDataTrackingNavigator extends ViewNavigator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ViewDataTrackingNavigator()
		{
			
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var savedStates:Dictionary = new Dictionary(true);
		
		/**
		 * We need to keep track of the views since we don't have immediate access to the
		 * list from the ViewNavigator 
		 */
		private var trackedViews:Array = [];
		
		private var watchPopEndView:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		//  currentTrackedView
		//--------------------------------------
		
		[Bindable(event="viewDataUpdated")]
		public final function get currentTrackedView():*
		{
			
			return trackedViews[currentTrackedViewLength - 1];
			
		}
		
		[Bindable(event="viewDataUpdated")]
		public final function get currentTrackedViewLength():uint
		{
			
			return trackedViews.length;
			
		}
		
		//--------------------------------------
		//  appActiveView
		//--------------------------------------
		
		[Bindable(event="viewDataUpdated")]
		[Bindable("viewChangeComplete")]
		public function get appActiveView():*
		{
			
			var numViews:int = currentTrackedViewLength;
			
			if ((numViews > 0) && (getClass(activeView) == trackedViews[numViews - 1]))
				return activeView; // If whatever is on top of trackedViews stack is same as super.activeView's class, then it is the appActiveView
			else
				return trackedViews[numViews - 1]; // If not then return whatever is really on top of trackedViews stack
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function getClass(instance:Object):Class
		{
			
			return getDefinitionByName(getQualifiedClassName(instance)) as Class;
			
		}
		
		/**
		 * Returns index number in trackedViews for next View that will be removed, or -1 if there are no more views that can be popped.
		 */
		private function hasPoppableView(checkEndViewIndex:int = 0):int
		{
			
			if (checkEndViewIndex < 0)
				checkEndViewIndex = 0;
			
			// Besides 1st one (trackedViews[0]), are there any actual Views that ViewDataTrackingNavigator can popView()?
			var numItems:int = trackedViews.length;
			var navStackNumItems:int = this.navigationStack.source.length;
			for (var i:int = numItems - 1; checkEndViewIndex < i; i--)
			{
				
				for (var j:int = 0; j < navStackNumItems; j++)
				{
					
					if (this.navigationStack.source[j].viewClass === trackedViews[i])
						return i;
					
				}
				
			}
			
			return -1;
			
		}
		
		/**
		 * Makes MainAppViewManager remember one view in stack
		 * 
		 * @param viewObj
		 * 
		 */
		private function rememberView(viewObj:Object):void
		{
			
			// Track the view
			trackedViews.push(viewObj);
			
			dispatchEvent(new Event("viewDataUpdated"));
			
		}
		
		/**
		 * Makes MainAppViewManager remove one view from stack (forget it)
		 */
		private function forgetViewAt(index:int):*
		{
			
			var popped:Array = trackedViews.splice(index, 1);
			
			dispatchEvent(new Event("viewDataUpdated"));
			
			return popped[0];
			
		}
		
		/**
		 * Returns data associted with remembered targetView, if it exists
		 * 
		 * @param targetView
		 */
		private function getDataForTrackedView(targetView:*):Object
		{
			
			if (savedStates[targetView])
			{
				
				if (targetView is Class)
				{
					
					return savedStates[targetView];
					
				}
				else
				{
					
					var index:int = trackedViews.lastIndexOf(targetView);
					if ((index != -1) && savedStates[targetView].hasOwnProperty(index) && savedStates[targetView][index])
						return savedStates[targetView][index];
					else
						return null;
					
				}
				
			}
			
			return null;
			
		}
		
		/**
		 * Wait until activeView becomes endView
		 * @param endView
		 * @param data
		 * 
		 */
		private function waitUntilPopCompletes(endView:Class, data:Object = null):void
		{
			
			if (endView)
			{
				
				// We want to wait until activeView becomes endView
				
				if (!watchPopEndView)
				{
					
					var me:IEventDispatcher = this;
					var onDataChange:Function = function(dataEvent:Event):void
					{
						
						if (activeView is watchPopEndView)
						{
							
							// once activeView changes to endView, we know pop is complete
							
							me.removeEventListener(dataEvent.type, onDataChange);
							
							var activeViewClass:Class = getClass(activeView);
							var curSaveState:Object = savedStates[activeViewClass];
							
							if (!data && curSaveState)
								activeView.data = curSaveState;
							else
								activeView.data = data;
							
							watchPopEndView = null;
							
							if (!(trackedViews[currentTrackedViewLength - 1] is Class))
							{
								
								// Next item in tracked view stack is not Class...
								// which means it is not for activeView that just showed up
								// ...which means ViewDataTrackingNavigator has some state
								// changes remembered
								// Since Flex ViewNavigator creates new instance of View every time
								// and not restore view states and property values, we need to do it here
								
								var recreateStateIndex:int = trackedViews.lastIndexOf(activeViewClass); // This is index number of activeView's tracked position
								var recreateViewData:Object;
								var untrack:Array;
								for (var i:int = recreateStateIndex + 1; i < currentTrackedViewLength; i++)
								{
									
									recreateViewData = getDataForTrackedView(trackedViews[i]);
									
									if ((recreateViewData is TrackedViewState) && TrackedViewState(recreateViewData).recreateAtViewNavigate)
									{
										
										// Restore state and properties stored in this recreateViewData
										var trackedViewState:TrackedViewState = recreateViewData as TrackedViewState;
										trace("TODO: Recreate state: "+trackedViewState.targetView, trackedViewState.fromState, trackedViewState.toState);
										

									}
									else
									{
										
										// This particular trackedViews[i] won't be recreated
										// so let'ts untrack immediately
										if (!untrack)
											untrack = [];
										
										untrack.push(trackedViews[i]);
										
									}
									
								}
								
								while (untrack && (untrack.length > 0))
								{
									
									unTrackView(untrack[untrack.length - 1]);
									untrack.splice(untrack.length - 1, 1);
									
								}
								
								/*
								while ((recreateStateIndex < currentTrackedViewLength) &&
									!(trackedViews[recreateStateIndex] is Class))
								{
									
									trace("@@@@@@@");
									trace(trackedViews[recreateStateIndex], getDataForTrackedView(trackedViews[recreateStateIndex]))
									trace(trackedViews[recreateStateIndex].hasOwnProperty("id"));
									trace(trackedViews[recreateStateIndex].id);
									trace(getClass(trackedViews[recreateStateIndex]));
									trace(activeView);
									trace(activeView.hasOwnProperty(trackedViews[recreateStateIndex].id));
									recreateStateIndex++;
									
								}
								*/
								
							}
							
						}
						
					};
					
					this.addEventListener(Event.ENTER_FRAME, onDataChange);
					
				}
				
				// ViewDataTrackingNavigator should now wait until everything is popped
				// and see this becoming activeView
				watchPopEndView = endView;
				
			}
			
		}
		
		private function noMorePrevious():void
		{
			
			// No more previous view
			dispatchEvent(new ViewDataTrackingNavigatorEvent(ViewDataTrackingNavigatorEvent.NO_MORE_PREVIOUS_PAGES,
				false,
				false));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inherit
		 */
		override public function pushView(viewClass:Class, data:Object = null, context:Object = null, transition:ViewTransitionBase = null):void
		{
			
			// Remember current view data
			savedStates[getClass(activeView)] = activeView.data;
			
			// and push view and track
			super.pushView(viewClass, data, context, transition);
			trackView(viewClass, data);
			
			if (watchPopEndView) // If ViewDataTrackingNavigator is already in middle of trying to pop view(s)
				watchPopEndView = viewClass; // then it will now be this one that it should wait for
			
		}
		
		/**
		 * @private
		 */
		override public final function popView(transition:ViewTransitionBase = null):void
		{
			
			// I am not letting you use this method so this class can handle view data in flow, too
			throw new Error("Don't use popView method for ViewDataTrackingNavigator, instead use poptoPreviousView");
			
		}
		
		/**
		 * @private
		 */
		override public final function popToFirstView(transition:ViewTransitionBase = null):void
		{
			
			// I am not letting you use this method so this class can handle view data in flow, too
			throw new Error("Don't use popToFirstView method for ViewDataTrackingNavigator, instead use poptoInitialView");
			
		}
		
		/**
		 * @private
		 */
		override public final function popAll(transition:ViewTransitionBase = null):void
		{
			
			// I am not letting you use this method so this class can handle view data in flow, too
			throw new Error("Don't use popAll method for ViewDataTrackingNavigator, instead use poptoInitialView");
			
		}
		
		/**
		 * @private
		 */
		override public final function replaceView(viewClass:Class, data:Object = null, context:Object = null, transition:ViewTransitionBase = null):void
		{
			
			// TODO: this method is not implemented yet
			throw new Error("replaceView is not implemented yet");
			
		}
		
		/**
		 * @private
		 */
		override public function backKeyUpHandler():void
		{
			
			// TODO: this method is not implemented yet
			throw new Error("backKeyUpHandler is not implemented yet");
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  public methods
		//
		//--------------------------------------------------------------------------
		
		public function poptoPreviousView(data:Object = null, transition:ViewTransitionBase = null):void
		{
			
			// Remember current view data
			if (activeView)
				savedStates[getClass(activeView)] = activeView.data;
			
			var numViews:int = currentTrackedViewLength;
			if (numViews > 1)
			{
				
				var popTargetView:Object = trackedViews[currentTrackedViewLength - 1];
				if (popTargetView is Class)
				{
					
					// If there is a view to be popped then ViewDataTrackingNavigator will end up here
					var viewClassToGoBackTo:Class = this.navigationStack.source[this.navigationStack.length - 2].viewClass;
					waitUntilPopCompletes(viewClassToGoBackTo, data);
					
					// active view is the same as what is on top of stack so do normal popView
					super.popView(transition);
					
				}
				
				// untrack what is in stack
				unTrackView(popTargetView);
				
			}
			else if (numViews == 1)
			{
				
				// No more previous view
				noMorePrevious();
				
			}
			
		}
		
		public function poptoInitialView(data:Object = null, transition:ViewTransitionBase = null):void
		{
			
			// Remember current view data
			if (activeView)
				savedStates[getClass(activeView)] = activeView.data;
			
			var numViews:int = currentTrackedViewLength;
			if (numViews > 1)
			{
				
				var nextPopViewIndex:int = hasPoppableView();
				if (nextPopViewIndex != -1)
					waitUntilPopCompletes(this.navigationStack.source[0].viewClass, data);
				
				// pop all views first to make sure there is none left
				super.popToFirstView(transition);
				
				// and untrack all
				var popTargetView:Object;
				while (currentTrackedViewLength > 1) // untrack all up to first one
				{
					
					// untrack everything that is in stack
					popTargetView = trackedViews[currentTrackedViewLength - 1];
					
					unTrackView(popTargetView);
					
				}
				
			}
			else if (numViews == 1)
			{
				
				// No more previous view
				noMorePrevious();
				
			}
			
		}
		
		public function untrackAllStatesForActiveView(data:Object = null):void
		{
			
			// Remember current view data
			if (activeView)
				savedStates[getClass(activeView)] = activeView.data;
			
			var numViews:int = currentTrackedViewLength;
			if (numViews > 1)
			{
				
				// Let's untrack everything up to trackedViews[trackedViews.indexOf(getClass(activeView))]
				var popTargetView:Object;
				while (trackedViews[currentTrackedViewLength - 1] !== getClass(activeView))
				{
					
					// untrack everything that is in stack
					popTargetView = trackedViews[currentTrackedViewLength - 1];
					
					unTrackView(popTargetView);
					
				}
				
			}
			else if (numViews == 1)
			{
				
				// No more previous view
				noMorePrevious();
				
			}
			
		}
		
		/**
		 * Makes ViewDataTrackingNavigator remember specified view and data associated with it in stack
		 * 
		 * @param targetView
		 * @param targetViewData
		 * 
		 */
		public function trackView(targetView:*, targetViewData:Object = null):void
		{
			
			rememberView(targetView);
			
			if (targetViewData)
			{
				
				// and data associated with this by its index number in trackedViews Array
				
				if (targetView is Class)
				{
					
					savedStates[targetView] = targetViewData;
					
				}
				else
				{
					
					if (!savedStates[targetView])
						savedStates[targetView] = new Dictionary(true);
					
					savedStates[targetView][trackedViews.indexOf(targetView)] = targetViewData;
					
				}
				
			}
			
			dispatchEvent(new ViewDataTrackingNavigatorEvent(ViewDataTrackingNavigatorEvent.TRACKED_VIEW_PUSH,
				false,
				false,
				targetView,
				targetViewData));
			
		}
		
		/**
		 * Makes ViewDataTrackingNavigator remove specified view information in stack.
		 * 
		 * @param targetView
		 * 
		 */
		public function unTrackView(targetView:*):void
		{
			
			var index:int = trackedViews.lastIndexOf(targetView);
			if (index != -1)
			{
				
				// Specified view is part of this ViewDataTrackingNavigator so slice (forget) it from stack
				
				var dataobj:Object = getDataForTrackedView(targetView);
				
				forgetViewAt(index);
				
				dispatchEvent(new ViewDataTrackingNavigatorEvent(ViewDataTrackingNavigatorEvent.TRACKED_VIEW_POP,
					false,
					false,
					targetView,
					dataobj));
				
			}
			
		}
		
		/**
		 * Returns Array containing trackedViews in this navigator.
		 */
		public function getViews():Array
		{
			
			return trackedViews.concat();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onCreationComplete(event:FlexEvent):void
		{
			
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			//put the first view in the trackedViews array
			rememberView(firstView);
			
		}
		
	}
	
}