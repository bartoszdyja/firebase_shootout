require 'webrick'

server = WEBrick::HTTPServer.new(Port: 1234)

class Game < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    # status, conte:nt_type, body = do_stuff_with request

    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = request.path
  end
end

server.mount '/', Game

trap('INT') { server.shutdown }

server.start
