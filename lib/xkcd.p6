use v6.c;
use HTTP::UserAgent;
use JSON::Fast;

# Define the URLs as globals
our $xkcd-url = "https://www.xkcd.com/";
our $image-url = "https://imgs.xkcd.com/comics/";
our $explanation-url = "https://explainxkcd.com/";
our $archive-url = "https://what-if.xkcd.com/archive/";

class Comic {
    has Int $.number where * > 0;
    has Str $.link = $xkcd-url ~ self.number ~ "/info.0.json";
    has Str $.title is rw;
    has Str $.alt-text is rw;
    has Str $.image-link is rw;

    method get-xkcd-data() {
        my $ua = HTTP::UserAgent.new;
        $ua.timeout = 10;

        my $response = $ua.get(self.link).content;
        my $xkcd-data = from-json($response);
        self.title = $xkcd-data<title>;
        self.alt-text = $xkcd-data<alt>;
        self.image-link = $xkcd-data<img>;
    }

}

sub get-latest-comic-num($ua) {
    # Uses the xkcd JSON API to look up the number
    # of the latest xkcd comic.
    # Returns that number as an integer
    my $url = "https://xkcd.com/info.0.json";
    my $response = $ua.get($url).content;
    my $xkcd = from-json($response);
    
    $xkcd<num>
}



my $c = Comic.new(:number(10));
$c.get-xkcd-data();
say $c.title;
