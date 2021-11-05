--[[
Drok
--]]
local function games(msg,MsgText)
if msg.type ~= "pv" then
if MsgText[1] == "تفعيل" and MsgText[2] == "الالعاب" or MsgText[2] == "اللعبه" or MsgText[2] == "اللعبة" or MsgText[2] == "العاب بيسو" then
if not msg.Admin then return "-› هذا الامر يخص {الادمن,المدير,المنشئ,المطور} فقط  \n" end
if not redis:get(max..'lock_geams'..msg.chat_id_) then 
return "-› أهلا عزيزي "..msg.TheRankCmd.."\n- الالعاب بالتاكيد تم تفعيلها\n" 
else 
redis:del(max..'lock_geams'..msg.chat_id_) 
return "-› أهلا عزيزي "..msg.TheRankCmd.."\n- تم تفعيل الالعاب \n" 
end 
end
if MsgText[1] == "تعطيل" and MsgText[2] == "الالعاب" or MsgText[2] == "اللعبه" or MsgText[2] == "اللعبة" or MsgText[2] == "قائمة الالعاب" then
if not msg.Admin then return "-› هذا الامر يخص {الادمن,المدير,المنشئ,المطور} فقط  \n" end
if redis:get(max..'lock_geams'..msg.chat_id_) then 
return "-› أهلا عزيزي "..msg.TheRankCmd.."\n- الالعاب بالتأكيد معطله\n" 
else
redis:set(max..'lock_geams'..msg.chat_id_,true)  
return "-› أهلا عزيزي "..msg.TheRankCmd.."\n- تم تعطيل الالعاب\n" 
end   
end
if MsgText[1] == "اضف رسائل" and msg.reply_to_message_id_ == 0 then       
if not msg.Creator then 
return "-› هذا الامر يخص {المطور,المنشئ} فقط  \n" 
end 
local ID_USER = MsgText[2]
redis:set(max..'SET:ID:USER'..msg.chat_id_,ID_USER)  
redis:setex(max.."SETEX:MSG"..msg.chat_id_..""..msg.sender_user_id_,500,true)  
sendMsg(msg.chat_id_,msg.id_,'-› ارسل لي عدد الرسائل الذي تريده')
end
if MsgText[1] == "اضف نقاط" and msg.reply_to_message_id_ == 0 then       
if not msg.Creator then 
return "-› هذا الامر يخص {المطور,المنشئ} فقط  \n" 
end 
local ID_USER = MsgText[2]
redis:set(max..'SET:ID:USER:NUM'..msg.chat_id_,ID_USER)  
redis:setex(max.."SETEX:NUM"..msg.chat_id_..""..msg.sender_user_id_,500,true)  
sendMsg(msg.chat_id_,msg.id_,'-› ارسل لي عدد النقاط الذي تريده')
end
if not redis:get(max..'lock_geams'..msg.chat_id_) and msg.GroupActive then



-------- مقالات -------

