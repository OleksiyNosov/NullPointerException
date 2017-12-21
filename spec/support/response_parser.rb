module ResponseParser
  def response_collection_values *keys
    response_body.map { |element| extract_values element, keys }
  end

  def response_values *keys
    extract_values response_body, keys
  end

  def extract_values element, keys
    keys.map!(&:to_s)

    element.slice(*keys)
  end

  def response_body
    JSON.parse response.body
  end
end
