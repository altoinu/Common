/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.pv3d.objects
{
	
	import org.papervision3d.core.geom.TriangleMesh3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.proto.MaterialObject3D;
	
	/**
	 * Papervision Torus (Donut shape) object.  Converted into Papervision from Away3D.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class Torus extends TriangleMesh3D
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor.
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param material
		 * @param radius
		 * @param tube
		 * @param segmentsR
		 * @param segmentsT
		 * @param yUp
		 * 
		 */
		public function Torus( material:MaterialObject3D = null, radius:Number = 100, tube:Number = 50, segmentsR:int = 8, segmentsT:int = 6, yUp:Boolean = true)
		{
			
			super( material, new Array(), new Array(), null );
			
			this._radius = radius;
			this._tube = tube;
			this._segmentsR = segmentsR;
			this._segmentsT = segmentsT;
			this._yUp = yUp;
			
			buildTorus(_radius, _tube, _segmentsR, _segmentsT, _yUp);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var grid:Array;
		private var _radius:Number;
		private var _tube:Number;
		private var _segmentsR:int;
		private var _segmentsT:int;
		private var _yUp:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function buildTorus(radius:Number, tube:Number, segmentsR:int, segmentsT:int, yUp:Boolean):void
		{
			
			this.geometry.ready = true;
			
			var i:int;
			var j:int;
			
			var aVertice:Array = this.geometry.vertices;
			var aFace:Array = this.geometry.faces;
			var aUV:Array = new Array();
			
			grid = new Array(segmentsR);
			
			for (i = 0; i < segmentsR; i++)
			{
				grid[i] = new Array(segmentsT);
				for (j = 0; j < segmentsT; j++)
				{
					var u:Number = (i / segmentsR) * 2 * Math.PI;
					var v:Number = (j / segmentsT) * 2 * Math.PI;
					
					if (yUp)
					{
						
						grid[i][j] = new Vertex3D((radius + tube*Math.cos(v))*Math.cos(u), tube*Math.sin(v), (radius + tube*Math.cos(v))*Math.sin(u));
						aVertice.push(grid[i][j]);
						
					}
					else
					{
						
						grid[i][j] = new Vertex3D((radius + tube*Math.cos(v))*Math.cos(u), -(radius + tube*Math.cos(v))*Math.sin(u), tube*Math.sin(v));
						aVertice.push(grid[i][j]);
						
					}
					
				}
				
			}
			
			for (i = 0; i < segmentsR; i++)
			{
				
				for (j = 0; j < segmentsT; j++)
				{
					
					var ip:int = (i+1) % segmentsR;
					var jp:int = (j+1) % segmentsT;
					var a:Vertex3D = grid[i ][j];
					var b:Vertex3D = grid[ip][j];
					var c:Vertex3D = grid[i ][jp];
					var d:Vertex3D = grid[ip][jp];
					
					var uva:NumberUV = new NumberUV(i / segmentsR, j / segmentsT);
					var uvb:NumberUV = new NumberUV((i+1) / segmentsR, j / segmentsT);
					var uvc:NumberUV = new NumberUV(i / segmentsR, (j+1) / segmentsT);
					var uvd:NumberUV = new NumberUV((i+1) / segmentsR, (j+1) / segmentsT);
					
					aFace.push( new Triangle3D( this, [ a, b, c], material, [uva, uvb, uvc]) );
					
					aFace.push( new Triangle3D( this, [d, c, b], material, [uvd, uvc, uvb]) );
					
				}
				
			}
			
		}
		
	}
	
}