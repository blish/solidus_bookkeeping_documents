pdf.image Spree::PrintInvoiceSetting.invoice_logo_url, vposition: :top, height: 40, scale: Spree::PrintInvoiceSetting.logo_scale

pdf.grid([0, 3], [1, 4]).bounding_box do
  pdf.text I18n.t(invoice.document_type, scope: "spree.print_invoice"), align: :right, style: :bold, size: 18
  pdf.move_down 4

  pdf.text t(:invoice_number, scope: [:spree, :print_invoice], number: invoice.document_number), align: :right
  pdf.move_down 2
  pdf.text I18n.t(:invoice_date, scope: [:spree, :print_invoice], date: I18n.l(invoice.date)), align: :right
end
