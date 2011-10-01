<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="2.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
		xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:my="urn:x-my"
		xmlns:x="http://www.w3.org/1999/xhtml"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                exclude-result-prefixes="x atom xs my">
  <xsl:output
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    method="xhtml" version="1.0" media-type="text/html" indent="no"/>

  <xsl:param name="baseURI" />
  <xsl:param name="newsFeed" />
  <xsl:param name="blogFeed" />
  <xsl:param name="tip" />

  <xsl:variable name="menu">
    <ul>
      <li><a href="examples.html">Examples</a></li>
      <li><a href="http://openfacts2.berlios.de/wikien/index.php/BerliosProject:ESXX">Wiki</a></li>
      <li><a href="http://esxx.blogspot.com/">Blog</a></li>
      <li><a href="download.html">Download</a></li>
      <li><a href="http://developer.berlios.de/projects/esxx/">Contribute</a></li>
      <li><a href="license.html">License</a></li>
    </ul>
  </xsl:variable>

  <!-- The identity transform, except that PIs and comments are stripped -->
  <xsl:template match="element()">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="attribute()|text()">
    <xsl:copy/>
  </xsl:template>


  <!-- Example XML:
       <error>
	 <title>ESXX Server Error</title>
	 <subtitle>File not found</subtitle>
	 <message>Error message</message>
	 <stacktrace>Stack trace ...</stacktrace>
       </error> 
  -->

  <xsl:template match="/error">
    <xsl:variable name="view">
      <view>
	<post title="{title}" date="{current-dateTime()}">
	  <h3><xsl:value-of select="subtitle" /></h3>
	  <p><xsl:value-of select="message" /></p>
	  <xsl:if test="stacktrace/text()">
	    <h3>Stack trace</h3>
	    <pre class="stacktrace"><xsl:value-of select="stacktrace" /></pre>
	  </xsl:if>
	</post>

	<sidebar>
	  <ul>
	    <li>
	      <h2>Need fix?</h2>
	      <p>Do you suspect this error is because of a bug in ESXX? If so, please accept our apologies and make sure you're using the <a href="http://developer.berlios.de/project/showfiles.php?group_id=9645">latest stable version</a>.</p>
	    </li>

	    <li>
	      <h2>Helpful resources</h2>
	      <ul>
		<li><a href="http://openfacts2.berlios.de/wikien/index.php/BerliosProject:ESXX_-_Applications">Creating ESXX applications</a></li>
		
		<li><a href="http://openfacts2.berlios.de/wikien/index.php/BerliosProject:ESXX_-_The_runtime">ESXX Runtime Reference</a></li>
		
		<li>
		  <a href="http://developer.mozilla.org/en/docs/Core_JavaScript_1.5_Guide">JavaScript 1.5 Guide</a>,
		  <a href="http://developer.mozilla.org/en/docs/Core_JavaScript_1.5_Reference">Reference</a>
		</li>
		
		<li>
		  <a href="http://developer.mozilla.org/en/New_in_JavaScript_1.6">New in JavaScript 1.6</a>, 
		  <a href="http://developer.mozilla.org/en/New_in_JavaScript_1.7">1.7</a>,
		  <a href="http://developer.mozilla.org/en/New_in_JavaScript_1.8">1.8</a>
		</li>
		
		<li><a href="https://developer.mozilla.org/En/Core_JavaScript_1.5_Guide/Processing_XML_with_E4X">Processing XML with E4x</a></li>
		
		<li><a href="http://dispatchevent.org/roger/as3-e4x-rundown/">AS3 E4X Rundown</a></li>
		
		<li><a href="http://java.sun.com/javase/6/docs/api/">Java SE 6.0 API Specification</a></li>
		
		<li>
		  <a href="http://www.h2database.com/html/grammar.html">SQL Grammar</a>,
		  <a href="http://www.h2database.com/html/functions.html">Functions</a>,
		  <a href="http://www.h2database.com/html/datatypes.html">Data&#160;Types</a>
		</li>
		
		<li>
		  <a href="http://www.w3.org/TR/xslt20/">XSLT 2.0</a>, 
		  <a href="http://www.w3.org/TR/xpath-functions/">XPath 2.0 Functions</a>
		</li>
	      </ul>
	    </li>
	  </ul>
	</sidebar>
      </view>
    </xsl:variable>

    <xsl:apply-templates select="$view" />
  </xsl:template>


  <!-- Example XML:
       <page title="My page">
	 {HTML content}
       </page>

       or

       <not-found>missing.html</not-found>
  -->

  <xsl:template match="/x:page | /not-found">
    <xsl:variable name="view">
      <view>
	<xsl:choose>
	  <xsl:when test="local-name() = 'page'">
	    <post title="{@title}" date="{@date}">
	      <xsl:copy-of select="*"/>
	    </post>
	  </xsl:when>

	  <xsl:when test="local-name() = 'not-found'">
	    <post title="Page '{text()}' Not Found" date="{current-dateTime()}">
	      <p>The page you were looking for could not be found. Please
