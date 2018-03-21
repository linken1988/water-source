<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LeakageAnalysis.aspx.cs" Inherits="webSCADA.CommonPage.LeakageAnalysis" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>漏损分析</title>
    <link href="../common.css" rel="stylesheet" />
</head>
    <body class="margin">

    <div>

        <div class="middle">
            <form method="post" action="LeakageAnalysis.aspx">
                请选择日期
                <input type="date" id="StartDate" runat="server" />
                <input type="submit" value="查询" />
                <input type="hidden" id="SensorID" runat="server" />
            </form>
        </div>

        <div class="alignRight" runat="server" visible="false" id="downloadify">必须先安装Flash 10及以上版本。</div>

        <div id="reportData" class="marTB">
            <asp:Literal ID="litContent" runat="server" />
        </div>

    </div>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/Downloadify/swfobject.js"></script>
    <script src="../Scripts/Downloadify/downloadify.min.js"></script>
    <script>

        $(function () {

            if ($('#downloadify').length > 0) {
                Downloadify.create('downloadify', {
                    filename: function () {
                        return "漏损分析报表.xls";
                    },
                    data: function () {
                        return '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>caption{font-size:20px;} table{width:100%;border-collapse:collapse;} th,td{text-align:center;border:1px solid #ccc;}</style></head><body>' + $('#reportData').html() + '</body></html>';
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

            var columnsCount = parseInt($('table').data('colsize'));
            if (columnsCount>0) {
                columnsCount--;
            }

            var rows = $('table tbody tr');
            rows.each(function (index, elem) {
                var $elem = $(elem);
                var arr = [];
                for (var i = 1; i <= columnsCount; i++) {
                    var val = $elem.find("td:nth-child(" + (i+1) + ")").text();
                    arr.push(val);                    
                }
                var result = arr.every(function (val) { return val !== ''; });
                if (result) {
                    var indexZero = parseFloat(arr[0]);
                    var sum = arr.reduce(function (x, y) { return parseFloat(x) + parseFloat(y); });
                    sum -= indexZero;
                    var output = indexZero - sum;
                    $elem.find('td:nth-last-child(2)').text(output.toFixed(2));
                    $elem.find('td:nth-last-child(1)').text(((output / indexZero)*100).toFixed(2) + '%');
                }
            });


        });

    </script>

</body>

</html>
