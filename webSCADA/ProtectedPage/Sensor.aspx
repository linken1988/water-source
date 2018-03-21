<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Sensor.aspx.cs" Inherits="webSCADA.ProtectedPage.Sensor" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
    <meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    <fieldset>
        <legend runat="server" id="caption">新增传感器</legend>
        <form method="post" action="/ProtectedPage/Handler/Sensor.ashx" id="form1">
           <input disabled="disabled" type="hidden" id="SensorID" runat="server" />
            <table>
               <tr>
                   <th>传感器名称</th>
                   <td><input maxlength="20" type="text" id="SensorName" runat="server" /></td>
               </tr>
               <tr>
                   <th>通道号</th>
                   <td><input type="text" maxlength="3" id="Channel" runat="server" /></td>
               </tr>
               <tr>
                   <th>计量单位</th>
                   <td><input type="text" id="Unit" runat="server" /></td>
               </tr>
               <tr>
                   <th>显示顺序</th>
                   <td><input type="text" id="Sort" runat="server" /></td>
               </tr>
               <tr>
                   <th>所属站点<span class="prompt">(请从树视图中选择)</span></th>
                   <td><span runat="server" id="StationName">未选择站点</span>
                       <input type="hidden" id="StationSN" runat="server" />
                   </td>
               </tr>
               <tr>
                   <th></th>
                   <td>
                       <button accesskey="Create" id="btnSubmit" type="submit" runat="server">新增传感器</button>
                   </td>
               </tr>
           </table>
       </form>
    </fieldset>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>

    <script>

        function receiveStationInfo(stationSN,stationName) {
            $('#StationName').text(stationName);
            $('#StationSN').val(stationSN);
        };


        $(function () {

            $("form").submit(function (event) {
                if ($("#StationSN").val() === '') {
                    alert('必须选择一个站点');
                    return false;
                };                

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
