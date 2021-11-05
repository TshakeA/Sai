--[[
Nashi
--]]
local function addrdod(msg,MsgText)

----=================================| كود الرد العشوائي المجموعات|===============================================
if MsgText[1]=="اضف رد عشوائي" and msg.GroupActive then
if not msg.Director then return "- هذا الامر يخص {المطور,المنشئ,المدير} فقط  \n" end
redis:setex(max..'addrdRandom1:'..msg.chat_id_..msg.sender_user_id_,1400,true) 
redis:del(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_)
return "- حسننا ,  الان ارسل كلمه الرد للعشوائي"
end


if MsgText[1]== "مسح رد عشوائي" then
if not msg.Director then return "- هذا الامر يخص {المطور,المنشئ,المدير} فقط  \n" end
redis:setex(max..':DelrdRandom:'..msg.chat_id_..msg.sender_user_id_,300,true)
return "- حسننا عزيزي\n- الان ارسل الرد العشوائي لمسحها "
end


if MsgText[1] == "مسح الردود العشوائيه" then
if not msg.Director then return "- هذا الامر يخص {المطور,المنشئ,المدير} فقط  " end
local AlRdod = redis:smembers(max..':KlmatRRandom:'..msg.chat_id_) 
if #AlRdod == 0 then return "- الردود العشوائيه محذوفه بالفعل ✓" end
for k,v in pairs(AlRdod) do redis:del(max..':ReplayRandom:'..msg.chat_id_..":"..v) redis:del(max..':caption_replay:Random:'..msg.chat_id_..v) 
end
redis:del(max..':KlmatRRandom:'..msg.chat_id_) 
return "- اهلا عزيزي "..msg.TheRankCmd.."  \n- تم مسح جميع الردود العشوائيه ✓"
end

if MsgText[1] == "الردود العشوائيه" then
if not msg.Director then return "- هذا الامر يخص {المطور,المنشئ,المدير} فقط  " end
message = "- الردود العشـوائيه :\n\n"
local AlRdod = redis:smembers(max..':KlmatRRandom:'..msg.chat_id_) 
if #AlRdod == 0 then 
message = message .."- لا توجد ردود عشوائيه مضافه !\n"
else
for k,v in pairs(AlRdod) do
local incrr = redis:scard(max..':ReplayRandom:'..msg.chat_id_..":"..v) 
message = message..k..'- ['..v..'] ⋙ •⊱ {*'..incrr..'*} ⊰• رد\n'
end
end
return message.."\n"
end
----=================================|نهايه كود الرد العشوائي المجموعات|===============================================

----=================================|كود الرد العشوائي العام|===============================================

if MsgText[1]=="اضف رد عشوائي عام" then
if not msg.SudoUser then return "- هذا الامر يخص {المطور} فقط  \n" end
redis:setex(max..'addrdRandom1Public:'..msg.chat_id_..msg.sender_user_id_,1400,true) 
redis:del(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_)
return "- حسننا ,  الان ارسل كلمه الرد للعشوائي العام "
end


