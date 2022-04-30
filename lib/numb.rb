#!/usr/bin/env ruby
# Id$ nonnax 2022-04-30 11:09:50 +0800
# notta unified mapper, boom!
class Numb
  class Response < Rack::Response; end

  attr :req, :res, :env
  def initialize(&block)
    @block=block
  end
  def call(env)
    @req=Rack::Request.new(env)
    @res=Rack::Response.new(nil, 404)
    @env=env
    @once=false
    instance_eval(&@block)
    not_found{ res.write 'Not Found'}
    res.finish
  end
  def on(u, **params)
    return unless req.path_info.match?(/#{u}\/?\Z/)
    pp [u, req.path_info]

    res.status=200
    yield *params.merge(req.params.transform_keys(&:to_sym)).values
  end
  def get;  yield if req.get? end
  def post; yield if req.post? end
  def not_found; run_once{yield} if res.status==404 end

  private def run_once; return if @once; @once=true; yield end
end
