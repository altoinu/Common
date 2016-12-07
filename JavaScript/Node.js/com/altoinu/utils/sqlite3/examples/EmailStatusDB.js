/*
 * sql stuff to keep track of email delivery
 * 
 * Node modules
 * 
 * - q
 */

var mod_Q = require('q');

var SQLite3DB = require('../SQLite3DB.js');
var ObjectUtils = require('../ObjectUtils.js');

var LOG_PREFIX = 'SQL email: ';

var EmailStatusDB = function(dbFileName, debugLogEnabled) {

	// --------------------------------------------------------------------------
	//
	// private variables
	//
	// --------------------------------------------------------------------------

	var me = this;

	var TABLE_EMAIL_SEND_STATUS = 'email_send_status';
	var TABLE_EMAIL_SEND_STATUS_COLUMNS = {
		'id': {
			type: 'TEXT',
			sourceColumnIfNotExists: 'orderID' // use this if id does not exist (2nd priority)
			//sourceColumn: 'orderID' // use this as source (higher priority)
		},
		//'orderID': 'TEXT',
		'email': 'TEXT',
		'type': {
			type: 'TEXT',
			defaultValue: EmailStatusDB.TYPE_UNDEFINED
		},
		'timestamp': {
			type: 'DATETIME',
			defaultValue: 'CURRENT_TIMESTAMP',
			notNull: true
		},
		'status': 'TEXT',
		'transactionID': 'TEXT',
		'message': 'TEXT',
		'sourceData': {
			type: 'TEXT',
			defaultValue: ''
		},
		'isCC': {
			type: 'TEXT',
			defaultValue: ''
		},
		'updateRecordOnceSent': {
			type: 'INTEGER',
			defaultValue: 0
		}
	};

	var TABLE_EMAIL_SEND_STATUS_CONSTRAINTS = {
		'emailID': {
			type: 'PRIMARY KEY',
			expr: [
				'id',
				'email',
				'type'
			]
		}
	};

	var dbFile = (dbFileName ? dbFileName : 'email.db');
	var defaultTableName = TABLE_EMAIL_SEND_STATUS;

	// extends SQLite3DB
	SQLite3DB.call(this, dbFile, defaultTableName, TABLE_EMAIL_SEND_STATUS_COLUMNS, TABLE_EMAIL_SEND_STATUS_CONSTRAINTS, debugLogEnabled, LOG_PREFIX);
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
	 * getSendStatus() - gets all status
	 * 
	 * @param id
	 *            optional, if not specified, then all
	 * @param email
	 *            optional
	 * @param type
	 *            optional
	 * @param status
	 *            optional
	 * @param transactionID
	 *            optional
	 * @param timestamp1
	 *            optional
	 * @param timestamp2
	 *            optional
	 */
	this.getSendStatus = function(id, email, type, status, transactionID, timestamp1, timestamp2) {

		var criteria = {};
		if (id)
			criteria.id = id;
		if (email)
			criteria.email = email;
		if (type)
			criteria.type = type;
		if (status)
			criteria.status = status;
		if (transactionID)
			criteria.transactionID = transactionID;
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
				LOG_PREFIX + 'getSendStatus'
			].concat(criteriaText));
			//me.log(LOG_PREFIX + 'getSendStatus', 'id: ' + id, 'email: ' + email, 'type: ' + type, 'status: ' + status);
			me.log(sql);
			me.log(sqlArgs);

			var deferred = mod_Q.defer();

			db.all(sql, sqlArgs, function(err, row) {

				if (err) {

					me.log(LOG_PREFIX + 'getSendStatus error');
					me.log(err);
					deferred.reject({
						result: 'fail',
						message: 'getSendStatus error',
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
						LOG_PREFIX + 'getSendStatus complete'
					].concat(criteriaText));
					//me.log(LOG_PREFIX + 'getSendStatus complete', 'id: ' + id, 'email: ' + email, 'type: ' + type, 'status: ' + status);
					me.log(row.length + ' record' + (row.length > 1 ? 's' : '') + ' found');
					deferred.resolve(row);

				}

			});

			return deferred.promise;

		});

	};

	/**
	 * Sets the record specified by id and email to status
	 * 
	 * @param id
	 *            required
	 * @param email
	 *            required
	 * @param type
	 *            required
	 * @param status
	 *            required
	 * @param transactionID
	 *            optional
	 * @param message
	 *            optional
	 * @param sourceData
	 *            optional
	 * @param isCC
	 *            optional
	 * @param updateRecordOnceSent
	 *            optional, true/false
	 * 
	 */
	this.setSendStatus = function(id, email, type, status, transactionID, message, sourceData, isCC, updateRecordOnceSent) {

		return me.isTableInitialized().then(function(db) {

			me.log(LOG_PREFIX + 'setSendStatus', 'id: ' + id, 'email: ' + email, 'type: ' + type, 'status: ' + status);
			if (transactionID)
				me.log('transactionID: ' + transactionID);
			if (message)
				me.log('message: ' + message);
			if (sourceData)
				me.log('sourceData: ' + sourceData);
			if (isCC)
				me.log('isCC: ' + isCC);
			if (updateRecordOnceSent !== undefined)
				me.log('updateRecordOnceSent: ' + updateRecordOnceSent);

			if (!id || !email || !type || !status) {

				// all of them have to be specified
				var errorMsg = 'id, email, type, and status required for setSendStatus';
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
				if (email)
					email = String(email);
				if (type)
					type = String(type);
				if (status)
					status = String(status);

				// get record with specified data
				return me.getSendStatus(id, email, type).then(function(results) {

					// then set it to new set of specified values

					var sql;
					// property name must be '$(name)'
					var sqlArgs = {
						'$id': id,
						'$email': email,
						'$type': type,
						'$status': status
					};

					if (transactionID)
						sqlArgs['$transactionID'] = String(transactionID);
					if (message)
						sqlArgs['$message'] = String(message);
					if (sourceData)
						sqlArgs['$sourceData'] = String(sourceData);
					if (isCC)
						sqlArgs['$isCC'] = String(isCC);
					if (updateRecordOnceSent !== undefined)
						sqlArgs['$updateRecordOnceSent'] = (updateRecordOnceSent ? 1 : 0);

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

						/*
						sql += ' SET id=$id, email=$email, type=$type, status=$status';
						sql += (transactionID ? ', transactionID=$transactionID' : '');
						sql += (message ? ', message=$message' : '');
						sql += (sourceData ? ', sourceData=$sourceData' : '');
						sql += (isCC ? ', isCC=$isCC' : '');
						sql += (updateRecordOnceSent !== undefined ? ', updateRecordOnceSent=$updateRecordOnceSent' : '');
						 */

						sql += ' WHERE id=$id AND email=$email AND type=$type';

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

						/*
						sql += ' (id, email, type, status';
						sql += (transactionID ? ', transactionID' : '');
						sql += (message ? ', message' : '');
						sql += (sourceData ? ', sourceData' : '');
						sql += (isCC ? ', isCC' : '');
						sql += (updateRecordOnceSent !== undefined ? ', updateRecordOnceSent' : '');
						sql += ')';
						 */

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

						/*
						sql += ' VALUES ($id,$email,$type,$status';
						sql += (transactionID ? ',$transactionID' : '');
						sql += (message ? ',$message' : '');
						sql += (sourceData ? ',$sourceData' : '');
						sql += (isCC ? ',$isCC' : '');
						sql += (updateRecordOnceSent !== undefined ? ',$updateRecordOnceSent' : '');
						sql += ')';
						 */

					}

					sql += ';';

					me.log(sql);
					me.log(sqlArgs);

					var deferred = mod_Q.defer();

					db.run(sql, sqlArgs, function(err) {

						if (err) {

							me.log(LOG_PREFIX + 'setSendStatus error');
							me.log(err);
							deferred.reject({
								result: 'fail',
								message: 'setSendStatus error',
								data: sqlArgs,
								error: {
									obj: err,
									data: ObjectUtils.convertToErrorObj(err)
								}
							});

						} else {

							me.log(LOG_PREFIX + 'setSendStatus complete', 'id: ' + id, 'email: ' + email, 'type: ' + type, 'status: ' + status);
							deferred.resolve({
								id: id,
								email: email,
								type: type,
								status: status
							});

						}

					});

					return deferred.promise;

				});

			}

		});

	};

	/**
	 * At least one of the parameters is required
	 * 
	 * @param id
	 * @param email
	 * @param type
	 */
	this.removeSendStatus = function(id, email, type) {

		return me.isTableInitialized().then(function(db) {

			me.log(LOG_PREFIX + 'removeSendStatus', 'id: ' + id, 'email: ' + email, 'type: ' + type);

			if (!id && !email && !type) {

				// one of them has to be specified
				var errorMsg = 'id/email/type to be removed not specified';
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
				if (email)
					email = String(email);
				if (type)
					type = String(type);

				return me.getSendStatus(id, email, type).then(function(results) {

					if (results.length > 0) {

						var criteria = {};
						if (id)
							criteria.id = id;
						if (email)
							criteria.email = email;
						if (type)
							criteria.type = type;

						var expr = me.buildSQLWhereExpr(criteria);
						var sql = 'DELETE FROM ' + defaultTableName + expr.sql + ';';
						var sqlArgs = expr.sqlArgs;
						var criteriaText = expr.criteriaText;

						me.log(sql);
						me.log(sqlArgs);

						var deferred = mod_Q.defer();

						db.run(sql, sqlArgs, function(err) {

							if (err) {

								me.log(LOG_PREFIX + 'removeSendStatus error');
								me.log(err);
								deferred.reject({
									result: 'fail',
									message: 'removeSendStatus error',
									data: sqlArgs,
									error: {
										obj: err,
										data: ObjectUtils.convertToErrorObj(err)
									}
								});

							} else {

								me.log(LOG_PREFIX + 'removeSendStatus complete', 'id: ' + id, 'email: ' + email, 'type: ' + type);
								deferred.resolve({
									id: id,
									email: email,
									type: type,
									status: 'sent'
								});

							}

						});

						return deferred.promise;

					} else {

						var errorMsg = 'Could not remove ' + id + ' ' + email + ' ' + type + ', not found';
						me.log(LOG_PREFIX + 'removeSendStatus fail, ' + errorMsg);
						
						return mod_Q.reject({
							result: 'fail',
							message: errorMsg,
							data: {
								id: id,
								email: email,
								type: type,
							},
							error: null
						});

					}

				});

			}

		});

	};

};

