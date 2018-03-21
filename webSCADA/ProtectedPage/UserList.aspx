<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" Inherits="webSCADA.ProtectedPage.UserList" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8"/>
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    <asp:Repeater ItemType="webSCADA.DAL.User" ID="rep" runat="server">
        <HeaderTemplate>
            <table class="listview">
                <caption>用户管理</caption>
                <thead>
                    <tr>
                        <th>姓名</th>
                        <th>帐号</th>
                        <th>角色</th>
                        <th>管理</th>
                    </tr>
                </thead>
                <tbody>            
        </HeaderTemplate>

        <ItemTemplate>
            <tr>
                <td><%#:Item.Name %></td>
                <td><%#:Item.LoginName %></td>
                <td><%#:Item.Role %></td>
                <td>
                    <a href="User.aspx?UserID=<%#:Item.UserID %>">编辑</a>
                    <a href="<%#:Item.UserID %>">删除</a>
                </td>
            </tr>
        </ItemTemplate>

        <FooterTemplate></tbody></table></FooterTemplate>
    </asp:Repeater>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>
    <script>

        $(function () {
            $('table').click(function (event) {
                var target = $(event.target);
                var text = target.text();
                if (target.is('a') && text === '删除') {

                    if (window.confirm("确定要删除吗？")) {

                        $.ajax({
                            type: "POST",
                            url: "/ProtectedPage/Handler/User.ashx",
                            cache: false,
                            data: String.format('UserID={0}', target.attr('href')),
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
