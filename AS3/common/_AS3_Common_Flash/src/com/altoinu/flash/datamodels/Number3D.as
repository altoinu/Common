/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.datamodels
{
	
	import flash.events.EventDispatcher;

	/**
	 * Represents number in 3D space.
	 * @author Kaoru Kawashima
	 * 
	 */
	public class Number3D extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns a Number3D object with x, y and z properties set to zero.
		 *
		 * @return A Number3D object.
		 */
		public static function get ZERO():Number3D
		{
			
			return new Number3D(0, 0, 0);
			
		}
		
		public static function add(n:Number3D, m:Number3D):Number3D
		{
			
			return new Number3D(n.x + m.x, n.y + m.y, n.z + m.z);
			
		}
		
		public static function subtract(n:Number3D, m:Number3D):Number3D
		{
			
			return new Number3D(n.x - m.x, n.y - m.y, n.z - m.z);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param x
		 * @param y
		 * @param z
		 * 
		 */
		public function Number3D(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			
			_x = x;
			_y = y;
			_z = z;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  x
		//----------------------------------
		
		private var _x:Number = 0;
		
		/**
		 * x direction vector.
		 */
		public function get x():Number
		{
			
			return _x;
			
		}
		
		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			
			_x = value;
			
		}
		
		//----------------------------------
		//  y
		//----------------------------------
		
		private var _y:Number = 0;
		
		/**
		 * y direction vector.
		 */
		public function get y():Number
		{
			
			return _y;
			
		}
		
		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			
			_y = value;
			
		}
		
		//----------------------------------
		//  z
		//----------------------------------
		
		private var _z:Number = 0;
		
		/**
		 * z direction vector.
		 */
		public function get z():Number
		{
			
			return _z;
			
		}
		
		/**
		 * @private
		 */
		public function set z(value:Number):void
		{
			
			_z = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[Number3D: " + x + "," + y + "," + z + "]";
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function clone():Number3D
		{
			
			return new Number3D(x, y, z);
			
		}
		
		/**
		 * Normalize.
		 */
		public function normalize():void
		{
			
			var mod:Number = Math.sqrt( this.x*this.x + this.y*this.y + this.z*this.z );
			
			if ( mod != 0 && mod != 1)
			{
				
				mod = 1 / mod; // mults are cheaper then divs
				this.x *= mod;
				this.y *= mod;
				this.z *= mod;
				
			}
			
		}
		
		public function multiply(value:Number):void
		{
			
			x *= value;
			y *= value;
			z *= value;
			
		}
		
		public function plus(value:Number):void
		{
			
			x += value;
			y += value;
			z += value;
			
		}
		
		public function minus(value:Number):void
		{
			
			x -= value;
			y -= value;
			z -= value;
			
		}
		
		/**
		 * Checks to see if target Number3D is at the same x y z.
		 * @param target
		 * @return 
		 * 
		 */
		public function isEqual(target:Number3D):Boolean
		{
			
			return (x == target.x) && (y == target.y) && (z == target.z);
			
		}
		
	}
	
}