if MsgText[1]== "مسح رد عشوائي عام" then
if not msg.SudoUser then return "- هذا الامر يخص {المطور} فقط  \n" end
redis:setex(max..':DelrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_,300,true)
return "- حسننا عزيزي\n- الان ارسل الرد العشوائي العام لمسحها"
end

if MsgText[1] == "مسح الردود العشوائيه العامه" then
if not msg.SudoUser then return "- هذا الامر يخص {المطور} فقط  \n" end
local AlRdod = redis:smembers(max..':KlmatRRandom:') 
if #AlRdod == 0 then return "- الردود العشوائيه محذوفه بالفعل ✓" end
for k,v in pairs(AlRdod) do redis:del(max..":ReplayRandom:"..v) redis:del(max..':caption_replay:Random:'..v)  end
redis:del(max..':KlmatRRandom:') 
return "- اهلا عزيزي "..msg.TheRankCmd.."  \n- تم مسح جميع الردود العشوائيه ✓"
end

if MsgText[1] == "الردود العشوائيه العام" then
if not msg.SudoUser then return "- هذا الامر يخص {المطور} فقط  \n" end
message = "- الردود العشـوائيه العام :\n\n"
local AlRdod = redis:smembers(max..':KlmatRRandom:') 
if #AlRdod == 0 then 
message = message .."- لا توجد ردود عشوائيه مضافه !\n"
else
for k,v in pairs(AlRdod) do
local incrr = redis:scard(max..":ReplayRandom:"..v) 
message = message..k..'- ['..v..'] ⋙ •⊱ {*'..incrr..'*} ⊰• رد\n'
end
end
return message.."\n"
end

----=================================|نهايه كود الرد العشوائي العام|===============================================
--====================== Reply Random Public =====================================
if redis:get(max..'addrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_) and redis:get(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_) then
klma = redis:get(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_)
msg.klma = klma
if msg.text == "تم" then
redis:del(max..'addrdRandom1Public:'..msg.chat_id_..msg.sender_user_id_)
redis:del(max..'addrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_)
sendMsg(msg.chat_id_,msg.id_,'- تم اضافه رد متعدد عشوائي بنجاح ✓\n- يمكنك ارسال (['..klma..']) لاضهار الردود العشوائيه .')
redis:del(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_)
return false
end

local CountRdod = redis:scard(max..':ReplayRandom:'..klma) or 1
local CountRdod2 = 10 - tonumber(CountRdod)
local CountRdod = 9 - tonumber(CountRdod)
if CountRdod2 == 0 then 
redis:del(max..'addrdRandom1Public:'..msg.chat_id_..msg.sender_user_id_)
redis:del(max..'addrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_)
sendMsg(msg.chat_id_,msg.id_,'- وصلت الحد الاقصى لعدد الردود ✓\n- تم اضافه الرد (['..klma..']) للردود العشوائيه .')
redis:del(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_)
return false
end
if msg.text then 
if utf8.len(msg.text) > 4000 then 
return sendMsg(msg.chat_id_,msg.id_,"- عذرا غير مسموح باضافه جواب الرد باكثر من 4000 حرف تم الغاء الامر ")
end
CaptionInsert(msg,msg.text,true)
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Text:"..msg.text) 
return sendMsg(msg.chat_id_,msg.id_,'تم ادراج الرد باقي '..CountRdod..'\n تم ادراج الرد ارسل رد اخر او ارسل {تم} ✓')
elseif msg.content_.ID == "MessagePhoto" then
if msg.content_.photo_.sizes_[3] then 
photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
else 
photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Photo:"..photo_id) 
CaptionInsert(msg,photo_id,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج صور للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageVoice" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Voice:"..msg.content_.voice_.voice_.persistent_id_) 
CaptionInsert(msg,msg.content_.voice_.voice_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج البصمه للرد باقي '..CountRdod..' ✓\n-  ارسل رد اخر او ارسل {تم}')
elseif msg.content_.ID == "MessageAnimation" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Animation:"..msg.content_.animation_.animation_.persistent_id_) 
CaptionInsert(msg,msg.content_.animation_.animation_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج المتحركه للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageVideo" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Video:"..msg.content_.video_.video_.persistent_id_) 
CaptionInsert(msg,msg.content_.video_.video_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الفيديو للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageAudio" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Audio:"..msg.content_.audio_.audio_.persistent_id_) 
CaptionInsert(msg,msg.content_.audio_.audio_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الصوت للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageDocument" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Document:"..msg.content_.document_.document_.persistent_id_) 
CaptionInsert(msg,msg.content_.document_.document_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الملف للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')  
elseif msg.content_.ID == "MessageSticker" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Sticker:"..msg.content_.sticker_.sticker_.persistent_id_) 
CaptionInsert(msg,msg.content_.sticker_.sticker_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الملصق للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
end  

end
--====================== End Reply Random Public =====================================
--====================== Reply Random Only Group =====================================
if redis:get(max..'addrdRandom:'..msg.chat_id_..msg.sender_user_id_) and redis:get(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_) then
klma = redis:get(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_)
msg.klma = klma
if msg.text == "تم" then
redis:del(max..'addrdRandom1:'..msg.chat_id_..msg.sender_user_id_)
redis:del(max..'addrdRandom:'..msg.chat_id_..msg.sender_user_id_)
sendMsg(msg.chat_id_,msg.id_,'- تم اضافه رد متعدد عشوائي بنجاح ✓\n- يمكنك ارسال (['..klma..']) لاضهار الردود العشوائيه .')
redis:del(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_)
return false
end

local CountRdod = redis:scard(max..':ReplayRandom:'..msg.chat_id_..":"..klma) or 1
local CountRdod2 = 10 - tonumber(CountRdod)
local CountRdod = 9 - tonumber(CountRdod)
if CountRdod2 == 0 then 
redis:del(max..'addrdRandom1:'..msg.chat_id_..msg.sender_user_id_)
redis:del(max..'addrdRandom:'..msg.chat_id_..msg.sender_user_id_)
sendMsg(msg.chat_id_,msg.id_,'- وصلت الحد الاقصى لعدد الردود ✓\n- تم اضافه الرد (['..klma..']) للردود العشوائيه .')
redis:del(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_)
return false
end
if msg.text then 
if utf8.len(msg.text) > 4000 then 
return sendMsg(msg.chat_id_,msg.id_,"- عذرا غير مسموح باضافه جواب الرد باكثر من 4000 حرف تم الغاء الامر\n")
end
CaptionInsert(msg,msg.text,false)
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Text:"..msg.text) 
return sendMsg(msg.chat_id_,msg.id_,'تم ادراج الرد باقي '..CountRdod..'\n تم ادراج الرد ارسل رد اخر او ارسل {تم} \n✓')
elseif msg.content_.ID == "MessagePhoto" then
if msg.content_.photo_.sizes_[3] then 
photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
else 
photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Photo:"..photo_id) 
CaptionInsert(msg,photo_id,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج صور للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageVoice" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Voice:"..msg.content_.voice_.voice_.persistent_id_) 
CaptionInsert(msg,msg.content_.voice_.voice_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج البصمه للرد باقي '..CountRdod..' ✓\n-  ارسل رد اخر او ارسل {تم}')
elseif msg.content_.ID == "MessageAnimation" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Animation:"..msg.content_.animation_.animation_.persistent_id_) 
CaptionInsert(msg,msg.content_.animation_.animation_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج المتحركه للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageVideo" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Video:"..msg.content_.video_.video_.persistent_id_) 
CaptionInsert(msg,msg.content_.video_.video_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الفيديو للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageAudio" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Audio:"..msg.content_.audio_.audio_.persistent_id_) 
CaptionInsert(msg,msg.content_.audio_.audio_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الصوت للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageDocument" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Document:"..msg.content_.document_.document_.persistent_id_) 
CaptionInsert(msg,msg.content_.document_.document_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الملف للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')  
elseif msg.content_.ID == "MessageSticker" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Sticker:"..msg.content_.sticker_.sticker_.persistent_id_) 
CaptionInsert(msg,msg.content_.sticker_.sticker_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الملصق للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
end  

end
--====================== End Reply Random Only Group =====================================

end

local function dbeso(msg)

--=============================================================================================================================
if msg.SudoUser and msg.text and redis:get(max..'addrdRandom1Public:'..msg.chat_id_..msg.sender_user_id_) then 
if not redis:get(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_) then  -- كلمه الرد
if utf8.len(msg.text) > 25 then return sendMsg(msg.chat_id_,msg.id_,"- عذرا غير مسموح باضافه كلمه الرد باكثر من 25 حرف ") end
redis:setex(max..'addrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_,1400,true) 
redis:setex(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_,1400,msg.text)
return sendMsg(msg.chat_id_,msg.id_,"- جيد , يمكنك الان ارسال جواب الرد المتعدد العام \n- [[ نص,صوره,فيديو,متحركه,بصمه,اغنيه,ملف ]] \n\n- علما ان الاختصارات كالاتي : \n \n- {الاسم} : لوضع اسم المستخدم\n- {الايدي} : لوضع ايدي المستخدم\n- {المعرف} : لوضع معرف المستخدم \n- {الرتبه} : لوضع نوع رتبه المستخدم \n- {التفاعل} : لوضع تفاعل المستخدم \n- {الرسائل} : لاضهار عدد الرسائل \n- {النقاط} : لاضهار عدد النقاط \n- {التعديل} : لاضهار عدد السحكات \n- {البوت} : لاضهار اسم البوت\n- {المطور} : لاضهار معرف المطور الاساسي\n- {الردود} : لاضهار ردود عشوائيه .\n\n- يمكنك اضافه 10 ردود متعدد كحد اقصى  \n➼")
end
end



if  msg.SudoUser and msg.text and redis:get(max..':DelrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_) then
redis:del(max..':DelrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_)
local DelRd = redis:del(max..':ReplayRandom:'..msg.text) 
if DelRd == 0 then 
return sendMsg(msg.chat_id_,msg.id_,'- هذا الرد ليس مضاف في الردود العشوائيه ')
end
redis:del(max..':caption_replay:Random:'..msg.text) 
redis:srem(max..':KlmatRRandom:',msg.text) 
return sendMsg(msg.chat_id_,msg.id_,'- تم حذف الرد بنجاح ✓')
end
--=============================================================================================================================


if not msg.GroupActive then return false end
if msg.text then

if redis:get(max..'addrdRandom1:'..msg.chat_id_..msg.sender_user_id_) then -- استقبال الرد للمجموعه فقط

if not redis:get(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_) then  -- كلمه الرد
if utf8.len(msg.text) > 25 then 
return sendMsg(msg.chat_id_,msg.id_,"- عذرا غير مسموح باضافه كلمه الرد باكثر من 25 حرف ")
end
redis:setex(max..'addrdRandom:'..msg.chat_id_..msg.sender_user_id_,1400,true) 
redis:setex(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_,1400,msg.text)
return sendMsg(msg.chat_id_,msg.id_,"- جيد , يمكنك الان ارسال جواب الرد المتعدد العام \n- [[ نص,صوره,فيديو,متحركه,بصمه,اغنيه,ملف ]] \n\n- علما ان الاختصارات كالاتي : \n \n- {الاسم} : لوضع اسم المستخدم\n- {الايدي} : لوضع ايدي المستخدم\n- {المعرف} : لوضع معرف المستخدم \n- {الرتبه} : لوضع نوع رتبه المستخدم \n- {التفاعل} : لوضع تفاعل المستخدم \n- {الرسائل} : لاضهار عدد الرسائل \n- {النقاط} : لاضهار عدد النقاط \n- {التعديل} : لاضهار عدد السحكات \n- {البوت} : لاضهار اسم البوت\n- {المطور} : لاضهار معرف المطور الاساسي\n- {الردود} : لاضهار ردود عشوائيه .\n\n- يمكنك اضافه 10 ردود متعدد كحد اقصى  \n➼")
end
end
end


    ------------------------------{ Start Replay Send }------------------------
function CaptionInsert(msg,input,public)
if msg.content_ and msg.content_.caption_ then 
if public then
redis:hset(max..':caption_replay:Random:'..msg.klma,input,msg.content_.caption_) 
else
redis:hset(max..':caption_replay:Random:'..msg.chat_id_..msg.klma,input,msg.content_.caption_) 
end
end
end
--====================== Reply Random Public =====================================
if redis:get(max..'addrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_) and redis:get(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_) then
klma = redis:get(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_)
msg.klma = klma
if msg.text == "تم" then
redis:del(max..'addrdRandom1Public:'..msg.chat_id_..msg.sender_user_id_)
redis:del(max..'addrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_)
sendMsg(msg.chat_id_,msg.id_,'- تم اضافه رد متعدد عشوائي بنجاح ✓\n- يمكنك ارسال (['..klma..']) لرؤية الردود العشوائيه .')
redis:del(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_)
return false
end

local CountRdod = redis:scard(max..':ReplayRandom:'..klma) or 1
local CountRdod2 = 10 - tonumber(CountRdod)
local CountRdod = 9 - tonumber(CountRdod)
if CountRdod2 == 0 then 
redis:del(max..'addrdRandom1Public:'..msg.chat_id_..msg.sender_user_id_)
redis:del(max..'addrdRandomPublic:'..msg.chat_id_..msg.sender_user_id_)
sendMsg(msg.chat_id_,msg.id_,'- وصلت الحد الاقصى لعدد الردود ✓\n- تم اضافه الرد (['..klma..']) للردود العشوائيه .')
redis:del(max..'replay1RandomPublic'..msg.chat_id_..msg.sender_user_id_)
return false
end
if msg.text then 
if utf8.len(msg.text) > 4000 then 
return sendMsg(msg.chat_id_,msg.id_,"- عذرا غير مسموح باضافه جواب الرد باكثر من 4000 حرف تم الغاء الامر ")
end
CaptionInsert(msg,msg.text,true)
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Text:"..msg.text) 
return sendMsg(msg.chat_id_,msg.id_,'تم ادراج الرد باقي '..CountRdod..'\n تم ادراج الرد ارسل رد اخر او ارسل {تم} ✓')
elseif msg.content_.ID == "MessagePhoto" then
if msg.content_.photo_.sizes_[3] then 
photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
else 
photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Photo:"..photo_id) 
CaptionInsert(msg,photo_id,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج صور للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageVoice" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Voice:"..msg.content_.voice_.voice_.persistent_id_) 
CaptionInsert(msg,msg.content_.voice_.voice_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج البصمه للرد باقي '..CountRdod..' ✓\n-  ارسل رد اخر او ارسل {تم}')
elseif msg.content_.ID == "MessageAnimation" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Animation:"..msg.content_.animation_.animation_.persistent_id_) 
CaptionInsert(msg,msg.content_.animation_.animation_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج المتحركه للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageVideo" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Video:"..msg.content_.video_.video_.persistent_id_) 
CaptionInsert(msg,msg.content_.video_.video_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الفيديو للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageAudio" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Audio:"..msg.content_.audio_.audio_.persistent_id_) 
CaptionInsert(msg,msg.content_.audio_.audio_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الصوت للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageDocument" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Document:"..msg.content_.document_.document_.persistent_id_) 
CaptionInsert(msg,msg.content_.document_.document_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الملف للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')  
elseif msg.content_.ID == "MessageSticker" then
redis:sadd(max..':KlmatRRandom:',klma) 
redis:sadd(max..':ReplayRandom:'..klma,":Sticker:"..msg.content_.sticker_.sticker_.persistent_id_) 
CaptionInsert(msg,msg.content_.sticker_.sticker_.persistent_id_,true)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الملصق للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
end  

end
--====================== End Reply Random Public =====================================
--====================== Reply Random Only Group =====================================
if redis:get(max..'addrdRandom:'..msg.chat_id_..msg.sender_user_id_) and redis:get(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_) then
klma = redis:get(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_)
msg.klma = klma
if msg.text == "تم" then
redis:del(max..'addrdRandom1:'..msg.chat_id_..msg.sender_user_id_)
redis:del(max..'addrdRandom:'..msg.chat_id_..msg.sender_user_id_)
sendMsg(msg.chat_id_,msg.id_,'- تم اضافه رد متعدد عشوائي بنجاح ✓\n- يمكنك ارسال (['..klma..']) لرؤية الردود العشوائيه .')
redis:del(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_)
return false
end

local CountRdod = redis:scard(max..':ReplayRandom:'..msg.chat_id_..":"..klma) or 1
local CountRdod2 = 10 - tonumber(CountRdod)
local CountRdod = 9 - tonumber(CountRdod)
if CountRdod2 == 0 then 
redis:del(max..'addrdRandom1:'..msg.chat_id_..msg.sender_user_id_)
redis:del(max..'addrdRandom:'..msg.chat_id_..msg.sender_user_id_)
sendMsg(msg.chat_id_,msg.id_,'- وصلت الحد الاقصى لعدد الردود ✓\n- تم اضافه الرد (['..klma..']) للردود العشوائيه .')
redis:del(max..'replay1Random'..msg.chat_id_..msg.sender_user_id_)
return false
end
if msg.text then 
if utf8.len(msg.text) > 4000 then 
return sendMsg(msg.chat_id_,msg.id_,"- عذرا غير مسموح باضافه جواب الرد باكثر من 4000 حرف تم الغاء الامر\n")
end
CaptionInsert(msg,msg.text,false)
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Text:"..msg.text) 
return sendMsg(msg.chat_id_,msg.id_,'تم ادراج الرد باقي '..CountRdod..'\n تم ادراج الرد ارسل رد اخر او ارسل {تم} \n✓')
elseif msg.content_.ID == "MessagePhoto" then
if msg.content_.photo_.sizes_[3] then 
photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
else 
photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Photo:"..photo_id) 
CaptionInsert(msg,photo_id,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج صور للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageVoice" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Voice:"..msg.content_.voice_.voice_.persistent_id_) 
CaptionInsert(msg,msg.content_.voice_.voice_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج البصمه للرد باقي '..CountRdod..' ✓\n-  ارسل رد اخر او ارسل {تم}')
elseif msg.content_.ID == "MessageAnimation" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Animation:"..msg.content_.animation_.animation_.persistent_id_) 
CaptionInsert(msg,msg.content_.animation_.animation_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج المتحركه للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageVideo" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Video:"..msg.content_.video_.video_.persistent_id_) 
CaptionInsert(msg,msg.content_.video_.video_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الفيديو للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageAudio" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Audio:"..msg.content_.audio_.audio_.persistent_id_) 
CaptionInsert(msg,msg.content_.audio_.audio_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الصوت للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
elseif msg.content_.ID == "MessageDocument" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Document:"..msg.content_.document_.document_.persistent_id_) 
CaptionInsert(msg,msg.content_.document_.document_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الملف للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')  
elseif msg.content_.ID == "MessageSticker" then
redis:sadd(max..':KlmatRRandom:'..msg.chat_id_,klma) 
redis:sadd(max..':ReplayRandom:'..msg.chat_id_..":"..klma,":Sticker:"..msg.content_.sticker_.sticker_.persistent_id_) 
CaptionInsert(msg,msg.content_.sticker_.sticker_.persistent_id_,false)
return sendMsg(msg.chat_id_,msg.id_,'- تم ادراج الملصق للرد باقي '..CountRdod..' ✓\n- ارسل رد اخر او ارسل {تم} .')
end  

end
--====================== End Reply Random Only Group =====================================


end

return {
max = {

"^(اضف رد عشوائي)$",
"^(مسح رد عشوائي)$",
"^(اضف رد عشوائي عام)$",
"^(مسح رد عشوائي عام)$",
"^(الردود العشوائيه)$",
"^(الردود العشوائيه العام)$",
"^(مسح الردود العشوائيه العامه)$",
"^(مسح الردود العشوائيه)$",
},
 imax = addrdod,
 dmax = dbeso,
 }
