<?php
require __DIR__.'/autoload.php';
require __DIR__.'/class.account.php';
use Models\MemAccount;
use Models\ServerList;
use Illuminate\Database\Capsule\Manager as DB;

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
	$column = [
		DB::raw('ServerID as ID'),
		DB::raw('ServerName as Name'),
	];
	$serverList = ServerList::where('IsActive', 1)->get($column);
	$serverList = $serverList->keyBy(function ($item) {
		return convertViToEn($item['Name']);
	});

	$returnXml = array (
		'Play' => (json_decode(json_encode($serverList), true)),
		'List' => (json_decode(json_encode($serverList), true)),
		'Config' => [
			'ConfigXu' => [
				'ConfigXu' => ConfigXu
			],
			'SuportUrl' => [
				'SuportUrl' => SupportUrl
			],
			'SiteName' => [
				'SiteName' => SiteName
			],
			'Version' => [
				'Version' => VersionLauncher
			],
			'MOMO_ACCOUNT_NAME' => [
				'MOMO_ACCOUNT_NAME' => MOMO_ACCOUNT_NAME
			],
			'MOMO_PHONE_NUMBER' => [
				'MOMO_PHONE_NUMBER' => MOMO_PHONE_NUMBER
			],
		],
	);
	
	$xmlElement = new SimpleXMLElement('<Result/>');
	$xmlElement->addAttribute('status', 'true');
	$xmlElement->addAttribute('message', 'Đăng nhập thành công');
	echo arrayToXml($returnXml, $xmlElement)->asXML();
} else {
	die('Tài khoản hoặc mật khẩu không đúng');
}
?>