module ApplicationHelper

	def error_message field, object
	  if message = object.errors.messages[field].first
	  	"#{field.capitalize} #{message}"
	  end
	end

	def sort_by_field field
      if field == params[:field]
        direction = params[:direction] == 'asc' ? 'desc' : 'asc'
	    arrow = {'asc' => '&#8593;', 'desc' => '&#8595;'}[direction]
	    link_to "#{field} #{arrow}".html_safe, articles_path(field: field, direction: direction)
	  else
	  	link_to "#{field} #{'&#8645;'}".html_safe, articles_path(field: field, direction: 'asc')
	  end
	end

	#def roles
	#  select("roles", User::ROLES.collect!.with_index { |role, i| [role, i] }, { include_blank: true })
	#end
end
