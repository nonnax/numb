#!/usr/bin/env ruby
# Id$ nonnax 2022-04-24 19:13:24 +0800
require 'rack'
require 'rack/test'
require 'test/unit'

OUTER_APP = Rack::Builder.parse_file("config.ru").first

class TestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_root
    get "/"
     # assert last_response.ok?
     assert_equal last_response.status, 302

  end
  def test_root_post
    post "/"
     # assert last_response.ok?
     assert_equal last_response.status, 302
  end

  def test_login_get
    get "/login/name"
     assert_equal last_response.status, 200
     # assert last_response.body.include?('name')
  end

  # def test_login_post
    # post "/login/name"
     # assert_equal last_response.status, 405 # no method
  # end

  def test_normal
    get "/tv"
     assert_equal last_response.status, 200
  end

  def test_any
    get "/any", options: 'default'
     # assert last_response.ok?
     assert_equal last_response.status, 200
     assert last_response.body.match?('default')
  end

  def test_not_found
    get "/adgads/asdfa"
     assert_equal last_response.status, 404
     # assert_equal last_response.body, 'notto foundo'
  end
end
