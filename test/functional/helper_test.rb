require File.dirname(__FILE__) + '/../test_helper'

class HelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ApplicationHelper
  # include whatever helpers you want to test here, sometimes you'll need
  # to include some of the Rails helpers, as I've done above.

  def test_truth
    assert true
  end
end