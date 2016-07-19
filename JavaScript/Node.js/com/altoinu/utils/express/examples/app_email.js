var AppVars = require('./appvars.js');
var config = require('./env.json')[AppVars.env];

// --------------------------------------------------------------------------
//
// required Node JS modules
//
// --------------------------------------------------------------------------

var app_base = require('./utils/app_base.js');
var routes = require('./routes/routes_email.js');

// --------------------------------------------------------------------------
//
// private variables
//
// --------------------------------------------------------------------------

var Logger = require('./utils/Logger.js');
var logger = new Logger();
logger.prefix = 'app_email.js:';

logger.log(config);

// --------------------------------------------------------------------------
//
// stuff
//
// --------------------------------------------------------------------------

var appObj = app_base('app_base, app_email.js:', {
	routeSetterDef: routes,
	serverPort: config.EMAIL.port
});

logger.log('module? module.parent =', (module.parent ? true : false));

if (module.parent) {

	module.exports = appObj.app;

} else {

	logger.log('running stand alone');

	process.on('message', function(message) {

		if (message === 'shutdown') {

			// pm2 shutdown stuff

			appObj.shutdown().fin(function() {

				// exit
				process.exit(0);

			}).done();

		}

	});

}