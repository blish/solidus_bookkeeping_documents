include Forwardable

module Spree
  class Printables::BaseView
    extend Forwardable
    extend Spree::DisplayMoney

    attr_reader :printable, :document

    money_methods :item_total, :total

    def initialize(printable, document)
      @printable = printable
      @document = document
    end

    def name
      raise NotImplementedError, "Please implement name"
    end

    def email
      raise NotImplementedError, "Please implement email"
    end

    def total
      raise NotImplementedError, "Please implement total"
    end

    def number
      raise NotImplementedError, "Please implement number"
    end
  end
end
