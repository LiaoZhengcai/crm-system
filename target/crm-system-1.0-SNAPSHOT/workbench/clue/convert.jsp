﻿<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

//String fullname = request.getParameter("fullname");
//String id = request.getParameter("id");
//String appellation = request.getParameter("appellation");
//String company = request.getParameter("company");
//String owner = request.getParameter("owner");

%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});
		
		//打开市场活动选择的模态窗口
		$("#openSerachModalBtn").click(function () {
			$.ajax({
				url:"clue/getAllActivityByClueId",
				data:{
					"id":"${param.id}"
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					var html = "";
					if(JSON.stringify(data) == "[]"){
						html += '<tr class="active"><td colspan="5" style="text-align: center">未找到关联的市场活动信息，请先关联市场活动</td></tr>';
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
					$("#showAllActivity").html(html);
					$("#searchActivityModal").modal("show");
				}
			});
		});

		//提交选择的市场活动
		$("#submitActivityBtn").click(function () {
			//取市场活动ID
			var id = $("input[name=xz]:checked").val();
			//取市场活动名称
			var name = $("#"+id).html();
			//赋值
			$("#activityName").val(name);
			$("#activityId").val(id);
			//关闭模态窗口
			$("#searchActivityModal").modal("hide");
		});

		//为转换按钮绑定事件,线索转换之后URL转向线索列表
		$("#convertBtn").click(function () {
			//判断是否创建交易
			if($("#isCreateTransaction").prop("checked")){
                var tradeName = $.trim($("#tradeName").val());
			    if(tradeName==""){
                    $("#msg").html("*交易名称不能为空");
                    $("#tradeName").focus();
                    return false;
                }
				$("#tranForm").submit();
			}else{
				window.location.href="clue/doConvert?clueId=${param.id}";
			}
		});

	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">请选择关联的市场活动</h4>
				</div>
				<div class="modal-body">
<%--					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">--%>
<%--						<form class="form-inline" role="form">--%>
<%--						  <div class="form-group has-feedback">--%>
<%--						    <input type="text" id="aname" class="form-control" style="width: 350px;" placeholder="请输入市场活动名称，按回车，模糊查询">--%>
<%--						    <span class="glyphicon glyphicon-search form-control-feedback"></span>--%>
<%--						  </div>--%>
<%--						</form>--%>
<%--					</div>--%>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="showAllActivity">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
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

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.fullname}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="tranForm" action="clue/doConvert" method="post">
			<input type="hidden" name="clueId" value="${param.id}">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="name"><span style="color: red;" id="msg"></span>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" readonly="readonly" class="form-control time" id="expectedClosingDate" name="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control" name="stage">
		    	<option></option>
		    	<option>资质审查</option>
		    	<option>需求分析</option>
		    	<option>价值建议</option>
		    	<option>确定决策者</option>
		    	<option>提案/报价</option>
		    	<option>谈判/复审</option>
		    	<option>成交</option>
		    	<option>丢失的线索</option>
		    	<option>因竞争丢失关闭</option>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;"><!--searchActivityModal-->
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSerachModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
			<input type="hidden" id="activityId" name="activityId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="convertBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" onclick="window.history.back();" type="button" value="取消">
	</div>
</body>
</html>