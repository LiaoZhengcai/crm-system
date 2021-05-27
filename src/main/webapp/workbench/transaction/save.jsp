<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script>
	$(function () {
		$("#create-owner").val("${user.id}");
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		//为查找市场活动源绑定事件，根据名称查市场活动源
		$("#aname").keydown(function (event) {
			//绑定回车事件
			if(event.keyCode==13){
				$.ajax({
					url:"tran/showActivityByName",
					data:{
						"aname" : $.trim($("#aname").val()),
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						var html = "";
						if(JSON.stringify(data) == "[]"){
							html += '<tr class="active"><td colspan="5" style="text-align: center">未找到相关的市场活动信息</td></tr>';
						}else{
							$.each(data,function (i,n) {
								html += '<tr class="active">';
								html += '<td><input name="xz" type="radio" value="'+n.id+'"/></td>';
								html += '<td id="'+n.id+'">'+n.name+'</td>';
								html += '<td>'+n.startDate+'</td>';
								html += '<td>'+n.endDate+'</td>';
								html += '<td>'+n.owner+'</td>';
								html += '</tr>';
							});
						}
						$("#activityBody").html(html);
					}
				});
				//展现完列表，把模态窗口默认的回车行为禁掉
				return false;
			}
		});
		//提交选择的市场活动
		$("#submitActivityBtn").click(function () {
			//取市场活动ID
			var id = $("input[name=xz]:checked").val();
			//取市场活动名称
			var name = $("#"+id).html();
			//赋值
			$("#activityName").val(name);
			$("#create-activityId").val(id);
			//清空搜索框内容
			$("#aname").val("");
			$("#activityBody").html("");
			//关闭模态窗口
			$("#findMarketActivity").modal("hide");
		});

		//为查找联系人绑定事件，根据名称查联系人信息
		$("#cname").keydown(function (event) {
			//绑定回车事件
			if(event.keyCode==13){
				$.ajax({
					url:"tran/showContactsByName",
					data:{
						"cname" : $.trim($("#cname").val()),
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						var html = "";
						if(JSON.stringify(data) == "[]"){
							html += '<tr class="active"><td colspan="4" style="text-align: center">未找到相关的联系人信息</td></tr>';
						}else{
							$.each(data,function (i,n) {
								html += '<tr class="active">';
								html += '<td><input name="xz" type="radio" value="'+n.id+'"/></td>';
								html += '<td id="'+n.id+'">'+n.fullname+'</td>';
								html += '<td>'+n.email+'</td>';
								html += '<td>'+n.mphone+'</td>';
								html += '</tr>';
							});
						}
						$("#contactsBody").html(html);
					}
				});
				//展现完列表，把模态窗口默认的回车行为禁掉
				return false;
			}
		});
		//提交选择的联系人信息
		$("#submitContactsBtn").click(function () {
			var id = $("input[name=xz]:checked").val();
			var name = $("#"+id).html();
			$("#contactsName").val(name);
			$("#create-contactsId").val(id);
			//清空搜索框内容
			$("#cname").val("");
			$("#contactsBody").html("");
			//关闭模态窗口
			$("#findContacts").modal("hide");
		});

		$("#saveTran").click(function () {
			var money = $.trim($("#create-money").val());
			var name = $.trim($("#create-name").val());
			var customerId = $.trim($("#create-customerId").val());
			var stage = $.trim($("#create-stage").val());
			var type = $.trim($("#create-type").val());
			var source = $.trim($("#create-source").val());
			var activityId = $.trim($("#create-activityId").val());
			var contactsId = $.trim($("#create-contactsId").val());
			if(money==""){
				alert("金额不能为空");
				$("#create-money").focus();
				return false;
			}
			if(name==""){
				alert("交易名称不能为空");
				$("#create-name").focus();
				return false;
			}
			if(customerId==""){
				alert("客户不能为空");
				$("#create-customerId").focus();
				return false;
			}
			if(stage==""){
				alert("阶段不能为空");
				$("#create-stage").focus();
				return false;
			}
			if(type==""){
				alert("类型不能为空");
				$("#create-type").focus();
				return false;
			}
			if(source==""){
				alert("来源不能为空");
				$("#create-source").focus();
				return false;
			}
			if(activityId==""){
				alert("市场活动源不能为空");
				return false;
			}
			if(contactsId==""){
				alert("联系人不能为空");
				return false;
			}
			$("#tranForm").submit();
		});

	});
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline"  role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="aname" style="width: 350px;" placeholder="输入市场活动名称，按回车键，查找市场活动源">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 850px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">确定</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="cname" class="form-control" style="width: 350px;" placeholder="请输入联系人名称，按回车键，查找联系人信息">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 850px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitContactsBtn">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTran">保存</button>
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/index.jsp'">返回</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" id="tranForm" action="tran/saveTran" role="form" style="position: relative; top: -30px;">
		<input type="hidden" name="createBy" value="${user.name}">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="owner" id="create-owner">
					<c:forEach items="${ucList.uList}" var="c">
						<option value="${c.id}">${c.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="money" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="name" id="create-name">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="date" class="form-control time" name="expectedDate" id="create-expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerId" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="customerId" id="create-customerId">
					<option></option>
					<c:forEach items="${ucList.cList}" var="c">
						<option value="${c.id}">${c.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" name="stage" id="create-stage">
			  	<option></option>
			  	<option value="资质审查">资质审查</option>
			  	<option value="需求分析">需求分析</option>
			  	<option value="价值建议">价值建议</option>
			  	<option value="确定决策者">确定决策者</option>
			  	<option value="提案/报价">提案/报价</option>
			  	<option value="谈判/复审">谈判/复审</option>
			  	<option value="成交">成交</option>
			  	<option value="丢失的线索">丢失的线索</option>
			  	<option value="因竞争丢失关闭">因竞争丢失关闭</option>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="type" id="create-type">
				  <option></option>
				  <option value="已有业务">已有业务</option>
				  <option value="新业务">新业务</option>
				</select>
			</div>
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" id="contactsName" placeholder="查找联系人" readonly class="form-control" id="create-contactsName">
				<input type="hidden" name="contactsId" id="create-contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="source" id="create-source">
				    <option></option>
					<option value="广告">广告</option>
					<option value="推销电话">推销电话</option>
					<option value="员工介绍">员工介绍</option>
					<option value="外部介绍">外部介绍</option>
					<option value="在线商场">在线商场</option>
					<option value="合作伙伴">合作伙伴</option>
					<option value="公开媒介">公开媒介</option>
					<option value="web调研">web调研</option>
					<option value="聊天">聊天</option>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" id="activityName" placeholder="查找市场活动源" class="form-control" readonly id="create-activitySrc">
				<input type="hidden" name="activityId" id="create-activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" name="description" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" name="contactSummary" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="date" class="form-control time" name="nextContactTime" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>