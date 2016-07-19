// --------------------------------------------------------------------------
//
// Main class
//
// --------------------------------------------------------------------------

var NumberUtils = function() {

	var me = this;

};

//--------------------------------------------------------------------------
//
// Static properties
//
// --------------------------------------------------------------------------

NumberUtils.currencyUSD = 'USD';

//--------------------------------------------------------------------------
//
// Static methods
//
// --------------------------------------------------------------------------

NumberUtils.toCurrencyString = function(num, currency) {

	var value;

	switch (currency.toUpperCase()) {

		case NumberUtils.currencyUSD:
			//console.log(parseInt(Number(num) * 100));
			//console.log(parseInt(Number(num) * 100) / 100);
			//console.log(parseFloat(Number(num) * 100));
			//console.log(parseFloat(Number(num) * 100) / 100);
			//value = parseInt(Number(num) * 100) / 100;
			value = parseFloat(Number(num) * 100) / 100;
			value = '$' + String(value.toFixed(2));
			break;

		default:
			value = num;

	}

	return value;

};

NumberUtils.getFitScale = function(width, height, containerWidth, containerHeight, precision) {

	var decimalNum = (precision != null) && isFinite(precision) && (precision >= 0) ? Math.floor(precision) : 0;
	
	var fit_scale_x = containerWidth / width;
	var fit_scale_y = containerHeight / height;

	var resultScale;
	if (isFinite(fit_scale_x) && isFinite(fit_scale_y)) {
		
		resultScale = Number(fit_scale_x <= fit_scale_y ? fit_scale_x : fit_scale_y);
		
	} else {
		
		if (isFinite(fit_scale_x))
			resultScale = Number(fit_scale_x);
		else if (isFinite(fit_scale_y))
			resultScale = Number(fit_scale_y);
		else
			resultScale = NaN;
		
	}
	
	if (precision)
		return Number(resultScale.toFixed(decimalNum));
	else
		return resultScale;
	
};

module.exports = NumberUtils;
