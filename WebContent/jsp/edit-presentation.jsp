<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=11" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-ui-1.11.1.custom/jquery-ui.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/smoothness/jquery-ui-1.11.1.custom/jquery-ui.min.css">
<title>Presentation 編集･管理</title>
</head>
<body>
<input type="button" value="clear" id="clear"  />
<input type="button" value="remove" id="remove"  />
<input type="button" value="load" id="load" />
<input type="button" value="register" id="register" />
<input type="button" value="publish" id="publish"  />
<select id="select_presentation" ></select>
<br />
<input type="text" id="title" value=""  />
<br />
<textarea cols="100" rows="24" id="script_area"></textarea>

<script>
$(function(){
	var FUNCTION_ID = 'Presentation';
	var presentation_contents = new Array();
	var selected_id = null;
	var NEW_PRESENTATION_ID = -1;
	var script_area_jquery = $('#script_area');
	script_area_jquery.resizable();

	init();

	function getSelectedId(){
		var option = $('#select_presentation :selected');
		if( option.length !== 1){
			alert('Please select');
			return null;
		}
		return option.attr('name');
	}

	function init(_except_id){
		var pool_contents = new Array();
		var counter = 0;
		var titles = '';

		var raw_localStorage = localStorage[FUNCTION_ID];
		if( raw_localStorage != null && raw_localStorage != ""){
			console.log(' localStorage data Exists.');
			presentation_contents = JSON.parse(raw_localStorage)['presentation_contents'];

			if( typeof presentation_contents === 'undefined'){
				console.log(' Existing data is not right. ');
				presentation_contents = [];
			}
		}else{
			console.log('no localStorage. And initializing data.');
			//initializing data
			presentation_contents = [];
			localStorage[FUNCTION_ID] = JSON.stringify( {"presentation_contents":presentation_contents , "publish_content":null});
		}

		titles +='<option name="'+NEW_PRESENTATION_ID+'">New Presentation</option>';
		console.log('{"registered contents":{"length":'+presentation_contents.length+'}}');
		$(presentation_contents).each(function(_idx, _obj){
			if( ( _except_id == null || _except_id != _idx)
					&& _obj != null){
				var title = _obj['title'];
				var content = _obj['content'];

				titles +='<option name="'+counter+'">'+title+'</option>';
				pool_contents.push(_obj);
				++counter;
			}
		});
		presentation_contents = pool_contents;
		$('#select_presentation').html(titles);
		selected_id = null;
	}

	$('#load').on('click',function(){
		selected_id = getSelectedId();
		if( selected_id != NEW_PRESENTATION_ID){
			var title_content = presentation_contents[selected_id];
			$('#title').val(title_content['title']);
			script_area_jquery.html(title_content['content']);
		}else{
			alert('You can\'t load "New Presentation"!!');
		}
	});

	$('#remove').on('click',function(){
		selected_id = getSelectedId();
		if( selected_id != NEW_PRESENTATION_ID){
			init(selected_id);
			localStorage[FUNCTION_ID] = JSON.stringify({"presentation_contents":presentation_contents});
			registerContent(presentation_contents);
		}else{
			alert('You can\'t remove "New Presentation"!!');
		}
	});


	$('#publish').on('click',function(){
		selected_id = getSelectedId();
		if( selected_id != NEW_PRESENTATION_ID){
			console.log(JSON.stringify(presentation_contents));
			registerContent(presentation_contents, selected_id );
		}else{
			alert('You can\'t publish "New Presentation"!!');
			return;
		}
		alert('publishing completed.');
	});

	$('#clear').on('click',function(){
		localStorage.clear();
		if(localStorage.length == null || localStorage.length ==0){
			alert('success');
		}else{
			alert('failure');
		}
	});

	$('#register').on('click',function(){
		var register_id = null;
		selected_id = getSelectedId();
		if( selected_id == NEW_PRESENTATION_ID ){
			register_id = presentation_contents.length;
		}else{
			register_id = selected_id;
		}
		var title = $('#title').val();
		if( title == null || title.length == 0){
			alert('Please input title');
			return;
		}

		var content = script_area_jquery.html();
		presentation_contents[register_id] = {"title":title,"content":content};
		registerContent(presentation_contents );

		init();
		alert('register completed.');
	});

	function registerContent(_presentation_contents, _selected_id){
		console.log( 'register : ' );
		var time_stamp = new Date();
		var setData = {"presentation_contents":_presentation_contents, "TimeStamp":time_stamp}
		console.log('Edit TimeStamp:'+time_stamp);
		if( _selected_id === null || typeof _selected_id === 'undefined' ){
			console.log(' kept.');
			var localStorageData = JSON.parse(localStorage[FUNCTION_ID]);
			var kept_selected_content = null
			if( localStorageData.hasOwnProperty('publish_content') ){
				keput_selected_content = localStorageData['publish_content'];
			}
			setData['publish_content'] = kept_selected_content;
		}else{
			console.log(' newer.');
			setData['publish_content'] = _presentation_contents[_selected_id];
		}
		console.log('publish_content :'+JSON.stringify(setData['publish_content']));
		localStorage[FUNCTION_ID] = JSON.stringify(setData);
		console.log(JSON.stringify(localStorage[FUNCTION_ID]));
	}
});
</script>
</body>
</html>