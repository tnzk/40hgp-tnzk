module Ramaze
  module Helper
    module AccountHelper

      def passwd(s)
        Digest::SHA512.hexdigest(s)
      end

      def current_account
        session[:account] ? Account.get(session[:account]) : nil
      end
      
      def get_rand_str( length = 8)
        source = ("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a + ["_","-","."]
        key = ''
        length.times { key += source[rand(source.size)].to_s }
        key
      end

    end
  end
end
