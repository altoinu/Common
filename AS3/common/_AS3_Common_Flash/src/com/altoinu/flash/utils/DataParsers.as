/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	import flash.utils.describeType;
	
	/**
	 * Author(s): Kaoru Kawashima
	 * Utility functions to parse through data.
	 * 
	 */
	public class DataParsers
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Converts XML to Object by copying every element into name=value.  Attributes are converted with "a_" appended at the beginning,
		 * so for example: <code>&lt;root&gt;&lt;person firstname="John"&gt;...</code> becomes <code>object.a_firstname == "John."</code>
		 * 
		 * @param sourceXML
		 * @return New Object created from sourceXML.
		 * 
		 */
		public static function convertXMLToObject(sourceXML:XML):Object
		{
			
			if (sourceXML == null)
				return null;
			
			var copiedObject:Object = new Object();
			
			var sourceChildren:XMLList = sourceXML.children();
			var numItems:int = sourceChildren.length()
			for (var i:int = 0; i < numItems; i++)
			{
				
				copiedObject[sourceChildren[i].name()] = isFinite(sourceXML.children()[i]) ? Number(sourceChildren[i]) : sourceChildren[i];
				
			}
			
			var sourceAttributes:XMLList = sourceXML.attributes();
			var numAttributes:int = sourceAttributes.length();
			for (var j:int = 0; j < numAttributes; j++)
			{
				
				copiedObject["a_"+sourceAttributes[j].name()] = isFinite(sourceXML.attributes()[j]) ? Number(sourceAttributes[j]) : sourceAttributes[j];
				
			}
			
			return copiedObject;
			
		}
		
		/**
		 * Copies all dynamic properties in specified sourceObject, and returns new Object
		 * containing the same exact properties.
		 * @param sourceObject
		 * @return New Object contaiing the same exact properties, or null if sourceObject is null.
		 * 
		 */
		public static function copyDynamicProperties(sourceObject:Object):Object
		{
			
			if (sourceObject == null)
				return null;
			
			var copiedObject:Object = new Object();
			
			for (var dynamicProp:String in sourceObject)
			{
				
				copiedObject[dynamicProp] = sourceObject[dynamicProp];
				
			}
			
			return copiedObject;
			
		}
		
		[Deprecated(replacement="copyFixedProperties")]
		public static function copyFixeProperties(sourceObject:Object):Object
		{
			
			return copyFixedProperties(sourceObject);
			
		}
		
		/**
		 * Copies all fixed properties (public properties defined in class definition) in specified sourceObject,
		 * and returns new Object containing the same exact properties as dynamic properties.
		 * @param sourceObject
		 * @return New Object contaiing the same exact properties, or null if sourceObject is null.
		 * 
		 */
		public static function copyFixedProperties(sourceObject:Object):Object
		{
			
			if (sourceObject == null)
				return null;
			
			var sourceClassType:XML = describeType(sourceObject);
			var sourceClassProperties:XMLList = sourceClassType.accessor.((@access == "readwrite") || (@access == "writeonly"));
			sourceClassProperties = new XMLList(sourceClassProperties.toXMLString() + XMLList(sourceClassType.variable).toXMLString());
			
			var copiedObject:Object = new Object();
			
			for each (var accessor:XML in sourceClassProperties)
			{
				
				var accessorName:String = accessor.@name;
				copiedObject[accessorName] = sourceObject[accessorName];
				
			}
			
			return copiedObject;
			
		}
		
		/**
		 * Takes <code>sourceString</code> which contains name=value pair objects separated by <code>separateChar</code> and
		 * converts it into Object.  For example, string "firstname=kaoru,lastname=kawashima,city=pleasant,ridge" is converted
		 * into Object so the data will be available in form: obj.firstname = kaoru, obj.lastname = kawashima, and obj.city =
		 * pleasant,ridge
		 * 
		 * @param sourceString
		 * @param separateChar
		 * @return 
		 * 
		 */
		public static function decodeNameValuePairObjects(sourceString:String, separateChar:String = ","):Object
		{
			
			if (sourceString.indexOf("=") == -1)
			{
				
				// Source does not have = sign.  Invalid
				throw(new Error("Specified sourceString is not in valid form... It does not have any equal sign."));
				return null;
				
			}
			
			var nameValuePair:Object = {};
			
			var currentIndex:int = 0;
			while ((currentIndex < sourceString.length) && (sourceString.indexOf("=", currentIndex) != -1))
			{
				
				// String from currentIndex to sourceString.indexOf("=", currentIndex) is propertyName
				var equalSignIndex:int = sourceString.indexOf("=", currentIndex);
				var propertyName:String = sourceString.substring(currentIndex, equalSignIndex);
				
				
				var propertyData:String;
				
				var nextSeparateCharIndex:int = sourceString.indexOf(separateChar, equalSignIndex + 1);
				if (nextSeparateCharIndex == -1)
				{
					
					// No more separateChar after the equal sign in the sourceString, use the rest as propertyData
					propertyData = sourceString.substring(equalSignIndex + 1);
					
					currentIndex = sourceString.length;
					
				}
				else
				{
					
					// There is a separateChar after the equal sign, see if there is next equal following it
					var nextEqualSignIndex:int = sourceString.indexOf("=", nextSeparateCharIndex + 1);
					
					if (nextEqualSignIndex == -1)
					{
						
						// There is no equal sign after next separateChar.  This separateChar is part of the last data.
						// Use the rest as propertyData
						propertyData = sourceString.substring(equalSignIndex + 1);
						
						currentIndex = sourceString.length;
						
					}
					else
					{
						
						// There is an equal sign after next separateChar.
						// propertyData is everything from the current equal sign up to last separateChar before next equal sign
						var textBetweenCurrentEqualSignAndNext:String = sourceString.substring(equalSignIndex + 1, nextEqualSignIndex);
						var lastSeparateCharIndexBeforeNextEqualSign:int = textBetweenCurrentEqualSignAndNext.lastIndexOf(separateChar);
						propertyData = textBetweenCurrentEqualSignAndNext.substring(0, lastSeparateCharIndexBeforeNextEqualSign);
						
						// Remember the index number of sourceString position which is the start of next propertyName
						currentIndex = equalSignIndex + 1 + lastSeparateCharIndexBeforeNextEqualSign + 1;
						
					}
					
				}
				
				// Save data
				nameValuePair[propertyName] = propertyData;
				
			}
			
			return nameValuePair;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.  You do not create an instance of this class... just call its static functions.
		 * 
		 */
		public function DataParsers()
		{
			
			throw("You do not create an instance of DataParsers.  Just call its static functions");
			
		}
		
	}
	
}