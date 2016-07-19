var RouteSetter = require('./RouteSetter.js');

var routesDef = [
	'./ConfigRoute.js',
	'./ImageProcessRoute.js'
];

module.exports = RouteSetter(routesDef);
