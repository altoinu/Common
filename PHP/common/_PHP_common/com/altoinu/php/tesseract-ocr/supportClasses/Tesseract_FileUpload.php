<?php 
/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */

class Tesseract_FileUpload
{

	public $uploadError = "";
	
	public $allowed_types = array('png', 'jpg', 'jpeg');
	public $file_temp = "";
	public $file_name = "";
	public $file_type = "";
	public $file_size = "";
	public $file_ext = "";
	public $image_width = '';
	public $image_height = '';
	public $image_type = '';
	public $image_size_str = '';
	public $mimes = array();
	public $xss_clean = FALSE;
	
	public $upload_path = "";
	
	protected $_file_name_override = "";
	
	public function __construct($allowedTypes, $uploadPath, $fileNameOverride = "")
	{
		
		$this->set_allowed_types($allowedTypes);
		$this->set_upload_path($uploadPath);
		
		$this->_file_name_override = $fileNameOverride;
		
	}

	/**
	 * Set Allowed File Types
	 *
	 * @param	string
	 * @return	void
	 */
	public function set_allowed_types($types)
	{
		if ( ! is_array($types) && $types == '*')
		{
			$this->allowed_types = '*';
			return;
		}
		$this->allowed_types = explode('|', $types);
	}
	
	/**
	 * Set Upload Path
	 *
	 * @param	string
	 * @return	void
	 */
	public function set_upload_path($path)
	{
		// Make sure it has a trailing slash
		$this->upload_path = rtrim($path, '/').'/';
	}
	
	/**
	 * Set Image Properties
	 *
	 * Uses GD to determine the width/height/type of image
	 *
	 * @param	string
	 * @return	void
	 */
	public function set_image_properties($path = '')
	{
		if ( ! $this->is_image())
		{
			return;
		}
	
		if (function_exists('getimagesize'))
		{
			if (FALSE !== ($D = @getimagesize($path)))
			{
				$types = array(1 => 'gif', 2 => 'jpeg', 3 => 'png');
	
				$this->image_width		= $D['0'];
				$this->image_height		= $D['1'];
				$this->image_type		= ( ! isset($types[$D['2']])) ? 'unknown' : $types[$D['2']];
				$this->image_size_str	= $D['3'];  // string containing height and width
			}
		}
	}

	/**
	 * Validate the image
	 *
	 * @return	bool
	 */
	public function is_image()
	{
		// IE will sometimes return odd mime-types during upload, so here we just standardize all
		// jpegs or pngs to the same file type.
	
		$png_mimes  = array('image/x-png');
		$jpeg_mimes = array('image/jpg', 'image/jpe', 'image/jpeg', 'image/pjpeg');
	
		if (in_array($this->file_type, $png_mimes))
		{
			$this->file_type = 'image/png';
		}
	
		if (in_array($this->file_type, $jpeg_mimes))
		{
			$this->file_type = 'image/jpeg';
		}
	
		$img_mimes = array(
				'image/gif',
				'image/jpeg',
				'image/png',
		);
	
		return (in_array($this->file_type, $img_mimes, TRUE)) ? TRUE : FALSE;
	}
	
	/**
	 * Verify that the filetype is allowed
	 *
	 * @return	bool
	 */
	public function is_allowed_filetype($ignore_mime = FALSE)
	{
		if ($this->allowed_types == '*')
		{
			return TRUE;
		}
	
		if (count($this->allowed_types) == 0 OR ! is_array($this->allowed_types))
		{
			// TODO: log -
			$this->uploadError = "upload_no_file_types";
			return FALSE;
		}
	
		$ext = strtolower(ltrim($this->file_ext, '.'));
	
		if ( ! in_array($ext, $this->allowed_types))
		{
			return FALSE;
		}
		
		// Images get some additional checks
		$image_types = array('gif', 'jpg', 'jpeg', 'png', 'jpe');
	
		if (in_array($ext, $image_types))
		{
			if (getimagesize($this->file_temp) === FALSE)
			{
				return FALSE;
			}
		}
	
		if ($ignore_mime === TRUE)
		{
			return TRUE;
		}
	
		$mime = $this->mimes_types($ext);
	
		if (is_array($mime))
		{
			if (in_array($this->file_type, $mime, TRUE))
			{
				return TRUE;
			}
		}
		elseif ($mime == $this->file_type)
		{
			return TRUE;
		}
	
		return FALSE;
	}
	
