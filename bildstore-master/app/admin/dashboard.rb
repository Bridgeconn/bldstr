ActiveAdmin.register_page "Dashboard" do

	menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

	content title: proc{ I18n.t("active_admin.dashboard") } do
		# div class: "blank_slate_container", id: "dashboard_default_message" do
		#   span class: "blank_slate" do
		#     span I18n.t("active_admin.dashboard_welcome.welcome")
		#     small I18n.t("active_admin.dashboard_welcome.call_to_action")
		#   end
		# end

		columns do

			column do
				panel "Recent Products" do
					table_for Product.order('id desc').limit(10) do
						column("Name") {|product| link_to(product.name, admin_product_path(product)) }
						column("Category"){|product| product.category.name if product.category.present? }
						column("Price") {|product| number_to_currency product.price }
					end
				end
			end

			column do
				panel "Recent Users" do
					table_for User.order('id desc').limit(10).each do |user|
						column(:email) {|user| link_to(user.email, admin_user_path(user)) }
					end
				end
			end

			column do
				panel "Recent Completed Orders" do
					table_for Order.where(status: 3).order('id desc').limit(10) do
						column("Order"){|order|link_to("# #{order.id}", admin_order_path(order)) }
						column("Email"){|order| order.billing_email }
						column("Total Amount") {|order| number_to_currency order.total_amount }
					end
				end
			end
		end

		# Here is an example of a simple dashboard with columns and panels.
		#
		# columns do
		#   column do
		#     panel "Recent Posts" do
		#       ul do
		#         Post.recent(5).map do |post|
		#           li link_to(post.title, admin_post_path(post))
		#         end
		#       end
		#     end
		#   end

		#   column do
		#     panel "Info" do
		#       para "Welcome to ActiveAdmin."
		#     end
		#   end
		# end
	end # content
end
