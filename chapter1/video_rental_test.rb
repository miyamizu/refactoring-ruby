require "active_record"
require "minitest/autorun"

class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILERENS = 2

  attr_reader :title
  attr_reader :price_code

  def initialize(title, price_code)
    @title, @price_code, = title, price_code
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end
end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(arg)
    @rentals << arg
  end

  def statement
    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for #{@name}\n"
    @rentals.each do |element|
      this_amount = amount_for(element)

      # レンタルポイントを加算
      frequent_renter_points += 1

      # 新作2日間レンタルでボーナス加算
      if element.movie.price_code == Movie.NEW_RELEASE && element.days_rented > 1
        frequent_renter_points += 1
      end

      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + this_amount.to_s + "\n"
      total_amount += this_amount
    end

    # フッター行を追加
    result += "Amount owed is #{total_amount}\n"
    result += "You earnd #{frequent_renter_points} frequent renter points"
    result
  end

  def amount_for(element)
    this_amount = 0
    case element.movie.price_code
    when Movie::REGULAR
      this_amount += 2
      this_amount += (element.days_rented - 2) * 1.5 if element.days_rented > 2
    when Movie::NEW_RELEASE
      this_amount += element.days_rented * 3
    when Movie::CHILERENS
      this_amount += 1.5
      this_amount += (element.days_rented - 3) * 1.5 if element.days_rented > 3
    end
  end
end

# gem install byebug
# module TestSetup
#   def setup
#     setup_database
#     import_fixtures
#   end
#
#   private
#
#   def setup_database
#     ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
#     ActiveRecord::Schema.define do
#       create_table :movies do |t|
#         t.string :title
#         t.integer :price_code
#         t.timestamps
#       end
#
#       create_table :rentals do |t|
#         t.belongs_to :movie
#         t.integer :days_rented
#         t.timestamps
#       end
#
#       create_table :customers do |t|
#         t.string :name
#         t.timestamps
#       end
#     end
#   end
#
#   def import_fixtures
#     @movie1 = Movie.create!("Movie1", 1)
#     @movie2 = Movie.create!("Movie2", 2)
#     @movie3 = Movie.create!("Movie3", 3)
#
#     @customer = Customer.create!('miyamizu',[])
#
#     Rental.create!(@movie1, 3)
#   end
# end
#
# # ビデオレンタルの料金を計算して印刷する
# class CalculateRentalFee < Minitest::Test
#   include TestSetup
#
#   def test_customers_can_rental?
#     args = [@customer.name, [@movie1, @movie2]]
#     p @customer
#     assert_includes true, @customer.add_rental(args)
#   end
#
#   def statement
#     expected_courses = [@reading, @writing, @physics, @algebra]
#     assert_equal expected_courses, @omar.courses.to_a
#   end
# end
