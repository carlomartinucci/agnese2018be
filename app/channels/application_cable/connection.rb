module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # identified_by :current_user_slug

    # def connect
    #   self.current_user_slug = find_current_user_slug_or_create
    # end

    # private
    #   def find_current_user_slug_or_create
    #     user_slug = cookies.signed[:user_slug]

    #     if user_slug.blank?
    #       tokens = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    #       user_slug = tokens.sample(10).join

    #       cookies.signed[:user_slug] = user_slug
    #     end

    #     user_slug
    #   end
  end
end
