#Simple bot loop to run the daemon that gets the emails

log_file = File.join(File.dirname(__FILE__),'../log', ARGV[0] + '.log')
logger = Logger.new(log_file ,'daily')

Net::POP.enable_ssl

FROM = /(From|FROM):.+<(.*)>/
URL  = /((http|https)[^\s]*)/i

def from(m)
  md = FROM.match m.header
  md[2]
end

def body(m)
  headers, body_str = m.top(m.size).split("\r\n\r\n",2)
  md = URL.match(body_str)
  md[1] unless md.nil?
end

loop do

  Net::POP3.start('pop.gmail.com', 995,
                  'jetty@ouelong.com', 'jettybot1') do |pop|
    if pop.mails.empty?
      puts 'No mail.'
    else
      i = 0
      pop.each_mail do |m|   # or "pop.mails.each ..."
        logger.info from(m)
        logger.info body(m)
        i += 1
      end
      logger.info "#{pop.mails.size} mails popped."
    end
    pop.reset
  end

  sleep(1)
end
