/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	import com.altoinu.flash.datamodels.Vector3DSpace;
	
	import flash.geom.Rectangle;
	
	/**
	 * Math related utility functions.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class MathUtils
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns random integer between min and max.
		 * @param min Minimum number.
		 * @param max Maximum number.
		 * @return 
		 * 
		 */
		public static function randRange(min:Number, max:Number):Number
		{
			
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
			
		}
		
		/**
		 * Returns array of random integers.
		 * @param min Minimum number.
		 * @param max Maximum number.
		 * @param numIntegers Number of random integers to generate.
		 * @param duplicates If true, then the resulting array may contain two or more integers with same value.
		 * If false, then no integers will match.  When false, this will throw an error if the number of integers
		 * between min and max (max - min + 1) is less than numIntegers.
		 * @return 
		 * 
		 */
		public static function getMultipleRandomNum(min:Number, max:Number, numIntegers:uint = 1, duplicates:Boolean = true):Array
		{
			
			if (!duplicates && (max - min + 1 < numIntegers))
				throw new Error("Range specified for getMultipleRandomNum is too small to generate Array of numIntegers random integers.");
			
			var randomNumArray:Array = [];
			for (var i:int = 0; i < numIntegers; i++)
			{
				
				var randomNum:Number;
				do
				{
					
					randomNum = randRange(min, max);
					
				}
				while (randomNumArray.indexOf(randomNum) != -1)
				
				randomNumArray.push(randomNum);
				
			}
			
			return randomNumArray;
			
		}
		
		public static function convertRadianToDegree(radian:Number):Number
		{
			
			return radian / (2 * Math.PI) * 360;
			
		}
		
		public static function convertDegreeToRadian(degree:Number):Number
		{
			
			return degree / 360 * (2 * Math.PI);
			
		}
		
		[Deprecated(replacement="Vector3DSpace.dotProduct")]
		/**
		 * Calculates dot product.
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function dotProduct(vector1:Vector3DSpace, vector2:Vector3DSpace):Number
		{
			
			return Vector3DSpace.dotProduct(vector1, vector2);
			
		}
		
		[Deprecated(replacement="Vector3DSpace.crossProduct")]
		/**
		 * Calculates cross product of two vectors.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function crossProduct(vector1:Vector3DSpace, vector2:Vector3DSpace):Vector3DSpace
		{
			
			return Vector3DSpace.crossProduct(vector1, vector2);
			
		}
		
		[Deprecated(replacement="Vector3DSpace.angleBetweenVectors")]
		/**
		 * Calculates angle in radians between two vectors.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function angleBetweenVectors(vector1:Vector3DSpace, vector2:Vector3DSpace):Number
		{
			
			return Vector3DSpace.angleBetweenVectors(vector1, vector2);
			
		}
		
		[Deprecated(replacement="Vector3DSpace.areParallel")]
		/**
		 * Checks to see if two vectors are parallel to each other.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function areParallel(vector1:Vector3DSpace, vector2:Vector3DSpace):Boolean
		{
			
			return Vector3DSpace.areParallel(vector1, vector2);
			
		}
		
		[Deprecated(replacement="Vector3DSpace.areParallelSameDirection")]
		/**
		 * Checks to see if two vectors are parallel to each other and also pointing towards the same direction.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function areParallelSameDirection(vector1:Vector3DSpace, vector2:Vector3DSpace):Boolean
		{
			
			return Vector3DSpace.areParallelSameDirection(vector1, vector2);
			
		}
		
		[Deprecated(replacement="Vector3DSpace.areParallelOppositeDirection")]
		/**
		 * Checks to see if two axes are parallel to each other but pointing in opposite direction.
		 * 
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function areParallelOppositeDirection(vector1:Vector3DSpace, vector2:Vector3DSpace):Boolean
		{
			
			return Vector3DSpace.areParallelOppositeDirection(vector1, vector2);
			
		}
		
		[Deprecated(replacement="Vector3DSpace.areOrthogonal")]
		/**
		 * Checks to see if two axes are orthogonal (meeting at right angles) to each other.
		 * @param vector1
		 * @param vector2
		 * @return 
		 * 
		 */
		public static function areOrthogonal(vector1:Vector3DSpace, vector2:Vector3DSpace):Boolean
		{
			
			return Vector3DSpace.areOrthogonal(vector1, vector2);
			
		}
		
		/**
		 * Given container rectangle defined by <code>containerRect</code>, find scale that allows a rectangle defined by
		 * <code>targetRectOriginalSize</code> to fit exactly in that container.
		 * 
		 * @param targetRectOriginalSize
		 * @param containerRect
		 * @return 
		 * 
		 */
		public static function getFitScale(targetRectOriginalSize:Rectangle, containerRect:Rectangle):Number
		{
			
			var fit_scale_x:Number = containerRect.width / targetRectOriginalSize.width;
			var fit_scale_y:Number = containerRect.height / targetRectOriginalSize.height;
			
			return Math.floor((fit_scale_x <= fit_scale_y ? fit_scale_x : fit_scale_y) * 100) / 100;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * Constructor.  You do not create an instance of this class... just call its static functions
		 */
		public function MathUtils()
		{
			
			throw("You do not create an instance of MathUtils.  Just call its static functions");
			
		}
		
	}
	
}