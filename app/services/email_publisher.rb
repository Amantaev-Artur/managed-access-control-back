require 'bunny'

class EmailPublisher
  def initialize(email:, action:, data:)
    @connection = Bunny.new(
      hostname: ENV.fetch('RABBITMQ_HOST'),
      port: ENV.fetch('RABBITMQ_PORT'),
      user: ENV.fetch('RABBITMQ_USER'),
      password: ENV.fetch('RABBITMQ_PASSWORD')
    )
    @email = email
    @action = action
    @data = data
  end

  def call
    @connection.start

    channel = @connection.create_channel

    queue_name = 'mailer'

    payload = {
      email: @email,
      action: @action,
      **@data
    }.stringify_keys

    channel.default_exchange.publish(Oj.dump(payload), routing_key: queue_name)

    @connection.close
  end
end