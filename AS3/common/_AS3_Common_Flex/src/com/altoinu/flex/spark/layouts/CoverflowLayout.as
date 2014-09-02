/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.spark.layouts
{
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import mx.core.ILayoutElement;
	import mx.core.IStateClient;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.layouts.supportClasses.LayoutBase;
	
	/**
	 * Coverflow layout.
	 * 
	 * @see http://www.rialvalue.com/blog/2010/03/30/flex4-coverflow-layout/
	 * @author Kaoru Kawashima
	 * 
	 */
	public class CoverflowLayout extends LayoutBase
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private static const ANIMATION_STEPS:int = 24; // fps
		private static const RIGHT_SIDE:int = -1;
		private static const LEFT_SIDE:int = 1;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function CoverflowLayout()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var finalMatrices:Vector.<Matrix3D>;
		private var leftMostIndex:int = -1;
		private var rightMostIndex:int = -1;
		private var centerX:Number;
		private var centerY:Number;
		private var transitionTimer:Timer;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  perspectiveProjectionX
		//----------------------------------
		
		private var _perspectiveProjectionX:Number = NaN;
		
		[Bindable(event="perspectiveProjectionXChange")]
		/**
		 * X coordinate of the two-dimensional point representing the center of the
		 * projection, the vanishing point for the display object.
		 */
		public function get perspectiveProjectionX():Number
		{
			
			return _perspectiveProjectionX;
			
		}
		
		/**
		 * @private
		 */
		public function set perspectiveProjectionX(value:Number):void
		{
			
			_perspectiveProjectionX = value;
			invalidateTarget();
			
			dispatchEvent(new Event("perspectiveProjectionXChange"));
			
		}
		
		//----------------------------------
		//  perspectiveProjectionY
		//----------------------------------
		
		private var _perspectiveProjectionY:Number = NaN;
		
		[Bindable(event="perspectiveProjectionYChange")]
		/**
		 * Y coordinate of the two-dimensional point representing the center of the
		 * projection, the vanishing point for the display object.
		 */
		public function get perspectiveProjectionY():Number
		{
			
			return _perspectiveProjectionY;
			
		}
		
		/**
		 * @private
		 */
		public function set perspectiveProjectionY(value:Number):void
		{
			
			_perspectiveProjectionY = value;
			invalidateTarget();
			dispatchEvent(new Event("perspectiveProjectionYChange"));
			
		}
		
		//----------------------------------
		//  horizontalCenter
		//----------------------------------
		
		private var _horizontalCenter:Number = 0;
		
		[Bindable(event="horizontalCenterChange")]
		/**
		 * Horizontal offset from center within the container group.
		 */
		public function get horizontalCenter():Number
		{
			
			return _horizontalCenter;
			
		}
		
		/**
		 * @private
		 */
		public function set horizontalCenter(value:Number):void
		{
			
			_horizontalCenter = value;
			invalidateTarget();
			dispatchEvent(new Event("horizontalCenterChange"));
			
		}
		
		//----------------------------------
		//  verticalCenter
		//----------------------------------
		
		private var _verticalCenter:Number = 0;
		
		[Bindable(event="verticalCenterChange")]
		/**
		 * Vertical offset from center within the container group.
		 */
		public function get verticalCenter():Number
		{
			
			return _verticalCenter;
			
		}
		
		/**
		 * @private
		 */
		public function set verticalCenter(value:Number):void
		{
			
			_verticalCenter = value;
			invalidateTarget();
			dispatchEvent(new Event("verticalCenterChange"));
			
		}
		
		//----------------------------------
		//  focalLength
		//----------------------------------
		
		private var _focalLength:Number = 300;
		
		[Bindable(event="focalLengthChange")]
		/**
		 * @copy flash.geom.PerspectiveProjection#focalLength
		 */
		public function get focalLength():Number
		{
			
			return _focalLength;
			
		}
		
		/**
		 * @private
		 */
		public function set focalLength(value:Number):void
		{
			
			_focalLength = value;
			invalidateTarget();
			dispatchEvent(new Event("focalLengthChange"));
			
		}
		
		//----------------------------------
		//  elementRotation
		//----------------------------------
		
		private var _elementRotation:Number = -45;
		
		[Bindable(event="elementRotationChange")]
		/**
		 * Rotation in degrees of non-selected elements.
		 */
		public function get elementRotation():Number
		{
			
			return _elementRotation;
			
		}
		
		/**
		 * @private
		 */
		public function set elementRotation(value:Number):void
		{
			
			_elementRotation = value;
			invalidateTarget();
			dispatchEvent(new Event("elementRotationChange"));
			
		}
		
		//----------------------------------
		//  mirrorElementRotation
		//----------------------------------
		
		private var _mirrorElementRotation:Boolean = true;
		
		[Bindable(event="mirrorElementRotationChange")]
		/**
		 * When true, non-selected elements are rotated by <code>elementRotation</code> degrees
		 * to face each other (like iTunes coverflow) while false would make all elements rotate
		 * to face same direction.
		 * 
		 * @default true
		 */
		public function get mirrorElementRotation():Boolean
		{
			
			return _mirrorElementRotation;
			
		}
		
		/**
		 * @private
		 */
		public function set mirrorElementRotation(value:Boolean):void
		{
			
			_mirrorElementRotation = value;
			invalidateTarget();
			dispatchEvent(new Event("mirrorElementRotationChange"));
			
		}
		
		//----------------------------------
		//  horizontalDistance
		//----------------------------------
		
		private var _horizontalDistance:Number = 100;
		
		[Bindable(event="horizontalDistanceChange")]
		/**
		 * Distance between elements.
		 */
		public function get horizontalDistance():Number
		{
			
			return _horizontalDistance;
			
		}
		
		/**
		 * @private
		 */
		public function set horizontalDistance(value:Number):void
		{
			
			_horizontalDistance = value;
			invalidateTarget();
			dispatchEvent(new Event("horizontalDistanceChange"));
			
		}
		
		//----------------------------------
		//  depthDistance
		//----------------------------------
		
		private var _depthDistance:Number = 1;
		
		[Bindable(event="depthDistanceChange")]
		/**
		 * How far away non-selected elements will be from viewing camera.
		 */
		public function get depthDistance():Number
		{
			
			return _depthDistance;
			
		}
		
		/**
		 * @private
		 */
		public function set depthDistance(value:Number):void
		{
			
			_depthDistance = value;
			invalidateTarget();
			dispatchEvent(new Event("depthDistanceChange"));
			
		}
		
		//----------------------------------
		//  selectedItemProximity
		//----------------------------------
		
		private var _selectedItemProximity:Number = 0;
		
		[Bindable(event="selectedItemProximityChange")]
		/**
		 * How close selected item is close to camera. Bigger number causes selected item to be closer to viewing camera.
		 */
		public function get selectedItemProximity():Number
		{
			
			return _selectedItemProximity;
			
		}
		
		/**
		 * @private
		 */
		public function set selectedItemProximity(value:Number):void
		{
			
			_selectedItemProximity = value;
			invalidateTarget();
			dispatchEvent(new Event("selectedItemProximityChange"));
			
		}
		
		//----------------------------------
		//  selectedIndex
		//----------------------------------
		
		private var _selectedIndex:int = -1;
		
		[Bindable(event="selectedIndexChange")]
		/**
		 * Index number of element to display as selected by facing front.
		 */
		public function get selectedIndex():Number
		{
			
			return _selectedIndex;
			
		}
		
		/**
		 * @private
		 */
		public function set selectedIndex(value:Number):void
		{
			
			_selectedIndex = value;
			invalidateTarget();
			dispatchEvent(new Event("selectedIndexChange"));
			
		}
		
		//----------------------------------
		//  transitionDuration
		//----------------------------------
		
		private var _transitionDuration:Number = 700;
		
		[Bindable(event="transitionDurationChange")]
		/**
		 * Time in milliseconds elements slides to next one when selection is changed.
		 */
		public function get transitionDuration():Number
		{
			
			return _transitionDuration;
			
		}
		
		/**
		 * @private
		 */
		public function set transitionDuration(value:Number):void
		{
			
			if (_transitionDuration != value)
			{
				
				_transitionDuration = value;
				
				if (transitionTimer != null)
				{
					
					// Clear previous timer
					transitionTimer.removeEventListener(TimerEvent.TIMER, animationTickHandler);
					transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, animationTimerCompleteHandler);
					transitionTimer = null;
					
				}
				
				invalidateTarget();
				dispatchEvent(new Event("transitionDurationChange"));
				
			}
			
		}
		
		//----------------------------------
		//  numElementsLeft
		//----------------------------------
		
		private var _numElementsLeft:int = -1;
		
		[Bindable(event="numElementsLeftChange")]
		/**
		 * Maximum number of elements to display on the left side of element at <code>selectedIndex</code>.
		 * It may become necessary to set this for performance if the group contains large number of elements
		 *  Set to negative number to display all.
		 * 
		 * @default -1
		 */
		public function get numElementsLeft():int
		{
			
			return _numElementsLeft;
			
		}
		
		/**
		 * @private
		 */
		public function set numElementsLeft(value:int):void
		{
			
			_numElementsLeft = value;
			invalidateTarget();
			dispatchEvent(new Event("numElementsLeftChange"));
			
		}
		
		//----------------------------------
		//  numElementsRight
		//----------------------------------
		
		private var _numElementsRight:int = -1;
		
		[Bindable(event="numElementsRightChange")]
		/**
		 * Maximum number of elements to display on the right side of element at <code>selectedIndex</code>.
		 * It may become necessary to set this for performance if the group contains large number of elements
		 *  Set to negative number to display all.
		 * 
		 * @default -1
		 */
		public function get numElementsRight():int
		{
			
			return _numElementsRight;
			
		}
		
		/**
		 * @private
		 */
		public function set numElementsRight(value:int):void
		{
			
			_numElementsRight = value;
			invalidateTarget();
			dispatchEvent(new Event("numElementsRightChange"));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function invalidateTarget():void
		{
			
			if (target)
			{
				
				target.invalidateDisplayList();
				target.invalidateSize();
				
			}
			
		}
		
		
		private function centerPerspectiveProjection(width:Number, height:Number):void
		{
			
			var perspectiveProjection:PerspectiveProjection = new PerspectiveProjection();
			var perspectiveX:Number = isFinite(_perspectiveProjectionX) ? _perspectiveProjectionX : width / 2;
			var perspectiveY:Number = isFinite(_perspectiveProjectionY) ? _perspectiveProjectionY : height / 2;
			perspectiveX += horizontalCenter;
			perspectiveY += verticalCenter;
			
			perspectiveProjection.projectionCenter = new Point(perspectiveX, perspectiveY);
			perspectiveProjection.focalLength = _focalLength;
			
			target.transform.perspectiveProjection = perspectiveProjection;
			
		}
		
		
		private function positionCentralElement(element:ILayoutElement, width:Number, height:Number):Matrix3D
		{
			
			element.setLayoutBoundsSize(NaN, NaN, false);
			var elementWidth:Number = element.getLayoutBoundsWidth(false);
			var elementHeight:Number = element.getLayoutBoundsHeight(false);
			
			centerX = (width - elementWidth) / 2 + horizontalCenter;
			centerY = (height - elementHeight) / 2  + verticalCenter;
			
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendTranslation(centerX, centerY, -_selectedItemProximity);
			
			element.setLayoutBoundsSize(NaN, NaN, false);
			
			if (element is IVisualElement)
				IVisualElement(element).depth = 10;
			
			return matrix;
			
		}
		
		
		private function positionLateralElement(element:ILayoutElement, index:int, side:int, zPositionOverride:Number = NaN):Matrix3D
		{
			
			element.setLayoutBoundsSize(NaN, NaN, false);
			
			var matrix:Matrix3D = new Matrix3D();
			var elementWidth:Number = element.getLayoutBoundsWidth(false);
			var elementHeight:Number = element.getLayoutBoundsHeight(false);
			
			var zPosition:Number = (isFinite(zPositionOverride) ? zPositionOverride : index) * depthDistance;
			
			if ((side == RIGHT_SIDE) || !mirrorElementRotation)
			{
				
				matrix.appendTranslation(-elementWidth, 0, 0);
				matrix.appendRotation(RIGHT_SIDE * elementRotation, Vector3D.Y_AXIS);
				matrix.appendTranslation(elementWidth, 0, 0);
				
			}
			else
			{
				
				matrix.appendRotation(side * elementRotation, Vector3D.Y_AXIS);
				
			}
			
			matrix.appendTranslation(centerX - side * (index) * horizontalDistance, centerY, zPosition);
			
			if (element is IVisualElement)
				IVisualElement(element).depth = -zPosition;
			
			return matrix;
			
			// This line would find out if element is already at specified pos or not
			// if (element.getLayoutMatrix3D().position.x != matrix.position.x)  // element is already at specified position
			
		}
		
		private function playTransition():void
		{
			
			if (transitionTimer)
			{
				
				transitionTimer.stop();
				transitionTimer.reset();
				
			}
			else
			{
				
				transitionTimer = new Timer(transitionDuration / ANIMATION_STEPS, ANIMATION_STEPS);
				transitionTimer.addEventListener(TimerEvent.TIMER, animationTickHandler);
				transitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animationTimerCompleteHandler);
				
			}
			
			transitionTimer.start();
			
		}
		
		/**
		 * Interpolate elements from startIndex to endIndex (but not including endIndex) to specified percent
		 * @param percent
		 * @param startIndex
		 * @param endIndex
		 * 
		 */
		private function translateElementsToFinalSpot(percent:Number, startIndex:int, endIndex:int):void
		{
			
			var initialMatrix:Matrix3D;
			var finalMatrix:Matrix3D;
			var element:ILayoutElement;
			
			if (startIndex < 0)
				startIndex = 0;
			
			if (finalMatrices.length < endIndex)
				endIndex = finalMatrices.length;
			
			for (var i:int = startIndex; i < endIndex; i++)
			{
				
				finalMatrix = finalMatrices[i];
				element = target.getVirtualElementAt(i);
				
				if (finalMatrix)
				{
					
					// transition matrix is specified, so move the element
					//UIComponent(element).visible = true;
					moveElement(element as UIComponent, finalMatrix, percent);
					
					/*
					initialMatrix = UIComponent(element).transform.matrix3D;
					initialMatrix.interpolateTo(finalMatrix, percent);
					element.setLayoutMatrix3D(initialMatrix, false);
					*/
					
				}
				else
				{
					
					//UIComponent(element).visible = false;
					
				}
				
			}
			
		}
		
		/**
		 * Interpolate specified element to specified percent of finalMatrix
		 * @param element
		 * @param finalMatrix
		 * @param percent
		 * 
		 */
		private function moveElement(element:UIComponent, finalMatrix:Matrix3D, percent:Number):void
		{
			
			var initialMatrix:Matrix3D = element.transform.matrix3D;
			initialMatrix.interpolateTo(finalMatrix, percent);
			element.setLayoutMatrix3D(initialMatrix, false);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function updateDisplayList(width:Number, height:Number):void
		{
			
			var i:int = 0; // loop vars
			var j:int = 0;
			
			var numElements:int = target.numElements;
			var matrix:Matrix3D;
			
			if (numElements > 0)
			{
				
				centerPerspectiveProjection(width, height);
				
				finalMatrices = new Vector.<Matrix3D>(numElements);
				leftMostIndex = 0;
				rightMostIndex = numElements - 1;
				
				var element:IVisualElement;
				var midElement:int = selectedIndex <= -1 ? -1 : selectedIndex;
				if (midElement >= 0)
				{
					
					// Position selected element
					element = target.getVirtualElementAt(midElement);
					matrix = positionCentralElement(element, width, height);
					finalMatrices[midElement] = matrix;
					
					if (element is IStateClient)
						IStateClient(element).currentState = "selected";
					
				}
				else
				{
					
					// Nothing selected
					// so just figure out where the center is
					var firstElement:ILayoutElement = target.getVirtualElementAt(0);
					firstElement.setLayoutBoundsSize(NaN, NaN, false);
					var elementWidth:Number = firstElement.getLayoutBoundsWidth(false);
					var elementHeight:Number = firstElement.getLayoutBoundsHeight(false);
					
					centerX = (width - elementWidth) / 2 + horizontalCenter;
					centerY = (height - elementHeight) / 2 + verticalCenter;
					
				}
				
				// Position elements left of selected one
				var currentElementIndex:int = midElement - 1;
				var edgeElementIndex:int = currentElementIndex - numElementsLeft + 1;
				if ((numElementsLeft < 0) || (edgeElementIndex < 0))
					edgeElementIndex = 0;
				
				var flowEdgeElementFound:Boolean = false;
				
				for (i = currentElementIndex; 0 <= i; i--)
				{
					
					element = target.getVirtualElementAt(i);
					
					if (i >= edgeElementIndex)
					{
						
						matrix = positionLateralElement(element, midElement - i, LEFT_SIDE);
						
					}
					else
					{
						
						// Any elements after edgeElementIndex will be positioned/stacked at left most since it is more than numElementsLeft away from mid element
						matrix = positionLateralElement(element, midElement - edgeElementIndex, LEFT_SIDE, midElement - i);
						
						if (!flowEdgeElementFound)
						{
							
							// This will be the index of the left most element that will actually be animate transitioned by coverflow
							leftMostIndex = i + 1;
							flowEdgeElementFound = true;
							
						}
						
					}
					
					finalMatrices[i] = matrix;
					
					if (element is IStateClient)
						IStateClient(element).currentState = "normal";
					
				}
				
				// Position elements right of selected one
				currentElementIndex = midElement + 1;
				edgeElementIndex = currentElementIndex + numElementsRight - 1;
				if ((numElementsRight < 0) || (edgeElementIndex > numElements - 1))
					edgeElementIndex = numElements - 1;
				
				flowEdgeElementFound = false;
				
				for (j = 1, i = currentElementIndex; i < numElements; i++, j++)
				{
					
					element = target.getVirtualElementAt(i);
					
					if (i <= edgeElementIndex)
					{
						
						matrix = positionLateralElement(element, j, RIGHT_SIDE);
						
					}
					else
					{
						
						// Any elements after edgeElementIndex will be positioned/stacked at right most since it is more than numElementsLeft away from mid element
						matrix = positionLateralElement(element, edgeElementIndex - currentElementIndex + 1, RIGHT_SIDE, j);
						
						if (!flowEdgeElementFound)
						{
							
							// This will be the index of the right most element that will actually be animate transitioned by coverflow
							rightMostIndex = i - 1;
							flowEdgeElementFound = true;
							
						}
						
					}
					
					finalMatrices[i] = matrix;
					
					if (element is IStateClient)
						IStateClient(element).currentState = "normal";
					
				}
				
				// To save on CPU, immediately move the elements that are going to be stacked on far left or far right
				if (leftMostIndex == midElement)
					leftMostIndex = -1;
				
				if (rightMostIndex + 1 == midElement)
					rightMostIndex++;
				
				translateElementsToFinalSpot(1, 0, leftMostIndex);
				translateElementsToFinalSpot(1, rightMostIndex + 1, numElements);
				
				for (i = 0; i < numElements; i++)
				{
					
					// Toggle visibility so only the ones between leftMostIndex and rightMostIndex are displayed
					target.getVirtualElementAt(i).visible = ((leftMostIndex <= i) && (i <= rightMostIndex));
					
				}
				
				// The rest will be transitioned by timer
				if (transitionDuration > 0)
					playTransition();
				else
					animationTimerCompleteHandler();
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function animationTickHandler(event:TimerEvent):void
		{
			
			translateElementsToFinalSpot(0.2, leftMostIndex, rightMostIndex + 1);
			
		}
		
		private function animationTimerCompleteHandler(event:TimerEvent = null):void
		{
			
			translateElementsToFinalSpot(1, leftMostIndex, rightMostIndex + 1);
			
			finalMatrices = null;
			
		}
		
	}
	
}