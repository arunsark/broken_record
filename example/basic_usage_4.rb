require_relative "helper"

class Article
  include BrokenRecord::Mapping
  map_to_table :articles
  has_many :readers, :through => :readerships, :source => "Reader", :class => "Readership", :target => "Article"
end

class Readership
  include BrokenRecord::Mapping
  map_to_table :readerships

  belongs_to :reader, :key => :reader_id, :class => "Reader"
  belongs_to :article, :key => :article_id, :class => "Article"
end

class Reader
  include BrokenRecord::Mapping
  map_to_table :readers
  has_many :articles, :through => :readerships, :source => "Article", :class => "Readership", :target => "Reader"
end

article1 = Article.create(:title => "A great article",
                   :body  => "Short but sweet!")

reader1 = Reader.create(name: "George")
reader2 = Reader.create(name: "Nell")

Readership.create(reader_id: reader1.id, article_id: article1.id)
Readership.create(reader_id: reader2.id, article_id: article1.id)

Article.all.each do |article|
  puts %{
    TITLE: #{article.title}
    READERS: #{article.readers.map { |r| r.name }.join(", ")}
  }
end
