class GistService
  GIST_URL_REGEXP = /^https:\/\/gist.github.com\/\w+\/\w{32}$/

  def initialize(client: nil)
    @client = client || Octokit::Client.new
    @client.access_token = Rails.application.credentials.dig(:git, :access_token)
  end

  def gist(url)
    @client.gist(url.last(32))
  end

  def gist?(url)
    !!(url =~ GIST_URL_REGEXP)
  end
end
