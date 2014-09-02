/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.skins.halo
{
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.filters.DropShadowFilter;
	
	import mx.core.EdgeMetrics;
	import mx.graphics.RectangularDropShadow;
	import mx.skins.halo.ToolTipBorder;
	
	/**
	 * The skin for a ToolTip extended from mx.skinds.halo.ToolTipBorder.  Just like regular
	 * ToolTip border, set the borderStyle to one of the following to use the border:
	 * <p>
	 * <pre>
	 * errorTipAbove
	 * errorTipAbove_inset
	 * errorTipBelow
	 * errorTipBelow_inset
	 * errorTipLeft
	 * errorTipLeft_inset
	 * errorTipRight
	 * errorTipRight_inset
	 * </pre>
	 * </p>
	 * 
	 * You can also offset the pointer using style <code>pointerOffset</code> and change
	 * its size by setting styles <code>pointerWidth</code> and <code>pointerHeight</code>.
	 * You can also set cornerRadius of the tool tip.
	 * 
	 * <p><code>pointerOffset</code>, <code>pointerWidth</code>, and <code>pointerHeight</code>
	 * are not default style property of any component, so if you want it to work correctly
	 * in mxml, you must extend the component to accept these values, or simply define these values
	 * using CSS.</p>
	 * 
	 * @author kaoru.kawashima
	 * 
	 */
	public class ToolTipBorder_Custom extends ToolTipBorder
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const DEFAULT_COLOR:uint = 0xFFFF00;
		public static const DEFAULT_POINTEROFFSET:Number = 7;
		public static const DEFAULT_POINTERWIDTH:Number = 12;
		public static const DEFAULT_POINTERHEIGHT:Number = 11;
		public static const DEFAULT_CORNERRADIUS:Number = 3;
		public static const DEFAULT_BORDERTHICKNESS:Number = 2;
		
		public static const ERRORTIP_ABOVE:String = "errorTipAbove";
		public static const ERRORTIP_ABOVE_INSET:String = "errorTipAbove_inset";
		public static const ERRORTIP_BELOW:String = "errorTipBelow";
		public static const ERRORTIP_BELOW_INSET:String = "errorTipBelow_inset";
		public static const ERRORTIP_LEFT:String = "errorTipLeft";
		public static const ERRORTIP_LEFT_INSET:String = "errorTipLeft_inset";
		public static const ERRORTIP_RIGHT:String = "errorTipRight";
		public static const ERRORTIP_RIGHT_INSET:String = "errorTipRight_inset";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 */
		public function ToolTipBorder_Custom() 
		{
			super(); 
		}
	
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 */
		private var dropShadow:RectangularDropShadow;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
	
		//----------------------------------
		//  borderMetrics
		//----------------------------------
	
		/**
		 *  @private
		 *  Storage for the borderMetrics property.
		 */
		private var _borderMetrics:EdgeMetrics;
	
		/**
		 *  @private
		 */
		override public function get borderMetrics():EdgeMetrics
		{		
			
			if (_borderMetrics)
				return _borderMetrics;
				
			var borderStyle:String = getStyle("borderStyle");
			
			// Custom styles for this extended class
			var cornerRadius:Number = getStyle("cornerRadius");
			if (isNaN(cornerRadius))
				cornerRadius = DEFAULT_CORNERRADIUS;
			
			var borderThickness:Number = getStyle("borderThickness");
			if (isNaN(borderThickness))
				borderThickness = DEFAULT_BORDERTHICKNESS;
			
			var pointerOffset:Number = getStyle("pointerOffset");
			if (isNaN(pointerOffset))
				pointerOffset = DEFAULT_POINTEROFFSET;
			
			var pointerWidth:Number = getStyle("pointerWidth");
			if (isNaN(pointerWidth))
				pointerWidth = DEFAULT_POINTERWIDTH;
			
			var pointerHeight:Number = getStyle("pointerHeight");
			if (isNaN(pointerHeight))
				pointerHeight = DEFAULT_POINTERHEIGHT;
			
			switch (borderStyle)
			{
				
				case ERRORTIP_ABOVE:
				{
	 				_borderMetrics = new EdgeMetrics(borderThickness / 2, borderThickness / 2, borderThickness / 2, pointerHeight + (borderThickness / 2));
	 				break;
				}
				
				case ERRORTIP_ABOVE_INSET:
				{
	 				_borderMetrics = new EdgeMetrics(borderThickness, borderThickness, borderThickness, pointerHeight + borderThickness);
	 				break;
				}
			
				case ERRORTIP_BELOW:
				{
	 				_borderMetrics = new EdgeMetrics(borderThickness / 2, pointerHeight + (borderThickness / 2), borderThickness / 2, borderThickness / 2);
	 				break;
				}
				
				case ERRORTIP_BELOW_INSET:
				{
					_borderMetrics = new EdgeMetrics(borderThickness, pointerHeight + borderThickness, borderThickness, borderThickness);
	 				break;
				}
				
	 			case ERRORTIP_LEFT:
				{
	 				_borderMetrics = new EdgeMetrics((borderThickness / 2), borderThickness / 2, pointerHeight + (borderThickness / 2), borderThickness / 2);
					break;
				}
				
				case ERRORTIP_LEFT_INSET:
				{
	 				_borderMetrics = new EdgeMetrics(borderThickness, borderThickness, pointerHeight + borderThickness, borderThickness);
	 				break;
				}
				
				case ERRORTIP_RIGHT:
				{
	 				_borderMetrics = new EdgeMetrics(pointerHeight + (borderThickness / 2), borderThickness / 2, borderThickness / 2, borderThickness / 2);
					break;
				}
				
				case ERRORTIP_RIGHT_INSET:
				{
	 				_borderMetrics = new EdgeMetrics(pointerHeight + borderThickness, borderThickness, borderThickness, borderThickness);
	 				break;
				}
				
				default: // "toolTip"
				{
					_borderMetrics = new EdgeMetrics(3, 1, 3, 3);
	 				break;
				}
	 		}
			
			return _borderMetrics;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 *  Draw the background and border.
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{	
			
			super.updateDisplayList(w, h);
	
			var borderStyle:String = getStyle("borderStyle");
			var backgroundColor:uint = getStyle("backgroundColor");
			var backgroundAlpha:Number= getStyle("backgroundAlpha");
			var borderColor:uint = getStyle("borderColor");
			var shadowColor:uint = getStyle("shadowColor");
			var shadowAlpha:Number = 0.1;
			
			// Custom styles for this extended class
			var cornerRadius:Number = getStyle("cornerRadius");
			if (isNaN(cornerRadius))
				cornerRadius = DEFAULT_CORNERRADIUS;
			
			var borderThickness:Number = getStyle("borderThickness");
			if (isNaN(borderThickness))
				borderThickness = DEFAULT_BORDERTHICKNESS;
			
			var pointerOffset:Number = getStyle("pointerOffset");
			if (isNaN(pointerOffset))
				pointerOffset = DEFAULT_POINTEROFFSET;
			
			var pointerWidth:Number = getStyle("pointerWidth");
			if (isNaN(pointerWidth))
				pointerWidth = DEFAULT_POINTERWIDTH;
			
			var pointerHeight:Number = getStyle("pointerHeight");
			if (isNaN(pointerHeight))
				pointerHeight = DEFAULT_POINTERHEIGHT;
			
			var g:Graphics = graphics;
			g.clear();
			
			filters = [];
	
			switch (borderStyle)
			{
				case "toolTip":
				{
					// face
					drawRoundRect(
						3, 1, w - 6, h - 4, cornerRadius,
						backgroundColor, backgroundAlpha) 
					
					if (!dropShadow)
						dropShadow = new RectangularDropShadow();
	
					dropShadow.distance = 3;
					dropShadow.angle = 90;
					dropShadow.color = 0;
					dropShadow.alpha = 0.4;
	
					dropShadow.tlRadius = cornerRadius + 2;
					dropShadow.trRadius = cornerRadius + 2;
					dropShadow.blRadius = cornerRadius + 2;
					dropShadow.brRadius = cornerRadius + 2;
	
					dropShadow.drawShadow(graphics, 3, 0, w - 6, h - 4);
	
					break;
				}
	
				case ERRORTIP_ABOVE:
				{
					
					g.lineStyle(borderThickness, borderColor, backgroundAlpha, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(pointerOffset, h - pointerHeight);
					if (pointerOffset >= cornerRadius)
					{
						g.lineTo(cornerRadius, h - pointerHeight);
						g.curveTo(0, h - pointerHeight, 0, h - pointerHeight - cornerRadius);
					}
					else if ((0 < pointerOffset) &&
							 (pointerOffset <= cornerRadius))
					{
						g.curveTo(0, h - pointerHeight, 0, h - pointerHeight - pointerOffset);
					}
					else
					{
						g.lineTo(0, h - pointerHeight);
					}
					g.lineTo(0, cornerRadius);
					g.curveTo(0, 0, cornerRadius, 0);
					g.lineTo(w - cornerRadius, 0);
					g.curveTo(w, 0, w, cornerRadius);
					g.lineTo(w, h - pointerHeight - cornerRadius);
					if (pointerOffset + pointerWidth > w - cornerRadius)
						g.lineTo(w, h - pointerHeight);
					else
						g.curveTo(w, h - pointerHeight, w - cornerRadius, h - pointerHeight);
					g.lineTo(pointerOffset + pointerWidth, h - pointerHeight);
					g.lineTo(pointerOffset + (pointerWidth / 2), h);
					g.lineTo(pointerOffset, h - pointerHeight);
					g.endFill();
					
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}
				
				case ERRORTIP_ABOVE_INSET:
				{
				
					g.lineStyle(borderThickness, borderColor, backgroundAlpha, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(pointerOffset + (borderThickness / 2), h - pointerHeight - (borderThickness / 2));
					if (pointerOffset + (borderThickness / 2) >= cornerRadius + (borderThickness / 2))
					{
						g.lineTo(cornerRadius + (borderThickness / 2), h - pointerHeight - (borderThickness / 2));
						g.curveTo((borderThickness / 2), h - pointerHeight - (borderThickness / 2), (borderThickness / 2), h - pointerHeight - cornerRadius - (borderThickness / 2));
					}
					else if ((0 < pointerOffset + (borderThickness / 2)) &&
							 (pointerOffset + (borderThickness / 2) <= cornerRadius + (borderThickness / 2)))
					{
						g.curveTo((borderThickness / 2), h - pointerHeight - (borderThickness / 2), (borderThickness / 2), h - pointerHeight - pointerOffset - (borderThickness / 2));
					}
					else
					{
						g.lineTo((borderThickness / 2), h - pointerHeight - (borderThickness / 2));
					}
					g.lineTo((borderThickness / 2), cornerRadius + (borderThickness / 2));
					g.curveTo((borderThickness / 2), (borderThickness / 2), cornerRadius - (borderThickness / 2), (borderThickness / 2));
					g.lineTo(w - (borderThickness / 2) - cornerRadius, (borderThickness / 2));
					g.curveTo(w - (borderThickness / 2), (borderThickness / 2), w - (borderThickness / 2), (borderThickness / 2) + cornerRadius);
					g.lineTo(w - (borderThickness / 2), h - pointerHeight - cornerRadius - (borderThickness / 2));
					if (pointerOffset + pointerWidth - (borderThickness / 2) >= w - cornerRadius - (borderThickness / 2))
						g.lineTo(w - (borderThickness / 2), h - pointerHeight - (borderThickness / 2));
					else
						g.curveTo(w - (borderThickness / 2), h - pointerHeight - (borderThickness / 2), w - cornerRadius - (borderThickness / 2), h - pointerHeight - (borderThickness / 2));
					g.lineTo(pointerOffset + pointerWidth - (borderThickness / 2), h - pointerHeight - (borderThickness / 2));
					g.lineTo(pointerOffset + (pointerWidth / 2), h - (borderThickness / 2));
					g.lineTo(pointerOffset + (borderThickness / 2), h - pointerHeight - (borderThickness / 2));
					g.endFill();
										
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
					
				}
				
				case ERRORTIP_BELOW:
				{
					
					g.lineStyle(borderThickness, borderColor, backgroundAlpha, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(pointerOffset, pointerHeight);
					if (pointerOffset >= cornerRadius)
					{
						g.lineTo(cornerRadius, pointerHeight);
						g.curveTo(0, pointerHeight, 0, pointerHeight + cornerRadius);
					}
					else if ((0 < pointerOffset) &&
							 (pointerOffset <= cornerRadius))
					{
						g.curveTo(0, pointerHeight, 0, pointerHeight + pointerOffset);
					}
					else
					{
						g.lineTo(0, pointerHeight)
					}
					g.lineTo(0, h - cornerRadius);
					g.curveTo(0, h, cornerRadius, h);
					g.lineTo(w - cornerRadius, h);
					g.curveTo(w, h, w, h - cornerRadius);
					g.lineTo(w, pointerHeight + cornerRadius);
					if (pointerOffset + pointerWidth > w - cornerRadius)
						g.lineTo(w, pointerHeight);
					else
						g.curveTo(w, pointerHeight, w - cornerRadius, pointerHeight);
					g.lineTo(pointerOffset + pointerWidth, pointerHeight);
					g.lineTo(pointerOffset + (pointerWidth / 2), 0);
					g.lineTo(pointerOffset, pointerHeight);
					g.endFill();
					
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
					
				}
				
				case ERRORTIP_BELOW_INSET:
				{
				
					g.lineStyle(borderThickness, borderColor, backgroundAlpha, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(pointerOffset + (borderThickness / 2), pointerHeight + (borderThickness / 2));
					if (pointerOffset + (borderThickness / 2) >= cornerRadius + (borderThickness / 2))
					{
						g.lineTo(cornerRadius + (borderThickness / 2), pointerHeight + (borderThickness / 2));
						g.curveTo((borderThickness / 2), pointerHeight + (borderThickness / 2), (borderThickness / 2), pointerHeight + cornerRadius + (borderThickness / 2));
					}
					else if ((0 < pointerOffset + (borderThickness / 2)) &&
							 (pointerOffset + (borderThickness / 2) <= cornerRadius + (borderThickness / 2)))
					{
						g.curveTo((borderThickness / 2), pointerHeight + (borderThickness / 2), (borderThickness / 2), pointerHeight + pointerOffset + (borderThickness / 2));
					}
					else
					{
						g.lineTo((borderThickness / 2),  pointerHeight + (borderThickness / 2));
					}
					g.lineTo((borderThickness / 2), h - cornerRadius - (borderThickness / 2));
					g.curveTo((borderThickness / 2), h - (borderThickness / 2), cornerRadius + (borderThickness / 2), h - (borderThickness / 2));
					g.lineTo(w - cornerRadius - (borderThickness / 2), h - (borderThickness / 2));
					g.curveTo(w - (borderThickness / 2), h - (borderThickness / 2), w - (borderThickness / 2), h - cornerRadius - (borderThickness / 2));
					g.lineTo(w - (borderThickness / 2), pointerHeight + cornerRadius + (borderThickness / 2));
					if (pointerOffset + pointerWidth - (borderThickness / 2) >= w - cornerRadius - (borderThickness / 2))
						g.lineTo(w - (borderThickness / 2), pointerHeight + (borderThickness / 2));
					else
						g.curveTo(w - (borderThickness / 2), pointerHeight + (borderThickness / 2), w - cornerRadius - (borderThickness / 2), pointerHeight + (borderThickness / 2));
					g.lineTo(pointerOffset + pointerWidth - (borderThickness / 2), pointerHeight + (borderThickness / 2));
					g.lineTo(pointerOffset + (pointerWidth / 2), (borderThickness / 2));
					g.lineTo(pointerOffset + (borderThickness / 2), pointerHeight + (borderThickness / 2));
					g.endFill();
										
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
					
				}
				
				case ERRORTIP_LEFT:
				{
					
					g.lineStyle(borderThickness, borderColor, backgroundAlpha, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(w - pointerHeight, pointerOffset);
					if (pointerOffset >= cornerRadius)
					{
						g.lineTo(w - pointerHeight, cornerRadius);
						g.curveTo(w - pointerHeight, 0, w - pointerHeight - cornerRadius, 0);
					}
					else if ((0 < pointerOffset) &&
							 (pointerOffset <= cornerRadius))
					{
						g.curveTo(w - pointerHeight, 0, w - pointerHeight - pointerOffset, 0);
					}
					else
					{
						g.lineTo(w - pointerHeight, 0);
					}
					g.lineTo(cornerRadius, 0);
					g.curveTo(0, 0, 0, cornerRadius);
					g.lineTo(0, h - cornerRadius);
					g.curveTo(0, h, cornerRadius, h);
					g.lineTo(w - pointerHeight - cornerRadius, h);
					if (pointerOffset + pointerWidth >= h - cornerRadius)
						g.lineTo(w - pointerHeight, h);
					else
						g.curveTo(w - pointerHeight, h, w - pointerHeight, h - cornerRadius);
					g.lineTo(w - pointerHeight, pointerOffset + pointerWidth);
					g.lineTo(w, pointerOffset + (pointerWidth / 2));
					g.lineTo(w - pointerHeight, pointerOffset);
					g.endFill();
					
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}
				
				case ERRORTIP_LEFT_INSET:
				{
					
					g.lineStyle(borderThickness, borderColor, backgroundAlpha, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(w - pointerHeight - (borderThickness / 2), pointerOffset + (borderThickness / 2));
					if (pointerOffset + (borderThickness / 2) >= cornerRadius + (borderThickness / 2))
					{
						g.lineTo(w - pointerHeight - (borderThickness / 2), cornerRadius + (borderThickness / 2));
						g.curveTo(w - pointerHeight - (borderThickness / 2), (borderThickness / 2), w - pointerHeight - cornerRadius - (borderThickness / 2), (borderThickness / 2));
					}
					else if ((0 < pointerOffset + (borderThickness / 2)) &&
							 (pointerOffset + (borderThickness / 2) <= cornerRadius + (borderThickness / 2)))
					{
						g.curveTo(w - pointerHeight - (borderThickness / 2), (borderThickness / 2), w - pointerHeight - pointerOffset - (borderThickness / 2), (borderThickness / 2));
					}
					else
					{
						g.lineTo(w - pointerHeight - (borderThickness / 2), (borderThickness / 2));
					}
					g.lineTo(cornerRadius + (borderThickness / 2), (borderThickness / 2));
					g.curveTo((borderThickness / 2), (borderThickness / 2), (borderThickness / 2), cornerRadius + (borderThickness / 2));
					g.lineTo((borderThickness / 2), h - cornerRadius - (borderThickness / 2));
					g.curveTo((borderThickness / 2), h - (borderThickness / 2), cornerRadius + (borderThickness / 2), h - (borderThickness / 2));
					g.lineTo(w - pointerHeight - cornerRadius - (borderThickness / 2), h - (borderThickness / 2));
					if (pointerOffset + pointerWidth - (borderThickness / 2) >= h - cornerRadius - (borderThickness / 2))
						g.lineTo(w - pointerHeight - (borderThickness / 2), h - (borderThickness / 2));
					else
						g.curveTo(w - pointerHeight - (borderThickness / 2), h - (borderThickness / 2), w - pointerHeight - (borderThickness / 2), h - cornerRadius - (borderThickness / 2));
					g.lineTo(w - pointerHeight - (borderThickness / 2), pointerOffset + pointerWidth - (borderThickness / 2));
					g.lineTo(w - (borderThickness / 2), pointerOffset + (pointerWidth / 2));
					g.lineTo(w - pointerHeight - (borderThickness / 2), pointerOffset + (borderThickness / 2));
					g.endFill();
					
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}
				
				case ERRORTIP_RIGHT:
				{
					
					g.lineStyle(borderThickness, borderColor, backgroundAlpha, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(pointerHeight, pointerOffset);
					if (pointerOffset >= cornerRadius)
					{
						g.lineTo(pointerHeight, cornerRadius);
						g.curveTo(pointerHeight, 0, pointerHeight + cornerRadius, 0);
					}
					else if ((0 < pointerOffset) &&
							 (pointerOffset <= cornerRadius))
					{
						g.curveTo(pointerHeight, 0, pointerHeight + pointerOffset, 0);
					}
					else
					{
						g.lineTo(pointerHeight, 0);
					}
					g.lineTo(w - cornerRadius, 0);
					g.curveTo(w, 0, w, cornerRadius);
					g.lineTo(w, h - cornerRadius);
					g.curveTo(w, h, w - cornerRadius, h);
					g.lineTo(pointerHeight + cornerRadius, h);
					if (pointerOffset + pointerWidth >= h - cornerRadius)
						g.lineTo(pointerHeight, h);
					else
						g.curveTo(pointerHeight, h, pointerHeight, h - cornerRadius);
					g.lineTo(pointerHeight, pointerOffset + pointerWidth);
					g.lineTo(0, pointerOffset + (pointerWidth / 2));
					g.lineTo(pointerHeight, pointerOffset);
					g.endFill();
					
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}
				
				case ERRORTIP_RIGHT_INSET:
				{
					
					g.lineStyle(borderThickness, borderColor, backgroundAlpha, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
					g.beginFill(backgroundColor, backgroundAlpha);
					g.moveTo(pointerHeight + (borderThickness / 2), pointerOffset + (borderThickness / 2));
					if (pointerOffset + (borderThickness / 2) >= cornerRadius + (borderThickness / 2))
					{
						g.lineTo(pointerHeight + (borderThickness / 2), cornerRadius + (borderThickness / 2));
						g.curveTo(pointerHeight + (borderThickness / 2), (borderThickness / 2), pointerHeight + cornerRadius + (borderThickness / 2), (borderThickness / 2));
					}
					else if ((0 < pointerOffset + (borderThickness / 2)) &&
							 (pointerOffset + (borderThickness / 2) <= cornerRadius + (borderThickness / 2)))
					{
						g.curveTo(pointerHeight + (borderThickness / 2), (borderThickness / 2), pointerHeight + pointerOffset + (borderThickness / 2), (borderThickness / 2));
					}
					else
					{
						g.lineTo(pointerHeight + (borderThickness / 2), (borderThickness / 2));
					}
					g.lineTo(w - cornerRadius - (borderThickness / 2), (borderThickness / 2));
					g.curveTo(w - (borderThickness / 2), (borderThickness / 2), w - (borderThickness / 2), cornerRadius + (borderThickness / 2));
					g.lineTo(w - (borderThickness / 2), h - cornerRadius - (borderThickness / 2));
					g.curveTo(w - (borderThickness / 2), h - (borderThickness / 2), w - cornerRadius - (borderThickness / 2), h - (borderThickness / 2));
					g.lineTo(pointerHeight + cornerRadius + (borderThickness / 2), h - (borderThickness / 2));
					if (pointerOffset + pointerWidth - (borderThickness / 2) >= h - cornerRadius - (borderThickness / 2))
						g.lineTo(pointerHeight + (borderThickness / 2), h - (borderThickness / 2));
					else
						g.curveTo(pointerHeight + (borderThickness / 2), h - (borderThickness / 2), pointerHeight + (borderThickness / 2), h - cornerRadius - (borderThickness / 2));
					g.lineTo(pointerHeight + (borderThickness / 2), pointerOffset + pointerWidth - (borderThickness / 2));
					g.lineTo((borderThickness / 2), pointerOffset + (pointerWidth / 2));
					g.lineTo(pointerHeight + (borderThickness / 2), pointerOffset + (borderThickness / 2));
					g.endFill();
					
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}
				
			}
			
		}
		
	}

}