	public function validate_upload_path()
	{
	
		if ($this->upload_path == '')
		{
			// TODO: log - no upload path
			$this->uploadError = "upload_no_filepath";
			return FALSE;
		}
	
		if (function_exists('realpath') AND @realpath($this->upload_path) !== FALSE)
		{
			$this->upload_path = str_replace("\\", "/", realpath($this->upload_path));
		}
	
		if ( ! @is_dir($this->upload_path))
		{
			// TODO: log - no upload path
			$this->uploadError = "upload_no_filepath";
			return FALSE;
		}
	
		if ( ! is_really_writable($this->upload_path))
		{
			// TODO: log - cannot write
			$this->uploadError = "upload_not_writable";
			return FALSE;
		}
	
		$this->upload_path = preg_replace("/(.+?)\/*$/", "\\1/",  $this->upload_path);
		return TRUE;
	
	}
	
	/**
	 * Extract the file extension
	 *
	 * @param	string
	 * @return	string
	 */
	public function get_extension($filename)
	{
		$x = explode('.', $filename);
		return '.'.end($x);
	}

	/**
	 * Clean the file name for security
	 *
	 * @param	string
	 * @return	string
	 */
	public function clean_file_name($filename)
	{
		$bad = array(
						"<!--",
						"-->",
						"'",
						"<",
						">",
						'"',
						'&',
						'$',
						'=',
						';',
						'?',
						'/',
						"%20",
						"%22",
						"%3c",		// <
						"%253c",	// <
						"%3e",		// >
						"%0e",		// >
						"%28",		// (
						"%29",		// )
						"%2528",	// (
						"%26",		// &
						"%24",		// $
						"%3f",		// ?
						"%3b",		// ;
						"%3d"		// =
					);

		$filename = str_replace($bad, '', $filename);

		return stripslashes($filename);
	}

	/**
	 * Runs the file through the XSS clean function
	 *
	 * This prevents people from embedding malicious code in their files.
	 * I'm not sure that it won't negatively affect certain files in unexpected ways,
	 * but so far I haven't found that it causes trouble.
	 *
	 * @return	void
	 */
	/*
	public function do_xss_clean()
	{
		$file = $this->file_temp;
	
		if (filesize($file) == 0)
		{
			return FALSE;
		}
	
		if (function_exists('memory_get_usage') && memory_get_usage() && ini_get('memory_limit') != '')
		{
			$current = ini_get('memory_limit') * 1024 * 1024;
	
			// There was a bug/behavioural change in PHP 5.2, where numbers over one million get output
			// into scientific notation.  number_format() ensures this number is an integer
			// http://bugs.php.net/bug.php?id=43053
	
			$new_memory = number_format(ceil(filesize($file) + $current), 0, '.', '');
	
			ini_set('memory_limit', $new_memory); // When an integer is used, the value is measured in bytes. - PHP.net
		}
	
		// If the file being uploaded is an image, then we should have no problem with XSS attacks (in theory), but
		// IE can be fooled into mime-type detecting a malformed image as an html file, thus executing an XSS attack on anyone
		// using IE who looks at the image.  It does this by inspecting the first 255 bytes of an image.  To get around this
		// CI will itself look at the first 255 bytes of an image to determine its relative safety.  This can save a lot of
		// processor power and time if it is actually a clean image, as it will be in nearly all instances _except_ an
		// attempted XSS attack.
	
		if (function_exists('getimagesize') && @getimagesize($file) !== FALSE)
		{
			if (($file = @fopen($file, 'rb')) === FALSE) // "b" to force binary
			{
				return FALSE; // Couldn't open the file, return FALSE
			}
	
			$opening_bytes = fread($file, 256);
			fclose($file);
	
			// These are known to throw IE into mime-type detection chaos
			// <a, <body, <head, <html, <img, <plaintext, <pre, <script, <table, <title
			// title is basically just in SVG, but we filter it anyhow
	
			if ( ! preg_match('/<(a|body|head|html|img|plaintext|pre|script|table|title)[\s>]/i', $opening_bytes))
			{
				return TRUE; // its an image, no "triggers" detected in the first 256 bytes, we're good
			}
		}
	
		if (($data = @file_get_contents($file)) === FALSE)
		{
			return FALSE;
		}
	
		$CI =& get_instance();
		return $CI->security->xss_clean($data, TRUE);
	}
	*/
	
	/**
	 * List of Mime Types
	 *
	 * This is a list of mime types.  We use it to validate
	 * the "allowed types" set by the developer
	 *
	 * @param	string
	 * @return	string
	 */
	public function mimes_types($mime)
	{
		global $mimes;
	
		if (count($this->mimes) == 0)
		{
			/*
			 if (defined('ENVIRONMENT') AND is_file(APPPATH.'config/'.ENVIRONMENT.'/mimes.php'))
			 {
			include(APPPATH.'config/'.ENVIRONMENT.'/mimes.php');
			}
			elseif (is_file(APPPATH.'config/mimes.php'))
			{
			include(APPPATH.'config//mimes.php');
			}
			*/
			$path = substr(__FILE__, 0, strrpos(__FILE__, "/") + 1);
			if (is_file($path . 'mimes.php'))
			{
				include($path . 'mimes.php');
			}
			else
			{
				return FALSE;
			}
	
			$this->mimes = $mimes;
			unset($mimes);
		}
		
		return ( ! isset($this->mimes[$mime])) ? FALSE : $this->mimes[$mime];
	}
	
