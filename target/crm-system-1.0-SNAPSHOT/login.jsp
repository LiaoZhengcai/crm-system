<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {
			//如果当前窗口不是顶层窗口，将顶层窗口设置为当前窗口。
			if(window.top!=window){
				window.top.location=window.location;
			}
			//页面加载完毕后，让用户的文本框自动获得焦点
			$("#loginAct").focus();
			//为当前登录窗口绑定敲键盘事件
			$(window).keydown(function (event) {
				if(event.keyCode==13){
					login();
				}
			})
			//为登录按钮绑定事件执行登录
			$("#submitBtn").click(function () {
				login();
			})
		})
		//用户执行登录的方法
		function login() {
			//取得账号密码，去除空格，验证账号密码不能为空
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			if(loginAct==""){
				$("#msg").html("账号不能为空");
				$("#loginAct").focus();
				return false;
			}else if (loginPwd==""){
				$("#msg").html("密码不能为空");
				$("#loginPwd").focus();
				return false;
			}
			//去后台验证登录操作
			 $.ajax({
				 url:"user/doLogin",
				 data:{
				 	"loginAct":loginAct,
					 "loginPwd":loginPwd
				 },
				 type:"post",
				 dataType:"json",
				 success:function (data) {
					if(data.success){
						//登录成功跳转到初始页
						window.location.href = "workbench/index.jsp";
					}else{
						//登录失败，给出响应提示
                            $("#msg").html(data.msg);
					}
				 }
			 })
		}
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;"></span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
					<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>