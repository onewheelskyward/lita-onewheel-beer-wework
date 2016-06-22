module Lita
  module Handlers
    class OnewheelBeerWework < Handler
      REDIS_KEY = 'onewheel-doc'

      route /^docdel\s+([\w\/+_-]+)$/,
            :command_del_key,
            command: true,
            help: {'!docdel key     ' => 'removes a key'}
      route /^doc\s+([\w\/+_-]+)\s+(.*)$/,
            :command_add_key,
            command: true,
            help: {'!doc key http://' => 'Add a key using key_val and the http link'}
      route /^doc$/,
            :command_list_keys,
            command: true,
            help: {'!doc            ' => 'list all keys'}
      route /^doc\s+(\w+)$/,
            :command_fetch_key,
            command: true,
            help: {'!doc key        ' => 'fetch the value for key_val'}

      def command_add_key(response)
        key = response.matches[0][0]
        value = response.matches[0][1]
        redis.hset(REDIS_KEY, key, value)
        response.reply "Documented #{key} as #{value}"
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
        response.reply replies.join "\n"
      end

      def command_del_key(response)
        key = response.matches[0][0]
        y = redis.hdel(REDIS_KEY, key)
        response.reply "Document deleted: #{key}"
      end

      def get_values_that_start_with_key(key)
        values = []
        all = redis.hgetall(REDIS_KEY)
        all.each do |all_key, all_val|
          if all_key =~ /^#{key}/
            values.push format_key_val_response(all_key, all_val)
          end
        end
        reply = values.join "\n"
      end

      def format_key_val_response(all_key, all_val)
        "#{all_key}: #{all_val}"
      end
    end

    Lita.register_handler(OnewheelBeerWework)
  end
end
