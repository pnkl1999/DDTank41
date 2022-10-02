<?php
require __DIR__.'/autoload.php';
require __DIR__.'/class.account.php';
use Models\MemAccount;
use Models\ServerList;
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Support\Str;

$debug = false;
$validator = $validator->make($_POST, [
	'u' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
	'p' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
    'cardType' => 'required|min:1|max:10|regex:/^[a-z0-9\_\.@]{1,10}$/i',
    'passCard' => 'required|min:5|max:20|regex:/^[a-z0-9\_\.@]{5,20}$/i',
    'serial' => 'required|min:5|max:20|regex:/^[a-z0-9\_\.@]{5,20}$/i',
    'money' => 'required|min:1|max:20|regex:/^[0-9\_\.@]{1,20}$/i',
]);
if ($validator->fails()) {
	die('Dữ liệu không hợp lệ');
}

$userName = $_POST['u'];
$passWord = strtoupper(md5($_POST['p']));
$type = trim($_POST['cardType']);
$serial = trim($_POST['serial']);
$passcard = trim($_POST['passCard']);
$payAmount = intval($_POST['money']);
$accountInfo = MemAccount::where('Email', $userName)
			->where('Password', $passWord)
			->first();

if(!empty($accountInfo)) {
            
    $cardName = null;
    $TxtCard = '';
    $Telco = null;

    switch($type) {
        case 1:
            $cardName = 'Viettel';
            $TxtCard = 'VTT';
            $Telco = 'VIETTEL';
            break;
            
        case 2:
            $cardName = 'Mobifone';
            $TxtCard = 'VMS';
            $Telco = 'MOBIFONE';
            break;
            
        case 6:
            $cardName = 'Zing';
            $TxtCard = 'VNG';
            $Telco = 'ZING';
            break;
            
        case 3:
            $cardName = 'Vinaphone';
            $TxtCard = 'VNP';
            $Telco = 'VINAPHONE';
            break;
            
        case 5:
            $cardName = 'GATE';
            $TxtCard = 'FPT';
            $Telco = 'GATE';
            break;
            
            
        // case 8:
            // $cardName = 'Vcoin';
            // $TxtCard = '';
            // $Telco = '';
            // break;
            
        // case 11:
            // $cardName = 'Vietnamobile';
            // $TxtCard = '';
            // $Telco = '';
            // break;
    }

    // if($_SESSION['ss_user_email'] == 'khanhlam' || $debug) {//debug
        // $account = new account();
        // $return['type'] = -1958;
        // $return['content'] = $account->getAmountReceived(intval($payAmount));
        // $return['content2'] = $payAmount;
        // echo json_encode($return);
        // die();
    // }
    $account = new account();
    $coinhave = $account->getAmountReceived(intval($payAmount));
    if(!$coinhave) {
        // $return['type'] = -1958;
        die('Mệnh giá không hợp lệ vui lòng chọn mệnh giá khác!');
    } else
    if($Telco != null) {
        $request_id = rand(100000000, 999999999);  //Mã đơn hàng của bạn
        $command = 'charging';  // Nap the
        $url = 'https://thesieure.com/chargingws/v2';
        $partner_id = PartnerIDTheSieuRe;//'5715317261';
        $partner_key = PartnerKeyTheSieuRe;//'3edba7a8497cda6af1b735e18ad8d5c2';
        
        // $result = Connect::init($passcard,$serial,$payAmount, $type);
        
        $dataPost = array();
        $dataPost['request_id'] = $request_id;
        $dataPost['code'] = $passcard;
        $dataPost['partner_id'] = $partner_id;
        $dataPost['serial'] = $serial;
        $dataPost['telco'] = $Telco;
        $dataPost['command'] = $command;
        ksort($dataPost);
        $sign = $partner_key;
        foreach ($dataPost as $item) {
            $sign .= $item;
        }
        
        $mysign = md5($sign);

        $dataPost['amount'] = $payAmount;
        $dataPost['sign'] = $mysign;

        $data = http_build_query($dataPost);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        $actual_link = (isset($_SERVER['HTTPS']) ? "https" : "http") . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
        curl_setopt($ch, CURLOPT_REFERER, $actual_link);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);

        $result = curl_exec($ch);
        curl_close($ch);

        $obj = json_decode($result);

        if($debug) {
            $obj = array('request_id'=>69,'status'=>99);
            $obj = (object) $obj;
        }
        $errorMessage = array(
            'INPUT_DATA_INCORRECT' => 'Dữ liệu không hợp lệ'
        );
        if ($obj->status == 99) {
            //Gửi thẻ thành công, đợi duyệt.
            
            $account = new account();
            
            $account->logCard($accountInfo['UserID'], $Telco, $serial, $passcard, 0, 0, $obj->request_id);
            // $return['type'] = -115;
            die("Thẻ này đã được gửi qua Nạp Chậm bạn vui lòng đợi 30s-1p nếu thẻ đúng sẽ có tiền trong tài khoản nhé");
        } elseif ($obj->status == 1) {
            //Thành công
            $account = new account();
            
            $account->logCard($accountInfo['UserID'], $Telco, $serial, $passcard, $obj->value, 1, $obj->request_id);
            
            $menhgia = intval($obj->value);
            // khuyen mai or gi do
            // $coinhave = intval($obj->value) * 1; // day la coin goc nap 1 dc 1
            
            // chuyen tien vao tai khoan
            $canAdd = $account->addCoin($accountInfo['UserID'], $coinhave, true);
            
            if($canAdd) {
                $account->log($accountInfo['UserID'], 'Nạp thẻ', 2, 'Nạp thẻ '.$cardName.' mệnh giá '.number_format($menhgia).'VNĐ', $coinhave);
                
                //$account->addNumberField($accountInfo['UserID'], "MoneyLock", $coinhave); // day la coin khuyen mai. khong thich them thi bo ntn
                $account->addNumberField($accountInfo['UserID'], "VIPExp", $menhgia / 1000);
                
                $userInfo = $account->getUserInfo($accountInfo['UserID']);
                
                $account->updateInfo($accountInfo['UserID'], "VIPLevel", getVIPLevel($userInfo['VIPExp']));
                
                die('Nạp thành công thẻ cào mệnh giá '.number_format($menhgia).'VNĐ. Bạn nhận được '.number_format($coinhave).'Coin.');
            
            } else {
                die('LỖI. Liên hệ GM để được trợ giúp.');
            }
            // Những loại thẻ được xử lý ngay Zing, Garena, Gate, Vcoin
        } elseif ($obj->status == 2) {
            //Thành công nhưng sai mệnh giá
            $account = new account();
            
            $account->logCard($accountInfo['UserID'], $Telco, $serial, $passcard, $obj->value, 1, $obj->request_id);
            
            $menhgia = intval($obj->value);
            // khuyen mai or gi do
            // $coinhave = intval($obj->value) * 1; // day la coin goc nap 1 dc 1
            $coinhave = $account->getAmountReceived(intval($menhgia));//lay config tu db
            
            // chuyen tien vao tai khoan
            $canAdd = $account->addCoin($accountInfo['UserID'], $coinhave, true);
            
            if($canAdd) {
                $account->log($accountInfo['UserID'], 'Nạp thẻ', 2, 'Nạp thẻ '.$cardName.' mệnh giá '.number_format($menhgia).'VNĐ', $coinhave);
                
                //$account->addNumberField($accountInfo['UserID'], "MoneyLock", $coinhave); // day la coin khuyen mai. khong thich them thi bo ntn
                $account->addNumberField($accountInfo['UserID'], "VIPExp", $menhgia / 1000);
                
                $userInfo = $account->getUserInfo($accountInfo['UserID']);
                
                $account->updateInfo($accountInfo['UserID'], "VIPLevel", getVIPLevel($userInfo['VIPExp']));
                
                die('Nạp thành công thẻ cào mệnh giá '.number_format($menhgia).'VNĐ. Bạn nhận được '.number_format($coinhave).'Coin.');
            
            } else {
                die('LỖI. Liên hệ GM để được trợ giúp.');
            }
        } elseif ($obj->status == 3) {
            //Thẻ lỗi
            die($obj->message);
        } elseif ($obj->status == 4) {
            //Bảo trì
            die('LỖI. Hệ thống nạp bảo trì!');
        } else {
            //Lỗi
            die(isset($errorMessage[$obj->message]) ? $errorMessage[$obj->message] : $obj->message);
        }
    } else {
       die('Loại thẻ cào này chưa hỗ trợ');
    }

} else {
	die('Tài khoản hoặc mật khẩu không đúng');
}
?>