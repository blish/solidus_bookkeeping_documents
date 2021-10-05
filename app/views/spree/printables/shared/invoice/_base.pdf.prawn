font_style = {
  face: Spree::PrintInvoiceSetting.font_face,
  size: Spree::PrintInvoiceSetting.font_size
}

prawn_document(force_download: true) do |pdf|
  pdf.define_grid(columns: 5, rows: 8, gutter: 10)
  pdf.font font_style[:face], size: font_style[:size]

  pdf.repeat(:all) do
    render 'spree/printables/shared/header', pdf: pdf, invoice: doc
  end

  # CONTENT
  pdf.grid([1,0], [6,4]).bounding_box do

    # address block on first page only
    if pdf.page_number == 1
      render 'spree/printables/shared/address_block', pdf: pdf, printable: printable
    end

    pdf.move_down 10

    render 'spree/printables/shared/invoice/items', pdf: pdf, invoice: doc

    pdf.move_down 10

    render 'spree/printables/shared/totals', pdf: pdf, invoice: doc

    pdf.move_down 30

    pdf.text Spree::PrintInvoiceSetting.return_message, align: :right, size: font_style[:size]
  end

  # Footer
  if Spree::PrintInvoiceSetting.use_footer
    render 'spree/printables/shared/footer', pdf: pdf
  end

  # Page Number
  if Spree::PrintInvoiceSetting.use_page_numbers
    render 'spree/printables/shared/page_number', pdf: pdf
  end
end
