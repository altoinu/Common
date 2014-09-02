/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.containers
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	/**
	 *  Dispatched when view changes between thumbnail and full view.
	 *
	 *  @eventType com.altoinu.flex.customcomponents.ExpandableView.VIEWCHANGE
	 */
	[Event(name="viewchange", type="flash.events.Event")]
	
	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------
	
	[Exclude(name="percentHeight", kind="property")]
	[Exclude(name="percentWidth", kind="property")]
	
	/**
	 * ExpandableView component is has two views.  When <code>fullview</code> property is set as true,
	 * it will display the child contents.  If <code>fullview</code> is set to false, then it hides
	 * all child items and instead displays a single component set to <code>thumbnailComponent</code>
	 * property as a thumbnail.
	 * 
	 * <p>This may work better than using ViewStack since when switching views, ViewStack does not update
	 * the view state of each component simultaneously.  Because of this, if effects such as <code>showEffect</code>,
	 * <code>hideEffect</code>, and <code>resizeEffect</code> are set, ViewStack first has to completely hide
	 * whatever is displaying before it can play the effect to show the next view.</p>
	 * 
	 * <p>ExpandableView switches visibility state simultaneously, so if effects are set, they play
	 * simultaneously.  For example, by setting <code>showEffect</code> and <code>hideEffect</code> as Fade
	 * effect for all of the children that will display for full view and <code>thumbnailComponent</code>, thumbnail
	 * can fade out while full view items fade in at the same time.</p>
	 * 
	 * @author kaoru.kawashima
	 * 
	 */
	public class ExpandableView extends Canvas
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event type "viewchange."
		 */
		public static const VIEWCHANGE:String = "viewchange";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function ExpandableView()
		{
			
			super();
			
			// Event listeners
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _created:Boolean = false;
		
		/**
		 * @private
		 */
		private var _fullview:Boolean = false;
		
		/**
		 * @private
		 */
		private var _thumbnailComponent:UIComponent = new UIComponent();
		
		/**
		 * @prvate
		 * Width of the content when it is expanded to full view.
		 */
		private var _fullViewPercentWidth:Number;
		
		/**
		 * @private
		 * Height of the content when it is expanded to full view.
		 */
		private var _fullViewPercentHeight:Number;
		
		/**
		 * @private
		 * Full view components.  This is different from getChildren method because it will always hold
		 * components that display for full view.
		 */
		private var _allFullViewComponents:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable("heightChanged")]
	    [Inspectable(category="General")]
	    [PercentProxy("percentHeight")]
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			
			return super.height;
			
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			
			super.height = value;
			
		}
		
		[Bindable("widthChanged")]
	    [Inspectable(category="General")]
	    [PercentProxy("percentWidth")]
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			
			return super.width;
			
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			
			super.width = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable]
		/**
		 * Array containing references to the DisplayObjecs within this ExpandableView that are not
		 * removed when the view is shrunk down to the thumbnail view.
		 */
		public var itemsNotRemovedForThumbnailView:Array;
		
		[Bindable(event="viewchange")]
		/**
		 * true if fullview view is displayed, false if thumbnail view is displayed.  Default value is false.
		 */
		public function get fullview():Boolean
		{
			
			return _fullview;
			
		}
		
		/**
		 * @private
		 */
		public function set fullview(value:Boolean):void
		{
			
			_fullview = value;
			
			if (_fullview)
			{
				
				addAllFullViewItemsToView();
				if (_thumbnailComponent.parent == this)
				{
					
					//removeChild(_thumbnailComponent);
					_thumbnailComponent.visible = false;
					_thumbnailComponent.includeInLayout = false;
					
				}
				
			}
			else
			{
				
				removeAllFullViewItemsFromView();
				addChild(_thumbnailComponent);
				_thumbnailComponent.visible = true;
				_thumbnailComponent.includeInLayout = true;
				
			}
			
			dispatchEvent(new Event(VIEWCHANGE));
			
		}
		
		/**
		 * View to display when fullview == false.
		 */		
		public function get thumbnailComponent():UIComponent
		{
			
			return _thumbnailComponent;
			
		}
		
		/**
		 * @private
		 */
		public function set thumbnailComponent(value:UIComponent):void
		{
			
			if (_thumbnailComponent != value)
			{
				
				if (value == null)
					value = new UIComponent(); // Thumbnail cannot be null, so use empty UIComponent for now
				
				// Add to ExpandableView temporarily
				if ((_thumbnailComponent == null) && (_thumbnailComponent.parent != null))
				{
					
					// Remove previous thumbnail component
					_thumbnailComponent.parent.removeChild(_thumbnailComponent);
					
				}
				
				_thumbnailComponent = value;
				
				// Add new thumbnail
				addChild(_thumbnailComponent);
				
				// so this line can figure out the size of thumbnail
				_thumbnailComponent.validateNow();
				
				// then immediately remove it if ExpandableView is not in thumbnail state
				if (_fullview)
					removeChild(_thumbnailComponent);
				
			}
			
		}
		
		[Bindable(event="fullViewUpdated")]
		/**
		 * Array containing all items in the full view.  This is different from <code>getChildren</code> method because
		 * it will always hold components that display for full view.
		 */
		public function get allFullViewComponents():Array
		{
			
			var temp:Array = [];
			var numItems:uint = _allFullViewComponents.length;
			for (var i:uint = 0; i < numItems; i++)
			{
				
				temp.push(_allFullViewComponents[i].component);
				
			}
			
			return temp;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			
			addAllFullViewItemsToView(); // Temporarily add everything so the item is placed at the right index
			
			if (child.parent != null)
				child.parent.removeChild(child); // Remove it first
			
			// Make sure nothing gets placed on top of the thumbnail
			if ((child != _thumbnailComponent) && (_thumbnailComponent.parent == this) && (index >= this.getChildIndex(_thumbnailComponent)))
				index = this.getChildIndex(_thumbnailComponent);
			
			if (index > numChildren)
				index = numChildren; // Make sure child stays within range
			
			var newItem:DisplayObject = child;
			if (!((numChildren == 1) && (child.parent != null) && (child.parent == this)))
				newItem = super.addChildAt(child, index);
			
			// and remember all full view items
			_allFullViewComponents = rememberAllChildren();
			
			if (!_fullview)
			{
				
				// Currently in thumbnail view, so remove all full view items
				removeAllFullViewItemsFromView();
				
			}
			
			dispatchEvent(new Event("fullViewUpdated"));
			
			return newItem;
			
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			
			addAllFullViewItemsToView(); // Temporarily add everything
			var newItem:DisplayObject = super.removeChild(child);
			
			// and remember the full view items
			_allFullViewComponents = rememberAllChildren();
			
			if (!_fullview)
			{
				
				// Currently in thumbnail view, so remove all full view items
				removeAllFullViewItemsFromView();
				
			}
			
			dispatchEvent(new Event("fullViewUpdated"));
			
			return newItem;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Adds all items belonging to full view.
		 */
		private function addAllFullViewItemsToView():void
		{
			
			var numItems:uint = _allFullViewComponents.length;
			for (var i:uint = 0; i < numItems; i++)
			{
				
				_allFullViewComponents[i].component.includeInLayout = _allFullViewComponents[i].includeInLayout;
				
				_allFullViewComponents[i].component.visible = _allFullViewComponents[i].visible;
				
			}
			
		}
		
		/**
		 * @private
		 * Removes all items that is not thumbnailComponent.
		 */
		private function removeAllFullViewItemsFromView():void
		{
			
			var numItems:uint = _allFullViewComponents.length;
			for (var i:uint = 0; i < numItems; i++)
			{
				
				if ((itemsNotRemovedForThumbnailView == null) || (itemsNotRemovedForThumbnailView.indexOf(_allFullViewComponents[i].component) == -1))
				{
					
					// Remove by changing includeInLayout to false
					_allFullViewComponents[i].component.includeInLayout = false;
					
					_allFullViewComponents[i].component.visible = false;
					
				}
				
			}
			
		}
		
		/**
		 * @private
		 * Builds array of {component: child item, includeInLayout: child.includeInLayout}
		 */
		private function rememberAllChildren():Array
		{
			
			// Extract all the children
			var allItems:Array = super.getChildren().concat();
			if (allItems.indexOf(_thumbnailComponent) != -1) // but not thumbnail
				allItems.splice(allItems.indexOf(_thumbnailComponent), 1);
			
			var numItems:uint = allItems.length;
			for (var i:uint = 0; i < numItems; i++)
			{
				
				allItems[i] = {component: allItems[i]};
				
				if (allItems[i].component.hasOwnProperty("includeInLayout"))
					allItems[i].includeInLayout = allItems[i].component.includeInLayout;
				
				if (allItems[i].component.hasOwnProperty("visible"))
					allItems[i].visible = allItems[i].component.visible;
				
			}
			
			return allItems;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onCreationComplete(event:FlexEvent):void
		{
			
			if (!_fullview)
			{
				
				// Make sure thumbnail is displaying
				
			}
			
			_created = true;
			
		}
		
	}
	
}