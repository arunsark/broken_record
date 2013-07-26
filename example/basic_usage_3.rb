require_relative "helper"

class Article
  include BrokenRecord::Mapping
  map_to_table :articles
  has_one :author, :key => :article_id, :class => "Author"
end

class Author
  include BrokenRecord::Mapping
  map_to_table :authors
  belongs_to :article, :key   => :article_id,
                       :class => "Article"
end


article1 = Article.create(:title => "A great article",
                   :body  => "Short but sweet!")

author = Author.create(:name => "George", :article_id => article1.id)

Article.all.each do |article|
  puts %{
    TITLE: #{article.title}
    AUTHOR: #{article.author.name}
  }
end
