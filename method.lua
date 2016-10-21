
 package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
 package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'
 URL = require('socket.url')
 assert(JSON)

 http = require "socket.http"
 HTTPS = require('ssl.https')
 ltn12 = require("ltn12")
 BASE_URL = 'https://api.telegram.org/bot' .. config.bot_api_key
 function sendRequest(url)

  local dat, res = HTTPS.request(url)

  local tab = JSON:decode(dat)

  if res ~= 200 then
    return false, res
  end

  if not tab.ok then
    return false, tab.description
  end

  return tab

end
 function getMe()

   local url = BASE_URL .. '/getMe'
   return sendRequest(url)

end
 function getUpdates(offset)

  local url = BASE_URL .. '/getUpdates?timeout=20'

  if offset then

    url = url .. '&offset=' .. offset

  end

  return sendRequest(url)

end
 function sendMessage(chat_id, text, disable_web_page_preview, reply_to_message_id, use_markdown, reply_markup )

   local url = BASE_URL .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)

   if disable_web_page_preview == true then
      url = url .. '&disable_web_page_preview=true'
   end

   if reply_to_message_id then
      url = url .. '&reply_to_message_id=' .. reply_to_message_id
   end

   if use_markdown then
      url = url .. '&parse_mode=Markdown'
   end
   if reply_markup then
   url = url .. "&reply_markup="..URL.escape(reply_markup)
end

--   by @mico_iq
   return JSON:decode(HTTPS.request(url))

end
 function getChatAdministrators(chat_id)

local url = BASE_URL .. '/getChatAdministrators?chat_id=' .. chat_id
return sendRequest(url)
end
 function sendChatAction(chat_id, action)
 -- Support actions are typing, upload_photo, record_video, upload_video, record_audio, upload_audio, upload_document, find_location

   local url = BASE_URL .. '/sendChatAction?chat_id=' .. chat_id .. '&action=' .. action
   return sendRequest(url)

end
 function editMessageText(chat_id, message_id, text, keyboard, markdown)

	local url = BASE_URL .. '/editMessageText?chat_id=' .. chat_id .. '&message_id='..message_id..'&text=' .. URL.escape(text)

	if markdown then
		url = url .. '&parse_mode=Markdown'
	end

	url = url .. '&disable_web_page_preview=true'

	if keyboard then
		url = url..'&reply_markup='..keyboard
	end
 --by @mico_iq
	return JSON:decode(HTTPS.request(url))

end
 function answerCallbackQuery(callback_query_id, text, show_alert)

	local url = BASE_URL .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)

	if show_alert then
		url = url..'&show_alert=true'
	end

	return sendRequest(url)

end
