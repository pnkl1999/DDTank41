<?php
require __DIR__.'/autoload.php';
use Models\MemAccount;
use Models\LogCard;
use Illuminate\Database\Capsule\Manager as DB;
use Illuminate\Support\Str;
use Carbon\Carbon;
header('Content-Type: application/json');

$validator = $validator->make($_POST, [
	'u' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
	'p' => 'required|min:4|max:20|regex:/^[a-z0-9\_\.@]{4,20}$/i',
    'page' => 'required|min:1|max:10|regex:/^[0-9]{1,10}$/i',
]);

if ($validator->fails()) {
    die('Dữ liệu không hợp lệ');
}

$userName = $_POST['u'];
$passWord = strtoupper(md5($_POST['p']));
$page = $_POST['page'];

$accountInfo = MemAccount::where('Email', $userName)
			->where('Password', $passWord)
			->first();

if(!empty($accountInfo)) {
    $query = LogCard::query();
    $columns = [
        'ID',
        'UserID',
        DB::raw('Name as NameCard'),
        'Serial',
        DB::raw('Passcard as CodeCard'),
        DB::raw('Money as ValueCard'),
        DB::raw('Type as Status'),
        'TimeCreate',
    ];
    $query->where('UserID', $accountInfo['UserID']);
    $returnData = getPartial($query, 12, $page, $columns);
    foreach($returnData['Data'] as $data) {
        $data['TimeCreate'] = Carbon::createFromTimestamp($data['TimeCreate']);
    }
    echo json_encode($returnData);
} else {
	die('Tài khoản hoặc mật khẩu không đúng');
}