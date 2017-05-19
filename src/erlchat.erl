%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 五月 2017 9:47
%%%-------------------------------------------------------------------
-module(erlchat).
-author("jiarj").
-include("include/wechat.hrl").

%% API
-export([get_code_url/3, get_access_token/3, refresh_token/2, get_userinfo/2, check/4, send_template_message/2]).

get_code_url(Appid,Redirect_uri,State) when is_list(Appid),is_list(Redirect_uri),is_list(Redirect_uri) ->
  Enc_url=edoc_lib:escape_uri(Redirect_uri),
  Url = ?API_URL_CODE++"?appid="++Appid++"&redirect_uri="++Enc_url++"&response_type=code&scope=snsapi_userinfo&state=" ++ State ++"#wechat_redirect",
  Url.

get_access_token(Appid,Secret,Code) when is_list(Appid),is_list(Secret),is_list(Code)->
  %Access_token_Rui = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="++Appid++"&secret="++Secret++"&code="++binary_to_list(Code)++"&grant_type=authorization_code",
  Access_token_Rui = ?API_URL_ACCESS_TOKEN++"?appid="++Appid++"&secret="++Secret++"&code="++Code++"&grant_type=authorization_code",
  Response= wechat_util:http_get(Access_token_Rui),
  Response;
get_access_token(app,Appid,Secret) when is_list(Appid),is_list(Secret) ->
  %Access_token_Rui = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="++Appid++"&secret="++Secret++"&code="++binary_to_list(Code)++"&grant_type=authorization_code",
  Access_token_Rui = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&"++"appid="++Appid++"&secret="++Secret,
  Response= wechat_util:http_get(Access_token_Rui),
  Response.

refresh_token(Appid,REFRESH_TOKEN) when is_list(Appid),is_list(REFRESH_TOKEN) ->
  %Access_token_Rui = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="++Appid++"&secret="++Secret++"&code="++binary_to_list(Code)++"&grant_type=authorization_code",
  REFRESH_TOKEN_Rui = ?API_URL_REFRESH_TOKEN++"?appid="++Appid++"&grant_type=refresh_token&refresh_token="++REFRESH_TOKEN,
  Response= wechat_util:http_get(REFRESH_TOKEN_Rui),
  Response.

get_userinfo(ACCESS_TOKEN,OPENID) when is_list(ACCESS_TOKEN),is_list(OPENID)->
  %Userinfo_Url = "https://api.weixin.qq.com/sns/userinfo?access_token="++binary_to_list(ACCESS_TOKEN)++"&openid="++binary_to_list(OPENID),
  Userinfo_Url =?API_URL_USERINFO++"?access_token="++ACCESS_TOKEN++"&openid="++OPENID++"&lang=zh_CN",
  Userinfo= wechat_util:http_get(Userinfo_Url),
  Userinfo.

check(Signature, Timestamp, Nonce,Token) when is_list(Signature),is_list(Timestamp),is_list(Nonce),is_list(Token)->
  TmpList = [Token, Timestamp, Nonce],
  TmpList2 = lists:sort(TmpList),
  TmpStr = string:join(TmpList2, ""),
  Hash = wechat_util:hexstring(TmpStr),
  string:equal(string:to_lower(Signature), string:to_lower(Hash)).

send_template_message(AccessToken, Message) when is_list(AccessToken),is_binary(Message) ->
  URL = ?API_URL_PREFIX ++ "/cgi-bin/message/template/send?access_token="++AccessToken,
  wechat_util:http_post(URL, Message).



