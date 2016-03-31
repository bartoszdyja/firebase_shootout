require 'webrick'

server = WEBrick::HTTPServer.new(Port: 1234)

class Game < WEBrick::HTTPServlet::AbstractServlet

  class ShootoutGame
    attr_reader :id

    def initialize
      @id = __id__.to_s
    end

    def new_game
      "From new game " + id
    end
  end

  def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'application/json'
    case request.path
    when '/'
      result = 'Welcome to the Game. Hit /start path to begin.'
    when '/start'
      @game = ShootoutGame.new
      result = @game.new_game
    else
      response.status = 404
      result = 'Page not found.'
    end
    response.body = result
  end
end


server.mount '/', Game

trap('INT') { server.shutdown }

server.start
