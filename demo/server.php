<?php
/**
 * Pharos for PHP
 *
 * Code Example:
 * print_r( Pharos::push('foo', 1, array( 'foo' => 'bar' )) );
 *
 * @copyright 2012 CodeSup http://codesup.com
 * @package Pharos
 * @author Philipp Spieß <philipp.spiess@myxcode.at>
 */
class Pharos {
  private static $domain = 'http://localhost:7331/';
  public static function push($channel, $ids, $msg) {
    if(!is_array($ids)) {
      $ids = array($ids);
    }

    $cmd = array(
      'channel' => $channel,
      'ids' => $ids,
      'msg' => $msg
    );

    $cmd = json_encode($cmd);
    
    $ch = curl_init();
    
    curl_setopt($ch, CURLOPT_URL, self::$domain . 'push');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, count($cmd));
    curl_setopt($ch, CURLOPT_POSTFIELDS, $cmd);
    
    $result = curl_exec($ch);
    curl_close($ch);
    
    return json_decode($result, true);
  }
}