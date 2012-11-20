require 'tire/test_helper'
require File.expand_path('../active_record_article', __FILE__)

class ActiveRecordArticleTest < Test::Unit::TestCase

  should 'add prefix to index name' do
    assert_equal 'tire_test_active_record_articles', ActiveRecordArticle.tire.index.name
  end

  should 'turn off updating elasticsearch index by defaut' do
    ActiveRecordArticle.create :title => "Test article"
    assert ActiveRecordArticle.tire.search('test').results.blank?
  end

  should 'allow using elasticsearch inside block' do
    Tire.test_mode! do
      ActiveRecordArticle.create :title => "Test article"
      assert ActiveRecordArticle.tire.search('test').results.present?
    end

    assert ActiveRecordArticle.tire.search('test').results.blank?
  end

end
