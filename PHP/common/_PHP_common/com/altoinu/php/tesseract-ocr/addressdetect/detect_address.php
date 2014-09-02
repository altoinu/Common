<?php
/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */

/**
 * require_once 'detect_address.php';
 * $results = detectUSAddress($text);
 * 
 * @param unknown $text
 * @return multitype:unknown multitype:
 */
function detectUSAddress($text) {
	
	// US address reg ex
	$addressName = "(?:(.+)\n)"; // name
	
	$addressStreetBase = "(?:\d+ +).+";  // street address, number + street name
	$addressStreet = "(?:($addressStreetBase)\n)"; // with capture group
	$addressStreetNoCapture = "(?:$addressStreetBase\n)"; // no capture group
	
	$addressRoomLabel = "(?:apartment|apt|suite|ste|unit)";
	$addressRoom = "(?:(" . $addressRoomLabel . " .+)\n)"; // apt/suite/unit with capture group
	$addressRoomNoCapture = "(?:" . $addressRoomLabel . " .+\n)"; // apt/suite/unit
	
	$addressStreetRoomPattern1 = "(?:" . $addressRoom . $addressStreet . ")"; // apt/suite/unit, street address
	$addressStreetRoomPattern2 = "(?:" . $addressStreet . $addressRoom . ")"; // street address, apt/suite/unit
	
	$addressCityStateZip = "((?:\w| )+),? *([a-zA-Z]{2}) +(\d{5}(?:-\d{4})?)"; // city, state zip 5 or 5-4
	
	$addressPattern = "(?:$addressStreetRoomPattern1|$addressStreetRoomPattern2|$addressStreet)" . $addressCityStateZip;
	
	// strip empty lines
	$textTrimmed = str_replace("\n\n", "\n", trim($text));
	// add empty line after line containing city, state zip pattern
	$textTrimmed = preg_replace("/^" . $addressCityStateZip . "$/im", "$0\n", $textTrimmed);
	
	//preg_match_all($addressPattern, $text, $matches, PREG_SET_ORDER);
	//preg_match_all("/^$addressName$addressPattern$/im", $textTrimmed, $matches, PREG_PATTERN_ORDER);
	
	// name, optional 2nd name (company name, etc, not street or room), followed by address pattern
	preg_match_all("/^$addressName(?:(?!$addressStreetNoCapture|$addressRoomNoCapture)$addressName)?$addressPattern$/im", $textTrimmed, $matches, PREG_PATTERN_ORDER);
	
	$results = array(
			"addresses" => $matches[0],
			"subpatterns" => array_slice($matches, 1),
			"detected" => $text
	);
	
	return $results;
	
}

?>