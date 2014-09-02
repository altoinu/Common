<?php
/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */

// This script requires Tesseract OCR installed
// https://code.google.com/p/tesseract-ocr/

/**
 * require 'process_uploaded_image.php';
 * $text = recognizeCharacters();
 * 
 * @return string
 */
function recognizeCharacters() {
	
	$path = substr(__FILE__, 0, strrpos(__FILE__, "/") + 1);
	require_once $path . 'supportClasses/Tesseract_FileUpload.php';
	require_once $path . 'supportClasses/tesseract_ocr.php';
	
	$fileUpload = new Tesseract_FileUpload('png|jpg|jpeg', './snapPhotos', 'uploadedimage');
	$fileUpload->do_upload('photo');
	$photo_data = $fileUpload->data();
	return TesseractOCR::recognize($photo_data['full_path']);
	
}

?>