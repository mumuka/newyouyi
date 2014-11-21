<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WXPartnerList.aspx.cs"
    Inherits="ZentCloud.JubitIMP.Web.WuBuHui.Partner.WXPartnerList" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>五伴会列表</title>
    <!-- Bootstrap -->
    <link rel="stylesheet" href="/WubuHui/css/wubu.css?v=0.0.4">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
</head>
<body>
    <div class="behindbar">
        <div class="title wbtn_line_lightpurple">
            <span class="iconfont icon-44"></span>分类
        </div>
        <ul class="catlist">
            <li class="catli current"><a href="#">全部</a></li>
            <%=PartnerStr %>
        </ul>
    </div>
    <div class="wtopbar">
        <div class="col-xs-2">
            <span class="wbtn wbtn_line_lightpurple" id="categorybtn"><span class="iconfont icon-44 bigicon">
            </span></span>
        </div>
        <div class="col-xs-10">
            <span class="wbtn wbtn_main" onclick="OnSearch()"><span class="iconfont icon-111"></span>
            </span>
            <input type="text" class="searchtext" id="txtTitle">
        </div>
        <!-- /.col-lg-6 -->
    </div>
    <!-- /.container -->
    <div class="paixu">
        <div class="col-xs-3">
            <a href="#" class="wlink current">最新回复</a>
        </div>
        <div class="col-xs-3">
            <a href="#" class="wlink">最多回复</a>
        </div>
        <div class="col-xs-3">
            <a href="#" class="wlink">最多文章</a>
        </div>
        <div class="col-xs-3">
            <a href="#" class="wlink">最高人气</a>
        </div>
    </div>
    <div class="mainlist top86 bottom50" id="needload">
        <p class="loadnote" style="text-align: center;">
        </p>
    </div>
    <!-- mainlist -->
    <div class="footerbar">
        <div class="col-xs-2 ">
            <a class="wbtn wbtn_main" type="button" href="../MyCenter/Index.aspx"><span class="iconfont icon-back"></span>
            </a>
        </div>
        <!-- /.col-lg-2 -->
        <div class="col-xs-10">
        </div>
        <!-- /.col-lg-10 -->
    </div>
    <!-- footerbar -->
</body>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="/WubuHui/js/jquery.js"></script>
<script src="/WubuHui/js/bootstrap.js"></script>
<script src="/WubuHui/js/behindbar.js?v=0.0.3"></script>
<script src="/WubuHui/js/bottomload.js?v=0.0.3"></script>
<script>
    var PageIndex = 1;
    var PageSize = 8;
    var title = "";
    var ctype = "";
    $(function () {
        InitData();
        $(".catlist>li").click(function () {
            PageIndex = 1;
            title = "";
            $("#needload>a").remove();
            ctype = $(this).attr("v");
            InitData();
            $(".catlist>li").removeClass("catli current").addClass("catli");
            $(this).addClass("catli current");
        });
    })


    function OnSearch() {
        PageIndex = 1;
        ctype = "";
        $("#needload>a").remove();
        title = $("#txtTitle").val();
        InitData();

    }


    function FormatDate(value) {
        if (value == null || value == "") {
            return "";
        }
        var date = new Date(parseInt(value.replace("/Date(", "").replace(")/", ""), 10));
        var month = padLeft(date.getMonth() + 1, 10);
        var currentDate = padLeft(date.getDate(), 10);
        var hour = padLeft(date.getHours(), 10);
        var minute = padLeft(date.getMinutes(), 10);
        var second = padLeft(date.getSeconds(), 10);
        //return date.getFullYear() + "-" + month + "-" + currentDate + " " + hour + ":" + minute + ":" + second;
        return date.getFullYear() + "-" + month + "-" + currentDate;
    }

    function padLeft(str, min) {
        if (str >= min)
            return str;
        else
            return "0" + str;
    }

    function InitData() {
        $.ajax({
            type: 'post',
            url: "/Handler/App/WXWuBuHuiPartnerHandler.ashx",
            data: { Action: "GetPartnerInfoList", PageIndex: PageIndex, PageSize: PageSize, Type: ctype, Title: title },
            success: function (result) {
                var resp = $.parseJSON(result);
                if (resp.Status == 0) {
                    data = resp.ExObj;
                    if (data == null) {
                        return;
                    };
                    var html = "";
                    $.each(data, function (Index, Item) {
                        html += '<a href="WXPartnerInfo.aspx?id=' + Item.AutoId + '" class="listbox"><div class="touxiang wbtn_round">';
                        html += '<img src="' + Item.PartnerImg + '" alt=""></div>';
                        html += '<div class="textbox"><h3>' + Item.PartnerName + '</h3><p>' + Item.PartnerAddress + '<br/>' + Item.PartnerContext + '</p></div>';
                        html += '<div class="tagbox"><span class="wbtn_tag wbtn_red"><span class="iconfont icon-eye"></span>' + Item.PartnerPv + '</span>';
                        html += '<span class="wbtn_tag wbtn_red"><span class="iconfont icon-zan"></span>' + Item.ParTnerStep + '</span>';
                        if (Item.Ctype != null) {
                            $.each(Item.Ctype, function (i, it) {
                                html += '<span class="wbtn_tag wbtn_main">' + it.CategoryName + '</span>';
                            });
                        }
                        html += '</div>';
                        html += '<div class="wbtn_fly wbtn_flybr wbtn_lightpurple timetag">' + FormatDate(Item.InsertDate) + '</div>';
                        html += '</a>';
                    });
                    $(".loadnote").before(html);
                    $(".loadnote").text("");
                    PageIndex++;

                }
            },
            complete: function () {
                $("#needload").bottomLoad(function () {
                    $(".loadnote").text("正在加载...");
                    InitData();
                })
            }
        });
    };



//    $("#needload").bottomLoad(function () {
//        console.log("dddddd");
//    })

    var arr = [".footerbar", ".wtopbar", ".mainlist", ".paixu"];
    $("#categorybtn").controlbehindbar(arr, ".mainlist");

</script>
</html>
