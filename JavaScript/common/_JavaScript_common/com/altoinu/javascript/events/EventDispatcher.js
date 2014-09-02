/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 * 
 * @author Kaoru Kawashima http://www.altoinu.com
 * 
 * Requirements:
 * 
 * com.altoinu.javascript.utils.utils.js 1.2
 * 
 * @param $targetObject
 *            Object which methods and classes will be defined under.
 */
(function($targetObject) {

	var namespace = "com.altoinu.javascript.events";
	var version = "1.1";
	console.log(namespace + " - EventDispatcher.js: " + version);

	// Create namespace on $targetObject and set object in it
	var ns = $targetObject.com.altoinu.javascript.utils.createNamespace($targetObject, namespace);

	// --------------------------------------------------------------------------
	//
	// Event
	//
	// --------------------------------------------------------------------------

	/**
	 * 
	 * @param type
	 * @param bubbles
	 * @param cancelable
	 * @returns {ns.Event}
	 */
	ns.Event = function(type, bubbles, cancelable) {

		// --------------------------------------------------------------------------
		//
		// Public properties
		//
		// --------------------------------------------------------------------------

		this.type = type;
		this.bubbles = bubbles; // TODO: to be implemented
		this.cancelable = cancelable; // TODO: to be implemented

		this.target;
		this.currentTarget; // TODO: to be implemented
		this.eventPhase; // TODO: to be implemented

	};

	ns.Event.prototype.clone = function() {

		return new ns.Event(this.type, this.bubbles, this.cancelable);

	};

	// --------------------------------------------------------------------------
	//
	// EventDispatcher
	//
	// --------------------------------------------------------------------------

	/**
	 * Aggregates an instance of the EventDispatcher class.
	 * 
	 * Example:
	 * 
	 * var obj = new com.eprize.javascript.events.EventDispatcher();
	 * 
	 * obj.addEventlistener("blah1", function(event) {
	 * 	console.log("blah1 event1");
	 * });
	 * 
	 * var handler = function(event) {
	 * 	console.log("event: 3");
	 * };
	 * 
	 * obj.addEventlistener("blah1", handler, false, 2);
	 * obj.addEventlistener("blah1", handler, false, 0);
	 * obj.addEventlistener("blah1", handler, false, 1);
	 * 
	 * obj.addEventlistener("foo", function(event) {
	 * 	console.log("foo event");
	 * });
	 * 
	 * var event = new com.eprize.javascript.events.Event("blah1");
	 * obj.dispatchEvent(event);
	 * 
	 * @param target
	 * @returns {ns.EventDispatcher}
	 */
	ns.EventDispatcher = function(target) {

		// --------------------------------------------------------------------------
		//
		// Private properties
		//
		// --------------------------------------------------------------------------

		var me = this;
		var bubbleEvents = [];

		var dispatchTarget = target;

		// --------------------------------------------------------------------------
		//
		// Public methods
		//
		// --------------------------------------------------------------------------

		/**
		 * Registers an event listener object with an EventDispatcher object so
		 * that the listener receives notification of an event.
		 * 
		 * @param type
		 *            The type of event.
		 * @param listener
		 *            The listener function that processes the event in form
		 *            function(event) {}.
		 * @param useCapture
		 *            TODO: to be implemented
		 * @param priority
		 *            The priority level of the event listener. All listeners
		 *            with priority n are processed before listeners of priority
		 *            n-1. If two or more listeners share the same priority,
		 *            they are processed in the order in which they were added.
		 *            The default priority is 0.
		 * @param scope
		 */
		this.addEventListener = function(type, listener, useCapture, priority, scope) {

			// get/create reference to array of event "type"
			bubbleEvents[type] = bubbleEvents[type] || [];

			// add new handler with priority
			if ((priority == undefined) || isNaN(Number(priority)))
				priority = 0;

			bubbleEvents[type].push({
				priority: priority,
				handler: {
					func: listener,
					scope: scope
				}
			});

			// Sort in order of priority
			bubbleEvents[type].sort(function(a, b) {

				if (a.priority < b.priority)
					return 1; // a < b
				else if (a.priority > b.priority)
					return -1; // a > b
				else
					return 0; // a == b

			});

		};

		/**
		 * Removes a listener from the EventDispatcher object.
		 * 
		 * @param type
		 *            The type of event.
		 * @param listener
		 *            The listener object to remove.
		 * @param useCapture
		 *            TODO: to be implemented
		 * @returns {Boolean}
		 */
		this.removeEventListener = function(type, listener, useCapture) {

			if (bubbleEvents[type]) {

				var listeners = bubbleEvents[type];

				for ( var i = listeners.length - 1; i >= 0; --i) {

					if (listeners[i].handler.func === listener) {

						listeners.splice(i, 1);
						return true;

					}

				}

			}

			return false;

		};

		/**
		 * Checks whether the EventDispatcher object has any listeners
		 * registered for a specific type of event. This allows you to determine
		 * where an EventDispatcher object has altered handling of an event type
		 * in the event flow hierarchy. To determine whether a specific event
		 * type actually triggers an event listener, use willTrigger().
		 * 
		 * The difference between hasEventListener() and willTrigger() is that
		 * hasEventListener() examines only the object to which it belongs,
		 * whereas willTrigger() examines the entire event flow for the event
		 * specified by the type parameter.
		 * 
		 * @param type
		 * @returns {Boolean}
		 */
		this.hasEventListener = function(type) {

			if (bubbleEvents[type])
				return true;
			else
				return false;

		};

		/**
		 * Checks whether an event listener is registered with this
		 * EventDispatcher object or any of its ancestors for the specified
		 * event type. This method returns true if an event listener is
		 * triggered during any phase of the event flow when an event of the
		 * specified type is dispatched to this EventDispatcher object or any of
		 * its descendants.
		 * 
		 * The difference between the hasEventListener() and the willTrigger()
		 * methods is that hasEventListener() examines only the object to which
		 * it belongs, whereas the willTrigger() method examines the entire
		 * event flow for the event specified by the type parameter.
		 * 
		 * @param type
		 * @returns {Boolean}
		 */
		this.willTrigger = function(type) {

			if (bubbleEvents[type])
				return true;
			else
				return false;

		};

		/**
		 * Dispatches an event into the event flow. The event target is the
		 * EventDispatcher object upon which the dispatchEvent() method is
		 * called.
		 * 
		 * @param event
		 */
		this.dispatchEvent = function(event) {

			if ((event instanceof ns.Event) && bubbleEvents[event.type]) {

				// All listeners for this event type
				var listeners = bubbleEvents[event.type].concat();

				// execute handler function in order
				var numListeners = listeners.length;
				var clonedEvent;
				var eventTarget = dispatchTarget ? dispatchTarget : me;
				for ( var i = 0; i < numListeners; i++) {

					// TODO: capture phase event handler
					//clonedEvent = event.clone();
					//clonedEvent.target = phase event target;
					//clonedEvent.currentTarget = eventTarget;

					// target event handler
					clonedEvent = event.clone();
					clonedEvent.target = eventTarget;
					clonedEvent.currentTarget = eventTarget;
					listeners[i].handler.func.call(listeners[i].handler.scope ? listeners[i].handler.scope : me, clonedEvent);

					// TODO: bubble up phase event
					//clonedEvent = event.clone();
					//clonedEvent.target = phase event target;
					//clonedEvent.currentTarget = eventTarget;

				}

			}

		};

	};

	return ns;

})(window);
// You can change $targetObject here to something other than default reference
// to "window" object to store elements and classes under it
