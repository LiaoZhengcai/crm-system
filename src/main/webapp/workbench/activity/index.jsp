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
		//页面加载完毕触发一个方法，默认展开市场活动信息列表
		pageList();

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

	    //为创建按钮绑定时间，打开添加操作的模态窗口
		$("#addBtn").click(function () {
            //操作模态窗口的jquery对象，调用modal方法，为该方法传递参数  show：打开，hide：关闭
            //$("#createActivityModal").modal("show");
            //去后台取所有者信息，展现到添加模态窗口。
            $.ajax({
                url:"activity/getUserList",
                type:"get",
                dataType:"json",
                success:function (data) {
                    var html = "";
                    //i:第几个，n:每一个user对象
                    $.each(data,function (i,n) {
                        html += "<option value='"+n.id+"'>"+n.name+"</option>";
                    });
                    $("#create-Owner").html(html);
					//$("#create-Owner option:first").remove();
                    //将当前登录的用户设置为下拉框默认的选项
					var id = "${user.id}";
					$("#create-Owner").val(id);
                    //获取所有者信息再打开模态窗口
                    $("#createActivityModal").modal("show");
                }
            });
        });

		//点x,点关闭按钮触发清空form表单
		$("#resetForm,#closeForm").click(function () {
			$("#activityAddForm")[0].reset();
			$("#createActivityModal").modal("hide");
		});
		//为保存按钮绑定事件，执行添加操作
		$("#saveBtn").click(function () {
			$.ajax({
				url:"activity/addActivity",
				data:{
					"owner" : $.trim($("#create-Owner").val()),
					"name" : $.trim($("#create-name").val()),
					"startDate" : $.trim($("#create-startDate").val()),
					"endDate" : $.trim($("#create-endDate").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val()),
					"createBy" : "${user.name}",
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data){
						//清空表单
						$("#activityAddForm")[0].reset();
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
						//添加成功后刷新市场活动信息列表（局部刷新）
						pageList();
					}else{
						alert("添加市场活动失败！");
					}
				}
			});
		});

		//为查询按钮绑定事件，触发pageList方法
        $("#searchBtn").click(function () {
            pageList();
        });
        //为取消查询按钮绑定事件
		$("#clearBtn").click(function () {
			$("#activitySearchForm")[0].reset();
			pageList();
		});
        //为全选的复选框绑定事件，触发全选操作
        $("#qx").click(function () {
            $("input[name=xz]").prop("checked",this.checked);
        });
        //动态生成的元素，我们要以on的形式绑定元素的有效外层元素来触发事件
        $("#activityBody").on("click",$("input[name=xz]"),function () {
            $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
        });
        //为删除按钮绑定事件执行市场活动信息删除操作
		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if(confirm("您确定要删除吗？")){
				if($xz.length==0){
					alert("请选择需要删除的记录");
				}else{
					var param = $xz.serialize();
					$.post("activity/doDelete",param,function (data) {
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
				$.get("activity/getUserListAndActivity/"+id+"",null,function (data) {
					var html = "";
					$.each(data.uList,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#edit-owner").html(html);
					//表单赋值
					$("#edit-id").val(data.a.id);
					$("#edit-name").val(data.a.name);
					$("#edit-owner").val(data.a.owner);
					$("#edit-startDate").val(data.a.startDate);
					$("#edit-endDate").val(data.a.endDate);
					$("#edit-cost").val(data.a.cost);
					$("#edit-description").val(data.a.description);
					//打开修改模态窗口
					$("#editActivityModal").modal("show");
				});
			}
		});

		//为更新按钮绑定事件，执行市场活动的修改
		$("#updateBtn").click(function () {
			$.ajax({
				url:"activity/doUpdate",
				data:{
					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"name" : $.trim($("#edit-name").val()),
					"startDate" : $.trim($("#edit-startDate").val()),
					"endDate" : $.trim($("#edit-endDate").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-description").val()),
					"editBy" : "${user.name}",
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data){
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
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
			url:"activity/pageList",
			data:{
				"pageNo" : pageNo,
				"pageSize" : pageSize,
                "name" : $.trim($("#search-name").val()),
                "owner" : $.trim($("#search-owner").val()),
                "startDate" : $.trim($("#search-startDate").val()),
                "endDate" : $.trim($("#search-endDate").val()),
			},
			type:"get",
			dataType:"json",
			success:function (data) {
                //从后台取pageInfo数据，pageInfo：封装了分页有关的数据，比如list,total...
                var html = "";
                if(JSON.stringify(data.list) == "[]"){
					html += '<tr class="active"><td colspan="5" style="text-align: center">未找到相关记录</td></tr>';
				}else{
                	//重新加载分页的时候取消全选的勾
					$("#qx").prop("checked",false);
					$.each(data.list,function (i,n) {
						html += '<tr class="active">';
						html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'activity/toDetail/'+n.id+'\';">'+n.name+'</a></td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.startDate+'</td>';
						html += '<td>'+n.endDate+'</td>';
						html += '</tr>';
					});
				}
				$("#activityBody").html(html);
                //数据处理完后，结合分页查询，对前端展现分页信息
				new Pagination({
					element: '#activityPage', // 渲染的容器  [必填]
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

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
<%--                    data-dismiss="modal"--%>
					<button type="button" class="close" id="closeForm">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-Owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-Owner"></select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control time" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<!-- data-dismiss="modal":表示关闭模态窗口 -->
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="resetForm">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control time" id="edit-startDate">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="date" class="form-control time" id="edit-endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
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
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" id="activitySearchForm" role="form" style="position: relative;top: 8%; left: 5px;">
					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">名称</div>
							<input class="form-control" type="text" id="search-name">
						</div>
					</div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">所有者</div>
							<input class="form-control" type="text" id="search-owner">
						</div>
					</div>


					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">开始日期</div>
							<input class="form-control time" type="date" id="search-startDate" />
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">结束日期</div>
							<input class="form-control time" type="date" id="search-endDate">
						</div>
					</div>
					<br>
					<button type="button" id="searchBtn" class="btn btn-default">查询</button>
					<button type="button" id="clearBtn" class="btn btn-default">清空查询</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!-- 这里把模态窗口改成自己用JS代码来控制，不能写死在元素中 data-toggle="modal" data-target="#createActivityModal"  data-toggle="modal" data-target="#editActivityModal"-->
					<button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
					<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
					<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>

			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
					<tr style="color: #B3B3B3;">
						<td><input type="checkbox" id="qx"/></td>
						<td>名称</td>
						<td>所有者</td>
						<td>开始日期</td>
						<td>结束日期</td>
					</tr>
					</thead>
					<tbody id="activityBody">
<%--					<tr class="active">--%>
<%--						<td><input type="checkbox" /></td>--%>
<%--						<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--						<td>zhangsan</td>--%>
<%--						<td>2020-10-10</td>--%>
<%--						<td>2020-10-20</td>--%>
<%--					</tr>--%>
					</tbody>
				</table>
			</div>
            <div style="height: 30px; position: relative;top: -50px;">
                <div id="activityPage"></div>
            </div>

		</div>

	</div>
</body>
</html>