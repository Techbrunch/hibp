require 'httparty'
require 'uri'
require 'colorize'
require 'json'

results = []

#HTTParty::Basement.http_proxy('127.0.0.1', 8080, nil, nil)

ARGF.each_with_index do |email|
  response = HTTParty.get("https://haveibeenpwned.com/unifiedsearch/" + email.strip!.sub('@', '%40'), {
    headers: {
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36',
        'Host' => 'haveibeenpwned.com',
        'Accept-Language' => 'en-GB,en-US;q=0.9,en;q=0.8,fr;q=0.7',
    },
    #debug_output: STDOUT,
    #verify: false
  })
  if response.code == 200
    json = JSON.parse(response.body)
    result = {email: email, breaches: json['Breaches']}
    puts JSON.pretty_generate(result)
    results.push(result)
  elsif response.code != 404
    puts response.body, response.code, response.message, response.headers.inspect
  end
  sleep(1.5)
end

puts results.to_json


