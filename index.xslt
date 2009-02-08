<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns="http://www.w3.org/1999/xhtml" xmlns:x="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="x">
  <xsl:output
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    method="xhtml" version="1.0" media-type="text/html" indent="no"/>

<!-- The identity transform, except thatPIs and comments are stripped -->
  <xsl:template match='element()'>
    <xsl:copy>
      <xsl:apply-templates select='@*,node()'/>
    </xsl:copy>
  </xsl:template>
<!--  <xsl:template match='attribute()|text()|comment()|processing-instruction()'>-->
  <xsl:template match='attribute()|text()'>
    <xsl:copy/>
  </xsl:template>

<!-- Match on the root element -->
  <xsl:template match="/*">
    <xsl:variable name="title">
      <xsl:choose>
	<xsl:when test="local-name() = 'page'"><xsl:value-of select="@title"/></xsl:when>
	<xsl:when test="local-name() = 'error'">Internal Server Error</xsl:when>
	<xsl:when test="local-name() = 'not-found'">Page '<xsl:value-of select="text()"/>' Not Found</xsl:when>
      </xsl:choose>
    </xsl:variable>

    <html xml:lang="en">
      <head>
<title>ESXX -  <xsl:value-of select="$title"/></title>
<meta name="keywords" content="ssjs, server-side javascript, ecmascript, xml, application server"/>
<link href="mailto:martin@blom.org" rev="made" />
<link href='/favicon.ico' rel='shortcut icon' type='image/vnd.microsoft.icon'/>
<link rel='alternate stylesheet' type='text/css' href='/css/blackwhite.css' title='Black and white'/>
<link rel='alternate stylesheet' type='text/css' href='/css/pastel.css' title='Pastel'/>
<link rel='alternate stylesheet' type='text/css' href='/css/plain.css' title='Plain'/>
<link rel='alternate stylesheet' type='text/css' href='/css/system.css' title='System default'/>
<link rel='alternate stylesheet' type='text/css' href='/css/amiga.css' title='Workbench 1.x' class='default'/>
<script type='text/javascript' src='/js/styleswitch.js'></script>
      </head>
      <body>

<!-- Top bar with an ad and a search bar -->
<table id="ads"><tr><td>
<script type="text/javascript"><xsl:comment>
google_ad_client = "pub-2115989180089866";
/* 728x90, skapad 2008-05-25 */
google_ad_slot = "6119170186";
google_ad_width = 728;
google_ad_height = 90;
//</xsl:comment></script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</td>
<td>
Search this site, the blog and the wiki:<br/>
<form action="http://www.google.com/cse" id="cse-search-box">
  <div>
    <input type="hidden" name="cx" value="partner-pub-2115989180089866:ayx3ndbp8fl" />
    <input type="hidden" name="ie" value="UTF-8" />
    <input type="text" name="q" size="20" />
    <input type="submit" name="sa" value="Search" />
  </div>
</form>
<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&amp;lang=en"></script>
</td></tr></table>

<!-- The page title -->
<h1>ESXX -  <xsl:value-of select="$title"/></h1>

<!-- The navigation menu -->
<div id="menu">
<ul>
<li><a href="index.html">Main</a></li>
<li><a href="http://openfacts2.berlios.de/wikien/index.php/BerliosProject:ESXX">Wiki</a></li>
<li><a href="http://esxx.blogspot.com/">Blog</a></li>
<li><a href="http://developer.berlios.de/project/showfiles.php?group_id=9645">Download</a></li>
<li><a href="http://developer.berlios.de/svn/?group_id=9645">Subversion</a></li>
<li><a href="http://developer.berlios.de/projects/esxx/">BerliOS Developer</a></li>
<li><a href="license.html">License</a></li>
</ul>
</div>

<!-- Render page content -->
<xsl:choose>
  <xsl:when test="local-name() = 'page'">
    <xsl:apply-templates select="*"/>
  </xsl:when>

  <xsl:when test="local-name() = 'error'">
    <p>An internal server error occured. If you think this is because of
a site problem, please contact Martin
Blom <a href="mailto:martin@blom.org?subject=ESXX%20Server%20down!&amp;body={encode-for-uri(text())}">&lt;martin@blom.org></a>. The
error message received was:</p>
    <pre><xsl:value-of select="." /></pre>
  </xsl:when>

  <xsl:when test="local-name() = 'not-found'">
    <p>The page you were looking for could not be found. Please use the
navigation links above.</p>

<p>If you think this is because of a site problem, please contact Martin
Blom
<a href="mailto:martin@blom.org?subject=ESXX%20page%20not%20found!&amp;body=Page%20{encode-for-uri(text())}%20not%20found.">&lt;martin@blom.org></a>.</p>
  </xsl:when>
</xsl:choose>


<!-- The footer with logos -->
<p>
<a href="http://validator.w3.org/check?uri=referer"><img
    src="http://www.w3.org/Icons/valid-xhtml10"
    alt="Valid XHTML 1.0 Strict" height="31" width="88" /></a>
<a href="http://jigsaw.w3.org/css-validator/check/referer" class="css2"><img 
   style="border:0;width:88px;height:31px"
   src="http://jigsaw.w3.org/css-validator/images/vcss" 
   alt="Valid CSS!" /></a>
<a href="http://lynx.isc.org/"><img 
   src="/gfx/lynx.gif" alt="Lynx Enhanced" /></a>
<a href="http://developer.berlios.de" title="BerliOS Developer"><img
    src="http://developer.berlios.de/bslogo.php?group_id=3406"
    width="124" height="32" alt="BerliOS Developer Logo" /></a>
</p>

<!-- The "switch stylesheet" panel -->
<table id='switcher'>
<tr>
<td><a href='#' onclick='setActiveStyleSheet("Black and white"); return false;'>Black and white</a></td>
<td><a href='#' onclick='setActiveStyleSheet("Pastel"); return false;'>Pastel</a></td>
<td><a href='#' onclick='setActiveStyleSheet("Plain"); return false;'>Plain</a></td>
<td><a href='#' onclick='setActiveStyleSheet("System default"); return false;'>System default</a></td>
<td><a href='#' onclick='setActiveStyleSheet("Workbench 1.x"); return false;'>Workbench 1.x</a></td>
<td class='logo'><a href="mailto:martin@blom.org?subject=ESXX"><img src='/gfx/logo.gif' alt='Leviticus, Divine Software' /></a></td>
</tr>
</table>

<!-- Google Analytics -->
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-5102402-1");
pageTracker._initData();
pageTracker._trackPageview();
</script>

<!-- End of body -->
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
