# Inspired by https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html
# module SetCurrentRequestDetails extend ActiveSupport::Concern
#   included do
#     before_action do
#       Current.params_coords = params  # not query_parameters or request.query_string and because it's not a POST, not request_parameters
#       Current.radius = params #query_parameters
#       puts "DEBUG REQUEST PARAMS"
#       puts params # request_parameters
#       puts "DEBUG QUERY PARAMS"
#       # puts query_parameters
#     end
#   end
# end