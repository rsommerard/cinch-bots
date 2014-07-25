require 'cinch'

# Loggie Plugin
class Loggie
  include Cinch::Plugin
  listen_to :channel

  match(/(.+)/)

  def initialize(*args)
    super
  end

  def listen(m)
    time = Time.now
    directory_name = 'logs/' + time.strftime('%Y%m%d') + '/'
    file_name = directory_name + m.channel.name + '.cinch.log'
    Dir.mkdir(directory_name) unless Dir.exist?(directory_name)
    f = File.new(file_name, 'a')
    f.puts "[#{time.strftime('%H:%M:%S')}] #{m.user}: #{m.message}"
    f.close
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.mozilla.org'
    c.channels = ['#b2g', '#frenchmoz', '#mozfr']
    c.nick = 'Loggie'
    c.plugins.plugins = [Loggie]
  end
end

bot.start
