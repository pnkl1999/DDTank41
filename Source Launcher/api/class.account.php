<?php
use Models\MemAccount;
use Models\ConfigCharge;
use Models\ServerList;
use Models\LogCard;
use Models\MemHistory;
use Models\LogMomo;
use Illuminate\Database\Capsule\Manager as DB;

class account {

	public $userid;

	public function __construct($uid = 0) {

		$this->userid = $uid;
    }

	public static function test() {
		return MemAccount::first();
	}

    public static function getUsername($username = null) {
    	//return str
    	if($username == null)
    		$username = $_SESSION['ss_user_email'];
    	return $username;
    	$emailArr = explode("@", $username);

    	$firstName = substr($emailArr[0], 0, floor(strlen($emailArr[0]) / 2));

    	$lastName = $emailArr[1];

    	return $firstName.'..@'.$lastName;
    }

	public static function isLogin() {

		global $_config;

		if($_SESSION['ss_user_id'] && $_SESSION['ss_user_email'] && $_SESSION['ss_user_key'] == md5($_SESSION['ss_user_id'].$_SESSION['ss_user_email'].$_SESSION['ss_user_pass'].$_config['function']['code_anti_hack_session']))
			return true;
		else {
			//die("" .md5($_SESSION['ss_user_id'].$_SESSION['ss_user_email'].$_SESSION['ss_user_pass'].$_config['function']['code_anti_hack_session']));
			if($_SESSION['ss_user_id'] || $_SESSION['ss_user_email'] || $_SESSION['ss_user_pass'])
				self::removeSession();
			return false;
		}
	}

	public static function createSession($userid, $email, $password) {

		global $_config;

		$_SESSION['ss_user_id'] = $userid;

		$_SESSION['ss_user_email'] = $email;
		
		$_SESSION['ss_user_pass'] = $password;

		$_SESSION['ss_user_key'] = md5($userid.$email.$password.$_config['function']['code_anti_hack_session']);
		
		//die($_SESSION['ss_user_key']);

	}

	public static function removeSession() {
		$_SESSION['ss_user_id'] = false;
		$_SESSION['ss_user_email'] = false;
		$_SESSION['ss_user_pass'] = false;
		$_SESSION['ss_user_key'] = false;
	}

	private static function createMail($socialId, $type, $socialVar) {
		switch ($type) {

			case 'facebook':
				return $socialId.'@facebook.com';
				break;

			case 'google':
				if($socialVar != null)
					return $socialVar->email;
				else
					return $socialId.'@gmail.com';
				break;

			case 'yahoo':
				if($socialVar != null)
					return $socialVar['contact/email'];
				else
					return $socialId.'@yahoo.com';
				break;
			
			default:
				return null;
				break;
		}
	}

	public static function login($mail, $pass) {
		$ishave = false;

		$accInfo = MemAccount::where([
				['Email', '=', $mail],
				['Password', '=', $pass],
				['IsBan', '=', false],
			])
			->fisrt();
		if(!empty($accInfo)) {

			$ishave = true;

			// create session
			self::createSession($accInfo['UserID'], $mail, $accInfo['Password']);

		}

		return $ishave;
	}

	public static function checkSocial($type, $socialVar) {

		global $conn, $_config;

		$isConnect = false;

		$checkSocial = sqlsrv_query($conn, "select * from Mem_Social WHERE Type = ? AND SocialID = ?", array($type, $socialVar['ID']), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($checkSocial) > 0) {

			$isConnect = true;

		}

		sqlsrv_free_stmt($checkSocial);

		return $isConnect;

	}

	public static function getSocial($socialId, $type) {

		global $conn, $_config;

		$checkSocial = sqlsrv_query($conn, "select * from Mem_Social WHERE Type = ? AND SocialID = ?", array($type, $socialId), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($checkSocial) > 0)
			return sqlsrv_fetch_array($checkSocial, SQLSRV_FETCH_ASSOC);

		return false;
	}

