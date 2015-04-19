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
			input{
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
<input type="text" id="css_prop_s" placeholder="css prop" style="width:100px;height:40px;margin:10px;position:relative;top:0px;left:0px;ime-mode:disabled;">
<input type="text" id="css_val"  placeholder="css val" style="width:100px;height:40px;margin:10px;position:relative;top:0px;left:0px;ime-mode:disabled;" />
<input type="button" id="css_change"  value="Dsgn" style="width:60px;height:40px;margin:10px;position:relative;top:0px;left:0px;" />
<input type="button" id="Init"  value="Init" style="width:60px;height:40px;margin:10px;float:right ;position:relative;top:0px;right:10px;" />
<input type="button" id="close" value="Cls" style="width:60px;height:40px;margin:10px;position:relative;top:0px;left:0px;" />
<div  style="float:right;position:relative;top:10px;right:10px;">ページセレクト：<select id="selectPage" ></select></div>
</section>
<article id="content_root" >
</article>
<script type="text/javascript">
window.addEventListener("storage", function(e) {
    alert(e.url + " [" + e.key + "]: Change from " + e.oldValue + " to " + e.newValue);
});
$(function(){
	var FUNCTION_ID = 'Presentation';

	var CLASS_OPENABLE = 'openable';
	var CLASSES_OPENABLE_EVENT = ['displayNextAll','applyCssData'];//TODO その内ここにまとめたい

	var content_root_jquery = $('#content_root');
	var default_content = content_root_jquery.html();

	var title_content = "";
	var modified_content = ""
	var title = "";

	var content_prev_jquery = $('#content_prev');
	var content_next_jquery = $('#content_next');
	var fire_jquery = $('#fire');
	var select_page_jquery = $('#selectPage');
	var style_change_jquery = $('#css_change');
	var change_css_prop_jquery = $('#css_prop_s');
	var change_css_val_jquery = $('#css_val');
	var close_jquery = $('#close');

	var now_presentation = null;

	function init_content(in_default_content){
		if( in_default_content != null &&  in_default_content.trim() != '' ){
			return {"title":"Presentation", "content":in_default_content.trim()};
			console.log(' There is a default content.');
		}else{
			var title_content = null;
			var raw_localStorage = window.localStorage[FUNCTION_ID];
			if( raw_localStorage != null && raw_localStorage != ""){
				var parsed_LS = JSON.parse(raw_localStorage);
				title_content = parsed_LS['publish_content'];
				console.log('TimeStamp:'+parsed_LS['TimeStamp']);

				title_content['content'] = title_content['content'].replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&amp;/g,'&').replace(/&nbsp;/g,' ').replace(/&quot/g,'"'); ;
				console.log(' There is a localStorage content.');
			}else{
				alert('Please set a content at Edit Page.');
				console.log(' There is no published content.');
				return {"content":"","title":"none"};
			}
			if( title_content == null || ! title_content.hasOwnProperty('content') ){
				alert('Please set a content at Edit Page.');
				console.log(' There is no right content.');
				return {"content":"","title":"none"};
			}
			return title_content;
		}
	}

	if(WebSocket){
		var ws_uri = "ws://"+"<%=request.getServerName()%>"+":"+"<%=request.getServerPort()%>"+"<%=request.getContextPath()%>"+"/ws_presentation";
		console.log("ws_uri:"+ws_uri);
		var ws = new WebSocket(ws_uri);
		ws.onopen = function() {
			$(document).on('click','#Init',function(){
				title_content = init_content(default_content);
				modified_content = title_content.content;
				title = title_content.title;
				console.log('content:'+modified_content);
				now_presentation = new Presentation(ws, title,content_root_jquery,  modified_content, fire_jquery, select_page_jquery, style_change_jquery);
				//$('svg',content_root_jquery).empty();
				var send_data = {"init_content":content_root_jquery.html() };
				ws.send(JSON.stringify(send_data));

			});
			$('#Init').trigger('click');

			$(document).on('click', '#close',function(){
				ws.send('{"close_presentation":"close_presentation"}');
			});


		};

		ws.onmessage = function(message) {
			//slave now_presentation.selectPage( JSON.parse(message)['page'] );
		};

		ws.onclose = function(event){
			ws.send("close_presentation");
		};
	}else{
		var ws ={"send":function(){console.log("no websocket");
		}};

		console.log("Websocketに対応していないため､連携機能が使用不能です｡")
	}

	window.onunload = function(event){
	    // 切断
	    ws.close(4500,"renew");
	}

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
		d3_start();

		$('.'+CLASS_OPENABLE).each(function(){
			console.log("this:"+JSON.stringify( $(this).attr('class') ));
			$(this).data("isOpen",false);
		});

		var today = new Date();
		$('.today_yyyymmdd').empty().html(today.getFullYear() + '年' + (today.getMonth() + 1)+ '月' + today.getDate() + '日');

		var contents = $('.content');
		var init_idx = 0;
		var init_content = contents.eq(init_idx).css({"display":""});
		var idx = init_idx;
		var length_contents = contents.length;
		var present_content = new PresentContent( init_content );
		var synchronized_flg = 0;
		var user_css_memory = {};
		var pre_css_key = change_css_prop_jquery.val();
		user_css_memory[pre_css_key] = change_css_val_jquery.val();

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
			present_content.get().fadeOut("fast",function(){
				present_content.set( contents.eq(sel_idx) );
				select_page_jquery.val(sel_idx);

				var ws_msg = {};//master
				ws_msg['page'] = sel_idx;//master
				ws.send(JSON.stringify(ws_msg));//master

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
				console.log('change css key:'+key+',val:'+val+';');
				contents.each(function(){
					$(this).css(key,val);
				});
				user_css_memory[key] = val;
			},
			"css_key_change":function(){
				console.log('PreKey :'+pre_css_key);
				var key = change_css_prop_jquery.val();
				console.log('Key :'+key);
				var val = change_css_val_jquery.val();
				if( user_css_memory.hasOwnProperty(pre_css_key) ){
					user_css_memory[pre_css_key] = val;
				}
				if( user_css_memory.hasOwnProperty(key) ){
					change_css_val_jquery.val( user_css_memory[key] );
				}else{
					change_css_val_jquery.val('');
				}
				console.log('user_css_memory:'+JSON.stringify(user_css_memory));
				pre_css_key = key;
			},
			"openStepByStep":function(){
				if( present_content.get().children('.'+CLASS_OPENABLE).length > 0 ){
					var fire_result = fireOpening();
					console.log('fire_result:'+fire_result);
					if( fire_result === false ){
						content_next_jquery.trigger('click');
					}
				}else{
					content_next_jquery.trigger('click');
				}
			}
		};
	}
function d3_start(){
	//Circle Data Set
	var d3_data_s = [
		{ "circle":[
		            {"attr":{"cx": 110, "cy": 110, "r": 100}, "style":{"fill":"red","opacity":0.4}},
		            {"attr":{"cx": 210, "cy": 110, "r": 80}, "style":{"fill":"blue","opacity":0.2}}
		            ]
		//,"text":{}
		}];
	var d3_obj_s = {};

	//Create the SVG Viewport
	var svgContainer = d3.select("#obj_01_01").append("svg")
	                                     .attr("width",300)
	                                     .attr("height",300);
	//Add 1st to the svgContainer
	var d3_data_s_length = d3_data_s.length;
	for(var index = 0; index < d3_data_s_length; ++index){
		var shape_grp = d3_data_s[index];
		for( var shape in shape_grp)if(shape_grp.hasOwnProperty(shape)){
			var shape_val_s = shape_grp[shape];
			var shape_val_s_length = shape_val_s.length;

			var instance_shape = svgContainer.selectAll(shape).data(shape_val_s)
			                           .enter().append(shape);
			d3_obj_s[shape] = instance_shape;
			//Add attributes
			var insAttributes = instance_shape;
			for( var s_idx=0; s_idx < shape_val_s_length; ++s_idx){
				var shape_val = shape_val_s[s_idx];
				for( var method in shape_val) if( shape_val.hasOwnProperty(method) ){
					var prop_s = shape_val[method];
					for(var prop in prop_s ) if( prop_s.hasOwnProperty(prop) ){
						insAttributes = insAttributes[method](prop, function (d) {
								return d[method][prop];
							});
					}
				}
			}
		}
	}
}
/*
	//Add the SVG Text Element to the svgContainer
	var text = svgContainer.selectAll("text")
	                        .data(circle_data_s)
	                        .enter()
	                        .append("text");

	//Add SVG Text Element Attributes
	var textLabels = text
	                 .attr("x", function(d) { return d.cx; })
	                 .attr("y", function(d) { return d.cy; })
	                 .text( function (d) { return "ドメイン" ; })
	                 .attr("font-family", "sans-serif")
	                 .attr("font-size", "20px")
	                 .attr("fill", "red");
*/
});
</script>

</body>
</html>
