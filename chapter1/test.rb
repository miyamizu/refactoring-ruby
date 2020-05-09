require 'minitest/autorun'
require 'minitest/unit'
require './video_rental.rb'

class TestFoo < MiniTest::Unit::TestCase
  def setup
    @jaws = Movie.new("Jaws", Movie::NEW_RELEASE)
    @et = Movie.new("ET", Movie::REGULAR)
    @anpanman = Movie.new("Anpanman", Movie::CHILDRENS)

    @first_rental = Rental.new(@jaws, 3)
    @second_rental = Rental.new(@et, 5)
    @third_rental = Rental.new(@anpanman, 2)

    @snowmi = Customer.new("Snowmi")
    @snowmi.add_rental(@first_rental)
    @snowmi.add_rental(@second_rental)
    @snowmi.add_rental(@third_rental)


    @str = "Rental Record for Snowmi
#{"\t"}Jaws#{"\t"}9
#{"\t"}ET#{"\t"}6.5
#{"\t"}Anpanman#{"\t"}1.5
Amount owed is 17.0
You earned 4 frequent renter points"
  end

  def test_statement
    assert_equal(@str, @snowmi.statement)
  end
end
