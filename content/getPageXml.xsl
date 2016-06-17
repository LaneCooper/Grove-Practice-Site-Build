<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"
        media-type="text/html"
        doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
        indent="yes"
        encoding="utf-8"/>
    
    <xsl:include href="include-xmlView.xsl"/>
    
    <xsl:template match="/">
        <html>
            <head>
								<title>Ingeniux CMS XML Viewer</title>
                <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
                <script type="text/javascript">
                  <![CDATA[
                    // Dojo requires the baseScriptUri be defined when the Dojo filename is not "dojo.js"
										// parseWidgets is set to false, we instead use searchIds to pinpoint the widgets to parse
                    djConfig = { baseScriptUri: "../js/dojo/", isDebug:false, parseWidgets:false, searchIds:["menu"]};
                  ]]>
                </script>
                <script type="text/javascript" src="../js/dojo/dojo-ajax.js" ></script>
                
                <style type="text/css" media="all" >
                    <![CDATA[
                    body, span {
                        font-family: Verdana;
                        font-size:12px;
                    }
                    
                    .tag {
                        color:blue;
                        cursor:pointer;
                    }
                    
                    .name {
                        color:#d22222;
                        cursor:pointer;
                    }
                    
                    .toggle {
                        width:10px;
                        display:block;
                        float:left;
                        clear:none;
                        cursor:pointer;
                    }
                    
                    .line, .lineEnd {
                        text-indent: -20;
                        margin-left:30px;
                    }
                    
                    .container
                    {
                        text-indent: 0;
                    }
                    
                    .comment
                    {
                        color: #999999;                  
                    }
                    
                    .menuItem
                    {
                      display:block;
                      padding:2px;
                      margin-left:5px;
                      padding-left:21px;
                      padding-right:5px;
                      font-size:11px;
                      cursor:pointer;
                      background-repeat:no-repeat;
                    }
                    ]]>
                </style>
                
                <script type="text/javascript">
                    <![CDATA[
                    
                    dojo.require("dojo.event.*");
                    dojo.require("dojo.html.*");
                    dojo.require("dojo.lang.*");
                    dojo.require("dojo.widget.PopupContainer");
                    
                    var eh = {
                        toggle: function(evt)
                        {
                            var title = this.locateElement(evt.target);
                            
                            if (title != null)
                            {                            
                                var container = dojo.html.getElementsByClass("container", title)[0];
                                var toggleButton = title.previousSibling;
                                var endTag = title.nextSibling.nextSibling;
                                
                                if (toggleButton.innerHTML == "-") {
                                    container.style.display = "none";
                                    toggleButton.innerHTML = "+";
                                    if (endTag.className == 'lineEnd')
                                        endTag.style.display = "none";
                                }
                                else if (toggleButton.innerHTML == "+"){
                                    container.style.display = "block";
                                    toggleButton.innerHTML = "-";
                                    if (endTag.className == 'lineEnd')
                                        endTag.style.display = "block";                                    
                                }
                            }
                                
                            evt.preventDefault();                        
                        },
                        
                        locateElement: function(ele)
                        {
                            var lineEle = null;
                            
                            if (ele.className.toLowerCase() == 'name')
                            {                                
                                while((ele.className.toLowerCase() != 'line') && (ele.tagName.toLowerCase != 'body'))
                                {
                                    ele = ele.parentNode;
                                }
                                
                                if (ele.className.toLowerCase() == 'line')
                                    lineEle = ele;
                            }
                            else if (ele.className.toLowerCase() == 'toggle')
                            {
                                lineEle = ele.nextSibling;
                            }
                            
                            return lineEle;
                        },
                        
                        handleContextMenu: function(evt)
                        {
                          //pop up a context menu and say 
                          //"View Source"
                          this.contextMenu = dojo.widget.byId("menu");
                          if (!this.contextMenu)
                            return false;
														
                          this.contextMenu.open(evt.clientX, evt.clientY, document.body)
                          
                          if (!dojo.render.html.ie)
                            evt.preventDefault();
                          else
                            evt.returnValue = false;
                            
                           return false;
                        },
                        
                        contextMenu: null,
                        
                        refresh: function()
                        {
                          window.location = window.location;
                        },
                        
                        viewSource: function(span)
                        {
			                    window.open(window.location.href + "&viewSource=true", "_blank", 
				                    "resizable=yes,status=yes,scrollbars=yes,width=640,height=480", true);
                          span.style.backgroundColor = "#CFD0D4";
                          this.contextMenu.close();                          
                        }
                    }
                    
                    dojo.addOnLoad(function(){
                        dojo.event.connect(dojo.byId("root"), "onclick", eh, "toggle" );
                        //if there is a loading symbol, removing
                        
                        var loadingSymbol = dojo.byId("loading");
                        
                        if (loadingSymbol)
                        {
                          loadingSymbol.style.display = "none";
                        }
                    });
                    ]]>
                  </script>
                </head>
            <body oncontextmenu="eh.handleContextMenu(event)">
                <div class="xmlPreview">
                    <xsl:call-template name="root" >
                        <xsl:with-param name="windowVersion" select="true()" />
                    </xsl:call-template>
                </div>
              <div dojoType="PopupContainer" style="border:1px solid gray; padding-top:5px;padding-bottom:5px;background-color:#CFD0D4; width:180px;position:absolute;left:-9999px;" id="menu" >
                <span class="menuItem"  onclick="eh.refresh()" onmouseover="this.style.backgroundColor = '#eeeeee'"
                      onmouseout="this.style.backgroundColor = '#CFD0D4'"
                      style="background-image: url(../images/icons/default/refresh16.png);"
                      >Refresh</span>
                <hr/>
                <span class="menuItem"  onclick="eh.viewSource(this)" onmouseover="this.style.backgroundColor = '#eeeeee'"
                      onmouseout="this.style.backgroundColor = '#CFD0D4'"
                      style="background-image: url(../images/icons/default/xmlview16.png);"
                      >View Source</span>
              
              </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
