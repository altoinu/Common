/**
 * Usage
 * require('./CORS.js')({
 * 	"origin": [
 * 		"http://localhost",
 * 		"http://localhost:3001",
 * 		"http://www.example.com",...
 * 	]
 * });
 */
// --------------------------------------------------------------------------
//
// private variables
//
// --------------------------------------------------------------------------
var Logger = require('../utils/Logger.js');
var logger = new Logger();
logger.prefix = 'CORS:';

//--------------------------------------------------------------------------
//
// stuff
//
// --------------------------------------------------------------------------

/**
 * Express js middleware to allow CORS request on origin specified in corsDef
 * 
 * @param corsDef {origin: ["http://...", "http://...",...]}
 */
var allow = function(corsDef, req, res, next) {

	if (req.method == 'OPTIONS') {

		logger.log(req.method + ' ' + req.originalUrl);
		logger.log(req.headers);

	}

	if (req.headers.hasOwnProperty('origin')) {

		// header contains origin for CORS

		if (corsDef.origin.indexOf(req.headers.origin) != -1) {

			// origin is defined in corsDef, allow cross domain

			// add necessary headers

			logger.log(req.headers.origin);
			res.header('Access-Control-Allow-Origin', req.headers.origin);
			// Access-Control-Allow-Credentials true/false
			// Access-Control-Expose-Headers

			// TODO: set these values in corsDef too?
			var requestMethod;
			var requestHeader;
			for ( var header in req.headers) {

				//logger.log(header, req.headers[header]);

				if (header.toLowerCase() == 'access-control-request-method')
					requestMethod = req.headers[header];

				if (header.toLowerCase() == 'access-control-request-headers')
					requestHeader = req.headers[header];

			}

			if (!requestMethod)
				requestMethod = 'GET,POST,OPTIONS';
			if (!requestHeader)
				requestHeader = 'accept, content-type';

			logger.log(requestMethod);
			logger.log(requestHeader);
			res.header('Access-Control-Allow-Methods', requestMethod);
			res.header('Access-Control-Allow-Headers', requestHeader);

		} else {

			logger.error('CORS error... origin "' + req.headers.origin + '" not specified in env.json');

		}

	}

	// method OPTIONS is browser checking for CORS
	// return status 200
	if (req.method == 'OPTIONS')
		res.status(200).end();
	else
		next();

};

/**
 * 
 * @param corsDef {origin: ["http://...", "http://...",...]}
 */
var CORS = function(corsDef) {

	return {
		allow: allow.bind(this, corsDef)
	/*
	allow: function(req, res, next) {
		allow(corsDef, req, res, next);
	}
	 */
	};

};

module.exports = CORS;