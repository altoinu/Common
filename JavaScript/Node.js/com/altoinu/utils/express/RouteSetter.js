/**
 * 2017-09-11
 * v1.1
 */
var Logger = require('../utils/Logger.js');
var logger = new Logger();
logger.prefix = 'RouteSetter:';

var mod_express = require('express');
var mod_Q = require('q');

/**
 * Array of path to route definition modules.
 * Each module should be either
 * - instance of express.Router(), or
 * - Object {
 * route: instance of express.Router(),
 * shutown: function(),
 * (optional) baseUrl: 'example: /api'
 * }
 */
var routesDefObj = [];

module.exports = function(routesDef) {

	// --------------------------------------------------------------------------
	//
	// private variables
	//
	// --------------------------------------------------------------------------

	var router = mod_express.Router();

	// --------------------------------------------------------------------------
	//
	// Routes
	//
	// --------------------------------------------------------------------------

	var routeCheck = function(req, res, next) {

		logger.log('================================================Route');
		logger.log('req.originalUrl', req.method, req.originalUrl);
		logger.log('req.baseUrl', req.baseUrl);
		logger.log('req.path', req.path);
		logger.log('req.url', req.url);

		if (req.query) {

			//logger.log('req.query');
			logger.log('req.query', req.query);

		}
		//logger.log('req.route');
		//logger.log(req.route);

		next();

	};

	var subRouter = mod_express.Router();
	subRouter.use(routeCheck);

	// Read and set defined routes
	var args = Array.prototype.slice.call(routesDef);
	args.forEach(function(def, i, array) {

		logger.log(def);

		var r = require(def);
		routesDefObj.push(r);

		if (r.hasOwnProperty('route')) {

			if (r.hasOwnProperty('baseUrl') && r.baseUrl) {

				// put this route under defined baseUrl
				var subSubRouter = mod_express.Router();
				subSubRouter.use(routeCheck);
				subSubRouter.use(r.route);
				subRouter.use(r.baseUrl, subSubRouter);

			} else {

				subRouter.use(r.route);

			}

		} else {

			subRouter.use(r);

		}

	});

	router.use(subRouter);

	return {
		routes: router,
		shutdown: function() {

			// run shutdown stuff for each route
			return mod_Q.allSettled(routesDefObj.map(function(def, index, array) {

				if (def.hasOwnProperty('shutdown') && (typeof def.shutdown === 'function'))
					return def.shutdown();
				else
					return mod_Q.resolve();

			}));

		}
	};

};
