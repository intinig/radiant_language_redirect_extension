class LanguageRedirectExtension < Radiant::Extension
  version "0.2.1"
  description "Port of the original Language Redirect Behavior"
  url "http://medlar.it"

  def activate
    LanguageRedirectPage
    Page.class_eval do
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
    end
  end
  
  def deactivate
  end
    
end