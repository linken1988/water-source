<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlarmSettings.aspx.cs" Inherits="webSCADA.ProtectedPage.AlarmSettings" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>报警设置</title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">


    <asp:Repeater ItemType="webSCADA.DAL.AlarmSetting" ID="rep" runat="server">
        <HeaderTemplate>
            <table class="listview">
                <caption>报警设置</caption>
                <thead>
                    <tr>
                        <th>报警名称</th>
                        <th>报警类型</th>
                        <th>报警限值</th>
                        <th>管理</th>
                    </tr>
                </thead>
                <tbody>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td><%#:Item.AlarmName %></td>
                <td><%#:Item.AlarmType==0 ? "上" : "下" %>限</td>
                <td><%#:Item.LitmitValue.ToString("f2") %></td>
                <td><a href="<%#:Item.ID %>">删除</a></td>
            </tr>
        </ItemTemplate>
        <FooterTemplate></tbody>
            </table></FooterTemplate>
    </asp:Repeater>

    <asp:Literal ID="lit" runat="server" />
    <script src="/Scripts/jquery-1.11.1.min.js"></script>
    <script src="/Scripts/MSAJAX/MicrosoftAjax.js"></script>
    <script>

        $(function () {
            $('table').click(function (event) {
                var target = $(event.target);
                var text = target.text();
                if (target.is('a') && text==='删除') {

                    if (window.confirm("确定要删除吗？")) {
                        
                        $.ajax({
                            type: "POST",
                            url: "/ProtectedPage/Handler/AlarmSetting.ashx",
                            cache: false,
                            data: String.format('ID={0}',target.attr('href')),
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


                    };

                    return false;
                };
            });
        });

    </script>

</body>
</html>
