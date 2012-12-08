require 'net/pop'
require 'pp'

FROM = /(From|FROM):.+<(.*)>/
CONTENT_TYPE = /Content-Type:(.*)/
BOUNDARY = /(boundary|BOUNDARY)="?([^"]*)"?/
URL = /((http|https)[^\s]*)/i

def from(m)
  md = FROM.match m.header
  md[2]
end

def link(m)
  m.top(m.length)
end

def content_type(m)
  md = CONTENT_TYPE.match m.header
  md[1] unless md.nil?
end

def boundary(m)
  md = BOUNDARY.match content_type(m)
  md[2] unless md.nil?
end

def body(m)
  boundary = boundary(m)
  headers, body_str = m.top(m.size).split("\r\n\r\n",2)
  if (boundary)
    content_type, body_str = body_str.split(boundary)[1].split("\r\n\r\n",2)
  end

  md = URL.match(body_str)

  md[1] unless md.nil?
end


Net::POP.enable_ssl

Net::POP3.start('pop.gmail.com', 995,
                'jetty@ouelong.com', 'jettybot1') do |pop|
  if pop.mails.empty?
    puts 'No mail.'
  else
    i = 0
    pop.each_mail do |m|   # or "pop.mails.each ..."
      puts from(m)
      puts body(m)
      i += 1
    end
    puts "#{pop.mails.size} mails popped."
  end
  pop.reset
end
