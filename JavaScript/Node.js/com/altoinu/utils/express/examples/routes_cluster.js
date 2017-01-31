var path = require('path');
var RouteSetter = require('./RouteSetter.js');

var routesDef = [
	path.join(__dirname, '/routes/ConfigRoute.js'),
	path.join(__dirname, '/preview-server/routes/ImageProcessRoute.js')
];

module.exports = RouteSetter(routesDef);
