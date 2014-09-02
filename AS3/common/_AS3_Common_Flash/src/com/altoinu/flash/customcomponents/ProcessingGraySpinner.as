/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.customcomponents
{
	
	public class ProcessingGraySpinner extends ProcessingSpinner_Image
	{
		
		public function ProcessingGraySpinner(numWings:uint = 12, radius:Number = 10)
		{
			
			super(GrayLine, numWings, radius);
			
		}
		
	}
	
}

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;

class GrayLine extends Sprite
{
	
	public function GrayLine()
	{
		
		super();
		
		var g:Graphics = this.graphics;
		g.moveTo(-2.5, 0);
		g.lineStyle(2, 0x999999, 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
		g.lineTo(2.5, 0);
		
	}
	
}
