module Lita
  module Handlers
    class Prman < Handler
      PRS = {
        "latest" => "Your latest PR is set and it's testing against travis",
        "first" => "I have no clue what your first PR was",
        "1234" => "Yegor took care of this issue"
      }

      route(
        /^ngbot submit \s+(.+)/i,
        :submit,
        :command => true,
        :help    => {
          "ngbot submit NAME" => "Will tell the submission status for the PR of NAME"
        }
      )

      # insert handler code here
      def submit(response)
        pr = response.matches.first.first
        if is_repeated(pr)
          response.reply("You just asked that man...") 
          return
        end

        status = PRS[pr]
        unless status.present?
          status = "Error: PR not found"   
        end

        cache_message(pr)
        response.reply(status) 
      end

      def cache_message(pr)
        redis.set(user, pr)
      end

      def is_repeated(pr)
        match = redis.get(user)
        pr == match
      end

      Lita.register_handler(self)
    end
  end
end
