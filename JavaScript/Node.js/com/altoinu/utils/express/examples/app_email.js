// ======================================================================
// GLOBAL variables
// ======================================================================
GLOBAL.AppVars = require('../BrandConfig/appvars.js');
var AppVars = GLOBAL.AppVars;
GLOBAL.config = require('../BrandConfig/env.json')[AppVars.env];
var CONFIG = GLOBAL.config;
GLOBAL.email_js = require('../BrandConfig/email.js');
GLOBAL.email_param = require('../BrandConfig/email.json')[AppVars.env];

var HBS_VIEWS_FOLDER = 'local_modules/utils/views';

// --------------------------------------------------------------------------
//
// required Node JS modules
//
// --------------------------------------------------------------------------

var path = require('path');

var app_base = require('./utils/app_base.js');
var RouteSetter = require('./utils/RouteSetter.js');

var routes = RouteSetter([
	path.join(__dirname, '/elastic-email-server/routes/ElasticEmailRoute.js')
]);

// --------------------------------------------------------------------------
//
// private variables
//
// --------------------------------------------------------------------------

var Logger = require('./utils/Logger.js');
var logger = new Logger();
logger.prefix = 'app_email.js:';

logger.log(CONFIG);

// --------------------------------------------------------------------------
//
// stuff
//
// --------------------------------------------------------------------------

var appObj = app_base('app_base, app_email.js:', {
	appSettings: [
		{
			name: 'views',
			value: path.join(process.cwd(), HBS_VIEWS_FOLDER)
		},
		{
			name: 'view engine',
			value: 'hbs'
		}
	],
	routeSetterDef: routes,
	serverPort: CONFIG.EMAIL.port
});

logger.log('module? module.parent =', (module.parent ? true : false));

if (module.parent) {

	module.exports = appObj.app;

} else {

	logger.log('running stand alone');

	// pm2 shutdown stuff
	var doPM2Shutdown = function() {

		appObj.shutdown().fin(function() {

			// exit
			process.exit(0);

		}).done();

	};

	process.on('message', function(message) {

		if (message === 'shutdown')
			doPM2Shutdown();

	});

	process.on('SIGINT', function() {
		doPM2Shutdown();
	});

}