# require 'exponent-server-sdk'

class PushNotificationService
  @@exponent_push_token = 'ExponentPushToken[xxxxxxxxxxxxxxxxxxxxxx]'

  def initialize
    @client = Exponent::Push::Client.new
  end

  def send_push_notification(_token, _title, _body)
    messages = [{
      to: 'ExponentPushToken[xxxxxxxxxxxxxxxxxxxxxx]',
      sound: 'default',
      body: 'Hello world!'
    }, {
      to: 'ExponentPushToken[yyyyyyyyyyyyyyyyyyyyyy]',
      badge: 1,
      body: "You've got mail"
    }]

    handler = client.send_messages(messages)

    # puts handler.errors

    # you probably want to delay calling this because the service might take a few moments to send
    # I would recommend reading the expo documentation regarding delivery delays
    # client.verify_deliveries(handler.receipt_ids)
  end
end
