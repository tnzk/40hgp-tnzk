module Ramaze
  module Helper
    module FormatHelper

      def datetime_format(datetime)
        "#{datetime.year}年 #{datetime.month}月 #{datetime.day}日"
      end

    end
  end
end
