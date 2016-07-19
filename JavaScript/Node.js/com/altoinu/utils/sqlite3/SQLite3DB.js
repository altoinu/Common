/*
 * Class to handle basic sqlite3 table creating/mod/initializing.
 * Extend this class to actually do stuff
 */
var mod_Q = require('q');
var mod_sqlite3 = require('sqlite3').verbose();

var FileUtils = require('./FileUtils.js');
var Logger = require('./Logger.js');

/**
 * 
 * @param dbFile file name
 * @param defaultTableName table name
 * @param defaultTableColumnConfig
 * {
 *    'field': {
 *       type: 'TEXT',
 *       sourceColumn: 'orderID' // use this as source (higher priority)
 *       sourceColumnIfNotExists: 'orderID' // use this if id does not exist (2nd priority)
 *       primaryKey: true/false
 *       defaultValue: '' // value, 'CURRENT_TIME', 'CURRENT_DATE', 'CURRENT_TIMESTAMP'
 *       notNull: true/false
 *    },...
 * }
 * @param defaultTableConstraint
 * {
 *    constraintName1: {
 *       type: typeValue,
 *       expr: [field1, field2,...]
 *    },...
 * }
 * @param debugLogEnabled
 * @param logPrefix
 */
var SQLite3DB = function(dbFile, defaultTableName, defaultTableColumnConfig, defaultTableConstraint, debugLogEnabled, logPrefix) {

	// --------------------------------------------------------------------------
	//
	// private variables
	//
	// --------------------------------------------------------------------------

	var me = this;

	var SERVER_FOLDER = 'server/';

	var dbFolder = SERVER_FOLDER + 'sqlite3_db/';
	var tableInitialize_deferred = mod_Q.defer();

	var default_database;

	// --------------------------------------------------------------------------
	//
	// public variables
	//
	// --------------------------------------------------------------------------

	this.logger = new Logger(debugLogEnabled);

	// --------------------------------------------------------------------------
	//
	// private methods
	//
	// --------------------------------------------------------------------------

	function buildUTCDateString(sourceDate) {

		var month = sourceDate.getUTCMonth() + 1;
		if (month < 10)
			month = '0' + String(month);
		var date = sourceDate.getUTCDate();
		if (date < 10)
			date = '0' + String(date);
		return sourceDate.getUTCFullYear() + '-' + month + '-' + date;

	}

	function buildUTCTimeString(sourceDate) {

		var hours = sourceDate.getUTCHours();
		if (hours < 10)
			hours = '0' + String(hours);
		var min = sourceDate.getUTCMinutes();
		if (min < 10)
			min = '0' + String(min);
		var sec = sourceDate.getUTCSeconds();
		if (sec < 10)
			sec = '0' + String(sec);
		return hours + ':' + min + ':' + sec;

	}

	/**
	 * build column type and constraint sql string
	 * used for CREATE TABLE or ALTER TABLE
	 * type [PRIMARY KEY] [value/DEFAULT CURRENT_TIME/CURRENT_DATE/CURRENT_TIMESTAMP] [NOT NULL]
	 */
	function getColumnTypeConstraintStr(columnDefObj, forAlterTable) {

		//var columnDefObj = columnDef[columnName];
		var columnDefStr = '';

		if (typeof columnDefObj === 'string') {

			columnDefStr += columnDefObj;

		} else {

			if (columnDefObj.hasOwnProperty('type'))
				columnDefStr += columnDefObj.type;
			else
				columnDefStr += 'TEXT';

			if (columnDefObj.hasOwnProperty('primaryKey') && columnDefObj.primaryKey) {

				if (forAlterTable) {

					// adding PRIMARY KEY to existing table not supported in sqlite3
					// poop

					//columnDefStr += ' PRIMARY KEY';
					me.log('WARNING *** sqlite3 doesn\'t support adding PRIMARY KEY with ALTER TABLE');
					me.log('need to create new table and copy from existing one');

				} else {

					columnDefStr += ' PRIMARY KEY';

				}

			}

			if (columnDefObj.hasOwnProperty('defaultValue')) {

				var defaultValue;

				if ((columnDefObj.defaultValue == 'CURRENT_TIME') || (columnDefObj.defaultValue == 'CURRENT_DATE') || (columnDefObj.defaultValue == 'CURRENT_TIMESTAMP')) {

					if (forAlterTable) {

						// adding non constant CURRENT_TIME CURRENT_DATE CURRENT_TIMESTAMP
						// default value to existing table is not allowed in sqlite3
						// so just use current time
						var today = new Date();
						var todayDateString = buildUTCDateString(today);
						var todayTimeString = buildUTCTimeString(today);

						var todayString;
						if (columnDefObj.defaultValue == 'CURRENT_TIME')
							todayString = todayTimeString;
						else if (columnDefObj.defaultValue == 'CURRENT_DATE')
							todayString = todayDateString;
						else
							todayString = todayDateString + ' ' + todayTimeString;

						me.log(columnDefObj.defaultValue, 'default value', todayString);

						defaultValue = '\'' + todayString + '\'';

					} else {

						defaultValue = columnDefObj.defaultValue;

					}

				} else if ((columnDefObj.defaultValue !== '') && isFinite(Number(columnDefObj.defaultValue))) {

					// number
					defaultValue = columnDefObj.defaultValue;

				} else {

					// set as string
					defaultValue = '\'' + columnDefObj.defaultValue + '\'';

				}

				columnDefStr += ' DEFAULT ' + defaultValue;

			}

			if (columnDefObj.hasOwnProperty('notNull') && columnDefObj.notNull)
				columnDefStr += ' NOT NULL';

		}

		return columnDefStr;

	}

	/**
	 * build table column definition sql string
	 * from columnDef:
	 * {
	 *    'field': {
	 *       type: 'TEXT',
	 *       sourceColumn: 'orderID' // use this as source (higher priority)
	 *       sourceColumnIfNotExists: 'orderID' // use this if id does not exist (2nd priority)
	 *       primaryKey: true/false
	 *       defaultValue: '' // value, 'CURRENT_TIME', 'CURRENT_DATE', 'CURRENT_TIMESTAMP'
	 *       notNull: true/false
	 *    },...
	 * }
	 */
	function toTableColumnDefString(columnDef) {

		var columns = [];
		for ( var columnName in columnDef) {

			var columnDefStr = columnName + ' ';
			columnDefStr += getColumnTypeConstraintStr(columnDef[columnName]);

			columns.push(columnDefStr);

		}

		return columns.join(', ');

	}

	/**
	 * build table column constraints sql string
	 * from constraintsDef:
	 * {
	 *    constraintName1: {
	 *       type: typeValue,
	 *       expr: [field1, field2,...]
	 *    },...
	 * }
	 * CONSTRAINT constraintName1 typeValue (field1, field2...)
	 */
	function toTableConstraintsString(constraintsDef) {

		var constraints = [];
		for ( var constraintsName in constraintsDef) {

			var str = ('CONSTRAINT ' + constraintsName + ' ');
			str += (constraintsDef[constraintsName].type + ' ');

			if (constraintsDef[constraintsName].hasOwnProperty('expr'))
				str += '(' + constraintsDef[constraintsName].expr.join(', ') + ')';

			constraints.push(str);

		}

		return constraints.join(', ');

	}

	// --------------------------------------------------------------------------
	//
	// public methods
	//
	// --------------------------------------------------------------------------

	this.buildSQLWhereExpr = function(criteria) {

		var sql = '';
		var sqlArgs = {};

		var criteriaText = [];
		var criteriaAdded = false;
		for ( var columnName in criteria) {

			if (criteria[columnName] && (columnName != 'timestamp2')) {

				if (!criteriaAdded)
					sql += ' WHERE ';
				else
					sql += ' AND ';

				if (columnName == 'timestamp1') {

					var time1 = new Date(criteria['timestamp1']);
					var time2 = criteria.hasOwnProperty('timestamp2') ? new Date(criteria['timestamp2']) : null;

					//console.log('Dates.........');
					//console.log(time1);
					//console.log(time2);

					if (!time2 || (time1.valueOf() == time2.valueOf())) {

						//console.log(time1.valueOf() == time2.valueOf());

						sql += ('timestamp=$timestamp');
						if (criteria[columnName] instanceof Date)
							sqlArgs['$timestamp'] = buildUTCDateString(criteria[columnName]) + ' ' + buildUTCTimeString(criteria[columnName]);
						else
							sqlArgs['$timestamp'] = criteria[columnName];

						criteriaText.push(columnName + ': ' + criteria[columnName]);

					} else {

						//console.log(time1 > time2);
						//console.log(time2 > time1);

						sql += 'timestamp BETWEEN ';
						if (time2 > time1)
							sql += '$timestamp1 AND $timestamp2';
						else
							sql += '$timestamp2 AND $timestamp1';

						if (criteria['timestamp1'] instanceof Date)
							sqlArgs['$timestamp1'] = buildUTCDateString(criteria['timestamp1']) + ' ' + buildUTCTimeString(criteria['timestamp1']);
						else
							sqlArgs['$timestamp1'] = criteria['timestamp1'];

						if (criteria['timestamp2'] instanceof Date)
							sqlArgs['$timestamp2'] = buildUTCDateString(criteria['timestamp2']) + ' ' + buildUTCTimeString(criteria['timestamp2']);
						else
							sqlArgs['$timestamp2'] = criteria['timestamp2'];

						//console.log(sqlArgs);

						criteriaText.push('timestamp1: ' + criteria['timestamp1']);
						criteriaText.push('timestamp2: ' + criteria['timestamp2']);

					}

				} else {

					sql += (columnName + '=$' + columnName);
					sqlArgs['$' + columnName] = criteria[columnName];

					criteriaText.push(columnName + ': ' + criteria[columnName]);

				}

				criteriaAdded = true;

			}

		}

		return {
			sql: sql,
			sqlArgs: sqlArgs,
			criteriaText: criteriaText
		};

	}

	this.openDatabase = function(db_filename) {

		me.log(logPrefix + 'openDatabase');

		return FileUtils.mkdir(dbFolder).then(function(folder) {

			var db = default_database ? default_database : new mod_sqlite3.Database(dbFolder + db_filename);
			me.log(db);

			return db;

		});

	};

	this.closeDatabase = function(db) {

		if (!db)
			db = default_database;

		var tbInitialized;
		if (db == default_database)
			tbInitialized = me.isTableInitialized();
		else
			tbInitialized = mod_Q.resolve(db);

		return tbInitialized.then(function(db) {

			me.log(logPrefix + 'closeDatabase');

			var deferred = mod_Q.defer();

			if (db) {

				db.close(function(err) {

					if (err) {

						me.log(logPrefix + 'closeDatabase error');
						me.log(err);
						deferred.reject(err);

					} else {

						me.log(logPrefix + 'closeDatabase complete');

						if (db == default_database)
							default_database = null;

						deferred.resolve(db);

					}

				});

			} else {

				deferred.resolve(db);

			}

			return deferred.promise;

		});

	}

	this.initializeTable = function(db) {

		me.log(logPrefix + 'initializeTable');

		if (!db)
			db = default_database;

		var sql = 'SELECT name FROM sqlite_master WHERE type=\'table\' AND name=$tableName';
		var sqlArgs = {
			'$tableName': defaultTableName
		};
		me.log(sql);
		me.log(sqlArgs);

		var deferred = mod_Q.defer();

		// check to see if table exists already
		db.get(sql, sqlArgs, function(err, row) {

			if (err) {

				me.log(logPrefix + 'table check error');
				me.log(err);
				deferred.resolve(me.createTable(db));

			} else {

				if (row && !Array.isArray(row))
					row = [
						row
					];

				me.log(logPrefix + 'table check complete');
				me.log(row);

				// If table already exists, modify
				// to make sure table structures match
				// in case machine this code is running
				// has old version
				if (row && (row.length > 0))
					deferred.resolve(me.modifyTable(db));
				else
					deferred.resolve(me.createTable(db));

			}

		});

		return deferred.promise;

	};

	this.createTable = function(db, tableName) {

		me.log(logPrefix + 'createTable');

		if (!db)
			db = default_database;

		if (!tableName)
			tableName = defaultTableName;

		var columns = toTableColumnDefString(defaultTableColumnConfig);
		var constraints = toTableConstraintsString(defaultTableConstraint);
		var sql = 'CREATE TABLE IF NOT EXISTS ' + tableName + ' (' + columns + (constraints.length > 0 ? ', ' + constraints : '') + ');';
		me.log(sql);

		var deferred = mod_Q.defer();

		db.run(sql, function(err) {

			if (err) {

				me.log(logPrefix + 'createTable ' + tableName + ' error');
				me.log(err);
				deferred.reject(err);

			} else {

				me.log(logPrefix + 'createTable ' + tableName + ' complete');
				deferred.resolve(db);

			}

		});

		return deferred.promise;

	};

	/**
	 * In case existing table has missing columns, we modify here
	 */
	this.modifyTable = function(db) {

		me.log(logPrefix + 'modifyTable');

		if (!db)
			db = default_database;

		var tempTableName = defaultTableName + '_temp';

		// modify column doesn't work with sqlite3
		// var sql = 'ALTER TABLE ' + defaultTableName
		// + ' MODIFY $column $datatype';
		// var sqlArgs = { '$column': 'id', '$datatype': 'TEXT' };
		// so we need to create temp table and add column

		// create temporary table
		return me.createTable(db, tempTableName).then(function(db) {

			// Check and add missing source columns
			// into existing table so when we copy data
			// out later sqlite won't bomb because they
			// do not exist
			var addColumns = [];
			db.parallelize(function() {

				var columnDef = defaultTableColumnConfig;
				for ( var columnName in columnDef) {

					addColumns.push(me.addColumnIfNotExists(db, columnName));

				}

			});

			return mod_Q.all(addColumns);

		}).then(function(addColumnResults) {

			// which ones did not exist and were just added?
			var newColumns = [];
			addColumnResults.forEach(function(value, index, array) {

				// value.columnName was added because it was not there
				if (value.result == 'added')
					newColumns.push(value.columnName);

			});

			// Make sure source columns exist
			var addSourcePlaceHolderColumnOps = [];
			// object to remember which column should get
			// which existing column's data
			// {column name: 'source column name', ...}
			var sourceForColumns = {};
			db.parallelize(function() {

				var columnDef = defaultTableColumnConfig;
				for ( var columnName in columnDef) {

					if (typeof columnDef[columnName] === 'string') {

						// nothing special defined, use same column name for data transfer
						sourceForColumns[columnName] = columnName;

					} else {

						var sourceColumn;

						if (columnDef[columnName].hasOwnProperty('sourceColumn')) {

							// use sourceColumn data for this columnName
							// Overwrites existing data with whatever is in sourceColumn
							sourceColumn = columnDef[columnName].sourceColumn;

							// make sure sourceColumn exists in existing table
							if (!columnDef.hasOwnProperty(sourceColumn))
								addSourcePlaceHolderColumnOps.push(me.addColumnIfNotExists(db, sourceColumn));

						} else if ((newColumns.indexOf(columnName) != -1) && columnDef[columnName].hasOwnProperty('sourceColumnIfNotExists')) {

							// use sourceColumnIfNotExists data for this columnName
							// only if this columnName was not in existing table
							sourceColumn = columnDef[columnName].sourceColumnIfNotExists;

							// make sure sourceColumn exists in existing table
							if (!columnDef.hasOwnProperty(sourceColumn))
								addSourcePlaceHolderColumnOps.push(me.addColumnIfNotExists(db, sourceColumn));

						} else {

							// sourceColumn or sourceColumnIfNotExists not defined
							// use same column name for data transfer
							sourceColumn = columnName;

						}

						sourceForColumns[columnName] = sourceColumn;

					}

				}

			});

			return mod_Q.all(addSourcePlaceHolderColumnOps).then(function(results) {

				// copy all necessary data from existing table
				// into temporary table

				var targetColumns = [];
				var sourceColumns = [];
				for ( var columnName in sourceForColumns) {

					targetColumns.push(columnName);
					sourceColumns.push(sourceForColumns[columnName]);

				}

				// copy data to temp table
				var sql = 'INSERT INTO ' + tempTableName;
				// target columns
				sql += ' (' + targetColumns.join(', ') + ')';
				// source columns in existing table
				sql += ' SELECT ' + sourceColumns.join(', ') + ' FROM ' + defaultTableName + ';';
				me.log(sql);

				var deferred = mod_Q.defer();

				db.run(sql, function(err) {

					if (err) {

						me.log(logPrefix + 'modifyTable copy error');
						me.log(err);
						deferred.reject(err);

					} else {

						db.serialize(function() {

							// then delete original table
							var sql = 'DROP TABLE ' + defaultTableName;
							me.log(sql);
							db.run(sql);

							// rename temporary table to original table
							sql = 'ALTER TABLE ' + tempTableName + ' RENAME TO ' + defaultTableName;
							me.log(sql);
							db.run(sql, function(err) {

								if (err) {

									me.log(logPrefix + 'modifyTable rename error');
									me.log(err);
									deferred.reject(err);

								} else {

									me.log(logPrefix + 'modifyTable complete');
									deferred.resolve(db);

								}

							});

						});

					}

				});

				return deferred.promise;

			});

		});

		return deferred.promise;

	};

	/**
	 * Returns promise for default database initialization.
	 * Database querying should be done after this
	 * ex. me.isTableInitialized().then(function(db) { ... })...
	 */
	this.isTableInitialized = function() {

		return tableInitialize_deferred.promise;

	};

	/**
	 * checks to see if specified column exists
	 */
	this.isColumnExists = function(db, columnName) {

		if (!db)
			db = default_database;

		var checkIfColumnExists = 'SELECT ' + columnName + ' FROM ' + defaultTableName;
		// me.log(checkIfColumnExists);

		var deferred = mod_Q.defer();

		db.get(checkIfColumnExists, function(err, row) {

			if (err) {

				// doesn't exist
				me.log(logPrefix + 'isColumnExists, column: ' + columnName + ' doesn\'t exist');
				me.log(err);
				deferred.reject({
					error: err,
					db: db,
					columnName: columnName
				});

			} else {

				// exists
				me.log(logPrefix + 'isColumnExists, column: ' + columnName + ' exists');
				me.log(row);
				deferred.resolve({
					result: row,
					db: db,
					columnName: columnName
				});

			}

		});

		return deferred.promise;

	};

	/**
	 * return value would be 
	 * success - {result: 'exists' or 'added', columnName}
	 * fail - {error, columnName}
	 */
	this.addColumnIfNotExists = function(db, columnName) {

		if (!db)
			db = default_database;

		var columnDef = defaultTableColumnConfig;

		return me.isColumnExists(db, columnName).then(function(result) {

			// column exists, do nothing

			var columnName = result.columnName;
			me.log(logPrefix + 'addColumnIfNotExists complete, column exists: ' + columnName);
			return {
				result: 'exists',
				db: db,
				columnName: columnName,
				columnDef: columnDef[columnName]
			};

		}).fail(function(error) {

			// column doesn't exist, add

			var deferred = mod_Q.defer();

			var addColumn = 'ALTER TABLE ' + defaultTableName + ' ADD COLUMN ';

			var columnDefStr = columnName + ' ';
			// if not defined, add column as type TEXT
			if (!columnDef.hasOwnProperty(columnName))
				columnDefStr += 'TEXT';
			else
				columnDefStr += getColumnTypeConstraintStr(columnDef[columnName], true);

			addColumn += columnDefStr;

			me.log(addColumn);

			db.run(addColumn, function(err) {

				if (err) {

					me.log(logPrefix + 'addColumnIfNotExists error');
					me.log(err);
					deferred.reject({
						error: err,
						db: db,
						columnName: columnName,
						columnDef: columnDef[columnName]
					});

				} else {

					me.log(logPrefix + 'addColumnIfNotExists complete, column added: ' + columnName);
					deferred.resolve({
						result: 'added',
						db: db,
						columnName: columnName,
						columnDef: columnDef[columnName]
					});

				}

			});

			return deferred.promise;

		});

	};

	// --------------------------------------------------------------------------
	//
	// initializations
	//
	// --------------------------------------------------------------------------

	//console.log(this.prototype);
	//console.log(this.constructor !== SQLite3DB);
	//console.log(SQLite3DB.prototype.isPrototypeOf(this));
	//console.log(this instanceof SQLite3DB);

	//if (arguments.length > 0) {
	// do initialization only for extended class
	if (this.constructor !== SQLite3DB) {

		me.log(arguments);

		tableInitialize_deferred.resolve(me.openDatabase(dbFile).then(function(db) {

			// set default database
			default_database = db;
			return db;

		}).then(me.initializeTable).fail(function(error) {

			me.log(logPrefix + 'db initialize error');
			me.log(error);
			
			return mod_Q.reject(error);

		}));

	}

};

SQLite3DB.prototype.log = function() {

	var args = Array.prototype.slice.call(arguments);
	this.logger.log.apply(this.logger, args);

};

module.exports = SQLite3DB;