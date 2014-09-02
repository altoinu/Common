var scaleAndCopytoCanvas = function(imageFile, canvas, width, height, onComplete) {

	// set canvas to specified size
	$(canvas).attr({
		width: width,
		height: height
	});

	// copy image to canvas, scaled to that size
	var context = canvas.getContext("2d");

	canvasResize(imageFile, {
		width: width,
		height: 0,
		crop: false,
		quality: 80,
		callback: function(data, width, height) {

			var tempImg = new Image();
			tempImg.onload = function() {
				context.drawImage(tempImg, 0, 0, width, height);
			};
			tempImg.src = data;

			if (onComplete != null)
				onComplete(data, width, height);

		}
	});

};