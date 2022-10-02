<?php
require __DIR__.'/autoload.php';
use Models\MemAccount;
use Models\ServerList;
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Support\Str;


$token = explode("|", base64_decode($_POST['token']));
$input['username'] = $token[0];
$input['password'] = $token[1];
$input['new_password'] = $token[2];

$validator = $validator->make($input, [
	'username' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
	'password' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
    'new_password' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
]);

if ($validator->fails()) {
	die('0|Dữ liệu không hợp lệ');
}

$accountInfo = MemAccount::where('Email', $input['username'])
			->where('Password', strtoupper(md5($input['password'])))
			->first();

if(!empty($accountInfo)) {
    $accountInfo = MemAccount::where('Email', $input['username'])
			->where('Password', strtoupper(md5($input['password'])))
            ->update(['Password' => strtoupper(md5($input['new_password']))]);

    die('1|Đổi mật khẩu thành công');
}
die('0|Mật khẩu cũ không chính xác');
?>