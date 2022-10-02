<?php
require __DIR__.'/autoload.php';
use Models\MemAccount;
use Models\ServerList;
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Support\Str;


$validator = $validator->make($_POST, [
	'u' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
    'phone' => 'required|min:1|max:11|regex:/^[0-9]{1,11}$/i',
    'ip' => 'required|min:1|max:20|regex:/^[a-z0-9\_\.@]{1,20}$/i',
]);

if ($validator->fails()) {
	die('0|Dữ liệu không hợp lệ');
}

$accountInfo = MemAccount::where('Email', $_POST['u'])
                ->where('Phone', $_POST['phone'])
                ->first();

if(!empty($accountInfo)) {
    MemAccount::where('Email', $_POST['u'])
                ->where('Phone', $_POST['phone'])
                ->update(['Password'=> strtoupper(md5('123456'))]);//update password về 123456
    die('1|Mật khẩu mới của bạn là 123456');
}

die('0|Không tìm thấy tài khoản hoặc số điện thoại không đúng');
?>