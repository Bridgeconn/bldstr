module ApplicationHelper
	def number_to_indian_currency(price)
		number_to_currency(price,  precision: 2, :locale => :en)
	end

	def formatted_date(date)
		"#{date.strftime("%b")} #{date.day.ordinalize} #{date.strftime("%Y")}"
	end

	def country_name(country_code)
		Country[country_code].name if country_code
	end

	def state_name(country_code, state_code)
		Country[country_code].states[state_code]["name"] if country_code && state_code
	end

	def subcat_prefix(depth)
		("&nbsp;--" * 2 * depth).html_safe
	end

	def category_options_array(categories=[], parent_id=nil, depth=0)
		Category.where(parent_id: parent_id).order(:id).each do |category|
			categories << [subcat_prefix(depth) + category.name, category.id]
			category_options_array(categories, category.id, depth+1)
		end

		categories
	end
end
