<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CumulantDayReport.aspx.cs" Inherits="webSCADA.CommonPage.CumulantDayReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>累积量日报表</title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">

    <div>

        <div class="middle">
            <form method="post" action="CumulantDayReport.aspx">
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

        <div id="reportDataContainer" class="marTB">
            <asp:Literal ID="litContent" runat="server" />
        </div>

    </div>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/Downloadify/swfobject.js"></script>
    <script src="../Scripts/Downloadify/downloadify.min.js"></script>
    <script>

        $(function () {

            var tab = $('table.listview');
            var colTotal = tab.find('thead th').length - 1;
            var html = '<tfoot>';
            
                html += '<tr><td>当天用水量</td>';
                for (var j = 0; j < colTotal; j++) {
                    html += '<td></td>';
                }
                html += '</tr>';

            html += '</tfoot>';
            tab.append(html);

            for (var k = 1; k <= colTotal; k++) {
                var firstValue = tab.find('tbody tr:eq(0) td:eq(' + (k) + ')').text();
                var lastValue = tab.find('tbody tr:last td:eq(' + (k) + ')').text();
                if ((firstValue !== '') && (lastValue !== '')) {
                    var diff = parseFloat(lastValue) - parseFloat(firstValue);
                    tab.find('tfoot tr td:eq(' + (k) + ')').text(diff.toFixed(2));
                }
            }

            if ($('#downloadify').length > 0) {
                Downloadify.create('downloadify', {
                    filename: function () {
                        return "累积量日报表.xls";
                    },
                    data: function () {
                        return '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>caption{font-size:20px;} table{width:100%;border-collapse:collapse;} th,td{text-align:center;border:1px solid #ccc;}</style></head><body>' + $('#reportDataContainer').html() + '</body></html>';
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
