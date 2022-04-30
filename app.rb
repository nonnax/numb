#!/usr/bin/env ruby
# Id$ nonnax 2022-04-25 22:40:25 +0800
# require_relative 'lib/numb0'
require 'numb'
require_relative 'lib/search'
require 'json'

Numb.settings[:views]=:views

@settings=Hash.new{|h,k|h[k]={}}
@settings[:models]='models'
@settings[:timer]=Time.now


def repath(f)
  File.join(@settings[:models],f)
end

WATCHLIST=  repath('watchlist.json')
TVF=        repath('tv-series-flixtor.json')
TVMF=       repath('tv-show-myflixer.json')
MOVIESMF=   repath('movie-myflixer.json')
MOVIES=     repath('movies-flixtor.json')
ANIME=      repath('kissanime-series.json')
ANIME_PRO=  repath('kissanimes_pro_new_season.json')
CB=         repath('cb.json')
NAVBAR = %w[/tv/f /tv/m /movie/f /movie/m /boom]

J = Hash.new{|h, k| h[k]=JSON.load(File.read k, symbolize_names: true)}

App = Numb.new do

  on '/sub' do
    halt ->(e){[200, {}, ['hey']]}
  end

  on '/tv/f' do
    get do
      data=J[TVF]
      erb :watch, title: 'TV flixtor', data:, navbar: NAVBAR
    end
  end

  on '/tv/m' do
    get do
      data=J[TVMF]
      erb :watch, title: 'TV myflixer', data:, navbar: NAVBAR
    end
  end

  on '/movie/f' do |param|
    get do
      data=J[MOVIES]
      erb :watch, title: 'Movie F', data:, navbar: NAVBAR
    end
  end

  on '/movie/m' do |param|
    get do
      data=J[MOVIESMF]
      erb :watch, title: 'Movie MyF', data:,  navbar: NAVBAR
    end
  end

  on '/boom' do |param|
    get do
      data=[J[MOVIESMF], J[MOVIES], J[TVMF], J[TVF]].map(&:values).flatten
      erb :watch_all, title: 'Movie MyF', data:,  navbar: NAVBAR
    end
  end

  on '/cb', page:1 do |page|
    get do
      page &&= page.to_i
      db=J[CB].values.each_slice(50)
      data=db.to_a[page].flatten
      erb :watch_all, title: String(db.size), data:,  navbar: NAVBAR
    end
  end

  on '/search', q:'' do |q|
    get do
      data=search(q).values
      erb :watch_all, title: String(data.size), data:,  navbar: NAVBAR
    end
  end

  # on '/cb' do
    # get do
     # res.redirect '/cb/page?page=1'
    # end
  # end

  on '/' do
    get do
      erb '<div class="item"><h1>Welcome</h1></div>', title: 'Welcome',  navbar: NAVBAR
    end
  end
end
