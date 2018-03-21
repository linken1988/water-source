<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StationList.aspx.cs" Inherits="webSCADA.ProtectedPage.StationList" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
   
    <asp:Repeater ItemType="webSCADA.DAL.Station" ID="rep" runat="server">
        <HeaderTemplate>
            <table class="listview">
                <caption>站点管理</caption>
                <thead>
                    <tr>
                        <th>站号</th>
                        <th>站名</th>
                        <th>安装设备</th>
                        <th>所在分区</th>
                        <th>上发频率(分钟)</th>
                        <th>采集频率(分钟)</th>
                        <th>管理</th>
                    </tr>
                </thead>
                <tbody>
        </HeaderTemplate>

        <ItemTemplate>
            <tr>
                <td><%#:Item.StationSN %></td>
                <td><%#:Item.StationName %></td>
                <td><%#:Item.EquipmentName %></td>
                <td><%#:Item.DistrictName %></td>
                <td><%#:Item.PostInterval %></td>
                <td><%#:Item.CollectInterval %></td>
                <td><a href="Station.aspx?StationID=<%#:Item.StationID %>">编辑</a> <a href="<%#:Item.StationID %>">删除</a> <a href="SensorList.aspx?StationSN=<%#:Item.StationSN %>&StationName=<%#:Item.StationName %>">传感器管理</a></td>
            </tr>
        </ItemTemplate>

        <FooterTemplate></tbody></table></FooterTemplate>
    </asp:Repeater>

    <asp:Literal ID="lit" runat="server" />

    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script>

        $(function () {
            $('table').click(function (event) {
                var target = $(event.target);
                var text = target.text();
                if (target.is('a') && text === '删除') {
                    
                    if (window.confirm("删除站点会将该站点下的传感器信息一并删除\n确定要删除吗？")) {

                        
                        $.ajax({
                            type: "POST",
                            url: "/ProtectedPage/Handler/Station.ashx",
                            cache: false,
                            data: String.format("StationID={0}", target.attr("href")),
                            beforeSend: function (jqXHR, settings) {
                                jqXHR.setRequestHeader("action", 'Delete');
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



                        return false;
                    };

                    return false;
                };
            });
        });

    </script>

</body>
</html>
