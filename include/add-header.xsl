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

      <div id="hdr">
	<div id="logo"><a href="{$root}/"><img src="https://static.gnome.org/img/spacer.png" alt="Home" /></a></div>
        <div id="banner"><img src="https://static.gnome.org/img/spacer.png" alt="" /></div>
	<p class="none"></p>
        <div id="hdrNav">
	  <a href="https://www.gnome.org/about/">About GNOME</a> &middot;
	  <a href="https://www.gnome.org/start/stable/">Download</a> &middot;
	  <!--<a href="http://www.gnome.org/contribute/"><i>Get Involved!</i></a> &middot;-->
	  <a href="https://www.gnome.org/">Users</a> &middot;
	  <a href="https://developer.gnome.org/">Developers</a> &middot;
	  <a href="https://foundation.gnome.org/"><b>Foundation</b></a> &middot;
	  <a href="https://www.gnome.org/contact/">Contact</a>
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
