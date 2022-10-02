<?php
use Models\ServerList;

function getWCFCenter($serverid) {
	// global $conn;
	$svname = null;
	// $check = sqlsrv_query($conn, "select LinkCenter from Server_List WHERE ServerID = ?" , array($serverid), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));
	$svInfo = ServerList::where('ServerID', $serverid)->first(['LinkCenter']);
	if(!empty($svInfo)) {
		$svname = $svInfo['LinkCenter'];
	}
	// if(sqlsrv_num_rows($check) > 0) {
	// 	$svInfo = sqlsrv_fetch_array($check, SQLSRV_FETCH_ASSOC);
	// 	$svname = $svInfo['LinkCenter'];
	// }
	// sqlsrv_free_stmt($check);
	return $svname;
}

function SoapConnect($link) {
	$options = array(
		'soap_version'=> SOAP_1_1, 
		'exceptions'=> false, 
		'trace'=> 1,
		'cache_wsdl' => WSDL_CACHE_NONE, // WSDL_CACHE_MEMORY
        'exception' => 1,
        'keep_alive' => false,
		'connection_timeout' => 10,
	);
	
	$client = new SoapClient($link.'?wsdl', $options);//Lỗi
	return $client;
}

function noticeMail($serverid, $playerid) {
	
	$linkWCF = getWCFCenter($serverid);
	
	if($linkWCF && $linkWCF != null) {
		// notice to player
		$client = SoapConnect($linkWCF);
		if($client) {
			// connect to soap
			$obj = array('playerID' => $playerid);
			$result = $client->MailNotice($obj);
			if($result->MailNoticeResult == '1')
				return true;
			else
				return false;
		}
	}
}

function loginDevice($serverid, $content) {
	
	$linkWCF = getWCFCenter($serverid);
	
	if($linkWCF && $linkWCF != null) {
		// notice to player
		$client = SoapConnect($linkWCF);
		if($client) {
			// connect to soap
			$obj = array('zoneId' => $serverid, 'content' => $content);
			$result = $client->LoginDevice($obj);
			if($result->LoginDeviceResult == '1')
				return true;
			else
				return false;
		}
	}
}

function soapChargeMoney($serverid, $playerid, $chargeId) {
	
	$linkWCF = getWCFCenter($serverid);
	
	if($linkWCF && $linkWCF != null) {
		// notice to player
		// die($linkWCF);
		$client = SoapConnect($linkWCF);
		if($client) {
			// connect to soap
			$obj = array('userID' => $playerid, 'chargeID' => $chargeId);
			$result = $client->ChargeMoney($obj);
			return $result;
			if($result->ChargeMoneyResult == '1')
				return true;
			else
				return false;
		}
	}
}

function soapSendMail($serverid, $title, $content, $playerId, $itemArray, $md5) {
	
	//die($serverid . "|" . $playerId . "|" . $title . "|" . $content . "|" . $itemArray . "|" . $md5);
	
	$linkWCF = getWCFCenter($serverid);
	
	if($linkWCF && $linkWCF != null) {
		// notice to player
		$client = SoapConnect($linkWCF);
		if($client) {
			// connect to soap
			$obj = array('title' => $title, 'content' => $content, 'playerId' => $playerId, 'itemArray' => $itemArray, 'md5' => $md5);
			$result = $client->MailSend($obj);
			if($result->MailSendResult == '1')
				return true;
			else
				return false;
		}
	}
}

function soapSendSystemNotice($serverid, $text) {
	$linkWCF = getWCFCenter($serverid);
	
	if($linkWCF && $linkWCF != null) {
		$client = SoapConnect($linkWCF);
		if($client) {
			// connect to soap
			//$string = iconv('windows-1252', 'UTF-8', $text);
			$obj = array('msg' => $text);
			$result = $client->SystemNotice($obj);
			if($result->SystemNoticeResult == '1')
				return true;
			else
				return false;
		}
	}
}

function kickPlayer($serverid, $playerid) {
	$linkWCF = getWCFCenter($serverid);
	
	if($linkWCF && $linkWCF != null) {
		$client = SoapConnect($linkWCF);
		if($client) {
			// connect to soap
			$obj = array('playerID' => $playerid, 'msg' => 'kick player');
			$result = $client->KitoffUser($obj);
			if($result->KitoffUserResult == '1')
				return true;
			else
				return false;
		}
	}
}
?>