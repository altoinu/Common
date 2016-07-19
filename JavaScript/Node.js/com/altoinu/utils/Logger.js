function consoleMethod() {

	if (this.enabled) {

		var args = Array.prototype.slice.call(arguments);
		var method = args[0];

		// if (args.length > 1)
		// args[0] = logPrefix + args[0];

		console[method].apply(console, [
			this.prefix
		].concat(args.slice(1)));

	}

}

var Logger = function(enabled) {

	// --------------------------------------------------------------------------
	//
	// public variables
	//
	// --------------------------------------------------------------------------

	this.enabled = (enabled === undefined) ? true : enabled;

	this.prefix = '';

};

// --------------------------------------------------------------------------
//
// public methods
//
// --------------------------------------------------------------------------

Logger.prototype.log = function() {

	var args = Array.prototype.slice.call(arguments);
	consoleMethod.apply(this, [
		'log'
	].concat(args));

};

Logger.prototype.error = function() {

	var args = Array.prototype.slice.call(arguments);
	consoleMethod.apply(this, [
		'error'
	].concat(args));

};

module.exports = Logger;