<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="webSCADA.ProtectedPage.User" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
   
    <fieldset>
        <legend runat="server" id="caption">新增用户</legend>
        <form method="post" action="/ProtectedPage/Handler/User.ashx" id="form1">
           <input disabled="disabled" type="hidden" id="UserID" runat="server" />
            <table>
               <tr>
                   <th>姓名</th>
                   <td><input maxlength="10" type="text" id="Name" runat="server" /> </td>
               </tr>
               <tr>
                   <th>帐号</th>
                   <td><input maxlength="20" type="text" id="LoginName" runat="server" /> <%=webSCADA.DAL.User.PatternInfo %></td>
               </tr>
                <tr>
                    <th>密码</th>
                    <td><input maxlength="20" type="password" id="Password" runat="server" /> <span class="prompt" id="prompt" runat="server"></span> <%=webSCADA.DAL.User.PatternInfo %></td>
                </tr>
               <tr>
                   <th>角色</th>
                   <td><select datatextfield="Value" datavaluefield="Key" id="Role" runat="server"></select></td>
               </tr>
               <tr>
                   <th></th>
                   <td>
                       <button accesskey="Create" id="btnSubmit" type="submit" runat="server">新增用户</button>
                   </td>
               </tr>
           </table>
       </form>
    </fieldset>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script>

        $(function () {

            $("form").submit(function (event) {
                var btnSubmit = $("#btnSubmit");
                var text = btnSubmit.text();
                event.preventDefault();
                if (window.confirm('确定要' + text + '吗？')) {

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
