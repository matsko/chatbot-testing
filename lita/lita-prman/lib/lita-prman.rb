require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/prman"

Lita::Handlers::Prman.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
