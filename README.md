# Omniauth::Openweixin::Oauth2

Omniauth Strategy for https://open.weixin.qq.com/

微信开放平台的Omniauth Strategy

## Installation

```ruby
gem "omniauth-wechat-oauth2", git: 'git@github.com:yangsr/omniauth-wechat-oauth2.git'
```

## Usage

Here's an example for adding the middleware to a Rails app in `config/initializers/omniauth.rb`:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, ENV["WECHAT_APP_ID"], ENV["WECHAT_APP_SECRET"]
end
```

If you want to specify the callback url:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, ENV["WECHAT_APP_ID"], ENV["WECHAT_APP_SECRET"],
    :authorize_params => {:redirect_uri => "http://www.example.com/auth/wechat/callback"}
end
```
You can now access the OmniAuth Wechat OAuth2 URL: `/auth/wechat`

## Credits

Skinnyworm, If you want the Omniauth Strategy for http://mp.weixin.qq.com, Click [here](https://github.com/skinnyworm/omniauth-wechat-oauth2)

## Notice
There is some difference between https://open.weixin.qq.com/ and http://mp.weixin.qq.com, plz choose the appropriate gem to use.

微信公众平台和微信开放平台的OAuth流程略有不同，请选择合适的gem使用。

## About Unionid

UnionID机制，官方的解释是：

> 通过获取用户基本信息接口，开发者可通过OpenID来获取用户基本信息，而如果开发者拥有多个公众号，可使用以下办法通过UnionID机制来在多公众号之间进行用户帐号互通。只要是同一个微信开放平台帐号下的公众号，用户的UnionID是唯一的。换句话说，同一用户，对同一个微信开放平台帐号下的不同应用，UnionID是相同的。

此前的OpenID机制，每个微信号对应每个公众号只有唯一的OpenID，所以不同微信公众号之间是不能共享用户的，现在有了UnionID就可以了。
