/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flex.validators.mx.validators
{
	
	import mx.validators.EmailValidator;
	
	/**
	 * Custom validator to check on multiple fields to make sure they contain valid emails and all matches/do not match.
	 * 
	 * @example <listing version="3.0">
	 * &lt;EmailConfirmFieldsValidator id="validator_Email"
	 * &#xA0;source="{[field_Email1, field_Email2]}" property="text"
	 * &#xA0;required="true"
	 * &#xA0;requiredFieldError="Emails are required."
	 * &#xA0;notSameError="Emails do not match."/&gt;
	 * </listing>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class EmailConfirmFieldsValidator extends SameContentsValidator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Validator used for email.
		 */
		private static const VALIDATOR_EMAIL:EmailValidator = new EmailValidator();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function EmailConfirmFieldsValidator()
		{
			
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		override protected function doValidation(value:Object):Array
		{
			
			var results:Array = [];
			
			// do base validation for all items
			results = super.doValidation(value);
			
			if (results.length > 0)
				return results;
			
			var fieldsData:Array = value as Array;
			var numItems:int = fieldsData.length;
			
			for (var i:int = 0; i < numItems; i++)
			{
				
				var emailVarlidationResults:Array = VALIDATOR_EMAIL.validate(fieldsData[i]).results;
				if (emailVarlidationResults != null)
					results = results.concat(emailVarlidationResults);
				
			}
			
			return results;
			
		}
		
	}
	
}