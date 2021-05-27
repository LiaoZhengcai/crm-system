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
			$("#tranSearchForm")[0].reset();
			pageList();
		});

        //为全选的复选框绑定事件，触发全选操作
        $("#qx").click(function () {
            $("input[name=xz]").prop("checked",this.checked);
        });
        //动态生成的元素，我们要以on的形式绑定元素的有效外层元素来触发事件
        $("#tranBody").on("click",$("input[name=xz]"),function () {
            $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
        });

        //为修改按钮绑定事件，转向到修改页面
        $("#editBtn").click(function () {
            var $xz = $("input[name=xz]:checked");
            if($xz.length==0){
                alert("请选择需要修改的记录");
            }else if ($xz.length>1){
                alert("只能选择一条记录进行修改");
            }else{
                var id = $xz.val();
                window.location.href="tran/getUserAndCustomerAndTran/"+id+"";
            }
        });

		//为删除按钮绑定事件执行交易信息删除操作
		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if(confirm("您确定要删除吗？")){
				if($xz.length==0){
					alert("请选择需要删除的记录");
				}else{
					var param = $xz.serialize();
					$.post("tran/doDelete",param,function (data) {
						if(data){
							pageList();
						}else{
							alert("删除失败");
						}
					});
				}
			}
		});


	});

	//用于分页查询数据的方法
	function pageList(pageNo,pageSize){
		$.ajax({
			url:"tran/pageList",
			data:{
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"owner" : $.trim($("#search-owner").val()),
				"name" : $.trim($("#search-name").val()),
				"customerId" : $.trim($("#search-customerId").val()),
				"stage" : $.trim($("#search-stage").val()),
				"type" : $.trim($("#search-type").val()),
				"source" : $.trim($("#search-source").val()),
				"contactsId" : $.trim($("#search-contactsId").val()),
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
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'tran/toDetail/'+n.id+'\';">'+n.name+'</a></td>';
						html += '<td>'+n.customerId+'</td>';
						html += '<td>'+n.stage+'</td>';
						html += '<td>'+n.type+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.source+'</td>';
						html += '<td>'+n.contactsId+'</td>';
						html += '</tr>';
					});
				}
				$("#tranBody").html(html);
				//数据处理完后，结合分页查询，对前端展现分页信息
				new Pagination({
					element: '#tranPage', // 渲染的容器  [必填]
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

	
	
	<div>
		<div style="position: relative; left: 10px; top: -30px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" id="tranSearchForm" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
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
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control"  id="search-stage">
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
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control"  id="search-type">
					  	<option></option>
					  	<option>已有业务</option>
					  	<option>新业务</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control"  id="search-source">
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
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsId">
				    </div>
				  </div>
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  <button type="button" id="clearBtn" class="btn btn-default">清空查询</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='tran/toSave';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
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
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: -20px;">
				<div id="tranPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>