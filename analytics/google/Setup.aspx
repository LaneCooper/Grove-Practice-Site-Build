<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Setup.aspx.cs" Inherits="Ingeniux.Analytics.SetupPage" %>

<%@ Import Namespace="Ingeniux.Analytics" %>
<%@ Import Namespace="Ingeniux.Analytics.Core" %>
<%@ Import Namespace="Ingeniux.Analytics.Google" %>
<%@ Import Namespace="Ingeniux.CMS" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Google Analytics</title>
	<!-- Standard Ingeniux Style -->
	<link href="~/css/style.css" rel="Stylesheet" type="text/css" />
	<link type="text/css" rel="Stylesheet" href="../include/chartpage.css" />
	<%
		string cleanUrl = Request.Url.AbsoluteUri.SubstringBefore("?");
		string protocol = Request.IsSecureConnection ? "https://" : "http://";
		string requestCodeUrl = string.Format("https://accounts.google.com/o/oauth2/auth" +
			"?access_type=offline&approval_prompt=auto&response_type=code" +
			"&client_id={0}&redirect_uri=urn:ietf:wg:oauth:2.0:oob" +
			"&scope=https://www.googleapis.com/auth/analytics&state=urn:ietf:wg:oauth:2.0:oob33020663" +
			"&output=embed",
			AnalyticsDataProvider.GOOGLE_CLIENT_ID);
	%>
	<script src="<%=protocol %>ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js" type="text/javascript"></script>
	<script type="text/javascript">
		//<![CDATA[

		var googleAuthReqUrl = "<%=requestCodeUrl%>";

		var requestAuth = function () {
			window.open('connect.ashx', 'connectAnalytics', 'resizable=1,width=900,height=600');
		};

		var authWithCode = function () {
			var code = window.top.dojo13.trim(this.authCode.value);
			if (code)
				window.location.href = "<%=cleanUrl%>?code=" + code;
		};

		$(document).ready(function () {
			$("#connectButton").click(function () {
				requestAuth();
			});

			$("#authCode").keyup(function () {
				$("#continueAuth")[0].disabled = !($("#authCode")[0].value);
			});

			$("#continueAuth").click(function () {
				authWithCode();
			});
		});

		//]]
	</script>
</head>
<body class="tundra">
	<div id="maincontent">

		<form id="form1" runat="server">

			<%= MockDojo.StartBox(AnalyticsConfig.Localize("analytics_setupTitle"), "default/analytic24.png", "")%>

			<div style="padding: 12px">

				<asp:Panel ID="connect" runat="server">
					<p><%= AnalyticsConfig.Localize("analytics_setupDesc") %></p>
					<p><strong><%= AnalyticsConfig.Localize("analytics_setupStepsTitle") %></strong></p>
					<p><%=AnalyticsConfig.Localize("analytics_setupStep1") %></p>
					<p><%=AnalyticsConfig.Localize("analytics_setupStep2") %></p>
					<p><%=AnalyticsConfig.Localize("analytics_setupStep3") %></p>
					<button id="connectButton" onclick="return false;"><%= AnalyticsConfig.Localize("analytics_setupConnectBtn")%></button>
					<p><%=AnalyticsConfig.Localize("analytics_setupStep4") %></p>

					<textarea id="authCode" style="width: 500px"></textarea><br />
					<br />
					<button id="continueAuth" onclick="return false;" disabled><%= AnalyticsConfig.Localize("analytics_continueBtn")%></button>
				</asp:Panel>

				<asp:Panel ID="connected" runat="server">

					<%= AnalyticsConfig.Localize("analytics_setupConnected") %>

					<table style="margin: 5px;" runat="server" id="connectedLayoutTable">
						<tr>
							<td style="font-weight: bold; padding-right: 4px;"><%= AnalyticsConfig.Localize("analytics_setupConnectedProfile") %></td>
							<td>
								<asp:DropDownList ID="availableProfiles" runat="server"></asp:DropDownList></td>
						</tr>
					</table>

					<asp:LinkButton ID="btnSaveProfile" runat="server" OnClick="btnSave_Click"><%= AnalyticsConfig.Localize("analytics_setupConnectedSaveProfile") %></asp:LinkButton>
					<br />

					<div style="margin-top: 15px">
						<%= AnalyticsConfig.Localize("analytics_setupConnectedTokenBody") %>
						<br />

						<div style="margin: 5px; font-weight: bold; font-style: italic;">
							<asp:Label ID="gaAccessToken" runat="server" />
						</div>

						<asp:LinkButton ID="revokeToken" runat="server" OnClick="revokeToken_Click"><%= AnalyticsConfig.Localize("analytics_setupConnectedRevokeToken") %></asp:LinkButton>
					</div>

				</asp:Panel>

				<asp:Label ID="error" ForeColor="Red" runat="server">
				</asp:Label>

			</div>

		</form>

		<%
			string protocol = Request.IsSecureConnection ? "https://" : "http://";    
		%>

		<script src="<%=protocol %>ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js" type="text/javascript"></script>

		<script type="text/javascript">

			$(document).ready(function () {

				$('#profiles').change(function () {
					$('#profileName').val($(':selected', this).text());
				});

			});

		</script>



		<%= MockDojo.EndBox() %>
	</div>
</body>
</html>
