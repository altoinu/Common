var ObjectUtils = function() {
	
	var me = this;
	
};

ObjectUtils.convertToErrorObj = function(error) {
	
	console.log(error);
	
	var errorObj = {};
	for (var prop in error) {
		errorObj[prop] = error[prop];
	}
	
	if (error.hasOwnProperty('message'))
		errorObj.message = error.message;
	
	return errorObj;
	
};

module.exports = ObjectUtils;