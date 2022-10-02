<?php
require __DIR__.'/autoload.php';
use Models\MemAccount;
use Models\ServerList;
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Support\Str;

$validator = $validator->make($_POST, [
	'u' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
	'p' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
    'srv' => 'required|min:1|max:10|regex:/^[0-9]{1,10}$/i',
]);

if ($validator->fails()) {
	die('Dữ liệu không hợp lệ');
}

$userName = $_POST['u'];
$passWord = strtoupper(md5($_POST['p']));
$serverId = $_POST['srv'];

$accountInfo = MemAccount::where('Email', $userName)
			->where('Password', $passWord)
			->first();

if(!empty($accountInfo)) {
    $serverInfo = ServerList::where('ServerID', $serverId)->first();


    if(empty($serverInfo))
        die('Máy chủ không hoạt động, vui lòng chọn máy chủ khác');

    $keyrand = (string)Str::uuid();

    $timeNow = time();

    $content = file_get_contents($serverInfo['LinkRequest']."CreateLogin.aspx?content=".$userName."|".strtoupper($keyrand)."|".$timeNow."|".md5($userName.strtoupper($keyrand).$timeNow.KEY_REQUEST));


    if(trim($content) != "0") {
        die("Mã lỗi đăng nhập: ".$content);
    }
    die($serverInfo['LinkFlash']."Loading.swf?user=$userName&key=$keyrand&v=104&rand=92386938&config=".$serverInfo['LinkConfig']);
} else {
	die('Tài khoản hoặc mật khẩu không đúng');
}
?>