/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.java.android.utils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

public class URIUtils {

	public static String encodeURIComponent(String value) {

		try {

			// return URLEncoder.encode(value, "UTF-8").replace("+", "%20");
			return URLEncoder.encode(value, "UTF-8").replace("+", "%20")
					.replaceAll("\\%28", "(").replaceAll("\\%29", ")")
					.replaceAll("\\%27", "'").replaceAll("\\%21", "!")
					.replaceAll("\\%7E", "~");

		} catch (UnsupportedEncodingException e) {

			return value;

		}

	}

	public static String decodeURIComponent(String value) {

		try {

			return URLDecoder.decode(value, "UTF-8");

		} catch (UnsupportedEncodingException e) {

			return value;

		}

	}

}
