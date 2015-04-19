<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=11" />
		<title>Presentation</title>
		<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-2.1.1.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-ui-1.11.1.custom/jquery-ui.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/js/d3.v3.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery-ui-1.11.1.custom/jquery-ui.min.css">
		<style type="text/css" >
			* {
				font-family: 'A-TTC 新ゴ M','ヒラギノ角ゴ Pro W3','Hiragino Kaku Gothic Pro W3','メイリオ',Meiryo,'ＭＳ Ｐゴシック',sans-serif ,'ＭＳ ゴシック', monospace;
			}
			.shadow {
			  	padding				: 6px;
			  	box-shadow: 5px 5px 15px #000000;
				background			: black\9;
				border-radius		: 5px;
			}
			p,th,td,table,dl{
				margin:10px 0px 30px 50px;
				font-weight:800;
				padding:10px;
			}
			th{
				white-space:nowrap;
				word-break:keep-all;
			}
			input, select{
				border-radius		: 5px;
			}
			input[type=text]{
				padding: 5px;
			}

			.shadow:not(:target) {
				filter				: none ;
				background			: rgba(128,128,128,0.1);
			}
			#content_root{
				width:100%;
			}
			.content{
				width: 800px;
				margin:30px auto 0px;
				display:none;
				padding: 5px 30px 10px;
			}
			h1,h2,h3,h4{
				text-align:center;
			}
			h1{
				font-size:4em;
			}
			h2{
				font-size:3em;
			}
			h3{
				font-size:2em;
			}
			 .csssplite{
			 	cursor:pointer;
				<!-- /* background-image:url('<%=request.getContextPath()%>/img/tizuButtonCSSSplite.gif'); */ -->
				background-position: -20px -4px;
			}
			.hide_mode_target{
				width:100% ;

			}
			.menu_bar{
				background-color : rgba(221,221,221,0.5);
			}
		</style>
	</head>
<body>
<section class="hide_mode_target menu_bar" style="position:fix;top:0px ;left: 0px ;" data-fire-key-code="escape" >
<input type="button" id="content_prev"  value="Prev" style="width:60px;height:40px;margin:10px;position:relative;top:0px;left:0px;"/>
<input type="button" id="content_next" value="NeXT" style="width:60px;height:40px;margin:10px;position:relative;top:0px;left:0px;" />
<input type="button" id="fire"  value="Fire" style="width:60px;height:40px;margin:10px;position:relative;top:0px;left:0px;" />
<input type="text" id="css_prop_s"  placeholder="css prop" style="width:100px;height:40px;margin:10px;position:relative;top:0px;left:0px;">
<input type="text" id="css_val"  placeholder="css value" style="width:100px;height:40px;margin:10px;position:relative;top:0px;left:0px;" />
<input type="button" id="css_change"  value="Dsgn" style="width:60px;height:40px;margin:10px;position:relative;top:0px;left:0px;" />
<input type="button" id="Init"  value="Init" style="width:60px;height:40px;margin:10px;float:right ;position:relative;top:0px;right:10px;" />
<div  style="float:right;position:relative;top:10px;right:10px;">ページセレクト：<select id="selectPage" ></select></div>
</section>
<article id="content_root" >
<section class="content" >
<article style="font-size:64pt;">Please Wait ^～^</article><br />
<article>この文字が読みやすいようにCSS調整してください</article>
</section>
</article>


