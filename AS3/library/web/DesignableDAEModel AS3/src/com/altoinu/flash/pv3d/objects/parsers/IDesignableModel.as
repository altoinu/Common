/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.objects.parsers
{
	
	import com.altoinu.flash.customcomponents.drawingboard.IDrawingBoard;
	import com.altoinu.flash.pv3d.materials.DrawingBoardMaterial;
	
	/**
	 * <code>IDesignableModel</code> defines properties and methods required for Papervision
	 * 3D models that use <code>DrawingBoardMaterial</code> as the material so its texture can
	 * be customized.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public interface IDesignableModel extends IDrawingBoard
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * <code>DrawingBoardMaterial</code> applied to the model.  This is where all custom design is placed.
		 */
		function get designMaterial():DrawingBoardMaterial;
		
		/**
		 * @private
		 */
		function set designMaterial(value:DrawingBoardMaterial):void;
		
		function get modelLoaded():Boolean;
		
	}
	
}