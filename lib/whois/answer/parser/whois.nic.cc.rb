#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'
require 'whois/answer/parser/scanners/verisign'


module Whois
  class Answer
    class Parser

      #
      # = whois.nic.cc parser
      #
      # Parser for the whois.nic.cc server.
      #
      class WhoisNicCc < Base
        include Ast

        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain Name") { |raw| raw.downcase }
        end

        property_not_supported :domain_id


        property_supported :referral_whois do
          node("Whois Server")
        end

        property_supported :referral_url do
          node("Referral URL")
        end


        property_supported :status do
          node("Status")
        end

        property_supported :available? do
          node("Registrar").nil?
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Creation Date") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          node("Updated Date") { |raw| Time.parse(raw) }
        end

        property_supported :expires_on do
          node("Expiration Date") { |raw| Time.parse(raw) }
        end


        property_supported :registrar do
          # Return nil because when the response contains more than one registrar section
          # the response can be messy. See, for instance, the Verisign response for google.com.
          nil
        end


        property_supported :nameservers do # TODO
          node("Name Server") do |values|
            [*values].map(&:downcase).reject { |value| value == "no nameserver" }
          end || []
        end


        protected

          def parse
            Scanners::Verisign.new(content_for_scanner).parse
          end

      end

    end
  end
end
