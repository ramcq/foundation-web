<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY copy   "&#169;" >
  <!ENTITY middot "&#183;" >
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:date="http://exslt.org/dates-and-times"
		version="1.0" extension-element-prefixes="date">

  <!-- using encoding="US-ASCII" would make the output compatible with
       both ISO-8859-1 and UTF-8 -->
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
	      omit-xml-declaration="yes"
	      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

  <!-- the root directory for the website -->
  <xsl:param name="root" select="''" />

  <xsl:template match="html">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </html>
  </xsl:template>

  <xsl:template match="head">
    <head xmlns="http://www.w3.org/1999/xhtml">
      <link rel="stylesheet" type="text/css" href="https://static.gnome.org/css/vote/vote.css" />
      <link rel="icon" type="image/png" href="https://static.gnome.org/img/logo/foot-16.png" />
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="node()" />
    </head>
  </xsl:template>

  <xsl:template match="body">
    <body xmlns="http://www.w3.org/1999/xhtml">
      <div id="body">
	<xsl:copy-of select="@*" />
	<xsl:apply-templates select="node()" />
      </div>

    <div id="footer_community"></div>

    <div id="footer_grass"></div>

    <div id="footer">
      <div class="container_12" id="container_12">
        <div class="links grid_9">
          <div class="menu-footer-container">
            <ul id="menu-footer" class="menu">
              <li id="menu-item-1048" class=
              "menu-item menu-item-type-custom menu-item-object-custom current-menu-item current_page_item menu-item-1048">
              <a href="http://www.gnome.org">The GNOME Project</a>

                <ul class="sub-menu">
                  <li id="menu-item-1049" class=
                  "menu-item menu-item-type-post_type menu-item-object-page menu-item-1049">
                  <a href="https://www.gnome.org/about/">About Us</a></li>

                  <li id="menu-item-1050" class=
                  "menu-item menu-item-type-post_type menu-item-object-page menu-item-1050">
                  <a href="https://www.gnome.org/get-involved/">Get Involved</a></li>

                  <li id="menu-item-1051" class=
                  "menu-item menu-item-type-post_type menu-item-object-page menu-item-1051">
                  <a href="https://www.gnome.org/teams/">Teams</a></li>

                  <li id="menu-item-1053" class=
                  "menu-item menu-item-type-post_type menu-item-object-page menu-item-1053">
                  <a href="https://www.gnome.org/support-gnome/">Support GNOME</a></li>

                  <li id="menu-item-1054" class=
                  "menu-item menu-item-type-post_type menu-item-object-page menu-item-1054">
                  <a href="https://www.gnome.org/contact/">Contact Us</a></li>

                  <li id="menu-item-2246" class=
                  "menu-item menu-item-type-post_type menu-item-object-page menu-item-2246">
                  <a href="https://www.gnome.org/foundation/">The GNOME Foundation</a></li>
                </ul>
              </li>

              <li id="menu-item-1047" class=
              "menu-item menu-item-type-custom menu-item-object-custom menu-item-1047">
                <a href="#">Resources</a>

                <ul class="sub-menu">
                  <li id="menu-item-1055" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1055">
                  <a href="https://developer.gnome.org">Developer Center</a></li>

                  <li id="menu-item-1056" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1056">
                  <a href="https://help.gnome.org">Documentation</a></li>

                  <li id="menu-item-1057" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1057">
                  <a href="https://wiki.gnome.org">Wiki</a></li>

                  <li id="menu-item-1058" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1058">
                  <a href="https://mail.gnome.org/mailman/listinfo">Mailing Lists</a></li>

                  <li id="menu-item-1059" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1059">
                  <a href="https://wiki.gnome.org/GnomeIrcChannels">IRC Channels</a></li>

                  <li id="menu-item-1060" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1060">
                  <a href="https://bugzilla.gnome.org/">Bug Tracker</a></li>

                  <li id="menu-item-1061" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1061">
                  <a href="https://git.gnome.org/browse/">Development Code</a></li>

                  <li id="menu-item-1062" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1062">
                  <a href="https://wiki.gnome.org/Jhbuild">Build Tool</a></li>
                </ul>
              </li>

              <li id="menu-item-1046" class=
              "menu-item menu-item-type-custom menu-item-object-custom menu-item-1046">
                <a href="https://www.gnome.org/news">News</a>

                <ul class="sub-menu">
                  <li id="menu-item-1063" class=
                  "menu-item menu-item-type-post_type menu-item-object-page menu-item-1063">
                  <a href="https://www.gnome.org/press/">Press Releases</a></li>

                  <li id="menu-item-1064" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1064">
                  <a href="https://www.gnome.org/start/stable">Latest Release</a></li>

                  <li id="menu-item-1065" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1065">
                  <a href="https://planet.gnome.org">Planet GNOME</a></li>

                  <li id="menu-item-1067" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1067">
                  <a href="https://news.gnome.org">Development News</a></li>

                  <li id="menu-item-1068" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1068">
                  <a href="https://identi.ca/gnome">Identi.ca</a></li>

                  <li id="menu-item-1069" class=
                  "menu-item menu-item-type-custom menu-item-object-custom menu-item-1069">
                  <a href="https://twitter.com/gnome">Twitter</a></li>
                </ul>
              </li>
            </ul>
          </div>
        </div>

        <div id="footnotes" class="grid_9">
         <p> Copyright &copy; 2005 - 2014 <a href="https://www.gnome.org/"><strong>The GNOME Project</strong></a>.<br />
         <small><a href="http://validator.w3.org/check/referer">Optimised</a> for <a href=
          "http://www.w3.org/">standards</a>. Hosted by <a href=
          "http://www.redhat.com/">Red Hat</a>.
        </div>
      </div>
    </div>

    </body>
  </xsl:template>

  <!-- copy elements, adding the XHTML namespace to elements with an
       empty namespace URI -->
  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="namespace-uri() = ''">
	<xsl:element namespace="http://www.w3.org/1999/xhtml"
		     name="{local-name()}">
	  <xsl:copy-of select="@*" />
	  <xsl:apply-templates select="node()" />
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*" />
	  <xsl:apply-templates select="node()" />
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- get rid of processing instructions -->
  <xsl:template match="processing-instruction()">
  </xsl:template>

  <!-- copy everything else -->
  <xsl:template match="node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