	public function do_upload($field = "file")
	{
		
		// Is $_FILES[$field] set? If not, no reason to continue.
		if ( ! isset($_FILES[$field]))
		{
			
			// TODO: log - no file
			$this->uploadError = "upload_no_file_selected";
			return FALSE;
			
		}
		
		// Is the upload path valid?
		if ( ! $this->validate_upload_path())
		{
			// errors will already be set by validate_upload_path() so just return FALSE
			return FALSE;
		}
		
		// Was the file able to be uploaded? If not, determine the reason why.
		if ( ! is_uploaded_file($_FILES[$field]['tmp_name']))
		{
			
			$error = ( ! isset($_FILES[$field]['error'])) ? 4 : $_FILES[$field]['error'];

			// TODO: log -
			switch($error)
			{
				case 1:	// UPLOAD_ERR_INI_SIZE
					$this->uploadError = "upload_file_exceeds_limit";
					break;
				case 2: // UPLOAD_ERR_FORM_SIZE
					$this->uploadError = "upload_file_exceeds_form_limit";
					break;
				case 3: // UPLOAD_ERR_PARTIAL
					$this->uploadError = "upload_file_partial";
					break;
				case 4: // UPLOAD_ERR_NO_FILE
					$this->uploadError = "upload_no_file_selected";
					break;
				case 6: // UPLOAD_ERR_NO_TMP_DIR
					$this->uploadError = "upload_no_temp_directory";
					break;
				case 7: // UPLOAD_ERR_CANT_WRITE
					$this->uploadError = "upload_unable_to_write_file";
					break;
				case 8: // UPLOAD_ERR_EXTENSION
					$this->uploadError = "upload_stopped_by_extension";
					break;
				default:
					$this->uploadError = "upload_no_file_selected";
					break;
			}

			return FALSE;
		}
		
		// Set the uploaded data as class variables
		$this->file_temp = $_FILES[$field]['tmp_name'];
		$this->file_size = $_FILES[$field]['size'];
		$this->file_type = preg_replace("/^(.+?);.*$/", "\\1", $_FILES[$field]['type']);
		$this->file_type = strtolower(trim(stripslashes($this->file_type), '"'));
		$this->file_name = $this->_prep_filename($_FILES[$field]['name']);
		$this->file_ext	 = $this->get_extension($this->file_name);
		//$this->client_name = $this->file_name;
		
		// Is the file type allowed to be uploaded?
		if ( ! $this->is_allowed_filetype())
		{
			// TODO: log -
			$this->uploadError = "upload_invalid_filetype";
			return FALSE;
		}

		// if we're overriding, let's now make sure the new name and type is allowed
		
		if ($this->_file_name_override != '')
		{
			$this->file_name = $this->_prep_filename($this->_file_name_override);

			// If no extension was provided in the file_name config item, use the uploaded one
			if (strpos($this->_file_name_override, '.') === FALSE)
			{
				$this->file_name .= $this->file_ext;
			}

			// An extension was provided, lets have it!
			else
			{
				$this->file_ext	 = $this->get_extension($this->_file_name_override);
			}

			if ( ! $this->is_allowed_filetype(TRUE))
			{
				// TODO: log -
				$this->uploadError = "upload_invalid_filetype";
				return FALSE;
			}
		}

		// Convert the file size to kilobytes
		if ($this->file_size > 0)
		{
			$this->file_size = round($this->file_size/1024, 2);
		}

		/*
		// Is the file size within the allowed maximum?
		if ( ! $this->is_allowed_filesize())
		{
			// TODO: log -
			$this->uploadError = "upload_invalid_filesize";
			return FALSE;
		}
		*/

		/*
		// Are the image dimensions within the allowed size?
		// Note: This can fail if the server has an open_basdir restriction.
		if ( ! $this->is_allowed_dimensions())
		{
			// TODO: log -
			$this->uploadError = "upload_invalid_dimensions";
			return FALSE;
		}
		*/

		// Sanitize the file name for security
		$this->file_name = $this->clean_file_name($this->file_name);

		/*
		// Truncate the file name if it's too long
		if ($this->max_filename > 0)
		{
			$this->file_name = $this->limit_filename_length($this->file_name, $this->max_filename);
		}
		*/
		
		/*
		// Remove white spaces in the name
		if ($this->remove_spaces == TRUE)
		{
			$this->file_name = preg_replace("/\s+/", "_", $this->file_name);
		}
		*/

		/*
		 * Validate the file name
		* This function appends an number onto the end of
		* the file if one with the same name already exists.
		* If it returns false there was a problem.
		*/
		/*
		$this->orig_name = $this->file_name;
		
		if ($this->overwrite == FALSE)
		{
			$this->file_name = $this->set_filename($this->upload_path, $this->file_name);
		
			if ($this->file_name === FALSE)
			{
				return FALSE;
			}
		}
		*/

		/*
		 * Run the file through the XSS hacking filter
		* This helps prevent malicious code from being
		* embedded within a file.  Scripts can easily
		* be disguised as images or other file types.
		*/
		/*
		if ($this->xss_clean)
		{
			if ($this->do_xss_clean() === FALSE)
			{
				// TODO: log -
				$this->uploadError = "upload_unable_to_write_file";
				return FALSE;
			}
		}
		*/

		/*
		 * Move the file to the final destination
		* To deal with different server configurations
		* we'll attempt to use copy() first.  If that fails
		* we'll use move_uploaded_file().  One of the two should
		* reliably work in most environments
		*/
		if ( ! @copy($this->file_temp, $this->upload_path.$this->file_name))
		{
			if ( ! @move_uploaded_file($this->file_temp, $this->upload_path.$this->file_name))
			{
				// TODO: log -
				$this->uploadError = "upload_destination_error";
				return FALSE;
			}
		}

		/*
		 * Set the finalized image dimensions
		* This sets the image width/height (assuming the
		* file was an image).  We use this information
		* in the "data" function.
		*/
		$this->set_image_properties($this->upload_path.$this->file_name);
		
		return TRUE;
		
	}

