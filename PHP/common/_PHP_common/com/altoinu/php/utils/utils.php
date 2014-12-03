<?php

/**
 * I guess I can just use dirname() instead
 * @return string
 */
function getCurrentFolderPath() {
	
	return substr(__FILE__, 0, strrpos(__FILE__, "/") + 1);
	
}

function getIncludeParentFileName() {
	
	$dt = debug_backtrace();
	
	for ($i = 0; $i < count($dt); $i++) {
		
		if ($dt[$i]['function'] == 'getIncludeParentFileName') {
			
			// This is the script file calling this method
			$thisFile = $dt[$i]['file'];
			
			// We want to find file that is including $thisFile
			for ($j = 0; $j < count($dt); $j++) {
				
				if (($dt[$j]['function'] == 'include') ||
					($dt[$j]['function'] == 'include_once') ||
					($dt[$j]['function'] == 'require') ||
					($dt[$j]['function'] == 'require_once')) {
					
					if (isset($dt[$j]['args']) && ($dt[$j]['args'][0] == $thisFile)) {
						
						return $dt[$j]['file'];
						break;
						
					}
					
				}
				
			}
			
		}
		
	}
	
	// not being included by any
	return null;
	
}

function encodeURI($uri)
{
	return preg_replace_callback("{[^0-9a-z_.!~*'();,/?:@&=+$#]}i", function ($m) {
		return sprintf('%%%02X', ord($m[0]));
	}, $uri);
}

?>