require "Hashie"

module ImageTransTestGenerator
  class Image < ::Hashie::Mash
    include Util

    REG_VALID_HTTP_CONTENT_TYPE = /^image\//i

    def self.parse(html_node:, referer: nil, update_with_http_trans: false)
      begin
        html_node_name = html_node.name.to_s.downcase
        html_src_attr = parse_src_attr(html_node: html_node)
        html_src_attr_expanded = expand_uri(uri: html_src_attr, referer: referer)
      rescue => e
        valid = false
        invalid_reason = e.to_s
      else
        valid = true
      end

      image = self.new(
        referer: referer,

        html_node_name: html_node_name,
        html_src_attr: html_src_attr,
        html_src_attr_expanded: html_src_attr_expanded,

        valid: valid,
        invalid_reason: invalid_reason,
      )

      image.update_with_http_trans if update_with_http_trans

      image
    end

    def self.parse_src_attr(html_node:)
      src = html_node.attribute('src')
      src.nil? ? nil : src.value
    end

    REG_VALID_STRING = /^true$/i

    def valid?
      return self.valid unless self.valid.is_a?(String)
      self.valid =~ REG_VALID_STRING
    end

    def update_with_http_trans
      return self unless self.valid

      if block_given?
        yield(self)
      end

      begin
        # http_trans_res = load_uri(uri: self.html_src_attr_expanded, referer: self.referer)
        http_trans_res = head_uri(uri: self.html_src_attr_expanded, referer: self.referer)
      rescue => e
        puts_debug(e)
        set_invalid(e.to_s)
        return self
      end

      self.http_status = http_trans_res.status.to_i
      unless http_trans_res.success?
        set_invalid("http trans not success")
        return self
      end

      puts_debug(http_trans_res.headers.to_hash)
      puts_debug(http_trans_res.body)

      self.http_encoding = http_trans_res.body.encoding.to_s

      self.http_content_type = http_trans_res.headers["content-type"].to_s
      unless self.http_content_type =~ REG_VALID_HTTP_CONTENT_TYPE
        set_invalid("invalid content_type(#{self.http_content_type})")
      end

      self.http_content_length = http_trans_res.headers["content-length"].to_s
      unless self.http_content_length.to_i > 0
        set_invalid("invalid content_length(#{self.http_content_length.to_i})")
      end

      self
    end

    def src_uri
      begin
        uri = URI.parse(self.html_src_attr_expanded)
      rescue
        return nil
      end
      uri
    end

    def src_uri_scheme
      uri = src_uri
      return "" if uri.nil?

      "#{uri.scheme}"
    end

    def src_uri_domain(depth: 0)
      uri = src_uri
      return "" if uri.nil?

      hostname = uri.hostname
      if depth > 0
        hostname = snip_domain(domain: hostname, depth: depth)
      end

      "#{hostname}:#{uri.port}"
    end

    def src_has_query?
      uri = src_uri
      return false if uri.nil?

      uri.query.to_s.length == 0 ? false : true
    end

    def set_invalid(reason)
      self.valid = false
      self.invalid_reason = "" if self.invalid_reason.nil?
      self.invalid_reason += " / " if self.invalid_reason.length > 0
      self.invalid_reason += reason
      self
    end
  end
end
