<?
if (empty($uri[2])) exit;

if ($uri[1] == "e") {
	$uri[2] = $uri[3];
	$uri[3] = $uri[4];
}

ob_implicit_flush(true);

set_time_limit(180);

ini_set('default_charset', 'UTF8');
header('Content-type: text/html; charset=utf-8');
header('Access-Control-Allow-Origin: *');
//$tpl = 'multi/v2viewer/index';

// member exist check 20140602 add by nkdk
$indb = new ovDB($_CFG['db'][0],true);
$exist_mem = $indb->getone('SELECT mem_index FROM member WHERE mem_id = ?', $uri[2]);
if (is_null($exist_mem)) {
        header('HTTP/1.x 404 Not Found');
        $site->display('bookstore/v2viewer/nobook.tpl');
        exit;
}

$lib =& ovMods::load('multi', '', array('memberid' => $uri[2], 'noinit' => true));
if ($lib->loaded == false) {
	header("Location: {$lib->monfig['url_html5viewer']}info/nobook/");
	exit;
}


$author = new ovMember($_CFG['db'][0], false);
$author->load($uri[2]);
if (!$author->loaded) {
	header("Location: {$lib->monfig['url_html5viewer']}info/nobook/");
	exit;
}


$bookid = !empty($_GET) ? key($_GET) : (string)$lib->info->books['read'];
if (count($argv)) $bookid = $uri[3];
$book =& $lib->get_book($bookid, 'bookid');

if ($book === false) {
	header("Location: {$lib->monfig['url_html5viewer']}info/nobook/");
	exit;
}
if (is_null($book->memberid)) {
	@header('HTTP/1.x 404 Not Found');
        $site->display('bookstore/v2viewer/nobook.tpl');
	exit;
}

if ($uri[3] == $lib->monfig['path_data_name'] && !is_file($book->path.implode('/', array_slice($uri, 5)))) {
	@header('HTTP/1.x 404 Not Found');
        $site->display('bookstore/v2viewer/nobook.tpl');
	exit;
}
elseif (empty($argv) && $uri[3] != '') {

	header("Location: {$lib->monfig['url_html5viewer']}info/nobook/");
	exit;
}

if((string)$book->info->config['hs_type'] == ''){
	_a($book->info->config, 'hs_date', date("Y/m/d H:i:s"));
	_a($book->info->config, 'hs_type', '2');
	_a($book->info->config, 'hs_key', random_int_id(4));
	//$httpxml = $lib->info->xpath('//books/book[@id = "'.$bookid.'"]');
	//_a($httpxml[0], 'hs_type', $r['value']['hs_type']);
	$book->save();
	//$lib->save();
	$lib->db_save($book->id, array('hs_type' => 2));
}

if (is_file($book->path.$book->monfig['file_contents'])) {
	if ($_CFG['global']['seo']) $site->assign('sitemap', $book->monfig['url_delivery'].$book->monfig['url_base'].'sitemap/'.$book->memberid.'/');
	$site->assign('contents', $book->monfig['path_data_name'].'/'.(string)$book->info_lib['path'].'/'.$book->monfig['file_contents']);
}

$site->assign_by_ref('book', $book);

/*
if (empty($argv) && $member) {

	if ($member->info['superid'] == $book->memberid) {
	}
	elseif ($member->info['staff_level'] != 4) {
		if((int)$book->info->config['hs_type'] == 3){
			header("Location: {$lib->monfig['url_html5viewer']}info/hsstop/");
			exit;
		}else{
			if((int)$book->info->config['hs_type'] == 1){
				if (isset($_POST['login']) || isset($_POST['login_x'])) {
					$r = $site->verify('v2login', $_POST);
					if (!$r['ok']) {
						header("Location: {$lib->monfig['url_html5viewer']}info/login/{$bookid}/{$uri[2]}/err_none/");
						exit;
					}else{
						if((string)$book->info->config['hs_key'] == $r['value']['key'] || $r['value']['key'] == $book->monfig['hs_superkey']){
							$created = (string)$book->info->date;
							$d = _date_diff('d', $created, time());
							if ((int)$book->info_lib['publish'] == 0 && $d < -7) {
								header("Location: {$lib->monfig['url_html5viewer']}info/");
								exit;
							}else{
							}
						}else{
							header("Location: {$lib->monfig['url_html5viewer']}info/login/{$bookid}/{$uri[2]}/err_key/");
							exit;
						}
					}
				}else{
					header("Location: {$lib->monfig['url_html5viewer']}info/login/{$bookid}/{$uri[2]}/");
					exit;
				}
			}
		}
	}
}
*/

$plan =& ovMods::load('plan', $_CFG['db'][0]);
$plan->get_info($author);

if ($author->info['plan']['plan'] == $plan->monfig['default'] && (int)$book->info->config['logo'] == 0) {
	_a($book->info->config, 'logo', 1);
	$book->save(false);
} elseif ($author->info['plan']['plan'] != $plan->monfig['default'] && (int)$book->info->config['logo'] == 1) {
	_a($book->info->config, 'logo', 0);
	$book->save(false);
}

if(!empty($argv) && $uri[4]=="nolog")
	$site->assign('nolog',1);
	
if($author->info['plan']['html5_flag'] <= 0) {
	header("Location: {$lib->monfig['url_html5viewer']}info/nobook/");
	exit;
}

