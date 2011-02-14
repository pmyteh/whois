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


module Whois
  class Answer
    class Parser

      #
      # = whois.registry.in parser
      #
      # Parser for the whois.registry.in server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisRegistryIn < Base

        property_supported :status do
          if content_for_scanner =~ /Status:(.+?)\n/
            content_for_scanner.scan(/Status:(.+?)\n/).flatten.map(&:downcase)
          end
        end

        property_supported :available? do
          (content_for_scanner.strip == "NOT FOUND")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created On:(.*?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Last Updated On:(.*?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration Date:(.*?)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do # TODO
          content_for_scanner.scan(/Name Server:([^\s]*)\n/).flatten.map(&:downcase)
        end

      end

    end
  end
end
