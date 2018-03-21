<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnalogStatisticsByDay.aspx.cs" Inherits="webSCADA.CommonPage.AnalogStatisticsByDay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>模拟量日统计报表</title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">

    <div>

        <div class="middle">
            <form method="post" action="AnalogStatisticsByDay.aspx">
                请选择日期
                <input type="date" id="_StartDate" runat="server" />
                时间间隔
                <select runat="server" id="_IntervalTime">
                </select> 分钟
                <input type="submit" value="查询" />
                <input type="hidden" id="_QueryQueue" runat="server" />
            </form>
        </div>

        <div class="alignRight" runat="server" visible="false" id="downloadify">必须先安装Flash 10及以上版本。</div>

        <div id="reportAnalogStatisticsByDay" class="marTB">
            <asp:Literal ID="litContent" runat="server" />
        </div>

    </div>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/Downloadify/swfobject.js"></script>
    <script src="../Scripts/Downloadify/downloadify.min.js"></script>
    <script>

        $(function () {

            function getThName(i) {
                switch (i) {
                    case 1: return "最小值";
                    case 2: return "最大值";
                    default: return "平均值";
                }
            }

            var tab = $('table.listview');
            var colTotal = tab.find('thead th').length-1;
            var html = '<tfoot>';
            for (var i = 1; i <= 3; i++) {
                html += '<tr><td data-type="' + i + '">' + getThName(i) + '</td>';
                for (var j = 0; j < colTotal; j++) {
                    html += '<td></td>';
                }
                html += '</tr>';
            }
            html += '</tfoot>';
            tab.append(html);

            for (var k = 1; k <= colTotal; k++) {
                var data = [];
                tab.find("tbody td:nth-child(" + (k + 1) + ")").each(function (index, element) {
                    var text=$(this).text();
                    if(text!==''){
                        data.push([index,parseFloat(text)]);
                    }
                });
                data.sort(function (x, y) { return x[1] - y[1]; });
                //console.log(data, '==========');
                if (data.length > 0) {
                    var min = data[0][1];
                    var max = data[data.length - 1][1];
                    var total = 0;
                    for (var m = 0; m < data.length; m++) {
                        total += parseFloat(data[m][1]);
                    }
                    var avg = (total / (data.length));
                    (tab.find('tfoot tr:eq(0) td:eq(' + (k) + ')').html(min.toFixed(2) + '<br />' + tab.find('tbody tr:eq(' + data[0][0] + ') td:eq(0)').text()));
                    (tab.find('tfoot tr:eq(1) td:eq(' + (k) + ')').html(max.toFixed(2) + '<br />' + tab.find('tbody tr:eq(' + data[data.length-1][0] + ') td:eq(0)').text()));
                    (tab.find('tfoot tr:eq(2) td:eq(' + (k) + ')').text(avg.toFixed(2)));
                }
            }

            if ($('#downloadify').length > 0) {
                Downloadify.create('downloadify', {
                    filename: function () {
                        return "模拟量日统计报表.xls";
                    },
                    data: function () {
                        return '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>caption{font-size:20px;} table{width:100%;border-collapse:collapse;} th,td{text-align:center;border:1px solid #ccc;}</style></head><body>' + $('#reportAnalogStatisticsByDay').html() + '</body></html>';
                    },
                    onComplete: function () { alert('已经成功导出报表'); },
                    onCancel: function () { /*alert('导出报表被取消');*/ },
                    onError: function () { alert('发生错误，请确定报表中有内容。'); },
                    transparent: false,
                    swf: '/images/downloadify.swf',
                    downloadImage: '/images/download.png',
                    width: 100,
                    height: 30,
                    transparent: true,
                    append: false
                });
            };


            $('form').submit(function (event) {

                var checkedSensors = parent.getAllCheckedSensor();
                if (checkedSensors.length === 0) {
                    alert('请从树视图中选择传感器');
                    event.preventDefault();
                    return;
                } else {
                    $('#_QueryQueue').val(checkedSensors.toString());
                };

            });

            

        });

    </script>

</body>
</html>
