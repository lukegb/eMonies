module ApplicationHelper
  def to_money(i)
    number_to_currency(i, unit: "£", negative_format: "(%u%n)")
  end

  def markdown(content)
    @markdown_renderer ||= Redcarpet::Render::HTML.new(hard_wrap: true)
    @markdown ||= Redcarpet::Markdown.new(@markdown_renderer, autolink: true, space_after_headers: true, fenced_code_blocks: true, tables: true)
    @markdown.render(content).html_safe
  end

  def purchase_row_class(purchase, current_person)
    "purchaseRow #{purchase.requires_action_by_me?(current_person) ? 'requiresActionByMe' : ''} #{purchase.pending_other_acceptances?(current_person) ? 'pendingOtherAcceptances' : ''}"
  end 
end
