require 'set'

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
    links = links + Marshal.load(@redis.get(key)) unless @redis.get(key).nil? # merge old & new array

    array_to_str = Marshal.dump(links)

    begin
      { status: @redis.set(key, array_to_str) }
    rescue Redis::BaseError => e
      { status: e.message }
    end
  end

  def search_data
    from, to = @params[:from].to_i, @params[:to].to_i
    from, to = to, from if from > to # reverse

    result = Set.new()

    (from..to).each do |date|
      begin
        unless check_data(date)
          Marshal.load(@redis.get(date)).each do |url|
            result.add(url)
          end
        end
      rescue Redis::BaseError => e
        return { status: e.message }
      end
    end

    { domains: result.to_a, status: 'OK' }
  end

  private

  def check_data(date)
    @redis.get(date).nil?
  end
end
