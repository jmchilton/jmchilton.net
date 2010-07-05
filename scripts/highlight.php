#!/usr/bin/php -q
<?
$LANGUAGE_PATH = 'scripts/geshi/geshi';
 
function get_pretty_code( $str, $lang )
{
	global $LANGUAGE_PATH;
	require_once( 'scripts/geshi/geshi.php' );
	$geshi = new GeSHi( $str, $lang, $LANGUAGE_PATH );
	if( $lang == 'php' )
	{
		 $geshi->enable_strict_mode( true );
	}
	$str = $geshi->parse_code();
	return $str;
}

$source_code    = file_get_contents( $argv[1] );
$lang           = $argv[2];
$colorized_code = get_pretty_code($source_code, $lang);

echo $colorized_code;
?>
