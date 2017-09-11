/**
 * 2017-09-11
 * v1.1
 * 
 * npm modules required:
 * - express
 * - body-parser
 * - cookie-parser
 * - morgan
 * - q
 */
var VERSION = '1.1';
//--------------------------------------------------------------------------
//
// required Node JS modules
//
// --------------------------------------------------------------------------

var mod_express = require('express');
var mod_bodyParser = require('body-parser');
var mod_cookieParser = require('cookie-parser');
var mod_morgan = require('morgan');
var mod_Q = require('q');

//var ObjectUtils = require('./ObjectUtils.js');

// --------------------------------------------------------------------------
//
// module
//
// --------------------------------------------------------------------------

/**
 * 
 * @param logPrefix
 * @param config
 *            {appSettings, middleware, routeSetterDef, baseUrl, serverPort}
 */
var app_base = function(logPrefix, config) {

	// --------------------------------------------------------------------------
	//
	// private variables
	//
	// --------------------------------------------------------------------------

	var Logger = require('./Logger.js');
	var logger = new Logger();
	logger.prefix = logPrefix;

	var appSettings = config.hasOwnProperty('appSettings') ? config.appSettings : null;
	var middleware = config.hasOwnProperty('middleware') ? config.middleware : null;
	var routeSetterDef = config.hasOwnProperty('routeSetterDef') ? config.routeSetterDef : null;
	var baseUrl = config.hasOwnProperty('baseUrl') ? config.baseUrl : null;
	var serverPort = config.hasOwnProperty('serverPort') ? config.serverPort : null;

	var app = mod_express();

	// --------------------------------------------------------------------------
	//
	// stuff
	//
	// --------------------------------------------------------------------------

	// application settings
	if (appSettings) {

		if (!Array.isArray(appSettings)) {

			appSettings = [
				appSettings
			];

		}

		appSettings.forEach(function(setting, index, array) {

			app.set(setting.name, setting.value);

		});

	}

	// default middlewares
	app.use(mod_morgan('dev'));
	app.use(mod_bodyParser.json());
	app.use(mod_bodyParser.urlencoded({
		extended: true
	}));

	// add middleware
	if (middleware) {

		if (!Array.isArray(middleware)) {

			middleware = [
				middleware
			];

		}

		middleware.forEach(function(mid, index, array) {

			app.use(mid);

		});

	}

	// routes
	if (routeSetterDef) {

		// If path specified, mount routes to there [baseUrl]/[routeSetterDef routes]...
		// (ex baseUrl == /api then /api/[routeSetterDef routes]...
		if (baseUrl)
			app.use((baseUrl.charAt(0) != '/' ? '/' : '') + baseUrl, routeSetterDef.routes);
		else
			app.use(routeSetterDef.routes);

	}

	// catch 404 and forward to error handler
	app.use(function(req, res, next) {

		var err = new Error('Not Found');
		err.status = 404;
		next(err);

	});

	// error handlers
	app.use(function(err, req, res, next) {

		res.status(err.status || 500);
		next(err);

	});

	function isDevEnv() {

		return app.get('env') === 'development';

	}

	function createErrorReturnObj(error) {

		var errorObj = {
			status: error.status || 500,
			message: error.message
		};

		if (isDevEnv()) {

			// development error handler
			// will print stacktrace
			errorObj.error = error;

		} else {

			// production error handler
			// no stacktraces leaked to user
			errorObj.error = {
				status: error.status
			};

		}

		return errorObj;

	}

	// return as json if .json is in URL
	app.use('/\*.json', function(err, req, res, next) {

		console.log('.json error');

		var errorObj = createErrorReturnObj(err);
		if (isDevEnv())
			errorObj.error = errorObj.error.stack;

		res.json(errorObj);

	});

	// or render
	app.use(function(err, req, res, next) {

		console.log('render error');

		// res.send(ObjectUtils.convertToErrorObj(err));
		res.render('error', createErrorReturnObj(err));

	});

	// server
	var server = app.listen(serverPort, function() {

		var host = server.address().address;
		var port = server.address().port;

		logger.log('listening at port:' + port);

	});

	return {
		app: app,
		server: server,
		shutdown: function() {

			return mod_Q.allSettled([
				// shutdown server
				(function() {

					var deferred = mod_Q.defer();
					server.close(function() {
						deferred.resolve(server);
					});

					return deferred.promise;

				})(),
				// shutdown routes
				routeSetterDef.shutdown()
			]);

		}
	};

}

app_base.version = VERSION;
module.exports = app_base;