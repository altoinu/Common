var AppVars = require('./appvars.js');
var config = require('./env.json')[AppVars.env];

var HBS_VIEWS_FOLDER = 'server/utils/views';

// --------------------------------------------------------------------------
//
// required Node JS modules
//
// --------------------------------------------------------------------------

var path = require('path');

var app_base = require('./utils/app_base.js');
var RouteSetter = require('./utils/RouteSetter.js');

var cors = require('./routes/CORS.js')(config.API.CORS);
var routes = RouteSetter([
	path.join(__dirname, 'routes/ConfigRoute.js'),
	path.join(__dirname, 'routes/ImageProcessRoute.js')
]);

// --------------------------------------------------------------------------
//
// private variables
//
// --------------------------------------------------------------------------

var Logger = require('./utils/Logger.js');
var logger = new Logger();
logger.prefix = 'app_cluster.js:';

logger.log(config);

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
	serverPort: config.API.port_internal,
	serverPath: config.API.path
});

logger.log('module? module.parent =', (module.parent ? true : false));
// TODO: module.parent vs require.main === module
// https://nodejs.org/api/modules.html
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