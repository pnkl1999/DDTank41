<?php
require __DIR__.'/autoload.php';
use Models\MemAccount;
// use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
//1|vinhkosd|71B1ABB01462F7C3DF4E06FF9E49F119
//return type code|user|pass_md5
/*
output:
	*code 1 -> success
	*input user
	*md5 pass
input:
	["user"] = user,
	["pass"] = pass,
*/
// var_dump($_POST);
// echo json_encode(MemAccount::first());


$validator = $validator->make($_POST, [
	'u' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
	'p' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
]);

if ($validator->fails()) {
	die('Tài khoản hoặc mật khẩu không hợp lệ');
}

$userName = $_POST['u'];
$passWord = strtoupper(md5($_POST['p']));

$accountInfo = MemAccount::where('Email', $userName)
			->where('Password', $passWord)
			->first();
if(!empty($accountInfo)) {
	die($accountInfo['VipLevel'] . ':' . $accountInfo['Money']);
} else {
	die('Tài khoản hoặc mật khẩu không đúng');
}
?>