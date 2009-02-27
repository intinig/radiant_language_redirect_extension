class LanguageRedirectDataset < Dataset::Base
  uses :pages
  
  def load
    Page.update_all({:class_name => "LanguageRedirectPage"}, "id = #{page_id(:home)}")
  end
end