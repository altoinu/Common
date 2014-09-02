/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.flash.utils.collections
{
	/**
	 * 	A LinkedList is a basic collection type that is not included in Flash. LinkedList is expensive
	 * for searching or traversing, but very cheap for inserting as each item in the list is not in the same heap
	 * of memory like an Array. 
	 */
	public class LinkedList
	{
		public var item:Object;
		
		public var next:LinkedList;
		public var prev:LinkedList;
		
		public function getLast():LinkedList
		{
			if(next)
				return next.getLast();
			return this;
		}
		
		public function getFirst():LinkedList
		{
			if(prev)
				return prev.getFirst();
			
			return this;
		}
		
	}
}