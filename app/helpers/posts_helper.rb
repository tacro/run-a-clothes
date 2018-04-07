module PostsHelper
  def render_with_hashtags(detail)
    detail.gsub(/#[\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/items/hashtag/#{word.delete('#')}"}.html_safe
  end
end
