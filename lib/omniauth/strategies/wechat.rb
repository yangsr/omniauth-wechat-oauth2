require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Wechat < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "wechat"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        site:          "https://api.weixin.qq.com",
        authorize_url: "https://open.weixin.qq.com/connect/qrconnect#wechat_redirect",
        token_url:     "/sns/oauth2/access_token",
        token_method:  :get
      }

      option :authorize_params, {scope: "snsapi_login"}

      option :token_params, {parse: :json}

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info['openid'] }

      info do
        {
          nickname:   raw_info['nickname'],
          sex:        raw_info['sex'],
          province:   raw_info['province'],
          city:       raw_info['city'],
          country:    raw_info['country'],
          headimgurl: raw_info['headimgurl'],
          unionid:    raw_info['unionid'],
        }
      end

      extra do
        {raw_info: raw_info}
      end

      def request_phase
        params = client.auth_code.authorize_params.merge(redirect_uri: callback_url).merge(authorize_params)
        params["appid"] = params.delete("client_id")
        redirect client.authorize_url(params)
      end

      def raw_info
        @uid ||= access_token["openid"]
        @raw_info ||= begin
          access_token.options[:mode] = :query
          response = access_token.get("/sns/userinfo", :params => {"openid" => @uid}, parse: :text)
          @raw_info = JSON.parse(response.body.gsub(/[\u0000-\u001f]+/, ''))
        end
      end

      protected
      def build_access_token
        params = {
          'appid' => client.id,
          'secret' => client.secret,
          'code' => request.params['code'],
          'grant_type' => 'authorization_code'
          }.merge(token_params.to_hash(symbolize_keys: true))
        client.get_token(params, deep_symbolize(options.auth_token_params))
      end
    end
  end
end
