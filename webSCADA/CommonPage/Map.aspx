<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Map.aspx.cs" Inherits="webSCADA.CommonPage.Map" %>

<!DOCTYPE html>

<html lang="zh-hans">
<head>
<meta charset="utf-8" />
    <title></title>
    <link href="../common.css" rel="stylesheet" />
    <style type="text/css">
        body, html,#map {width: 100%;height: 100%;overflow: hidden;margin:0;}
        div#note {
            position:absolute;
            top:10px;
            right:10px;
            background-color:#fff;
            border:1px solid #ccc;
            padding:10px;
        }
    </style>
</head>
<body>
    
    <div id="map"></div>
    <div id="note">
        在左侧树视图中选择不同的<span class="prompt">站点</span>，可在地图中快速导航。
    </div>

    <asp:Literal ID="lit" runat="server" />
    <script src="../Scripts/MSAJAX/MicrosoftAjax.js"></script>
    <script src="http://api.map.baidu.com/api?v=2.0&ak=<%=System.Configuration.ConfigurationManager.AppSettings["baiduMapKey"] %>"></script>
    <script src="../Scripts/jquery-1.11.1.min.js"></script>

    <script>

        var stationMapData=<%=GetStationMap%>;

        var map = new BMap.Map("map");
        var point = new BMap.Point(<%=System.Configuration.ConfigurationManager.AppSettings["initLongitude"]%>, <%=System.Configuration.ConfigurationManager.AppSettings["initLatitude"]%>);
        map.centerAndZoom(point, 15);
        map.enableScrollWheelZoom();

        if(stationMapData!==null){
            for(var i=0;i<stationMapData.length;i++){

                var label = new BMap.Label(String.format('<a id="{1}">{0}</a>',stationMapData[i][1],stationMapData[i][0]),{position:new BMap.Point(stationMapData[i][2],stationMapData[i][3])});   
                label.setStyle({ color : "#666", fontSize : "12px",padding:'5px',borderColor:'#333' })
                label.addEventListener("click", function(type, target){  
                    var stationSN=$(type.target.content).attr('id');
                    var stationNode=($('div[id="' + stationSN + '"]',window.parent.document));
                    var htmlStr='';
                    if(stationNode.length>0){
                        htmlStr=stationNode.html();
                    }; 
                    
                    var showPosi=null;
                    for(var j=0;j<stationMapData.length;j++){
                        if(stationMapData[j][0]==stationSN){
                            showPosi=new BMap.Point(stationMapData[j][2],stationMapData[j][3]);
                            break;
                        }
                    }

                    map.openInfoWindow(new BMap.InfoWindow(htmlStr, {width:300,enableMessage:false}), showPosi);  
                });  
                map.addOverlay(label);
            };
        };

        function setMapCenter(stationSN){
            if(stationMapData!==null){
                for(var i=0,len=stationMapData.length;i<len;i++){
                    if(stationMapData[i][0]==stationSN){
                        map.setCenter(new BMap.Point(stationMapData[i][2],stationMapData[i][3]));            
                        break;
                    };
                };
            };
        };

    </script>

</body>
</html>
