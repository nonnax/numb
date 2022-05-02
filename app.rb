#!/usr/bin/env ruby
# Id$ nonnax 2022-04-25 22:40:25 +0800
require_relative 'lib/numb'

Numb.settings[:layout]='layout_001'

$sum = 0

Thread.new do # trivial example work thread
  loop do
     sleep 0.12
     $sum += 1
  end
end

AppB = Numb.new do
  get do
    res.write 'inner world'
  end
end

App = Numb.new do
  #
  # path test first
  #
  on '/thread' do
    res.write "Testing background work thread: sum is #{$sum}"
  end

  on '/tv' do |params|
    get do
      erb 'watch:tv:'+String(session[:name]), title: 'tv time'
    end
  end

  #
  # method first test
  # url with slug. ie /url/:slug
  get do
    on '/any/:slug', default: 'default' do |slug, params|
      erb 'watch:'+String(slug)+String(params), title: 'movie time'
    end

    on( '/login', name:'', surname:'') do |name, sur|
      session[:name]=name
      erb 'welcome:'+String(session[:name])+String(sur), title: 'welcome'
    end
  end

  #
  # method with url test. numb.rb only
  #
  # get '/all' do |all|
     # erb 'watch:all'+String(all), title: 'all time'
  # end
  #
  # test position in prog flow
  #
  on '/' do
    res.redirect '/thread'
  end

  not_found do
    erb 'notto foundo'
  end

  on '/inner' do
    halt AppB
  end
end
