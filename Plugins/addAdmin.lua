
local function storm_send(chat_id, reply_to_message_id, text) local TextParseMode = {ID = "TextParseModeMarkdown"}
tdcli_function ({ID = "SendMessage",chat_id_ = chat_id,reply_to_message_id_ = reply_to_message_id,disable_notification_ = 1,from_background_ = 1,reply_markup_ = nil,input_message_content_ = {ID = "InputMessageText",text_ = text,disable_web_page_preview_ = 1,clear_draft_ = 0,entities_ = {},parse_mode_ = TextParseMode,},}, dl_cb, nil)
end
--###########################
function sendMention(msg,chat,text,user)   
entities = {}   
entities[0] = {ID='MessageEntityBold', offset_=0, length_=0}   
if text and text:match('{') and text:match('}')  then   
local x = utf8.len(text:match('(.*){'))   
local offset = x + 1  
local y = utf8.len(text:match('{(.*)}'))   
local length = y + 1  
text = text:gsub('{','')   
text = text:gsub('}','')   
table.insert(entities,{ID="MessageEntityMentionName", offset_=offset, length_=length, user_id_=user})   
end   
return tdcli_function ({ID="SendMessage", chat_id_=chat, reply_to_message_id_=msg.id_, disable_notification_=0, from_background_=1, reply_markup_=nil, input_message_content_={ID="InputMessageText", text_=text, disable_web_page_preview_=1, clear_draft_=0, entities_=entities}}, dl_cb, nil)   
end
local function getMessag(chat_id, message_id,cb) 
tdcli_function ({ ID = "GetMessage", chat_id_ = chat_id, message_id_ = message_id }, cb, nil) 
end 
--###########################
function CatchNameSet(Name) 
ChekName = utf8.sub(Name,0,35) 
Name = ChekName 
if utf8.len(Name) > 30 then
t=  Name..' ...' 
else
t = Name
end
return t
end
--###########################
function nadmin(msg,chat,user,word) --// نتيجه تنزيل الادمن
if (msg.can_be_deleted_ == false) then   
storm_send(chat,msg.id_,"-› البوت ليس مشرف هنا، ارفع البوت بكل الصلاحيات .")   
return false end      
tdcli_function ({ID = "GetChatMember",chat_id_ = chat,user_id_ = user},function(arg,da) 
tdcli_function ({ID = "GetUser",user_id_ = user},function(arg,data) 
if data.message_ == "User not found" then
storm_sendMsg(msg.chat_id_, msg.id_, 1,'-› اعذرني مايمديني اطلع معلوماته . \n', 1, 'md')
return false  end
if tonumber(user) == tonumber(max) then  
storm_send(chat,msg.id_,"-› انا البوت مايمديني اغير اسمي .")   
return false  end 
if (da and da.status_.ID == "ChatMemberStatusCreator") then
storm_send(chat,msg.id_,"-› لايمكنني تغيير اسم مالك المجموعة .")   
return false  end 
local SET_ADMIN = https.request('https://api.telegram.org/bot'..Token..'/promoteChatMember?chat_id='.. chat ..'&user_id='.. user..'&can_pin_messages=true&can_restrict_members=true&can_invite_users=true&can_delete_messages=true&can_change_info=true&can_promote_members=false')
local JSON_ADMIN = JSON.decode(SET_ADMIN)
local SET_U = https.request('https://api.telegram.org/bot'..Token..'/setChatAdministratorCustomTitle?chat_id='.. chat ..'&user_id='.. user..'&custom_title='..word)
local JSON_SET = JSON.decode(SET_U)
if (JSON_ADMIN.description == "Bad Request: not enough rights" and JSON_ADMIN.error_code == 400) then
storm_send(chat,msg.id_,"-› لا يمكنني تغيير اسم المشرف لأن ليس لدي صلاحية - إضافة مشرفين جدد - .")   
return false  end 
if (JSON_ADMIN.result == true) and (JSON_SET.description == "Bad Request: ADMIN_RANK_EMOJI_NOT_ALLOWED" and JSON_SET.error_code == 400) then
storm_send(chat,msg.id_,"-› لايمكن أن يتضمن اسم المشرف ايموجي .")   
return false  end 
if (JSON_ADMIN.description == "Bad Request: CHAT_ADMIN_REQUIRED" and JSON_ADMIN.error_code == 400) then
storm_send(chat,msg.id_,"-› لا يمكنني تغيير اسم المشرف لأني لم أرفعه .")   
return false  end 
if (JSON_ADMIN.result == true) and (JSON_SET.result == true)  then
sendMention(msg,chat,'- ('..CatchNameSet(data.first_name_)..')'..'\n- تم تغيير اسم المشرف في المجموعة \n',user)   
end end,nil) end,nil)   
end
--###########################
function rem_admin(msg,chat,user) --// نتيجه تنزيل الادمن
if (msg.can_be_deleted_ == false) then   
storm_send(chat,msg.id_,"-› البوت ليس مشرف هنا، ارفع البوت بكل الصلاحيات .")   
return false end      
tdcli_function ({ID = "GetChatMember",chat_id_ = chat,user_id_ = user},function(arg,da) 
tdcli_function ({ID = "GetUser",user_id_ = user},function(arg,data) 
if data.message_ == "User not found" then
storm_sendMsg(msg.chat_id_, msg.id_, 1,'-› اعذرني مايمديني اطلع معلوماته . \n', 1, 'md')
return false  end
if tonumber(user) == tonumber(max) then  
storm_send(chat,msg.id_,"-› انا البوت مايمديك تنزلني .")   
return false  end 
if (da and da.status_.ID == "ChatMemberStatusCreator") then
storm_send(chat,msg.id_,"-› لايمكنني تنزيل مالك المجموعة .")   
return false  end 
if (da and da.status_.ID == "ChatMemberStatusMember") then
storm_send(chat,msg.id_,"-› هو ليس مشرف اصلاً .")   
return false  end 
local SET_ADMIN = https.request('https://api.telegram.org/bot'..Token..'/promoteChatMember?chat_id='.. chat ..'&user_id='.. user..'&can_pin_messages=false&can_restrict_members=false&can_invite_users=false&can_delete_messages=false&can_change_info=false')
local JSON_ADMIN = JSON.decode(SET_ADMIN)
if (JSON_ADMIN.description == "Bad Request: not enough rights" and JSON_ADMIN.error_code == 400) then
storm_send(chat,msg.id_,"-› لا يمكنني تنزيل المشرف لأن ليس لدي صلاحية - إضافة مشرفين جدد - .")   
return false  end 
if (JSON_ADMIN.description == "Bad Request: CHAT_ADMIN_REQUIRED" and JSON_ADMIN.error_code == 400) then
storm_send(chat,msg.id_,"-› لا يمكنني تنزيل المشرف لأني لم أرفعه .")   
return false  end 
if (JSON_ADMIN.result == true) then
sendMention(msg,chat,'- ('..CatchNameSet(data.first_name_)..')'..'\n- تم تنزيله من المشرفين في المجموعة \n',user)   
end end,nil) end,nil)   
end
--###########################
function add_admin(msg,chat,user) --// نتيجه رفع ادمن
if (msg.can_be_deleted_ == false) then   
storm_send(chat,msg.id_,"-› البوت ليس مشرف هنا، ارفع البوت بكل الصلاحيات .")   
return false end      
tdcli_function ({ID = "GetChatMember",chat_id_ = chat,user_id_ = user},function(arg,da) 
tdcli_function ({ID = "GetUser",user_id_ = user},function(arg,data) 
if data.message_ == "User not found" then
storm_sendMsg(msg.chat_id_, msg.id_, 1,'-› اعذرني مايمديني اطلع معلوماته .\n', 1, 'md')
return false  end
if tonumber(user) == tonumber(bot_id) then  
storm_send(chat,msg.id_,"-› انا مشرف (: . .")   
return false  end 
if (da and da.status_.ID == "ChatMemberStatusCreator") then
storm_send(chat,msg.id_,"-› لايمكنني رفع مالك المجموعة .")   
return false  end 
if (da and da.status_.ID == "ChatMemberStatusEditor") then
storm_send(chat,msg.id_,"-› هذا الشخص مشرف بالمجموعة اصلاً .")   
return false  end 
local SET_ADMIN = https.request('https://api.telegram.org/bot'..Token..'/promoteChatMember?chat_id='.. chat ..'&user_id='.. user..'&can_pin_messages=true&can_restrict_members=true&can_invite_users=true&can_delete_messages=true&can_change_info=true&can_promote_members=false')
local JSON_ADMIN = JSON.decode(SET_ADMIN)
if (JSON_ADMIN.description == "Bad Request: not enough rights" and JSON_ADMIN.error_code == 400) then
storm_send(chat,msg.id_,"-› لا يمكنني رفع المشرف لأن ليس لدي صلاحية - إضافة مشرفين جدد - .")   
return false  end 
if (JSON_ADMIN.result == true) then
taha = '\n'
sendMention(msg,chat,'-  ('..CatchNameSet(data.first_name_)..')'..'\n - تم رفعه مشرف في المجموعة . \n'..taha,user)   
end end,nil) end,nil)   
end

