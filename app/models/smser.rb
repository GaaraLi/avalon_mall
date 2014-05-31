require 'net/http'
require 'iconv'
class Smser < ActiveRecord::Base

  @cdkey = '53643048'
  @password = 'zhaohuibing1'

  class << self

    def balance
      uri = 'http://www.68885888.com/ws/Send.aspx?CorpID='\
            + @cdkey + '&Pwd=' + @password
      Smser.call_sms_service(uri)
    end

    def send_message(phone, message)
      unless  SEND_SMS
        Rails.logger.info("Won't send sms message as it was turn off in config/initializers/sms_config.rb")
        return '0', 'succeed'
      end

      sms_service_uri = 'http://www.68885888.com/ws/Send.aspx?CorpID='\
            + @cdkey + '&Pwd=' + @password + '&Mobile=' + phone\
            + '&Content=' + message + ". " + "&addserial="
      response = Smser.call_sms_service(sms_service_uri)

      doc = Nokogiri::HTML(response.body)

      #code = doc.xpath("//response/error").first.content
      #message = doc.xpath("//response/message").first.content

      #return code == '0', message
    end


    def send_message_activate(phone, message)
      unless  SEND_SMS
        Rails.logger.info("Won't send sms message as it was turn off in config/initializers/sms_config.rb")
        return '0', 'succeed'
      end


      sms_service_uri = 'http://www.68885888.com/ws/Send.aspx?CorpID='\
            + @cdkey + '&Pwd=' + @password + '&Mobile=' + phone\
            + '&Content=' + message + "."
      response = Smser.call_sms_service(sms_service_uri)

      doc = Nokogiri::HTML(response.body)

      #code = doc.xpath("//response/error").first.content
      #message = doc.xpath("//response/message").first.content

      #return code == '0', message
    end

    def send_message_without_suffix(phone, message)
      unless  SEND_SMS
        Rails.logger.info("Won't send sms message as it was turn off in config/initializers/sms_config.rb")
        return '0', 'succeed'
      end

      sms_service_uri = 'http://www.68885888.com/ws/Send.aspx?CorpID='\
            + @cdkey + '&Pwd=' + @password + '&Mobile=' + phone\
            + '&Content=' + message + "." + "&addserial="
      response = Smser.call_sms_service(sms_service_uri)

      doc = Nokogiri::HTML(response.body)

      #code = doc.xpath("//response/error").first.content
      #message = doc.xpath("//response/message").first.content

      #return code == '0'
    end

    def send_cash_repaid_message(phone, message)
      unless  SEND_SMS
        Rails.logger.info("Won't send sms message as it was turn off in config/initializers/sms_config.rb")
        return '0', 'succeed'
      end

      sms_service_uri = 'http://www.68885888.com/ws/Send.aspx?CorpID='\
            + @cdkey + '&Pwd=' + @password + '&Mobile=' + phone\
            + '&Content=' + message + "."+ "&addserial="
      response = Smser.call_sms_service(sms_service_uri)

      doc = Nokogiri::HTML(response.body)

      #code = doc.xpath("//response/error").first.content
      #message = doc.xpath("//response/message").first.content

      #return code == '0'
    end


    def call_sms_service(url)
      url= url.strip
      url= Iconv.conv("gbk","UTF-8", url)
      url= URI.encode( url)
      url = URI.parse( url)
      sms_service = Net::HTTP.new(url.host, url.port)
      sms_service.open_timeout = 20
      sms_service.read_timeout = 20
      sms_service.get(url)
    end

  end

end
