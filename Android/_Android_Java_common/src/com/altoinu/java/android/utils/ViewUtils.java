/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.java.android.utils;

import android.content.Context;

public class ViewUtils {

	/**
	 * Convert dp to pixel value
	 * @param dpValue
	 * @param context
	 * @return dp value in pixels
	 */
	public static int dpToPx(int dpValue, Context context) {
		
		final float scale = context.getResources().getDisplayMetrics().density;
		return (int) (dpValue * scale + 0.5f);
		
	}
	
}
