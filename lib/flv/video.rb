require 'uri'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'uri/query_params'

module FLV
  class Video

    FORMATS = {
      :mp4      => ['mp4_url'],
      :flv      => ['flv_url', 'flv', 'video_url', 'file'],
      :flv_h264 => ['flv_h264']
    }

    attr_reader :url

    def initialize(url)
      @url = URI(url)
      @doc = Nokogiri::HTML(open(@url))
    end

    TITLE_XPATHS = [
      "//meta[@name='description']/@content",
      "//title"
    ]

    def title
      @title ||= @doc.at(TITLE_XPATHS.join('|')).inner_text
    end

    def flashvars
      @flashvars ||= (
        extract_flashvars_from_html ||
        extract_flashvars_from_embedded_html ||
        extract_flashvars_from_javascript ||
        {}
      )
    end

    def formats
      @formats ||= FORMATS.keys.select do |format|
        FORMATS[format].any? { |var| flashvars.has_key?(var) }
      end
    end

    def video_urls
      @video_urls ||= begin
                        urls = {}

                        FORMATS.each do |format,vars|
                          vars.each do |var|
                            if flashvars.has_key?(var)
                              urls[format] = @url.merge(flashvars[var])
                              next
                            end
                          end
                        end

                        urls
                      end
    end

    protected

    FLASHVARS_XPATHS = [
      '//@flashvars',
      '//param[@name="flashvars"]/@value',
      '//param[@name="FlashVars"]/@value'
    ]

    def extract_flashvars_from_html(doc=@doc)
      if (flashvars = doc.at(FLASHVARS_XPATHS.join('|')))
        URI::QueryParams.parse(flashvars.value)
      end
    end

    EMBEDDED_FLASHVARS_XPATHS = [
      '//*[contains(.,"flashvars")]',
      '//*[contains(.,"FlashVars")]'
    ]

    def extract_flashvars_from_embedded_html
      if (attr = @doc.at(EMBEDDED_FLASHVARS_XPATHS.join('|')))
        html = Nokogiri::HTML(attr.inner_text)

        extract_flashvars_from_html(html)
      end
    end

    FLASHVARS_JAVASCRIPT_XPATHS = [
      '//script[contains(.,"flashvars")]',
      '//script[contains(.,"jwplayer")]',
    ]

    def extract_flashvars_from_javascript
      if (script = @doc.at(FLASHVARS_JAVASCRIPT_XPATHS.join('|')))
        code = script.inner_text

        return extract_flashvars_from_javascript_function(code) ||
               extract_flashvars_from_javascript_hash(code)
      end
    end

    FLASHVARS_FUNCTION_REGEXP = /['"]flashvars['"]\s*,\s*['"]([^'"]+)['"]/

    def extract_flashvars_from_javascript_function(code)
      if (match = code.match(FLASHVARS_FUNCTION_REGEXP))
        URI::QueryParams.parse(match[1])
      end
    end

    FLASHVARS_HASH_REGEXP = /(?:flashvars\s*=\s*|jwplayer\(['"][a-z]+['"]\).setup\()(\{[^\}]+\})/m

    def extract_flashvars_from_javascript_hash(code)
      regexp = lambda { |vars|
        
      }

      flashvars = {}

      vars   = FORMATS.values.flatten
      regexp = /['"](#{Regexp.union(vars)})['"]:\s*['"]([^'"]+)['"]/

      if (match = code.match(regexp))
        flashvars[match[1]] = URI.decode(match[2])
      end

      return flashvars
    end

  end
end
