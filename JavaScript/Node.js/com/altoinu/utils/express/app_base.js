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

var ObjectUtils = require('./ObjectUtils.js');

// --------------------------------------------------------------------------
//
// module
//
// --------------------------------------------------------------------------

/**
 * 
 * @param logPrefix
 * @param config
 *            {appSettings, middleware, routeSetterDef, serverPort}
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
	app.use(routeSetterDef.routes);

	// catch 404 and forward to error handler
	app.use(function(req, res, next) {

		var err = new Error('Not Found');
		err.status = 404;
		next(err);

	});

	// development error handler
	// will print stacktrace
	if (app.get('env') === 'development') {

		app.use(function(err, req, res, next) {

			res.status(err.status || 500);
			res.render('error', {
				message: err.message,
				error: err
			});

		});

	}

	// production error handler
	// no stacktraces leaked to user
	app.use(function(err, req, res, next) {

		// res.status(err.status || 500).send(ObjectUtils.convertToErrorObj(err));
		res.status(err.status || 500);
		res.render('error', {
			message: err.message,
			error: {}
		});

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

module.exports = app_base;