<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Station.aspx.cs" Inherits="webSCADA.ProtectedPage.Station" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    <fieldset>
        <legend runat="server" id="caption">新增站点</legend>
        <form method="post" action="/ProtectedPage/Handler/Station.ashx" id="form1">
           <input disabled="disabled" type="hidden" id="StationID" runat="server" />
            <table>
               <tr>
                   <th>站号</th>
                   <td><input type="text" id="StationSN" runat="server" /></td>
               </tr>
               <tr>
                   <th>站名</th>
                   <td><input maxlength="50" type="text" id="StationName" runat="server" /></td>
               </tr>
                <tr>
                    <th>经度</th>
                    <td><input type="text" id="Longitude" runat="server" /></td>
                </tr>
                <tr>
                    <th>纬度</th>
                    <td><input type="text" id="Latitude" runat="server" /></td>
                </tr>
               <tr>
                   <th>设备类型</th>
                   <td><select id="EquipmentName" runat="server">
                       <option>RTU-H</option>
                       <option>RTU-L</option>
                       </select></td>
               </tr>
               <tr>
                   <th>上发频率(分钟)</th>
                   <td><input type="text" id="PostInterval" runat="server" /></td>
               </tr>
               <tr>
                   <th>采集频率(分钟)</th>
                   <td><input type="text" id="CollectInterval" runat="server" /></td>
               </tr>
               <tr>
                   <th>所属分区<span class="prompt">(请从树视图中选择分区)</span></th>
                   <td>
                       <span runat="server" id="DistrictName">未选择</span>
                       <input type="hidden" id="DistrictID" runat="server" />
                   </td>
               </tr>
               <tr>
                   <th></th>
                   <td>
                       <button accesskey="Create" id="btnSubmit" type="submit" runat="server">新增站点</button>
                   </td>
               </tr>
           </table>
       </form>
    </fieldset>

    <asp:Literal ID="lit" runat="server" />

    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script>

        function receiveDistrictInfo(districtID, districtName) {
            $('#DistrictName').text(districtName);
            $('#DistrictID').val(districtID);
        };

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
