module ApplicationHelper
  def to_money(i)
    number_to_currency(i, unit: "£", negative_format: "(%u%n)")
  end

  def markdown(content)
    @markdown_renderer ||= Redcarpet::Render::HTML.new(hard_wrap: true)
    @markdown ||= Redcarpet::Markdown.new(@markdown_renderer, autolink: true, space_after_headers: true, fenced_code_blocks: true, tables: true)
    @markdown.render(content).html_safe
  end
end
