#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.sk-nic.sk parser
      #
      # Parser for the whois.sk-nic.sk server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisSkNicSk < Base

        # @see https://www.sk-nic.sk/documents/stavy_domen.html
        property_supported :status do
          if content_for_scanner =~ /^Domain-status\s+(.+)\n/
            case $1.downcase
              when "dom_ok"   then :registered
              when "dom_held" then :registered
              when "dom_dakt" then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^Not found/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /^Last-update\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /^Valid-date\s+(.+)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/dns_name\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(name)
          end
        end

      end

    end
  end
end
