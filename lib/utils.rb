require 'httparty'

module Utils
  IPDATA_API_KEY = "974d320fd436e6373303f33e09551220e6a0d314dba57fb18972e78d"
  IPDATA_API_URL = "https://api.ipdata.co/"

  module_function

  def get_location(ip)
    response = HTTParty.get("#{IPDATA_API_URL}#{ip}?api-key=#{IPDATA_API_KEY}")
    response.parsed_response
  end
end
