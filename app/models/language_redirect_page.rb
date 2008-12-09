class LanguageRedirectPage < Page
  
  def headers
    {
      'Status' => "302 Found",
      'Location' => location,
      'Vary' => "Accept-Language"
    }
  end
  
  def render
    "<html><body>302 Found</body></html>"
  end
  
  def cache?
    false
  end
  
  protected
    def config
      map = Hash[*render_part(:config).split(/[\n:]/)]
      map.each_pair {|k, v| v.chomp!; v.strip!}
      map
    end
  
    def languages
      langs = (@request.env["HTTP_ACCEPT_LANGUAGE"] || "").scan(/[^,\s]+/)
      q = lambda { |str| /;q=/ =~ str ? Float($') : 1 }
      langs = langs.collect do |ele|
        [q.call(ele), ele.split(/;/)[0].downcase]
      end.sort { |l, r| r[0] <=> l[0] }.collect { |ele| ele[1] }
      langs
    end
  
    def location
      path = nil
      languages.find do |lang|
        path = location_map[lang[0..1]]
      end
      path ||= location_map["*"] || '/en/'
      if path =~ %r{[:][/][/]}
        path
      else
        @request.protocol + @request.host_with_port + path
      end
    end
    
    def location_map
      @location_map ||= config
    end
  
end