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
      # = whois.tld.ee parser
      #
      # Parser for the whois.tld.ee server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisTldEe < Base
        include Ast

        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+)\n/
            case $1.downcase
              when "paid and in zone" then :registered
              # NEWSTATUS
              when "expired" then :expired
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^%ERROR:101: no entries found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /registered:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /expire:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          if content_for_scanner =~ /registrar:\s+(.*)\n/
            Whois::Answer::Registrar.new(
                :id => $1,
                :name => $1
            )
          end
        end

        property_supported :admin_contact do
          if content_for_scanner =~ /admin-c:\s+(.*)\n/
            contact($1, Whois::Answer::Contact::TYPE_ADMIN)
          end
        end

        property_supported :registrant_contact do
          if content_for_scanner =~ /registrant:\s+(.*)\n/
            contact($1, Whois::Answer::Contact::TYPE_REGISTRANT)
          end
        end

        property_not_supported :technical_contact


        property_supported :nameservers do # TODO
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map { |value| value.strip.split(" ").first }
        end


        protected

          def parse
            Scanner.new(content_for_scanner).parse
          end

          def contact(element, type)
            node(element) do |raw|
              Answer::Contact.new(
                :id             => element,
                :type           => type,
                :name           => raw['name'],
                :organization   => raw['org'],
                :created_on     => Time.parse(raw['created'])
              )
            end
          end

          class Scanner

            def initialize(content)
              @input = StringScanner.new(content)
            end

            def parse
              @ast = Hash.new
              while !@input.eos?
                if @input.scan(/contact:\s+(.*)\n/)
                  section = @input[1].strip
                  content = Hash.new

                  while @input.scan(/(.*?):\s+(.*?)\n/)
                    content[@input[1]] = @input[2]
                  end

                  @ast[section] = content
                else
                  @input.scan(/(.*)\n/)
                end
              end
              @ast
            end
          end

      end
    end
  end
end