<script type="text/javascript">
$(function(){
	var FUNCTION_ID = 'Presentation';
	var raw_localStorage = localStorage[FUNCTION_ID];

	var CLASS_OPENABLE = 'openable';
	var CLASSES_OPENABLE_EVENT = ['displayNextAll','applyCssData'];//TODO その内ここにまとめたい

	var content_root_jquery = $('#content_root');
	var user_css_memory = {};

	var now_presentation = null;
	var modified_content = null;
	if(WebSocket){
		var ws_uri = "ws://"+"<%=request.getServerName()%>"+":"+"<%=request.getServerPort()%>"+"<%=request.getContextPath()%>"+"/ws_presentation";
		console.log("ws_uri:"+ws_uri);
		var ws = new WebSocket(ws_uri);
		ws.onopen = function() {
			$(document).on('click','#Init',function(){
				now_presentation = new Presentation(ws, title,content_root_jquery,  modified_content, fire_jquery, select_page_jquery, style_change_jquery);
			});
			$('#Init').trigger('click');
		};

		ws.onmessage = function(message) {//slave
			var message_stringified = JSON.stringify(message.data);
			if( message_stringified != null && message_stringified != ''){
				var sent_data = JSON.parse(message.data);
				for(var key in sent_data)if(sent_data.hasOwnProperty(key)){
					if( key == 'page'){
						var idx = parseInt(sent_data[key],10);
						now_presentation.selectPage( idx );
						break;
					}else if( key == 'init_content') {
						modified_content = sent_data[key].replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace('\\\\n','');
						if(modified_content != ''){
							content_root_jquery.empty().html(modified_content);
							$('#Init').trigger('click');
						}
						break;
					}else if( key === 'close_presentation'){
						now_presentation = null;
						modified_content = '<section class="content" ><article style="font-size:64pt;">Please Wait ^～^</article><br /><article>この文字が読みやすいようにCSS調整してください</article></section>';
						$('#Init').trigger('click');
					}else{
						console.log('key:'+key);
					}
				}
			}
		};
	}else{
		var ws ={"send":function(){console.log("no websocket");
		}};
		console.log("Websocketに対応していないため､連携機能が使用不能です｡")
	}

	var title_content = null;
	var default_content = content_root_jquery.html();

	var title = 'Presentation';
	if( default_content != null &&  default_content.trim() != '' ){
		modified_content = default_content.trim();
		console.log("There is default content.");
	}else{
		if( raw_localStorage != null && raw_localStorage != ""){
			console.log( raw_localStorage );
			title_content = JSON.parse(raw_localStorage)['publish_content'];
		}else{
			alert('Please set a content at Edit Page.');
			console.log(' There is no published content.');
			return;
		}
		if( title_content == null || ! title_content.hasOwnProperty('content') ){
			alert('Please set a content at Edit Page.');
			console.log(' There is no right content.');
			return;
		}
		var raw_content = title_content['content'];
		title = title_content['title'];
		modified_content = raw_content.replace(/&lt;/g,'<').replace(/&gt;/g,'>');
	}

	var content_prev_jquery = $('#content_prev');
	var content_next_jquery = $('#content_next');
	var fire_jquery = $('#fire');
	var select_page_jquery = $('#selectPage');
	var style_change_jquery = $('#css_change');
	var change_css_prop_jquery = $('#css_prop_s');
	var change_css_val_jquery = $('#css_val');


	content_next_jquery.click(function(){
		var _this = $(this);
		var rtn = now_presentation.nextPage(_this);
		console.log('next page');
	});
	content_prev_jquery.click(function(){
		var _this = $(this);
		var rtn = now_presentation.prevPage(_this);
		console.log('prev page');
	});
	$(document).on('click','#fire',function(){
		var rtn = now_presentation.fire();
	});
	$(document).on('click','#css_change',function(){
		var rtn = now_presentation.css_change();
	});
	change_css_prop_jquery.on('change', function(){
		console.log('css key changed.');
		var rtn = now_presentation.css_key_change();
	});

	select_page_jquery.on('change', function(){
		var in_idx = $(this).val();
		now_presentation.selectPage( in_idx );
	});


	$(document).on('keydown',function(_ev, _this ){
		switch(_ev.keyCode){
			case 37://←
				content_prev_jquery.trigger('click');
				break;
			case 38://↑
				fire_jquery.trigger('click');
				break;
			case 39 ://→
				content_next_jquery.trigger('click');
				break;
			case 40 ://↓
				now_presentation.openStepByStep();
				break;
			case 27 ://ESC
				$('[class*="hide_mode_target"][data-fire-key-code="escape"]').toggle('slide',null,500);
				break;
			default :
				break;
		}
	});

	function Presentation(ws, _title, root_jquery, _content, fire_jquery, select_page_jquery, style_change_jquery){
		$('title').html(_title);
		root_jquery.empty().html(_content);

		$('.'+CLASS_OPENABLE).each(function(){
			console.log("this:"+JSON.stringify( $(this).attr('class') ));
			$(this).data("isOpen",false);
		});

		var today = new Date();
		$('.today_yyyymmdd').empty().html(today.getFullYear() + '年' + (today.getMonth() + 1)+ '月' + today.getDate() + '日');

		var contents = $('.content');
		var init_idx = 0;
		var init_content = contents.eq(init_idx).css({"display":"","opacity":1});
		var idx = init_idx;
		var length_contents = contents.length;
		var present_content = new PresentContent( init_content );
		var synchronized_flg = 0;
		var pre_css_key = change_css_prop_jquery.val();
		user_css_memory[pre_css_key] = change_css_val_jquery.val();
		console.log("user_css_memory:init:"+JSON.stringify(user_css_memory));

		var append_page_select = "";
		for(var i=0; i < length_contents; ++i){
			append_page_select +='<option value="'+ i +'" >'+(i+1)+'</option>';
		}
		select_page_jquery
		.html(append_page_select);

		present_content.get().fadeOut("fast",function(){
			present_content.set( init_content );
			idx = init_idx;
			if( present_content.get().children('.fireable').length > 0 ){
				fire_jquery.prop("disabled",false);
			}else{
				fire_jquery.prop("disabled",true);
			}
			$(this).fadeIn("slow");
		});
		$('[class*="'+CLASS_OPENABLE+'"][class*="displayNextAll"]').nextAll().css({"opacity":0});
		for(var css_key in user_css_memory)if(user_css_memory.hasOwnProperty(css_key)){
			var css_val = user_css_memory[css_key];
			if( css_key!= null && css_key != ''
					&& css_val != null && css_val != ''){
				contents.each(function(){
					$(this).css(css_key,css_val);
				});
			}
		}
		//End Initializing

		function PresentContent(_content){
			var present_content = _content;
			return {
				"get":function(){
					return present_content;
				}
				,"set":function(_present_content){
					present_content = _present_content;
					return present_content;
				}
			};
		}

		function fireOpening(){
			var list = $('.'+CLASS_OPENABLE, present_content.get()).filter(function(){
				console.log("isOpen:"+$(this).data("isOpen"));
				return $(this).data("isOpen") === false;
			});
			console.log( "unopened:"+list.length);
			if( list.length > 0){
				list.eq(0).trigger('mouseover');
				return true;
			}else{
				return false;
			}
		}

		$(document).on('mouseover','.'+CLASS_OPENABLE, function(){
			var _this = $(this);
			_this.filter('.displayNextAll').nextAll().each(function(){
				$(this).animate({"opacity":1});
			});

			_this.children('.applyCssData').each(function(){
				var _self_this = $(this);
				var _self_css = _self_this.data("css");
				var _parent_css = _this.data("css");
				if(_self_css !== null && typeof _self_css !== 'undefined'){
					_self_this.css(_self_css);
				}else if( _parent_css !== null && typeof _parent_css !== 'undefined' ){
					_self_this.css(_parent_css);
				}
			});
			_this.filter('.applyCssData').each(function(){
				var _self_this = $(this);
				var _self_css = _self_this.data("css");
				if( _self_css !== null && typeof _self_css !== 'undefined' ){
					_self_this.css(_self_css);
				}
			});
			_this.data("isOpen",true);
		});

	//以下はかなりてきとー
		var fireCssSplite_id = '#fireCssSplite';
		var fireCssSplite_jquery = $(fireCssSplite_id);
		var first_size_css_splite = {"width":fireCssSplite_jquery.css("width"),"height":fireCssSplite_jquery.css("height")};

		var toggle_flg = 1;
		$(document).on('click',fireCssSplite_id,function(){
			if( 1 === toggle_flg ){
				$(this).animate({"width":"135px","height":"47px"},1000);
			}else{
				$(this).animate(first_size_css_splite,1000);
			}
			toggle_flg *= -1;
		});

		function selectPageImpl(sel_idx){
			if( length_contents === 1){
				return;
			}
			present_content.get().fadeOut("fast",function(){
				present_content.set( contents.eq(sel_idx) );
				select_page_jquery.val(sel_idx);

				if( present_content.get().children('.fireable').length > 0 ){
					fire_jquery.prop("disabled",false);
				}else{
					fire_jquery.prop("disabled",true);
				}
				idx = sel_idx;
				present_content.get().fadeIn("slow");
			});
		}

		// Page init
		selectPageImpl(init_idx);
		return {
			"selectPage":function(sel_idx){
				selectPageImpl(sel_idx);
			},
			"nextPage":function(_this){
				if(synchronized_flg > 0){return;}
				++synchronized_flg;
				_this.prop("disabled",true);
				++idx;//next page
				idx = idx % length_contents;//カリー化したい

				selectPageImpl(idx);
				--synchronized_flg;
				_this.prop("disabled",false);
			},
			"prevPage":function(_this){
				if(synchronized_flg > 0){return;}
				++synchronized_flg;
				_this.prop("disabled",true);
				--idx;//pre page
				idx = (length_contents + idx) % length_contents;//カリー化したい

				selectPageImpl(idx);
				--synchronized_flg;
				_this.prop("disabled",false);
			},
			"fire":function(){
				$('.fireable',present_content.get()).trigger('click');
			},
			"css_change":function(){
				var key = change_css_prop_jquery.val();
				var val = change_css_val_jquery.val();
				contents.each(function(){
					$(this).css(key,val);
				});
				user_css_memory[key] = val;
			},
			"css_key_change":function(){
				var key = change_css_prop_jquery.val();
				var val = change_css_val_jquery.val();
				if( user_css_memory.hasOwnProperty(pre_css_key) ){
					user_css_memory[pre_css_key] = val;
				}
				if( user_css_memory.hasOwnProperty(key) ){
					change_css_val_jquery.val( user_css_memory[key] );
				}else{
					change_css_val_jquery.val('');
				}
				pre_css_key = key;
			},
			"openStepByStep":function(){
				if( present_content.get().children('.'+CLASS_OPENABLE).length > 0 ){
					var fire_result = fireOpening();
					if( fire_result === false ){
						content_next_jquery.trigger('click');
					}
				}else{
					content_next_jquery.trigger('click');
				}
			}
		};
	}
});
</script>
</body>
</html>
