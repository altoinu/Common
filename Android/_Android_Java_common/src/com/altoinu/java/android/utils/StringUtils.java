/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.java.android.utils;

public class StringUtils {

	public static String getURLProtocol(String url) {

		int slash = url.indexOf("/");
		int indx = url.indexOf(":/");

		if (indx > -1 && indx < slash) {

			return url.substring(0, indx);

		} else {

			indx = url.indexOf("::");

			if (indx > -1 && indx < slash)
				return url.substring(0, indx);

		}

		return "";

	}

	public static String dropURLProtocol(String url, String protocol) {

		return url.substring(url.indexOf(protocol) + protocol.length() + 3);

	}

}
