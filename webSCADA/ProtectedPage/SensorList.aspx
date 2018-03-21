<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SensorList.aspx.cs" Inherits="webSCADA.ProtectedPage.SensorList" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
   
    <table class="listview">
                <caption id="caption" runat="server"></caption>
                <thead>
                    <tr>
                        <th>传感器名称</th>
                        <th>通道号</th>
                        <th>所属站点</th>
                        <th>单位</th>
                        <th>显示顺序</th>
                        <th>管理</th>
                    </tr>
                </thead>
                <tbody>                  

    <asp:Repeater ItemType="webSCADA.DAL.Sensor" ID="rep" runat="server">
        

        <ItemTemplate>
            <tr>
                <td><%#:Item.SensorName %></td>
                <td><%#:Item.Channel %></td>
                <td><%#:Item.StationName %></td>
                <td><%#:Item.Unit %></td>
                <td><%#:Item.Sort %></td>
                <td>
                    <%# ((!string.IsNullOrWhiteSpace(Item.Channel)) && (Item.Channel.StartsWith("P"))) ? string.Format("<a href='{0}'>指定父累积量传感器</a>",Item.SensorID) : ""  %>
                    <a href="<%#:Item.SensorID %>">删除</a>
                    <a href="Sensor.aspx?SensorID=<%#:Item.SensorID %>">编辑</a>
                    <a <%# new char[]{'A','V'}.Contains(Item.Channel[0]) ? "" : "style='display:none'" %> href="AlarmSetting.aspx?SensorID=<%#:Item.SensorID %>">新增报警</a>
                </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
                    </tbody></table>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>
    <script>

        $(function () {
            var funcs = ['指定父累积量传感器', '删除'];
            $('table').click(function (event) {
                var target = $(event.target);
                var text = target.text();
                if (target.is('a') && funcs.indexOf(text) !== -1) {

                    var data = String.format('SensorID={0}', target.attr('href'));

                    var prompt='确定要删除吗？';

                    if (text === funcs[0]) {
                        var checkedSensors = parent.getAllCheckedSensor();
                        if (checkedSensors.length === 0) {
                            prompt = '您没有从树视图选择父传感器，此种情况下会取消当前选择的传感器的父传感器。确定吗？'
                            data += "&parentSensorID=-1";
                        } else if (checkedSensors.length > 1) {
                            prompt = '您只能从树视图中选择一个传感器作为当前选择的传感器的父传感器';
                            alert(prompt);
                            return false;
                        } else {
                            prompt = "确定指定树视图中选择的传感器作为当前传感器的父传感器吗？";
                            data += String.format("&parentSensorID={0}", checkedSensors[0]);
                        }
                    } 

                    if (window.confirm(prompt)) {
                        
                        $.ajax({
                            type: "POST",
                            url: "/ProtectedPage/Handler/Sensor.ashx",
                            cache: false,
                            data: data,
                            beforeSend: function (jqXHR, settings) {
                                jqXHR.setRequestHeader("action", text === funcs[1] ? 'Delete' : 'UpdateParentSensorID');
                                target.attr("disabled", true);
                            },
                            success: function (data, textStatus, jqXHR) {
                                if (data === "删除成功") {
                                    target.parents('tr').remove();
                                } else {
                                    target.attr("disabled", false);
                                    alert(data);
                                };
                            },
                            error: function (jqXHR, textStatus, errorThrown) {
                                target.attr("disabled", false);
                                alert(errorThrown);
                            }
                        });


                    };

                    return false;
                };
            });
        });

    </script>

</body>
</html>
