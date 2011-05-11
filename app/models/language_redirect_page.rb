class LanguageRedirectPage < Page

  def headers
    {
      'Status' => "301 Redirect",
      'Location' => location,
      'Vary' => "Accept-Language"
    }
  end

  def render
    "<html><body>301 Redirect</body></html>"
  end

  def cache?
    false
  end

  def response_code
    301
  end
  
  def find_by_url(url, live=true, clean=true)
    found = super
    if (found.nil? || found.is_a?(FileNotFoundPage)) && 
      location_map.values.all? {|target| clean_url(url) !~ Regexp.new(target) }
      self
    else
      found
    end
  end

  protected
    def config
      YAML.load(render_part('config'))
    end

    def languages
      langs = (@request.env["HTTP_ACCEPT_LANGUAGE"] || "").split(/[,\s]+/)
      langs_with_weights = langs.map do |ele|
        both = ele.split(/;q=/)
        lang = both[0].split('-').first
        weight = both[1] ? Float(both[1]) : 1
        [-weight, lang]
      end.sort_by(&:first).map(&:last)
    end

    def location
      path = location_map[languages.find { |lang| location_map[lang] }]
      path ||= location_map["*"] || '/en/'
      path += request.request_uri
      path.gsub!(%r{([^:])//}, '\1/')
      if path =~ %r{[:][/][/]}
        path
      else
        path.sub!(%r{^([^/])}, '/\1')
        @request.protocol + @request.host_with_port + path
      end
    end

    def location_map
      @location_map ||= config
    end

end