// extends
EmailStatusDB.prototype = new SQLite3DB();
EmailStatusDB.prototype.constructor = EmailStatusDB;

// --------------------------------------------------------------------------
//
// static properties
//
// --------------------------------------------------------------------------

// email types
EmailStatusDB.TYPE_UNDEFINED = 'undefined';

// email status constants
EmailStatusDB.STATUS = {};

// Email info presend
EmailStatusDB.STATUS.PRE_SEND = 'preSend';
// Email info presend
EmailStatusDB.STATUS.SEND_ERROR = 'sendError';
// Email info submitted
EmailStatusDB.STATUS.SEND_INITIATED = 'sendInitiated';
// Email info submit failed, email probably didn't go
EmailStatusDB.STATUS.ERROR_SEND_INITIATE_FAIL = 'ErrorSendInitiateFail';
// Currently in process of sending
EmailStatusDB.STATUS.SENDING = 'sending';
// Email failed to be delivered
EmailStatusDB.STATUS.SEND_FAILED = 'sendFailed';
// Could not get status of send progress
EmailStatusDB.STATUS.ERROR_GET_SEND_STATUS_FAIL = 'ErrorGetSendStatusFail';
// Email sent, but update record failed
EmailStatusDB.STATUS.ERROR_SENT_BUT_UPDATE_RECORD_FAIL = 'ErrorSentButUpdateRecordFail';
// Email failed to be delivered, and also update record failed
EmailStatusDB.STATUS.ERROR_SEND_FAILED_AND_UPDATE_RECORD_FAIL = 'ErrorSendFailUpdateRecordFail';

module.exports = EmailStatusDB;