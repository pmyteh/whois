#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/afilias'


module Whois
  class Record
    class Parser

      #
      # = whois.afilias.info parser
      #
      # Parser for the whois.afilias.info server.
      #
      class WhoisAfiliasInfo < Base
        include Features::Ast


        property_supported :disclaimer do
          node("property-disclaimer")
        end


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          node("Status") || []
        end

        property_supported :available? do
          !!node("status-available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created On") do |value|
            Time.parse(value)
          end
        end

        property_supported :updated_on do
          node("Last Updated On") do |value|
            Time.parse(value)
          end
        end

        property_supported :expires_on do
          node("Expiration Date") do |value|
            Time.parse(value)
          end
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            value =~ /(.+?) \((.+?)\)/ || Whois.bug!("Unknown registrar format `#{value}'")
            Record::Registrar.new(
              :id =>            $2,
              :name =>          $1,
              :organization =>  $1
            )
          end
        end

        property_supported :registrant_contacts do
          contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          contact("Admin", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          contact("Tech", Whois::Record::Contact::TYPE_TECHNICAL)
        end



        property_supported :nameservers do
          Array.wrap(node("Name Server")).reject(&:empty?).map do |name|
            Nameserver.new(name.downcase)
          end
        end


        # Initializes a new {Scanner} instance
        # passing the {Whois::Record::Parser::Base#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Afilias.new(content_for_scanner).parse
        end


        private

          def contact(element, type)
            node("#{element} ID") do
              address = (1..3).map { |i| node("#{element} Street#{i}") }.delete_if(&:empty?).join(" ")

              Record::Contact.new(
                :type         => type,
                :id           => node("#{element} ID"),
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :address      => address,
                :city         => node("#{element} City"),
                :zip          => node("#{element} Postal Code"),
                :state        => node("#{element} State/Province"),
                :country_code => node("#{element} Country"),
                :phone        => node("#{element} Phone"),
                :fax          => node("#{element} FAX"),
                :email        => node("#{element} Email")
              )
            end
          end

      end

    end
  end
end
