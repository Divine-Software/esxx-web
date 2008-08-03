
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

    var last_modified = Math.max(this.started, file_info.lastModified);
    var max_age       = esxx.document.settings.maxAge;
    var expires       = new Date().getTime() + max_age * 1000;

    // Load the file and hand it over to the 'text/html' style-sheet.
    var body = new URI(file_info.@uri).load();

    return new Response(200, {
	"Last-Modified": new Date(last_modified).toUTCString(),
	"Cache-Control": "max-age=" + max_age + ", public",
	"Expires":       new Date(expires).toUTCString() 
      }, body, "text/html");
    
  }
  else {
    // Display the page-not-found view
    return this.notFound(req);
  }
}

function Main.prototype.notFound(req) {
  var page = req.args.page || "index.html";

  return new Response(404, {}, <not-found>{page}</not-found>, "text/html");
}

function Main.prototype.error(req, ex) {
  // Display the error view
  return new Response(500, {}, <error>{ex}</error>, "text/html");
}

var main = new Main();