use the navigation links above.</p>

	      <p>If you think this is because of a site problem, please
contact <a href="mailto:martin@blom.org?subject=ESXX%20page%20not%20found!&amp;body=Page%20'{encode-for-uri(text())}'%20not%20found.">Martin Blom</a>.
	      </p>
	    </post>
	  </xsl:when>
	</xsl:choose>

	<sidebar>
	  <ul>
	    <li>
	      <h2>Did you know?</h2>
	      <a href="http://flattr.com/thing/1327/ESXX-Friendly-Server-side-JavaScript" 
		 target="_blank">
		<img src="http://api.flattr.com/button/button-static-50x60.png" 
		     title="Flattr this" border="0" class="right"/>
	      </a>
	      <xsl:apply-templates select="$tip" />
	    </li>

	    <li>
	      <h2><a href="http://developer.berlios.de/news/?group_id=9645">News</a></h2>

	      <xsl:apply-templates select="$newsFeed" />
	    </li>

	    <li>
	      <h2><a href="http://esxx.blogspot.com/">Latest blog posts</a></h2>

	      <xsl:apply-templates select="$blogFeed" />
	    </li>
	  </ul>
	</sidebar>
      </view>    
    </xsl:variable>

    <xsl:apply-templates select="$view" />
  </xsl:template>  


  <xsl:template match="x:view">
    <html>
      <head>
	<title>ESXX &#8212; <xsl:value-of select="x:post/@title" /></title>
	<meta name="keywords" content="ssjs, server-side javascript, ecmascript, xml, application server"/>
        <meta name="google-site-verification" content="sJoabVdANiaOz4jctmQVSx0ghra1Yex3eK5w7AK5NlU" />
	<link href="mailto:martin@blom.org" rev="made" />
	<link href='http://esxx.org/favicon.ico' rel='shortcut icon' type='image/vnd.microsoft.icon'/>
	<link href="{$baseURI}css/esxx.css" rel="stylesheet" type="text/css" media="screen" />
      </head>
      <body>
	<div id="bg1">
	  <div id="header">
	    <h1><a href="http://esxx.org/">ESXX<sup>0.9 &#946;</sup></a></h1>
	    <h2>A Divine Software&#8482; production</h2>
	  </div>
	</div>

	<div id="bg2">
	  <div id="header2">
	    <div id="menu">
	      <xsl:apply-templates select="$menu/*" />
	    </div>
	    
	    <div id="search">
	      <form action="http://www.google.com/cse" id="cse-search-box">
		<fieldset>
		  <input type="hidden" name="cx" value="partner-pub-2115989180089866:ayx3ndbp8fl" />
		  <input type="hidden" name="ie" value="UTF-8" />
		  <input type="text" name="q" class="text"/>
		  <input type="submit" name="sa" value="Search" class="button"/>
		</fieldset>
	      </form>
	      <script><![CDATA[
(function() {
  var f = document.getElementById("cse-search-box");
  if (f) if (f.q) {
    f.q.onblur  = function() { f.q.value = "Search site, blog, wiki"; };
    f.q.onfocus = function() { f.q.value = ""; };
    f.q.onblur();
  }
})();
]]></script>
	    </div>
	  </div>
	</div>

	<div id="bg3">
	  <div id="bg4">
	    <div id="bg5">
	      <div id="page">
		<div id="sidebar">
		  <xsl:apply-templates select="x:sidebar/*" />
		</div>

		<div id="content">
		  <xsl:apply-templates select="x:post" />
		</div>