--###########################

--€€€€€€€€€€€€€€€€€€€€€
local function games(msg,MsgText)
if msg.type ~= "pv" and msg.GroupActive then
if MsgText[1] == "تغيير" then
if not msg.Creator then
storm_send(msg.chat_id_,msg.id_,"-› هذا الأمر للمالك الاساسي فقط .")   
return false  end 
if tonumber(msg.reply_to_message_id_) ~= 0 then
function prom_reply(extra, result, success) 
nadmin(msg,msg.chat_id_,result.sender_user_id_,MsgText[2])
end  
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},prom_reply, nil)
end
end 
if MsgText[1] == "رفع مشرف" then
if not msg.Creator then
storm_send(msg.chat_id_,msg.id_,"-› هذا الأمر للمالك الاساسي فقط .")   
return false  end 
if tonumber(msg.reply_to_message_id_) ~= 0 then 
function prom_reply(extra, result, success) 
add_admin(msg,msg.chat_id_,result.sender_user_id_)
end  
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},prom_reply, nil)
end
end 
if MsgText[1] == "تنزيل مشرف" then
if not msg.Creator then
storm_send(msg.chat_id_,msg.id_,"-› هذا الأمر للمالك الاساسي فقط .")   
return false  end 
if tonumber(msg.reply_to_message_id_) ~= 0 then 
function prom_reply(extra, result, success) 
rem_admin(msg,msg.chat_id_,result.sender_user_id_)
end  
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},prom_reply, nil)
end
end 
if MsgText[1] == "رفع مشرف" and MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
if not msg.Creator then
storm_send(msg.chat_id_,msg.id_,"-› هذا الأمر للمالك الاساسي فقط .")   
return false  end 
local username = MsgText[2]
function prom_username(extra, result, success) 
if (result and result.code_ == 400 or result and result.message_ == "USERNAME_NOT_OCCUPIED") then
storm_send(msg.chat_id_,msg.id_,"-› المعرف غير صحيح .")   
return false  end   
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
storm_send(msg.chat_id_,msg.id_,"-› هذا معرف قناة .")   
return false end      
add_admin(msg,msg.chat_id_,result.id_)
end  
tdcli_function ({ID = "SearchPublicChat",username_ = username},prom_username,nil) 
end 
if MsgText[1] == "تنزيل مشرف" and MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
if not msg.Creator then
storm_send(msg.chat_id_,msg.id_,"-› هذا الأمر للمالك الاساسي فقط .")   
return false  end 
local username = MsgText[2]
function prom_username(extra, result, success) 
if (result and result.code_ == 400 or result and result.message_ == "USERNAME_NOT_OCCUPIED") then
storm_send(msg.chat_id_,msg.id_,"-› المعرف غير صحيح .")   
return false  end   
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
storm_send(msg.chat_id_,msg.id_,"-› هذا معرف قناة .")   
return false end      
rem_admin(msg,msg.chat_id_,result.id_)
end  
tdcli_function ({ID = "SearchPublicChat",username_ = username},prom_username,nil) 
end 

if MsgText[1] == "رفع مشرف" and MsgText[2] and MsgText[2]:match('^%d+$') then
if not msg.Creator then
storm_send(msg.chat_id_,msg.id_,"-› هذا الأمر للمالك الاساسي فقط .")   
return false  end 
if tonumber(msg.reply_to_message_id_) == 0 then 
add_admin(msg,msg.chat_id_,MsgText[2])
end
end  
if MsgText[1] == "تنزيل مشرف" and MsgText[2] and MsgText[2]:match('^%d+$') then
if not msg.Creator then
storm_send(msg.chat_id_,msg.id_,"-› هذا الأمر للمالك الاساسي فقط .")   
return false  end 
if tonumber(msg.reply_to_message_id_) == 0 then 
rem_admin(msg,msg.chat_id_,MsgText[2])
end  
end
----------------------------------------



end
end


return {
max = {
'^(تغيير) (.+)$',
'^(رفع مشرف)$',
'^(رفع مشرف) (@[%a%d_]+)$',
'^(رفع مشرف) (%d+)$',
'^(تنزيل مشرف)$',
'^(تنزيل مشرف) (@[%a%d_]+)$',
'^(تنزيل مشرف) (%d+)$', 

 },
 imax = games,


 }



