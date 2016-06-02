require 'barometer'
require 'rubygems'
require 'twilio-ruby'

account_sid = "ACc936ff2e6318b23e202241bd899737c3"
auth_token ="501cdd2c8e7dd7b57aedf27e9e5f176e"

@client = Twilio::REST::Client.new(account_sid,auth_token)

def get_weather(location)
@barometer = Barometer.new(location)
@weather = @barometer.measure
return @weather
end


def current_weather(weather)
@weather = weather
@temp = @weather.current.temperature.imperial
@condition = @weather.current.icon

case
when @condition.match("sun")
condition = "Sunny...put the flag up."
when @condition.match("cloud")
condition = "Cloudy....put the flag up, just in case."
when @condition.match("clear")
condition = "Clear...flag goes up."
when @condition.match("rain")
condition = "Rainy...no flag today."
when @condition.match("haz")
condition = "Hazy....yep, the flag goes up."
when @condition.match("snow")
condition = "Snowy...No flag today."
end

return "Right now, your conditions are \n #{@temp} degrees and #{condition}.\n"
end


def forecasting(weather)
@forecast = @weather.forecast
@forecast_a = []

@forecast.each do |x|

case
when x.icon.match("sun")
condition = "Sunny....put the flag up."
when  x.icon.match("cloud")
condition = "Cloudy....put the flag up, just in case."
when  x.icon.match("clear")
condition = "Clear....flag goes up."
when  x.icon.match("rain")
condition = "Rainy....no flag today."
when  x.icon.match("haz")
condition = "Hazy.....yep, the flag goes up."
when  x.icon.match("snow")
condition = "Snowy....No flag today."
end

@forecast_a.push("On #{x.starts_at.month}/#{x.starts_at.day} expect: #{condition} high temp of #{x.high.f}F and a low temp of #{x.low.f}F.\n")

end

return @forecast_a

end


puts "What zip code, please?"
location = gets.chomp
weather = get_weather(location)

current = current_weather(weather)
puts current

forecast = forecasting(weather)
puts "And your weather for the rest of the week is:\n"
forecast.each {|x| puts x}


message = @client.account.messages.create(
	:from => "+12012040810 ",
	:to => "+12017794132",
	:body => current
)

puts message.to