$viewData = array(
	'logurl'  		=> '',
	'referer' 		=> $_SERVER['HTTP_REFERER'],
	'html5Viewhost'	=> HTTP_HOST.'/'.$url[1].'/',
	'tocHost'		=> ($_CFG['global']['force_ssl'] ? 'https://' : 'http://').$_CFG['hosts_bshelf']['bookshelf_url'].'/bookstore/h5/',
	'printUrlFlag'  => $printUrlFlag
);

// multi ling check start
$chk_multiling = $book->info->config['multilingual'];
$sel_multiling = $book->info->config['selmultilingual'];
$skin_name = 'j1';
if (isset($chk_multiling)) {
	if ($chk_multiling == 1 && isset($sel_multiling) && $sel_multiling != "") {
		//$sel_multiling = $sel_multiling;
	} else {
		preg_match_all('/^[^,]+/', $_SERVER["HTTP_ACCEPT_LANGUAGE"], $match);
		$sel_multiling = $match[0][0]; 
	}

	if ($sel_multiling == "") { $sel_multiling = 'ja'; }

	if ($sel_multiling == 'ko' || strtolower($sel_multiling) == 'ko-kr') $skin_name = 'ko1';
	if ($sel_multiling == 'ja' || strtolower($sel_multiling) == 'ja-jp') $skin_name = 'j1';
	if ($sel_multiling == 'en' || strtolower($sel_multiling) == 'en-us') $skin_name = 'en1';
	if ($sel_multiling == 'cn' || strtolower($sel_multiling) == 'zh-cn') $skin_name = 'cn1';
}
$viewData["lang"] = $skin_name;


//old browser psy20150806
if( msieOldBrowserCheck() && $uri[5] !="downcmd" ){
    oldViewer();
}else{
    newViewer();
}

exit;

function msieOldBrowserCheck(){
    $u_agent = $_SERVER['HTTP_USER_AGENT'];
    if( preg_match('/MSIE/i',$u_agent) ) {
        preg_match('/MSIE\s([\d.]+)/i', $u_agent, $ver); 
        $ieVer = preg_replace("/\s+/", "", $ver[0]);
        if( $ieVer == 'MSIE7.0' || $ieVer == 'MSIE8.0' || $ieVer == 'MSIE9.0' ){
            return true;
        }
    }
    
    return false;
}


function newViewer(){
    global $uri, $book, $author, $plan, $site, $lib, $viewData;
    
    $tpl = 'multi/html5_v2/index';
    $printUrlFlag = false;
    if($uri[5]=="downcmd") $printUrlFlag = true;    
    
    $publishkey = "";
    if((int)$book->info_lib['publish'] && $author->info['plan']['plan'] > 1) {
    	$jsonString = file_get_contents( $lib->path.$bookid.'/'.$lib->monfig['file_json_book'] );
    	$jsonObj = json_decode($jsonString);
    	
    	if( $jsonObj->publishkey == "" ){
    		$publishkey = md5(date('YmdHis').time());
    	}
    }
        
    $bookurl = 'data/'.(string)$book->info_lib['path'].'/';
    $viewData["bookurl"] = $bookurl;
    $viewData["bookjson"] = $lib->monfig['file_json_book'];
    //$book->save_json((bool)$_GET['sj'], $publishkey);
    
    $site->assign('indicator', $bookurl.'pl_thumb.jpg');
    $site->assign_by_ref('book', $book);
    $site->assign( 'viewData', base64_encode( json_encode($viewData) ) );
    //$book->save_json((bool)$_GET['sj'], $publishkey);
    $site->display($tpl);
}

function oldViewer(){
    global $uri, $book, $author, $plan, $site, $lib, $viewData;
   
    $tpl = 'multi/h5Viewer/index';
    $printUrlFlag = false;
    if($uri[5]=="downcmd") $printUrlFlag = true;
    
    $data = array();
    
    $publishkey='';
    if((int)$book->info_lib['publish'] && $author->info['plan']['plan'] > 1) {
    	if( !empty($_COOKIE['h5publishkey']) ){
    		$ckKeyid = false;
    		foreach($_COOKIE['h5publishkey'] as $keyid=>$pubkey){
    			if( $keyid == $book->info_lib['bookid']){
    				$data['publishkey'] = $pubkey;
    				$ckKeyid = true;
    				break;
    			}
    		}
    		
    		if(!$ckKeyid){
    			$publishkey = md5(date('YmdHis').time());
    			setcookie("h5publishkey[".$book->info_lib['bookid']."]", $publishkey, time()+3600, HTTP_HOST);
    			$data['publishkey'] = $publishkey;
    		}
    	}else {
    		$publishkey = md5(date('YmdHis').time());
    		setcookie("h5publishkey[".$book->info_lib['bookid']."]", $publishkey, time()+3600, HTTP_HOST);
    		$data['publishkey'] = $publishkey;
    	}
    }
    
    $data['logo'] = $author->info['plan']['plan'] == $plan->monfig['default'] ? 1 : 0;
    
    $bookurl = 'data/'.(string)$book->info_lib['path'].'/';
    $indicator = ($uri[5] !="downcmd") ? $bookurl.'pl_thumb.jpg' : 'data/pl_thumb.jpg';
    //($uri[5]=="downcmd") 
    $site->assign('skin_name', $viewData["lang"]);
    $site->assign('h5data', base64_encode(http_build_query($data)));
    $site->assign('indicator', $indicator);
    $site->assign('bookurl', $bookurl);
    $site->assign('bookjson', $lib->monfig['file_json_book']);
    $site->assign( 'viewData', base64_encode( json_encode($viewData) ) );
    $book->save_json((bool)$_GET['sj'], $publishkey);
    $site->display($tpl);
}

?>
