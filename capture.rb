require "rubygems"
require "httparty"
require "cgi"
require 'json'

class Twitter
  include HTTParty
  base_uri 'search.twitter.com'
  
  def search term
    rsp = self.class.get("/search.json?q=#{CGI::escape term}&rpp=25")
    JSON.parse(rsp.body)['results']
  end
  
  
end


# helper method for when a tweet was created
def tw_time tweet
  DateTime.parse tweet['created_at'] unless tweet.nil?
end

def diff_time a, b
  ((a - b) * 24 * 60 * 60)
end


twitter = Twitter.new

File.open("_terms.txt").each_with_index do |term, i|
  next if term.match /^ /

  term.chomp!

  results = twitter.search term

  count = results.size

  start_time = tw_time results.first
  end_time   = tw_time results.last

  diff = if start_time.nil? || end_time.nil?
    -1
  else
    diff_time(start_time, end_time)
  end
  
  File.open("public/#{i}.txt", 'a') do |f| 
    f.write("#{start_time || DateTime.now} #{count} #{diff} \n")
  end

end