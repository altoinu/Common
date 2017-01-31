// ======================================================================
// GLOBAL variables
// ======================================================================
GLOBAL.AppVars = require('../BrandConfig/appvars.js');
var AppVars = GLOBAL.AppVars;
GLOBAL.config = require('../BrandConfig/env.json')[AppVars.env];
var CONFIG = GLOBAL.config;

var HBS_VIEWS_FOLDER = 'local_modules/utils/views';

// --------------------------------------------------------------------------
//
// required Node JS modules
//
// --------------------------------------------------------------------------

var path = require('path');

var app_base = require('./utils/app_base.js');
var RouteSetter = require('./utils/RouteSetter.js');

var cors = require('./routes/CORS.js')(CONFIG.API.CORS);
var routes = RouteSetter([
	path.join(__dirname, '/routes/ConfigRoute.js'),
	path.join(__dirname, '/preview-server/routes/ImageProcessRoute.js'),
	path.join(__dirname, '/preview-server/routes/EmailDebugRoute.js')
]);

// --------------------------------------------------------------------------
//
// private variables
//
// --------------------------------------------------------------------------

var Logger = require('./utils/Logger.js');
var logger = new Logger();
logger.prefix = 'app_cluster.js:';

logger.log(CONFIG);

// --------------------------------------------------------------------------
//
// stuff
//
// --------------------------------------------------------------------------

var appObj = app_base('app_base, app_cluster.js:', {
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
	middleware: cors.allow,
	routeSetterDef: routes,
	serverPort: CONFIG.API.port_internal,
	serverPath: CONFIG.API.path
});

logger.log('module? module.parent =', (module.parent ? true : false));
// TODO: module.parent vs require.main === module
// https://nodejs.org/api/modules.html
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