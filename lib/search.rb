#!/usr/bin/env ruby
# Id$ nonnax 2022-04-26 09:37:05 +0800
require 'rubytools/noko_party'
require 'json'
# q,=ARGV
MFROOT='https://myflixer.to'

def search(q, &block)
  data={}
  u='https://myflixer.to/search/'+String(q)
  @doc=NokoParty.get(u)
  @doc.search('.film-poster').map.with_index{|d|
    div, img, link = d.children.reject{|c| c.name=='text'}
    div_text, img_src, link_title, link_href=[div.text, img[:'data-src'], link&.[](:title), link&.[](:href)]
    info=d.parent.search('.film-detail .fd-infor').text
    next unless [img_src, link_href].any?
    captures=[img_src, MFROOT+link_href, link_title, ([div_text]+info.split).join(' ')]

    h=%i(img link title meta).zip(captures).to_h if data
    data[h[:link]]=h
    block[h] if block
  }
  data
end
# puts JSON.pretty_generate(data)

