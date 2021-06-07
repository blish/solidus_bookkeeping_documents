if File.exist?(Spree::PrintInvoice::Config.invoice_logo_path)
  pdf.image Spree::PrintInvoice::Config.invoice_logo_path, vposition: :top, height: 40, scale: Spree::PrintInvoice::Config[:logo_scale]
end

pdf.grid([0,3], [1,4]).bounding_box do
  pdf.text Spree.t(invoice.document_type, scope: :print_invoice), align: :right, style: :bold, size: 18
  pdf.move_down 4

  pdf.text Spree.t(:invoice_number, scope: :print_invoice, number: invoice.document_number), align: :right
  pdf.move_down 2
  pdf.text Spree.t(:invoice_date, scope: :print_invoice, date: I18n.l(invoice.date)), align: :right
end
