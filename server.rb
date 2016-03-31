require 'webrick'
require 'json'
require 'firebase'

server = WEBrick::HTTPServer.new(Port: 1234)

class Game < WEBrick::HTTPServlet::AbstractServlet

  class ShootoutGame
    BASE_URI = 'https://resplendent-heat-1218.firebaseio.com/'
    $firebase = Firebase::Client.new(BASE_URI)
    attr_reader :id, :turn, :round

    def initialize
      @id = __id__.to_s
      @turn = %w(shoot save).sample
      @round = 0
    end

    def start_game
      call = $firebase.push("games", { id: id, turn: turn })
      name = JSON.parse(call.response.body)['name'];
      { game_id: name, player_turn: turn }.to_json
      # JSON.generate({"created_at":"2013-03-14T16:53:52-04:00"})
    end

    def self.find_game(game_id)
      response = $firebase.get("games/#{game_id}")
      response.body.to_json
    end
  end

  def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'application/json; charset=utf-8'
    case request.path
    when '/'
      result = 'Welcome to the Game. Hit /start path to begin.'
    when '/start'
      game = ShootoutGame.new.start_game
      result = game
    when '/show'
      game_id = request.query['game_id']
      game = ShootoutGame.find_game(game_id)
      result = game
    else
      response.status = 404
      result = 'Page not found.'
    end
    response.body = result
  end
end

def do_POST(request, response)
  response.status = 200
  response['Content-Type'] = 'application/json'
  case request.path
  when '/shoot'
    result = 'shooted'
  end
  response.body = result
end

server.mount '/', Game

trap('INT') { server.shutdown }

server.start
