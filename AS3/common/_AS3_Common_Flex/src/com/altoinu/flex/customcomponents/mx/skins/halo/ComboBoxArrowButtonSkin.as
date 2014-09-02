/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.skins.halo
{
	
	import flash.display.Graphics;
	
	import mx.skins.halo.ComboBoxArrowSkin;
	
	/**
	 * The skin or all the states of the button in a ComboBox. Unlike the normal
	 * ComboBoxArrowSkin, you can specify different color for the arrow button.
	 * 
	 * @mxml
	 * 
	 * <p>Following are the extra styles that can be used:</p>
	 * 
	 * <pre>
	 * 	<b>Styles</b>
	 * 	iconColor="0"
	 * 	iconFillAlphas=fillAlphas
	 * 	iconFillColors=fillColors
	 * 	iconHighlightAlphas=highlightAlphas
	 * 	arrowButtonWidth="22"
	 * </pre>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class ComboBoxArrowButtonSkin extends ComboBoxArrowSkin
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function ComboBoxArrowButtonSkin()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			
			super.updateDisplayList(w, h);
			
			// User-defined styles.
			var arrowColor:uint = getStyle("iconColor");
			if (isNaN(arrowColor))
				arrowColor = 0;
			
			var cornerRadius:Number = getStyle("cornerRadius");
			
			var iconFillAlphas:Array = getStyle("iconFillAlphas");
			if (iconFillAlphas == null)
				iconFillAlphas = getStyle("fillColors");
			if (iconFillAlphas[0] == null)
				iconFillAlphas[0] = getStyle("fillColors")[0];
			if (iconFillAlphas[1] == null)
				iconFillAlphas[1] = getStyle("fillColors")[1];
			
			var iconFillColors:Array = getStyle("iconFillColors");
			if (iconFillColors == null)
				iconFillColors = getStyle("fillColors");
			if (iconFillColors[0] == null)
				iconFillColors[0] = getStyle("fillColors")[0];
			if (iconFillColors[1] == null)
				iconFillColors[1] = getStyle("fillColors")[1];
			
			var iconHighlightAlphas:Array = getStyle("iconHighlightAlphas");		
			if (iconHighlightAlphas == null)
				iconHighlightAlphas = getStyle("highlightAlphas");
			if (iconHighlightAlphas[0] == null)
				iconHighlightAlphas[0] = getStyle("highlightAlphas")[0];
			if (iconHighlightAlphas[1] == null)
				iconHighlightAlphas[1] = getStyle("highlightAlphas")[1];
			
			
			var arrowButtonWidth:Number = getStyle("arrowButtonWidth");
			if (isNaN(arrowButtonWidth))
				arrowButtonWidth = 22;
			
			var cornerRadius1:Number = Math.max(cornerRadius - 1, 0);
			var cr:Object = { tl: 0, tr: cornerRadius, bl: 0, br: cornerRadius };
			var cr1:Object = { tl: cornerRadius1, tr: cornerRadius1, bl: cornerRadius1, br: cornerRadius1 };
			
			var g:Graphics = graphics;
			
			var upFillColors:Array = [ iconFillColors[0], iconFillColors[1] ];
			var upFillAlphas:Array = [ iconFillAlphas[0], iconFillAlphas[1] ];
			
			// icon background
			drawRoundRect(
				w - arrowButtonWidth - 2, 2, arrowButtonWidth, h - 4,
				cr1,
				iconFillColors, iconFillAlphas,
				verticalGradientMatrix(w - arrowButtonWidth - 2, 2, arrowButtonWidth, h - 4));
			
			// icon highlight
			drawRoundRect(
				w - arrowButtonWidth - 2, 2, arrowButtonWidth, (h - 4) / 2,
				{ tl: cornerRadius1, tr: cornerRadius1, bl: 0, br: 0 },
				[ 0xFFFFFF, 0xFFFFFF ], iconHighlightAlphas,
				verticalGradientMatrix(w - arrowButtonWidth - 2, 2, arrowButtonWidth, (h - 4) / 2));
			
			// Draw the triangle.
			g.beginFill(arrowColor);
			g.moveTo(w - (arrowButtonWidth / 2) - 2, h / 2 + 3);
			g.lineTo(w - (arrowButtonWidth * 1 / 3) - 2, h / 2 - 2);
			g.lineTo(w - (arrowButtonWidth * 2 / 3) - 2, h / 2 - 2);
			g.lineTo(w - (arrowButtonWidth / 2) - 2, h / 2 + 3);
			g.endFill();
			
		}
		
	}
	
}