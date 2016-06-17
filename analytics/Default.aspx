<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Ingeniux.Analytics.DefaultPage" %>
<%@ Import Namespace="Ingeniux.Analytics" %>
<%@ Import Namespace="Ingeniux.Analytics.Core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Google Analytics</title>
    <!-- Standard Ingeniux Style -->
    <link href="~/css/style.css" rel="Stylesheet" type="text/css" />
    
    <link type="text/css" rel="Stylesheet" href="include/tabs.css" />
    <link type="text/css" rel="Stylesheet" href="include/chartpage.css" />
    
    <script type="text/javascript" language="JavaScript" src="include/FusionCharts/FusionCharts.js"></script>

    <%
        string protocol = Request.IsSecureConnection ? "https://" : "http://";    
    %>

    <script src="<%=protocol %>ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js" type="text/javascript"></script>
    
    		<!-- Load Dojo 1.3 with a scopeMap, mapping it to the global vars dojo13, dijit13, and dojox13 -->

		<script type="text/javascript">
		    djConfig = {
		        baseUrl: "../js/dojo13/dojo/",

		        scopeMap: [
					["dojo", "dojo13"],
					["dijit", "dijit13"],
					["dojox", "dojox13"]
				],
		        modulePaths: {
		            igx: "../../igx",
		            "igx.data": "../../igx/data"
		        },
		        parseOnLoad: true
		    }
		</script>
		<script type="text/javascript" src="../js/dojo13/dojo/dojo.js"></script>
		
		<script type="text/javascript">
		    dojo13.require("dijit.form.DateTextBox");
		</script>

        <!-- #2913 Fix: Force height and overflow back to their default values, overriding settings in style.css -->		
		<style type="text/css">
		    html, body { height:auto!important;  overflow: auto !important; }
		</style>

 
</head>
<body id="bodytag" runat="server" class="tundra">
    <div id="maincontent">
    
    <script type="text/javascript">
    //<![CDATA[

        // Default chart width unless override needed
        var fusionChartWidth = 600;

        $(document).ready(function () {

            // Reload this window when the pubtarget changes
        	function PubTargetChanged() { if (window) { window.location = '<%= Request.Url.AbsoluteUri %>'; } }

            // Subscribe to changePublishingTarget event
            var subscribedEvent = window.parent.dojo.event.topic.subscribe("/controller/changePublishingTarget", PubTargetChanged);

            // Unsubscribe from changePublishingTarget
            $(window).unload(function () {
                window.parent.dojo.event.topic.unsubscribe(subscribedEvent);
            });

            //When the page loads, hide the ia_control sections, showing only the first one
            $(".tab_container").parent().each(function () {
                $(".ia_control", this).hide(); //Hide all content
                $("ul.tabs li:first", this).addClass("active").show(); //Activate first tab
                $(".ia_control:first", this).show(); //Show first tab content
            });

            //On Click Event
            $("ul.tabs li").click(function () {

                // If the clicked tab is already active, simply exit
                if ($(this).hasClass('active')) return false;

                // Otherwise hide active tabs and display the clicked item
                var $container = $(this).parent().parent();
                $container.find("ul.tabs li.active").removeClass("active"); //Remove any "active" class
                $(this).addClass("active"); //Add "active" class to selected tab
                var toHide = $container.find(".ia_control:visible") //Hide all tab content

                var selectedTabID = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content

                $(selectedTabID).fadeIn(); //Fade in the active ID content

                toHide.hide();

                return false;
            });

            // Determine if tab widths are greater than the default width and override if needed
            $('ul.tabs').each(function (index) {

                // Calculate the total tabs width based on localized text
                var runningWidth = 0;
                $('li', this).each(function () {
                    runningWidth += $(this).width()
                })

                // If override is needed, set the fusionChartWidth and explicity set the parent ul width
                if (runningWidth > fusionChartWidth) {
                    fusionChartWidth = runningWidth + 5
                    $(this).width(fusionChartWidth);
                }
            });

            // Disable right click            
            $(this).bind("contextmenu", function () { return false; });

            // After the DOM is ready, execute the IAnalyticsControl init js if included
            //also make sure it is defined
            if (typeof initAnalyticsControls == 'function') {
                initAnalyticsControls();
            }
        });

        function createUrlChart(swf, name, height, width, url) {

            var chart = new FusionCharts('include/FusionCharts/' + swf, name, width, height);
            chart.addParam("WMode", "Transparent");
            chart.setTransparent(true);
            chart.setDataURL(escape(url));
            chart.render(name + 'chart');
        }

        //]]
    </script>

    <form id="form1" runat="server">
    
    <asp:Panel ID="dateRangeSelector" runat="server">
    <%= MockDojo.StartHeader(AnalyticsConfig.Localize("analytics_reportRange"))%>

        <table style="margin-left: 15px;">
            <tr>
                <td><%= AnalyticsConfig.Localize("analytics_startDate")%></td>
                <td>
                    <input type="text" name="startDate" id="startDate" dojo13Type="dijit13.form.DateTextBox" required="true" runat="server" /> 
                </td>
                <td rowspan="2">
                    <asp:Button ID="btnUpdate" runat="server" />
                </td>
            </tr>
            <tr>
                <td><%= AnalyticsConfig.Localize("analytics_endDate")%></td>
                <td>
                   <input type="text" name="endDate" id="endDate" dojo13Type="dijit13.form.DateTextBox" required="true" runat="server" /> 
                </td>
            </tr>
        </table>

    <%= MockDojo.EndHeader()%>
    </asp:Panel>

    <asp:Panel ID="reportPanel2" runat="server"></asp:Panel>
    
    </form>
        
    </div>
    
    <asp:Literal ID="jsblock" runat="server" />
    
    </body>
</html>
