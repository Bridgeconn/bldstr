class CartItem < ApplicationRecord

	belongs_to :product
  belongs_to :order
  delegate :name, :price, :image, to: :product, prefix: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :product_present
  validate :order_present

  
  def unit_price    
    product.price
  end

  def total_price
    unit_price * quantity
  end

   def subtotal
    cart_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end


  private
  def product_present
    if product.nil?
      errors.add(:product, "is not valid or is not active.")
    end
  end

  def order_present
    if order.nil?
      errors.add(:order, "is not a valid order.")
    end
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = quantity * self[:unit_price]
  end
end
