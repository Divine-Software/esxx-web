
esxx.include("esxx/harmony.js");

function Main() {
  this.started = new Date();

  this.blogURI = new URI("http://esxx.blogspot.com/feeds/posts/default?max-results=3");
  this.blogFeed = null;
  this.blogUpdated = 0;

  this.newsURI = new URI("http://developer.berlios.de/export/rss20_bsnews.php?group_id=9645");
  this.newsFeed = null;
  this.newsUpdated = 0;
}

function Main.prototype.page(req) {
  var page = req.args.page || "index.html";

  var file_info = new URI("pages/").load().*.(name == page);

  if (file_info.length() == 1) {
    // Calculate the Last-Modified header based on when the page was
    // last changed and when the ESXX application was
    // started. Calculate the Expires header based on settings.maxAge
    // in 'index.esxx'.

    var last_modified = Math.round(Math.max(this.started, file_info.lastModified) / 1000) * 1000;
    var max_age       = esxx.document.settings.maxAge;
    var expires       = new Date().getTime() + max_age * 1000;

    var headers       = {
      "Last-Modified":  new Date(last_modified).toUTCString(),
      "Cache-Control":  "max-age=" + max_age + ", public",
      "Expires":        new Date(expires).toUTCString()
    };

    var if_modified_since = req.headers["If-Modified-Since"];

    if (if_modified_since) {
      // Convert to ms
      if_modified_since = new Date(if_modified_since).getTime();

      if (if_modified_since >= last_modified) {
	return new ESXX.Response(ESXX.Response.NOT_MODIFIED, headers,
				 null, "text/html");
      }
    }

    // Load the file and hand it over to the 'text/html' style-sheet.
    var body = new URI(file_info.@uri).load();
    body.@date = new Date(parseInt(file_info.lastModified)).toISOString();

    var rc = new ESXX.Response(ESXX.Response.OK, headers,
			       body, "text/html");

    // Enable Content-Length header
    rc.buffered = true;

    return rc;
  }
  else {
    // Display the page-not-found view
    return this.notFound(req);
  }
}

function Main.prototype.notFound(req) {
  var page = req.args.page || "index.html";

  return new ESXX.Response(ESXX.Response.NOT_FOUND, {},
			   <not-found>{page}</not-found>, "text/html");
}

function Main.prototype.error(req, ex) {
  // Display the error view
  return new ESXX.Response(ESXX.Response.INTERNAL_SERVER_ERROR, {},
			   <error>
			   <title>I'm feeling dizzy</title>
			   <subtitle>{ex.getClass().getName()}</subtitle>
			   <body>{ex}</body>
			   </error>, "text/html");
}

function Main.prototype.setXSLTParams(req, next) {
  let now = new Date().getTime();

  // (Try to) update news feed every 10 minutes
  try {
    if (now - this.newsUpdated > 600e3) {
      this.newsUpdated = now;
      
      // Convert to Atom
      let rss = this.newsURI.load();
      let cnt = 0;

      this.newsFeed = <feed xmlns="http://www.w3.org/2005/Atom"/>;

      for each (let item in rss.channel.item) {
	let date = new Date(item.pubDate);

	this.newsFeed.* += <entry xmlns="http://www.w3.org/2005/Atom">
	  <title>{item.title}</title>
	  <updated>{date.toISOString()}</updated>
	  <summary>{item.description.toString().substring(0, 255)}</summary>
	  <link rel="alternate" type="text/html" href={item.link}/>
	  </entry>;

	if (++cnt >= 3) {
	  break;
	}
      }
    }
  }
  catch (ex) {
    // Just log the error
    esxx.log.error("Failed to retrieve News feed: " + ex);
  }

  if (!(this.newsFeed instanceof XML)) {
    // Make sure this.newsFeed is XML, or else the XSLT stylesheet
    // fails to execute
    this.newsFeed = <dummy/>;
  }


  // (Try to) update blog feed every 10 minutes
  try {
    if (now - this.blogUpdated > 600e3) {
      this.blogUpdated = now;
      this.blogFeed = this.blogURI.load();
    }
  }
  catch (ex) {
    esxx.log.error("Failed to retrieve Blog feed: " + ex);
  }

  if (!(this.blogFeed instanceof XML)) {
    // Make sure this.blogFeed is XML, or else the XSLT stylesheet
    // fails to execute
    this.blogFeed = <dummy/>;
  }

  let res = next();

  res.params.baseURI = new URI(req.scriptURI, "..");
  res.params.newsFeed = this.newsFeed;
  res.params.blogFeed = this.blogFeed;

  return res;
}


// Create an instance of the Main class
var main = new Main();
