module Squib
  class TmpMaker
    @@NUM = -1

    def self.next
      @@NUM += 1
      "_tmp/tmp_#{@@NUM}.svg"
    end
  end
end