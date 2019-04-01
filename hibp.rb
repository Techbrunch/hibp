require 'httparty'
require 'uri'
require 'colorize'
require 'json'

results = []

File.open(ARGV[0]).each do |email|
  response = HTTParty.get("https://api.haveibeenpwned.com/unifiedsearch/" + email.strip!.sub('@', '%40'), {
    headers: {
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0) Gecko/20100101 Firefox/66.0',
        'Accept' => '*/*',
        'Accept-Language' => 'en-GB,en;q=0.5',
        'Referer' => 'https://haveibeenpwned.com/',
        'Origin' => 'https://haveibeenpwned.com/'
    },
    #debug_output: STDOUT
  })
  if response.code == 200
    json = JSON.parse(response.body)
    results.push({email: email, breaches: json['Breaches']})
  elsif response.code != 404
    puts response.body, response.code, response.message, response.headers.inspect
  end
  sleep(1.5)
end

puts results.to_json


