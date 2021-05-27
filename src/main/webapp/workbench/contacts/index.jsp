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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link type="text/css" href="jquery/jsPagination/pagination.css" rel="stylesheet">
<script type="text/javascript" src="jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/jsPagination/pagination.js"></script>
<script type="text/javascript">

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		//页面加载异步查询线索数据
		pageList();
		//为查询按钮绑定事件，触发pageList方法
		$("#searchBtn").click(function () {
			pageList();
		});
		//为取消查询按钮绑定事件
		$("#clearBtn").click(function () {
			$("#clueSearchForm")[0].reset();
			pageList();
		});

		//为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {
			$.ajax({
				url : "contacts/getUserAndCustomerList",
				type : "get",
				dataType : "json",
				success : function (data) {
					var html = "";
					$.each(data.u,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#create-owner").html(html);
					var id = "${user.id}";
					$("#create-owner").val(id);
					var html = "<option></option>";
					$.each(data.c,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#create-customerId").html(html);
					//处理完所有者下拉框数据后，打开模态窗口
					$("#createContactsModal").modal("show");
				}
			});
		});

		//点x,点关闭按钮触发清空form表单
		$("#resetForm,#closeForm").click(function () {
			$("#contactsAddForm")[0].reset();
			$("#createContactsModal").modal("hide");
		});

		//为保存按钮绑定事件，执行线索添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url: "contacts/saveContacts",
				data: {
					"owner" : $.trim($("#create-owner").val()),
					"source" : $.trim($("#create-source").val()),
					"customerId" : $.trim($("#create-customerId").val()),
					"fullname" : $.trim($("#create-fullname").val()),
					"appellation" : $.trim($("#create-appellation").val()),
					"email" : $.trim($("#create-email").val()),
					"mphone" : $.trim($("#create-mphone").val()),
					"job" : $.trim($("#create-job").val()),
					"birth" : $.trim($("#create-birth").val()),
					"description" : $.trim($("#create-description").val()),
					"contactSummary" : $.trim($("#create-contactSummary").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime").val()),
					"address" : $.trim($("#create-address").val()),
					"createBy" : "${user.name}"
				},
				type: "post",
				dataType: "json",
				success: function (data) {
					if (data) {
						//清空表单
						$("#contactsAddForm")[0].reset();
						//关闭模态窗口
						$("#createContactsModal").modal("hide");
						//刷新列表
						pageList();
					} else {
						alert("添加联系人失败");
					}
				}
			});
		});

		//为全选的复选框绑定事件，触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});

		//动态生成的元素，我们要以on的形式绑定元素的有效外层元素来触发事件
		$("#contactsBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		});

		//为删除按钮绑定事件执行客户信息删除操作
		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if(confirm("您确定要删除吗？")){
				if($xz.length==0){
					alert("请选择需要删除的记录");
				}else{
					var param = $xz.serialize();
					$.post("contacts/doDeleteByIds",param,function (data) {
						if(data){
							pageList();
						}else{
							alert("删除失败");
						}
					});
				}
			}
		});

		//为修改按钮绑定事件，打开修改窗口
		$("#editBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择需要修改的记录");
			}else if ($xz.length>1){
				alert("只能选择一条记录进行修改");
			}else{
				var id = $xz.val();
				//修改前先拿到要修改的用户信息跟活动信息展现到修改模态窗
				$.get("contacts/getUserAndCustomerAndContacts/"+id+"",null,function (data) {
					var html = "";
					$.each(data.u,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#edit-owner").html(html);
					var html = "<option></option>";
					$.each(data.cu,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#edit-customerId").html(html);
					//表单赋值
					$("#edit-id").val(data.co.id);
					$("#edit-owner").val(data.co.owner);
					$("#edit-source").val(data.co.source);
					$("#edit-customerId").val(data.co.customerId);
					$("#edit-fullname").val(data.co.fullname);
					$("#edit-appellation").val(data.co.appellation);
					$("#edit-email").val(data.co.email);
					$("#edit-mphone").val(data.co.mphone);
					$("#edit-job").val(data.co.job);
					$("#edit-birth").val(data.co.birth);
					$("#edit-description").val(data.co.description);
					$("#edit-contactSummary").val(data.co.contactSummary);
					$("#edit-nextContactTime").val(data.co.nextContactTime);
					$("#edit-address").val(data.co.address);
					//打开修改模态窗口
					$("#editContactsModal").modal("show");
				});
			}
		});

		//为更新按钮绑定时间，执行数据修改
		$("#updateBtn").click(function () {
			$.ajax({
				url:"contacts/doUpdate",
				data:{
					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"source" : $.trim($("#edit-source").val()),
					"customerId" : $.trim($("#edit-customerId").val()),
					"fullname" : $.trim($("#edit-fullname").val()),
					"appellation" : $.trim($("#edit-appellation").val()),
					"email" : $.trim($("#edit-email").val()),
					"mphone" : $.trim($("#edit-mphone").val()),
					"job" : $.trim($("#edit-job").val()),
					"birth" : $.trim($("#edit-birth").val()),
					"description" : $.trim($("#edit-description").val()),
					"contactSummary" : $.trim($("#edit-contactSummary").val()),
					"nextContactTime" : $.trim($("#edit-nextContactTime").val()),
					"address" : $.trim($("#edit-address").val()),
					"editBy" : "${user.name}"
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data){
						//关闭模态窗口
						$("#editContactsModal").modal("hide");
						pageList();
					}else{
						alert("修改联系人失败");
					}
				}
			});
		});

	});

	//用于分页查询数据的方法
	function pageList(pageNo,pageSize){
		$.ajax({
			url:"contacts/pageList",
			data:{
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"fullname" : $.trim($("#search-fullname").val()),
				"customerId" : $.trim($("#search-customerId").val()),
				"source" : $.trim($("#search-source").val()),
				"birth" : $.trim($("#search-birth").val()),
				"owner" : $.trim($("#search-owner").val()),
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//从后台取pageInfo数据，pageInfo：封装了分页有关的数据，比如list,total...
				var html = "";
				if(JSON.stringify(data.list) == "[]"){
					html += '<tr class="active"><td colspan="6" style="text-align: center">未找到相关记录</td></tr>';
				}else{
					//重新加载分页的时候取消全选的勾
					$("#qx").prop("checked",false);
					$.each(data.list,function (i,n) {
						html += '<tr class="active">';
						html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'contacts/toDetail/'+n.id+'\';">'+n.fullname+'</a></td>';
						html += '<td>'+n.customerId+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.source+'</td>';
						html += '<td>'+n.birth+'</td>';
						html += '</tr>';
					});
				}
				$("#contactsBody").html(html);
				//数据处理完后，结合分页查询，对前端展现分页信息
				new Pagination({
					element: '#contactsPage', // 渲染的容器  [必填]
					type: 1, // 样式类型，默认1 ，目前可选 [1,2] 可自行增加样式   [非必填]
					layout: 'total, sizes, home, prev, pager, next, last, jumper', // [必填]
					pageIndex: data.pageNum, // 当前页码 [非必填]
					pageSize: data.pageSize, // 每页显示条数   TODO: 如果使用了sizes这里就无须传参，传了也无效 [必填]
					pageCount: 9, // 页码显示数量，页码必须大于等于5的奇数，默认页码9  TODO:为了样式美观，参数只能为奇数， 否则会报错 [非必填]
					total: data.total, // 数据总条数 [必填]
					singlePageHide: false, // 单页隐藏， 默认true  如果为true页码少于一页则不会渲染 [非必填]
					pageSizes: [5,10, 20, 30, 40, 50], // 选择每页条数  TODO: layout的sizes属性存在才生效
					prevText: '上一页', // 上一页文字，不传默认为箭头图标  [非必填]
					nextText: '下一页', // 下一页文字，不传默认为箭头图标 [非必填]
					ellipsis: true, // 页码显示省略符 默认false  [非必填]
					disabled: true, // 显示禁用手势 默认false  [非必填]
					currentChange: function(index, pageSize) { // 页码改变时回调  TODO:第一个参数是当前页码，第二个参数是每页显示条数数量，需使用sizes第二参数才有值。
						pageList(index,pageSize);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true" id="closeForm">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="contactsAddForm" role="form">
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
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
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <option value="先生">先生</option>
								  <option value="夫人">夫人</option>
								  <option value="女士">女士</option>
								  <option value="博士">博士</option>
								  <option value="教授">教授</option>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date"  class="form-control time" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerId" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
<%--								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">--%>
                            <select class="form-control" id="create-customerId">

                            </select>
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="date" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="resetForm">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
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
						</div>
						
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <option value="先生">先生</option>
								  <option value="夫人">夫人</option>
								  <option value="女士">女士</option>
								  <option value="博士">博士</option>
								  <option value="教授">教授</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control time" id="edit-birth">
							</div>
						</div>

						<div class="form-group" style="position: relative;">
							<label for="edit-customerId" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerId">

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="date" class="form-control time" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" id="clueSearchForm" style="position: relative;top: 8%; left: 5px;">
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerId">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
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
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control time" type="date" id="search-birth">
				    </div>
				  </div>
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  <button type="button" id="clearBtn" class="btn btn-default">清空查询</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: -30px;">
				<div id="contactsPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>