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
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$("#edit-owner").val("${uct.tran.owner}");
		$("#edit-money").val("${uct.tran.money}");
		$("#edit-name").val("${uct.tran.name}");
		$("#edit-expectedDate").val("${uct.tran.expectedDate}");
		$("#edit-customerId").val("${uct.tran.customerId}");
		$("#edit-stage").val("${uct.tran.stage}");
		$("#edit-type").val("${uct.tran.type}");
		$("#edit-source").val("${uct.tran.source}");
		$("#edit-activityId").val("${uct.tran.activityId}");
		$("#edit-contactsId").val("${uct.tran.contactsId}");
		$("#edit-description").val("${uct.tran.description}");
		$("#edit-contactSummary").val("${uct.tran.contactSummary}");
		$("#edit-nextContactTime").val("${uct.tran.nextContactTime}");

		$("#updateTran").click(function () {
			$("#updateTranForm").submit();
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
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
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
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody>

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateTran">更新</button>
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/index.jsp'">返回</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" action="tran/updateTran" id="updateTranForm" role="form" style="position: relative; top: -30px;">
		<input type="hidden" name="id" value="${uct.tran.id}">
		<input type="hidden" name="editBy" value="${user.name}">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="owner" id="edit-owner">
					<c:forEach items="${uct.uList}" var="c">
						<option value="${c.id}">${c.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="money" id="edit-money">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="name" id="edit-name">
			</div>
			<label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="date" class="form-control time" name="expectedDate" id="edit-expectedDate">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-customerId" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="customerId" id="edit-customerId">
					<option></option>
					<c:forEach items="${uct.cuList}" var="c">
						<option value="${c.id}">${c.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="stage" id="edit-stage">
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
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="type" id="edit-type">
					<option></option>
					<option value="已有业务">已有业务</option>
					<option value="新业务">新业务</option>
				</select>
			</div>
			<label for="edit-contactsId" class="col-sm-2 control-label">联系人名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="contactsId" id="edit-contactsId">
					<option></option>
					<c:forEach items="${uct.coList}" var="c">
						<option value="${c.id}">${c.fullname}</option>
					</c:forEach>
				</select>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="source" id="edit-source">
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
			<label for="edit-activityId" class="col-sm-2 control-label">市场活动源<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="activityId" id="edit-activityId">
					<option></option>
					<c:forEach items="${uct.aList}" var="c">
						<option value="${c.id}">${c.name}</option>
					</c:forEach>
				</select>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" name="description" id="edit-description"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" name="contactSummary" id="edit-contactSummary"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="date" class="form-control time" name="nextContactTime" id="edit-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>