<?php
require __DIR__.'/autoload.php';
require __DIR__.'/class.account.php';
use Models\MemAccount;
use Models\ServerList;
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Support\Str;

$isDebug = false;
$validator = $validator->make($_POST, [
	'u' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
	'p' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
    'tranId' => 'required|min:1|max:25|regex:/^[0-9\_\.@]{1,25}$/i',
]);
if ($validator->fails()) {
	die('Dữ liệu không hợp lệ');
}

$userName = $_POST['u'];
$passWord = strtoupper(md5($_POST['p']));

$startTime = '28-08-2021 00:00:00';//thời điểm bắt đầu lấy giao dịch

$d = DateTime::createFromFormat('d-m-Y H:i:s', $startTime);
if ($d === false) {
    die("Incorrect date string");
} else {
    $startTimeStamp = $d->getTimestamp() * 1000;
}
$tranId = trim($_POST['tranId']);

$accountInfo = MemAccount::where('Email', $userName)
			->where('Password', $passWord)
			->first();

if(!empty($accountInfo)) {
    $account = new account();

    if($momoInfo = $account->findMomoByTransId($tranId, $accountInfo['UserID'])) {
        die('Mã giao dịch đã được nạp vào '.date('H:i:s m/d/Y', $momoInfo['TimeCreate']).' bằng tài khoản : '.$momoInfo['Username'].'.');
    }
    
    if(MOMO_API_KEY) {
        $url = 'https://luthebao.com/api/apimomo/get?key=' . MOMO_API_KEY . '&days=5';
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        $actual_link = (isset($_SERVER['HTTPS']) ? "https" : "http") . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
        curl_setopt($ch, CURLOPT_REFERER, $actual_link);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
    
        $result = curl_exec($ch);
        if($result === false)
        {
            echo 'Không thể kết nối đến máy chủ giao dịch Momo, vui lòng truy cập lại sau hoặc liên hệ GM';
            die();
        }
        curl_close($ch);
        $jsonData = json_decode($result, true);
        if(!$jsonData['stt']) {       
            die('Hệ thống đang bảo trì, vui lòng thử sau ít phút!');
        } else {
            if($jsonData['msg'] == 'Lỗi 106: Request quá nhanh.'){
                die('Hệ thống tải quá nhiều yêu cầu. Vui lòng thử lại sau vài giây!');
            } else 
            if(count($jsonData['data']['tranList']) > 0) {
                $tranList = $jsonData['data']['tranList'];
                $foundTransaction = false;
                foreach($tranList as $transaction){
                    if($transaction['tranId'] == $tranId && $transaction['io'] == 1) {//tìm thấy giao dịch
                        $foundTransaction = true;	
                        if($transaction['finishTime'] < $startTimeStamp && !$isDebug) {
                            die('Thời gian giao dịch không còn khả dụng!');
                        } else if(strtolower($transaction['comment']) == strtolower($accountInfo['Email']) || $isDebug) { //tên đăng nhập khớp với nội dung giao dịch
                            $payAmount = $transaction['amount'];
                            $coinhave = intval(floor($payAmount * ($account->getAmountReceived(10000)/ 10000)));// lấy tỉ lệ từ ConfigCharge
                            
                            $canAdd = $account->addCoin($accountInfo['UserID'], $coinhave, true);
                            $account->logMomo($transaction['tranId'], $accountInfo['UserID'], $accountInfo['Email'], $payAmount);
                            if($canAdd) {
                                $account->log($accountInfo['UserID'], 'Nạp thẻ', 2, 'Nạp '.number_format($payAmount).'VNĐ Momo', $coinhave);
                                
                                $account->addNumberField($accountInfo['UserID'], "VIPExp", $payAmount / 1000);
                                
                                $userInfo = $account->getUserInfo($accountInfo['UserID']);
                                
                                $account->updateInfo($accountInfo['UserID'], "VIPLevel", getVIPLevel($userInfo['VIPExp']));
                                
                                die('Nạp '.number_format($payAmount).' VNĐ Momo Thành công. Bạn nhận được '.number_format($coinhave).'Coin.');
                            } else {
                                echo 'LỖI. Liên hệ GM để được trợ giúp.';
                            }
                            break;
                        } else {
                            echo 'Nội dung chuyển tiền không khớp tên tài khoản!';
                        }
                    }
                }
                if(!$foundTransaction) {
                    echo 'Không tìm thấy giao dịch!';
                }
            } else {
                echo 'Không tìm thấy giao dịch!';
            }
        }
    }
} else {
	die('Tài khoản hoặc mật khẩu không đúng');
}
?>