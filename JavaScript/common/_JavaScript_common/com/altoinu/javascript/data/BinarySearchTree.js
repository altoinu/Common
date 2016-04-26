/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.data";
	var version = "1.0.1";
	console.log(namespace + " - BinaryTree.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	var BinarySearchTreeNode = function(data, key) {

		// --------------------------------------------------------------------------
		//
		// Public properties
		//
		// --------------------------------------------------------------------------

		this.data = data;
		this.key = key;

	};

	var BinarySearchTree = function(left, node, parent, right) {

		// --------------------------------------------------------------------------
		//
		// Private properties
		//
		// --------------------------------------------------------------------------

		var me = this;

		// --------------------------------------------------------------------------
		//
		// Public properties
		//
		// --------------------------------------------------------------------------

		/**
		 * Root BinarySearchTreeNode
		 */
		this.node = node;

		/**
		 * Parent BinarySearchTree
		 */
		this.parent = parent;

		/**
		 * Left BinarySearchTree
		 */
		this.left = left;

		/**
		 * Right BinarySearchTree
		 */
		this.right = right;

		// --------------------------------------------------------------------------
		//
		// Public methods
		//
		// --------------------------------------------------------------------------

	};

	/**
	 * Compare key to tree's root node.
	 * Override to do custom comparison.
	 * @param key
	 * @returns {Number} -1 if left, 0 if equal, 1 if right
	 */
	BinarySearchTree.prototype.compare = function(key) {

		if (key < this.node.key)
			return -1;
		else if (key == this.node.key)
			return 0;
		else
			return 1;

	};

	BinarySearchTree.prototype.find = function(key) {
		
		if (this.node == null) {
			
			return null;
			
		} else {
			
			var compareResult = this.compare(key);
			if (compareResult == 0)
				return this;
			else if (compareResult <= -1)
				return (this.left != null) ? this.left.find(key) : null;
			else
				return (this.right != null) ? this.right.find(key) : null;
			
		}
		
	};
	
	/**
	 * Insert node into tree
	 * 
	 * @param newNode
	 * @returns leaf tree of this tree where node is inserted
	 */
	BinarySearchTree.prototype.insert = function(newNode) {

		if (!this.node) {
			
			this.node = newNode;
			return this;
			
		} else {
			
			var compareResult = this.compare(newNode.key);
			if (compareResult == 0) {
				
				// same key, replace node
				this.node = newNode;
				return this;
				
			} else if (compareResult <= -1) {
				
				// look in left
				if (!this.left) {
					
					this.left = new BinarySearchTree(null, newNode, this, null);
					return this.left;
					
				} else {
					
					return this.left.insert(newNode);
					
				}
				
			} else {
				
				// look in right
				if (!this.right) {
					
					this.right = new BinarySearchTree(null, newNode, this, null);
					return this.right;
					
				} else {
					
					return this.right.insert(newNode);
					
				}
				
			}
			
		}

	};

	ns.BinarySearchTreeNode = BinarySearchTreeNode;
	ns.BinarySearchTree = BinarySearchTree;
	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
