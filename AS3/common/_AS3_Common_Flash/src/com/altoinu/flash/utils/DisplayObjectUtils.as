/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	import com.altoinu.flash.utils.collections.LinkedList;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Utility functions you can use on DisplayObjects.
	 */
	public class DisplayObjectUtils
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Rotates DisplayObject around a specific point.
		 * 
		 * @param m
		 * @param x
		 * @param y
		 * @param angleDegrees
		 * 
		 */
		public static function rotateAroundInternalPoint(targetDisplayObject:DisplayObject, x:Number, y:Number, angleDegrees:Number):void
		{
			
			var transformMatrix:Matrix = targetDisplayObject.transform.matrix;
			transformMatrix.translate(-x, -y);
			transformMatrix.rotate(angleDegrees * Math.PI / 180);
			transformMatrix.translate(x, y);
			targetDisplayObject.transform.matrix = transformMatrix;
			
		}
		
		/**
		 * Function for getting all display children of a class type and returned as an Array.
		 * 
		 * @params target, classRef
		 */
		public static function getChildrenOfType(target:DisplayObjectContainer, classRef:Class, recursive:Boolean=false):Array
		{
			
			var itemsCache:Array = [];
			for (var i:int = 0; i < target.numChildren; i++) {
				if ( recursive && target.getChildAt(i) is DisplayObjectContainer ) {
					var append:Array = getChildrenOfType( DisplayObjectContainer(target.getChildAt(i)), classRef, true);
					if (append.length > 0) for ( var item:String in append) itemsCache.push(append[item]);
				}
				if (target.getChildAt(i) is classRef) {
					itemsCache.push( target.getChildAt(i) );
				}
			}
			return itemsCache;
			
		}
		
		public static function doesHaveType(target:DisplayObjectContainer, classRef:Class, recursive:Boolean=false):Boolean
		{
			
			for (var i:int = 0; i < target.numChildren; i++) {
				if ( recursive && target.getChildAt(i) is DisplayObjectContainer ) {
					var append:Array = getChildrenOfType( DisplayObjectContainer(target.getChildAt(i)), classRef, true);
					if (append.length > 0) for ( var item:String in append) return true;
				}
				if (target.getChildAt(i) is classRef) {
					return true;
				}
			}
			return false;
			
		}
		
		public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject
		{
			
			// create duplicate
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
			
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			
			if (target.scale9Grid)
			{
				var rect:Rectangle = target.scale9Grid;
				// WAS Flash 9 bug where returned scale9Grid is 20x larger than assigned
				// rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent)
				target.parent.addChild(duplicate);
			
			return duplicate;
			
		}
		
		/**
		 * Finds the relative coordinates of the parent based on a point relative to the child. While using localToGlobal, and globalToLocal are more efficient,
		 * this method will work when the display objects are not on the stage.
		 * @param child
		 * @param parent
		 * @param childPt
		 * @return 
		 * 
		 */
		public static function relativeCoordinates(child:DisplayObject,parent:DisplayObjectContainer=null,childPt:Point=null):Point
		{
			if(!parent)
				parent = child.parent;
			if(!parent)
			{
				throw new Error("Child does not have a parent!");
				return null;
			}
			if(!parent.contains(child))
			{
				throw new Error("Parent does not contain child!");
			}
			
			if(!childPt)
				childPt = new Point();
			
			do
			{
				
				childPt = child.transform.matrix.transformPoint(childPt);
				child = child.parent;

			}while(child != null && child != parent);
			
			
			return childPt;
			
		}
		
		
		/**
		 * 	Returns an Array of all the parents of the specified
		 * display object. The first item in the list is obj, and the
		 * last item is the last parent.
		 *	
		 */
		public static function getHierarchyArray(obj:DisplayObject):Array
		{
			var rtrn:Array = [];
			
			if(!obj)
				return null;
			
			rtrn.push(obj);
			
			var nextItems:Array = getHierarchyArray(obj as DisplayObject);
			if(nextItems)
			{
				rtrn = rtrn.concat(nextItems);
			}
			
			return rtrn;
		}
		
		/**
		 * 	Returns a LinkedList of all the parents of the specified
		 * display object. The first item in the list is obj, and the
		 * last item is the last parent.
		 *	
		 */
		public static function getHierarchyList(obj:DisplayObject):LinkedList
		{
			var rtrn:LinkedList = new LinkedList();
			
			if(!obj)
				return null;
			
			rtrn.item = obj;
			
			rtrn.next = getHierarchyList(obj.parent as DisplayObject);
			if(rtrn.next)
				rtrn.next.prev = rtrn;
			
			return rtrn;
		}
		
		/**
		 * 	Returns true if the child is a child, grandchild, etc., of the parent.
		 */
		public static function isChildOf(child:DisplayObject,parent:Object):Boolean
		{
			if(!child.parent)
				return false;
			if(child.parent == parent)
				return true;
			
			return isChildOf(child.parent,parent);
			
		}
		
		/**
		 *	Returns true if any of the child's parents is a of type "type"
		 */
		public static function isChildOfType(child:DisplayObject,type:Class):Boolean
		{
			if(!child)
				return false;
			if(child is type)
				return true;
			
			return isChildOfType(child.parent,type);
		}

		/**
		 * 	Returns true if the object can receive mouse events.
		 */
		public static function canReceiveMouseEvents(obj:InteractiveObject):Boolean
		{
			if(!obj.mouseEnabled)
				return false;
			
			
			var parent:DisplayObjectContainer;
			parent = obj.parent;
			while(parent)
			{
				if(!parent.mouseChildren)
					return false;
				
				parent = parent.parent;
			}
			
			return true;
		}
		
		/**
		 * Scales the display object to fit the toWidth and toHeight. 
		 * 
		 * @param dObj
		 * @param toWidth
		 * @param toHeight
		 * 
		 */		
		public static function scaleToFit(dObj:DisplayObject,toWidth:Number,toHeight:Number):void
		{
			var origBounds:Rectangle = dObj.getBounds(dObj);


			if(origBounds.width / origBounds.height > toWidth / toHeight)
			{
				dObj.scaleX = toWidth / origBounds.width;
				dObj.scaleY = dObj.scaleX;
			}
			else
			{
				dObj.scaleY = toHeight / origBounds.height;
				dObj.scaleX = dObj.scaleY;
			}
		}
		
		/**
		 * Scales the display object to fit the toWidth and toHeight so that display object
		 * fills the entire area. 
		 * 
		 * @param dObj
		 * @param toWidth
		 * @param toHeight
		 * 
		 */		
		public static function scaleToCrop(dObj:DisplayObject,toWidth:Number,toHeight:Number):void
		{
			var origBounds:Rectangle = dObj.getBounds(dObj);
			
			if(origBounds.width / origBounds.height > toWidth / toHeight)
			{
				dObj.scaleY = toHeight / origBounds.height;
				dObj.scaleX = dObj.scaleY;
			}
			else
			{
				dObj.scaleX = toWidth / origBounds.width;
				dObj.scaleY = dObj.scaleX;
			}

		}
				
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * Constructor.  You do not create an instance of this class... just call its static functions
		 */
		public function DisplayObjectUtils()
		{
			
			throw("You do not create an instance of DisplayObjectUtils.  Just call its static functions");
			
		}
		
	}
	
}
	