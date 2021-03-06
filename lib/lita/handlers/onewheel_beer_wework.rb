require 'json'

module Lita
  module Handlers
    class OnewheelBeerWework < Handler
      REDIS_KEY = 'onewheel-beer-wework'
      LOCATIONS = %w(1fs 1fn 2fs 2fn 3fn)

      route /^wework\s+([\w\/+_-]+)\s+(.*)$/i,
            :command_add_beer,
            command: true,
            help: {'!wework 2fS Beer   ' => 'Add a beer to 2fS', '!wework 1fn blow   ' => 'Blows the keg on 1fn.'}
      route /^wework$/i,
            :command_list_beers,
            command: true,
            help: {'!wework            ' => 'list all beers'}
      route /^wework\s+(\w+)$/i,
            :command_fetch_beer,
            command: true,
            help: {'!wework 2fS        ' => 'fetch the beer for 2fS'}

      http.get '/wework', :get_json_beers  # For aaronpk and Loqi

      def command_add_beer(response)
        reply = ''
        key = response.matches[0][0].downcase
        unless LOCATIONS.include? key
          Lita.logger.info "#{key} was not found in the floors array."
          return
        end
        beer_name = response.matches[0][1]
        key = key[0..1] + key[-1].downcase

        if %w(blow blown).include? beer_name.downcase
          stored = JSON.parse(redis.hget(REDIS_KEY, key))
          stored['name'] += ' BLOWN'
          reply = "#{key} #{stored['name']}"
          value = stored.to_json
        elsif %w(unblow unblown).include? beer_name.downcase
          stored = JSON.parse(redis.hget(REDIS_KEY, key))
          stored['name'].sub! ' BLOWN', ''
          reply = "#{key} #{stored['name']}"
          value = stored.to_json
        else
          value = {
              name: beer_name,
              user: response.user.name,
              time: Time.now
          }.to_json
          reply = "Logged #{beer_name} at #{key}!"
        end

        redis.hset(REDIS_KEY, key, value)
        response.reply reply
      end

      def command_fetch_beer(response)
        key = response.matches[0][0]

        values = get_values_that_start_with_key(key)
        values.each do |keg|
          floor_id, keg_name = get_floor_and_keg_name(keg)
          response.reply "#{floor_id}: #{keg_name}"
        end
      end

      def get_floor_and_keg_name(keg)
        floor_id = keg.keys[0]
        keg_meta = JSON.parse(keg[floor_id])
        return floor_id, keg_meta['name']
      end

      def command_list_beers(response)
        LOCATIONS.each do |floor|
          if (data = redis.hget(REDIS_KEY, floor))
            floor, keg_name = get_floor_and_keg_name(floor => data)
            response.reply "#{floor}: #{keg_name}"
          end
        end
      end

      def get_json_beers(request, response)
        all_beers = []
        LOCATIONS.each do |floor|
          if (data = redis.hget(REDIS_KEY, floor))
            d = JSON.parse(data)
            d['id'] = floor
            all_beers.push d
          end
        end
        Lita.logger.info 'Sending beers via HTTP.'
        response.headers['Content-Type'] = 'application/json'
        response.write all_beers.to_json
      end

      def get_values_that_start_with_key(key)
        values = []
        all = redis.hgetall(REDIS_KEY)
        all.each do |all_key, all_val|
          if all_key =~ /^#{key}/i
            values.push all_key => all_val
          end
        end
        values
      end
    end

    Lita.register_handler(OnewheelBeerWework)
  end
end
