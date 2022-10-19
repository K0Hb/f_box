require 'set'

class Statistics
  def initialize(params, mode)
    @params = params
    @mode = mode
    @redis = Redis::Namespace.new("f_box", :redis => Redis.new)
  end

  def self.call(*args)
    new(*args).main
  end

  def main
    if @mode == 'write'
      write
    elsif @mode == 'get'
      search_data
    end
  end

  private

  def write
    key = Time.now.to_i
    byte_str = Marshal.dump(@params)

    begin
      @redis.set(key, byte_str)
      { status: 'ok', time: key, data: @redis.get(key) }
    rescue Redis::BaseError => e
      { status: 'fail', message: e.message }
    end
  end

  def search_data
    from, to = @params[:from].to_i, @params[:to].to_i
    from, to = to, from if from > to # reverse

    result = Set.new()

    (from..to).each do |data|
      begin
        result.add(@redis.get(data)) if @redis.get(data)
      rescue Redis::BaseError => e
        return { status: 'fail', message: e.message }
      end
    end

    { domains: result.map { |url| Marshal.load(url) } }
  end
end
