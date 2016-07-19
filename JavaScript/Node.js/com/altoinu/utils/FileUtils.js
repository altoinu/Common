/**
 * 
 * 
 * NPM packages
 * 
 * npm install mmmagic
 * npm install q
 */
module.exports = (function() {

	// --------------------------------------------------------------------------
	//
	// required Node JS modules
	//
	// --------------------------------------------------------------------------

	var fs = require('fs');

	var mod_mmm = require('mmmagic')
	var mod_Q = require('q');

	var magic_MIMETYPE = new mod_mmm.Magic(mod_mmm.MAGIC_MIME_TYPE);

	// --------------------------------------------------------------------------
	//
	// Main class
	//
	// --------------------------------------------------------------------------

	var FileUtils = function() {

		var me = this;

	};

	//--------------------------------------------------------------------------
	//
	// Static methods
	//
	// --------------------------------------------------------------------------

	FileUtils.dirExists = function(d) {
		try {
			return fs.statSync(d).isDirectory();
		} catch (er) {
			return false;
		}
	};

	// promises for mkdir process
	var _mkdir_ing = {};
	/**
	 * Create specified folder (recursively if multiple level specified).
	 */
	FileUtils.mkdir = function(folder) {

		if (folder.charAt(folder.length - 1) == '/')
			folder = folder.substring(0, folder.length - 1);

		var resultFolder = folder + '/';

		if (FileUtils.dirExists(folder)) {

			// folder exists, return as is
			return mod_Q.fcall(function() {
				return resultFolder;
			});

		} else {

			// folder does not exist

			if (_mkdir_ing.hasOwnProperty(folder)) {

				// but it is in process of being created
				// so return its promise
				return _mkdir_ing[folder];

			} else {

				var mkfolder = mod_Q.defer();
				_mkdir_ing[folder] = mkfolder.promise;

				// create parent folder
				var parentFolder = folder.substring(0, folder.lastIndexOf('/'));

				FileUtils.mkdir(parentFolder).then(function(createdParentFolder) {

					console.log('Create folder: ' + folder);

					// then create the actual folder
					fs.mkdir(folder, function(err) {

						// throw err;
						// throw new Error(err);
						if (err)
							mkfolder.reject(err);
						else
							mkfolder.resolve(resultFolder);

						delete _mkdir_ing[folder];

					});

				});

				return mkfolder.promise;

			}

		}

	};

	FileUtils.copyFile = function(source, dest) {

		//console.log('Copy to:' + dest);

		var deferred = mod_Q.defer();

		fs.readFile(source, function(err, data) {

			if (err) {

				deferred.reject(err);

			} else {

				fs.writeFile(dest, data, function(err) {

					if (err)
						deferred.reject(err);
					else
						deferred.resolve({
							source: source,
							dest: dest
						});

				});

			}

		});

		return deferred.promise;

	};

	/**
	 * 
	 * source
	 * destFolder
	 * fileName (optional) file name to set for duplicated file
	 */
	FileUtils.duplicateFile = function(source, destFolder, fileName) {

		// string after last slash is file name
		var fileNameToSet = (fileName ? fileName : source.substr(source.lastIndexOf('/') + 1));

		if (destFolder.charAt(destFolder.length - 1) != '/')
			destFolder += '/';

		// Make sure folder exists (create if not)
		return FileUtils.mkdir(destFolder)
		.then(function(folder) {

			// then copy file to it
			return FileUtils.copyFile(source, destFolder + fileNameToSet);

		});

	};

	FileUtils.rename = function(source, dest) {

		var deferred = mod_Q.defer();

		fs.rename(source, dest, function(err) {

			if (err)
				deferred.reject(err);
			else
				deferred.resolve({
					source: source,
					dest: dest,
				});

		});

		return deferred.promise;

	};

	FileUtils.rm = function(path) {

		var deferred = mod_Q.defer();

		fs.unlink(path, function(err) {

			deferred.resolve(path);

		});

		return deferred.promise;

	};

	FileUtils.loadFileAndContentType = function(path) {

		console.log('Load: ' + path);

		var deferred = mod_Q.defer();

		// read file
		fs.readFile(path, function(err, data) {

			if (err) {

				console.log('Error loading: ' + path);
				console.log(err);
				deferred.reject(err);

			} else {

				// Detect image type
				magic_MIMETYPE.detectFile(path, function(err, contentType) {

					if (err) {

						console.log('Error loading, could not detect file path: ' + path);
						console.log(err);
						deferred.reject(err);

					} else {

						console.log(path);
						console.log('File contentType: ' + contentType);

						// and return binary data
						deferred.resolve({
							fullPath: path,
							contentType: contentType,
							data: data
						});

					}

				});

			}

		});

		return deferred.promise;

	};

	FileUtils.base64ConvertFile = function(fileData) {

		//return 'data:' + fileData.contentType + ';base64,' + (new Buffer(fileData.data).toString('base64'));
		return {
			fullPath: fileData.fullPath,
			contentType: fileData.contentType,
			data: fileData.data,
			dataBase64: 'data:' + fileData.contentType + ';base64,' + fileData.data.toString('base64')
		}

	};

	return FileUtils;

})();