string = "#{I18n.t(:page, scope: "spree.print_invoice")} <page> #{I18n.t(:of, scope: "spree.print_invoice")} <total>"

options = {
  at: [pdf.bounds.right - 155, 0],
  width: 150,
  align: :right,
  start_count_at: 1,
  color: "000000",
}

pdf.number_pages string, options
