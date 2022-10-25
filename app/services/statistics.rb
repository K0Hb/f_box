require 'set'
require 'uri/http'

class Statistics
  DB_NAME = 'f_box'

  def initialize(params, mode)
    @params = params
    @mode = mode
    @db_name = DB_NAME
    @redis = Redis::Namespace.new(@db_name, redis: Redis.new)
  end

  def write
    key = Time.now.to_i
    links = @params

    begin
      links.each { |url| @redis.zadd('links', key, url) }
    rescue Redis::BaseError => e
      return { status: e.message }
    end

    { status: 'OK' }
  end

  def search_data
    from, to = @params[:from].to_i, @params[:to].to_i
    from, to = to, from if from > to # reverse

    result = Set.new

    begin
      urls = @redis.zrangebyscore('links', from, to)
    rescue Redis::BaseError => e
      return { status: e.message }
    end

    urls.each { |url| result.add(parse_domain(url)) }

    { domains: result, status: 'OK' }
  end

  private

  def parse_domain(url)
    url = URI.parse(url)
    url = URI.parse("http://#{url}") if url.scheme.nil?
    url.host.downcase
  end
end
