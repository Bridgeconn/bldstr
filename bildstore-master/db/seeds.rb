# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# [:admin, :user].each do |role|
#   Role.find_or_create_by_name({ name: role }, without_protection: true)
# end
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

connection = ActiveRecord::Base.connection();
# connection.execute("SELECT setval('order_statuses_id_seq', (SELECT MAX(id) FROM order_statuses))")
# connection.execute("SELECT setval('order_statuses_seq', (SELECT MAX(id) FROM order_statuses))")
# connection.execute("SELECT setval('category_id_seq', (SELECT MAX(id) FROM categories))")
# connection.execute("SELECT setval('category_seq', (SELECT MAX(id) FROM category))")
# OrderStatus.delete_all
# OrderStatus.create!(name: "In Progress")
# OrderStatus.create!(name: "Placed")
# OrderStatus.create!(name: "Shipped")
# OrderStatus.create!(name: "Cancelled")
Category.delete_all
Category.create!(parent_id: nil, name: "Resources", description: "this is test")
User.delete_all
admin_user = User.new(email: "jobbyp@gmail.com", first_name: "jobby", last_name: "Prasannan", password: "Bild@1234!@#$", phone_number: "123456789")
admin_user.skip_confirmation!
admin_user.save
admin_user.add_role :admin