<!--		<div id="donations">
		  <xsl:call-template name="donations" />
		</div> -->
	<p>&#160;</p>
	      </div>
	    </div>
	  </div>
	</div>

	<div id="footer">
	  <p>2007-<xsl:value-of select="year-from-date(current-date())"/>&#160;<a href="mailto:martin@blom.org?subject=ESXX">Martin Blom</a>, 
	    Divine Software. Design by 
	    <a href="http://www.nodethirtythree.com/">nodeThirtyThree</a> + 
	    <a href="http://www.freecsstemplates.org/">Free CSS Templates</a> (130&#176;, 60%).
	  </p>
	</div>

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

      </body>
    </html>
  </xsl:template>


  <xsl:template match="x:post">
    <div class="post">
      <div class="title">
	<h2><xsl:value-of select="@title" /></h2>
<!--	<p><xsl:value-of select="my:date(@date)" /></p> -->
      </div>

      <div class="entry">
	<xsl:apply-templates select="*" />
      </div>

<!--      
      <div class="meta">
	<p class="credit">Posted by <a href="#">Someone</a> on October 11, 2008</p>
	<p class="links"><a href="#" class="comments">Comments (18)</a> &#160;&#160;&#160;&#160;&#160; <a href="#" class="more">Read more</a></p>
      </div>
-->
    </div>
  </xsl:template>

  <!-- Tip -->
  <xsl:template match="x:tip">
    <p><xsl:copy-of select="node()" /></p>
  </xsl:template>

  <!-- News/Blog Atom Feed rules -->
  <xsl:template match="atom:feed">
    <ul>
      <xsl:apply-templates select="atom:entry" />
    </ul>
  </xsl:template>

  <xsl:template match="atom:entry">
    <li>
      <xsl:value-of select="my:date(atom:published)" /><br/>
      <a href="{atom:link[@rel = 'alternate' and @type = 'text/html']/@href}"
	 title="{atom:summary}">
	<xsl:value-of select="atom:title" />
      </a>
    </li>
  </xsl:template>


  <!-- Donation table -->
  <xsl:template name="donations">
<table summary="Donation options">
<caption>Encourage further development by making a donation!</caption>
<thead><tr>
<td>&#8364; 10</td>
<td>&#8364; 50</td>
<td>&#8364; 100</td>
<td>&#8364; 500</td>
<td>&#8364; 1000</td>
<td>&#8364; 5000</td>
</tr></thead>
<tbody><tr>
<td>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post"><div>
<input type="hidden" name="cmd" value="_xclick" />
<input type="hidden" name="business" value="martin@blom.org" />
<input type="hidden" name="item_name" value="ESXX" />
<input type="hidden" name="amount" value="8" />
<input type="hidden" name="no_shipping" value="1" />
<input type="hidden" name="logo_custom" value="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" />
<input type="hidden" name="no_note" value="1" />
<input type="hidden" name="currency_code" value="EUR" />
<input type="hidden" name="tax" value="2" />
<input type="hidden" name="lc" value="US" />
<input type="hidden" name="bn" value="PP-BuyNowBF" />
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</div></form>
</td>
<td>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post"><div>
<input type="hidden" name="cmd" value="_xclick" />
<input type="hidden" name="business" value="martin@blom.org" />
<input type="hidden" name="item_name" value="ESXX" />
<input type="hidden" name="amount" value="40" />
<input type="hidden" name="no_shipping" value="1" />
<input type="hidden" name="logo_custom" value="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" />
<input type="hidden" name="no_note" value="1" />
<input type="hidden" name="currency_code" value="EUR" />
<input type="hidden" name="tax" value="10" />
<input type="hidden" name="lc" value="US" />
<input type="hidden" name="bn" value="PP-BuyNowBF" />
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</div></form>
</td>
<td>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post"><div>
<input type="hidden" name="cmd" value="_xclick" />
<input type="hidden" name="business" value="martin@blom.org" />
<input type="hidden" name="item_name" value="ESXX" />
<input type="hidden" name="amount" value="80" />
<input type="hidden" name="no_shipping" value="1" />
<input type="hidden" name="logo_custom" value="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" />
<input type="hidden" name="no_note" value="1" />
<input type="hidden" name="currency_code" value="EUR" />
<input type="hidden" name="tax" value="20" />
<input type="hidden" name="lc" value="US" />
<input type="hidden" name="bn" value="PP-BuyNowBF" />
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</div></form>
</td>
<td>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post"><div>
<input type="hidden" name="cmd" value="_xclick" />
<input type="hidden" name="business" value="martin@blom.org" />
<input type="hidden" name="item_name" value="ESXX" />
<input type="hidden" name="amount" value="400" />
<input type="hidden" name="no_shipping" value="1" />
<input type="hidden" name="logo_custom" value="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" />
<input type="hidden" name="no_note" value="1" />
<input type="hidden" name="currency_code" value="EUR" />
<input type="hidden" name="tax" value="100" />
<input type="hidden" name="lc" value="US" />
<input type="hidden" name="bn" value="PP-BuyNowBF" />
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</div></form>
</td>
<td>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post"><div>
<input type="hidden" name="cmd" value="_xclick" />
<input type="hidden" name="business" value="martin@blom.org" />
<input type="hidden" name="item_name" value="ESXX" />
<input type="hidden" name="amount" value="800" />
<input type="hidden" name="no_shipping" value="1" />
<input type="hidden" name="logo_custom" value="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" />
<input type="hidden" name="no_note" value="1" />
<input type="hidden" name="currency_code" value="EUR" />
<input type="hidden" name="tax" value="200" />
<input type="hidden" name="lc" value="US" />
<input type="hidden" name="bn" value="PP-BuyNowBF" />
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</div></form>
</td>
<td>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post"><div>
<input type="hidden" name="cmd" value="_xclick" />
<input type="hidden" name="business" value="martin@blom.org" />
<input type="hidden" name="item_name" value="ESXX" />
<input type="hidden" name="amount" value="4000" />
<input type="hidden" name="no_shipping" value="1" />
<input type="hidden" name="logo_custom" value="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" />
<input type="hidden" name="no_note" value="1" />
<input type="hidden" name="currency_code" value="EUR" />
<input type="hidden" name="tax" value="1000" />
<input type="hidden" name="lc" value="US" />
<input type="hidden" name="bn" value="PP-BuyNowBF" />
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit" alt="PayPal - The safer, easier way to pay online!" />
<img alt="" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1" />
</div></form>
</td>
</tr></tbody></table>
  </xsl:template>


  <!-- my:date formats a date string as "Month NNth, year" -->
  <xsl:function name="my:date">
    <xsl:param name="date" />
    <xsl:variable name="dt" select="xs:dateTime(translate($date, ' ', 'T'))" />
    <xsl:value-of select="format-dateTime($dt, '[MNn] [D1o], [Y]', 'en', (), ())" />
  </xsl:function>

  <!-- my:format-java-date formats a Java timestamp as "YYYY-MM-DD, HH:MM:SS" -->
  <xsl:function name="my:format-java-date">
    <xsl:param name="millis" />
    <xsl:variable name="dt" select="xs:dateTime('1970-01-01T00:00:00') 
				    + $millis * xs:dayTimeDuration('PT0.001S')"/>
    <xsl:value-of select="format-dateTime($dt, '[Y0001]-[M01]-[D01] [H01]:[m01]:[s01]', 
			  'en', (), ())" />
  </xsl:function>

</xsl:stylesheet>
