module Fastlane
  module Actions
    class GoogleChatMessageAction < Action
      def self.run(params)
            require 'net/http'
            require 'uri'
            require 'json'

            uri = URI.parse(params[:webhook_url])

            header = {
              'Content-Type' => 'application/json; charset=UTF-8'
            }

            body = {cards: [
              {
                header: {
                  title: params[:title],
                  subtitle: params[:subtitle],
                  imageUrl: params[:image_url]
                },
                sections: [
                  {
                    widgets: [
                      {
                        keyValue: {
                          content: params[:message_body],
                          contentMultiline: true,
                          bottomLabel: 'Posted By Tweebot'
                        }
                      }
                    ]
                  }
                ]
              }
            ]}.to_json
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
         
            request = Net::HTTP::Post.new(uri.request_uri)
            request["Content-Type"] = "application/json"
            request.body = body

            response = http.request(request)

            if response.code.to_i == 200
              UI.success("✅  Message Successfully Sent To Google Chat: #{response.code}  🫠")
            else
              UI.error("💩 Failed To Send Message To Google Chat: #{response.code} - #{response.message} ❌")
            end
          rescue => error
            UI.error("💩 Failed To Send Message To Google Chat: #{error.message} ❌")
          end

          def self.description
            "Sends A Message With A Header, Image, And Body To A Google Chat Webhook"
          end

      def self.authors
        ["Josh Robbins (∩｀-´)⊃━☆ﾟ.*･｡ﾟ"]
      end

      def self.return_value
        "The HTTP Response Code From The Google Chat Webhook"
      end

      def self.details
        "This Action Allows You To Send Custom Messages To A Google Chat Space Using A Webhook URL."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :webhook_url,
                                       env_name: "GOOGLE_CHAT_WEBHOOK_URL",
                                       description: "Webhook URL For The Google Chat Where The Message Will Be Sent",
                                       verify_block: proc do |value|
                                         UI.user_error!("💩 No Webhook URL For GoogleChatMessageAction Given, Pass Using `webhook_url: 'url'` ❌") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :title,
                                       description: "The Title To Be Used In The Google Chat Message Header",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :subtitle,
                                       description: "The Subtitle To Be Used In The Google Chat Message Header",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :image_url,
                                       description: "The URL Of The Image To Be Displayed In The Google Chat Message",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :message_body,
                                       description: "The Body Text Of The Google Chat Message",
                                       optional: false)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
