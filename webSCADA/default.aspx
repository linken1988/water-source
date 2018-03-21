<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="webSCADA._default" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <style type="text/css">

        html,body {
    height: 100%;
    margin:0;
    font:menu;
}


        header {
            height: 50px;
            line-height: 50px;
            font-size:30px;
            padding-left:10px;
            color:#fff;
        }

        footer {
            position:absolute;
            bottom:0;
            height:50px;
            line-height:50px;
            text-align:center;
            width:100%;
        }

        table {
            width:600px;
            margin:300px auto;
            font-size:14px;
            color:#fff;

        }

        input.size {
            width:200px;
        }

        #container {
    position: relative;
    height: 100%;
    background-color: rgba(0,0,0,0.6);
    background-position: center center;
    background-repeat: no-repeat;
    background-size: cover;
    background-attachment: fixed;
    width: 100%;
    color: #000;
    display: table;
    background-image:url(/images/1_1920x1080.jpg);
}

    </style>
</head>
<body>
    
    <div id="container">

    <header>
        <%=System.Web.Configuration.WebConfigurationManager.AppSettings["systemName"] %>
    </header>

    <section>
        <form runat="server">

            <table>
                <tbody>
                    <tr>
                        <th>帐号</th>
                        <td>
                            <input class="size" autofocus required maxlength="20" type="text" id="LoginName" placeholder="请输入帐号" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>密码</th>
                        <td>
                            <input class="size" required maxlength="20" type="password" id="Password" placeholder="请输入密码" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:CheckBox Text="下次不用输入密码" ID="RememberMe" runat="server" /></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button Text="登录" ID="btnLogin" runat="server" OnClick="btnLogin_Click" />
                            <p><asp:Label CssClass="prompt" ID="lblmsg" runat="server" /></p>
                            <asp:Literal ID="lit" runat="server" />
                        </td>
                    </tr>
                </tbody>
            </table>

        </form>
    </section>

    <footer><%=System.Web.Configuration.WebConfigurationManager.AppSettings["support"] %></footer>

        </div>

</body>
</html>
