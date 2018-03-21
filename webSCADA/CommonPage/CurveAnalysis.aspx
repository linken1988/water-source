<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CurveAnalysis.aspx.cs" Inherits="webSCADA.CommonPage.CurveAnalysis" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
</head>
<body class="margin">

    <div>

        <div class="alignRight marTB prompt">请注意：查询日期跨越太长可能会导致查询时间过长。</div>

        <div class="middle">
<form id="form1" method="post" action="Handler/CurveAnalysis.ashx">
查询时间介于 <input type="datetime-local" id="StartDateTime" runat="server" /> 
    至 <input type="datetime-local" id="EndDateTime" runat="server" /> 
<input type="submit" value="查询" />
<input type="hidden" id="QueryQueue" name="QueryQueue" />
</form>
        </div>

        <div id="container" style="min-width:800px;height:400px"></div>

    </div>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/jquery-1.11.1.min.js"></script>
    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>
    <script src="../Scripts/chart/highcharts.js"></script>
    <script>

        $(function () {

            var options = {
                chart: {
                    renderTo: 'container',
                    type: 'spline'
                },
                series: [{}],
                title: {
                    text: '曲线分析'
                }, xAxis: {
                    type: 'datetime',
                    labels: { enabled: false },
                    dateTimeLabelFormats: {
                        second: '%Y-%m-%d<br/>%H:%M:%S',
                        minute: '%Y-%m-%d<br/>%H:%M',
                        hour: '%Y-%m-%d<br/>%H:%M',
                        day: '%Y<br/>%m-%d',
                        week: '%Y<br/>%m-%d',
                        month: '%Y-%m',
                        year: '%Y'
                    }
                },
                yAxis: {
                    title: {
                        text: ''
                    }, labels: {format:'{value}'}
                },
                tooltip: {
                    formatter: function () {
                        return '<b>' + this.series.name + '</b><br />' +
                        Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + '  ' + this.y.toFixed(2);
                    }
                }, credits: {
                    enabled: false
                }
            };



            $("form").submit(function (event) {

                var btnSubmit = $("input[type='submit']");
                event.preventDefault();
                var checkedSensors = parent.getAllCheckedSensor();
                if (checkedSensors.length === 0) {
                    alert('请从树视图中选择传感器');
                    return;
                } else {
                    $('#QueryQueue').val(checkedSensors.toString());
                };


                $.ajax({
                    type: $(this).attr("method"),
                    url: $(this).attr("action"),
                    cache: false,
                    dataType: "json",
                    data: $(this).serialize(),
                    beforeSend: function () {
                        btnSubmit.attr("disabled", true);
                    },
                    success: function (data, textStatus, jqXHR) {
                        btnSubmit.attr("disabled", false);
                        options.series = data;
                        var chart = new Highcharts.Chart(options);

                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        btnSubmit.attr("disabled", false);
                    }
                });


            });

        });

    </script>

</body>
</html>
