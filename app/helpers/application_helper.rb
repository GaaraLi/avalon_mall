module ApplicationHelper
	def set_title_tag
		site_name= "享车商城"
		title= @page_title ? "#{@page_title} | #{site_name}": "#{site_name}"
		content_tag("title", title, nil, false)
	end

	def drop_bread_crumb
		@bread_crumbs_html=""
		@bread_crumbs_html << "<a href= root_path >首页 </a>"
		@bread_crumbs.each_slice(2).each do |b|
			if b[0]
				@bread_crumbs_html << "&nbsp&nbsp>&nbsp&nbsp"
				@bread_crumbs_html << "<a href= #{b[1]}> #{b[0]} </a>"
			end

		end
		return @bread_crumbs_html.html_safe
	end
end
