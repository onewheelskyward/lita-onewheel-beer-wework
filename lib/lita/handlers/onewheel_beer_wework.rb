module Lita
  module Handlers
    class OnewheelBeerWework < Handler
      REDIS_KEY = 'onewheel-beer-wework'
      LOCATIONS = %w(1fs 1fn 2fs 2fn 3fn)

      route /^wework\s+([\w\/+_-]+)\s+(.*)$/i,
            :command_add_key,
            command: true,
            help: {'!wework 2fS Beer' => 'Add a beer to 2fS'}
      route /^wework$/i,
            :command_list_keys,
            command: true,
            help: {'!wework            ' => 'list all beers'}
      route /^wework\s+(\w+)$/i,
            :command_fetch_key,
            command: true,
            help: {'!wework 2fS        ' => 'fetch the beer for 2fS'}

      def command_add_key(response)
        key = response.matches[0][0].downcase
        unless LOCATIONS.include? key
          Lita.logger.info "#{key} was not found in the floors array."
          return
        end
        beer_name = response.matches[0][1]
        key = key[0..1] + key[-1].upcase
        value = {
            name: beer_name,
            user: response.user.name,
            time: Time.now
        }.to_json
        redis.hset(REDIS_KEY, key, value)
        response.reply "Logged #{beer_name} at #{key}!"
      end

      def command_fetch_key(response)
        key = response.matches[0][0]

        values = get_values_that_start_with_key(key)
        values.each do |keg|
          floor_id = keg.keys[0]
          keg_meta = JSON.parse keg[floor_id]
          response.reply "#{floor_id}: #{keg_meta['name']}"
        end
      end

      def command_list_keys(response)
        replies = []

        all = redis.hgetall(REDIS_KEY)
        all.each do |key, val|
          replies.push format_key_val_response(key, val)
        end
        response.reply replies.join ', '
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

      def format_key_val_response(all_key, all_val)
        "#{all_key}: #{all_val}"
      end
    end

    Lita.register_handler(OnewheelBeerWework)
  end
end
