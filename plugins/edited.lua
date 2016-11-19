--[[
     Here you can see the settings and how the bot works please do not forget to set up the bot by adding your main-group for the re-change ads between channels
	 and to put the id of document that contain gif file about how can the user sign in with the bot  by the way there is some messages u should edit it below like ur main-channel etc and the replays .
	 *important* put same messages in line (48,108,180,477) put the main group id in line (33) put welcome message in line (275)
	 do not forget to have a copy of multi-part-post oon ur server
	 give this project star to push me to do the best.
	 for more suggestion and question please do not be lazy to chat with me here telegram.me/mico_iq .
	 just keep in mind it is beta version.
	 if u have any idea go ahead and do pull request or just fork it.
	 do not change the copy right of my own MICO .
	 shared on github on 2016/10/20

]]
function is_admin(msg)
 local value = false
  for i =1,#getChatAdministrators(msg.chat.id).result do 
    if getChatAdministrators(msg.chat.id).result[i].user.id == msg.from.id then
    value = true
    end
  end
  return value
end
function run(msg,matches)
 if msg.chat.type == "private" then
 sendMessage(msg.chat.id,"please,use me in group only")
 return
 end
    load = load_data("words.db")
    load.chat = load.chat or {}
 if matches[1] =="##new_chat_member##" and load.chat[tostring(msg.chat.id)] then
 return
 end
 if msg.text == "#in:arb" and is_admin(msg) then
   load.lang[tostring(msg.chat.id)] = "arb"
  save_data("words.db",load)
  editMessageText(msg.chat.id,msg.message_id,"تم أختيار اللغه العربيه.")
  return
 elseif msg.text == "#in:eng" and is_admin(msg) then
   load.lang[tostring(msg.chat.id)] = "eng"
   save_data("words.db",load)
   editMessageText(msg.chat.id,msg.message_id,"English language has been chosen")
  return
 end
  if msg.text == "#in:arb" and not is_admin(msg) then
   answerCallbackQuery(msg.cb_id,"فقط الادمن يمكنه اختيار اللغه",true)
  return
 elseif msg.text == "#in:eng" and not is_admin(msg) then
  answerCallbackQuery(msg.cb_id,"Just the admin can choose the language",true)
  return
 end
 if matches[1] == "/start"  or matches[1] =="##new_chat_member##" then
  if matches[1] =="##new_chat_member##" then
    load.chat[tostring(msg.chat.id)] = ""
    save_data("words.db",load)
  end
  load.lang = load.lang or {}
  load.lang[tostring(msg.chat.id)] = "eng"
  save_data("words.db",load)
  text  = "please choose language to be set as default :-"
  local keyboard = {}
  keyboard.inline_keyboard = {{{text = "English",callback_data = "eng"},{text = "Arabic",callback_data = "arb"}},}
  sendMessage(msg.chat.id, text, true, msg.message_id, false, JSON:encode(keyboard))
 end
  if msg.chat.type ~= "edited" then
   
   msg.text = msg.text or msg.caption or ""
   if msg.text ~= "" then
   load.word = load.word or {}
   load.word[tostring(msg.date.."#"..msg.chat.id.."#"..msg.from.id)] = load.word[tostring(msg.date.."#"..msg.chat.id.."#"..msg.from.id)] or {}
   table.insert(load.word[tostring(msg.date.."#"..msg.chat.id.."#"..msg.from.id)],msg.text)
   save_data("words.db",load)
   end
  end
 if msg.chat.type == "edited" then
 msg.text = msg.text or msg.caption or ""
 if msg.text ~= "" then
 table.insert(load.word[tostring(msg.rdate.."#"..msg.chat.id.."#"..msg.from.id)],msg.text)
 save_data("words.db",load)
 end
 if load.word[msg.rdate.."#"..msg.chat.id.."#"..msg.from.id] then
  local text = ""
  for k,v in pairs(load.word[tostring(msg.rdate.."#"..msg.chat.id.."#"..msg.from.id)]) do
   if k ~= #load.word[tostring(msg.rdate.."#"..msg.chat.id.."#"..msg.from.id)] then
   text = text..k.." - "..v.."\n"
   end
  end
 if load.lang[tostring(msg.chat.id)] and load.lang[tostring(msg.chat.id)] == "arb" then
 sendMessage(msg.chat.id,"لقد كانت الكلمه : \n"..text,true,msg.message_id,false)
 return
else
  sendMessage(msg.chat.id,"The word was: \n"..text,true,msg.message_id,false)
 return
 end
 end
 end
return
end
return {

patterns = {
"(.*)"
},
run = run,
--timer = timer
}
