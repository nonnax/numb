#!/usr/bin/env ruby
# Id$ nonnax 2022-04-25 22:40:25 +0800
require_relative 'lib/numb'

# Mapa.settings[:views]='views'

$sum = 0

Thread.new do # trivial example work thread
  loop do
     sleep 0.12
     $sum += 1
  end
end

App = Numb.new do
  def erb(s, **x)
    res.write s
  end
  def session
    {}
  end
  #
  # path test first
  #
  on '/thread' do
    res.write "Testing background work thread: sum is #{$sum}"
  end

  on '/tv' do |params|
    get do
      session[:name]='mapa'
      erb 'watch:tv:', title: 'tv time'
    end
  end

  # get do
    on '/login/name' do |name, params|
      get do
        session[:name]=name
        erb 'welcome:'+String(session[:name])+String(params), title: 'welcome'
      end
    end
  # end
  #
  # method test first
  #
  get do
    on '/any' do |any|
      erb 'watch:any'+String(any), title: 'movie time'
    end
  end

  on '/' do
    res.redirect '/thread'
  end

  not_found do
    erb 'notto foundo'
  end

end
