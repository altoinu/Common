/*
  Copyright (c) 2008, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.altoinu.flash.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	/**
	 * Class that converts BitmapData into a valid PNG
	 */	
	public class PNGEncoder
	{
		
		/**
		 * Created a PNG image from the specified BitmapData
		 *
		 * @param image The BitmapData that will be converted into the PNG format.
		 * @param dpi to be set on resulting PNG.
		 * @param scaleImageToDPI If true (default) PNGEncoder assumes <code>image</code> is at
		 * 72 dpi (or Capabilities.screenDPI) and will scale it to match specified <code>dpi</code>. If false,
		 * PNGEncoder assumes incoming image is already at specified <code>dpi</code>no scaling will happen.
		 * Please note that if this is set to false, image remains untouched but because dpi value may change
		 * resulting PNG may be recognized as different actual size (ex. printing). This may come in handy, though,
		 * when you want to do the actual scaling of the image outside of this method but still want to
		 * specifiy dpi to a certain value.
		 * 
		 * @return a ByteArray representing the PNG encoded image data.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */			
		public static function encode(image:BitmapData, dpi:Number = 72, scaleImageToSpecifiedDPI:Boolean = true):ByteArray
		{
			
			var scaledImage:BitmapData;
			
			// If different dpi specified
			if (scaleImageToSpecifiedDPI && (dpi != Capabilities.screenDPI))
			{
				
				// First scale image to specified dpi
				var scale:Number = dpi / Capabilities.screenDPI;
				scaledImage = new BitmapData(image.width * scale, image.height * scale, image.transparent, 0x00000000);
				var sourceBitmap:Bitmap = new Bitmap(image);
				var scaleMatrix:Matrix = new Matrix(scale, 0, 0, scale);
				scaledImage.draw(sourceBitmap, scaleMatrix);
				
			}
			else
			{
				
				// No scaling
				scaledImage = image;
				
			}
			
			// Create output byte array
			var png:ByteArray = new ByteArray();
			// Write PNG signature
			png.writeUnsignedInt(0x89504e47);
			png.writeUnsignedInt(0x0D0A1A0A);
			
			// Build IHDR chunk
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(scaledImage.width);
			IHDR.writeInt(scaledImage.height);
			IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
			IHDR.writeByte(0);
			writeChunk(png,0x49484452,IHDR);
			
			if (dpi != Capabilities.screenDPI)
			{
				
				// Build pHYs chunk, for dpi setting in PNG
				var pHYs:ByteArray = new ByteArray();
				pHYs.writeInt(dpi * (1 / 0.0254)); // x dpi converted to dots per meter
				pHYs.writeInt(dpi * (1 / 0.0254)); // y dpi converted to dots per meter
				pHYs.writeByte(1);
				var pHYsChunkType:uint = 0x70485973; //"112 72 89 115"
				writeChunk(png, pHYsChunkType, pHYs);
				
			}
			
			// Build IDAT chunk
			var IDAT:ByteArray= new ByteArray();
			for(var i:int=0;i < scaledImage.height;i++) {
				// no filter
				IDAT.writeByte(0);
				var p:uint;
				var j:int;
				if ( !scaledImage.transparent ) {
					for(j=0;j < scaledImage.width;j++) {
						p = scaledImage.getPixel(j,i);
						IDAT.writeUnsignedInt(
							uint(((p&0xFFFFFF) << 8)|0xFF));
					}
				} else {
					for(j=0;j < scaledImage.width;j++) {
						p = scaledImage.getPixel32(j,i);
						IDAT.writeUnsignedInt(
							uint(((p&0xFFFFFF) << 8)|
								(p>>>24)));
					}
				}
			}
			IDAT.compress();
			writeChunk(png,0x49444154,IDAT);
			// Build IEND chunk
			writeChunk(png,0x49454E44,null);
			// return PNG
			return png;
			
		}
		
		private static var crcTable:Array;
		private static var crcTableComputed:Boolean = false;
		
		private static function writeChunk(png:ByteArray, 
										   type:uint, data:ByteArray):void {
			if (!crcTableComputed) {
				crcTableComputed = true;
				crcTable = [];
				var c:uint;
				for (var n:uint = 0; n < 256; n++) {
					c = n;
					for (var k:uint = 0; k < 8; k++) {
						if (c & 1) {
							c = uint(uint(0xedb88320) ^ 
								uint(c >>> 1));
						} else {
							c = uint(c >>> 1);
						}
					}
					crcTable[n] = c;
				}
			}
			var len:uint = 0;
			if (data != null) {
				len = data.length;
			}
			png.writeUnsignedInt(len);
			var p:uint = png.position;
			png.writeUnsignedInt(type);
			if ( data != null ) {
				png.writeBytes(data);
			}
			var e:uint = png.position;
			png.position = p;
			c = 0xffffffff;
			for (var i:int = 0; i < (e-p); i++) {
				c = uint(crcTable[
					(c ^ png.readUnsignedByte()) & 
					uint(0xff)] ^ uint(c >>> 8));
			}
			c = uint(c^uint(0xffffffff));
			png.position = e;
			png.writeUnsignedInt(c);
		}
	}
}