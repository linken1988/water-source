<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StationHistoryData.aspx.cs" Inherits="webSCADA.CommonPage.StationHistoryData" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
   
    <div class="alignRight marTB prompt">请注意：查询日期跨越太长可能会导致查询时间过长。</div>

    <div class="middle marTB">
        <form method="post" action="StationHistoryData.aspx">
           查询时间介于 <input type="datetime-local" id="StartDateTime" runat="server" /> 至 <input type="datetime-local" id="EndDateTime" runat="server" /> 
            <input type="hidden" id="StationSN" name="StationSN" /><input type="submit" value="查询" />
        </form>
    </div>

    <div class="marTB alignRight" visible="false" id="chartControl" runat="server">
        <button accesskey="A" value="0">模拟量图表</button>
        <button accesskey="P" value="1">累积量图表</button>
        <button value="-1">隐藏图表</button>
    </div>

    <div id="chart"></div>

     <table class="listview" data-graph-container="#chart" data-graph-type="spline" data-graph-xaxis-labels-enabled="0" data-graph-yaxis-1-formatter-callback="yAxisFormat">
        <asp:Literal ID="lit" runat="server" />
    </table>

    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/DatePicker/WdatePicker.js"></script>
    <script src="../Scripts/chart/highcharts.js"></script>
    <script src="../Scripts/jquery.highchartTable.js"></script>
    <script>

        function yAxisFormat(value) { return value.toFixed(1); };

        $(function () {

            $('form').submit(function (event) {
                if (parent.selectedNodeID.charAt(0) !== 'S') {
                    event.preventDefault();
                    alert('请从树视图中选择一个站点');
                } else {
                    $('#StationSN').val(parseInt(parent.selectedNodeID.replace('S', '')));
                };
            });


            $('button').click(function () {
                var button = $(this);
                var val = button.val();
                if (val === '-1') {
                    $('#chart').hide();
                    parent.toggleSidebar('show');
                    $("#anchorSide", window.parent.document).text('隐藏边栏');
                } else {
                    parent.toggleSidebar('hide');
                    $("#anchorSide", window.parent.document).text('显示边栏');

                    var ths = $('table thead').find('th').not(':eq(0)').data('graph-skip', 1);
                    var channelType = button.attr('accesskey');
                    $.each(ths, function (index, elem) {
                        var th = $(this);
                        if (th.data('channel').charAt(0) === channelType) {
                            th.removeData('graph-skip');
                        };
                    });

                    $('#chart').show();
                    $('table.listview').highchartTable();

                };
            });



        });

    </script>

</body>
</html>
