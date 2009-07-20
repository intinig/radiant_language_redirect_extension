module LanguageRedirectTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

  desc %{
    Shows the content if the code matches the actual language

    *Usage:*
    <pre><code><r:if_language code="language" >...</r:if_language></code></pre>
  }
  tag 'if_language' do |tag|
    tag.expand if tag.attr['code'] == current_language
  end

  desc %{
    Shows the content unless the code matches the actual language

    *Usage:*
    <pre><code><r:unless_language code="language" >...</r:unless_language></code></pre>
  }
  tag 'unless_language' do |tag|
    tag.expand unless tag.attr['code'] == current_language
  end

  desc %{
    Shows a language chooser list separated by the characters supplied with the 'separator' attribute. By default, 'separator' is set to |.
    If the 'upcase' attribute is set to false, the language description will be uppercase. By default, 'upcase' is set to true.
    If the 'singleletter' attribute is set to false, the language description will show only the first letter. By default, 'singleletter' is set to true.

    *Usage:*
    <pre><code><r:choose_language [separator="|"] [upcase="true|false] [singleletter="true|false"] /></code></pre>
  }
  tag 'languageswitch' do |tag|
    upcase = tag.attr.has_key?('upcase') && tag.attr['upcase']=='false' ? nil : true
    singleletter = tag.attr.has_key?('singleletter') && tag.attr['singleletter']=='false' ? nil : true
    separator = tag.attr['separator'] || "|"

    html = '<ul>'
    config = language_config(self)
    config.delete('*')
    position = 1
    config.each do |key, value|
      key = key.upcase if upcase
      key = key.split(//)[0] if singleletter
      if request.request_uri.starts_with? value
        html += "<li class='active_language'>#{key}</li>"
      else
        html += "<li><a href='#{value}'>#{key}</a></li>"
      end
      html += "<li>#{separator}</li>" if position != config.length
      position = position + 1
    end
    html += '</ul>'
  end

  tag 'breadcrumbs' do |tag|
    page = tag.locals.page
    breadcrumbs = [tag.render('breadcrumb')]
    nolinks = (tag.attr['nolinks'] == 'true')
    # Remove LanguageRedirect pages from the hierarchy (preferably the root)
    page.ancestors.reject {|p| p.is_a?(LanguageRedirectPage) }.each do |ancestor|
      tag.locals.page = ancestor
      if nolinks
        breadcrumbs.unshift tag.render('breadcrumb')
      else
        breadcrumbs.unshift %{<a href="#{tag.render('url')}">#{tag.render('breadcrumb')}</a>}
      end
    end
    separator = tag.attr['separator'] || ' &gt; '
    breadcrumbs.join(separator)
  end
  
  protected

    def current_language
      config = language_config(self)
      config.each do |key, value|
         return key if request.request_uri.starts_with? value
      end
    end

    def language_config(page)
      if page.class == LanguageRedirectPage
        YAML.load(page.render_part(:config))
      elsif page.parent
        language_config(page.parent)
      end
    end
end
