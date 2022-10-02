<?php
require __DIR__.'/autoload.php';
require __DIR__.'/function.soap.php';
require __DIR__.'/class.account.php';
use Models\MemAccount;
use Models\ServerList;
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Support\Str;

$validator = $validator->make($_POST, [
	'u' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
	'p' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
    'userId' => 'required|min:1|max:10|regex:/^[0-9]{1,10}$/i',
    'areaId' => 'required|min:1|max:10|regex:/^[0-9]{1,10}$/i',
    'cash' => 'required|min:1|max:10|regex:/^[0-9]{1,10}$/i',
    'bagpass' => 'min:1|max:10|regex:/^[a-z0-9\_\.@]{1,10}$/i',
]);

if ($validator->fails()) {
    $failedRules = $validator->failed();
	// die('Dữ liệu không hợp lệ'.json_encode($_POST).json_encode($failedRules));
    die('Dữ liệu không hợp lệ');
}
// die(json_encode($_POST));
$userName = $_POST['u'];
$passWord = strtoupper(md5($_POST['p']));
$serverId = $_POST['areaId'];
$userId = $_POST['userId'];
$coin = intval($_POST['cash']);

$accountInfo = MemAccount::where('Email', $userName)
			->where('Password', $passWord)
			->first();

if(!empty($accountInfo)) {
    $serverInfo = ServerList::where('ServerID', $serverId)->first();


    if(empty($serverInfo))
        die('Máy chủ không hoạt động, vui lòng chọn máy chủ khác');

    $connectionInfo = array("Database" => $serverInfo['Database'], "UID" => $serverInfo['Username'], "PWD" => $serverInfo['Password'], "CharacterSet" => "UTF-8");

    $conn_sv = sqlsrv_connect($serverInfo['Host'], $connectionInfo);
    $dataReturn = [];
    if($conn_sv) {//have connection
		// check money
        $account = new account();
		
		if($coin <= $accountInfo['Money']) {
			// du tien
			// kiem tra xem co nhan vat hay khong
			$playerInfo = $account->getPlayerInfoByUserID($userId);
			
			if($playerInfo != false) {
				if($playerInfo['State'] == 1 || !CheckOnlineChuyenXu) {
					// co nhan vat => remove money
					$removeMoney = $account->removeCoin($accountInfo['UserID'], $coin);
					if($removeMoney) {
						
						$xuhave = $coin * ConfigXu;
						
						$account->log($accountInfo['UserID'], 'Chuyển Xu', 3, 'Chuyển '.number_format($xuhave).' Xu vào máy chủ '.$serverInfo['ServerName'], -$coin);
						
						// remove money thanh cong => chuyen xu
						$result = $account->chargeMoney($playerInfo, $xuhave);

						if($result != false) {
							// notice
							if($playerInfo['State'] == 1) {
								$noticeResult = soapChargeMoney($serverId, $playerInfo['UserID'], $result);
							}
							die("Chuyển Xu thành công. Bạn nhận được ".number_format($xuhave)." Xu vào máy chủ " . $serverInfo['ServerName'] . ".");
						} else {
							die('Lỗi hệ thống. Liên hệ GM để được hỗ trợ. CRE');
						}
					} else {
						die('Lỗi hệ thống. Liên hệ GM để được hỗ trợ.');
					}
				} else {
					die('Vui lòng vào game rồi chuyển để tránh mất mát');
				}
			} else {
				die('Vui lòng tạo nhân vật để sử dụng dịch vụ..');
			}
		} else {
			die('Số dư không đủ. Không thể thực hiện giao dịch.');
		}
        sqlsrv_close($conn_sv);
    } else {
        die('Máy chủ không hoạt động, vui lòng chọn máy chủ khác');
    }
} else {
	die('Tài khoản hoặc mật khẩu không đúng');
}
?>