	public static function connectSocial($userid, $type, $socialVar) {

		global $conn, $_config;

		$canConnect = true;

		if(self::isLogin()) {

			$canConnect = self::createSocial($userid, $type, $socialVar);

		}

		return $canConnect;

	}

	public static function loginSocial($type, $socialVar) {

		global $conn, $_config;
		
		$returnVal = false;

		$qCheck = sqlsrv_query($conn, "select Mem_Social.*, Mem_Account.Email, Mem_Account.IsBan, Mem_Account.AllowSocialLogin from Mem_Social, Mem_Account WHERE Mem_Social.SocialID = ? AND Mem_Social.Type = ? AND Mem_Social.UserID = Mem_Account.UserID", array($socialVar['ID'], $type), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			// check is have
			$accInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC);
			
			if($accInfo['IsBan'] == false && $accInfo['AllowSocialLogin'] == true) {
				self::createSession($accInfo['UserID'], $accInfo['Email'], $accInfo['Password']);
				$returnVal = true;
			}

		} else {

			/*// kiem tra xem social nay lien ket voi tai khoan nao
			$socialInfo = self::getSocial($socialVar['ID'], $type);

			if($socialInfo) {

				// social nay da ket noi voi mot tai khoan nao do
				$userInfo = self:getUserInfo($socialInfo['UserID']);

				// mo ket noi voi social do

			}*/

			$qCheck2 = sqlsrv_query($conn, "select * from Mem_Account where Email = ?", array($socialVar['Email']), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

			if(sqlsrv_num_rows($qCheck2) > 0) {

				// ton tai
				$userInfo = sqlsrv_fetch_array($qCheck2, SQLSRV_FETCH_ASSOC);

				self::createSession($userInfo['UserID'], $userInfo['Email'], $userInfo['Password']);

				// kiem tra xem da khoi tao social chua
				self::createSocial($userInfo['UserID'], $type, $socialVar);
				
				$returnVal = true;

			} else {

				// khoi tao social moi
				$userId = self::create($socialVar['Email'], "");

				if($userId > 0) {

					self::createSocial($userId, $type, $socialVar);

					self::createSession($userId, $socialVar['Email'], "");
					
					$returnVal = true;

				}
			}

			sqlsrv_free_stmt($qCheck2);

		}

		sqlsrv_free_stmt($qCheck);
		
		return $returnVal;
	}

	public static function createSocial($userid, $type, $socialVar) {

		global $conn, $_config;

		$canCreate = false;


		if(!self::checkSocial($type, $socialVar)) {

			$createSocial = sqlsrv_query($conn, "insert into Mem_Social (UserID, Type, SocialID, SocialName, SocialEmail, TimeCreate, IPCreate) VALUES (?, ?, ?, ?, ?, ?, ?)", array($userid, $type, $socialVar['ID'], utf8_encode($socialVar['Name']), $socialVar['Email'], time(), self::getUserIP()));

			if($createSocial) {

				//self::createSession($userid, $socialVar['Email']);

				sqlsrv_free_stmt($createSocial);

				$canCreate = true;

			} else {
				//echo 'loi sql '.$socialVar['ID'].'-'.$socialVar['Email'].'-'.$socialVar['Name'];
				print_r(sqlsrv_errors());

				die();

			}

		}

		return $canCreate;
	}

	public static function create($email, $password) {

		global $conn, $_config;

		$userid = 0;

		$qCheck = sqlsrv_query($conn, "select * from Mem_Account where Email = ?", array($email), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) <= 0) {

			$qInsert = sqlsrv_query($conn, "insert into Mem_Account (Email, Password, Money, TimeCreate, IPCreate, MoneyLock) VALUES (?, ?, 0, ?, ?, ?)", array($email, $password, time(), self::getUserIP(), 0));

			if($qInsert) {

				sqlsrv_free_stmt($qInsert);

				// get userid
				$qGet = sqlsrv_query($conn, "select UserID from Mem_Account where Email = ?", array($email), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

				$userInfo = sqlsrv_fetch_array($qGet, SQLSRV_FETCH_ASSOC);

				$userid = $userInfo['UserID'];

				//$this->userid = $userid;

				sqlsrv_free_stmt($qGet);

			} else {
				print_r(sqlsrv_errors());
				die();
			}
		}

		sqlsrv_free_stmt($qCheck);

		return $userid;
	}

