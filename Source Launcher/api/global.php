<?php
use Illuminate\Database\Capsule\Manager as DB;

$capsule = new DB;
$capsule->addConnection([
    'driver'    => DB_CONNECTION,
    'host'      => DB_HOST,
    'database'  => DB_DATABASE,
    'username'  => DB_USERNAME,
    'password'  => DB_PASSWORD,
    'charset'   => 'utf8',
    'collation' => 'utf8_unicode_ci',
    'prefix'    => '',
], "default");

// $capsule->addConnection([
    // 'driver'    => DB_CONNECTION_GLOBAL,
    // 'host'      => DB_HOST_GLOBAL,
    // 'port'      => DB_PORT_GLOBAL,
    // 'database'  => DB_DATABASE_GLOBAL,
    // 'username'  => DB_USERNAME_GLOBAL,
    // 'password'  => DB_PASSWORD_GLOBAL,
    // 'charset'   => 'utf8',
    // 'collation' => 'utf8_unicode_ci',
    // 'prefix'    => '',
// ], "global");

// $capsule->addConnection([
    // 'driver'    => DB_CONNECTION_GAME,
    // 'host'      => DB_HOST_GAME,
    // 'port'      => DB_PORT_GAME,
    // 'database'  => DB_DATABASE_GAME,
    // 'username'  => DB_USERNAME_GAME,
    // 'password'  => DB_PASSWORD_GAME,
    // 'charset'   => 'utf8',
    // 'collation' => 'utf8_unicode_ci',
    // 'prefix'    => '',
// ], "game");
// Set the event dispatcher used by Eloquent models... (optional)
use Illuminate\Events\Dispatcher;
use Illuminate\Container\Container;
$capsule->setEventDispatcher(new Dispatcher(new Container));

// Make this DB instance available globally via static methods... (optional)
$capsule->setAsGlobal();

// Setup the Eloquent ORM... (optional; unless you've used setEventDispatcher())
$capsule->bootEloquent();
// $users = DB::table('gm_users')->first();
$filesystem = new Illuminate\Filesystem\Filesystem();
$fileLoader = new Illuminate\Translation\FileLoader($filesystem, '');
$translator = new Illuminate\Translation\Translator($fileLoader, 'en_US');
$validator = new Illuminate\Validation\Factory($translator);

function arrayToXml(array $arr, SimpleXMLElement $xml)
{
    foreach ($arr as $k => $v) {
        if(is_array($v)){
            arrayToXml($v, $xml->addChild($k));
        } else {
            $xml->addChild($k, $v);
            $xml->addAttribute($k, $v);
        }
    }
    return $xml;
}

function convertViToEn($str)
{
    $str = preg_replace("/(à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ)/", "a", $str);
    $str = preg_replace("/(è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ)/", "e", $str);
    $str = preg_replace("/(ì|í|ị|ỉ|ĩ)/", "i", $str);
    $str = preg_replace("/(ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ)/", "o", $str);
    $str = preg_replace("/(ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ)/", "u", $str);
    $str = preg_replace("/(ỳ|ý|ỵ|ỷ|ỹ)/", "y", $str);
    $str = preg_replace("/(đ)/", "d", $str);
    $str = preg_replace("/(À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ)/", "A", $str);
    $str = preg_replace("/(È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ)/", "E", $str);
    $str = preg_replace("/(Ì|Í|Ị|Ỉ|Ĩ)/", "I", $str);
    $str = preg_replace("/(Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ)/", "O", $str);
    $str = preg_replace("/(Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ)/", "U", $str);
    $str = preg_replace("/(Ỳ|Ý|Ỵ|Ỷ|Ỹ)/", "Y", $str);
    $str = preg_replace("/(Đ)/", "D", $str);
    $str = preg_replace("/\s/", "", $str);

    return $str;
}

function Guid()
{
    if (function_exists('com_create_guid') === true)
    {
        return trim(com_create_guid(), '{}');
    }

    return sprintf('%04X%04X-%04X-%04X-%04X-%04X%04X%04X', mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(16384, 20479), mt_rand(32768, 49151), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535));
}

function getVIPLevel($exp) {
	if($exp >= 4000)
		return 8;
	else if($exp >= 3000)
		return 7;
	else if($exp >= 2000)
		return 6;
	else if($exp >= 1500)
		return 5;
	else if($exp >= 1000)
		return 4;
	else if($exp >= 500)
		return 3;
	else if($exp >= 200)
		return 2;
	else if($exp >= 100)
		return 1;
	else
		return 0;
}

function getPartial($queryData = [], $limit = 100, $page = 1, $columns = [])
    {
        $data = [];
        $offset = ($page - 1) * $limit;
        $totalRecord = $queryData->count();

        if ($totalRecord) {
            $totalPage = ($totalRecord % $limit == 0) ? $totalRecord / $limit : ceil($totalRecord / $limit);

            $data = $queryData->offset($offset)
                ->limit($limit);
            if ($columns) $data = $data->get($columns);
            else $data = $data->get();
        } else {
            $totalPage = 0;
            $page = 0;
            $totalRecord = 0;
        }

        $result = [
            'TotalRecord'   => $totalRecord,
            'Data'          => $data,
        ];

        return $result;
    }
?>