#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-04-30 11:09:50 +0800
# non unified mapper, boom!
class Numb
  class Response < Rack::Response; end

  attr :req, :res, :env

  def initialize(&block)
    @block = block
  end

  def call(env)
    @req = Rack::Request.new(env)
    @res = Rack::Response.new(nil, 404)
    @env = env
    @once = false
    instance_eval(&@block)
    not_found { res.write 'Not Found' }
    res.finish
  end

  def on(u, **params)
    return unless req.path_info.match?(%r{\A#{u}/?\Z})

    found { yield(*params.merge(req.params.transform_keys(&:to_sym)).values) }
  end

  def get(&block)
    found(&block) if req.get?
  end

  def post(&block)
    found(&block) if req.post?
  end

  def delete(&block)
    found(&block) if req.delete?
  end

  def not_found(&block)
    run_once(&block) if res.status == 404
  end

  def session
    env['rack.session']
  end

  private def found
    res.status = 200
    yield
    res.status = 404 if res.body.empty? && res.status == 200
  end
  private def run_once
    return if @once

    @once = true
    yield
  end
end
