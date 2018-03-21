<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="webSCADA.CommonPage.ChangePassword" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    <fieldset>
        <legend>修改密码</legend>
        <form id="form1" method="post" action="/CommonPage/Handler/User.ashx">
            <table>
                <tr>
                    <th>旧密码</th>
                    <td><input runat="server" id="Password" maxlength="20"  type="password" /></td>
                </tr>
                <tr>
                    <th>新密码</th>
                    <td><input runat="server" id="NewPassword" maxlength="20"  type="password" /></td>
                </tr>
                <tr>
                    <th></th>
                    <td><button accesskey="ChangePassword" type="submit">修改密码</button></td>
                </tr>
            </table>
        </form>
    </fieldset>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script>

        $(function () {

            $("form").submit(function (event) {
                var btnSubmit = $("button");
                event.preventDefault();
                if (window.confirm('确定要修改密码吗？')) {

                    $.ajax({
                        type: $(this).attr("method"),
                        url: $(this).attr("action"),
                        cache: false,
                        data: $(this).serialize(),
                        beforeSend: function (jqXHR, settings) {
                            jqXHR.setRequestHeader('action', btnSubmit.attr("accesskey"));
                            btnSubmit.attr("disabled", true);
                        },
                        success: function (data, textStatus, jqXHR) {
                            alert(data);
                            btnSubmit.attr("disabled", false);
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            btnSubmit.attr("disabled", false);
                            alert(errorThrown);
                        }
                    });

                };
            });



        });

    </script>

</body>
</html>
