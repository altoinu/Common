/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.customcomponents.mx.containers
{
	
	import com.altoinu.flex.customcomponents.mx.skins.halo.ToolTipBorder_Custom;
	
	import flash.geom.Point;
	
	import mx.containers.Box;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 * Corner radius of the tool tip.  The default value is 3.
	 */
	[Style(name="cornerRadius", type="Number", inherit="no")]
	
	/**
	 * Background color. The default value is 0xFFFF00.
	 */
	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]
	
	/**
	 * Border color. The default value is 0xFFFF00.
	 */
	[Style(name="borderColor", type="uint", format="Color", inherit="no")]
	
	/**
	 * You cannot override this style.  It is always set as com.altoinu.flex.customcomponents.mx.skins.halo.ToolTipBorder_Custom.
	 */
	[Style(name="borderSkin", type="Class", inherit="no")]
	
	[Inspectable(category="Styles", enumeration="errorTipLeft,errorTipLeft_inset,errorTipRight,errorTipRight_inset,errorTipAbove,errorTipAbove_inset,errorTipBelow,errorTipBelow_inset", defaultValue="errorTipLeft")]
	/**
	 * Border style of the tool tip.  Possible values are
	 * errorTipLeft, errorTipLeft_inset, errorTipRight, errorTipRight_inset, errorTipAbove, errorTipAbove_inset, errorTipBelow, errorTipBelow_inset.
	 * Tip pointer is placed in the opposite side of the border style specified so the tool tip looks like
	 * it is popping out to that direction.  For example, if border style is errorTipRight, tool tip pointer
	 * will be on left so the tool gets the looks of popping out on the right.
	 * The default value is errorTipRight_inset.
	 */
	[Style(name="borderStyle", type="String", enumeration="errorTipLeft,errorTipLeft_inset,errorTipRight,errorTipRight_inset,errorTipAbove,errorTipAbove_inset,errorTipBelow,errorTipBelow_inset", inherit="no")]
	
	/**
	 * Border thickness.  The default value is 2.
	 */
	[Style(name="borderThickness", type="Number", format="Length", inherit="no")]
	
	/**
	 * Height of the pointer of the tool tip.  The default value is 11.
	 */
	[Style(name="pointerHeight", type="Number", format="Length", inherit="no")]
	
	/**
	 * Width of the pointer of the tool tip.  The default value is 12.
	 */
	[Style(name="pointerWidth", type="Number", format="Length", inherit="no")]
	
	/**
	 * Pixels to offset tool tip pointer from left/top.  The default value is 7.
	 */
	[Style(name="pointerOffset", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the container's bottom border
	 *  and the bottom of its content area.
	 *
	 *  @default 0
	 */
	[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the container's top border
	 *  and the top of its content area.
	 *
	 *  @default 0
	 */
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the container's left border
	 *  and the left of its content area.
	 *
	 *  @default 0
	 */
	[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the container's right border
	 *  and the right of its content area.
	 *
	 *  @default 0
	 */
	[Style(name="paddingRight", type="Number", format="Length", inherit="no")]
	
	/**
	 * Custom tool tip that uses border skin com.altoinu.flex.customcomponents.mx.skins.halo.ToolTipBorder_Custom.
	 * Unlike mx.controls.ToolTip, this component can be treated like Box container,
	 * allowing more than just simple text to be placed inside it.
	 * 
	 * @author kaoru.kawashima
	 * 
	 */
	public class ToolTipCustom extends Box
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class property
		//
		//--------------------------------------------------------------------------
	
		private static var classConstructed:Boolean = classConstruct();
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
	
		/**
		 * Checks to see if style is defined, and if not assign default style values.
		 * @return 
		 * 
		 */
		private static function classConstruct():Boolean
		{
			
			// Is style defined for this class?
			if (!StyleManager.getStyleDeclaration("ToolTipCustom"))
			{
				
				// No, create default style
				var defaultStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				defaultStyle.defaultFactory = function():void
				{
					
					this.cornerRadius = ToolTipBorder_Custom.DEFAULT_CORNERRADIUS;
					this.backgroundColor = ToolTipBorder_Custom.DEFAULT_COLOR;
					this.borderColor = ToolTipBorder_Custom.DEFAULT_COLOR;
					this.borderSkin = ToolTipBorder_Custom;
					this.borderStyle = ToolTipBorder_Custom.ERRORTIP_RIGHT_INSET;
					this.borderThickness = ToolTipBorder_Custom.DEFAULT_BORDERTHICKNESS;
					this.pointerHeight = ToolTipBorder_Custom.DEFAULT_POINTERHEIGHT;
					this.pointerWidth = ToolTipBorder_Custom.DEFAULT_POINTERWIDTH;
					this.pointerOffset = ToolTipBorder_Custom.DEFAULT_POINTEROFFSET;
					this.paddingBottom = 0;
					this.paddingLeft = 0;
					this.paddingRight = 0;
					this.paddingTop = 0;
					
				}
				StyleManager.setStyleDeclaration("ToolTipCustom", defaultStyle, true);
				
			}
			
			return true;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 * Constructor.
		 * 
		 */		
		public function ToolTipCustom()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable(event="updateComplete")]
		/**
		 * X Y coordinate of the pointer tip.
		 * @return 
		 * 
		 */
		public function get toolTipPointerLocation():Point
		{
			
			var tipPoint:Point = new Point();
			
			// Custom styles for this extended class
			var cornerRadius:Number = getStyle("cornerRadius");
			if (isNaN(cornerRadius))
				cornerRadius = ToolTipBorder_Custom.DEFAULT_CORNERRADIUS;
			
			var borderThickness:Number = getStyle("borderThickness");
			if (isNaN(borderThickness))
				borderThickness = ToolTipBorder_Custom.DEFAULT_BORDERTHICKNESS;
			
			var pointerOffset:Number = getStyle("pointerOffset");
			if (isNaN(pointerOffset))
				pointerOffset = ToolTipBorder_Custom.DEFAULT_POINTEROFFSET;
			
			var pointerWidth:Number = getStyle("pointerWidth");
			if (isNaN(pointerWidth))
				pointerWidth = ToolTipBorder_Custom.DEFAULT_POINTERWIDTH;
			
			var pointerHeight:Number = getStyle("pointerHeight");
			if (isNaN(pointerHeight))
				pointerHeight = ToolTipBorder_Custom.DEFAULT_POINTERHEIGHT;
			
			switch (this.getStyle("borderStyle"))
			{
				
				case "toolTip":
				case ToolTipBorder_Custom.ERRORTIP_ABOVE:
				case ToolTipBorder_Custom.ERRORTIP_ABOVE_INSET:
				{
					
					tipPoint.x = pointerOffset + (pointerWidth / 2);
					tipPoint.y = this.height;
					break;
					
				}
				
				case ToolTipBorder_Custom.ERRORTIP_BELOW:
				case ToolTipBorder_Custom.ERRORTIP_BELOW_INSET:
				{
					
					tipPoint.x = pointerOffset + (pointerWidth / 2);
					tipPoint.y = 0;
					break;
					
				}
				
				case ToolTipBorder_Custom.ERRORTIP_LEFT:
				case ToolTipBorder_Custom.ERRORTIP_LEFT_INSET:
				{
					
					tipPoint.x = this.width;
					tipPoint.y = pointerOffset + (pointerWidth / 2);
					break;
					
				}
				
				case ToolTipBorder_Custom.ERRORTIP_RIGHT:
				case ToolTipBorder_Custom.ERRORTIP_RIGHT_INSET:
				{
					
					tipPoint.x = 0;
					tipPoint.y = pointerOffset + (pointerWidth / 2);
					break;
					
				}
				
			}
			
			return tipPoint;
			
		}
		
		[Bindable(event="updateComplete")]
		public function get toolTipPointerX():Number
		{
			
			return toolTipPointerLocation.x;
			
		}
		
		[Bindable(event="updateComplete")]
		public function get toolTipPointerY():Number
		{
			
			return toolTipPointerLocation.y;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
	
		/**
		 * @inheritDoc
		 */
		override public function styleChanged(styleProp:String):void
		{
			
			super.styleChanged(styleProp);
			
			if (styleProp == "borderStyle")
			{
				
				//trace("change1 "+this.getStyle("borderStyle"))
				invalidateDisplayList();
				invalidateProperties();
				invalidateSize();
				
			}
			else if (styleProp == "borderSkin")
			{
				
				//trace("change2 "+this.getStyle("borderSkin"))
				invalidateDisplayList();
				invalidateProperties();
				invalidateSize();
				
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			if (this.getStyle("borderSkin") != ToolTipBorder_Custom)
				this.setStyle("borderSkin", ToolTipBorder_Custom);  // borderSkin cannot be changed
			
			// Make sure borderStyle is one of the selected
			switch (this.getStyle("borderStyle"))
			{
				
				case "toolTip":
				case ToolTipBorder_Custom.ERRORTIP_ABOVE:
				case ToolTipBorder_Custom.ERRORTIP_ABOVE_INSET:
				case ToolTipBorder_Custom.ERRORTIP_BELOW:
				case ToolTipBorder_Custom.ERRORTIP_BELOW_INSET:
				case ToolTipBorder_Custom.ERRORTIP_LEFT:
				case ToolTipBorder_Custom.ERRORTIP_LEFT_INSET:
				case ToolTipBorder_Custom.ERRORTIP_RIGHT:
				case ToolTipBorder_Custom.ERRORTIP_RIGHT_INSET:
				{
					
					break;
					
				}
				
				default:
				{
					
					this.setStyle("borderStyle", ToolTipBorder_Custom.ERRORTIP_RIGHT_INSET);
					break;
					
				}
				
			}
			
			//trace("====="+this.getStyle("borderColor")+" "+ToolTipBorder_Custom.DEFAULT_COLOR+" "+0xFFFF00);
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
		}
		
	}
	
}