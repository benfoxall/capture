require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  @list = []
  
  File.open("_terms.txt").each_with_index do |term, i|
    active = term.match(/^ /).nil?
    lines = begin
      wc = `wc -l public/#{i}.txt`
      wc.split()[0]
    rescue
    end
    @list << [term, lines, active]
  end

  haml :index
end
