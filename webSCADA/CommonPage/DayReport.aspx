<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DayReport.aspx.cs" Inherits="webSCADA.CommonPage.DayReport" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">

    <div>

        <div class="middle">
            <form method="post" action="DayReport.aspx">
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
                        return "日报表.xls";
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