	public static function getUserIP() {

	    if( array_key_exists('HTTP_X_FORWARDED_FOR', $_SERVER) && !empty($_SERVER['HTTP_X_FORWARDED_FOR']) ) {
	        if (strpos($_SERVER['HTTP_X_FORWARDED_FOR'], ',')>0) {
	            $addr = explode(",",$_SERVER['HTTP_X_FORWARDED_FOR']);
	            return trim($addr[0]);
	        } else {
	            return $_SERVER['HTTP_X_FORWARDED_FOR'];
	        }
	    }
	    else {
	        return $_SERVER['REMOTE_ADDR'];
	    }

	}

	public static function getSocialConnect($userid, $name) {

		global $conn, $_config;

		$socialInfo = false;

		$qCheck = sqlsrv_query($conn, "select * from Mem_Social where UserID = ? AND Type = ?", array($userid, $name), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			$socialInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC);

		}

		sqlsrv_free_stmt($qCheck);

		return $socialInfo;
	}

	public static function getUserInfo($userid) {

		// global $conn, $_config;

		// $qCheck = sqlsrv_query($conn, "select * from Mem_Account where UserID = ?", array($userid), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));
		$userInfo = MemAccount::where('UserID', $userid)->first();
		if(!empty($userInfo)) {
			return $userInfo;
		} else {
			return false;
		}
	}
	public static function getUserID($username) {

		global $conn, $_config;
		if($username == null) return $username;
		$qCheck = sqlsrv_query($conn, "select UserID from Mem_Account where Email = ?", array($username), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			$userInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC);

			sqlsrv_free_stmt($qCheck);

			return $userInfo['UserID'];

		} else {

			return null;

		}
	}
	
	public static function getUserInfoByField($userid, $field) {

		global $conn, $_config;

		$qCheck = sqlsrv_query($conn, "select $field from Mem_Account where UserID = ?", array($userid), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			$userInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC);

			sqlsrv_free_stmt($qCheck);

			return $userInfo[$field];

		} else {

			return false;

		}
	}
	
	public static function getFullname($userid) {

		global $conn, $_config;
		
		$fullname = 'Unknown';

		$qCheck = sqlsrv_query($conn, "select Email, Fullname from Mem_Account where UserID = ?", array($userid), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			$userInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC);
			
			if($userInfo['Fullname'] == null) {
				
				$fullname = $userInfo['Email'];
				
			} else {
				
				$fullname = $userInfo['Fullname'];
				
			}
		}
		
		sqlsrv_free_stmt($qCheck);
		
		return $fullname;
	}
	
	public static function getUserInfoByEmail($email) {

		global $conn, $_config;

		$qCheck = sqlsrv_query($conn, "select * from Mem_Account where Email = ?", array($email), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			$userInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC);

			sqlsrv_free_stmt($qCheck);

			return $userInfo;

		} else {

			return false;

		}
	}
	
	public static function getPlayerInfo($username) {

		global $conn_sv, $_config;

		$qCheck = sqlsrv_query($conn_sv, "select UserID, State, UserName, NickName, Money, Win from Sys_Users_Detail where UserName = ?", array($username), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			$userInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC);

			sqlsrv_free_stmt($qCheck);

			return $userInfo;

		} else {

			return false;

		}
	}
	
	public static function getPlayerInfoByUserID($userid) {

		global $conn_sv, $_config;

		$qCheck = sqlsrv_query($conn_sv, "select UserID, State, UserName, NickName, Money, Win from Sys_Users_Detail where UserID = ?", array($userid), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			$userInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC);

			sqlsrv_free_stmt($qCheck);

			return $userInfo;

		} else {

			return false;

		}
	}
	
	public static function getListPlayerInfo($username) {

		global $conn_sv, $_config;
		
		$listAccount = array();

		$qCheck = sqlsrv_query($conn_sv, "select UserID, State, UserName, NickName, Money, Win from Sys_Users_Detail where UserName = ? AND IsExist = ?", array($username, true), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));

		if(sqlsrv_num_rows($qCheck) > 0) {

			while($userInfo = sqlsrv_fetch_array($qCheck, SQLSRV_FETCH_ASSOC)) {
				
				$listAccount[] = $userInfo;
				
			}

			sqlsrv_free_stmt($qCheck);

		}
		
		return $listAccount;
	}

	public static function xuWarPlus($userid) {

		global $conn, $_config;

		$userInfo = self::getUserInfo($userid);

		$plusAdd = 0;

		if($userInfo['VIPLevel'] > 0) {
			$plusAdd = 100;
		}

		if($userInfo['Phone'] != null) {
			$plusAdd += 50;
		} else if($userInfo['Fullname'] != null) {
			$plusAdd += 30;
		}

		return $plusAdd;
	}

	public static function log($userid, $typeName, $typeCode, $content, $value) {

		// global $conn, $_config;

		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];

		// $qInsert = sqlsrv_query($conn, "insert into Mem_History (UserID, Type, TypeCode, Content, Value, TimeCreate, IPCreate) VALUES (?, ?, ?, ?, ?, ?, ?)", array($userid, $typeName, $typeCode, $content, $value, time(), self::getUserIP()));
		$entity = new MemHistory();
		// array($userid, $typeName, $typeCode, $content, $value, time(), self::getUserIP())
		$params = [
			'UserID' => $userid,
			'Type' => $typeName,
			'TypeCode' => $typeCode,
			'Content' => $content,
			'Value' => $value,
			'TimeCreate' => time(),
			'IPCreate' => self::getUserIP(),
		];
		
		$entity->fill($params);
		$entity->save();
		// if($qInsert)
		// 	sqlsrv_free_stmt($qInsert);
	}
	
	public static function logCard($userid, $nameCard, $serial, $passcard, $money, $type, $taskid) {

		// global $conn, $_config;

		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];

		$entity = new LogCard();
		// array($userid, $nameCard, $serial, $passcard, $money, time(), $type, $taskid)
		$params = [
			'UserID' => $userid,
			'Name' => $nameCard,
			'Serial' => $serial,
			'Passcard' => $passcard,
			'Money' => $money,
			'TimeCreate' => time(),
			'Type' => $type,
			'TaskId' => $taskid,
		];
		
		$entity->fill($params);
		$entity->save();

		// $qInsert = sqlsrv_query($conn, "insert into Log_Card (UserID, Name, Serial, Passcard, Money, TimeCreate, Type, TaskId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", array($userid, $nameCard, $serial, $passcard, $money, time(), $type, $taskid));
		// if($qInsert)
		// 	sqlsrv_free_stmt($qInsert);
	}
	
	public static function addCoin($userid, $money, $istotal = false) {
		
		// global $conn, $_config;
		
		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];
		
		// $addTotal = '';
		
		// if($istotal)
		// 	$addTotal = ',TotalMoney = TotalMoney + '.$money;
			
		// $qUpdate = sqlsrv_query($conn, "UPDATE Mem_Account SET Money = Money + ?, MoneyEvent = MoneyEvent + ? $addTotal WHERE UserID = ?", array($money, $money, $userid));

		MemAccount::where('UserID', $userid)->increment('Money', $money);
		MemAccount::where('UserID', $userid)->increment('MoneyEvent', $money);
		if($istotal)
			MemAccount::where('UserID', $userid)->increment('TotalMoney', $money);

		// if($qUpdate) {
			// sqlsrv_free_stmt($qUpdate);
			
			$userInfo = self::getUserInfo($userid);
			
			if($userInfo['TotalMoney'] >= 100000) {
				// buff VIPLevel
				self::updateInfo($userid, 'VIPLevel', 1);
			}
			return true;
		// }
		return false;
	}
	
	public static function removeCoin($userid, $money) {
		
		// global $conn, $_config;
		
		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];
		
		// $qUpdate = sqlsrv_query($conn, "UPDATE Mem_Account SET Money = Money - ? WHERE UserID = ?", array($money, $userid));
		MemAccount::where('UserID', $userid)->decrement('Money', $money);
		return true;
		// if($qUpdate) {
			
		// 	sqlsrv_free_stmt($qUpdate);
			
		// 	return true;
			
		// }
		// return false;
	}
	
	public static function removeMoney($userid, $field, $money) {
		
		global $conn, $_config;
		
		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];
		
		$qUpdate = sqlsrv_query($conn, "UPDATE Mem_Account SET $field = $field - ? WHERE UserID = ?", array($money, $userid));
		
		if($qUpdate) {
			
			sqlsrv_free_stmt($qUpdate);
			
			return true;
			
		}
		return false;
	}
	
	public static function addNumberField($userid, $field, $value) {
		
		// global $conn, $_config;
		
		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];
		
		// $qUpdate = sqlsrv_query($conn, "UPDATE Mem_Account SET $field = $field + ? WHERE UserID = ?", array($value, $userid));

		// $params = [$field => $value];
		MemAccount::where('UserID', $userid)->increment($field, $value);
		return true;
		// if($qUpdate) {
			
		// 	sqlsrv_free_stmt($qUpdate);
			
		// 	return true;
			
		// }
		// return false;
	}
	
	public static function getAmountReceived($curAmount) {
		
		$val = false;
		$column = [
			DB::raw("Receive * ((promo / 100) + 1) as Receive")
		];
		// $results = sqlsrv_query($conn,"SELECT Receive * ((promo / 100) + 1) as Receive FROM Config_Charge where Amount = ?", array($curAmount), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));
		$data = ConfigCharge::where("Amount", $curAmount)->first($column);
		if(!empty($data)) {
			$val = ($data['Receive']);
		}
		
		// sqlsrv_free_stmt($results);
		
		return $val;
	}
	
	public static function getChargeConfig() {
		
		global $conn;
		
		$val = false;
		
		$results = sqlsrv_query($conn,"SELECT * FROM Config_Charge", array(), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));
		if(sqlsrv_num_rows($results) > 0) {
			$dataReturn = [];
			while($data = sqlsrv_fetch_array($results, SQLSRV_FETCH_ASSOC)) {
				$dataReturn[] = $data;
			}
			$val = $dataReturn;
		}
		
		sqlsrv_free_stmt($results);
		
		return $val;
	}
	
	public static function updateInfo($userid, $field, $value) {
		
		// global $conn, $_config;
		
		// $qUpdate = sqlsrv_query($conn, "UPDATE Mem_Account SET $field = ? WHERE UserID = ?", array($value, $userid));
		$params = [$field => $value];
		MemAccount::where('UserID', $userid)->update($params);
	}

	public static function changePassword($userid, $newpassword) {

		global $conn, $_config;

		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];

		$qInsert = sqlsrv_query($conn, "update Mem_Account SET Password = ? WHERE UserID = ?", array($newpassword, $userid));

		if($qInsert)
			sqlsrv_free_stmt($qInsert);

	}
	
	public static function chargeMoney($playerInfo, $money) {
		
		global $conn_sv;
		
		$val = false;
		
		$results = sqlsrv_query($conn_sv,"SELECT COUNT(*) as total FROM Charge_Money", array(), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));
		if(sqlsrv_num_rows($results) > 0) {
			$data = sqlsrv_fetch_array($results, SQLSRV_FETCH_ASSOC);
			$ChargeID = md5($data['total']);
			
			$val = sqlsrv_query($conn_sv, "INSERT INTO Charge_Money
				([ChargeID]
				,[UserName]
				,[Money]
				,[CanUse]
				,[PayWay]
				,[NeedMoney]
				,[NickName])
			VALUES
				(?
				,?
				,?
				,?
				,?
				,?
				,?)", array($ChargeID, $playerInfo['UserName'], $money,1,0,0,$playerInfo['NickName']));
				
			
		}
		
		sqlsrv_free_stmt($results);
		
		return $val;
	}
	
	public static function sendMail($conn_sv, $playerid, $title, $content, $itemArray) {
		
		global $_config;
		
		$result = false;
		
		if(count($itemArray) > 0) {
			
			for($i = 0; $i < count($itemArray); $i += 5) {
				
				
				$mail =  new MailInfo(getDateTime('now'));
				$mail->Sender = "GameMaster";
				$mail->Title = $title;
				$mail->Content = $content;
				$mail->ReceiverID = $playerid;
				
				for($j = 0; $j < 5; $j++) {
					if($itemArray[$i + $j] != null) {
						switch($j) {
							case 0:
							$mail->Annex1 = $itemArray[$i + $j]->ItemID;
							break;
							case 1:
							$mail->Annex2 = $itemArray[$i + $j]->ItemID;
							break;
							case 2:
							$mail->Annex3 = $itemArray[$i + $j]->ItemID;
							break;
							case 3:
							$mail->Annex4 = $itemArray[$i + $j]->ItemID;
							break;
							case 4:
							$mail->Annex5 = $itemArray[$i + $j]->ItemID;
							break;
						}
					} else {
						break;
					}
				}
				
				$insertMail = sqlsrv_query($conn_sv, $mail->GetQuery(), $mail->GetValues(), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));
				
				if($insertMail)
					sqlsrv_free_stmt($insertMail);
			}
			$result = true;
		}
		
		return $result;
	}
	
	public static function addItemBag($userid, $serverid, $templateid, $count, $isbind, $vailddate, $ismerge) {
		
		global $conn, $_config;
		
		$isDone = false;
		
		$isSuccess = false;
		
		if($ismerge) {
			// find another item not sending
			$qFind = sqlsrv_query($conn, "select TOP 1 * from Mem_Bag WHERE UserID = ? AND IsBind = ? AND TemplateID = ? AND IsSend = ? AND ServerID IN (0, ?)", array($userid, $isbind, $templateid, false, $serverid), array("Scrollable" => SQLSRV_CURSOR_KEYSET));
			
			if(sqlsrv_num_rows($qFind) > 0) {
				// have another can merge
				$itemInfo = sqlsrv_fetch_array($qFind, SQLSRV_FETCH_ASSOC);
				
				$isSuccess = sqlsrv_query($conn, "update Mem_Bag SET Count = Count + ? WHERE ItemID = ?", array($count, $itemInfo['ItemID']), array("Scrollable" => SQLSRV_CURSOR_KEYSET));
				
				$isDone = true;
			}
		}
		
		if(!$ismerge || !$isDone) {
			$isSuccess = sqlsrv_query($conn, "INSERT INTO Mem_Bag (UserID, TemplateID, Count, StrengthenLevel, IsBind, VaildDate, IsSend, ServerID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", array($userid, $templateid, $count, 0, $isbind, $vailddate, false, $serverid));
		}
		
		return $isSuccess;
	}
	
	public static function getEventInfo($userid, $eventid, $serverid) {
		
		global $conn, $_config;
		
		$qFind = sqlsrv_query($conn, "select * from Mem_EventProcess WHERE UserID = ? AND EventID = ? AND ServerID = ?", array($userid, $eventid, $serverid), array("Scrollable" => SQLSRV_CURSOR_KEYSET));
			
		if(sqlsrv_num_rows($qFind) > 0) {
			
			return sqlsrv_fetch_array($qFind, SQLSRV_FETCH_ASSOC);
			
		}
		
		return false;
	}
	
	public static function createKeyLauncher($userid, $email) {
		
		global $conn, $_config;
		
		$key = md5(rand(0, 99999));
		
		// delete all old key
		$qDelete = sqlsrv_query($conn, "delete from Mem_Launcher where UserID = ? AND Email = ?", array($userid, $email));
		
		sqlsrv_free_stmt($qDelete);
		
		$qCreate = sqlsrv_query($conn, "insert into Mem_Launcher (UserID, Email, KeyVerify, TimeCreate) VALUES (?, ?, ?, ?)", array($userid, $email, $key, time()));
		
		sqlsrv_free_stmt($qCreate);
		
		return $key;
	}
	
	public static function getKeyLauncher($email, $key) {
		
		global $conn, $_config;
		
		$qFind = sqlsrv_query($conn, "select * from Mem_Launcher WHERE Email = ? AND KeyVerify = ?", array($email, $key), array("Scrollable" => SQLSRV_CURSOR_KEYSET));
			
		if(sqlsrv_num_rows($qFind) > 0) {
			
			return sqlsrv_fetch_array($qFind, SQLSRV_FETCH_ASSOC);
			
		}
		
		return false;
		
	}
	
	public static function updateCoinGame($userid, $serverid, $value, $isplus) {
		
		global $conn, $_config;
		
		$qFind = sqlsrv_query($conn, "select * from Mem_CoinGame WHERE UserID = ? AND ServerID = ?", array($userid, $serverid), array("Scrollable" => SQLSRV_CURSOR_KEYSET));
			
		if(sqlsrv_num_rows($qFind) > 0) {
			
			//return sqlsrv_fetch_array($qFind, SQLSRV_FETCH_ASSOC);
			
			// update
			if($isplus) {
				
				$plusAdd = "Value + ?";
				
			} else {
				
				$plusAdd = "Value - ?";
				
			}
			
			$qUp = sqlsrv_query($conn, "UPDATE Mem_CoinGame SET Value = $plusAdd WHERE UserID = ? AND ServerID = ?", array($value, $userid, $serverid));
			
		} else {
			
			$qAdd = sqlsrv_query($conn, "INSERT INTO Mem_CoinGame (UserID, ServerID, Value) VALUES (?, ?, ?)", array($userid, $serverid, $value));
			
		}
		
		return true;
	}
	
	public static function getCoinGame($userid, $serverid) {
		
		global $conn, $_config;
		
		$qFind = sqlsrv_query($conn, "select * from Mem_CoinGame WHERE UserID = ? AND ServerID = ?", array($userid, $serverid), array("Scrollable" => SQLSRV_CURSOR_KEYSET));
			
		if(sqlsrv_num_rows($qFind) > 0) {
			
			$cgInfo = sqlsrv_fetch_array($qFind, SQLSRV_FETCH_ASSOC);
			
			return $cgInfo['Value'];
		}
		
		return 0;
	}
	
	public static function logMomo($transid, $userid, $userName, $payAmount) {
		// global $conn, $_config;

		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];

		// $qInsert = sqlsrv_query($conn, "insert into Log_Momo (TransactionID, UserID, Username, Amount, TimeCreate) VALUES (?, ?, ?, ?, ?)", array($transid, $userid, $userName, $payAmount, time()));
		$entity = new LogMomo();
		// array($transid, $userid, $userName, $payAmount, time())
		$params = [
			'TransactionID' => $transid,
			'UserID' => $userid,
			'Username' => $userName,
			'Amount' => $payAmount,
			'TimeCreate' => time()
		];
		
		$entity->fill($params);
		$entity->save();
		// if($qInsert)
		// 	sqlsrv_free_stmt($qInsert);
	}
	
	public static function findMomoByTransId($transid, $userid = 0) {
		// global $conn, $_config;

		if($userid == 0)
			$userid = $_SESSION['ss_user_id'];

		// $qFind = sqlsrv_query($conn, "select TransactionID, TimeCreate, Username from Log_Momo where TransactionID = ?", array($transid), array("Scrollable" => SQLSRV_CURSOR_KEYSET));
		$columns = [
			'TransactionID',
			'TimeCreate',
			'Username'
		];
		$momoInfo = LogMomo::where('TransactionID', $transid)
							->first($columns);

		if(!empty($momoInfo)) {
			return $momoInfo;
		}
		
		return false;
	}
}
?>