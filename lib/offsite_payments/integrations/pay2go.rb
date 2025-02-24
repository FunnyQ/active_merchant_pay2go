# encoding: utf-8
require 'digest'
require File.dirname(__FILE__) + '/pay2go/helper.rb'
require File.dirname(__FILE__) + '/pay2go/notification.rb'

module OffsitePayments #:nodoc:
  module Integrations #:nodoc:
    module Pay2go

      VERSION = '1.4'
      RESPOND_TYPE = 'String'
      CHECK_VALUE_FIELDS = %w(MerchantID RespondType TimeStamp Version MerchantOrderNo Amt ItemDesc)
      CHECK_CODE_FIELDS = %w(MerchantID RespondType TimeStamp Version MerchantOrderNo Amt ItemDesc)

      CONFIG = %w(
        MerchantID LangType TradeLimit ExpireDate NotifyURL EmailModify LoginType
      )

      mattr_accessor :service_url
      mattr_accessor :hash_key
      mattr_accessor :hash_iv
      mattr_accessor :debug

      CONFIG.each do |field|
        mattr_accessor field.underscore.to_sym
      end

      def self.service_url
        mode = ActiveMerchant::Billing::Base.mode
        case mode
          when :production
            'https://core.newebpay.com/MPG/mpg_gateway'
          when :development
            'https://ccore.newebpay.com/MPG/mpg_gateway'
          when :test
            'https://ccore.newebpay.com/MPG/mpg_gateway'
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
        end
      end

      def self.notification(post)
        Notification.new(post)
      end

      def self.setup
        yield(self)
      end

    end
  end
end
