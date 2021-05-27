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

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
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
				url : "clue/getUserList",
				type : "get",
				dataType : "json",
				success : function (data) {
					var html = "";
					$.each(data,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#create-owner").html(html);
					var id = "${user.id}";
					$("#create-owner").val(id);
					//处理完所有者下拉框数据后，打开模态窗口
					$("#createClueModal").modal("show");
				}
			});
		});

		//点x,点关闭按钮触发清空form表单
		$("#resetForm,#closeForm").click(function () {
			$("#clueAddForm")[0].reset();
			$("#createClueModal").modal("hide");
		});

		//为保存按钮绑定事件，执行线索添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url : "clue/saveClue",
				data : {
					"fullname" : $.trim($("#create-fullname").val()),
					"appellation" : $.trim($("#create-appellation").val()),
					"owner" : $.trim($("#create-owner").val()),
					"company" : $.trim($("#create-company").val()),
					"job" : $.trim($("#create-job").val()),
					"email" : $.trim($("#create-email").val()),
					"phone" : $.trim($("#create-phone").val()),
					"website" : $.trim($("#create-website").val()),
					"mphone" : $.trim($("#create-mphone").val()),
					"state" : $.trim($("#create-state").val()),
					"source" : $.trim($("#create-source").val()),
					"createBy" : "${user.name}",
					"description" : $.trim($("#create-description").val()),
					"contactSummary" : $.trim($("#create-contactSummary").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime").val()),
					"address" : $.trim($("#create-address").val())
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					if(data){
						//清空表单
						$("#clueAddForm")[0].reset();
						//关闭模态窗口
						$("#createClueModal").modal("hide");
						//刷新列表
						pageList();
					}else{
						alert("添加线索失败");
					}
				}
			});
		});

		//为全选的复选框绑定事件，触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});

		//动态生成的元素，我们要以on的形式绑定元素的有效外层元素来触发事件
		$("#clueBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		});

		//为删除按钮绑定事件执行线索信息删除操作
		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if(confirm("您确定要删除吗？")){
				if($xz.length==0){
					alert("请选择需要删除的记录");
				}else{
					var param = $xz.serialize();
					$.post("clue/doDelete",param,function (data) {
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
				$.get("clue/getUserListAndClue/"+id+"",null,function (data) {
					var html = "";
					$.each(data.uList,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#edit-owner").html(html);
					//表单赋值
					$("#edit-id").val(data.c.id);
					$("#edit-owner").val(data.c.owner);
					$("#edit-company").val(data.c.company);
					$("#edit-appellation").val(data.c.appellation);
					$("#edit-fullname").val(data.c.fullname);
					$("#edit-job").val(data.c.job);
					$("#edit-email").val(data.c.email);
					$("#edit-phone").val(data.c.phone);
					$("#edit-website").val(data.c.website);
					$("#edit-mphone").val(data.c.mphone);
					$("#edit-state").val(data.c.state);
					$("#edit-source").val(data.c.source);
					$("#edit-description").val(data.c.description);
					$("#edit-contactSummary").val(data.c.contactSummary);
					$("#edit-nextContactTime").val(data.c.nextContactTime);
					$("#edit-address").val(data.c.address);
					//打开修改模态窗口
					$("#editClueModal").modal("show");
				});
			}
		});

		//为更新按钮绑定时间，执行数据修改
		$("#updateBtn").click(function () {
			$.ajax({
				url:"clue/doUpdate",
				data:{
					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"company" : $.trim($("#edit-company").val()),
					"appellation" : $.trim($("#edit-appellation").val()),
					"fullname" : $.trim($("#edit-fullname").val()),
					"job" : $.trim($("#edit-job").val()),
					"email" : $.trim($("#edit-email").val()),
					"phone" : $.trim($("#edit-phone").val()),
					"website" : $.trim($("#edit-website").val()),
					"mphone" : $.trim($("#edit-mphone").val()),
					"state" : $.trim($("#edit-state").val()),
					"source" : $.trim($("#edit-source").val()),
					"description" : $.trim($("#edit-description").val()),
					"contactSummary" : $.trim($("#edit-contactSummary").val()),
					"nextContactTime" : $.trim($("#edit-nextContactTime").val()),
					"address" : $.trim($("#edit-address"    ).val()),
					"editBy" : "${user.name}"
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data){
						//关闭模态窗口
						$("#editClueModal").modal("hide");
						//添加成功后刷新市场活动信息列表（局部刷新）
						pageList();
					}else{
						alert("修改市场活动失败！");
					}
				}
			});
		});
	});


	//用于分页查询数据的方法
	function pageList(pageNo,pageSize){
		$.ajax({
			url:"clue/pageList",
			data:{
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"fullname" : $.trim($("#search-fullname").val()),
				"company" : $.trim($("#search-company").val()),
				"phone" : $.trim($("#search-phone").val()),
				"source" : $.trim($("#search-source").val()),
				"owner" : $.trim($("#search-owner").val()),
				"mphone" : $.trim($("#search-mphone").val()),
				"state" : $.trim($("#search-state").val())
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//从后台取pageInfo数据，pageInfo：封装了分页有关的数据，比如list,total...
				var html = "";
				if(JSON.stringify(data.list) == "[]"){
					html += '<tr class="active"><td colspan="8" style="text-align: center">未找到相关记录</td></tr>';
				}else{
					//重新加载分页的时候取消全选的勾
					$("#qx").prop("checked",false);
					$.each(data.list,function (i,n) {
						html += '<tr class="active">';
						html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'clue/toDetail/'+n.id+'\';">'+n.fullname+'</a></td>';
						html += '<td>'+n.company+'</td>';
						html += '<td>'+n.phone+'</td>';
						html += '<td>'+n.mphone+'</td>';
						html += '<td>'+n.source+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.state+'</td>';
						html += '</tr>';
					});
				}
				$("#clueBody").html(html);
				//数据处理完后，结合分页查询，对前端展现分页信息
				new Pagination({
					element: '#cluePage', // 渲染的容器  [必填]
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

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true" id="closeForm">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="clueAddForm" role="form">

						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>

						<div class="form-group">
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
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>

						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>

						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>

						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
									<option></option>
									<option value="试图联系">试图联系</option>
									<option value="将来联系">将来联系</option>
									<option value="已联系">已联系</option>
									<option value="虚假线索">虚假线索</option>
									<option value="丢失线索">丢失线索</option>
									<option value="未联系">未联系</option>
									<option value="需要条件">需要条件</option>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
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
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
									<input type="text" readonly="readonly" class="form-control time" id="create-nextContactTime">
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
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
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
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
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
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
								  <option value="试图联系">试图联系</option>
								  <option value="将来联系">将来联系</option>
								  <option value="已联系">已联系</option>
								  <option value="虚假线索">虚假线索</option>
								  <option value="丢失线索">丢失线索</option>
								  <option value="未联系">未联系</option>
								  <option value="需要条件">需要条件</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
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
									<input type="text" readonly="readonly" class="form-control time" id="edit-nextContactTime">
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
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar"  style="height: 80px;">
				<form class="form-inline" id="clueSearchForm"  role="form" style="position: relative;top: 8%; left: 5px;">
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="search-fullname" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" id="search-company" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="search-phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
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
				  <br>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="search-owner" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" id="search-mphone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
					  	<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  <button type="button" id="clearBtn" class="btn btn-default">清空查询</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 30px; position: relative;top: -10px;">
				<div id="cluePage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>