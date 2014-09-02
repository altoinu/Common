/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.utils
{
	
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * Utility class that calculates the bounding box dimensions of a Papervision DisplayObject3D.
	 * 
	 */
	public class BoundingBox
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param object The DisplayObject3D instance for which you want to calculate the bounding box
		 */
		public function BoundingBox(object:DisplayObject3D)
		{
			
			parseMesh( object );
		   
			sizeX = maxX - minX;
			sizeY = maxY - minY;
			sizeZ = maxZ - minZ;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var maxX :Number = 0;
		public var minX :Number = 0;
		public var maxY :Number = 0;
		public var minY :Number = 0;
		public var maxZ :Number = 0;
		public var minZ :Number = 0;
	   
		public var sizeX :Number = 0;
		public var sizeY :Number = 0;
		public var sizeZ :Number = 0;
	   
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Here is where we make the doughnuts...
		 * Recursively, we cycle through all objects and child objects, loop 
		 * through each of their vertices and storing the max of each dimension
		 */
		private function parseMesh(object:DisplayObject3D):void
		{
			
			if (object.children)
			{
				
				for each(var child:DisplayObject3D in object.children)
				{
					
					parseMesh(child);
					
				}
				
			}
			
			if (!object.geometry)
				return;
		   
			for each(var vertex:Vertex3D in object.geometry.vertices)
			{
				
				maxX = Math.max(maxX, vertex.x);
				minX = Math.min(minX, vertex.x);
				maxY = Math.max(maxY, vertex.y);
				minY = Math.min(minY, vertex.y);
				maxZ = Math.max(maxZ, vertex.z);
				minZ = Math.min(minZ, vertex.z);
				
			}
			
		}
		
	}
	
} 