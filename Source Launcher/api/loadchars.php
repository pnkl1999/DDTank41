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

    $connectionInfo = array("Database" => $serverInfo['Database'], "UID" => $serverInfo['Username'], "PWD" => $serverInfo['Password'], "CharacterSet" => "UTF-8");

    $conn_road = sqlsrv_connect($serverInfo['Host'], $connectionInfo);
    $dataReturn = [];
    if($conn_road) {//have connection
        $getListNickName = sqlsrv_query($conn_road, "select UserID, NickName from Sys_Users_Detail where IsExist = 1 and UserName = ?", array($userName), array( "Scrollable" => SQLSRV_CURSOR_KEYSET));
        
        if(sqlsrv_num_rows($getListNickName) > 0) {
            $index = 0;
            while($accountInfo = sqlsrv_fetch_array($getListNickName, SQLSRV_FETCH_ASSOC)) {
                $dataReturn[] = implode(';', array_merge(['index' => $index], $accountInfo));
                $index++;
                // echo json_encode($accountInfo);
            }
        }
        die(implode('|', $dataReturn));
    } else {
        die();
    }
    
} else {
	die('Tài khoản hoặc mật khẩu không đúng');
}
?>