<?php
require __DIR__.'/autoload.php';
use Models\MemAccount;
use Models\ServerList;
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Support\Str;


$token = explode("|", base64_decode($_POST['token']));
$input['username'] = $token[0];
$input['password'] = $token[1];
$input['phone'] = $token[2];
$input['ip'] = $token[4];
$validator = $validator->make($input, [
	'username' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
	'password' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
    'phone' => 'required|min:1|max:11|regex:/^[0-9]{1,11}$/i',
    'ip' => 'required|min:1|max:20|regex:/^[a-z0-9\_\.@]{1,20}$/i',
]);

if ($validator->fails()) {
	die('0|Dữ liệu không hợp lệ');
}

$accountInfo = MemAccount::where('Email', $input['username'])->first();

if(empty($accountInfo)) {
    $accountByPhone = MemAccount::where('Phone', $input['phone'])->first();
    if(!empty($accountByPhone)) {
        die('0|Số điện thoại đã tồn tại');
    }
    $entity = new MemAccount();

    $params = [
        'Email' => $input['username'],
        'Password' => strtoupper(md5($input['password'])),
        'Money' => 0,
        'Phone' => $input['phone'],
        'TimeCreate' => time(),
        'IPCreate' => $input['ip'],
        'MoneyLock' => 0,
    ];
    
    $entity->fill($params);
    $entity->save();

    die('1|Đăng ký thành công');
}
die('0|Tài khoản đã tồn tại, vui lòng đăng ký tài khoản khác');
?>