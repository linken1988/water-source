<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConcernedStation.aspx.cs" Inherits="webSCADA.CommonPage.ConcernedStation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    <div>
        <form action="Handler/ConcernedStation.ashx" method="post">
            <input type="hidden" name="data" id="data" />
            <input accesskey="Append" id="btnSubmit" type="submit" value="从左侧树视图'勾选'想要加入关注的站点然后点击这里" />
        </form>
    </div>

    <div>
        <asp:DataList CellSpacing="-1"  RepeatColumns="4" RepeatLayout="Table" ID="ds" runat="server">
            <ItemTemplate>
                <%# Eval("StationName") %>(<%# Eval("EquipmentName") %>)<dl data-stationsn="<%# Eval("StationSN") %>">
                <asp:Repeater DataSource="<%# (Container.DataItem as webSCADA.DAL.ConcernedStation).Sensors %>" ID="rep" runat="server">
                    <ItemTemplate>
                        <dd data-channel="<%# (Container.DataItem as webSCADA.DAL.Sensor).Channel %>"><%# (Container.DataItem as webSCADA.DAL.Sensor).SensorName %> : <span></span> <%# string.IsNullOrWhiteSpace((Container.DataItem as webSCADA.DAL.Sensor).Unit) ? "" : string.Format("({0})",(Container.DataItem as webSCADA.DAL.Sensor).Unit ) %></dd>
                    </ItemTemplate>
                </asp:Repeater></dl><a><img src="/images/x.png" /></a>
            </ItemTemplate>
        </asp:DataList>
    </div>

    <asp:Literal ID="litmsg" runat="server" />

    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/jquery.signalR-2.0.3.min.js"></script>
    <script src="/signalr/hubs"></script>
    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>
    <script>

        $(function () {

            var noticeHub = $.connection.noticeHub;

            function showData(data) {
                var jqStationData = JSON.parse(data);
                if (isExistsStation(jqStationData.StationSN)) {
                    var dl = $("dl[data-stationsn='" + jqStationData.StationSN + "']");
                    dl.children().each(function () {
                        var dd = $(this);
                        var channel = dd.data('channel');
                        if (jqStationData.Data[channel] instanceof Array) {
                            var array = jqStationData.Data[channel];
                            var val = array[array.length - 1];
                            if (channel.charAt(0) === 'K') {
                                val = val === 1 ? '关' : '开';
                            }
                            dd.children("span:last-child").text(val);
                        }
                    });
                }
            };

            noticeHub.client.broadcastStationData = function (data) {
                showData(data);
            }

            $.connection.hub.start().done(function () {
                //console.log('实时数据页连接服务器成功');
            });

            $.connection.hub.error(function (error) {
                console.log('连接SignalR时发生错误: ' + error)
            });

            function isExistsStation(stationSN) {
                var stations = $("dl[data-stationsn='" + stationSN + "']");
                return (stations.length)===1;
            }

            $('a').click(function () {
                var elem = $(this);
                var dl = elem.prev();
                var stationSN = dl.data('stationsn');
                if (window.confirm('确定要移除对该站点的关注吗？')) {
                    $.ajax({
                        type: "post",
                        url: 'Handler/ConcernedStation.ashx?' + new Date().getTime(),
                        cache: false,
                        data: "stationSN=" + stationSN,
                        beforeSend: function (jqXHR, settings) {
                            jqXHR.setRequestHeader('action', "Delete");
                            elem.attr("disabled", true);
                        },
                        success: function (data, textStatus, jqXHR) {
                            if (data === '操作成功') {
                                window.location.reload(true);
                            } else {
                                alert(data);
                                elem.attr("disabled", false);
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            elem.attr("disabled", false);
                            alert(errorThrown);
                        }
                    });
                }
            });

            $("form").submit(function (event) {
                var checkedStations = parent.getAllCheckedStations();
                if (checkedStations <= 0) {
                    alert('请从左侧树视图中至少勾选一个站点');
                    return false;
                }

                $('#data').val(checkedStations.toString());
                var btnSubmit = $("#btnSubmit");
                var text = btnSubmit.text();
                event.preventDefault();
                if (window.confirm('确定要加入到关注站点吗？')) {

                    $.ajax({
                        type: $(this).attr("method"),
                        url: $(this).attr("action") + '?' + new Date().getTime(),
                        cache: false,
                        data: $(this).serialize(),
                        beforeSend: function (jqXHR, settings) {
                            jqXHR.setRequestHeader('action', btnSubmit.attr("accesskey"));
                            btnSubmit.attr("disabled", true);
                        },
                        success: function (data, textStatus, jqXHR) {
                            if (data === '操作成功') {
                                window.location.reload(true);
                            } else {
                                alert(data);
                                btnSubmit.attr("disabled", false);
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            btnSubmit.attr("disabled", false);
                            alert(errorThrown);
                        }
                    });

                };
            });

            $('dl').each(function (index, element) {
                var stationSN = ($(element).data('stationsn'));
                var lastStationData = localStorage[String.format('RealTimeData-{0}', stationSN)];
                if (!!lastStationData) {
                    showData(lastStationData);
                };

            });

        });

    </script>

</body>
</html>
