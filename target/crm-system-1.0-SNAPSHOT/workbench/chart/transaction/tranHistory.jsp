<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
    <script type="text/javascript" src="ECharts/echarts.min.js"></script>
    <script type="text/javascript" src="jquery/jquery-3.3.1.min.js"></script>
    <script type="text/javascript">
        $(function () {
            getCharts();
        });

        function getCharts(){
            // 基于准备好的dom，初始化echarts实例
            var myChart = echarts.init(document.getElementById('main'));
            $.ajax({
                url : "tran/getTranHistory",
                data: {
                    
                },
                type : "get",
                dataType : "json",
                success : function (data) {
                    var names = [];
                    var values = [];
                    for (var i=0;i<data.length;i++){
                        names.push(data[i].name);
                        values.push(data[i].value)
                    }
                    var option = {
                        title: {
                            text: '历史交易数据柱状图',
                            subtext: '统计交易阶段数量的柱状图'
                        },
                        xAxis: {
                            type: 'category',
                            data:names
                                // ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        },
                        yAxis: {
                            type: 'value'
                        },
                        series: [{
                            data: values,
                            // [120, 200, 150, 80, 70, 110, 130]
                            type: 'bar',
                            showBackground: true,
                            backgroundStyle: {
                                color: 'rgba(180, 180, 180, 0.2)'
                            }
                        }]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            });
        }

    </script>
</head>
<body>
    <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main" style="width: 100%;height:400px;"></div>

</body>
</html>