	/**
	 * Finalized Data Array
	 *
	 * Returns an associative array containing all of the information
	 * related to the upload, allowing the developer easy access in one array.
	 *
	 * @return	array
	 */
	public function data()
	{
		return array (
				'file_name'			=> $this->file_name,
				'file_type'			=> $this->file_type,
				'file_path'			=> $this->upload_path,
				'full_path'			=> $this->upload_path.$this->file_name,
				'raw_name'			=> str_replace($this->file_ext, '', $this->file_name),
				//'orig_name'			=> $this->orig_name,
				//'client_name'		=> $this->client_name,
				//'file_ext'			=> $this->file_ext,
				'file_size'			=> $this->file_size,
				'is_image'			=> $this->is_image(),
				'image_width'		=> $this->image_width,
				'image_height'		=> $this->image_height,
				'image_type'		=> $this->image_type,
				'image_size_str'	=> $this->image_size_str,
		);
	}
	
	/**
	 * Prep Filename
	 *
	 * Prevents possible script execution from Apache's handling of files multiple extensions
	 * http://httpd.apache.org/docs/1.3/mod/mod_mime.html#multipleext
	 *
	 * @param	string
	 * @return	string
	 */
	protected function _prep_filename($filename)
	{
		if (strpos($filename, '.') === FALSE OR $this->allowed_types == '*')
		{
			return $filename;
		}

		$parts		= explode('.', $filename);
		$ext		= array_pop($parts);
		$filename	= array_shift($parts);

		foreach ($parts as $part)
		{
			if ( ! in_array(strtolower($part), $this->allowed_types) OR $this->mimes_types(strtolower($part)) === FALSE)
			{
				$filename .= '.'.$part.'_';
			}
			else
			{
				$filename .= '.'.$part;
			}
		}

		$filename .= '.'.$ext;

		return $filename;
	}
	
}

/**
 * Tests for file writability
 *
 * is_writable() returns TRUE on Windows servers when you really can't write to
 * the file, based on the read-only attribute.  is_writable() is also unreliable
 * on Unix servers if safe_mode is on.
 *
 * @access	private
 * @return	void
 */
if ( ! function_exists('is_really_writable'))
{
	function is_really_writable($file)
	{
		// If we're on a Unix server with safe_mode off we call is_writable
		if (DIRECTORY_SEPARATOR == '/' AND @ini_get("safe_mode") == FALSE)
		{
			return is_writable($file);
		}

		// For windows servers and safe_mode "on" installations we'll actually
		// write a file then read it.  Bah...
		if (is_dir($file))
		{
			$file = rtrim($file, '/').'/'.md5(mt_rand(1,100).mt_rand(1,100));

			if (($fp = @fopen($file, FOPEN_WRITE_CREATE)) === FALSE)
			{
				return FALSE;
			}

			fclose($fp);
			@chmod($file, DIR_WRITE_MODE);
			@unlink($file);
			return TRUE;
		}
		elseif ( ! is_file($file) OR ($fp = @fopen($file, FOPEN_WRITE_CREATE)) === FALSE)
		{
			return FALSE;
		}

		fclose($fp);
		return TRUE;
	}
}

?>