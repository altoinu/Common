/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.datamodels
{
	
	/**
	 * Acceleration.  The x, y, z values indicate (units/milliseconds ^ 2) and
	 * rotationX, rotationY, and rotationZ values indicate (degrees/milliseconds ^ 2).
	 * @author kaoru.kawashima
	 * 
	 */
	public class Acceleration extends Vector3DSpace
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param xA
		 * @param yA
		 * @param zA
		 * @param rotationXA
		 * @param rotationYA
		 * @param rotationZA
		 * 
		 */
		public function Acceleration(xA:Number = 0, yA:Number = 0, zA:Number = 0, rotationXA:Number = 0, rotationYA:Number = 0, rotationZA:Number = 0)
		{
			
			super(xA, yA, zA);
			_rotationX = rotationXA;
			_rotationY = rotationYA;
			_rotationZ = rotationZA;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  rotationX
		//----------------------------------
		
		private var _rotationX:Number = 0;
		
		/**
		 * rotationX velocity.
		 */
		public function get rotationX():Number
		{
			
			return _rotationX;
			
		}
		
		/**
		 * @private
		 */
		public function set rotationX(value:Number):void
		{
			
			_rotationX = value;
			
		}
		
		//----------------------------------
		//  rotationY
		//----------------------------------
		
		private var _rotationY:Number = 0;
		
		/**
		 * rotationY velocity.
		 */
		public function get rotationY():Number
		{
			
			return _rotationY;
			
		}
		
		/**
		 * @private
		 */
		public function set rotationY(value:Number):void
		{
			
			_rotationY = value;
			
		}
		
		//----------------------------------
		//  rotationZ
		//----------------------------------
		
		private var _rotationZ:Number = 0;
		
		/**
		 * rotationZ velocity.
		 */
		public function get rotationZ():Number
		{
			
			return _rotationZ;
			
		}
		
		/**
		 * @private
		 */
		public function set rotationZ(value:Number):void
		{
			
			_rotationZ = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function toString():String
		{
			
			return "[Acceleration x: "+x+" y: "+y+" z: "+z+" rotationX: "+rotationX+" rotationY: "+rotationY+" rotationZ: "+rotationZ+"]";
			
		}
		
		/**
		 * Creates a new instance of Acceleration using the same values.
		 * @return 
		 * 
		 */
		override public function clone():Number3D
		{
			
			return new Acceleration(x, y, z, rotationX, rotationY, rotationZ);
			
		}
		
	}
	
}