if MsgText[1] == "مقالات" then
local Time = os.time()
local G = { "،","?","&" }
local GT = G[math.random(#G)]
local M = {""}
local MG1 = M[math.random(#M)]
local MG = MG1:gsub("[-?&]", { ["-"] = " ",["&"] = " ",["?"] = " "} )


redis:set(max.."MG"..msg.chat_id_,MG)
redis:set(max.."MGTime"..msg.chat_id_,Time)

sendMsg(msg.chat_id_,msg.id_,MG1)
end

if (MsgText[1] == redis:get(max.."MG"..msg.chat_id_) )then 
local time = os.time() - redis:get(max.."MGTime"..msg.chat_id_)
if time < 20 then
local list_win = {"صح علييك !","قووه قووه","محد ينافسك !", "يا أسططووووررره !!" }
local win = list_win[math.random(#list_win)]
sendMsg(msg.chat_id_,msg.id_, " - "..win.." \n - *[ "..time.." ]* ثانية . ")
elseif time < 30 then
local list_win = {"صح علييك !","قووي","ياعيني "}
local win = list_win[math.random(#list_win)]
sendMsg(msg.chat_id_,msg.id_, " - "..win.." \n - *[ "..time.." ]* ثانية . ")
elseif time < 40 then
local list_win = {"شد شد","يجي منك"}
local win = list_win[math.random(#list_win)]
sendMsg(msg.chat_id_,msg.id_, " - "..win.." \n - *[ "..time.." ]* ثانية . ")
else 
local list_win = {"مستوى مستوى","ماش","بدري"}
local win = list_win[math.random(#list_win)]
sendMsg(msg.chat_id_,msg.id_, " - "..win.." \n - *[ "..time.." ]* ثانية . ")
end
end

-------- نهاية المقالات -----



if MsgText[1] == 'نقاطي' then 
local points = redis:get(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_)
if points and points ~= "0" then
return '-› عدد النقاط التي ربحتها هي › { '..points..' }\n- تسطيع بيع نقاطك ولحصول على (250) رساله مقابل كل نقطه من النقاط\n'
else
return '-› ليس لديك نقاط\n- أكتب الالعاب وأكسب نقاط'
end
end
if MsgText[1] == 'بيع نقاطي' then
if MsgText[2] == "0" then
return '-› عذرًا يجب أن يكون لديك على الاقل نقطة واحدة'
end
local points = redis:get(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_)
if tonumber(MsgText[2]) > tonumber(points) then
return '-› عذرًا لا تمتلك نقاط بهذا العدد' 
end
if points == "0" then
return '-› ليس لديك نقاط\n- أكتب الالعاب وأكسب نقاط'
else
local Total_Point = MsgText[2] * 250
redis:decrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,MsgText[2])  
redis:incrby(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_,Total_Point)  
return "-› تم خصم {* "..MsgText[2].." *} من نقاطك\n-› تم زياده {* "..Total_Point.."* } من الرسائل \n-› اصبحت رسائلك { *"..redis:get(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_).."* } رساله"
end
end
if MsgText[1] == 'مسح رسائلي' then
if MsgText[2] == "0" then
return '-› عذرًا يجب مسح رسالة واحد على الاقل'
end
local messages = redis:get(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_)
if tonumber(MsgText[2]) > tonumber(messages) then
return '-› عذرًا لا تمتلك رسائل بهذا العدد' 
end
if messages == "0" then
return '-› عذرًا يجب مسح رسالة واحد على الاقل'
else
redis:decrby(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_,MsgText[2] )  
return "-› تم مسح {* "..MsgText[2].." *} من رسائلك"
end
end
if MsgText[1] == 'المختلف' then
katu = {'😸','☠','🐼','🐇','🌑','🌚','⭐️','✨','⛈','🌥','⛄️','👨‍🔬','👨‍💻','👨‍🔧','👩‍🍳','🧚‍♀','🧜‍♂','🧝‍♂','🙍‍♂','🧖‍♂','👬','👨‍👨‍👧','🕓','🕤','⌛️','📅',
};
name = katu[math.random(#katu)]
redis:set(max..':Set_alii:'..msg.chat_id_,name)
name = string.gsub(name,'😸','😹😹😹😹😹😹😹😹😸😹😹😹😹')
name = string.gsub(name,'☠','💀💀💀💀💀💀💀☠💀💀💀💀💀')
name = string.gsub(name,'🐼','👻👻👻👻👻👻👻🐼👻👻👻👻👻')
name = string.gsub(name,'🐇','🕊🕊🕊🕊🕊🐇🕊🕊🕊🕊')
name = string.gsub(name,'🌑','🌚🌚🌚🌚🌚🌑🌚🌚🌚')
name = string.gsub(name,'🌚','🌑🌑🌑🌑🌑🌚🌑🌑🌑')
name = string.gsub(name,'⭐️','🌟🌟🌟🌟🌟🌟🌟🌟⭐️🌟🌟🌟')
name = string.gsub(name,'✨','💫💫💫💫💫✨💫💫💫💫')
name = string.gsub(name,'⛈','🌨🌨🌨🌨🌨⛈🌨🌨🌨🌨')
name = string.gsub(name,'🌥','⛅️⛅️⛅️⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️')
name = string.gsub(name,'⛄️','☃☃☃☃☃☃⛄️☃☃☃☃')
name = string.gsub(name,'👨‍🔬','👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍🔬👩‍🔬👩‍🔬👩‍🔬')
name = string.gsub(name,'👨‍💻','👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👩‍💻👨‍💻👩‍💻👩‍💻👩‍💻')
name = string.gsub(name,'👨‍🔧','👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧')
name = string.gsub(name,'👩‍🍳','👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳👩‍🍳👨‍🍳👨‍🍳👨‍🍳')
name = string.gsub(name,'🧚‍♀','🧚‍♂🧚‍♂🧚‍♂🧚‍♂🧚‍♀🧚‍♂🧚‍♂')
name = string.gsub(name,'🧜‍♂','🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧜‍♂🧜‍♀🧜‍♀🧜‍♀')
name = string.gsub(name,'🧝‍♂','🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♂🧝‍♀🧝‍♀🧝‍♀')
name = string.gsub(name,'🙍‍♂','🙎‍♂🙎‍♂🙎‍♂🙎‍♂🙎‍♂🙍‍♂🙎‍♂🙎‍♂🙎‍♂')
name = string.gsub(name,'🧖‍♂','🧖‍♀🧖‍♀🧖‍♀🧖‍♀🧖‍♀🧖‍♂🧖‍♀🧖‍♀🧖‍♀🧖‍♀')
name = string.gsub(name,'👬','👭👭👭👭👭👬👭👭👭')
name = string.gsub(name,'👨‍👨‍👧','👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👧👨‍👨‍👦👨‍👨‍👦')
name = string.gsub(name,'🕓','🕒🕒🕒🕒🕒🕒🕓🕒🕒🕒')
name = string.gsub(name,'🕤','🕥🕥🕥🕥🕥🕤🕥🕥🕥')
name = string.gsub(name,'⌛️','⏳⏳⏳⏳⏳⏳⌛️⏳⏳')
name = string.gsub(name,'📅','📆📆📆📆📆📆📅📆📆')
return 'اول واحد يطلع المختلف » {* '..name..' * } ' 
end

if MsgText[1] == 'امثله' then
katu = {
'قردة','صدى','ذانك','الارض','عبها','تحلف','صديقك','قبل','مليح','السن','خصمك','ومرعى','من','اخو','يعلم','واليد','دهر','بيوم','بطل','تستحي',
};
name = katu[math.random(#katu)]
redis:set(max..':Set_Amthlh:'..msg.chat_id_,name)
name = string.gsub(name,'قردة','جوا الدار .... وبرا الدار وردة')
name = string.gsub(name,'صدى','في قلبي ... ما بحبش حدى')
name = string.gsub(name,'اذانك','وين .... يا جحا')
name = string.gsub(name,'الارض','الطويل في السما نجمة والقصير في .... فجلة')
name = string.gsub(name,'عبها','بتحط في .... وبتف من فمها')
name = string.gsub(name,'تحلف','صار للشرشوحة مرجوحة وصارت .... بالطلاق')
name = string.gsub(name,'صديقك','خاف من عدوك مرة ومن .... ألف مرة')
name = string.gsub(name,'قبل','الجار .... الدار')
name = string.gsub(name,'السن','إخلع .... وإخلع الوجع')
name = string.gsub(name,'خصمك','اذا .... القاضي فَمن تُقاضي')
name = string.gsub(name,'مليح','سيدي .... زاده الهوى والريح')
name = string.gsub(name,'ومرعى','أكل .... وقلة صنعه')
name = string.gsub(name,'من','الجود .... الموجود')
name = string.gsub(name,'اخو','الزايد .... الناقص')
name = string.gsub(name,'يعلم','المال السايب .... الناس الحرام')
name = string.gsub(name,'واليد','العين بصيرة .... قصيرة')
name = string.gsub(name,'دهر','أعزب .... ولا ارمل شهر')
name = string.gsub(name,'بيوم','اكبر منك .... اعلم منك بسنه')
name = string.gsub(name,'بطل','أذا عرف السبب .... العجب')
name = string.gsub(name,'تستحي','إذا لم .... فافعل ماتشتهي')
return 'اكمل المثل التالي » {* '..name..' *}'
end

if MsgText[1] == 'انقليزي' or MsgText[1] == 'انجليزي' then
  katu = {
  'مرحباً','صباح الخير','مساء الخير','تصبح على خير','مع السلامة','أراك فيما بعد','سررت بلقائك','تشرفت بلقائك','أهلاً وسهلاً','ما اسمك','تفضل بالجلوس','شكراً','هل ترغب بمرافقتي','ما رأيك في أن نقوم بنزهة','سيراً على الأقدام','لنذهب للسباحه','حقيقه','صندوق','يد','شجاع','هادئ','حذر','مرح','ذكي','جبان','مجنون','عاطفي','ودود','مضحك','كريم','صادق','غير صبور','غير مهذب','حنون','كسول','حقير','مريض',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_Amthlh:'..msg.chat_id_,name)
  name = string.gsub(name,'مرحبا','Hello')
  name = string.gsub(name,'صباح الخير','Good morning')
  name = string.gsub(name,'مساء الخير','Good evening')
  name = string.gsub(name,'تصبح على خير','Good night')
  name = string.gsub(name,'مع السلامة','Goodbye')
  name = string.gsub(name,'أراك فيما بعد','See you later')
  name = string.gsub(name,'سررت بلقائك','Nice to meet you')
  name = string.gsub(name,'تشرفت بلقائك','Honored to meet you')
  name = string.gsub(name,'أهلاً وسهلاً','Welcome')
  name = string.gsub(name,'ما اسمك','What is your name')
  name = string.gsub(name,'تفضل بالجلوس','Have a seat')
  name = string.gsub(name,'شكراً','Thank you')
  name = string.gsub(name,'هل ترغب بمرافقتي','Would you like to come with me')
  name = string.gsub(name,'ما رأيك في أن نقوم بنزهة','How about having a picnic')
  name = string.gsub(name,'سيراً على الأقدام','On foot')
  name = string.gsub(name,'لنذهب للسباحه','Let us go swimming')
  name = string.gsub(name,'حقيقه','Truth')
  name = string.gsub(name,'صندوق','Box')
  name = string.gsub(name,'يد','Hand')
  name = string.gsub(name,'شجاع','Brave')
  name = string.gsub(name,'هادئ','Calm')
  name = string.gsub(name,'حذر','Cautious')
  name = string.gsub(name,'مرح','Cheerful')
  name = string.gsub(name,'ذكي','Clever')
  name = string.gsub(name,'جبان','Cowardly')
  name = string.gsub(name,'مجنون','Crazy')
  name = string.gsub(name,'عاطفي','Emotional')
  name = string.gsub(name,'ودود','Friendly')
  name = string.gsub(name,'مضحك','Funny')
  name = string.gsub(name,'كريم','Generous')
  name = string.gsub(name,'صادق','Honest')
  name = string.gsub(name,'غير صبور','Impatient')
  name = string.gsub(name,'غير مهذب','Impolite')
  name = string.gsub(name,'حنون','Kind')
  name = string.gsub(name,'كسول','Lazy')
  name = string.gsub(name,'حقير','Mean')
  name = string.gsub(name,'مريض','Patient')
  return 'اجب على معنى الكلمة » {* '..name..' *}'
  end

if MsgText[1] == 'علم' or MsgText[1] == 'اعلام' then
  katu = {
  'السعودية','اليمن','الكويت','البحرين','قطر','عمان','العراق','فلسطين','الجزائر','السودان','السويد','البرازيل','امريكا','كوريا الجنوبية','كوريا الشمالية','مصر','الامارات','الاردن','روسيا','تركيا','المغرب','سوريا','الصومال','تونس','ليبيا','فرنسا','جورجيا','اليونان','افغانستان','اندونيسيا','الارجنتين','المانيا','الهند','استراليا','النمسا','بلجيكا','كندا',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_Amthlh:'..msg.chat_id_,name)
  name = string.gsub(name,'السعودية','🇸🇦')
  name = string.gsub(name,'اليمن','🇾🇪')
  name = string.gsub(name,'الكويت','🇰🇼')
  name = string.gsub(name,'البحرين','🇧🇭')
  name = string.gsub(name,'قطر','🇶🇦')
  name = string.gsub(name,'عمان','🇴🇲')
  name = string.gsub(name,'العراق','🇮🇶')
  name = string.gsub(name,'فلسطين','🇵🇸')
  name = string.gsub(name,'الجزائر','🇩🇿')
  name = string.gsub(name,'السودان','🇸🇩')
  name = string.gsub(name,'السويد','🇸🇪')
  name = string.gsub(name,'البرازيل','🇧🇷')
  name = string.gsub(name,'امريكا','🇺🇸')
  name = string.gsub(name,'كوريا الجنوبية','🇰🇷')
  name = string.gsub(name,'كوريا الشمالية','🇰🇵')
  name = string.gsub(name,'مصر','🇪🇬')
  name = string.gsub(name,'الامارات','🇦🇪')
  name = string.gsub(name,'الاردن','🇯🇴')
  name = string.gsub(name,'روسيا','🇷🇺')
  name = string.gsub(name,'تركيا','🇹🇷')
  name = string.gsub(name,'المغرب','🇲🇦')
  name = string.gsub(name,'سوريا','🇸🇾')
  name = string.gsub(name,'الصومال','🇸🇴')
  name = string.gsub(name,'تونس','🇹🇳')
  name = string.gsub(name,'ليبيا','🇱🇾')
  name = string.gsub(name,'فرنسا','🇫🇷')
  name = string.gsub(name,'جورجيا','🇬🇪')
  name = string.gsub(name,'اليونان','🇬🇷')
  name = string.gsub(name,'افغانستان','🇦🇫')
  name = string.gsub(name,'اندونيسيا','🇮🇩')
  name = string.gsub(name,'الارجنتين','🇦🇷')
  name = string.gsub(name,'المانيا','🇩🇪')
  name = string.gsub(name,'الهند','🇮🇳')
  name = string.gsub(name,'استراليا','🇦🇺')
  name = string.gsub(name,'النمسا','🇦🇹')
  name = string.gsub(name,'بلجيكا','🇧🇪')
  name = string.gsub(name,'كندا','🇨🇦')
  return 'أسرع واحد يقول علم أيش » {* '..name..' *}'
  end

if MsgText[1] == 'كلمة وضدها' or MsgText[1] == 'كلمه وضدها' then
  katu = {
'الإيمان','التصديق','الرجاء','العدل','الرضاء','الشكر','الطمع','التوكل','الرأفة','الرحمة','العلم','الفهم','العفة','الزهد','الرفق','الرهبة','التواضع','التؤدة','الحلم','الصمت','الاستسلام','التسليم','الصبر','الصفح','الغنى','التذكر','الحفظ','التعطف','القنوع','المواساة','المودة','الوفاء','الطاعة','الغضوع','السلامة','الحب','الصدق','الحق','الامانة','الإخلاص','الشهامة','الذكاء','المعرفة','المداراة','الكتمان','الصلاة','الصوم','الجهاد','الحقيقة','المعروف','الستر','التقية','الإنصاف','التهيئة','النظافة','الحياء','القصد','الراحة','السهولة',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_Amthlh:'..msg.chat_id_,name)
  name = string.gsub(name,'الإيمان','الكفر')
  name = string.gsub(name,'التصديق','الجحود')
  name = string.gsub(name,'الرجاء','القنوط')
  name = string.gsub(name,'العدل','الجور')
  name = string.gsub(name,'الرضا','السخط')
  name = string.gsub(name,'الشكر','الكفران')
  name = string.gsub(name,'الطمع','اليأس')
  name = string.gsub(name,'التوكل','الحرص')
  name = string.gsub(name,'الرأفة','القسوة')
  name = string.gsub(name,'الرحمة','الغضب')
  name = string.gsub(name,'العلم','الجهل')
  name = string.gsub(name,'الفهم','الحمق')
  name = string.gsub(name,'العفة','التهتك')
  name = string.gsub(name,'الزهد','الرغبة')
  name = string.gsub(name,'الرفق','الخرق')
  name = string.gsub(name,'الرهبة','الجرأة')
  name = string.gsub(name,'التواضع','الكبر')
  name = string.gsub(name,'التؤدة','التسرع')
  name = string.gsub(name,'الحلم','السفه')
  name = string.gsub(name,'الصمت','الهذر')
  name = string.gsub(name,'الاستسلام','الاستكبار')
  name = string.gsub(name,'التسليم','الشك')
  name = string.gsub(name,'الصبر','الجزع')
  name = string.gsub(name,'الصفح','الانتقام')
  name = string.gsub(name,'الغنى','الفقر')
  name = string.gsub(name,'التذكر','السهو')
  name = string.gsub(name,'الحفظ','النسيان')
  name = string.gsub(name,'التعطف','القطيعة')
  name = string.gsub(name,'القنوع','الحرص')
  name = string.gsub(name,'المواساة','المنع')
  name = string.gsub(name,'المودة','العداوة')
  name = string.gsub(name,'الوفاء','الغدر')
  name = string.gsub(name,'الطاعة','المعصية')
  name = string.gsub(name,'الخضوع','التطاول')
  name = string.gsub(name,'السلامة','البلاء')
  name = string.gsub(name,'الحب','البغض')
  name = string.gsub(name,'الصدق','الكذب')
  name = string.gsub(name,'الحق','الباطل')
  name = string.gsub(name,'الامانة','الخيانة')
  name = string.gsub(name,'الإخلاص','الشوب')
  name = string.gsub(name,'الشهامة','البلادة')
  name = string.gsub(name,'الذكاء','الغباوة')
  name = string.gsub(name,'المعرفة','الانكار')
  name = string.gsub(name,'المداراة','المكاشفة')
  name = string.gsub(name,'الكتمان','الافشاء')
  name = string.gsub(name,'الصلاة','الإطاعة')
  name = string.gsub(name,'الصوم','الإفطار')
  name = string.gsub(name,'الجهد','النكول')
  name = string.gsub(name,'الحقيقة','الرياء')
  name = string.gsub(name,'المعروف','المنكر')
  name = string.gsub(name,'الستر','التبرج')
  name = string.gsub(name,'التقية','الإذاعة')
  name = string.gsub(name,'الإنصاف','الحمية')
  name = string.gsub(name,'التهيئة','البغي')
  name = string.gsub(name,'النظافة','القذر')
  name = string.gsub(name,'الحياء','الخلع')
  name = string.gsub(name,'القصد','العدوان')
  name = string.gsub(name,'الراحة','التعب')
  name = string.gsub(name,'السهولة','الصعوبة')
  return 'ضد كلمة » {* '..name..' *}'
  end

if MsgText[1] == 'دول' or MsgText[1] == 'الدول' then
  katu = {
  '🇸🇦','🇾🇪','🇰🇼','🇧🇭','🇶🇦','🇴🇲','🇮🇶','🇵🇸','🇩🇿','🇸🇩','🇸🇪','🇧🇷','🇺🇸','🇰🇷','🇰🇵','🇪🇬','🇦🇪','🇯🇴','🇷🇺','🇹🇷','🇲🇦','🇸🇾','🇸🇴','🇹🇳','🇱🇾','🇫🇷','🇬🇪','🇬🇷','🇦🇫','🇮🇩','🇦🇷','🇩🇪','🇮🇳','🇦🇺','🇦🇹','🇧🇪','🇨🇦',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_Amthlh:'..msg.chat_id_,name)
  name = string.gsub(name,'🇸🇦','السعودية')
  name = string.gsub(name,'🇾🇪','اليمن')
  name = string.gsub(name,'🇰🇼','الكويت')
  name = string.gsub(name,'🇧🇭','البحرين')
  name = string.gsub(name,'🇶🇦','قطر')
  name = string.gsub(name,'🇴🇲','عمان')
  name = string.gsub(name,'🇮🇶','العراق')
  name = string.gsub(name,'🇵🇸','فلسطين')
  name = string.gsub(name,'🇩🇿','الجزائر')
  name = string.gsub(name,'🇸🇩','السودان')
  name = string.gsub(name,'🇸🇪','السويد')
  name = string.gsub(name,'🇧🇷','البرازيل')
  name = string.gsub(name,'🇺🇸','امريكا')
  name = string.gsub(name,'🇰🇷','كوريا الجنوبية')
  name = string.gsub(name,'🇰🇵','كوريا الشمالية')
  name = string.gsub(name,'🇪🇬','مصر')
  name = string.gsub(name,'🇦🇪','الامارات')
  name = string.gsub(name,'🇯🇴','الاردن')
  name = string.gsub(name,'🇷🇺','روسيا')
  name = string.gsub(name,'🇹🇷','تركيا')
  name = string.gsub(name,'🇲🇦','المغرب')
  name = string.gsub(name,'🇸🇾','سوريا')
  name = string.gsub(name,'🇸🇴','الصومال')
  name = string.gsub(name,'🇹🇳','تونس')
  name = string.gsub(name,'🇱🇾','ليبيا')
  name = string.gsub(name,'🇫🇷','فرنسا')
  name = string.gsub(name,'🇬🇪','جورجيا')
  name = string.gsub(name,'🇬🇷','اليونان')
  name = string.gsub(name,'🇦🇫','افغانستان')
  name = string.gsub(name,'🇮🇩','اندونيسيا')
  name = string.gsub(name,'🇦🇷','الارجنتين')
  name = string.gsub(name,'🇩🇪','المانيا')
  name = string.gsub(name,'🇮🇳','الهند')
  name = string.gsub(name,'🇦🇺','استراليا')
  name = string.gsub(name,'🇦🇹','النمسا')
  name = string.gsub(name,'🇧🇪','بلجيكا')
  name = string.gsub(name,'🇨🇦','كندا')
  return 'أسرع واحد يرسل علم » {* '..name..' *}'
  end

if MsgText[1] == 'أسم مغني' or MsgText[1] == 'اسم مغني' or MsgText[1] == 'أسماء مغنين' or MsgText[1] == 'اسماء مغنين' then
  katu = {
'عبدالمجيد عبدالله','اصاله نصري','عبادي جوهر','طلال مداح','ادهم نابلسي','محمد عبده','يزن السقاف','حسين الجسمي','راشد الماجد','فضل شاكر','عباس ابراهيم','اليسا','رامي عياش','وائل جسار','يسرا محنوش','تامر حسني','ماجد المهندس','فضل شاكر','شيرين عبدالوهاب','راشد الماجد','أدهم نابلسي','عمرو دياب','حسين الجسمي','عبدالمجيد عبدالله','علي كاكولي','راشد الماجد','فضل شاكر','فيروز','محمد منير','جوزيف صقر','سعد لمجرد','رامي عياش','حماقي','روبي','حمزه نمره','محمد السالم','فيروز',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_Amthlh:'..msg.chat_id_,name)
  name = string.gsub(name,'عبدالمجيد عبدالله','حبيبي الي سكن بالعين')
  name = string.gsub(name,'فضل شاكر','فين لياليك')
  name = string.gsub(name,'راشد الماجد','حسك وجودي')
  name = string.gsub(name,'حسين الجسمي','بلغ حبيبك')
  name = string.gsub(name,'يزن السقاف','ماتخيلت')
  name = string.gsub(name,'محمد عبده','مشكلتنا')
  name = string.gsub(name,'ادهم نابلسي','خايف')
  name = string.gsub(name,'طلال مداح','حبك سابني')
  name = string.gsub(name,'عبادي جوهر','ياتاج راسي')
  name = string.gsub(name,'اصاله نصري','لحظات اللقى')
  name = string.gsub(name,'شيرين عبدالوهاب','كدابين')
  name = string.gsub(name,'فضل شاكر','ياغايب ليه ماتسال')
  name = string.gsub(name,'ماجد المهندس','واحش الدنيا')
  name = string.gsub(name,'تامر حسني','كل حاجه بينا')
  name = string.gsub(name,'يسرا محنوش','بفكر فيك')
  name = string.gsub(name,'وائل جسار','جرح الماضي')
  name = string.gsub(name,'رامي عياش','قصة حب')
  name = string.gsub(name,'اليسا','حب كل حياتي')
  name = string.gsub(name,'عباس ابراهيم','امنتك الله')
  name = string.gsub(name,'فضل شاكر','يادنيا كفايه خيانه')
  name = string.gsub(name,'راشد الماجد','كان يامكان')
  name = string.gsub(name,'علي كاكولي','النفخه الكدابة')
  name = string.gsub(name,'عبدالمجيد عبدالله','قنوع')
  name = string.gsub(name,'حسين الجسمي','بالبنط العريض')
  name = string.gsub(name,'عمرو دياب','أماكن السهر')
  name = string.gsub(name,'أدهم نابلسي','حان الآن')
  name = string.gsub(name,'راشد الماجد','ولهان')
  name = string.gsub(name,'محمد السالم','أغار أغار')
  name = string.gsub(name,'حمزه نمره','فاضي شويه')
  name = string.gsub(name,'روبي','حته تانيه')
  name = string.gsub(name,'حماقي','حياتك في صوره')
  name = string.gsub(name,'رامي عياش','دقي يا مزيكا')
  name = string.gsub(name,'سعد لمجرد','عدى الكلام')
  name = string.gsub(name,'جوزيف صقر','سهرنا يا ابو الاحباب')
  name = string.gsub(name,'محمد منير','حدوته مصريه')
  name = string.gsub(name,'فيروز','المسيح قام')
  name = string.gsub(name,'فيروز','نسم علينا الهوى')
  return 'مين صاحب أغنية » {* '..name..' *}'
  end

if MsgText[1] == 'تركيب' then
  katu = { 
  'مروحه','باب','الافضل','جدار','طيران','ورده','جيد','سيء','اريد','غريب','خطير','يهتم','حفظ','بطه','بطوط','ثقه','حقيقه','صندوق','‎‎القسطنطينية','شجاع','هادئ','حذر','مرح','ذكي','جبان','مجنون','عاطفي','ودود','مضحك','كريم','صادق','نيويورك','سناب','حنون','كسول','حقير','مريض',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_Amthlh:'..msg.chat_id_,name)
  name = string.gsub(name,'مروحه','م ر و ح ه')
  name = string.gsub(name,'باب','ب ا ب')
  name = string.gsub(name,'الافضل','ا ل ا ف ض ل')
  name = string.gsub(name,'جدار','ج د ا ر')
  name = string.gsub(name,'طيران','ط ي ر ا ن')
  name = string.gsub(name,'ورده','و ر د ه')
  name = string.gsub(name,'جيد','ج ي د')
  name = string.gsub(name,'سيء','س ي ء')
  name = string.gsub(name,'اريد','ا ر ي د')
  name = string.gsub(name,'غريب','غ ر ي ب')
  name = string.gsub(name,'خطير','خ ط ي ر')
  name = string.gsub(name,'يهتم','ي ه ت م')
  name = string.gsub(name,'حفظ','ح ف ظ')
  name = string.gsub(name,'بطه','ب ط ه')
  name = string.gsub(name,'بطوط','ب ط و ط')
  name = string.gsub(name,'ثقه','ث ق ه')
  name = string.gsub(name,'حقيقه','ح ق ي ق ه')
  name = string.gsub(name,'صندوق','ص ن د و ق')
  name = string.gsub(name,'القسطنطينية','ا ل ق س ط ن ط ي ن ي ة')
  name = string.gsub(name,'شجاع','ش ج ا ع')
  name = string.gsub(name,'هادئ','ه ا د ئ')
  name = string.gsub(name,'حذر','ح ذ ر')
  name = string.gsub(name,'مرح','م ر ح')
  name = string.gsub(name,'ذكي','ذ ك ي')
  name = string.gsub(name,'جبان','ج ب ا ن')
  name = string.gsub(name,'مجنون','م ج ن و ن')
  name = string.gsub(name,'عاطفي','ع ا ط ف ي')
  name = string.gsub(name,'ودود','و د و د')
  name = string.gsub(name,'مضحك','م ض ح ك')
  name = string.gsub(name,'كريم','ك ر ي م')
  name = string.gsub(name,'صادق','ص ا د ق')
  name = string.gsub(name,'نيويورك','ن ي و ي و ر ك')
  name = string.gsub(name,'سناب','س ن ا ب')
  name = string.gsub(name,'حنون','ح ن و ن')
  name = string.gsub(name,'كسول','ك س و ل')
  name = string.gsub(name,'حقير','ح ق ي ر')
  name = string.gsub(name,'مريض','م ر ي ض')
  return 'اسرع واحد يركب » {* '..name..' *}'
  end
  
if MsgText[1] == 'تفكيك' then
  katu = {
  'ا ح ب ك','ر م ة','ذ ئ ب','ب ع ي ر','ط ي ر','و ر د ه','ج م ي ل ','ح ل و','ب ط ر ي ق','ط م ا ط م','م و ز','س ي ا ر ة','ت ح ر ي ك','ف ل و س','ب و ت','ث ق ة','ح ل ز و ن','م ك ي ف','م ر و ح ه','ز ق','ب ل و ت و ث','ب ي س و','ب ا ع و ص','خ ش ن','ع ن ي ف','س ب ي ك ه','ه ط ف','ش م س','م ق ا ل','ق ا ت ل','د و ل ا ر','م ل ص ق ا ت','m y t h','d e v','t e l e g r a m','b e s o','ت س ط ي ر ر','تفكيك',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_Amthlh:'..msg.chat_id_,name)
  name = string.gsub(name,'احبك','ا ح ب ك')
  name = string.gsub(name,'ا ك ر ه ك','اكرهك')
  name = string.gsub(name,'ذ ئ ب','ذئب')
  name = string.gsub(name,'ب ع ي ر','بعير')
  name = string.gsub(name,'ط ي ر','طير')
  name = string.gsub(name,'و ر د ه','ورده')
  name = string.gsub(name,'ج م ي ل','جميل')
  name = string.gsub(name,'ح ل و','حلو')
  name = string.gsub(name,'ب ط ر ي ق','بطريق')
  name = string.gsub(name,'ط م ا ط م','طماطم')
  name = string.gsub(name,'م و ز','موز')
  name = string.gsub(name,'س ي ا ر ة','سيارة')
  name = string.gsub(name,'ت ح ر ي ك','تحريك')
  name = string.gsub(name,'ف ل و س','فلوس')
  name = string.gsub(name,'ب و ت','بوت')
  name = string.gsub(name,'ث ق ة','ثقة')
  name = string.gsub(name,'ح ل ز و ن','حلزون')
  name = string.gsub(name,'م ك ي ف','مكيف')
  name = string.gsub(name,'م ر و ح ه','مروحه')
  name = string.gsub(name,'ز ق','زق')
  name = string.gsub(name,'ب ل و ت و ث','بلوتوث')
  name = string.gsub(name,'ب ا ع و ص','باعوص')
  name = string.gsub(name,'ب ي س و','بيسو')
  name = string.gsub(name,'خ ش ن','خشن')
  name = string.gsub(name,'ع ن ي ف','عنيف')
  name = string.gsub(name,'س ب ي ك ه','سبيكه')
  name = string.gsub(name,'ه ط ف','هطف')
  name = string.gsub(name,'ش م س','شمس')
  name = string.gsub(name,'م ق ا ل','مقال')
  name = string.gsub(name,'ق ا ت ل','قاتل')
  name = string.gsub(name,'م ل ص ق ا ت','ملصقات')
  name = string.gsub(name,'د و ل ا ر','دولار')
  name = string.gsub(name,'m y t h','myth')
  name = string.gsub(name,'d e v','dev')
  name = string.gsub(name,'t e l e g r a m','telegram')
  name = string.gsub(name,'b e s o','b e s o')
  name = string.gsub(name,'ت س ط ي ر ر','تسطيرر')
  name = string.gsub(name,'ت ف ك ي ك','تفكيك')
  name = string.gsub(name,'ر م ة','رمة')
  return 'اسرع واحد يفكك » {* '..name..' *}'
  end

if MsgText[1] == 'الالغاز' or MsgText[1] == 'لغز' then
  katu = {
  'القاف','اسمك','الساعه','البحر','نجم','الحفرة','المشط','الثلج','الذكريات','البوصلة','البطريق','البحر','الفلفل','الاخلاق','السيارة','غلط','كوكب الارض','ادم وحواء','عطار',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_lgz:'..msg.chat_id_,name)
  name = string.gsub(name,'القاف','في كل قرن تجد مني واحدة، وفي كل دقيقة تجد مني اثنتين، وفي كل ساعة لا تجدني أبدًا… فمن أكون؟')
  name = string.gsub(name,'اسمك','أنا ملكك أنت، ولكن جميع الناس تستخدمني دون إذن منك، فمن أكون؟')
  name = string.gsub(name,'الساعه','أنا لا أتكلم إلا إني حينما أشبع أنطق دائمًا بالصدق، ولكني عندما أجوع أنطق كذبًا، فمن أكون؟')
  name = string.gsub(name,'البحر','أنا قادر على حمل أثقل الأشياء، ولكنني لا أستطيع أن أحمل مسمار، فمن أكون؟')
  name = string.gsub(name,'نجم','أنا مكاني في السماء، ولكن إذا أضفت لي حرفًا صار مكاني في الأرض، فمن أكون؟')
  name = string.gsub(name,'الحفرة','أنا شيء كلما أخذت مني جزءًا، إزداد حجمي أكثر، فمن أكون؟')
  name = string.gsub(name,'المشط','أنا امتلك أسنان كثيرة ولكني لا أستطيع أن أقضم أو أعض، فمن أكون؟')
  name = string.gsub(name,'الثلج','أنا مصنوع من الماء، ولكني مع ذلك إذا وضعت في الماء فإني أموت، فمن أكون؟')
  name = string.gsub(name,'الذكريات','شيء دائماً تفعله كثيراً وكلما فعلته تركته خلفك، فما هو؟')
  name = string.gsub(name,'البوصلة','بنت حافت الأرض حوف لأنها تعرف جميع الاتجاهات، مسكنها في الوسط وتنام إذا نام صاحبها، فمن هي؟')
  name = string.gsub(name,'البطريق','شيء يسير في البحر، يمشي في البر، عنده جناحين ولكن لا يطير، فما هو؟')
  name = string.gsub(name,'الفلفل','ما هو الشيء الذي يُقشر من الداخل ويؤكل من الخارج؟')
  name = string.gsub(name,'الاخلاق','شيء معروف عالميًا، مهم ومحترم، وفي نفس الوقت يُهان، فما هو؟')
  name = string.gsub(name,'السيارة','شيء أشتريه بمالي و لا أدخله داري فما هو؟')
  name = string.gsub(name,'غلط','ما هي الكلمة الوحيدة التي تُلفظ غلط دائمًا؟')
  name = string.gsub(name,'كوكب الارض','ما هو الكوكب الذي يُرى في الليل و النهار؟')
  name = string.gsub(name,'ادم وحواء','إنسان وزوجته لا هو من بني آدم و لا هي من بنات حواء؟')
  name = string.gsub(name,'عطار','تاجر من التجار إذا اقتلعنا عينه طار، فمن هو؟')
  return 'اول شخص يحل اللغز {* '..name..' *}'
  end

if MsgText[1] == 'عكس الكلمة' or MsgText[1] == 'عكس الكلمه' then
  katu = {
  'بحلا','وسيب','مارجيلتلا','ةكم','فيكم','رزوي','طشمال','جلثلا','تاريكذلا','ةلصوبلا','قيرطبلا','لفلفلا','قلاخالا','ةرايسلا','طلغ','بكوك','مدآ','راطع','باعلا','لاوج','يلت','تيليد','ةيدوعسلا','يضاف','عيقرط','شافخ','لامش','ةينيطنطسقلا','تارامالا','باعلالا','يتيبلط','مكيفش','يناعرو','لقوق','سلجم','رئاط','ةنس','روطرط',
  };
  name = katu[math.random(#katu)]
  redis:set(max..':Set_lgz:'..msg.chat_id_,name)
  name = string.gsub(name,'بحلا','الحب')
  name = string.gsub(name,'وسيب','بيسو')
  name = string.gsub(name,'مارجيلتلا','التليجرام')
  name = string.gsub(name,'ةكم','مكة')
  name = string.gsub(name,'فيكم','مكيف')
  name = string.gsub(name,'رزوي','يوزر')
  name = string.gsub(name,'طشمال','المشط')
  name = string.gsub(name,'جلثلا','الثلج')
  name = string.gsub(name,'تاريكذلا','الذكريات')
  name = string.gsub(name,'ةلصوبلا','البوصلة')
  name = string.gsub(name,'قيرطبلا','البطريق')
  name = string.gsub(name,'لفلفلا','الفلفل')
  name = string.gsub(name,'قلاخالا','الاخلاق')
  name = string.gsub(name,'ةرايسلا','السيارة')
  name = string.gsub(name,'طلغ','غلط')
  name = string.gsub(name,'بكوك','كوكب')
  name = string.gsub(name,'مدآ','آدم')
  name = string.gsub(name,'راطع','عطار')
  name = string.gsub(name,'باعلا','العاب')
  name = string.gsub(name,'لاوج','جوال')
  name = string.gsub(name,'يلت','تلي')
  name = string.gsub(name,'تيليد','ديليت')
  name = string.gsub(name,'ةيدوعسلا','السعودية')
  name = string.gsub(name,'يضاف','فاضي')
  name = string.gsub(name,'عيقرط','طرقيع')
  name = string.gsub(name,'لامش','شمال')
  name = string.gsub(name,'ةينيطنطسقلا','القسطنطينية')
  name = string.gsub(name,'تارامالا','الامارات')
  name = string.gsub(name,'باعلالا','الالعاب')
  name = string.gsub(name,'يتيبلط','طلبيتي')
  name = string.gsub(name,'مكيفش','شفيكم')
  name = string.gsub(name,'يناعرو','ورعاني')
  name = string.gsub(name,'لقوق','قوقل')
  name = string.gsub(name,'سلجم','مجلس')
  name = string.gsub(name,'رئاط','طائر')
  name = string.gsub(name,'ةنس','سنة')
  name = string.gsub(name,'روطرط','طرطور')
  name = string.gsub(name,'شافخ','خفاش')
  return 'اول من يعكس كلمة {* '..name..' *}'
  end

if MsgText[1] == 'اسئله' or MsgText[1] == 'الاسئله' or MsgText[1] == 'حزوره' then   
katu = {'امي','انا','المخده','الهواء','الهواء','القمر','المقفل','النهر','الغيم','اسمك','حرف الام','الضابط','الدائره','الجمعة','ابل','الصمت','السلحفاة','كم الساعه','شجره العائله','ضفدع','خليه النحل','الصوت','الجوع','الكتاب','البيض','الاسفنجه','البرتقال','الكفن','الساعه','الطاولة','البصل','الوقت','النار','الثلج','العمر','المسمار','الحفره','المشط','الجوال','الجرس','المراه','الغداء','الفيل','الصدى','الهواء','عقرب الساعه'};
name = katu[math.random(#katu)]
redis:set(max..':Set_Hzorh:'..msg.chat_id_,name)
name = string.gsub(name,'امي','اخت خالك ومهي خالتك منهي؟')
name = string.gsub(name,'انا','ورع امك وورع ابوك ومهي اختك ولاخوك منهو؟')
name = string.gsub(name,'المخده','انا خفيفه وانا لطيفه اقعد بحضن الخليفه أزيح الهموم  واخلي الحييب نايم من انا؟')
name = string.gsub(name,'الهواء','ماهو الشيء الذي يسير امامك ولا تراه؟')
name = string.gsub(name,'القمر','ماهو الشيء الذي يحيا اول الشهر ويموت في اخره؟')
name = string.gsub(name,'المقفل','وش الباب الي ما يمديك تفتحه؟')
name = string.gsub(name,'النهر','ماهو الشي الذي يجري ولا يمشي؟')
name = string.gsub(name,'الغيم','ماهو الشي الذي يمشي بلا رجلين ويبكي بلا عيون؟')
name = string.gsub(name,'اسمك','ماهو الشيء الذي لك ويستخدمه الناس من دون اذنك؟')
name = string.gsub(name,'حرف الام','ماهو الشيء الذي تراه في الليل ثلاث مرات والنهار مره واحده؟')
name = string.gsub(name,'الضابط','رجوله في الارض وراسه فوق النجوم؟')
name = string.gsub(name,'الدائره','ماهو الشيء الذي ليس له بدايه وليس له نهاية؟')
name = string.gsub(name,'الجمعة','لدينا ثلاث أعياد ليس عيد الفطر وليس عيد الاضحى فما هو؟')
name = string.gsub(name,'ابل','تفاحة ماكول نصها وش هي؟')
name = string.gsub(name,'الصمت','ماهي الكلمه الذي يبطل معناها اذا نطقت بها؟ ')
name = string.gsub(name,'السلحفاة','ماهو الذي لحمهه من الداخل وعضمهه من الخارج؟ ')
name = string.gsub(name,'كم الساعه','ماهوه السؤال الذي تختلف اجابته دائماً؟')
name = string.gsub(name,'شجره العائله','ما اسم الشجره التي ليس لها ضل ولا لها ثمار؟ ')
name = string.gsub(name,'الضفدع','ماهو الحيوان الذي لسانه طويل وجسمه صغير؟')
name = string.gsub(name,'خليه النحل','ماهو الشيء الذي يتسع مئاات الالوف ولا يتسع طير منتوف؟')
name = string.gsub(name,'الصوت','اسير بلا رجلين ولا ادخل الا ب الاذنين؟')
name = string.gsub(name,'الجوع','ماهو الشيء الذي يقرصك ولا تراه؟')
name = string.gsub(name,'الكتاب','له اوراق وما هو بنبات، له جلد وماهو بحيوان . وعلم وماهو ب انسان من هو؟')
name = string.gsub(name,'البيض','ماهو الشي الذي اسمه على لونه؟')
name = string.gsub(name,'الاسفنجه','كلي ثقوب ومع ذالك احفظ الماء فمن انا؟ ')
name = string.gsub(name,'البرتقال','ماهو الشيء نرميه بعد العصر؟')
name = string.gsub(name,'الكفن','ماهو الشيء لاتحب ان تلبسة وان لبستة لاترة؟')
name = string.gsub(name,'الساعه','ماهو الشيء الذي يمشي ويقف وليس له ارجل؟')
name = string.gsub(name,'الطاولة','اننا اربعة اخوه ولنا راس واحد فمن نحن؟')
name = string.gsub(name,'البصل','شيء تذبحه وتبكي عليه؟')
name = string.gsub(name,'الوقت','يذهب ولا يرجع؟')
name = string.gsub(name,'النار','شيء ياكل ولايشبع وان شرب الماء مات؟')
name = string.gsub(name,'الثلج','شيء مصنوع من الماء وان عاش في الماء يموت؟')
name = string.gsub(name,'العمر','ماهو الشيء الذي كلما زاد نقص؟')
name = string.gsub(name,'المسمار','ماهو الشيء الذي لا يمشي الا ب الضرب؟')
name = string.gsub(name,'الحفره','ماهو الشيء الذي كلما اخذنا منهه زاد وكبر؟')
name = string.gsub(name,'المشط','له اسنان ولا يعض ماهو؟ ')
name = string.gsub(name,'الجوال','يسمع بلا اذن ويحكي بلا لسان فما هو؟')
name = string.gsub(name,'الجرس','ماهو الشيء الذي اذا لمسته صاح؟')
name = string.gsub(name,'المراه','ارى كل شيء من دون عيون فمن اكون؟')
name = string.gsub(name,'الغداء','ماهو الشيء الذي لايؤكل في الليل؟ ')
name = string.gsub(name,'الفيل','من هوه الحيوان الذي يحك اذنه في انفه؟')
name = string.gsub(name,'الصدى','ماهو الشيء الذي يتكلم جميع اللغات؟ ')
name = string.gsub(name,'الهواء','شيء بيني وبينك لا تراه عينك ولا عيني فما هوه؟')
name = string.gsub(name,'عقرب الساعه','هناك عقرب لا يلدغ ولا يخاف منه الاطفال فما هوه؟')
return '  اول واحد يحلها » {* '..name..' *} ' 
end


if MsgText[1] == 'خاتم' or MsgText[1] == 'بات' then   
Num = math.random(1,6)
redis:set(max.."GAMES"..msg.chat_id_,Num) 
TEST = [[
 ¹           ²        ³         ⁴         ⁵          ⁶
↓         ↓       ↓       ↓        ↓        ↓
👊🏻 ‹› 👊🏻 ‹› 👊🏻 ‹› 👊🏻 ‹› 👊🏻 ‹› 👊🏻


-› أختر اليد التي تحمل المحيبس
- الفائز يربح {10} نقاط
]]
sendMsg(msg.chat_id_,msg.id_,TEST)   
redis:setex(max.."SET:GAME" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 100, true)  
return false  
end
if MsgText[1] == '' or MsgText[1] == '' then   
Num = math.random(1,10)
redis:set(max.."GAMESS"..msg.chat_id_,Num) 
TEST = [[
  ¹          ²         ³         ⁴          ⁵
↓         ↓        ↓        ↓        ↓
✉️ ↔ ✉️ ↔ ✉️ ↔ ✉️ ↔ ✉️
 ⁶           ⁷         ⁸         ⁹         ¹⁰
↓         ↓        ↓        ↓        ↓
✉️ ↔ ✉️ ↔ ✉️ ↔ ✉️ ↔ ✉️
-› أختر الظرف الذي يوجد بداخله النقود
- الفائز يربح {50} نقطة 
]]
sendMsg(msg.chat_id_,msg.id_,TEST)   
redis:setex(max.."SETT:GAMEE" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 100, true)  
return false  
end
if MsgText[1] == 'الأرقام' or MsgText[1] == 'الارقام' then   
Num = math.random(1,15)
redis:set(max.."GAMES:NUM"..msg.chat_id_,Num) 
TEST = '-› حسنًا لدنيا 15 رقم،\n'..'- رقم واحد فقط الصحيح \n'..'- هل تسطيع إجاد الرقم؟ \n أبحث الأن وحصل على 5 نقاط'
sendMsg(msg.chat_id_,msg.id_,TEST)
redis:setex(max.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 100, true)  
return false  
end
if (MsgText[1] == 'اسرع' or MsgText[1] == 'الاسرع') then
local NUM = math.random(10,1000)
redis:set(max..':NUM_SET:'..msg.chat_id_,(NUM * 3))
local Smiles = {'سحور','سياره','استقبال','قنفه','ايفون','قروب','مطبخ','كرستيانو','دجاجه','مدرسه','الوان','غرفه','ثلاجه','قهوه','سفينه','العراق','محطه','طياره','رادار','منزل','مستشفى','كهرباء','تفاحه','اخطبوط','سلمون','فرنسا','برتقاله','تفاح','مطرقه','بتيته','لهانه','شباك','باص','سمكه','ذباب','بيسو','تلفاز','حاسوب','انترنيت','ساحه','جسر','مرحباً','صباح الخير','مساء الخير','تصبح على خير','مع السلامة','أراك فيما بعد','سررت بلقائك','تشرفت بلقائك','أهلاً وسهلاً','ما اسمك','تفضل بالجلوس','شكراً','هل ترغب بمرافقتي','ما رأيك في أن نقوم بنزهة','سيراً على الأقدام','لنذهب للسباحه','حقيقه','صندوق','يد','شجاع','هادئ','حذر','مرح','ذكي','جبان','مجنون','عاطفي','ودود','مضحك','كريم','صادق','غير صبور','غير مهذب','حنون','كسول','حقير','مريض','امي','انا','المخده','الهواء','الهواء','القمر','المقفل','النهر','الغيم','اسمك',' الام','الضابط','الدائره','الجمعة','ابل','الصمت','السلحفاة','كم الساعه','شجره العائله','ضفدع','خليه النحل','الصوت','الجوع','الكتاب','البيض','الاسفنجه','البرتقال','الكفن','الساعه','الطاولة','البصل','الوقت','النار','الثلج','العمر','المسمار','الحفره','المشط','الجوال','الجرس','المراه','الغداء','الفيل','الصدى','الهواء','عقرب الساعه','عبدالمجيد عبدالله','اصاله نصري','عبادي جوهر','طلال مداح','ادهم نابلسي','محمد عبده','يزن السقاف','حسين الجسمي','راشد الماجد','فضل شاكر','عباس ابراهيم','اليسا','رامي عياش','وائل جسار','يسرا محنوش','تامر حسني','ماجد المهندس','فضل شاكر','شيرين عبدالوهاب','راشد الماجد','أدهم نابلسي','عمرو دياب','حسين الجسمي','عبدالمجيد عبدالله','علي كاكولي','راشد الماجد','فضل شاكر','فيروز','محمد منير','جوزيف صقر','سعد لمجرد','رامي عياش','حماقي','روبي','حمزه نمره','محمد السالم','فيروز'}
Emoji = Smiles[math.random(#Smiles)]
redis:set(max..':Set_Smile:'..msg.chat_id_,Emoji)
if tonumber(redis:get(max..':Set_Smile:'..msg.chat_id_)) == tonumber(redis:get(max..':NUM_SET:'..msg.chat_id_)) then
return 'أول واحد يكتب: '..(redis:get(max..':Set_Smile:'..msg.chat_id_))..''
else
return '️أول واحد يكتب: '..(redis:get(max..':Set_Smile:'..msg.chat_id_))..''
end
end
if MsgText[1] == 'ترتيب' then
katu = {'سحور','سياره','استقبال','قنفه','ايفون','بزونه','مطبخ','كرستيانو','دجاجه','مدرسه','الوان','غرفه','ثلاجه','قهوه','سفينه','العراق','محطه','طياره','رادار','منزل','مستشفى','كهرباء','تفاحه','اخطبوط','سلمون','فرنسا','برتقاله','تفاح','مطرقه','بتيته','لهانه','شباك','باص','سمكه','ذباب','بيسو','تلفاز','حاسوب','انترنيت','ساحه','جسر'};
name = katu[math.random(#katu)]
redis:set(max..':Set_Arg:'..msg.chat_id_,name)
name = string.gsub(name,'سحور','س ر و ح')
name = string.gsub(name,'سياره','ه ر س ي ا')
name = string.gsub(name,'استقبال','ل ب ا ت ق س ا')
name = string.gsub(name,'قنفه','ه ق ن ف')
name = string.gsub(name,'ايفون','و ن ي ف ا')
name = string.gsub(name,'بزونه','ز و ب ه ن')
name = string.gsub(name,'مطبخ','خ ب ط م')
name = string.gsub(name,'كرستيانو','س ت ا ن و ك ر ي')
name = string.gsub(name,'دجاجه','ج ج ا د ه')
name = string.gsub(name,'مدرسه','ه م د ر س')
name = string.gsub(name,'الوان','ن ا و ا ل')
name = string.gsub(name,'غرفه','غ ه ر ف')
name = string.gsub(name,'ثلاجه','ج ه ث ل ا')
name = string.gsub(name,'قهوه','ه ق ه و')
name = string.gsub(name,'سفينه','ه ن ف ي س')
name = string.gsub(name,'العراق','ق ع ا ل ر ا')
name = string.gsub(name,'محطه','ه ط م ح')
name = string.gsub(name,'طياره','ر ا ط ي ه')
name = string.gsub(name,'رادار','ر ا ر ا د')
name = string.gsub(name,'منزل','ن ز م ل')
name = string.gsub(name,'مستشفى','ى ش س ف ت م')
name = string.gsub(name,'كهرباء','ر ب ك ه ا ء')
name = string.gsub(name,'تفاحه','ح ه ا ت ف')
name = string.gsub(name,'اخطبوط','ط ب و ا خ ط')
name = string.gsub(name,'سلمون','ن م و ل س')
name = string.gsub(name,'فرنسا','ن ف ر س ا')
name = string.gsub(name,'برتقاله','ر ت ق ب ا ه ل')
name = string.gsub(name,'تفاح','ح ف ا ت')
name = string.gsub(name,'مطرقه','ه ط م ر ق')
name = string.gsub(name,'بتيته','ب ت ت ي ه')
name = string.gsub(name,'لهانه','ه ن ا ه ل')
name = string.gsub(name,'شباك','ب ش ا ك')
name = string.gsub(name,'باص','ص ا ب')
name = string.gsub(name,'سمكه','ك س م ه')
name = string.gsub(name,'ذباب','ب ا ب ذ')
name = string.gsub(name,'تلفاز','ت ف ل ز ا')
name = string.gsub(name,'حاسوب','س ا ح و ب')
name = string.gsub(name,'انترنيت','ا ت ن ر ن ي ت')
name = string.gsub(name,'ساحه','ح ا ه س')
name = string.gsub(name,'جسر','ر ج س')
name = string.gsub(name,'بيسو','و س ي ب')
return '  اسرع واحد يرتبها » {* '..name..' *} ' 
end
if (MsgText[1] == 'روليت') then
redis:del(max..":Number_Add:"..msg.chat_id_..msg.sender_user_id_) 
redis:del(max..':List_Rolet:'..msg.chat_id_)  
redis:setex(max..":Start_Rolet:"..msg.chat_id_..msg.sender_user_id_,3600,true)  
return '*• * حسناً , ارسل عدد اللاعبين .'
end
if MsgText[1] == 'نعم' and redis:get(max..":Witting_StartGame:"..msg.chat_id_..msg.sender_user_id_) then
local list = redis:smembers(max..':List_Rolet:'..msg.chat_id_) 
if #list == 1 then 
return "• لم يكتمل العدد للاعبين" 
elseif #list == 0 then 
return "• لم تقوم باضافه اي لاعب" 
end 
local UserName = list[math.random(#list)]
GetUserName(UserName,function(arg,data)
redis:incrby(max..':User_Points:'..msg.chat_id_..data.id_,5)
end,nil)
redis:del(max..':List_Rolet:'..msg.chat_id_) 
redis:del(max..":Witting_StartGame:"..msg.chat_id_..msg.sender_user_id_)
return '• تم اختيار الشخص المحظوظ\n• صاحب الحظ {['..UserName..']}\n• ربحت معنا 5 نقاط' 
end
if MsgText[1] == 'الاعبين' then
local list = redis:smembers(max..':List_Rolet:'..msg.chat_id_) 
local Text = '\n*————————*\n' 
if #list == 0 then 
return '*• * لا يوجد لاعبين هنا ' 
end 
for k, v in pairs(list) do 
Text = Text..k.."•  » [" ..v.."] »\n"  
end 
return Text
end
if MsgText[1] == 'احكام' then
redis:del(max..":Number_drok:"..msg.chat_id_..msg.sender_user_id_) 
redis:del(max..':List_drok:'..msg.chat_id_)  
redis:setex(max..":Start_drok:"..msg.chat_id_..msg.sender_user_id_,3600,true)  
return '-› حسنًا الان ارسل عدد المتنافسين .'
end
if MsgText[1] == 'نعم' and redis:get(max..":Witting_drok:"..msg.chat_id_..msg.sender_user_id_) then
local list = redis:smembers(max..':List_drok:'..msg.chat_id_) 
if #list == 1 then 
return "-› لم يكتمل العدد" 
elseif #list == 0 then 
return "-› لم تقوم باضافه اي شخص" 
end 
local UserName = list[math.random(#list)]
GetUserName(UserName,function(arg,data)
redis:incrby(max..':User_Points:'..msg.chat_id_..data.id_,5)
end,nil)
redis:del(max..':List_drok:'..msg.chat_id_) 
redis:del(max..":Witting_drok:"..msg.chat_id_..msg.sender_user_id_)
return '-› تم أختيار الشخص الفائز\n- الشخص الفائز {['..UserName..']}\n- الأن أحكم على الخاسرين\n- أكتب {* الاحكام *}' 
end
if MsgText[1] == 'الاشخاص' then
local list = redis:smembers(max..':List_drok:'..msg.chat_id_) 
local Text = '\n*————————*\n' 
if #list == 0 then 
return '-› لا يوجد أحد هنا' 
end 
for k, v in pairs(list) do 
Text = Text..k.."-› [" ..v.."] .\n"  
end 
return Text
end
if MsgText[1] == "الالعاب" or MsgText[1] == "قائمة الالعاب" or MsgText[1] == "قائمه الالعاب" then
return [[ 
- الالعاب لبوت بيسو - :
-› امثله › تكمل المثل المطلوب
-› معاني -› تجيب المعنى للإيموجي
-› اسئله › تجاوب على الاسئله
-› روليت › لعبة تعتمد على الحظ
-› حزوره › تجاوب على الحزورات
-› ترتيب › ترتب الكلِمات المطلوبه
-› الاسرع › اسرع واحد يدز إيموجي
-› خاتم › تخمن وين المحيبس
-› المختلف › تكتشف الإختلاف
-› انقليزي › تجيب معنى الكلِمة بالعربي
-› تفكيك › تفكك الكلِمات
-› كت تويت › تجاوب على كت تويت
-› الالغاز › تحل الالغاز المطلوبة
-› احكام › الاحكام تحكم على الخاسر
-› الارقام › تخمن وش الرقم الصحيح
-› بيسو السحرية › اسأل وبيسو تجاوب
-› بيسو اختاري حرف › لعبة تقدر تصنع منها اللعاب‌‏
-› أسم مغني › أسرع شخص يجيب أسم المغني
-› تركيب › تركيب الكِلمات
-› اعلام › ترسل أسم العلم المحدد
-› دول › ترسل علم الدولة المحدده
 -› كلمة وضدها › تجيب ضد الكلِمات
  -› عكس الكلمة › تكتب الكلمة بالعكس
 ‌‏
]]
end
if MsgText[1] == 'معاني' then
katu = {'قرد','حصان','ارنب','حيه','نمله','قطه','كلب','ثور','ماعز','خروف','سلحفاه','حوت','ورده','نخله','شجره','شمس','هلال','كامره','حلزون','مسدس','طياره','سياره','كرز','بطيخ','فراوله','منزل','كوره','نجمه','ساعه','راديو','باب','قارب','دجاجه','بطريق','ضفدع','بومه','نحله','ديك','جمل','بقره','دولفين','تمساح','قرش','نمر','اخطبوط','سمكه','خفاش','اسد','فأر','ذئب','فراشه','عقرب','زرافه','قنفذ','تفاحه','باذنجان'}
name = katu[math.random(#katu)]
redis:set(max..':Set_Name_Meant:'..msg.chat_id_,name)
name = string.gsub(name,'قرد','🐒')
name = string.gsub(name,'حصان','🐎')
name = string.gsub(name,'ارنب','🐇')
name = string.gsub(name,'حيه','🐍')
name = string.gsub(name,'نمله','🐜')
name = string.gsub(name,'قطه','🐈')
name = string.gsub(name,'كلب','🐕')
name = string.gsub(name,'ثور','🐂')
name = string.gsub(name,'ماعز','🐐')
name = string.gsub(name,'خروف','🐏')
name = string.gsub(name,'سلحفاه','🐢')
name = string.gsub(name,'حوت','🐳')
name = string.gsub(name,'ورده','🌷')
name = string.gsub(name,'نخله','🌴')
name = string.gsub(name,'شجره','🌳')
name = string.gsub(name,'شمس','🌞')
name = string.gsub(name,'هلال','🌙')
name = string.gsub(name,'كامره','📷')
name = string.gsub(name,'كامره','📹')
name = string.gsub(name,'حلزون','🐌')
name = string.gsub(name,'مسدس','🔫')
name = string.gsub(name,'طياره','🚁')
name = string.gsub(name,'سياره','🚘')
name = string.gsub(name,'كرز','🍒')
name = string.gsub(name,'بطيخ','🍉')
name = string.gsub(name,'فراوله','🍓')
name = string.gsub(name,'منزل','🏫')
name = string.gsub(name,'كوره','⚽')
name = string.gsub(name,'نجمه','🌟')
name = string.gsub(name,'ساعه','🕞')
name = string.gsub(name,'راديو','📻')
name = string.gsub(name,'باب','🚪')
name = string.gsub(name,'قارب','⛵')
name = string.gsub(name,'دجاجه','🐔')
name = string.gsub(name,'بطريق','🐧')
name = string.gsub(name,'ضفدع','🐸')
name = string.gsub(name,'بومه','🦉')
name = string.gsub(name,'نحله','🐝')
name = string.gsub(name,'ديك','🐓')
name = string.gsub(name,'جمل','🐫')
name = string.gsub(name,'بقره','🐄')
name = string.gsub(name,'دولفين','🐬')
name = string.gsub(name,'تمساح','🐊')
name = string.gsub(name,'قرش','🦈')
name = string.gsub(name,'نمر','🐅')
name = string.gsub(name,'اخطبوط','🐙')
name = string.gsub(name,'سمكه','🐟')
name = string.gsub(name,'خفاش','🦇')
name = string.gsub(name,'اسد','🦁')
name = string.gsub(name,'فأر','🐭')
name = string.gsub(name,'ذئب','🐺')
name = string.gsub(name,'فراشه','🦋')
name = string.gsub(name,'عقرب','🦂')
name = string.gsub(name,'زرافه','🦒')
name = string.gsub(name,'قنفذ','🦔')
name = string.gsub(name,'تفاحه','🍎')
name = string.gsub(name,'باذنجان','🍆')
return 'أسم السمايل » { '..name..' }'
end
sendMsg(msg.chat_id_,msg.id_,SENDTEXT)     
return false  
end






if MsgText[1] == 'نبخبمينبخيحصمبنذن8282نذنذنذنذنيميميكصىذ' then
sendMsg(msg.chat_id_,msg.id_,[[
-› الالعاب لبوت []]..redis:get(max..':NameBot:')..[[]🎖.
↓ ↓ ↓ ↓ 
-  امثله > تكمل المثل المطلوب
-  معاني > تجيب المعنى للإيموجي
-  اسئله > تجاوب على الاسئله
-  روليت > لعبة تعتمد على الحظ
-  حزوره > تجاوب على الحزورات
-  ترتيب > ترتب الكلِمات المطلوبه
-  العكس > تجيب عكس الكلِمات
-  الاسرع > اسرع واحد يدز إيموجي
-  خاتم > تخمن وين الخاتم
-  المختلف > تكتشف الإختلاف
-  انقليزي > تجيب معنى الكلِمة بالعربي
-  تفكيك > تفكك الكلِمات
- تركيب > تركيب الكِلمات
- كت تويت > تجاوب على كت تويت
-  الالغاز > تحل الالغاز المطلوبة
- احكام > الاحكام تحكم على الخاسر
- الارقام > تخمن وش الرقم الصحيح
- بيسو السحرية > اسأل وبيسو تجاوب
- بيسو اختاري حرف > لعبة تقدر تصنع منها اللعاب‌‏
‏‏
]])
end
end
end




local function procces(msg)
if msg.text and not redis:get(max..'lock_geams'..msg.chat_id_) then
if msg.text == redis:get(max..':Set_alii:'..msg.chat_id_) then -- // المختلف
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_alii:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end

if msg.text == redis:get(max..':Set_Amthlh:'..msg.chat_id_) then -- // امثله
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_Amthlh:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end

if msg.text == redis:get(max..':Set_lgz:'..msg.chat_id_) then -- // لغز
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_lgz:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end

if msg.text == redis:get(max..':Set_lgz:'..msg.chat_id_) then -- // الالغاز
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_lgz:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end

if msg.text == redis:get(max..':Set_Hzorh:'..msg.chat_id_) then -- // حزوره
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_Hzorh:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end


if msg.text == redis:get(max..':Set_Smile:'..msg.chat_id_) then --//  الاسرع
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_Smile:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end 
if msg.text == redis:get(max..':Set_alii:'..msg.chat_id_) then -- // المختلف
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_alii:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end 
if msg.text == redis:get(max..':Set_Hzorh:'..msg.chat_id_) then -- // حزوره
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_Hzorh:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end 
if msg.text == redis:get(max..':Set_Arg:'..msg.chat_id_) then -- // الترتيب
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_Arg:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end 
if msg.text == redis:get(max..':Set_Name_Meant:'..msg.chat_id_) then --// المعاني
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max..':Set_Name_Meant:'..msg.chat_id_)
return sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')
end 
if msg.text:match("^(%d+)$") and redis:get(max..":Start_drok:"..msg.chat_id_..msg.sender_user_id_) then  --// استقبال اللعبه الدمبله
if msg.text == "1" then
Text = "-› لا أستطيع أكمل اللعبه بشخص واحد فقط\n"
else
redis:set(max..":Number_drok:"..msg.chat_id_..msg.sender_user_id_,msg.text)  
Text = '-› حسنًا الأن تبدأ اللعبة \n- يرجى ارسال المعرفات \n- الفائز يحكم على الخاسر\n- لا يمكنك الأنسحاب \n'
end
redis:del(max..":Start_drok:"..msg.chat_id_..msg.sender_user_id_)  
return sendMsg(msg.chat_id_,msg.id_,Text)    
end
if msg.text:match('^(@[%a%d_]+)$') and redis:get(max..":Number_drok:"..msg.chat_id_..msg.sender_user_id_) then    --// استقبال الاسماء
if redis:sismember(max..':List_drok:'..msg.chat_id_,msg.text) then
return sendMsg(msg.chat_id_,msg.id_,'-› الشخص {['..msg.text..']} موجود اساساً' )
end
redis:sadd(max..':List_drok:'..msg.chat_id_,msg.text)
local CountAdd = redis:get(max..":Number_drok:"..msg.chat_id_..msg.sender_user_id_)
local CountAll = redis:scard(max..':List_drok:'..msg.chat_id_)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
redis:del(max..":Number_drok:"..msg.chat_id_..msg.sender_user_id_) 
redis:setex(max..":Witting_drok:"..msg.chat_id_..msg.sender_user_id_,1400,true)  
return sendMsg(msg.chat_id_,msg.id_,"-› تم أدخال الشخص الأخير \n- وتم أكتمال عدد الأشخاص \n- هل انت متأكد؟ اجب بـ {* نعم *}")
end 
return sendMsg(msg.chat_id_,msg.id_,"-› تم ادخال شخص جديد { ["..msg.text.."] } \n- تبقى { *"..CountUser.."* } الأشخاص ليكتمل عدد\n- ارسل المعرف التالي")
end
end 
if msg.text:match("^(%d+)$") and redis:get(max..":Start_Rolet:"..msg.chat_id_..msg.sender_user_id_) then  --// استقبال اللعبه الدمبله
if msg.text == "1" then
Text = "-› لا استطيع بدء اللعبه بلاعب واحد فقط\n"
else
redis:set(max..":Number_Add:"..msg.chat_id_..msg.sender_user_id_,msg.text)  
Text = '-› تم بدء تسجيل اللسته \n- يرجى ارسال المعرفات \n- الفائز يحصل على (5) نقاط\n- عدد الاعبين المطلوبه { *'..msg.text..'* } لاعب \n'
end
redis:del(max..":Start_Rolet:"..msg.chat_id_..msg.sender_user_id_)  
return sendMsg(msg.chat_id_,msg.id_,Text)    
end
if msg.text:match('^(@[%a%d_]+)$') and redis:get(max..":Number_Add:"..msg.chat_id_..msg.sender_user_id_) then    --// استقبال الاسماء
if redis:sismember(max..':List_Rolet:'..msg.chat_id_,msg.text) then
return sendMsg(msg.chat_id_,msg.id_,'-› المعرف {['..msg.text..']} موجود اساساً' )
end
redis:sadd(max..':List_Rolet:'..msg.chat_id_,msg.text)
local CountAdd = redis:get(max..":Number_Add:"..msg.chat_id_..msg.sender_user_id_)
local CountAll = redis:scard(max..':List_Rolet:'..msg.chat_id_)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
redis:del(max..":Number_Add:"..msg.chat_id_..msg.sender_user_id_) 
redis:setex(max..":Witting_StartGame:"..msg.chat_id_..msg.sender_user_id_,1400,true)  
return sendMsg(msg.chat_id_,msg.id_,"-› تم ادخال المعرف { ["..msg.text.."] } \n- وتم اكتمال العدد الكلي \n- هل انت مستعد؟ اجب بـ {* نعم *}")
end 
return sendMsg(msg.chat_id_,msg.id_,"-› تم ادخال المعرف { ["..msg.text.."] } \n- تبقى { *"..CountUser.."* } لاعبين ليكتمل العدد\n- ارسل المعرف التالي ")
end
if redis:get(max.."SETEX:MSG"..msg.chat_id_..""..msg.sender_user_id_) then
if msg.text:match("^(%d+)$") then
if tonumber(msg.text:match("^(%d+)$")) > 99999999990 then
sendMsg(msg.chat_id_,msg.id_,"-› لا تستطيع إضافة اكثر من (99999999990) رسالة .")
redis:del(max.."SETEX:MSG"..msg.chat_id_..""..msg.sender_user_id_)
return false  end
local GET_IDUSER = redis:get(max..'SET:ID:USER'..msg.chat_id_)
sendMsg(msg.chat_id_,msg.id_,"-› تم إضافة { "..msg.text.." } رسالة")
redis:incrby(max..'msgs:'..GET_IDUSER..':'..msg.chat_id_,msg.text)
end
redis:del(max.."SETEX:MSG"..msg.chat_id_..""..msg.sender_user_id_)
end
if redis:get(max.."SETEX:NUM"..msg.chat_id_..""..msg.sender_user_id_) then 
if msg.text:match("^(%d+)$") then
if tonumber(msg.text:match("^(%d+)$")) > 99999999990 then
sendMsg(msg.chat_id_,msg.id_,"*• لا تستطيع اضافة اكثر من 99999999990 نقطه\n*")   
redis:del(max.."SETEX:NUM"..msg.chat_id_..""..msg.sender_user_id_)  
return false  end 
local GET_IDUSER = redis:get(max..'SET:ID:USER:NUM'..msg.chat_id_)  
sendMsg(msg.chat_id_,msg.id_,"\n• * تم  اضافة له { "..msg.text.." }* نقطه")
redis:incrby(max..':User_Points:'..msg.chat_id_..GET_IDUSER,msg.text)  
end
redis:del(max.."SETEX:NUM"..msg.chat_id_..""..msg.sender_user_id_)  
end
if redis:get(max.."SET:GAME" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if msg.text:match("^(%d+)$") then
local NUM = msg.text:match("^(%d+)$")
if tonumber(NUM) > 6 then
sendMsg(msg.chat_id_,msg.id_,"-› لا يوجد سواء { 6 } اختيارات فقط ارسل اختيارك مره اخره\n")   
return false  end 
local GETNUM = redis:get(max.."GAMES"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(max.."SET:GAME" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
sendMsg(msg.chat_id_,msg.id_,'-› مبروك فزت وطلعت الخاتم باليد رقم { '..NUM..' }\n- لقد حصلت على { 10 } من نقاط يمكنك استبدالها برسائل')   
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,10)  
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:del(max.."SET:GAME" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
sendMsg(msg.chat_id_,msg.id_,'-› للاسف لقد خسرت \n- الخاتم باليد رقم { '..GETNUM..' }\n- حاول مره اخرى للعثور على الخاتم')   
end
end
if redis:get(max.."SETT:GAMEE" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if msg.text:match("^(%d+)$") then
local NUM = msg.text:match("^(%d+)$")
if tonumber(NUM) > 10 then
sendMsg(msg.chat_id_,msg.id_,"-› عذرًا لا يوجد إلا {10} فقط")   
return false  end 
local GETNUM = redis:get(max.."GAMESS"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(max.."SETT:GAMEE" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
sendMsg(msg.chat_id_,msg.id_,'-› إجابة صحيحة الظرف الذي يوجد به النقود : { '..NUM..' }\n- وحصلت على 50 نقطة هدية')   
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,50)  
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:del(max.."SETT:GAMEE" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
sendMsg(msg.chat_id_,msg.id_,'-› للأسف إجابة خاطئه \n- الظرف الذي يوجد داخله النقود : { '..GETNUM..' }\n')   
end
end
end
if (msg.text == redis:get(max.."GAME:CHER"..msg.chat_id_)) and redis:get(max.."GAME:S"..msg.chat_id_) then 
sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')     
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max.."GAME:S"..msg.chat_id_)
redis:del(max.."GAME:CHER"..msg.chat_id_)
elseif msg.text == 'الفيل' or msg.text == 'الثور' or msg.text == 'الحصان' or msg.text == '7' or msg.text == '9' or msg.text == '8' or msg.text == 'لوين' or msg.text == 'موسكو' or msg.text == 'مانكو' or msg.text == '20' or msg.text == '30' or msg.text == '28' or msg.text == 'ترامب' or msg.text == 'اوباما' or msg.text == 'كيم جونغ' or msg.text == '50' or msg.text == '70' or msg.text == '40' or msg.text == '7' or msg.text == '3' or msg.text == '10' or msg.text == '4' or msg.text == 'الاذن' or msg.text == 'الثلاجه' or msg.text == 'الغرفه' or msg.text == '15' or msg.text == '17' or msg.text == '25' or msg.text == 'الفرات' or msg.text == 'نهر الكونغو' or msg.text == 'المسيبي' or msg.text == 'بيا بايج' or msg.text == 'لاري بيج' or msg.text == 'بيا مارك زوكيربرج' or msg.text == 'الفيل' or msg.text == 'النمر' or msg.text == 'الفهد' or msg.text == 'بانكول' or msg.text == 'نيو دلهي' or msg.text == 'بيكن' or msg.text == 'الهاتف' or msg.text == 'التلفاز' or msg.text == 'المذياع' or msg.text == 'لفرسول' or msg.text == 'تركيا' or msg.text == 'بغداد' or msg.text == 'النحاس' or msg.text == 'الحديد' or msg.text == 'الفضه' or msg.text == 'امريكا الشماليه' or msg.text == 'امريكا الجنوبيه' or msg.text == 'افريقيا' or msg.text == 'القرش' or msg.text == 'الثعلب' or msg.text == 'الكلب' or msg.text == 'للجرو' or msg.text == 'العجل' or msg.text == 'الحمار' or msg.text == '3' or msg.text == '5' or msg.text == '6' or msg.text == 'اوربا' or msg.text == 'افريقيا' or msg.text == 'امريكا الجنوبيه' or msg.text == 'افريقيا' or msg.text == 'امريكا الشماليه' or msg.text == 'اوربا' or msg.text == 'الصاروخ' or msg.text == 'المسدس' or msg.text == 'الطائرات' or msg.text == 'سيدات' or msg.text == 'قوانص' or msg.text == 'عوانس' or msg.text == 'المكارم' or msg.text == 'المبائم' or msg.text == 'المعازم' or msg.text == 'حرف الغاء' or msg.text == 'حرف الواو' or msg.text == 'حرف النون' or msg.text == 'نحاس' or msg.text == 'الماس' or msg.text == 'حديد' or msg.text == 'العمر' or msg.text == 'ساعه' or msg.text == 'الحذاء' or msg.text == 'بئر' or msg.text == 'نهر' or msg.text == 'شلال' or msg.text == 'ادم' or msg.text == 'نوح' or msg.text == 'عيسئ' or msg.text == 'الاضافر' or msg.text == 'الاسنان' or msg.text == 'الدموع' or msg.text == 'الاخلاق' or msg.text == 'الضل' or msg.text == 'حرف النون'  then
if redis:get(max.."GAME:S"..msg.chat_id_) then  
local list = {'10' , 'براسي' , 'النمل' , '32' , 'بوتين' , '30' , '11' , 'الفم' , '14' , 'النيل' , 'ستيف جوبر' , 'خديجه' , 'الاسد' , 'طوكيو' , 'الانسان' , 'لندن' , 'الزئبق' , 'اورباالدولفين' , 'المهر' , '4' , 'اسيا' , 'اسيا' , 'المنجنيق' , 'انسات' , 'العزائم' , 'حرف الام' , 'ذهب' , 'الاسم' , 'سحاب' , 'ابراهيم' , 'الشعر' , 'حرف الواو'}
for k, v in pairs(list) do 
if msg.text ~= v then
sendMsg(msg.chat_id_,msg.id_,'-› اجابتك غلط ')     
redis:del(max.."GAME:S"..msg.chat_id_)
redis:del(max.."GAME:CHER"..msg.chat_id_)
return false  
end
end
end
end
if (msg.text == redis:get(max.."GAME:CHER"..msg.chat_id_)) and redis:get(max.."GAME:S"..msg.chat_id_) then  
sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')     
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max.."GAME:S"..msg.chat_id_)
redis:del(max.."GAME:CHER"..msg.chat_id_)
elseif msg.text == 'فهمت' or msg.text == 'شجاع' or msg.text == 'عدل' or msg.text == 'نشيط' or msg.text == 'مو زين' or msg.text == 'مو عطشان' or msg.text == 'حاره' or msg.text == 'مو خايف' or msg.text == 'خلف' or msg.text == 'وفي' or msg.text == 'القزم' or msg.text == 'لين' or msg.text == 'خشن' or msg.text == 'عاقل' or msg.text == 'ذكي' or msg.text == 'مو ظلمه' or msg.text == 'ممنوع' or msg.text == 'اسمعك' or msg.text == 'روح' then
if redis:get(max.."GAME:S"..msg.chat_id_) then  
local list = {'فهمت' , 'شجاع' , ' مو عطشان' , 'عدل' , 'نشيط' , 'مو زين' , ' حاره ' , 'خلف' , 'مو خايف' , 'لين' , 'القزم' , 'وفي' , 'عاقل' , 'خشن' , 'ذكي' , 'اسمعك' , 'ممنوع' , 'مو ظلمه'}
for k, v in pairs(list) do 
if msg.text ~= v then
sendMsg(msg.chat_id_,msg.id_,'-› أحسنت جبتها صح .')     
redis:incrby(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_,1)  
redis:del(max.."GAME:S"..msg.chat_id_)
redis:del(max.."GAME:CHER"..msg.chat_id_)
return false  
end
end
end
end
if redis:get(max.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if msg.text:match("^(%d+)$") then
local NUM = msg.text:match("^(%d+)$")
if tonumber(NUM) > 15 then
sendMsg(msg.chat_id_,msg.id_,"-› خطأ رجاًء أختار بين الـ 1-15 \n")
return false  end 
local GETNUM = redis:get(max.."GAMES:NUM"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(max..'SADD:NUM'..msg.chat_id_..msg.sender_user_id_)
redis:del(max.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
redis:incrby(max..':User_Points:'..msg.chat_id_..data.id_,5)
sendMsg(msg.chat_id_,msg.id_,'-› أحسنت لقد وجدت الرقم الصحيح\n- جائزتك 5 نقاط \n')
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:incrby(max..'SADD:NUM'..msg.chat_id_..msg.sender_user_id_,1)
if tonumber(redis:get(max..'SADD:NUM'..msg.chat_id_..msg.sender_user_id_)) >= 3 then
redis:del(max..'SADD:NUM'..msg.chat_id_..msg.sender_user_id_)
redis:del(max.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
sendMsg(msg.chat_id_,msg.id_,'-› حسنًا لم تكشف الرقم الصحيح \n- الرقم الصحيح { '..GETNUM..' } \n- اللعب مره أخرى\n')
else
sendMsg(msg.chat_id_,msg.id_,'-› الرقم غلط \n- أرسل رقم أخر \n')
end
end
end
end

if msg.text then  
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_}, function(arg,data) 
if redis:get(max.."chencher"..msg.sender_user_id_) then 
if redis:get(max.."chencher"..msg.sender_user_id_) ~= data.first_name_ then 
tahan = '['..(redis:get(max.."chencher"..msg.sender_user_id_) or '')..']'
taham = '['..data.first_name_..']'
sendMsg(msg.chat_id_,msg.id_,taha[math.random(#taha)])
end  
end
redis:set(max.."chencher"..msg.sender_user_id_, data.first_name_) 
end,nil) 
end
end
end
return {
max = {
"^(حزوره)$", 
"^(المختلف)$",
  "^(انقليزي)$",
    "^(انجليزي)$",
  "^(تفكيك)$",
   "^(الالغاز)$",
      "^(لغز)$",
      "^(امثله)$",
"^(نعم)$",
"^(نعم)$",
"^(الاعبين)$",
"^(الاسئله)$",
"^(ختيارات)$",
"^(اسئله)$",
"^(الالعاب)$",
"^(خاتم)$",
"^(ظرف)$",
"^(الظرف)$",
"^(تخمين)$",
"^(الارقام)$",
"^(علم)$",
"^(اعلام)$",
"^(الأرقام)$",
"^(خمن)$",
"^(بات)$",
"^(اسم مغني)$",
"^(أسم مغني)$",
"^(أسماء مغنين)$",
"^(اسماء مغنين)$",
'^(تعطيل) (.+)$',
'^(تفعيل) (.+)$',
"^(اسرع)$",
"^(كلمة وضدها)$",
"^(كلمه وضدها)$",
"^(عكس الكلمة)$",
"^(عكس الكلمه)$",
"^(الاسرع)$",
"^(نقاطي)$",
"^(ترتيب)$",
"^(دول)$",
"^(الدول)$",
"^(معاني)$",
"^(بيع نقاطي) (%d+)$",
"^(اضف رسائل) (%d+)$",
"^(مسح رسائلي) (%d+)$",
"^(اضف نقاط) (%d+)$",
"^(روليت)$",
"^(احكام)$",
"^(تركيب)$",
"^(قائمه الالعاب)$",
"^(قائمة الالعاب)$",
"^(مقالات)$",
 },
 imax = games,
 dmax = procces,
 }
