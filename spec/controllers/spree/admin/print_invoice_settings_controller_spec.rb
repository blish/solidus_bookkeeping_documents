RSpec.describe Spree::Admin::PrintInvoiceSettingsController, type: :controller do
  stub_authorization!

  before do
    user = build(:admin_user)
    allow(controller).to receive(:try_spree_current_user).and_return(user)
  end

  context "#update" do
    it "redirects to print invoice settings page" do
      put :update, params: {print_invoice_setting: {preferred_logo_path: 4}}
      expect(response).to redirect_to spree.edit_admin_print_invoice_settings_path
    end

    it "can set preferred_next_number" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_next_number: 1}}
      }.to change { Spree::PrintInvoiceSetting.next_number }.to(1)
    end

    it "can set preferred_logo_path" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_logo_path: "my_path/logo.png"}}
      }.to change { Spree::PrintInvoiceSetting.logo_path }.to("my_path/logo.png")
    end

    it "can set preferred_page_size" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_page_size: "Letter"}}
      }.to change { Spree::PrintInvoiceSetting.page_size }.to("Letter")
    end

    it "can set preferred_page_layout" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_page_layout: "landscape"}}
      }.to change { Spree::PrintInvoiceSetting.page_layout }.to("landscape")
    end

    it "can set preferred_footer_left" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_footer_left: "abc"}}
      }.to change { Spree::PrintInvoiceSetting.footer_left }.to("abc")
    end

    it "can set preferred_footer_right" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_footer_right: "abc"}}
      }.to change { Spree::PrintInvoiceSetting.footer_right }.to("abc")
    end

    it "can set preferred_return_message" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_return_message: "abc"}}
      }.to change { Spree::PrintInvoiceSetting.return_message }.to("abc")
    end

    it "can set preferred_footer_right" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_footer_right: "abc"}}
      }.to change { Spree::PrintInvoiceSetting.footer_right }.to("abc")
    end

    it "can set preferred_anomaly_message" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_anomaly_message: "abc"}}
      }.to change { Spree::PrintInvoiceSetting.anomaly_message }.to("abc")
    end

    it "can set preferred_use_footer" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_use_footer: true}}
      }.to change { Spree::PrintInvoiceSetting.use_footer }.to(true)
    end

    it "can set preferred_use_page_numbers" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_use_page_numbers: true}}
      }.to change { Spree::PrintInvoiceSetting.use_page_numbers }.to(true)
    end

    it "can set preferred_logo_scale" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_logo_scale: 80}}
      }.to change { Spree::PrintInvoiceSetting.logo_scale }.to(80)
    end

    it "can set preferred_font_face" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_font_face: "Arial"}}
      }.to change { Spree::PrintInvoiceSetting.font_face }.to("Arial")
    end

    it "can set preferred_font_size" do
      expect {
        put :update, params: {print_invoice_setting: {preferred_font_size: 12}}
      }.to change { Spree::PrintInvoiceSetting.font_size }.to(12)
    end
  end

  context "#edit" do
    it "renders the edit template" do
      get :edit, params: {}
      expect(response).to render_template(:edit)
    end
  end
end
