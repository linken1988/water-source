<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="webSCADA.CommonPage.Default" %>
<!DOCTYPE html>
<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../layout.css" rel="stylesheet" />
    <link href="../common.css" rel="stylesheet" />
    <link href="/Scripts/tree/dhtmlxtree.css" rel="stylesheet" />
</head>
<body>

    <header>
        <h1><%=System.Configuration.ConfigurationManager.AppSettings["systemName"] %></h1>
        <div><span id="clientDatetime"></span> <span runat="server" id="currentWeather"></span> 欢迎您：<%=User.Identity.Name %> <%=User.IsInRole("Administrator") ? "管理员" : "用户" %></div>
    </header>

    <nav>
        <table>
            <tr>
                <td><a href="###" id="anchorSide">隐藏边栏</a></td>
                <td><a target="navigate" href="Map.aspx">站点地图</a></td>                
                <td><a target="navigate" href="SensorRelations.aspx">漏损关系</a></td>
                <td><a target="navigate" href="ConcernedStation.aspx">关注站点</a></td>
                <td><a class="group" target="navigate" href="StationRealTimeData.aspx">实时数据</a></td>
                <td><a target="navigate" href="CurveAnalysis.aspx">曲线分析</a></td>
                <td><a class="group" target="navigate" href="StationHistoryData.aspx">历史数据</a></td>
                <td><a target="navigate" href="DayReport.aspx">日报表</a></td>
                <td><a target="navigate" href="AnalogStatisticsByDay.aspx">模拟量日统计</a></td>
                <td><a target="navigate" href="CumulantMonthReport.aspx">累积量月报</a></td>
                <td><a target="navigate" href="CumulantMonthReport.aspx?q=1">当月用水量</a></td>
                <td><a target="navigate" href="CumulantDayReport.aspx">累积量日报</a></td>               
                <td><a target="navigate" href="ChangePassword.aspx">修改密码</a></td>       

        <asp:LoginView runat="server">
            <RoleGroups>
                <asp:RoleGroup Roles="Administrator">
                    <ContentTemplate>
                        <td><a target="navigate" href="../ProtectedPage/Sensor.aspx">新增传感器</a></td>
                        <td><a target="navigate" href="../ProtectedPage/District.aspx">分区管理</a></td>
                        <td><a target="navigate" href="../ProtectedPage/Station.aspx">新增站点</a></td>
                        <td><a target="navigate" href="../ProtectedPage/StationList.aspx">站点管理</a></td>
                        <td><a target="navigate" href="../ProtectedPage/User.aspx">新增用户</a></td>
                        <td><a target="navigate" href="../ProtectedPage/UserList.aspx">用户管理</a></td>
                        <td><a class="group" target="navigate" href="/ProtectedPage/AlarmSettings.aspx">报警设置</a></td>
                    </ContentTemplate>
                </asp:RoleGroup>
            </RoleGroups>
        </asp:LoginView>

                </tr>
        </table>
    </nav>

    <aside id="tree">
        <div id="treeInstance"></div>
    </aside>

    <section id="container">
        <iframe name="navigate" id="navigate" src="Map.aspx"></iframe>
    </section>

    <aside id="sidebar">
        <section id="communicationsLog">
            <div id="logLabel">通讯日志</div>
            <div id="logEntry">
                <dl></dl>
            </div>
        </section>
    </aside>
  
    <footer>
        <%=System.Web.Configuration.WebConfigurationManager.AppSettings["support"] %>
    </footer>

    <div class="hide"><asp:Literal ID="lit" runat="server" /></div>

    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/jquery.signalR-2.0.3.min.js"></script>
    <script src="/signalr/hubs"></script>
    <script src="../Scripts/tree/dhtmlxcommon.js"></script>
    <script src="../Scripts/tree/dhtmlxtree.js"></script>
    <script src="../Scripts/tree/ext/dhtmlxtree_json.js"></script>
    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>

    <script>

        var selectedNodeID = undefined;
        var tree;

        function toggleSidebar(val) {
            if (val === 'hide') {
                $('#tree, #sidebar').hide();
                $('#container').css({ left: 0, right: 0 });
            } else {
                $('#tree, #sidebar').show();
                $('#container').css({ left: 200, right: 200 });
            };
        };

        //获取所有被选中的传感器数组
        function getAllCheckedSensor() {
            var arr = tree.getAllChecked().split(",");
            var temp = arr.filter(function (elem) {
                return elem.charAt(0) === 'R'
            });
            var result = temp.map(function (elem) {
                return elem.replace('R', '')
            });
            return result;
        };

        //获取所有被选中的站点
        function getAllCheckedStations() {
            var arr = tree.getAllChecked().split(",");
            var temp = arr.filter(function (elem) {
                return elem.charAt(0) === 'S'
            });
            var result = temp.map(function (elem) {
                return elem.replace('S', '')
            });
            return result;
        };


        $(function () {

            function formatDatetime(d) {
                return (d.getFullYear()) + "-" + (d.getMonth() + 1) + "-" + (d.getDate()) + " " + (d.getHours()) + ":" + (d.getMinutes()) + ":" + (d.getSeconds());
            }

            function showCurrentDatetime() {
                $('#clientDatetime').text(formatDatetime(new Date()));
                setTimeout(showCurrentDatetime,1000);
            }

            setTimeout(showCurrentDatetime, 0);

            tree = new dhtmlXTreeObject('treeInstance', '100%', '100%', 0);
            tree.enableCheckBoxes(1);
            tree.setImagePath("/scripts/tree/imgs/");
            tree.loadCSVString("<%=webSCADA.DAL.District.GetTreeView()%>");
            tree.attachEvent("onSelect", function (id) {
                selectedNodeID = id;
                var iframePathName = ($('#navigate').contents().get(0).location.pathname);
                if (id.charAt(0) === 'S') {
                    if (iframePathName === '/CommonPage/Map.aspx') {
                        $("#navigate")[0].contentWindow.setMapCenter(parseInt(id.replace('S', '')));
                    } else if (iframePathName === '/ProtectedPage/Sensor.aspx') {
                        $("#navigate")[0].contentWindow.receiveStationInfo(parseInt(id.replace('S', '')), tree.getItemText(id));
                    };
                } else if (id.charAt(0) !== 'R') {
                    if (iframePathName === '/ProtectedPage/Station.aspx') {
                        $("#navigate")[0].contentWindow.receiveDistrictInfo(parseInt(id), tree.getItemText(id));
                    };
                };
            });

            //tree.openAllItems(1);
            tree.openItem(1);

            var noticeHub = $.connection.noticeHub;

            noticeHub.client.broadcastStationData = function (data) {
                var jqStationData = JSON.parse(data);
                //console.log(jqStationData);
                updateCommunicationsLog(jqStationData);
                updateStationMapData(jqStationData);
                localStorage[String.format("RealTimeData-{0}", jqStationData.StationSN)] = data;
            };

            //报警
            noticeHub.client.broadcastAlarm = function (data) {
                //['AlarmName','限值','当前值']
                var jqData = JSON.parse(data);
                var container = $("#communicationsLog dl");
                for (var i = 0; i < jqData.length; i++) {
                    container.prepend(String.format('<dd>{0} 限值:{1} 当前值:{2}</dd>', jqData[i][0], jqData[i][1], jqData[i][2]));
                }
            }

            function updateCommunicationsLog(data) {
                var entry = $(String.format("#communicationsLog dl dd[accesskey='{0}']", data.StationSN));
                if (entry.length === 0) {
                    $("#communicationsLog dl").prepend(String.format("<dd accesskey='{0}'>{0} {1}</dd>", data.StationSN, data.PostDateTime));
                } else {
                    entry.text(String.format("{0} {1}", data.StationSN, data.PostDateTime));
                };
            };

            function updateStationMapData(stationData) {
                //console.log(stationData);

                var node = $(String.format('div.hide div[id="{0}"]', stationData.StationSN));
                if (node.length > 0) {
                    var ths = node.find('th');
                    $.each(ths, function (index, elem) {
                        var th = $(elem);
                        var channel = th.attr('accesskey');
                        var val = stationData.Data[channel];
                        //console.log(val);
                        //console.log(val instanceof Array);
                        if (val instanceof Array) {
                            var span = th.next().find('span');
                            if (channel.charAt(0) === 'K') {
                                span.text(val[val.length - 1] === 1 ? '关' : '开');
                            } else {
                                span.text(val[val.length - 1]);
                            };
                        };
                    });
                };
            };


            $.connection.hub.start().done(function () {
                //console.log('首页连接服务器成功');
            });

            $('a.group').click(function () {
                if (selectedNodeID === undefined || selectedNodeID.charAt(0) !== 'S') {
                    alert('请从树视图中选择一个站点');
                    return false;
                };

                $('#navigate').attr('src', String.format('{0}?StationSN={1}', $(this).attr('href'), selectedNodeID.replace('S', '')));
                return false;

            });


            $('#anchorSide').click(function () {
                var self = $(this);
                var text = self.text();
                if (text === '隐藏边栏') {
                    toggleSidebar('hide');
                    text = '显示边栏';
                } else {
                    toggleSidebar('show');
                    text = '隐藏边栏';
                };
                self.text(text);
                return false;
            });


            //
            function initUpdateMap() {
                $('div.hide div').each(function (index, elem) {
                    var stationID = ($(elem).attr('id'));
                    var stationData = (localStorage[String.format("RealTimeData-{0}", stationID)]);
                    if (stationData !== undefined) {
                        updateStationMapData(JSON.parse(stationData));
                    }
                });
            }

            initUpdateMap();

        });

    </script>

</body>
</html>