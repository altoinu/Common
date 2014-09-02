/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.skins
{
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import mx.skins.ProgrammaticSkin;
	
	/**
	 * Skin to draw gradient box.  For example, this skin can be specified through styles such as
	 * <code>upSkin</code> through mxml or .css to give component gradient background color.
	 * 
	 * <p>When GradientFillSkin is specified for a component skin, by default it draws red/yellow
	 * gradient; however, the gradient can be controlled by specifying extra style values for that component.
	 * Following are the styles recognized:</p>
	 * 
	 * <p>
	 * <pre>
	 * 	cornerRadius
	 * 	gradientFillType="linear" - flash.display.GradientType
	 * 	gradientFillColors=[0xFF0000, 0xFFFF00]
	 * 	gradientFillAlphas=[1, 1]
	 * 	gradientFillRatios=[0, 255]
	 * 	gradientFillSpreadMethod="pad" - flash.display.SpreadMethod
	 * 	gradientFillInterpolationMethod="rgb" - flash.display.InterpolationMethod
	 * 	gradientFillFocalPointRatio=0;
	 * 	gradientFillWidth=same as component
	 * 	gradientFillHeight=same as component
	 * 	gradientFillRotation=0
	 * </pre>
	 * </p>
	 * 
	 * <p>For information on each gradient fill style, refer to flash.display.Graphics.beginGradientFill() method.</p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class GradientFillSkin extends ProgrammaticSkin
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  style names recognized by GradientFillSkin
		//----------------------------------
		
		public static const STYLE_GRADIENT_TYPE:String = "gradientFillType";
		public static const STYLE_GRADIENT_FILL_COLORS:String = "gradientFillColors";
		public static const STYLE_GRADIENT_FILL_ALPHAS:String = "gradientFillAlphas";
		public static const STYLE_GRADIENT_RATIOS:String = "gradientFillRatios";
		public static const STYLE_GRADIENT_SPREAD_METHOD:String = "gradientFillSpreadMethod";
		public static const STYLE_GRADIENT_INTERPOLATION_METHOD:String = "gradientFillInterpolationMethod";
		public static const STYLE_GRADIENT_FOCALPOINT_RATIO:String = "gradientFillFocalPointRatio";
		public static const STYLE_GRADIENT_WIDTH:String = "gradientFillWidth";
		public static const STYLE_GRADIENT_HEIGHT:String = "gradientFillHeight";
		public static const STYLE_GRADIENT_ROTATION:String = "gradientFillRotation";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function GradientFillSkin()
		{
			
			super();
			
		}
		
		override public function get measuredHeight():Number
		{
			
			return 1;
			
		}
		
		override public function get measuredWidth():Number
		{
			
			return 1;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// Get gradient values from styles
			var gradientType:String = getStyle(STYLE_GRADIENT_TYPE);
			if ((gradientType != GradientType.LINEAR) && (gradientType != GradientType.RADIAL))
				gradientType = GradientType.LINEAR;
			
			var gradientColors:Array = getStyle(STYLE_GRADIENT_FILL_COLORS);
			if (gradientColors == null)
				gradientColors = [0xFF0000, 0xFFFF00];
			
			var gradientAlphas:Array = getStyle(STYLE_GRADIENT_FILL_ALPHAS);
			if (gradientAlphas == null)
				gradientAlphas = [1, 1];
			
			var gradientRatios:Array = getStyle(STYLE_GRADIENT_RATIOS);
			if (gradientRatios == null)
				gradientRatios = [0, 255];
			
			var spreadMethod:String = getStyle(STYLE_GRADIENT_SPREAD_METHOD);
			if ((spreadMethod != SpreadMethod.PAD) && (spreadMethod != SpreadMethod.REFLECT) && (spreadMethod != SpreadMethod.REPEAT))
				spreadMethod = SpreadMethod.PAD;
			
			var interp:String = getStyle(STYLE_GRADIENT_INTERPOLATION_METHOD);
			if ((interp != InterpolationMethod.LINEAR_RGB) && (interp != InterpolationMethod.RGB))
				interp = InterpolationMethod.RGB;
			
			var focalPtRatio:Number = getStyle(STYLE_GRADIENT_FOCALPOINT_RATIO);
			if (isNaN(focalPtRatio))
				focalPtRatio = 0;
			
			var gradientMatrix:Matrix = new Matrix();
			
			var gradientWidth:Number = getStyle(STYLE_GRADIENT_WIDTH);
			if (isNaN(gradientWidth))
				gradientWidth = unscaledWidth;
			
			var gradientHeight:Number = getStyle(STYLE_GRADIENT_HEIGHT);
			if (isNaN(gradientHeight))
				gradientHeight = unscaledHeight;
			
			var gradientRotation:Number = getStyle(STYLE_GRADIENT_ROTATION);
			if (isNaN(gradientRotation))
				gradientRotation = 0;
			
			gradientRotation *= (Math.PI / 180); // rotation in radians
			
			gradientMatrix.createGradientBox(gradientWidth, gradientHeight, gradientRotation);
			
			var cornerRadius:Number = getStyle("cornerRadius");
			if (isNaN(cornerRadius))
				cornerRadius = 0;
			
			var g:Graphics = graphics;
			g.clear();
			g.beginGradientFill(gradientType,
								gradientColors,
								gradientAlphas,
								gradientRatios,
								gradientMatrix,
								spreadMethod,
								interp,
								focalPtRatio);
			
			g.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, cornerRadius * 2);
			
			/*
			g.moveTo(cornerRadius, 0);
			g.lineTo(unscaledWidth - cornerRadius, 0);
			g.curveTo(unscaledWidth, 0, unscaledWidth, cornerRadius);
			g.lineTo(unscaledWidth, unscaledHeight - cornerRadius);
			g.curveTo(unscaledWidth, unscaledHeight, unscaledWidth - cornerRadius, unscaledHeight);
			g.lineTo(cornerRadius, unscaledHeight);
			g.curveTo(0, unscaledHeight, 0, unscaledHeight - cornerRadius);
			g.lineTo(0, cornerRadius);
			g.curveTo(0, 0, cornerRadius, 0);
			*/
			
			g.endFill();
			
			//drawRoundRect(0, 0, unscaledWidth, unscaledHeight, cornerRadius, gradientColors, gradientAlphas, gradientMatrix, gradientType, gradientRatios);
			
		}
		
	}
	
}