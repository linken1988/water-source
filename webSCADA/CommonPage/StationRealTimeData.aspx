<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StationRealTimeData.aspx.cs" Inherits="webSCADA.CommonPage.StationRealTimeData" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    <table class="listview">
        <caption id="caption" runat="server">
            <h1 id="stationName" runat="server"></h1>
            <h2 id="stationMeta" runat="server"></h2>
        </caption>
        <thead>
            <tr>
                <th data-channel="Interval">采集时间</th>
                <asp:Repeater ID="rep" runat="server">
                    <ItemTemplate>
                        <th data-channel="<%# Eval("Item2") %>"><%# Eval("Item1") %><%# string.IsNullOrWhiteSpace(Eval("Item3") as string) ? "" : string.Format("({0})",Eval("Item3")) %></th>
                    </ItemTemplate>
                </asp:Repeater>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>

    <asp:Literal ID="lit" runat="server" />

    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/jquery.signalR-2.0.3.min.js"></script>
    <script src="/signalr/hubs"></script>
    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>
    
    <script>

        $(function () {

            var noticeHub = $.connection.noticeHub;
            var maxRecordNumber = 20;

            noticeHub.client.broadcastStationData = function (data) {
                var jqStationData = JSON.parse(data);
                if ($('#caption').attr('accesskey') == jqStationData.StationSN) {
                    if ($('tbody tr').length > maxRecordNumber) {
                        $('tbody tr:last-Child').remove();
                    };
                    appendRow(jqStationData);
                };
            };

            $.connection.hub.start().done(function () {
                //console.log('实时数据页连接服务器成功');
            });

            $.connection.hub.error(function (error) {
                console.log('连接SignalR时发生错误: ' + error)
            });

            var ths = $('th');

            function appendRow(stationData) {
                var tr = ['<tr>'];
                $.each(ths, function (index, elem) {
                    var th = $(elem);
                    var channel = th.data('channel');
                    if (channel === 'Interval') {
                        tr.push(String.format('<td>{0}</td>', stationData.Interval[stationData.Interval.length - 1]));
                    } else {
                        var array = stationData.Data[channel];
                        if (array !== undefined) {
                            var val = array[array.length - 1];
                            var strVal = val.toFixed(2);
                            var firstChar=channel.charAt(0);
                            if ( firstChar=== 'K') {
                                tr.push(String.format('<td>{0}</td>', val === 1 ? '关' : '开'));
                            } else if ((firstChar === 'A' && strVal === '99999.00') || (firstChar === 'P' && strVal === '99999999.00')) {
                                tr.push('<td></td>');
                            }else {
                                tr.push(String.format('<td>{0}</td>', val));
                            };
                        } else {
                            tr.push("<td></td>");
                        };
                    };
                });
                tr.push('</tr>');
                $('tbody').prepend(tr.join(''));
            };
            
            var lastStationData = localStorage[String.format('RealTimeData-{0}', $("#caption").attr("accesskey"))];
            if (!!lastStationData) {
                appendRow(JSON.parse(lastStationData));
            };
        });

    </script>

</body>
</html>
