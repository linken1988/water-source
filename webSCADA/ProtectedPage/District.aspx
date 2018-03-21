<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="District.aspx.cs" Inherits="webSCADA.ProtectedPage.District" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">
    
    <div class="prompt alignRight">请从树视图中选择分区后进行相应的操作。</div>

    <div class="middle marTB" id="toolbar">
        <button accesskey="Create">新建分区</button>
        <button accesskey="Update">编辑分区</button>
        <button accesskey="Delete">删除分区</button>
    </div>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>
    <script>

        $(function () {

            var allowedAction = ['Create', 'Update', 'Delete'];

            $('#toolbar').click(function (event) {
                var selectedDistrictID = parent.selectedNodeID;
                if (selectedDistrictID === undefined || selectedDistrictID.charAt(0) === 'S' || selectedDistrictID.charAt(0) === 'R') {
                    alert('请从树视图中选择一个分区');
                    return;
                } else {
                    var target = $(event.target);
                    var action = target.attr('accesskey');
                    switch (action)
                    {
                        case allowedAction[2]: deleteDistrict(action,selectedDistrictID, target); break;
                        case allowedAction[1]: 
                        case allowedAction[0]: putDistrict(action, selectedDistrictID,target); break;
                    };
                };
            });

            function putDistrict(action, selectedDistrictID, target) {
                var promptText = "请输入分区名称";
                var districtName;
                if (action === allowedAction[1]) {
                    var selectedDistrictName = parent.tree.getItemText(selectedDistrictID);
                    districtName = window.prompt(promptText, selectedDistrictName);
                } else {
                    districtName = window.prompt(promptText);
                };
                
                if (districtName === null || districtName.trim() === '') {
                    return;
                } else {
                    districtName = encodeURIComponent(districtName);
                    var option = { selectedDistrictID: selectedDistrictID, districtName: districtName };
                    var command = String.format("DistrictName={0}&{1}={2}", districtName, action === allowedAction[0] ? 'ParentDistrictID' : 'DistrictID', encodeURIComponent(selectedDistrictID));
                    executeCommand(action, command, target, option);
                };
            };

            function deleteDistrict(action,selectedDistrictID, target) {
                if (parent.tree.getParentId(selectedDistrictID) === 0) {
                    alert('树视图不允许被删除');
                    return;
                };

                if (window.confirm("确定要删除吗？")) {
                    var command = String.format("DistrictID={0}", encodeURIComponent(selectedDistrictID));
                    executeCommand(action, command, target, { selectedDistrictID: selectedDistrictID });
                };
            };

            function executeCommand(action, command, target, option) {
                $.ajax({
                    type: 'POST',
                    url: '/ProtectedPage/Handler/District.ashx',
                    cache: false,
                    data: command,
                    beforeSend: function (jqXHR, settings) {
                        jqXHR.setRequestHeader('action', action);
                        target.attr("disabled", true);
                    },
                    success: function (data, textStatus, jqXHR) {
                        if (action === allowedAction[2] && data === '删除成功') {
                            parent.tree.deleteItem(option.selectedDistrictID, false);
                        } else if ((action === allowedAction[0]) && (/^\d+$/.test(data))) {
                            parent.tree.insertNewChild(option.selectedDistrictID, data, decodeURIComponent(option.districtName));
                        } else if ((action === allowedAction[1]) && (data === '更新成功')) {
                            parent.tree.setItemText(option.selectedDistrictID, decodeURIComponent(option.districtName));
                        } else {
                            alert(data);
                        };
                        target.attr("disabled", false);
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        target.attr("disabled", false);
                        alert(errorThrown);
                    }
                });
            };

        });

    </script>

</body>
</html>
