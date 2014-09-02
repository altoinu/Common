/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils
{
	
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * Utility functions you can use on Classes.
	 */
	public class ClassUtil
	{
		
		//private static const objDescription:Dictionary = new Dictionary(true);
		private static const objDescription:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Class static methods
		//
		//--------------------------------------------------------------------------
		
		public static function describeType(value:*):XML
		{
			
			if (value is Class)
			{
				
				// Return object description of Class as is
				return flash.utils.describeType(value);
				
			}
			else
			{
				
				var className:String = getQualifiedClassName(value);
				if (!objDescription.hasOwnProperty(className))
				{
					
					// Let's remember result of flash.utils.describeType for this object type
					// since this AS3 method is performance hog
					objDescription[className] = flash.utils.describeType(value);
					
				}
				
				return objDescription[className];
				
			}
			
		}
		
		public static function cloneObject(source:Object):*
		{
			
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			
			return(copier.readObject());
			
		}
		
		[Deprecated(replacement="com.altoinu.flash.utils.ClassUtil.getClassNameString")]
		public static function typeOf(objOrClass:Object):String
		{
			
			return getClassNameString(objOrClass);
			
		}
		
		public static function getClassNameString(objOrClass:Object):String
		{
			
			var desc:String = getQualifiedClassName(objOrClass);
			var a:Array = desc.split(/::/);
			
			return a[a.length-1];
			
		}
		
		public static function typeSubclassedFrom(objOrClass:*):String
		{
			
			var desc:String = getQualifiedSuperclassName(objOrClass);
			
			// Rev 0.1
			//var search:RegExp = new RegExp(derivedFrom);
			//return search.test(desc);
			var a:Array = desc.split(/::/);
			
			return a[a.length-1];
			
		}
		
		/**
		 * Returns Array of getter property names of specified object.
		 * @param obj
		 * 
		 */
		public static function getGetterPropertiesOf(obj:*):Array
		{
			
			if (obj == null)
				return null;
			
			var objClassType:XML = describeType(obj);
			var getters:XMLList = objClassType.accessor.((@access == "readwrite") || (@access == "readonly"));
			
			var getterNames:Array = [];
			for each (var accessor:XML in getters)
			{
				
				getterNames.push(String(accessor.@name));
				
			}
			
			return getterNames;
			
		}
		
		/**
		 * Returns Array of setter property names of specified object.
		 * @param obj
		 * @return 
		 * 
		 */
		public static function getSetterPropertiesOf(obj:*):Array
		{
			
			if (obj == null)
				return null;
			
			var objClassType:XML = describeType(obj);
			var setters:XMLList = objClassType.accessor.((@access == "readwrite") || (@access == "writeonly"));
			
			var setterNames:Array = [];
			for each (var accessor:XML in setters)
			{
				
				setterNames.push(String(accessor.@name));
				
			}
			
			return setterNames;
			
		}
		
		/**
		 * Returns Array of variable names of specified object.
		 * @param obj
		 * @return 
		 * 
		 */
		public static function getVariableNamesOf(obj:*):Array
		{
			
			if (obj == null)
				return null;
			
			var objClassType:XML = describeType(obj);
			var variables:XMLList = objClassType.variable;
			
			var variableNames:Array = [];
			for each (var varName:XML in variables)
			{
				
				variableNames.push(String(varName.@name));
				
			}
			
			return variableNames;
			
		}
		
		/**
		 * Returns Class definition of property in <code>obj</code> specified by <code>propertyName</code>.
		 * @param obj
		 * @param propertyName
		 * @return 
		 * 
		 */
		public static function getDefinitionOfProperty(obj:*, propertyName:String):Class
		{
			
			var objClassType:XML = describeType(obj);
			var accessorType:String = objClassType.accessor.(@name == propertyName).@type[0];
			if (!accessorType)
				accessorType = objClassType.variable.(@name == propertyName).@type[0];
			
			return getDefinitionByName(accessorType) as Class;
			
		}
		
		/**
		 * Returns class definition, either Array or Vector.<[whatever]> of data[propertyName]. null if neither.
		 * @param data
		 * @return 
		 * 
		 */
		public static function isArrayOrVector(obj:*, propertyName:String):Class
		{
			
			if (!obj)
			{
				
				throw new Error("data must be defined");
				return null;
				
			}
			
			var accessors:XMLList = describeType(obj).accessor.(@name == propertyName);
			if (accessors.length() > 0)
			{
				
				var classDef:Class = getDefinitionByName(accessors[0].@type) as Class;
				var testObj:Object = new classDef();
				return (testObj is Array) || isVector(testObj) ? classDef : null;
				
			}
			else
			{
				
				return null;
				
			}
			
		}
		
		public static function isVector(obj:*):Boolean
		{
			
			return obj is Vector.<*>;
			
		}
		
		/**
		 * Returns class definition of elements that <code>vector</code> can accept.
		 * @param vector
		 * @return 
		 * 
		 */
		public static function getVectorElementClass(vector:Vector.<*>):Class
		{
			
			var vectorDefName:String = String(describeType(vector).@name);
			vectorDefName = vectorDefName.substring(vectorDefName.indexOf("<") + 1, vectorDefName.lastIndexOf(">"));
			
			return getDefinitionByName(vectorDefName) as Class;
			
		}
		
		/**
		 * Returns true if <code>thisObjOrClass</code> extends <code>extendsThisClass</code>.
		 * @param thisObjOrClass
		 * @param extendsThisClass
		 * @return 
		 * 
		 */
		public static function extendsClass(thisObjOrClass:*, extendsThisClass:Class):Boolean
		{
			
			/*
			var testObj:Object = (thisObjOrClass is Class) ? new thisObjOrClass() : thisObjOrClass;
			
			var superClassName:String = getQualifiedClassName(new extendsThisClass());
			
			return describeType(testObj).extendsClass.(@type == superClassName).length() > 0; // Is superClassName listed as one of extendsClass?
			*/
			
			// Class definition of thisObjOrClass
			var testClass:Class = (thisObjOrClass is Class)
				? thisObjOrClass as Class
				: getDefinitionByName(getQualifiedClassName(thisObjOrClass)) as Class;
			
			// thisObjOrClass extends extendsThisClass if
			// they are equal or
			// describeType indicates testClass factory contains extendsThisClass as one of extended class types
			return (testClass == extendsThisClass) ||
				describeType(testClass).factory.extendsClass.(@type == getQualifiedClassName(extendsThisClass)).length() > 0;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/** 
		 * Constructor.  You do not create an instance of this class... just call its static functions
		 */
		public function ClassUtil()
		{
			
			throw("You do not create an instance of ClassUtil.  Just call its static functions");
			
		}
		
	}
	
}