module Lita
  module Handlers
    class Prman < Handler
      PRS = {
        "latest" => "Your latest PR is set and it's testing against travis",
        "first" => "I have no clue what your first PR was",
        "matsko" => "Matias has over 100 PRs waiting for Angular2",
        "igor" => "Igor is the king",
        "1234" => "Yegor took care of this issue"
      }

      route(
        /^submit\s+(.+)/i,
        :submit,
        :command => true,
        :help    => {
          "submit NAME" => "Will tell the submission status for the PR of NAME"
        }
      )

      route(
        /^debug/i,
        :debug,
        :command => true,
        :help    => {
          "debug" => "This will list the submit commands"
        }
      )

      def debug(response)
        response.reply("Possible values: (ngbot submit [" + PRS.keys.join(", ") + "])")
      end

      def submit(response)
        pr = response.matches.first.first
        if pr.nil? || pr.empty?
          response.reply("You need to enter in something") 
          return
        end

        if is_repeated(response.user, pr)
          response.reply("You just asked that man...") 
          return
        end

        if pr == "debug"
          response.reply("Possible values: " + PRS.keys.join(", "))
          return
        end

        status = PRS[pr]
        if status.nil?
          status = "Error: PR not found"   
        end

        cache_message(response.user, pr)
        response.reply(status) 
      end

      def cache_message(user, pr)
        redis.set(user.id, pr)
      end

      def is_repeated(user, pr)
        match = redis.get(user.id)
        pr == match
      end

      Lita.register_handler(self)
    end
  end
end
