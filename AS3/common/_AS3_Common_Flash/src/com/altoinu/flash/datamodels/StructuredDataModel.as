/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.datamodels
{
	
	import com.altoinu.flash.utils.ClassUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Event dispatched when source data is changed to update all values.
	 * 
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * Super class of data models that includes methods of IEventDispatcher.
	 * This class can be extended so it can be used in Flex with data binding on each
	 * public property defined with [Bindable] or [Bindable(event="...")] metadata
	 * tag, but since it does not require any Flex framework it can still be used in
	 * Flash.
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public dynamic class StructuredDataModel extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param sourceData
		 * 
		 */
		public function StructuredDataModel(sourceData:Object = null)
		{
			
			super();
			
			if (sourceData != null)
				setSource(sourceData);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private variables
		//
		//--------------------------------------------------------------------------
		
		private var _source:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function assignProp(propertyName:String, data:Object):void
		{
			
			/*
			if (this[propertyName] is StructuredDataModel)
			{
			
			// Use setSource method to set properties inside it, too
			StructuredDataModel(this[propertyName]).setSource(data);
			
			}
			*/
			
			if (
				(this[propertyName] is StructuredDataModel) ||
				((this[propertyName] == null) && ClassUtil.extendsClass(ClassUtil.getDefinitionOfProperty(this, propertyName), StructuredDataModel))
			)
			{
				
				// If specified property is StructuredDataModel
				// or if it is null but its definition is StructuredDataModel
				
				if (this[propertyName] == null)
				{
					
					// If null, create new instance
					var objClass:Class = ClassUtil.getDefinitionOfProperty(this, propertyName);
					this[propertyName] = new objClass();
					
				}
				
				// Use setSource method to set properties inside it, too
				StructuredDataModel(this[propertyName]).setSource(data);
				
			}
			else
			{
				
				var arrayOrVectorDef:Class = ClassUtil.isArrayOrVector(this, propertyName);
				if (
					arrayOrVectorDef &&
					data &&
					((data is Array) || (data is XMLList))
				)
				{
					
					// We are dealing with assigning Array or Vector source (data) to Array or Vector property (this[propertyName])
					
					// Create a new instance
					this[propertyName] = new arrayOrVectorDef();
					
					// If property is a Vector.<*> class then this will be the class def of each item accepted by it
					var vectorElementClass:Class = ClassUtil.isVector(this[propertyName]) ? ClassUtil.getVectorElementClass(this[propertyName]) : null;
					
					// and push each element to it
					var numItems:int = (data is Array) ? data.length : data.length();
					for (var i:int = 0; i < numItems; i++)
					{
						
						this[propertyName].push(vectorElementClass && ClassUtil.extendsClass(vectorElementClass, StructuredDataModel) ?
							new vectorElementClass(data[i]) :
							data[i]
						);
						
					}
					
				}
				else
				{
					
					// set data as is
					this[propertyName] = data;
					
				}
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The source of data in the data model.
		 * 
		 * <p>Any change that is made directly to the source is not reflected to
		 * ProductListingModelItemDetails object, so always make sure to use
		 * properties and methods of this class to modify the data.</p>
		 * 
		 * @return 
		 * 
		 */
		public function getSource():Object
		{
			
			return _source;
			
		}
		
		/**
		 * Sets the source of data in the data model.  When source is updated through this method,
		 * StructuredDataModel will read all fixed and dynamic properties of the new value
		 * and assigns them to its own properties with corresponding names.  For example,
		 * If the source value has property source.firstname, then the contents of it is assigned
		 * to this.firstname.  Be careful when assigning new data since it will wipe out
		 * all existing data, even the ones not specified in the new source.
		 * 
		 * <p>Any change that is made directly to the source is not reflected to
		 * ProductListingModelItemDetails object, so always make sure to use
		 * properties and methods of this class to modify the data.</p>
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function setSource(value:Object):Object
		{
			
			_source = value;
			
			var copiedProperty:Array = [];
			
			// Find all fixed properties and setters of this class
			var selfClassType:XML = ClassUtil.describeType(this);
			var writePropertyNames:Array = ClassUtil.getSetterPropertiesOf(this);
			writePropertyNames = writePropertyNames.concat(ClassUtil.getVariableNamesOf(this));
			
			// For each fixed properties of this class (public var and setters)
			var accessorName:String;
			var accessorIndex:int;
			var numProps:int = writePropertyNames.length;
			for (accessorIndex = 0; accessorIndex < numProps; accessorIndex++)
			{
				
				accessorName = writePropertyNames[accessorIndex];
				
				if ((value != null) && value.hasOwnProperty(accessorName))
				{
					
					// Copy source's accessorName property to this class's corresponding property
					if (this[accessorName] != value[accessorName])
						assignProp(accessorName, value[accessorName]);
					
				}
				else
				{
					
					// Source does not have accessorName property, so set corresponding public var/setter
					// of this class to null
					assignProp(accessorName, (this[accessorName] is Number) ? NaN : null);
					
				}
				
				// This property value is transferred, remember it
				copiedProperty.push(accessorName);
				
			}
			
			// For each fixed properties of the source (public var and getters)
			if (value != null)
			{
				
				var newValueProperties:Array = ClassUtil.getGetterPropertiesOf(value);
				numProps = newValueProperties.length;
				for (accessorIndex = 0; accessorIndex < numProps; accessorIndex++)
				{
					
					accessorName = newValueProperties[accessorIndex];
					
					//if ((accessorName != "source") && (copiedProperty.indexOf(accessorName) == -1))
					if (copiedProperty.indexOf(accessorName) == -1)
					{
						
						// If it has not been copied yet
						// copy source's accessorName property to this class's corresponding property
						if (this[accessorName] != value[accessorName])
							assignProp(accessorName, value[accessorName]);
						
						// This property value is transferred, remember it
						copiedProperty.push(accessorName);
						
					}
					
				}
				
			}
			
			if (selfClassType.@isDynamic == "true")
			{
				
				// Update dynamic properties as well since this class is marked as so
				
				// First, delete all existing dynamic properties
				for (var dynamicprop:String in this)
				{
					
					if (copiedProperty.indexOf(dynamicprop) == -1) // If it has not been copied from the source yet
						delete this[dynamicprop];
					
				}
				
				if (value != null)
				{
					
					var newValueDynamicProperty:String;
					if (value is XML)
					{
						
						// Get all elements at first level of XML
						for each (var prop:XML in XML(value).elements("*"))
						{
							
							newValueDynamicProperty = prop.name();
							
							if (copiedProperty.indexOf(newValueDynamicProperty) == -1)
							{
								
								// add as a new dynamic property
								if (prop.hasComplexContent())
								{
									
									if (this[newValueDynamicProperty] != prop.children())
										assignProp(newValueDynamicProperty, prop.children());
									
								}
								else
								{
									
									if (this[newValueDynamicProperty] != value[newValueDynamicProperty])
										assignProp(newValueDynamicProperty, value[newValueDynamicProperty]);
									
								}
								
								// This property value is transferred, remember it
								copiedProperty.push(newValueDynamicProperty);
								
							}
							else
							{
								
								// This property has been copied already, yet another XML element
								// has same name.
								// Convert existing property into Array
								//if (this[newValueDynamicProperty] is Array)
								
							}
							
							//if (prop.hasSimpleContent())
							//	this[newValueDynamicProperty] = prop; // add as a new dynamic property
							//trace("--"+prop.name()+" = "+prop.hasComplexContent()+" "+prop.hasSimpleContent() + " " +value[prop.name()]);
							
						}
						
					}
					else
					{
						
						// Get all dynamic properties in the source if there is no fixed property in this class
						for (newValueDynamicProperty in value)
						{
							
							// If sources's dynamic property newValueDynamicProperty does not exist in this class
							// and if it has not been copied yet
							if (copiedProperty.indexOf(newValueDynamicProperty) == -1)
							{
								
								// add as a new dynamic property
								if (this[newValueDynamicProperty] != value[newValueDynamicProperty])
									assignProp(newValueDynamicProperty, value[newValueDynamicProperty]);
								
								// This property value is transferred, remember it
								copiedProperty.push(newValueDynamicProperty);
								
							}
							
						}
						
					}
					
				}
				
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			
			return _source;
			
		}
		
		/**
		 * Generates JSON string using all public readable properties.
		 * @return 
		 * 
		 */
		public function getJSONString():String
		{
			
			var selfClassType:XML = ClassUtil.describeType(this);
			
			var obj:Object = {};
			
			var getters:Array = ClassUtil.getGetterPropertiesOf(this);
			var numGetters:int = getters.length;
			for (var i:int = 0; i < numGetters; i++)
			{
				
				if (!this.hasOwnProperty(getters[i]) || (this[getters[i]] == null))
					obj[getters[i]] = null;
				else if (this[getters[i]].hasOwnProperty("getJSONString") && (this[getters[i]].getJSONString is Function))
					obj[getters[i]] = this[getters[i]].getJSONString();
				else
					obj[getters[i]] = this[getters[i]];
				
			}
			
			if (selfClassType.@isDynamic == "true")
			{
				
				for (var prop:String in this)
				{
					
					if (!obj.hasOwnProperty(prop))
						obj[prop] = this[prop];
					
				}
				
			}
			
			return JSON.stringify(obj);
			
		}
		
	}
	
}