class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::Http::Parameters::ParseError => error
    if env['HTTP_ACCEPT'].match?(%r{application/json})
      return [400, { 'Content-Type' => 'application/json' }, []]
    else
      raise error
    end
  end
end
