/*
 * sql stuff to keep track of images generated
 * 
 * Node modules
 * 
 * - q
 * - sqlite3
 * 
 */

var mod_Q = require('q');

//var EmailStatusType = require('./EmailStatusType.js');
var SQLite3DB = require('./SQLite3DB.js');
var ObjectUtils = require('./ObjectUtils.js');

var LOG_PREFIX = 'SQL image: ';

var ImageProcessorDataDB = function(dbFileName, debugLogEnabled) {

	// --------------------------------------------------------------------------
	//
	// private variables
	//
	// --------------------------------------------------------------------------

	var me = this;

	var TABLE_NAME = 'images';
	var TABLE_COLUMNS = {
		'id': {
			type: 'TEXT',
			primaryKey: true
		},
		//'id': {
			//type: 'TEXT',
			//sourceColumn: 'orderID' // use this as source (higher priority)
			//sourceColumnIfNotExists: 'orderID' // use this if id does not exist (2nd priority)
			//primaryKey: true/false
			//defaultValue: '' // value, 'CURRENT_TIME', 'CURRENT_DATE', 'CURRENT_TIMESTAMP'
			//notNull: true/false
		//},
		'path': 'TEXT',
		'original': 'TEXT',
		'timestamp': {
			type: 'DATETIME',
			defaultValue: 'CURRENT_TIMESTAMP',
			notNull: true
		}
	};

	var TABLE_CONSTRAINTS = {
		//'emailID': {
			//type: 'PRIMARY KEY',
			//expr: [
				//'id',
				//'email',
				//'type'
			//]
		//}
	};

	var dbFile = (dbFileName ? dbFileName : 'images.sqlite');
	var defaultTableName = TABLE_NAME;

	// extends SQLite3DB
	SQLite3DB.call(this, dbFile, defaultTableName, TABLE_COLUMNS, TABLE_CONSTRAINTS, debugLogEnabled, LOG_PREFIX);
	var _super = {};
	for ( var _superProp in this) {

		_super[_superProp] = this[_superProp];

	}

	// --------------------------------------------------------------------------
	//
	// public methods
	//
	// --------------------------------------------------------------------------

	/**
	 * 
	 * @param id optional, if not specified, then all
	 * @param path optional
	 * @param original optional
	 * @param timestamp1
	 * @param timestamp2
	 */
	this.getImageData = function(id, path, original, timestamp1, timestamp2) {

		var criteria = {};
		if (id)
			criteria.id = id;
		if (path)
			criteria.path = path;
		if (original)
			criteria.original = original;
		if (timestamp1)
			criteria.timestamp1 = timestamp1;
		if (timestamp2)
			criteria.timestamp2 = timestamp2;

		var expr = me.buildSQLWhereExpr(criteria);
		var sql = 'SELECT * FROM ' + defaultTableName + expr.sql + ';';
		var sqlArgs = expr.sqlArgs;
		var criteriaText = expr.criteriaText;

		return me.isTableInitialized().then(function(db) {

			me.log.apply(me, [
				LOG_PREFIX + 'getImageData'
			].concat(criteriaText));
			me.log(sql);
			me.log(sqlArgs);

			var deferred = mod_Q.defer();

			db.all(sql, sqlArgs, function(err, row) {

				if (err) {

					me.log(LOG_PREFIX + 'getImageData error');
					me.log(err);
					deferred.reject({
						result: 'fail',
						message: 'getImageData error',
						data: sqlArgs,
						error: {
							obj: err,
							data: ObjectUtils.convertToErrorObj(err)
						}
					});

				} else {

					// Make this into array
					if (!Array.isArray(row))
						row = [
							row
						];

					me.log.apply(me, [
						LOG_PREFIX + 'getImageData complete'
					].concat(criteriaText));
					me.log(row);
					deferred.resolve(row);

				}

			});

			return deferred.promise;

		});

	};

	/**
	 * Sets image data
	 * 
	 * @param id required
	 * @param path optional
	 * @param original optional
	 */
	this.setImageData = function(id, path, original) {

		return me.isTableInitialized().then(function(db) {

			me.log(LOG_PREFIX + 'setImageData', 'id: ' + id, 'path: ' + path, 'original: ' + original);

			if (!id) {

				// id is required
				var errorMsg = 'id required for setImageData';
				me.log(errorMsg);
				return mod_Q.reject({
					result: 'fail',
					message: errorMsg,
					data: null,
					error: null
				});

			} else {

				if (id)
					id = String(id);
				if (path)
					path = String(path);
				if (original)
					original = String(original);

				// get record with specified data
				return me.getImageData(id).then(function(results) {

					// then set it to new set of specified values

					var sql;
					// property name must be '$(name)'
					var sqlArgs = {
						'$id': id
					};

					if (path)
						sqlArgs['$path'] = String(path);
					if (original)
						sqlArgs['$original'] = String(original);

					if (results.length > 0) {

						// target data exists in db, update
						sql = 'UPDATE ' + defaultTableName;

						sql += ' SET ';
						var addedSQLArgs = false;
						for ( var prop in sqlArgs) {

							if (addedSQLArgs)
								sql += ', ';
							else
								addedSQLArgs = true;

							sql += (prop.substr(1) + '=' + prop);

						}

						sql += ' WHERE id=$id';

					} else {

						// target data does not exist
						// insert as new entry
						sql = 'INSERT INTO ' + defaultTableName;

						sql += ' (';
						var addedSQLArgs = false;
						for ( var prop in sqlArgs) {

							if (addedSQLArgs)
								sql += ', ';
							else
								addedSQLArgs = true;

							sql += prop.substr(1);

						}
						sql += ')';

						sql += ' VALUES (';
						addedSQLArgs = false;
						for ( var prop in sqlArgs) {

							if (addedSQLArgs)
								sql += ',';
							else
								addedSQLArgs = true;

							sql += prop;

						}
						sql += ')';

					}

					sql += ';';

					me.log(sql);
					me.log(sqlArgs);

					var deferred = mod_Q.defer();

					db.run(sql, sqlArgs, function(err) {

						if (err) {

							me.log(LOG_PREFIX + 'setImageData error');
							me.log(err);
							deferred.reject({
								result: 'fail',
								message: 'setImageData error',
								data: sqlArgs,
								error: {
									obj: err,
									data: ObjectUtils.convertToErrorObj(err)
								}
							});

						} else {

							me.log(LOG_PREFIX + 'setImageData complete', 'id: ' + id, 'path: ' + path, 'original: ' + original);
							deferred.resolve({
								id: id,
								path: path,
								original: original
							});

						}

					});

					return deferred.promise;

				});

			}

		});

	};

	this.removeImageData = function(id) {

		return me.isTableInitialized().then(function(db) {

			me.log(LOG_PREFIX + 'removeImageData', 'id: ' + id);

			if (!id) {

				// one of them has to be specified
				var errorMsg = 'id to be removed not specified';
				me.log(errorMsg);
				return mod_Q.reject({
					result: 'fail',
					message: errorMsg,
					data: null,
					error: null
				});

			} else {

				if (id)
					id = String(id);

				return me.getImageData(id).then(function(results) {

					if (results.length > 0) {

						var criteria = {};
						if (id)
							criteria.id = id;

						var expr = me.buildSQLWhereExpr(criteria);
						var sql = 'DELETE FROM ' + defaultTableName + expr.sql + ';';
						var sqlArgs = expr.sqlArgs;
						var criteriaText = expr.criteriaText;

						me.log(sql);
						me.log(sqlArgs);

						var deferred = mod_Q.defer();

						db.run(sql, sqlArgs, function(err) {

							if (err) {

								me.log(LOG_PREFIX + 'removeImageData error');
								me.log(err);
								deferred.reject({
									result: 'fail',
									message: 'removeImageData error',
									data: sqlArgs,
									error: {
										obj: err,
										data: ObjectUtils.convertToErrorObj(err)
									}
								});

							} else {

								me.log(LOG_PREFIX + 'removeImageData complete', 'id: ' + id);
								deferred.resolve({
									id: id
								});

							}

						});

						return deferred.promise;

					} else {

						var errorMsg = 'Could not remove ' + id + ', not found';
						me.log(LOG_PREFIX + 'removeImageData fail, ' + errorMsg);
						return mod_Q.reject(errorMsg);

					}

				});

			}

		});

	};

};

//extends
ImageProcessorDataDB.prototype = new SQLite3DB();
ImageProcessorDataDB.prototype.constructor = ImageProcessorDataDB;

module.exports = ImageProcessorDataDB;