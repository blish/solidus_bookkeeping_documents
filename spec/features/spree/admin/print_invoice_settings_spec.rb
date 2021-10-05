RSpec.feature 'Settings for Print Invoice' do
  stub_authorization!

  scenario 'can update settings', :js do
    visit spree.edit_admin_print_invoice_settings_path

    check 'Use Footer'
    check 'Use Page Numbers'

    fill_in 'Logo Path', with: '/somewhere/logo.png'
    fill_in 'Next Number', with: '200'
    select2 'A4', from: 'Page Size'
    select2 'portrait', from: 'Page Layout'
    select2 'Courier', from: 'Font Face'
    select2 '11', from: 'Font Size'
    fill_in 'Logo Scale', with: '99'
    fill_in 'Left Footer Content', with: 'left text..'
    fill_in 'Right Footer Content', with: 'right text..'
    fill_in 'Order Return Message', with: 'Return message..'
    fill_in 'Order Anomaly Message', with: 'Anomaly message..'

    click_button 'Update'

    setting = Spree::PrintInvoiceSetting.first

    expect(setting.preferred_use_footer).to be(true)
    expect(setting.preferred_use_page_numbers).to be(true)

    expect(setting.preferred_logo_path).to eq '/somewhere/logo.png'
    expect(setting.preferred_next_number).to eq 200
    expect(setting.preferred_page_size).to eq 'A4'
    expect(setting.preferred_page_layout).to eq 'portrait'
    expect(setting.preferred_font_face).to eq 'Courier'
    expect(setting.preferred_font_size).to eq 11
    expect(setting.preferred_logo_scale).to eq 99
    expect(setting.preferred_footer_left).to eq 'left text..'
    expect(setting.preferred_footer_right).to eq 'right text..'
    expect(setting.preferred_return_message).to eq 'Return message..'
    expect(setting.preferred_anomaly_message).to eq 'Anomaly message..'
  end
end
