<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SensorRelations.aspx.cs" Inherits="webSCADA.CommonPage.SensorRelations" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    

    <table class="listview">
        <caption>漏损关系</caption>
        <thead>
            <tr>
                <th colspan="3">父传感器</th>
                <th rowspan="2">子传感器</th>
                <th rowspan="2">查看漏损分析</th>
            </tr>
            <tr>
                <th>站点</th>
                <th>传感器</th>
                <th>通道号</th> 
                              
            </tr>
        </thead>
        <tbody>
            <asp:Repeater ItemType="webSCADA.DAL.SensorRelations" ID="rep" runat="server">
                <ItemTemplate>
                    <tr>
                        <td><%#:Item.StationName %></td>
                    <td><%#:Item.SensorName %></td>
                    <td><%#:Item.Channel %></td>
                    <td>
                        <asp:Repeater DataSource="<%# Item.ChildrenSensor %>" runat="server">
                            <HeaderTemplate><dl></HeaderTemplate>
                            <ItemTemplate>
                                <dd><%#:Eval("Value") %></dd>
                            </ItemTemplate>
                            <FooterTemplate></dl></FooterTemplate>
                        </asp:Repeater>
                    </td>
                    <td><a href="LeakageAnalysis.aspx?SensorID=<%#:Item.SensorID %>">查看</a></td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </tbody>
    </table>
<asp:Literal ID="lit" runat="server" />
</body>
</html>
