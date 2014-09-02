/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.datamodels
{
	
	import com.altoinu.flash.events.PhysicsEvent;
	
	/**
	 * Event dispatched when any of the x, y, z, rotationX, rotationY, or rotationZ velocity value changes.
	 * 
	 * @eventType com.altoinu.flash.events.PhysicsEvent.ACCELERATED
	 */
	[Event(name="accelerated", type="com.altoinu.flash.events.PhysicsEvent")]
	
	/**
	 * Velocity.  The x, y, z values indicate (units/millisecond) and
	 * rotationX, rotationY, and rotationZ values indicate (degrees/millisecond).
	 * @author kaoru.kawashima
	 * 
	 */
	public class Velocity extends Vector3DSpace
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param xV
		 * @param yV
		 * @param zV
		 * @param rotationXV
		 * @param rotationYV
		 * @param rotationZV
		 * 
		 */
		public function Velocity(xV:Number = 0, yV:Number = 0, zV:Number = 0, rotationXV:Number = 0, rotationYV:Number = 0, rotationZV:Number = 0)
		{
			
			super(xV, yV, zV);
			_rotationX = rotationXV;
			_rotationY = rotationYV;
			_rotationZ = rotationZV;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var suppressEvents:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  x
		//----------------------------------
		
		/**
		 * @private
		 */
		override public function set x(value:Number):void
		{
			
			var oldValues:Velocity = clone() as Velocity;
			
			super.x = value;
			
			if (!suppressEvents)
				dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			
		}
		
		//----------------------------------
		//  y
		//----------------------------------
		
		/**
		 * @private
		 */
		override public function set y(value:Number):void
		{
			
			var oldValues:Velocity = clone() as Velocity;
			
			super.y = value;
			
			if (!suppressEvents)
				dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			
		}
		
		//----------------------------------
		//  z
		//----------------------------------
		
		/**
		 * @private
		 */
		override public function set z(value:Number):void
		{
			
			var oldValues:Velocity = clone() as Velocity;
			
			super.z = value;
			
			if (!suppressEvents)
				dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			
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
			
			var oldValues:Velocity = clone() as Velocity;
			
			_rotationX = value;
			
			if (!suppressEvents)
				dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			
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
			
			var oldValues:Velocity = clone() as Velocity;
			
			_rotationY = value;
			
			if (!suppressEvents)
				dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			
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
			
			var oldValues:Velocity = clone() as Velocity;
			
			_rotationZ = value;
			
			if (!suppressEvents)
				dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			
		}
		
		//----------------------------------
		//  speed
		//----------------------------------
		
		/**
		 * Using x, y, and z velocity, this property returns speed in terms of units/milliseconds.
		 * Setting this value will cause x, y, and z to be adjusted.
		 * 
		 * <p>This property is same as <code>magnitude</code> property, but changing value through
		 * this would cause event <code>PhysicsEvent.ACCELERATED</code> to be dispatched.</p>
		 * 
		 */
		public function get speed():Number
		{
			
			return magnitude;
			
			/*
			var velocity:Velocity = this;
			
			var xySpeed:Number = 0;
			if (Math.abs(velocity.x) < 0.00001)
			{
				
				// There is no X movement, so xySpeed is y velocity
				xySpeed = velocity.y;
				
			}
			else if (Math.abs(velocity.y) < 0.00001)
			{
				
				// There is no Y movement, so xySpeed is x velocity
				xySpeed = velocity.x;
				
			}
			else
			{
				
				// There are both X and Y movements
				var xyAngle:Number = Math.atan2(velocity.y, velocity.x);
				xySpeed = velocity.y / Math.sin(xyAngle);
				
			}
			
			var calculatedspeed:Number = 0;
			if (Math.abs(xySpeed) < 0.00001)
			{
				
				// There is no XY movement, so speed is z velocity
				calculatedspeed = velocity.z;
				
			}
			else if (Math.abs(velocity.z) < 0.00001)
			{
				
				// There is no Z movement, so speed is xySpeed
				calculatedspeed = xySpeed;
				
			}
			else
			{
				
				// There are both xySpeed and Z movements
				var xy_zAngle:Number = Math.atan2(velocity.z, xySpeed);
				calculatedspeed = velocity.z / Math.sin(xy_zAngle);
				
			}
			
			return calculatedspeed;
			*/
			
		}
		
		/**
		 * @private
		 */
		public function set speed(value:Number):void
		{
			
			var oldValues:Velocity = clone() as Velocity;
			
			suppressEvents = true;
			
			magnitude = value;
			
			suppressEvents = false;
			
			/*
			// Multiply the velocity by using the ratio between new value and current speed
			// ex. If current speed is 3 and new speed is 6, then velocity will be multiplied by 2.
			var multiple:Number = value / speed;
			_x *= multiple;
			_y *= multiple;
			_z *= multiple;
			*/
			
			dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			return "[Velocity x: "+x+" y: "+y+" z: "+z+" rotationX: "+rotationX+" rotationY: "+rotationY+" rotationZ: "+rotationZ+"]";
			
		}
		
		/**
		 * Creates a new instance of Velocity using the same values.
		 * @return new instance of Velocity.
		 * 
		 */
		override public function clone():Number3D
		{
			
			return new Velocity(x, y, z, rotationX, rotationY, rotationZ);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Copies all values (x, y, z, rotationX, rotationY, and rotationZ) from <code>sourceVelocity</code>.
		 * 
		 * @param sourceVelocity
		 * 
		 */
		public function copy(sourceVelocity:Velocity):void
		{
			
			setValues(sourceVelocity.x, sourceVelocity.y, sourceVelocity.z, sourceVelocity.rotationX, sourceVelocity.rotationY, sourceVelocity.rotationZ);
			
			/*
			var oldValues:Velocity = clone() as Velocity;
			
			suppressEvents = true;
			
			x = sourceVelocity.x;
			y = sourceVelocity.y;
			z = sourceVelocity.z;
			rotationX = sourceVelocity.rotationX;
			rotationY = sourceVelocity.rotationY;
			rotationZ = sourceVelocity.rotationZ;
			
			suppressEvents = false;
			
			dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			*/
			
		}
		
		/**
		 * Sets all values of velocity.
		 * 
		 * <p>When each value of Velocity is set (ex. Velocity.x = 1) <code>"accelerated"</code> event is dispatched.
		 * This method may be necessary if you want only one <code>"accelerated"</code> event dispatched from all values
		 * getting updated.</p>
		 * 
		 * @param xV
		 * @param yV
		 * @param zV
		 * @param rotationXV
		 * @param rotationYV
		 * @param rotationZV
		 * 
		 */
		public function setValues(xV:Number = 0, yV:Number = 0, zV:Number = 0, rotationXV:Number = 0, rotationYV:Number = 0, rotationZV:Number = 0):void
		{
			
			var oldValues:Velocity = clone() as Velocity;
			
			suppressEvents = true;
			
			x = xV;
			y = yV;
			z = zV;
			rotationX = rotationXV;
			rotationY = rotationYV;
			rotationZ = rotationZV;
			
			suppressEvents = false;
			
			dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this));
			
		}
		
		/**
		 * Applies acceleration to the velocity.
		 * @param acceleration
		 * @param millisecondsElapsed
		 * 
		 */
		public function accelerate(acceleration:Acceleration, millisecondsElapsed:int = 1):void
		{
			
			setValues(x + (acceleration.x * millisecondsElapsed),
					  y + (acceleration.y * millisecondsElapsed),
					  z + (acceleration.z * millisecondsElapsed),
					  rotationX + (acceleration.rotationX * millisecondsElapsed),
					  rotationY + (acceleration.rotationY * millisecondsElapsed),
					  rotationZ + (acceleration.rotationZ * millisecondsElapsed));
			
			/*
			var oldValues:Velocity = clone() as Velocity;
			
			suppressEvents = true;
			
			x += (acceleration.x * millisecondsElapsed);
			y += (acceleration.y * millisecondsElapsed);
			z += (acceleration.z * millisecondsElapsed);
			rotationX += (acceleration.rotationX * millisecondsElapsed);
			rotationY += (acceleration.rotationY * millisecondsElapsed);
			rotationZ += (acceleration.rotationZ * millisecondsElapsed);
			
			suppressEvents = false;
			
			dispatchEvent(new PhysicsEvent(PhysicsEvent.ACCELERATED, false, false, oldValues, this, acceleration));
			*/
			
		}
		
	}
	
}