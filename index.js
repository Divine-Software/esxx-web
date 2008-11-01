
function Main() {
  this.started = new Date();
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
			   <error>{ex}</error>, "text/html");
}

var main = new Main();
