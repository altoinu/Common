<?php

/**
 * @return string
 */
function getCurrentFolderPath() {
	
	return substr(__FILE__, 0, strrpos(__FILE__, "/") + 1);
	
}

function encodeURI($uri)
{
	return preg_replace_callback("{[^0-9a-z_.!~*'();,/?:@&=+$#]}i", function ($m) {
		return sprintf('%%%02X', ord($m[0]));
	}, $uri);
}

?>