module ImageTransTestGenerator
  class ImageArray < Array
    include Util

    def self.parse_ltsv(file)
      unless File.exist?(file)
        raise "file not found: #{file}"
      end
      list = LTSV.load(file)

      images = self.new
      list.each do |i|
        images << Image.new(i)
      end

      images
    end

    def self.dump_ltsv(obj)
      res = ""

      unless obj.is_a?(self)
        raise ArgumentError, "#{self} required"
      end

      obj.each do |i|
        res += "#{LTSV.dump(i.to_hash)}\n"
      end

      res
    end

    def http_content_length_total
      self.inject(0) do |sum, image|
        sum + image.http_content_length.to_i
      end
    end

    def update_with_http_trans!
      self.each do |i|
        if block_given?
          i.update_with_http_trans {|j| yield(j)}
        else
          i.update_with_http_trans
        end
      end
      self
    end
  end
end
