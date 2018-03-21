<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlarmSetting.aspx.cs" Inherits="webSCADA.ProtectedPage.AlarmSetting" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
     <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    <fieldset>
        <legend runat="server" id="caption">报警设置</legend>
        <form method="post" action="/ProtectedPage/Handler/AlarmSetting.ashx" id="form1">
           <input type="hidden" id="SensorID" runat="server" />
            <table>
               <tr>
                   <th>报警名称</th>
                   <td><input type="text" id="AlarmName" runat="server" /></td>
               </tr>
               <tr>
                   <th>报警类型</th>
                   <td><select id="AlarmType" runat="server"><option value="0">上限</option><option value="1">下限</option></select></td>
               </tr>
                <tr>
                    <th>报警限值</th>
                    <td><input type="text" id="LitmitValue" runat="server" /></td>
                </tr>
               <tr>
                   <th></th>
                   <td>
                       <button accesskey="Create" id="btnSubmit" type="submit" runat="server">新增报警设置</button>
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
