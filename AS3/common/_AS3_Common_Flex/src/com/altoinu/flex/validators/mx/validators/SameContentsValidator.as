/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.validators.mx.validators
{
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.events.FlexEvent;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	/**
	 * The SameContentsValidator checks on multiple fields to make sure they contain same contents,
	 * or make sure they all contain different contents, depending on the property <code>match</code>.
	 * 
	 * <p>The SameContentsValidator behaves the same as normal Validator, except that it expects
	 * Array of objects containing the property to validate. So when defining this validator in MXML,
	 * make sure you specify source="[object1, object2, ...]".</p>
	 * 
	 * <pre>
	 *  &lt;mx:SameContentsValidator 
	 *    enabled="true|false" 
	 *    listener="<i>Value of the source property</i>" 
	 *    match="true|false"
	 *    notSameError="Specified fields do not match."
	 *    property="<i>No default</i>" 
	 *    required="true|false" 
	 *    requiredFieldError="This field is required." 
	 *    sameError="Specified fields cannot match."
	 *    source="[<i>No default</i>, <i>No default</i>, ...]" 
	 *    trigger="<i>Value of the source property</i>" 
	 *    triggerEvent="valueCommit" 
	 *  /&gt;
	 * </pre>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class SameContentsValidator extends Validator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private static const DEFAULT_NOT_SAME_ERROR:String = "Specified fields do not match.";
		private static const DEFAULT_SAME_ERROR:String = "Specified fields cannot match.";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function SameContentsValidator()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function get actualTrigger():IEventDispatcher
		{
			
			throw new Error("actualTrigger property is not used in SameContentsValidator.");
			
			return null;
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get actualListeners():Array
		{
			
			var result:Array = [];
			
			if (listener)
				result.push(listener);
			else if ((_source != null) && (_source is Array))
				result = result.concat(_source);
			
			return result;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  property
		//----------------------------------
		
		[Inspectable(category="General")]
		/**
		 * @inheritDoc
		 */
		override public function get property():String
		{
			
			return super.property;
			
		}
		
		/**
		 * @private
		 */
		override public function set property(value:String):void
		{
			
			super.property = value;
			
		}
		
		//----------------------------------
		//  source
		//----------------------------------
		
		private var _source:Object;
		
		[Inspectable(category="General")]
		/**
		 * Specifies the Array of objects containing the property to validate.
		 */
		override public function get source():Object
		{
			
			return _source;
			
		}
		
		/**
		 * @private
		 */
		override public function set source(value:Object):void
		{
			
			if (_source == value)
				return;
			
			if (!(value is Array))
			{
				
				throw new Error("You must specify Array of objects containing property to validate.");
				
			}
			
			// Remove the listener from the old source.
			removeTriggerHandler();
			removeListenerHandler();
			
			_source = value;
			
			// Listen for the trigger event on the new source.
			addTriggerHandler();
			addListenerHandler();
			
		}
		
		//----------------------------------
		//  trigger
		//----------------------------------
		
		private var _trigger:IEventDispatcher;
		
		[Inspectable(category="General")]
		/**
		 * @inheritDoc
		 */
		override public function get trigger():IEventDispatcher
		{
			
			return _trigger;
			
		}
		
		/**
		 * @private
		 */
		override public function set trigger(value:IEventDispatcher):void
		{
			
			removeTriggerHandler();
			_trigger = value;
			addTriggerHandler();
			
		}
		
		//----------------------------------
		//  triggerEvent
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the triggerEvent property.
		 */
		private var _triggerEvent:String = FlexEvent.VALUE_COMMIT;
		
		[Inspectable(category="General")]
		/**
		 * @inheritDoc
		 */
		override public function get triggerEvent():String
		{
			
			return _triggerEvent;
			
		}
		
		/**
		 * @private
		 */
		override public function set triggerEvent(value:String):void
		{
			
			if (_triggerEvent == value)
				return;
			
			removeTriggerHandler();
			_triggerEvent = value;
			addTriggerHandler();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  notSameError
		//----------------------------------
		
		private var _notSameError:String = DEFAULT_NOT_SAME_ERROR;
		
		[Inspectable(category="Errors", defaultValue="null")]
		/**
		 * Error message to display if any specified values do not match.
		 * 
		 * @default "Specified fields do not match."
		 */
		public function get notSameError():String
		{
			
			return _notSameError;
			
		}
		
		/**
		 * @private
		 */
		public function set notSameError(value:String):void
		{
			
			_notSameError = (value != null) ? value : DEFAULT_NOT_SAME_ERROR;
			
		}
		
		//----------------------------------
		//  sameError
		//----------------------------------
		
		private var _sameError:String = DEFAULT_SAME_ERROR;
		
		[Inspectable(category="Errors", defaultValue="null")]
		/**
		 * Error message to display if any specified values match.
		 * 
		 * @default "Specified fields cannot match."
		 */
		public function get sameError():String
		{
			
			return _sameError;
			
		}
		
		/**
		 * @private
		 */
		public function set sameError(value:String):void
		{
			
			_sameError = (value != null) ? value : DEFAULT_SAME_ERROR;
			
		}
		
		//----------------------------------
		//  match
		//----------------------------------
		
		private var _match:Boolean = true;
		
		/**
		 * If true, then SameContentsValidator will make sure all fields have same contents. If false,
		 * then SameContentsValidator will make sure none of them match.
		 * @default true
		 */
		public function get match():Boolean
		{
			
			return _match;
			
		}
		
		/**
		 * @private
		 */
		public function set match(value:Boolean):void
		{
			
			_match = value;
			
		}
		
		//----------------------------------
		//  ignoreEmpty
		//----------------------------------
		
		private var _ignoreEmpty:Boolean = false;
		
		/**
		 * If true, then empty strings or null elements are ignored. If false, then they
		 * are also compared.
		 * @default false
		 */
		public function get ignoreEmpty():Boolean
		{
			
			return _ignoreEmpty;
			
		}
		
		/**
		 * @private
		 */
		public function set ignoreEmpty(value:Boolean):void
		{
			
			_ignoreEmpty = value;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function getValueFromSource():Object
		{
			
			if ((_source != null) && (_source is Array) && (property != null))
			{
				
				var sourceArray:Array = _source as Array;
				var values:Array = [];
				var numItems:int = sourceArray.length;
				for (var i:int = 0; i < numItems; i++)
				{
					
					values.push(sourceArray[i][property]);
					
				}
				
				return values;
				
			}
			else if ((_source == null) || !(_source is Array))
			{
				
				throw new Error("You must define Array of objects for source property.");
				
			}
			else if (property == null)
			{
				
				throw new Error(resourceManager.getString("validators", "PAttributeMissing"));
				
			}
			
			return null;
			
		}
			
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		override protected function doValidation(value:Object):Array
		{
			
			var fieldsData:Array = value as Array;
			var numItems:int = fieldsData.length;
			var results:Array = [];
			var i:int = 0;
			
			// do base validation for all items
			for (i = 0; i < numItems; i++)
			{
				
				results = super.doValidation(fieldsData[i]);
				
			}
			
			if (results.length > 0)
				return results;
			
			var j:int;
			checkmatchloop: for (i = 0; i < numItems; i++)
			{
				
				if (!ignoreEmpty ||
					((fieldsData[i] != null) && (fieldsData[i] != "")))
				{
					
					for (j = i + 1; j < numItems; j++)
					{
						
						if (!ignoreEmpty ||
							((fieldsData[j] != null) && (fieldsData[j] != "")))
						{
							
							if (match)
							{
								
								// Make sure all matches
								if (fieldsData[i] != fieldsData[j])
								{
									
									// There is a field that does not match
									results.push(new ValidationResult(true, j.toString(), "notSame", notSameError));
									break;
									
								}
								
							}
							else
							{
								
								// Make sure none matches
								if (fieldsData[i] == fieldsData[j])
								{
									
									// There are fields that match
									results.push(new ValidationResult(true, j.toString(), "same", sameError));
									break checkmatchloop;
									
								}
								
							}
							
						}
						
					}
					
				}
				
			}
			
			/*
			if (match)
			{
				
				// Make sure all matches
				var compareToItem:Object;
				for (i = 0; i < numItems; i++)
				{
					
					if (i != 0)
					{
						
						if (compareToItem != fieldsData[i])
						{
							
							// There is a field that does not match
							results.push(new ValidationResult(true, i.toString(), "notSame", notSameError));
							break;
							
						}
						
					}
					else
					{
						
						compareToItem = fieldsData[i];
						
					}
					
				}
				
			}
			else
			{
				
				
				// Make sure none matches
				var j:int;
				checkmatchloop: for (i = 0; i < numItems; i++)
				{
					
					if (!ignoreEmpty ||
						((fieldsData[i] != null) && (fieldsData[i] != "")))
					{
						
						for (j = i + 1; j < numItems; j++)
						{
							
							if (!ignoreEmpty ||
								((fieldsData[j] != null) && (fieldsData[j] != "")))
							{
								
								if (fieldsData[i] == fieldsData[j])
								{
									
									// There are fields that match
									results.push(new ValidationResult(true, i.toString(), "same", sameError));
									break checkmatchloop;
									
								}
								
							}
							
						}
						
					}
					
				}
				
			}
			*/
			
			return results;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function addTriggerHandler():void
		{
			
			if (_trigger != null)
			{
				
				_trigger.addEventListener(_triggerEvent, triggerHandler);
				
			}
			else if ((_source != null) && (_source is Array))
			{
				
				var sourceArray:Array = _source as Array;
				var numItems:int = sourceArray.length;
				for (var i:int = 0; i < numItems; i++)
				{
					
					var item:Object = sourceArray[i];
					if (item is IEventDispatcher)
						IEventDispatcher(item).addEventListener(_triggerEvent, triggerHandler);
					
				}
				
			}
			
		}
		
		/**
		 * @private
		 */
		private function removeTriggerHandler():void
		{
			
			if (_trigger != null)
			{
				
				_trigger.removeEventListener(_triggerEvent, triggerHandler);
				
			}
			else if ((_source != null) && (_source is Array))
			{
				
				var sourceArray:Array = _source as Array;
				var numItems:int = sourceArray.length;
				for (var i:int = 0; i < numItems; i++)
				{
					
					var item:Object = sourceArray[i];
					if (item is IEventDispatcher)
						IEventDispatcher(item).removeEventListener(_triggerEvent, triggerHandler);
					
				}
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function triggerHandler(event:Event):void
		{
			
			validate();
			
		}
		
	}
	
}