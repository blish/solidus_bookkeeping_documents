header = [
  pdf.make_cell(content: I18n.t(:sku, scope: :spree)),
  pdf.make_cell(content: I18n.t(:item_description, scope: :spree)),
  pdf.make_cell(content: I18n.t(:options, scope: :spree)),
  pdf.make_cell(content: I18n.t(:qty, scope: :spree)),
]
data = [header]

printable.items.each do |item|
  row = [
    item.sku,
    item.name,
    item.options_text,
    item.quantity,
  ]
  data += [row]
end

column_widths = [0.125, 0.55, 0.25, 0.075].map { |w| w * pdf.bounds.width }

pdf.table(data, header: true, position: :center, column_widths: column_widths) do
  row(0).style align: :center, font_style: :bold
  column(0..2).style align: :left
  column(3).style align: :center
end
