module Lita
  module Handlers
    class OnewheelBeerWework < Handler
      REDIS_KEY = 'onewheel-doc'

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
        unless %w(1fs 1fn 2fs 2fn 3fn).include? key
          Lita.logger.info "#{key} was not found in the floors array."
          return
        end
        key = key[0..1] + key[-1].upcase
        value = response.matches[0][1]
        redis.hset(REDIS_KEY, key, value)
        response.reply "Logged #{value} at #{key}!"
      end

      def command_fetch_key(response)
        key = response.matches[0][0]

        reply = get_values_that_start_with_key(key)
        response.reply reply
      end

      def command_list_keys(response)
        replies = []

        all = redis.hgetall(REDIS_KEY)
        all.each do |key, val|
          replies.push format_key_val_response(key, val)
        end
        response.reply replies.join ", "
      end

      def get_values_that_start_with_key(key)
        values = []
        all = redis.hgetall(REDIS_KEY)
        all.each do |all_key, all_val|
          if all_key =~ /^#{key}/i
            values.push format_key_val_response(all_key, all_val)
          end
        end
        reply = values.join ", "
      end

      def format_key_val_response(all_key, all_val)
        "#{all_key}: #{all_val}"
      end
    end

    Lita.register_handler(OnewheelBeerWework)
  end
end
