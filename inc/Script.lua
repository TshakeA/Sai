--[[
 الأصلية
]]

function download_to_file(url, file_name)
    -- print to server
    -- print("url to download: "..url)
    -- uncomment if needed
    local respbody = {}
    local options = {
        url = url,
        sink = ltn12.sink.table(respbody),
        redirect = true
    }

    -- nil, code, headers, status
    local response = nil

    if url:starts('https') then
        options.redirect = false
        response = {https.request(options)}
    else
        response = {http.request(options)}
    end

    local code = response[2]
    local headers = response[3]
    local status = response[4]

    if code ~= 200 then return nil end

    file_name = file_name or get_http_file_name(url, headers)

    local file_path = "data/"..file_name
    -- print("Saved to: "..file_path)
    -- uncomment if needed
    file = io.open(file_path, "w+")
    file:write(table.concat(respbody))
    file:close()

    return file_path
end
function run_command(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    cmd:close()
    return result
end
function string:isempty()
    return self == nil or self == ""
end

-- Returns true if the string is blank
function string:isblank()
    self = self:trim()
    return self:isempty()
end

-- DEPRECATED!!!!!
function string.starts(String, Start)
    -- print("string.starts(String, Start) is DEPRECATED use string:starts(text) instead")
    -- uncomment if needed
    return Start == string.sub(String,1,string.len(Start))
end

-- Returns true if String starts with Start
function string:starts(text)
    return text == string.sub(self,1,string.len(text))
end

function lock_photos(msg)
    if not msg.Director then
        return "-› هذا الامر يخص {المدير,المالك,Dev} فقط  ."
    end
    redis:set(max.."getidstatus"..msg.chat_id_, "Simple")
    return  "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم تعطيل الايدي بالصوره."
end
function unlock_photos(msg)
    if not msg.Director then
        return "-› هذا الامر يخص {المدير,المالك,Dev} فقط  ."
    end
    redis:set(max.."getidstatus"..msg.chat_id_, "Photo")
    return  "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم تفعيل الايدي بالصوره."
end
function cmds_on(msg)
    if not msg.Creator then return "-› هذا الامر يخص\n-(المالك، Dev) فقط ."
    end
    redis:set(max..'lock:kara:'..msg.chat_id_,'on')
    return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم تعطيل الرفع في المجموعه."
end
function cmds_off(msg)
    if not msg.Creator then return "-› هذا الامر يخص\n-(المالك، Dev) فقط ."
    end
    redis:set(max..'lock:kara:'..msg.chat_id_,'off')
    return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم تفعيل الرفع في المجموعه."
end

function lockjoin(msg)
    if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ."
    end
    redis:set(max..'lock:join:'..msg.chat_id_,true)
    return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n-تم قفل الدخول بالرابط."

end
function unlockjoin(msg)
    if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ."
    end
    redis:del(max..'lock:join:'..msg.chat_id_)
    return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n-تم فتح الدخول بالرابط."
end







local function imax(msg,MsgText)
    if msg.type ~= 'pv' then


        if MsgText[1] == "تفعيل" and not MsgText[2] then
            redis:set(max.."getidstatus"..msg.chat_id_, "Photo")
            redis:set(max..'lock:kara:'..msg.chat_id_,'off')
            return modadd(msg)
        end
        if MsgText[1] == "تعطيل" and not MsgText[2] then
            return modrem(msg)
        end
        if MsgText[1] == "تفعيل الايدي بالصوره" and not MsgText[2] then
            return unlock_photos(msg)
        end
        if MsgText[1] == "تعطيل الايدي بالصوره" and not MsgText[2] then
            return lock_photos(msg)
        end
        if MsgText[1] == "تعطيل الرفع" and not MsgText[2] then
            return cmds_on(msg)
        end
        if MsgText[1] == "تفعيل الرفع" and not MsgText[2] then
            return cmds_off(msg)
        end

        if MsgText[1] == "قفل الدخول بالرابط" and not MsgText[2] then
            return lockjoin(msg)
        end
        if MsgText[1] == "فتح الدخول بالرابط" and not MsgText[2] then
            return unlockjoin(msg)
        end

    end

    if msg.type ~= 'pv' and msg.GroupActive then




        if MsgText[1] == "المجموعة" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            GetFullChat(msg.chat_id_,function(arg,data)
                local GroupName = (redis:get(max..'group:name'..msg.chat_id_) or "")
                redis:set(max..'linkGroup'..msg.chat_id_,(data.invite_link_ or ""))
                return sendMsg(msg.chat_id_,msg.id_,
                        "- *(*  ["..FlterName(GroupName).."]("..(data.invite_link_ or "")..")  *)* \n\n"
                                .."- عدد الاعضاء ⇜ *(* "..data.member_count_.." *)*"
                                .."\n- عدد المحظورين ⇜ *(* "..data.kicked_count_.." *)*"
                                .."\n- عدد المشرفين ⇜ *(*"..data.administrator_count_.."*)* ".."\n- ايدي المجموعة ⇜ *(*"..msg.chat_id_.."*)*"
                                .." \n"
                )
            end,nil)
            return false
        end

        if MsgText[1] == "التفاعل" then
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="active"})
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="active"})
            end
            return false
        end


        if MsgText[1] == "اضف رد مطور" then
            if not msg.Creator then return "-› هذا الامر يخص المالك فقط ." end
            redis:setex(max..'addpro:'..msg.chat_id_..msg.sender_user_id_,300,true)
            redis:del(max..'replaypro:'..msg.chat_id_..msg.sender_user_id_)
            return "-› حسناً الان ارسل كلمة الرد المطور ."
        end

        if MsgText[1] == "مسح رد مطور" then
            if not msg.Creator then return "-› هذا الامر يخص المالك فقط ." end
            return RemProf(msg, MsgText[2])
        end

        if MsgText[1] == "منع" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return AddFilter(msg, MsgText[2])
        end

        if MsgText[1] == "الغاء منع" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return RemFilter(msg, MsgText[2])
        end

        if MsgText[1] == "قائمة المنع" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return FilterXList(msg)
        end

        if MsgText[1] == "الحمايه" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return settingsall(msg)
        end

        if MsgText[1] == "الاعدادات" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return settings(msg)
        end

        if MsgText[1] == "الوسائط" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return media(msg)
        end

        if MsgText[1] == "نائبين المدراء" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return GetListAdmin(msg)
        end

        if MsgText[1] == "يبيبيبيبيب" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub('-100',""), offset_ = 0,limit_ = 200
            },function(ta,taha)
                local t = "\n- قائمة الاعضاء - \n"
                x = 0
                local list = taha.members_
                for k, v in pairs(list) do
                    x = x + 1
                    t = t..""..x.." - {["..v.user_id_.."](tg://user?id="..v.user_id_..")} \n"
                end
                send_msg(msg.chat_id_,t,msg.id_)
            end,nil)
        end

        if MsgText[1] == "كشف المجموعة" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return ownerlist(msg) .. GetListAdmin(msg) .. whitelist(msg)
        end
---============(منشن)=============--


---============(منشن)=============--

        if MsgText[1] == "منشن للكل" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return ownerlist(msg) .. maliklist(msg) .. GetListAdmin(msg) .. whitelist(msg)
        end

        if MsgText[1] == "المالك الاساسي" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return maliklist(msg)
        end

        if MsgText[1] == "المدراء" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return ownerlist(msg)
        end
--[[
        if MsgText[1] == "المالك الاساسي" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return Hussainlist(msg)
        end
]]
        if MsgText[1] == "المميزين" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            return whitelist(msg)
        end


        if MsgText[1] == "صلاحياته" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if tonumber(msg.reply_to_message_id_) ~= 0 then
                function prom_reply(extra, result, success)
                    Get_Info(msg,msg.chat_id_,result.sender_user_id_)
                end
                tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},prom_reply, nil)
            end
        end
        if MsgText[1] == "صلاحياتي" then
            if tonumber(msg.reply_to_message_id_) == 0 then
                Get_Info(msg,msg.chat_id_,msg.sender_user_id_)
            end
        end
        if MsgText[1] == "صلاحياته" and MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if tonumber(msg.reply_to_message_id_) == 0 then
                local username = MsgText[2]
                function prom_username(extra, result, success)
                    if (result and result.code_ == 400 or result and result.message_ == "USERNAME_NOT_OCCUPIED") then
                        return sendMsg(msg.chat_id_,msg.id_,'- المعرف غير صحيح .')
                    end
                    if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
                        return sendMsg(msg.chat_id_,msg.id_,'- هذا معرف قناة .')
                    end
                    Get_Info(msg,msg.chat_id_,result.id_)
                end
                tdcli_function ({ID = "SearchPublicChat",username_ = username},prom_username,nil)
            end
        end
        if MsgText[1] == "فحص البوت" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            local Chek_Info = https.request('https://api.telegram.org/bot'..Token..'/getChatMember?chat_id='.. msg.chat_id_ ..'&user_id='.. max.."")
            local Json_Info = JSON.decode(Chek_Info)
            if Json_Info.ok == true then
                if Json_Info.result.status == "administrator" then
                    if Json_Info.result.can_change_info == true then
                        info = 'ꪜ' else info = '✘' end
                    if Json_Info.result.can_delete_messages == true then
                        delete = 'ꪜ' else delete = '✘' end
                    if Json_Info.result.can_invite_users == true then
                        invite = 'ꪜ' else invite = '✘' end
                    if Json_Info.result.can_pin_messages == true then
                        pin = 'ꪜ' else pin = '✘' end
                    if Json_Info.result.can_restrict_members == true then
                        restrict = 'ꪜ' else restrict = '✘' end
                    if Json_Info.result.can_promote_members == true then
                        promote = 'ꪜ' else promote = '✘' end
                    return sendMsg(msg.chat_id_,msg.id_,'\n- أهلاًً عزيزي البوت هنا مشرف بالمجموعة \n- وصلاحياته هي  \n\n- تغير معلومات المجموعه ↞ ❪ '..info..' ❫\n- حذف الرسائل ↞ ❪ '..delete..' ❫\n- حظر المستخدمين ↞ ❪ '..restrict..' ❫\n- دعوة مستخدمين ↞ ❪ '..invite..' ❫\n- تثبيت الرسائل ↞ ❪ '..pin..' ❫\n- اضافة مشرفين جدد ↞ ❪ '..promote..' ❫\n\n- ملاحظة » علامة ❪  ꪜ ❫ تعني لديه الصلاحية وعلامة ❪ ✘ ❫ تعني ليس لديه الصلاحيه')
                end
            end
        end

        if MsgText[1] == "تثبيت" and msg.reply_id then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            local GroupID = msg.chat_id_:gsub('-100',"")
            if not msg.Director and redis:get(max..'lock_pin'..msg.chat_id_) then
                return "- لا يمكنك التثبيت الامر مقفول من قبل الاداره"
            else
                tdcli_function({
                    ID="PinChannelMessage",
                    channel_id_ = GroupID,
                    message_id_ = msg.reply_id,
                    disable_notification_ = 1},
                        function(arg,data)
                            if data.ID == "Ok" then
                                redis:set(max..":MsgIDPin:"..msg.chat_id_,msg.reply_id)
                                return sendMsg(msg.chat_id_,msg.id_,"-› أهلاً عزيزي "..msg.TheRankCmd.." \n- تم تثبيت الرساله.")
                            elseif data.ID == "Error" and data.code_ == 6 then
                                return sendMsg(msg.chat_id_,msg.id_,'- عذرا لا يمكنني التثبيت .\n- لست مشرف او لا املك صلاحيه التثبيت .')
                            end
                        end,nil)
            end
            return false
        end


        if MsgText[1] == "الغاء التثبيت" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            if not msg.Director and redis:get(max..'lock_pin'..msg.chat_id_) then
                return "- لا يمكنك الغاء التثبيت الامر مقفول من قبل الاداره"
            else
                local GroupID = msg.chat_id_:gsub('-100',"")
                tdcli_function({ID="UnpinChannelMessage",channel_id_ = GroupID},
                        function(arg,data)
                            if data.ID == "Ok" then
                                return sendMsg(msg.chat_id_,msg.id_,"-› أهلاً عزيزي "..msg.TheRankCmd.."  \n- تم الغاء تثبيت الرساله.")
                            elseif data.ID == "Error" and data.code_ == 6 then
                                return sendMsg(msg.chat_id_,msg.id_,'- عذرا لا يمكنني الغاء التثبيت .\n- لست مشرف او لا املك صلاحيه التثبيت .')
                            elseif data.ID == "Error" and data.code_ == 400 then
                                return sendMsg(msg.chat_id_,msg.id_,'- عذرا عزيزي '..msg.TheRankCmd..' .\n- لا توجد رساله مثبته لاقوم بازالتها .')
                            end
                        end,nil)
            end
            return false
        end


        if MsgText[1] == "تقييد" then
		if msg.SudoBaseP then return "وبعدين معاك كوني؟"
            elseif not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="tqeed"})
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="tqeed"})
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="tqeed"})
            end
            return false
        end

        if MsgText[1] == "فك التقييد" or MsgText[1] == "فك تقييد" then
		if msg.SudoBaseP then return "مسويه خوي ههه"
            elseif not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="fktqeed"})
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="fktqeed"})
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="fktqeed"})
            end
            return false
        end


        if MsgText[1] == "رفع مميز" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            if not MsgText[2] and msg.reply_id then
                if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                    GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="setwhitelist"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                if MsgText[2] and MsgText[2]:match('^%d+$') then
                    GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="setwhitelist"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                    GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="setwhitelist"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'on' then
                sendMsg(msg.chat_id_,msg.id_,"-› أهلاً عزيزي "..msg.TheRankCmd.."\n- الرفع معطل.")
            end
            return false
        end


        if MsgText[1] == "تنزيل مميز" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="remwhitelist"})
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="remwhitelist"})
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="remwhitelist"})
            end
            return false
        end


        if (MsgText[1] == "رفع المدير"  or MsgText[1] == "رفع مدير" )  then
            if not msg.Creator then return "-› هذا الامر يخص\n {Dev,المالك} فقط ." end
            if not MsgText[2] and msg.reply_id then
                if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                    GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="setowner"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                if MsgText[2] and MsgText[2]:match('^%d+$') then
                    GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="setowner"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                    GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="setowner"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'on' then
                sendMsg(msg.chat_id_,msg.id_,"-› أهلاً عزيزي "..msg.TheRankCmd.."\n- الرفع معطل.")
            end
            return false
        end


        if (MsgText[1] == "تنزيل المدير" or MsgText[1] == "تنزيل مدير" )  then
            if not msg.Creator then return "-› هذا الامر يخص\n {Dev,المالك} فقط ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="remowner"})
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="remowner"})
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="remowner"})
            end
            return false
        end


        if (MsgText[1] == "رفع مالك اساسي" or MsgText[1] == "رفع المالك اساسي")  then
            if not msg.SudoUser then return "-› هذا الامر يخص (Dev,Myth) فقط ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="setkara"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="setkara"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="setkara"})
                return false
            end
        end

        if (MsgText[1] == "تنزيل مالك اساسي" or MsgText[1] == "تنزيل المالك اساسي")  then
            if not msg.SudoUser then return "-› هذا الامر يخص\n- (Dev,Myth) ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="remkara"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="remkara"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="remkara"})
                return false
            end
        end


        if (MsgText[1] == "رفع مالك" or MsgText[1] == "رفع المالك")  then
            if not msg.Kara then return ".-› هذا الامر يخص\n-(المالك الأساسي، Dev، Myth) فقط ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="setmnsha"})
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="setmnsha"})
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="setmnsha"})
            end
            return false
        end


        if (MsgText[1] == "تنزيل مالك" or MsgText[1] == "تنزيل المالك" )  then
            if not msg.Kara then return "-› هذا الامر يخص\n- (Dev,المالك الاساسي) فقط ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="remmnsha"})
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="remmnsha"})
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="remmnsha"})
            end
            return false
        end


        if MsgText[1] == "رفع نائب مدير" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if not MsgText[2] and msg.reply_id then
                if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                    GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="promote"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                if MsgText[2] and MsgText[2]:match('^%d+$') then
                    GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="promote"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'off' then
                if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                    GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="promote"})
                end
            end
            if redis:get(max..'lock:kara:'..msg.chat_id_) == 'on' then
                sendMsg(msg.chat_id_,msg.id_,"-› أهلاً عزيزي "..msg.TheRankCmd.."\n- الرفع معطل.")
            end
            return false
        end



        if MsgText[1] == "تنزيل نائب مدير" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="demote"})
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="demote"})
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="demote"})
            end
            return false
        end


        if MsgText[1] == "تنزيل الكل" then



            if not msg.SudoBase then

                if not msg.Creator then return "-› هذا الامر يخص\n {Dev,المالك} فقط ." end

                local Admins = redis:scard(max..'admins:'..msg.chat_id_)
                redis:del(max..'admins:'..msg.chat_id_)
                local NumMDER = redis:scard(max..'owners:'..msg.chat_id_)
                redis:del(max..'owners:'..msg.chat_id_)
                local MMEZEN = redis:scard(max..'whitelist:'..msg.chat_id_)
                redis:del(max..'whitelist:'..msg.chat_id_)

                return "-› أهلاً عزيزي "..msg.TheRankCmd.." \n- تم تنزيل ❴ "..Admins.." ❵ من نائبين المدراء\n- تم تنزيل ❴ "..NumMDER.." ❵ من المدراء\n-› تم تنزيل ❴ "..MMEZEN.." ❵ من المميزين\n\n- تم تنزيل الكل ."



            else
                local Creator = redis:scard(max..'creators:'..msg.chat_id_)
                redis:del(max..'admins:'..msg.chat_id_)
                local NumMDER = redis:scard(max..'owners:'..msg.chat_id_)
                redis:del(max..'owners:'..msg.chat_id_)
                local MMEZEN = redis:scard(max..'whitelist:'..msg.chat_id_)
                redis:del(max..'whitelist:'..msg.chat_id_)
                local Admins = redis:scard(max..'admins:'..msg.chat_id_)
                redis:del(max..'admins:'..msg.chat_id_)


            end
        end


        --{ Commands For locks }

        if MsgText[1] == "قفل" then

            if MsgText[2] == "الكل"		 then return lock_All(msg) end
            if MsgText[2] == "الوسائط" 	 then return lock_Media(msg) end
            if MsgText[2] == "الصور بالتقييد" 	 then return tqeed_photo(msg) end
            if MsgText[2] == "الفيديو بالتقييد"  then return tqeed_video(msg) end
            if MsgText[2] == "المتحركه بالتقييد" then return tqeed_gif(msg) end
            if MsgText[2] == "التوجيه بالتقييد"  then return tqeed_fwd(msg) end
            if MsgText[2] == "الروابط بالتقييد"  then return tqeed_link(msg) end
            if MsgText[2] == "الدردشه"    	     then return mute_text(msg) end
            if MsgText[2] == "المتحركه" 		 then return mute_gif(msg) end
            if MsgText[2] == "الصور" 			 then return mute_photo(msg) end
            if MsgText[2] == "الفيديو"			 then return mute_video(msg) end
            if MsgText[2] == "البصمات" 		then  return mute_audio(msg) end
            if MsgText[2] == "الصوت" 		then return mute_voice(msg) end
            if MsgText[2] == "الملصقات" 	then return mute_sticker(msg) end
            if MsgText[2] == "الجهات" 		then return mute_contact(msg) end
            if MsgText[2] == "التوجيه" 		then return mute_forward(msg) end
            if MsgText[2] == "الموقع"	 	then return mute_location(msg) end
            if MsgText[2] == "الملفات" 		then return mute_document(msg) end
            if MsgText[2] == "الاشعارات" 	then return mute_tgservice(msg) end
            if MsgText[2] == "الانلاين" 		then return mute_inline(msg) end
            if MsgText[2] == "الكيبورد" 	then return mute_keyboard(msg) end
            if MsgText[2] == "الروابط" 		then return lock_link(msg) end
            if MsgText[2] == "التاك" 		then return lock_tag(msg) end
            if MsgText[2] == "المعرفات" 	then return lock_username(msg) end
            if MsgText[2] == "التعديل" 		then return lock_edit(msg) end
            if MsgText[2] == "الكلايش" 		then return lock_spam(msg) end
            if MsgText[2] == "التكرار" 		then return lock_flood(msg) end
            if MsgText[2] == "البوتات" 		then return lock_bots(msg) end
            if MsgText[2] == "البوتات بالطرد" 	then return lock_bots_by_kick(msg) end
            if MsgText[2] == "الماركدوان" 	then return lock_markdown(msg) end
            if MsgText[2] == "الويب" 		then return lock_webpage(msg) end
            if MsgText[2] == "التثبيت" 		then return lock_pin(msg) end
        end

        --{ Commands For Unlocks }
        if MsgText[1] == "فتح" 		then
            if MsgText[2] == "الكل" then return Unlock_All(msg) end
            if MsgText[2] == "الوسائط" then return Unlock_Media(msg) end
            if MsgText[2] == "الصور بالتقييد" 		then return fktqeed_photo(msg) 	end
            if MsgText[2] == "الفيديو بالتقييد" 	then return fktqeed_video(msg) 	end
            if MsgText[2] == "المتحركه بالتقييد" 	then return fktqeed_gif(msg) 	end
            if MsgText[2] == "التوجيه بالتقييد" 	then return fktqeed_fwd(msg) 	end
            if MsgText[2] == "الروابط بالتقييد" 	then return fktqeed_link(msg) 	end
            if MsgText[2] == "المتحركه" 	then return unmute_gif(msg) 	end
            if MsgText[2] == "الدردشه" 		then return unmute_text(msg) 	end
            if MsgText[2] == "الصور" 		then return unmute_photo(msg) 	end
            if MsgText[2] == "الفيديو" 		then return unmute_video(msg) 	end
            if MsgText[2] == "البصمات" 		then return unmute_audio(msg) 	end
            if MsgText[2] == "الصوت" 		then return unmute_voice(msg) 	end
            if MsgText[2] == "الملصقات" 	then return unmute_sticker(msg) end
            if MsgText[2] == "الجهات" 		then return unmute_contact(msg) end
            if MsgText[2] == "التوجيه" 		then return unmute_forward(msg) end
            if MsgText[2] == "الموقع" 		then return unmute_location(msg) end
            if MsgText[2] == "الملفات" 		then return unmute_document(msg) end
            if MsgText[2] == "الاشعارات" 	then return unmute_tgservice(msg) end
            if MsgText[2] == "الانلاين" 		then return unmute_inline(msg) 	end
            if MsgText[2] == "الكيبورد" 	then return unmute_keyboard(msg) end
            if MsgText[2] == "الروابط" 		then return unlock_link(msg) 	end
            if MsgText[2] == "التاك" 		then return unlock_tag(msg) 	end
            if MsgText[2] == "المعرفات" 	then return unlock_username(msg) end
            if MsgText[2] == "التعديل" 		then return unlock_edit(msg) 	end
            if MsgText[2] == "الكلايش" 		then return unlock_spam(msg) 	end
            if MsgText[2] == "التكرار" 		then return unlock_flood(msg) 	end
            if MsgText[2] == "البوتات" 		then return unlock_bots(msg) 	end
            if MsgText[2] == "البوتات بالطرد" 	then return unlock_bots_by_kick(msg) end
            if MsgText[2] == "الماركدوان" 	then return unlock_markdown(msg) end
            if MsgText[2] == "الويب" 		then return unlock_webpage(msg) 	end
            if MsgText[2] == "التثبيت" 		then return unlock_pin(msg) end
        end

        if MsgText[1] == "انشاء رابط" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if not redis:get(max..'ExCmdLink'..msg.chat_id_) then
                local LinkGp = ExportLink(msg.chat_id_)
                if LinkGp then
                    LinkGp = LinkGp.result
                    redis:set(max..'linkGroup'..msg.chat_id_,LinkGp)
                    redis:setex(max..'ExCmdLink'..msg.chat_id_,120,true)
                    return sendMsg(msg.chat_id_,msg.id_,"-› تم انشاء رابط جديد \n- | "..LinkGp.." |.")
                else
                    return sendMsg(msg.chat_id_,msg.id_,"-› لا يمكنني انشاء رابط للمجموعه .\n- لانني لست مشرف في المجموعه .")
                end
            else
                return sendMsg(msg.chat_id_,msg.id_,"-› لقد قمت بانشاء الرابط سابقا .\n- ارسل { الرابط } لرؤبة الرابط .")
            end
            return false
        end

        if MsgText[1] == "ضع رابط" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            redis:setex(max..'linkGroup'..msg.sender_user_id_,300,true)
            return '- أرسل الرابط الحين .'
        end

        if MsgText[1] == "الرابط" then
            if not redis:get(max..'linkGroup'..msg.chat_id_) then
                return "- لا يوجد رابط اكتب انشاء رابط لإتشاء رابط ."
            end
            local GroupName = redis:get(max..'group:name'..msg.chat_id_)
            local GroupLink = redis:get(max..'linkGroup'..msg.chat_id_)
            local gu = " ["..GroupName.."]("..GroupLink..") "
            return sendMsgg(msg.chat_id_,msg.id_,gu)
        end
    end


    if MsgText[1] == "الرابط خاص" then
        if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
        local GroupLink = redis:get(max..'linkGroup'..msg.chat_id_)
        if not GroupLink then return "- لا يوجد رابط اكتب انشاء رابط لإتشاء رابط ." end
        local Text = "- رابط المجموعة: \n- "..Flter_Markdown(redis:get(max..'group:name'..msg.chat_id_)).." :\n\n["..GroupLink.."]\n"
        local info, res = https.request(ApiToken..'/sendMessage?chat_id='..msg.sender_user_id_..'&text='..URL.escape(Text)..'&disable_web_page_preview=true&parse_mode=Markdown')
        if res == 403 then
            return "-› عذرا عزيزي \n- لم استطيع ارسالك الرابط لانك قمت بحظر البوت ."
        elseif res == 400 then
            return "-› عذرا عزيزي \n- لم استطيع ارسالك الرابط يجب عليك مراسله البوت اولا ."
        end
        if res == 200 then
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."  \n- تم ارسال الرابط خاص لك ."
        end
    end

    if MsgText[1] == "تحديث" then
        if not msg.SudoBaseA then return false end
        relaoding(msg)
    end

    function run_bash(str)
        local cmd = io.popen(str)
        local result = cmd:read('*all')
        cmd:close()
        return result
    end

    
   if MsgText[1]  == "يوتيوب!" and MsgText[2] then

url = "https://i1bot.com/main/Beso/t.php?s="..URL.escape(MsgText[2]).."&chat="..msg.chat_id_.."&Token="..Token.."&msgid="..msg.id_/2097152/0.5
print(url)
print(https.request(url))
end

    if MsgText[1] == "يوتيوب؟" and MsgText[2]  then
        if
        redis:get(max..'lock_yt'..msg.chat_id_) then

            local ip = {"2a07:3b80:1::f060","2a07:3b80:1::ee63","2a07:3b80:1::de2a","2a07:3b80:1::d433","2a07:3b80:1::6457"}

            text = run_bash('youtube-dl -o "tmp1/%(title)s.%(ext)s" --source-address '..ip[math.random(#ip)]..' -f mp4 "ytsearch:'..MsgText[2]..'"')
            audio = string.match(text, '%[download%] Destination: tmp1/(.*).mp4') or string.match(text, '%[download%] tmp1/(.*).mp4 has already been downloaded')
            file = 'tmp1/'..audio..'.mp4'

            sendVideo(msg.chat_id_,msg.id_, file)

        end
    end

    if MsgText[1] == "ساوند؟" and MsgText[2] then
        if
        redis:get(max..'lock_yt'..msg.chat_id_) then

            local URL = MsgText[1]


            text = run_bash('youtube-dl -o "tmp/%(title)s.%(ext)s" "scsearch:'..MsgText[2]..'"')
            audio = string.match(text, '%[download%] Destination: tmp/(.*).mp3') or string.match(text, '%[download%] tmp/(.*).mp3 has already been downloaded')
            file = 'tmp/'..audio..'.mp3'


            sendAudio(msg.chat_id_,msg.id_, file,audio,'@AH8iBot','𝗖𝗵𝗮 ➤ @rnnni')
        end
    end


    if MsgText[1] == "ضع القوانين" then
        if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
        redis:setex(max..'rulse:witting'..msg.sender_user_id_.." "..msg.chat_id_,300,true)
        return '-› حسناً عزيزي \n- الان ارسل القوانين  للمجموعه .'
    end

    if MsgText[1] == "القوانين" then
        if not redis:get(max..'rulse:msg'..msg.chat_id_) then
            return " الابتعاد عن الألفاظ القذرة.\n- الابتعاد عن العنصرية.\n- عدم نشر صور ومقاطع غير اخلاقية.\n- احترام مالك القروب واعضاء القروب."
        else
            return "*⤦ القوانين ⤥*\n"..redis:get(max..'rulse:msg'..msg.chat_id_)
        end
    end


    if MsgText[1] == "ضع تكرار" then
        if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
        local NumLoop = tonumber(MsgText[2])
        if NumLoop < 1 or NumLoop > 50 then
            return "-› حدود التكرار,  يجب أن تكون ما بين  *(2-50)*"
        end
        redis:set(max..'flood'..msg.chat_id_,MsgText[2])
        return "-› تم وضع التكرار *| "..MsgText[2].." |*."
    end



    if MsgText[1] == "مسح" then
        if not MsgText[2] and msg.reply_id then
            if not msg.Admin then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            Del_msg(msg.chat_id_, msg.reply_id)
            Del_msg(msg.chat_id_, msg.id_)
            return false
        end
        --[[
                if MsgText[2] and MsgText[2]:match('^%d+$') then
                    if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
                    if 100 < tonumber(MsgText[2]) then return "- حدود المسح ,  يجب ان تكون ما بين  *[2-100]*" end
                    local DelMsg = MsgText[2] + 1
                    GetHistory(msg.chat_id_,DelMsg,function(arg,data)
                        All_Msgs = {}
                        for k, v in pairs(data.messages_) do
                            if k ~= 0 then
                                if k == 1 then
                                    All_Msgs[0] = v.id_
                                else
                                    table.insert(All_Msgs,v.id_)
                                end
                            end
                        end
                        if tonumber(DelMsg) == data.total_count_ then
                            tdcli_function({ID="DeleteMessages",chat_id_ = msg.chat_id_,message_ids_=All_Msgs},function()
                                sendMsg(msg.chat_id_,msg.id_,"- تـم مسح ↜ { *"..MsgText[2].."* } من الرسائل.")
                            end,nil))
                        else
                            tdcli_function({ID="DeleteMessages",chat_id_=msg.chat_id_,message_ids_=All_Msgs},function()
                                sendMsg(msg.chat_id_,msg.id_,"- تـم مسح ↜ { *"..MsgText[2].."* } من الرسائل .")
                            end,nil))
                        end
                    end)
                    return false
                end
        ]]
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            if not msg.Admin then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if 500 < tonumber(MsgText[2]) then return "- حدود المسح ,  يجب ان تكون ما بين  *[2-100]*" end
            local DelMsg = MsgText[2] + 1
            GetHistory(msg.chat_id_,DelMsg,function(arg,data)
                All_Msgs = {}
                for k, v in pairs(data.messages_) do
                    if k ~= 0 then
                        if k == 1 then
                            All_Msgs[0] = v.id_
                        else
                            table.insert(All_Msgs,v.id_)
                        end
                    end
                end
                if tonumber(DelMsg) == data.total_count_ then
                    pcall(tdcli_function({ID="DeleteMessages",chat_id_=msg.chat_id_,message_ids_=All_Msgs},function()
                        sendMsg(msg.chat_id_,msg.id_,"- تـم مسح ↜ { *"..MsgText[2].."* } من الرسائل.")
                    end,nil))
                else
                    pcall(tdcli_function({ID="DeleteMessages",chat_id_=msg.chat_id_,message_ids_=All_Msgs},function()
                        sendMsg(msg.chat_id_,msg.id_,"- تـم مسح ↜ { *"..MsgText[2].."* } من الرسائل.")
                    end,nil))
                end
            end)
            return false
        end

        if MsgText[2] == "نائبين المدراء" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end

            local Admins = redis:scard(max..'admins:'..msg.chat_id_)
            if Admins ==0 then
                return "- عذرا لا يوجد نائبين مدراء ليتم مسحهم ."
            end
            redis:del(max..'admins:'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n-تم مسح {"..Admins.."} من نائبين المدراء في البوت."
        end


        if MsgText[2] == "قائمة المنع" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            local Mn3Word = redis:scard(max..':Filter_Word:'..msg.chat_id_)
            if Mn3Word == 0 then
                return "-› عذرا لا توجد كلمات ممنوعه ليتم حذفها."
            end
            redis:del(max..':Filter_Word:'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."   \n- تم مسح {*"..Mn3Word.."*} كلمات من المنع."
        end


        if MsgText[2] == "القوانين" then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if not redis:get(max..'rulse:msg'..msg.chat_id_) then
                return "-› عذراً لا توجد قوانين ليتم مسحها ."
            end
            redis:del(max..'rulse:msg'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n-تم حذف القوانين بنجاح."
        end


        if MsgText[2] == "الترحيب"  then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if not redis:get(max..'welcome:msg'..msg.chat_id_) then
                return "- لا يوجد ترحيب للمجموعة ."
            end
            redis:del(max..'welcome:msg'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n-تم حذف الترحيب بنجاح."
        end


        if MsgText[2] == "المالك الاساسي" then
            if not msg.SudoUser then return "-› هذا الامر يخص \n- ( Dev ) فقط  ." end
            local NumMnsha = redis:scard(max..':KARA_BOT:'..msg.chat_id_)
            if NumMnsha ==0 then
                return "-› عذرا لا يوجد مالك اساسي \n!"
            end
            redis:del(max..':KARA_BOT:'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم مسح {* "..NumMnsha.." *} المالك الاساسي."
        end


        if MsgText[2] == "المالكين" then
            if not msg.SudoUser then return "-› هذا الامر يخص \n- ( Dev ) فقط  ." end
            local NumMnsha = redis:scard(max..':MONSHA_BOT:'..msg.chat_id_)
            if NumMnsha ==0 then
                return "-› عذرا لا يوجد مالكين ليتم مسحهم ."
            end
            redis:del(max..':MONSHA_BOT:'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم مسح {* "..NumMnsha.." *} من المالكيين."
        end


        if MsgText[2] == "المدراء" then
            if not msg.Creator then return "- هذا الامر يخص \n{Dev,المالك,المدير} فقط ." end
            local NumMDER = redis:scard(max..'owners:'..msg.chat_id_)
            if NumMDER ==0 then
                return "-› عذرا لا يوجد مدراء ليتم مسحهم \n!"
            end
            redis:del(max..'owners:'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم مسح {* "..NumMDER.." *} من المدراء."
        end

        if MsgText[2] == 'المحظورين' then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end

            local list = redis:smembers(max..'banned:'..msg.chat_id_)
            if #list == 0 then return "- لا يوجد مستخدمين محظورين  ." end
            message = '-› قائمة الاعضاء المحظورين :\n'
            for k,v in pairs(list) do
                StatusLeft(msg.chat_id_,v)
            end
            redis:del(max..'banned:'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."   \n- تم مسح {* "..#list.." *} من المحظورين."
        end

        if MsgText[2] == 'المكتومين' then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            local MKTOMEN = redis:scard(max..'is_silent_users:'..msg.chat_id_)
            if MKTOMEN ==0 then
                return "-› لا يوجد مستخدمين مكتومين في المجموعه "
            end
            redis:del(max..'is_silent_users:'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم مسح {* "..MKTOMEN.." *} من المكتومين."
        end

        if MsgText[2] == 'المميزين' then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            local MMEZEN = redis:scard(max..'whitelist:'..msg.chat_id_)
            if MMEZEN ==0 then
                return "- لا يوجد مستخدمين مميزين في المجموعه ."
            end
            redis:del(max..'whitelist:'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم مسح {* "..MMEZEN.." *} من المميزين."
        end


        if MsgText[2] == 'الرابط' then
            if not msg.Director then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
            if not redis:get(max..'linkGroup'..msg.chat_id_) then
                return "- لا يوجد رابط مضاف اصلا "
            end
            redis:del(max..'linkGroup'..msg.chat_id_)
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n-تم مسح رابط المجموعه."
        end


    end
    --End del


    if MsgText[1] == "ضع اسم" then
        if not msg.Creator then return "-› هذا الامر يخص\n {Dev,المالك} فقط ." end
        redis:setex(max..'name:witting'..msg.sender_user_id_.." "..msg.chat_id_,300,true)
        return "-› حسناً عزيزي  \n- لان ارسل الاسم  للمجموعه ."
    end


    if MsgText[1] == "مسح الصوره" then
        if not msg.Creator then return "- هذا الامر يخص {Dev,المالك} فقط  \n??" end
        https.request(ApiToken.."/deleteChatPhoto?chat_id="..msg.chat_id_)
        return sendMsg(msg.chat_id_,msg.id_,'- تم مسح صورة المجموعة . ')
    end


    if MsgText[1] == "ضع صوره" then
        if not msg.Creator then return "-› هذا الامر يخص\n {Dev,المالك} فقط ." end
        if msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,function(arg, data)
                if data.content_.ID == 'MessagePhoto' then
                    if data.content_.photo_.sizes_[3] then
                        photo_id = data.content_.photo_.sizes_[3].photo_.persistent_id_
                    else
                        photo_id = data.content_.photo_.sizes_[0].photo_.persistent_id_
                    end
                    tdcli_function({ID="ChangeChatPhoto",chat_id_ = msg.chat_id_,photo_ = GetInputFile(photo_id)},
                            function(arg,data)
                                if data.ID == "Ok" then
                                    --return sendMsg(msg.chat_id_,msg.id_,'- تم تغيير صورة المجموعة⠀.')
                                elseif  data.code_ == 3 then
                                    return sendMsg(msg.chat_id_,msg.id_,'- ليس لدي صلاحيه تغيير الصوره \n- يجب اعطائي صلاحيه `تغيير معلومات المجموعه ` ⠀.')
                                end
                            end, nil)
                end

            end ,nil)
            return false
        else
            redis:setex(max..'photo:group'..msg.chat_id_..msg.sender_user_id_,300,true)
            return '-› حسناً عزيزي \n- الان قم بارسال الصورة .'
        end
    end


    if MsgText[1] == "ضع وصف" then
        if not msg.Creator then return "-› هذا الامر يخص\n {Dev,المالك} فقط ." end
        redis:setex(max..'about:witting'..msg.sender_user_id_.." "..msg.chat_id_,300,true)
        return "-› حسناً عزيزي  \n- الان ارسل الوصف  للمجموعة ."
    end


    if MsgText[1] == "طرد البوتات" then
        if not msg.Director then return "-› هذا الامر يخص\n {Dev,المالك} فقط ." end
        tdcli_function({ID="GetChannelMembers",channel_id_ = msg.chat_id_:gsub('-100',""),
                        filter_ ={ID="ChannelMembersBots"},offset_ = 0,limit_ = 50},function(arg,data)
            local Total = data.total_count_ or 0
            if Total == 1 then
                return sendMsg(msg.chat_id_,msg.id_,"- لا يوجد بوتات في المجموعة .")
            else
                local NumBot = 0
                local NumBotAdmin = 0
                for k, v in pairs(data.members_) do
                    if v.user_id_ ~= our_id then
                        kick_user(v.user_id_,msg.chat_id_,function(arg,data)
                            if data.ID == "Ok" then
                                NumBot = NumBot + 1
                            else
                                NumBotAdmin = NumBotAdmin + 1
                            end
                            local TotalBots = NumBot + NumBotAdmin
                            if TotalBots  == Total - 1 then
                                local TextR  = "- عـدد الـبـوتات * "..(Total - 1).." * \n\n"
                                if NumBot == 0 then
                                    TextR = TextR.."- لا يـمـكـن طردهم لانـهـم مشـرفـين .\n"
                                else
                                    if NumBotAdmin >= 1 then
                                        TextR = TextR.."- لم يتم طـرد {* "..NumBotAdmin.." *} بوت لأنهم مشرفين ."
                                    else
                                        TextR = TextR.."- تم طرد كل البوتات .\n"
                                    end
                                end
                                return sendMsg(msg.chat_id_,msg.id_,TextR)
                            end
                        end)
                    end
                end
            end

        end,nil)

        return false
    end


    if MsgText[1] == "كشف البوتات" then
        if not msg.Director then return "-› هذا الامر يخص\n- {Dev,المالك} فقط ." end
        tdcli_function({ID="GetChannelMembers",channel_id_ = msg.chat_id_:gsub('-100',""),
                        filter_ ={ID= "ChannelMembersBots"},offset_ = 0,limit_ = 50},function(arg,data)
            local total = data.total_count_ or 0
            AllBots = '- قائمة البوتات الـحالية\n\n'
            local NumBot = 0
            for k, v in pairs(data.members_) do
                GetUserID(v.user_id_,function(arg,data)
                    if v.status_.ID == "ChatMemberStatusEditor" then
                        BotAdmin = "» *★*"
                    else
                        BotAdmin = ""
                    end

                    NumBot = NumBot + 1
                    AllBots = AllBots..NumBot..'- @['..data.username_..'] '..BotAdmin..'\n'
                    if NumBot == total then
                        AllBots = AllBots..[[

- عندك {]]..total..[[} بوتات
- ملاحظة : الـ ★ تعنـي ان البوت مشرف في المجموعـة.]]
                        sendMsg(msg.chat_id_,msg.id_,AllBots)
                    end

                end,nil)
            end

        end,nil)
        return false
    end


    if MsgText[1] == 'طرد المحذوفين' then
        if not msg.Creator then return "-› هذا الامر يخص\n- {Dev,المالك} فقط ." end
        sendMsg(msg.chat_id_,msg.id_,'- جاري البحث عـن الـحـسـابـات المـحذوفـة .')
        tdcli_function({ID="GetChannelMembers",channel_id_ = msg.chat_id_:gsub('-100',"")
        ,offset_ = 0,limit_ = 200},function(arg,data)
            if data.total_count_ and data.total_count_ <= 200 then
                Total = data.total_count_ or 0
            else
                Total = 200
            end
            local NumMem = 0
            local NumMemDone = 0
            for k, v in pairs(data.members_) do
                GetUserID(v.user_id_,function(arg,datax)
                    if datax.type_.ID == "UserTypeDeleted" then
                        NumMemDone = NumMemDone + 1
                        kick_user(v.user_id_,msg.chat_id_,function(arg,data)
                            redis:srem(max..':MONSHA_BOT:'..msg.chat_id_,v.user_id_)
                            redis:srem(max..'whitelist:'..msg.chat_id_,v.user_id_)
                            redis:srem(max..'owners:'..msg.chat_id_,v.user_id_)
                            redis:srem(max..'admins:'..msg.chat_id_,v.user_id_)
                        end)
                    end
                    NumMem = NumMem + 1
                    if NumMem == Total then
                        if NumMemDone >= 1 then
                            sendMsg(msg.chat_id_,msg.id_,"- تم طـرد {* "..NumMemDone.." *} من الحسابات المحذوفة .")
                        else
                            sendMsg(msg.chat_id_,msg.id_,'- لا يوجد حسابات محذوفه في المجموعة .')
                        end
                    end
                end,nil)
            end
        end,nil)
        return false
    end




    --====================================== { Start New ID } ======================================--
    if MsgText[1] == "مسح الايدي"  then
        if not msg.Creator then return "-› هذا الامر يخص المالك فقط ." end
        if not redis:get(max.."ChatID"..msg.chat_id_) then
            return "- لا يوجد ايدي مخصص للمجموعة ."
        end
        redis:del(max.."ChatID"..msg.chat_id_)
        return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n-تم حذف الايدي بنجاح."
    end

    if MsgText[1] == "ضع الايدي" then
        if not msg.Creator then return "-› هذا الامر يخص المالك فقط ." end
        redis:set(max..'KID'..msg.chat_id_,true)
        return "-› حسناً عزيزي \n- ارسل الايدي اللي تبي  واستعمل هذي الدوال\n\n› #اليوزر\n› #الرتبة\n› #الرسائل\n› #ايدي\n› #التعديل \n› #بايو ."
    end





    if MsgText[1] == "ايدي" or MsgText[1]:lower() == "id" then

        if not MsgText[2] and not msg.reply_id then
            if redis:get(max..'lock_id'..msg.chat_id_) then
                local msgs = redis:get(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_) or 1
                GetUserID(msg.sender_user_id_,function(arg,data)
                    if data.username_ then UserNameID = "@"..data.username_.."" else UserNameID = "" end


                    if data.username_ then
                        text1 = run_bash('curl https://t.me/'..data.username_)
                        text2 = string.match(text1, [[<meta property="og:description" content="(.*)">

<meta property="twitter:title" content=]])
                        print(text2)
                        if text2 == "You can contact @"..data.username_.." right away." or text2 == "Unsupported characters" then
                            bio =" لا يوجد بايو"
                        else
                            bio = text2
                        end
                    else
                        bio = "لا يمكن استخراج البايو بدون معرف "
                    end


                    local points = redis:get(max..':User_Points:'..msg.chat_id_..msg.sender_user_id_)
                    if points and points ~= "0" then
                        nko = points
                    else
                        nko = '0'
                    end
                    local rfih = (redis:get(max..':edited:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
                    local NumGha = (redis:get(max..':adduser:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
                    local Namei = FlterName(data.first_name_..' '..(data.last_name_ or ""),20)
                    GetPhotoUser(msg.sender_user_id_,function(arg, data)
                        if redis:get(max.."getidstatus"..msg.chat_id_) == "Photo" then
                            if data.photos_[0] then
                                ali = { "1","2" }
                                ssssys = ali[math.random(#ali)]
                                if not redis:get(max.."ChatID"..msg.chat_id_) then
                                    sendPhoto(msg.chat_id_,msg.id_,data.photos_[0].sizes_[1].photo_.persistent_id_,'• USE 𖦹 ['..UserNameID..']\n• MSG 𖥳 '..msgs..' ‏\n• STA 𖦹 '..msg.TheRank..' \n• iD 𖥳  '..msg.sender_user_id_..'\n• Bio 𖦹 ['..bio..' ]',dl_cb,nil)
                                else
                                    Text = redis:get(max.."ChatID"..msg.chat_id_)
                                    Text = Text:gsub('#ايدي',msg.sender_user_id_)
                                    Text = Text:gsub('#اليوزر',UserNameID)
                                    Text = Text:gsub('#الرتبة',msg.TheRank)
                                    Text = Text:gsub('#الرسائل',msgs)
                                    Text = Text:gsub('#التعديل',rfih)
                                    Text = Text:gsub('#بايو',bio)

                                    sendPhoto(msg.chat_id_,msg.id_,data.photos_[0].sizes_[1].photo_.persistent_id_,"\n"..Text.."",dl_cb,nil)
                                end
                            else
                                if not redis:get(max.."ChatID"..msg.chat_id_) then
                                    sendMsg(msg.chat_id_,msg.id_,'- لا يمكنني عرض صورتك لانك قمت بحظر البوت او انك لاتملك صوره في بروفيلك .\n• USE 𖦹 ['..UserNameID..']\n• MSG 𖥳 '..msgs..' ‏\n• STA 𖦹 '..msg.TheRank..' \n• iD 𖥳  '..msg.sender_user_id_..'\n• Bio 𖦹 ['..bio..' ] ')
                                else
                                    Text = redis:get(max.."ChatID"..msg.chat_id_)
                                    Text = Text:gsub('#ايدي',msg.sender_user_id_)
                                    Text = Text:gsub('#اليوزر',UserNameID)
                                    Text = Text:gsub('#الرتبة',msg.TheRank)
                                    Text = Text:gsub('#الرسائل',msgs)
                                    Text = Text:gsub('#التعديل',rfih)
                                    Text = Text:gsub('#بايو',bio)

                                    sendMsg(msg.chat_id_,msg.id_,Flter_Markdown(Text))
                                end
                            end
                        else
                            if redis:get(max.."ChatID"..msg.chat_id_) then
                                Text = redis:get(max.."ChatID"..msg.chat_id_)
                                Text = Text:gsub('#ايدي',msg.sender_user_id_)
                                Text = Text:gsub('#اليوزر',UserNameID)
                                Text = Text:gsub('#الرتبة',msg.TheRank)
                                Text = Text:gsub('#الرسائل',msgs)
                                Text = Text:gsub('#التعديل',rfih)
                                Text = Text:gsub('#بايو',bio)

                                sendMsg(msg.chat_id_,msg.id_,Flter_Markdown(Text))
                            else
                                sendMsg(msg.chat_id_,msg.id_,'• USE 𖦹 ['..UserNameID..']\n• MSG 𖥳 '..msgs..' ‏\n• STA 𖦹 '..msg.TheRank..' \n• iD 𖥳  '..msg.sender_user_id_..'\n• Bio 𖦹 ['..bio..' ] ')
                            end
                        end

                    end)
                end ,nil)
            end
            return false
        end
        --====================================== { End  New ID } ======================================--


        if msg.reply_id and not MsgText[2] then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="iduser"})
        elseif MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="iduser"})
            return false
        end
        return false
    end

    if MsgText[1] == "الرتبه" and not MsgText[2] and msg.reply_id then
        return GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="rtba"})
    end


    if MsgText[1]== 'رسائلي' or MsgText[1] == 'رسايلي' or MsgText[1] == 'احصائياتي'  then
        GetUserID(msg.sender_user_id_,function(arg,data)
            local msgs = (redis:get(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_) or 0)
            local NumGha = (redis:get(max..':adduser:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local photo = (redis:get(max..':photo:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local sticker = (redis:get(max..':sticker:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local voice = (redis:get(max..':voice:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local audio = (redis:get(max..':audio:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local animation = (redis:get(max..':animation:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local edited = (redis:get(max..':edited:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local video = (redis:get(max..':video:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)

            local Get_info =  "❪ احصائيات الـرسـائـل ❫\n"
                    .."- الـرسائل ❪ "..msgs.." ❫\n"
                    .."- الجهات ❪ "..NumGha.." ❫\n"
                    .."- الصور ❪ "..photo.." ❫\n"
                    .."- المتحركه ❪ "..animation.." ❫\n"
                    .."- الملصقات ❪ "..sticker.." ❫\n"
                    .."- البصمات ❪ "..voice.." ❫\n"
                    .."- الصوت ❪ "..audio.." ❫\n"
                    .."- الفيديو ❪ "..video.." ❫\n"
                    .."- التعديل ❪ `"..edited.."` ❫\n"
            return sendMsg(msg.chat_id_,msg.id_,Get_info)
        end,nil)
        return false
    end

    if MsgText[1] == 'مسح' and MsgText[2] == 'رسائلي'  then
        local msgs = redis:get(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_) or 1
        if rfih == 0 then  return "- عذرا لا يوجد رسائل لك في البوت ." end
        redis:del(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_)
        return "- تم مسح {* "..msgs.." *} من رسائلك ."
    end

    if MsgText[1]== 'جهاتي' then
        return '- عدد جهاتك المضافه ⇜ ❪ '..(redis:get(max..':adduser:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)..' ❫ .'
    end

    if MsgText[1] == 'مسح' and MsgText[2] == 'جهاتي'  then
        local adduser = redis:get(max..':adduser:'..msg.chat_id_..':'..msg.sender_user_id_) or 0
        if adduser == 0 then  return "- عذرا ليس لديك جهات لكي يتم مسحها ." end
        redis:del(max..':adduser:'..msg.chat_id_..':'..msg.sender_user_id_)
        return "- تم مسح {* "..adduser.." *} من جهاتك ."
    end

    if MsgText[1]== 'اسمي' then
        GetUserID(msg.sender_user_id_,function(arg,data)
            local FlterName = FlterName(data.first_name_..""..(data.last_name_ or ""),90)
            local Get_info = " "..FlterName..""
            return sendMsg(msg.chat_id_,msg.id_,Get_info)
        end,nil)
        return false
    end

    if MsgText[1] == 'معلوماتي' or MsgText[1] == 'موقعي' then
        GetUserID(msg.sender_user_id_,function(arg,data)
            local msgs = (redis:get(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_) or 0)
            local NumGha = (redis:get(max..':adduser:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local photo = (redis:get(max..':photo:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local sticker = (redis:get(max..':sticker:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local voice = (redis:get(max..':voice:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local audio = (redis:get(max..':audio:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local animation = (redis:get(max..':animation:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local edited = (redis:get(max..':edited:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local video = (redis:get(max..':video:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)

            local Get_info ="الاسـم ❪ "..FlterName(data.first_name_..' '..(data.last_name_ or ""),25).." ❫\n"
                    .."- المعرف ❪ "..ResolveUser(data).." ❫\n"
                    .."- الايدي ❪ "..msg.sender_user_id_.." ❫\n"
                    .."- رتبتك ❪ "..msg.TheRank.." ❫\n"
                    .." ❪ احصائيات الـرسـائـل ❫\n"
                    .."- الـرسائل ❪ "..msgs.." ❫\n"
                    .."- الجهات ❪ "..NumGha.." ❫\n"
                    .."- الصور ❪ "..photo.." ❫\n"
                    .."- المتحركه ❪ "..animation.." ❫\n"
                    .."- الملصقات ❪ "..sticker.." ❫\n"
                    .."- البصمات ❪ "..voice.." ❫\n"
                    .."- الصوت ❪ "..audio.." ❫\n"
                    .."- الفيديو ❪ "..video.." ❫\n"
                    .."- التعديل ❪`"..edited.."` ❫\n"
            return sendMsg(msg.chat_id_,msg.id_,Get_info)
        end,nil)
        return false
    end

    if MsgText[1] == "مسح معلوماتي" then
        GetUserID(msg.sender_user_id_,function(arg,data)
            local msgs = (redis:del(max..'msgs:'..msg.sender_user_id_..':'..msg.chat_id_) or 0)
            local NumGha = (redis:del(max..':adduser:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local photo = (redis:del(max..':photo:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local sticker = (redis:del(max..':sticker:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local voice = (redis:del(max..':voice:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local audio = (redis:del(max..':audio:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local animation = (redis:del(max..':animation:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local edited = (redis:del(max..':edited:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
            local video = (redis:del(max..':video:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)

            local Get_info ="- أهلاً عزيزي تم حذف جميع معلوماتك ."
            return sendMsg(msg.chat_id_,msg.id_,Get_info)
        end,nil)
        return false
    end

    if MsgText[1] == "تفعيل" then

        if MsgText[2] == "الردود" 	then return unlock_replay(msg) end
        if MsgText[2] == "الاذاعه" 	then return unlock_brod(msg) end
        if MsgText[2] == "الايدي" 	then return unlock_ID(msg) end
        if MsgText[2] == "اليوتيوب" 	then return unlock_YT(msg) end
        if MsgText[2] == "الكت تويت" 	then return unlock_qt(msg) end
        if MsgText[2] == "الحماية" 	then return unlock_PR(msg) end
        if MsgText[2] == "الترحيب" 	then return unlock_Welcome(msg) end
        if MsgText[2] == "التحذير" 	then return unlock_waring(msg) end
		if MsgText[2] == "المنشن" 	then return unlock_mall(msg) end
    end




    if MsgText[1] == "تعطيل" then

        if MsgText[2] == "الردود" 	then return lock_replay(msg) end
        if MsgText[2] == "الاذاعه" 	then return lock_brod(msg) end
        if MsgText[2] == "الايدي" 	then return lock_ID(msg) end
        if MsgText[2] == "اليوتيوب" 	then return lock_YT(msg) end
        if MsgText[2] == "الكت تويت" 	then return lock_qt(msg) end
        if MsgText[2] == "الحماية" 	then return lock_PR(msg) end
        if MsgText[2] == "الترحيب" 	then return lock_Welcome(msg) end
        if MsgText[2] == "التحذير" 	then return lock_waring(msg) end
		if MsgText[2] == "المنشن" 	then return lock_mall(msg) end

    end


    if MsgText[1] == "ضع الترحيب" then
        if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
        redis:set(max..'welcom:witting'..msg.sender_user_id_.." "..msg.chat_id_,true)
        return "-› حسناً عزيزي \n- ارسل رد الترحيب الان\n\n- ملاحظه تستطيع إضافة دوال للترحيب مثلا :\n- اضهار قوانين المجموعه  » *{القوانين}*  \n- اضهار الاسم العضو » *{الاسم}*\n- اضهار المعرف العضو » *{المعرف}*\n- اضهار اسم المجموعه » *{المجموعه}*"
    end


    if MsgText[1] == "الترحيب" then
        if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
        if redis:get(max..'welcome:msg'..msg.chat_id_)  then
            return Flter_Markdown(redis:get(max..'welcome:msg'..msg.chat_id_))
        else
            return "-› أهلاً عزيزي "..msg.TheRankCmd.."  \n- نورت المجموعة ."
        end
    end


    if MsgText[1] == "كشف"  then
        if not MsgText[2] and msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="whois"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="whois"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="whois"})
            return false
        end
    end


    if MsgText[1] == "طرد" then
	if msg.SudoBaseP then return "يابنت الحلال تعوذي من ابليس واطردي الشر 😔"
        elseif not msg.Admin then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
        if not MsgText[2] and msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="kick"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="kick"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="kick"})
            return false
        end
    end


    if MsgText[1] == "حظر" then
        if msg.SudoBaseP then return "لا مايمديك تحظرين انتي بالذات" 
		elseif not msg.Admin then return "-› هذا الامر يخص\n-(المالك، المالك الأساسي, Dev) فقط ." end
        if not MsgText[2] and msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="ban"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="ban"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="ban"})
            return false
        end
    end


    if (MsgText[1] == "الغاء الحظر" or MsgText[1] == "الغاء حظر") and msg.Admin then
	if msg.SudoBaseP then return "سوت خوي هههه"
        elseif not msg.Admin then return "-› هذا الامر يخص\n-(المالك، المالك الأساسي, Dev) فقط ." end
        if not MsgText[2] and msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="unban"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="uban"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="unban"})
            return false
        end
    end


    if MsgText[1] == "كتم" then
	if msg.SudoBaseP then return "اعقلي كوكبب"
        elseif not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
        if not MsgText[2] and msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="silent"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="ktm"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="silent"})
            return false
        end
    end


    if MsgText[1] == "الغاء الكتم" or MsgText[1] == "الغاء كتم" then
	if msg.SudoBaseP then return "ياربي من هذي البنت اللي ما تعقل"
        elseif not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
        if not MsgText[2] and msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="unsilent"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="unktm"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="unsilent"})
            return false
        end
    end

    if MsgText[1] == "المكتومين" then
        if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Devs) فقط ." end
        return MuteUser_list(msg)
    end

    if MsgText[1] == "المحظورين" then
        if not msg.Director then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Devs) فقط ." end
        return GetListBanned(msg)
    end

    if MsgText[1] == "رفع المشرفين" then
        if not msg.Creator then return "-› هذا الامر يخص \n- (المالك، Devs) فقط  ." end
        return set_admins(msg)
    end



    if MsgText[1] == 'مسح' and MsgText[2] == 'R'  then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local vmtwren = redis:scard(max..':VSUDO_BOT:')
        if vmtwren == 0 then  return "-› لا يوجد Dev🎖 في البوت ." end
        redis:del(max..':VSUDO_BOT:')
        return "-› تم مسح {* "..vmtwren.." *} من قائمة الـDev🎖 ."
    end

    if MsgText[1] == 'مسح' and MsgText[2] == 'D'  then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local mtwren = redis:scard(max..':SUDO_BOT:')
        if mtwren == 0 then  return "-› لا يوجد Dev في البوت ." end
        redis:del(max..':SUDO_BOT:')
        return "-› تم مسح {* "..mtwren.." *} من قائمة الـDev ."
    end

    if MsgText[1] == 'مسح' and MsgText[2] == 'M'  then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local Mmtwren = redis:scard(max..':MSUDO_BOT:')
        if mtwren == 0 then  return "-› لا يوجد Dev في البوت ." end
        redis:del(max..':MSUDO_BOT:')
        return "-› تم مسح {* "..Mmtwren.." *} من قائمة الـDev ."
    end

    if MsgText[1] == 'مسح' and MsgText[2] == 'F'  then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local Fmtwren = redis:scard(max..':FSUDO_BOT:')
        if mtwren == 0 then  return "-› لا يوجد Dev في البوت ." end
        redis:del(max..':FSUDO_BOT:')
        return "-› تم مسح {* "..Fmtwren.." *} من قائمة الـDev ."
    end

    if MsgText[1] == 'مسح' and MsgText[2] == 'P'  then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local Fmtwren = redis:scard(max..':PSUDO_BOT:')
        if mtwren == 0 then  return "-› لا يوجد Dev في البوت ." end
        redis:del(max..':PSUDO_BOT:')
        return "-› تم مسح {* "..Pmtwren.." *} من قائمة الـDev ."
    end

    if MsgText[1] == 'مسح' and MsgText[2] == 'A'  then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local Fmtwren = redis:scard(max..':ASUDO_BOT:')
        if mtwren == 0 then  return "-› لا يوجد Dev في البوت ." end
        redis:del(max..':ASUDO_BOT:')
        return "-› تم مسح {* "..Amtwren.." *} من قائمة الـDev ."
    end

    if MsgText[1] == 'مسح' and MsgText[2] == "قائمة العام"  then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local addbannds = redis:scard(max..'gban_users')
        if addbannds ==0 then
            return "‎-› قائمة الحظر فارغه ."
        end
        redis:del(max..'gban_users')
        return "‎-› تـم مـسـح { *"..addbannds.." *} من قائمة العام."
    end

    if msg.SudoBase then
--=====================(R H F)=================
        if MsgText[1] == "رفع R"   then
            if not msg.SudoBase then return "-› هذا الامر يخص \n- ( Myth ) فقط  ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="vup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="vup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="vup_sudo"})
                return false
            end
        end
		

        if MsgText[1] == "تنزيل R"   then
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="vdn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="vdn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="vdn_sudo"})
                return false
            end
        end
--=====================(R H F)=================				
--=====================(M 7 M D)===============		
		        if MsgText[1] == "رفع M"   then
            if not msg.SudoBase then return "-› هذا الامر يخص \n- ( Myth ) فقط  ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="Mup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="Mup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="Mup_sudo"})
                return false
            end
        end
		

        if MsgText[1] == "تنزيل M"   then
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="Mdn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="Mdn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="Mdn_sudo"})
                return false
            end
        end
--=====================(M 7 M D)===============	
--=====================(F S L)=================			
		        if MsgText[1] == "رفع F"   then
            if not msg.SudoBase then return "-› هذا الامر يخص \n- ( Myth ) فقط  ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="Fup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="Fup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="Fup_sudo"})
                return false
            end
        end
		

        if MsgText[1] == "تنزيل F"   then
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="Fdn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="Fdn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="Fdn_sudo"})
                return false
            end
        end
--=====================( F S L )===============
--=====================(F W A L)=================
        if MsgText[1] == "رفع فوله"   then
            if not msg.SudoBase then return "-› هذا الامر يخص \n- ( Myth ) فقط  ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="Aup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="Aup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="Aup_sudo"})
                return false
            end
        end


        if MsgText[1] == "تنزيل فوله"   then
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="Adn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="Adn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="Adn_sudo"})
                return false
            end
        end
--=====================( F W A L )===============
 --=====================(PLANET)=================
        if MsgText[1] == "رفع كوكب"   then
            if not msg.SudoBase then return "-› هذا الامر يخص \n- ( Myth ) فقط  ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="Pup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="Pup_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="Pup_sudo"})
                return false
            end
        end


        if MsgText[1] == "تنزيل كوكب"   then
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="Pdn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="Pdn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="Pdn_sudo"})
                return false
            end
        end
 --=====================( PLANET )===============
--=====================( D E V )===============
        if MsgText[1] == "رفع D"  then
            if not msg.SudoBase then return "-› هذا الامر يخص \n- ( Myth ) فقط  ." end
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="up_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="up_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="up_sudo"})
                return false
            end
        end

        if MsgText[1] == "تنزيل D"  then
            if not MsgText[2] and msg.reply_id then
                GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="dn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('^%d+$') then
                GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="dn_sudo"})
                return false
            end
            if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
                GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="dn_sudo"})
                return false
            end
        end
--=====================( D E V )===============
        if MsgText[1] == "تنظيف المجموعات" or MsgText[1] == "تنظيف المجموعات" then
            local groups = redis:smembers(max..'group:ids')
            local GroupsIsFound = 0
            for i = 1, #groups do
                GroupTitle(groups[i],function(arg,data)
                    if data.code_ and data.code_ == 400 then
                        rem_data_group(groups[i])
                        print(" Del Group From list ")
                    else
                        print(" Name Group : "..data.title_)
                        GroupsIsFound = GroupsIsFound + 1
                    end
                    print(GroupsIsFound..' : '..#groups..' : '..i)
                    if #groups == i then
                        local GroupDel = #groups - GroupsIsFound
                        if GroupDel == 0 then
                            sendMsg(msg.chat_id_,msg.id_,'-› جـيـد , لا توجد مجموعات وهميه.')
                        else
                            sendMsg(msg.chat_id_,msg.id_,'- عدد المجموعات  { *'..#groups..'*  } \n-  تـم تنظيف   { *'..GroupDel..'*  }  مجموعة \n- اصبح العدد الحقيقي الان  { *'..GroupsIsFound..'*  }  مجموعة')
                        end
                    end
                end)
            end
            return false
        end
        if MsgText[1] == "تنظيف المشتركين" or MsgText[1] == "تنظيف المشتركين" then
            local pv = redis:smembers(max..'users')
            local NumPvDel = 0
            for i = 1, #pv do
                GroupTitle(pv[i],function(arg,data)
                    sendChatAction(pv[i],"Typing",function(arg,data)
                        if data.ID and data.ID == "Ok"  then
                            print("Sender Ok")
                        else
                            print("Failed Sender Nsot Ok")
                            redis:srem(max..'users',pv[i])
                            NumPvDel = NumPvDel + 1
                        end
                        if #pv == i then
                            if NumPvDel == 0 then
                                sendMsg(msg.chat_id_,msg.id_,'-› جـيـد , لا يوجد مشتركين وهمي')
                            else
                                local SenderOk = #pv - NumPvDel
                                sendMsg(msg.chat_id_,msg.id_,'- عدد المشتركين  { *'..#pv..'*  } \n- تـم تنظيف   { *'..NumPvDel..'*  }  مشترك \n- اصبح العدد الحقيقي الان { *'..SenderOk..'*  }  من المشتركين')
                            end
                        end
                    end)
                end)
            end
            return false
        end
        if MsgText[1] == "ضع صوره للترحيب" or MsgText[1]=="ضع صوره للترحيب" then
            redis:setex(max..'welcom_ph:witting'..msg.sender_user_id_,300,true)
            return'-› حسناً عزيزي \n- الان قم بارسال الصوره للترحيب .'
        end

        if MsgText[1] == "تعطيل" and MsgText[2] == "البوت خدمي" then
            return lock_service(msg)
        end

        if MsgText[1] == "تفعيل" and MsgText[2] == "البوت خدمي" then
            return unlock_service(msg)
        end

        if MsgText[1] == "صوره الترحيب" then
            local Photo_Weloame = redis:get(max..':WELCOME_BOT')
            if Photo_Weloame then
                sendPhoto(msg.chat_id_,msg.id_,Photo_Weloame,[[ اهلاً
أنا بوت فوري لإدارة المجموعات
-  يوتيوب, كت تويت, إستجابة سريعه والمزيد ..
- ارفع البوت مشرف بالقروب ثم اكتب كلمة تفعيل .
قناة أخبار وتحديثات فوري @rnnni
Myth: @iiiziiii

]])

                return false
            else
                return "- لا توجد صوره مضافه للترحيب في البوت \n- لإضافة صوره الترحيب ارسل `ضع صوره للترحيب`"
            end
        end

        if MsgText[1] == "اضف رد المطور" then
            redis:setex(max..'text_sudo:witting'..msg.sender_user_id_,1200,true)
            return '-› حسناً عزيزي \n- الان قم بارسال الرد .'
        end

        if MsgText[1] == "ضع شرط التفعيل" and MsgText[2] and MsgText[2]:match('^%d+$') then
            redis:set(max..':addnumberusers',MsgText[2])
            return '- تم وضع شرط التفعيل *('..MsgText[2]..')* عضـو ،'
        end

        if MsgText[1] == "شرط التفعيل" then
            return'- شرط تفعيل البوت ان يكون عددالاعضاء *('..redis:get(max..':addnumberusers')..')* عضـو .'
        end
    end

    if MsgText[1] == 'المجموعات' or MsgText[1] == "المجموعات" then
        if not msg.SudoUser then return "-› هذا الامر يخص \n- ( Dev ) فقط  ." end
        return '- عدد المجموعات المفعلة ➞ `'..redis:scard(max..'group:ids')..'`  .'
    end

    if MsgText[1] == "المشتركين" or MsgText[1] == "المشتركين" then
        if not msg.SudoUser then return "-› هذا الامر يخص \n- ( Dev ) فقط  ." end
        return '- عدد المشتركين في البوت: `'..redis:scard(max..'users')..'` .'
    end

    if MsgText[1] == 'قائمة المجموعات' then
        if not msg.SudoBase then return "-› هذا الامر يخص \n- ( Myth ) فقط  ." end
        return chat_list(msg)
    end

    if MsgText[1] == 'تعطيل' and MsgText[2] and MsgText[2]:match("-100(%d+)") then
        if not msg.SudoUser then return "-› هذا الامر يخص \n- ( Dev ) فقط  ." end
        if redis:sismember(max..'group:ids',MsgText[2]) then
            local name_gp = redis:get(max..'group:name'..MsgText[2])
            sendMsg(MsgText[2],0,'- تم تعطيل المجموعه بأمر من Dev -')
            rem_data_group(MsgText[2])
            StatusLeft(MsgText[2],our_id)
            return '- تم تعطيل المجموعه ومغادرتها \n- المجموعة ➞ ['..name_gp..']\n- الايدي ➞ ( *'..MsgText[2]..'* ).'
        else
            return '- لا توجد مجموعه مفعله بهذا الايدي !. '
        end
    end

    if MsgText[1] == 'المطور' then
        return redis:get(max..":TEXT_SUDO") or '- لا يوجد رد مطور .'
    end

    if MsgText[1] == "اذاعه عام بالتوجيه" or MsgText[1] == "اذاعه عام بالتوجيه" then
        if not msg.SudoUser then return"-› هذا الامر يخص \n- الـMyth فقط  ." end
        if not msg.SudoBase and not redis:get(max..'lock_brod') then
            return "- الاذاعه مقفوله من قبل Myth -"
        end
        redis:setex(max..'fwd:'..msg.sender_user_id_,300, true)
        return "- حسناً الان ارسل التوجيه للاذاعه ."
    end

    if MsgText[1] == "اذاعه عام" or MsgText[1] == "اذاعه عام" then
        if not msg.SudoUser then return"-› هذا الامر يخص \n- الـMyth فقط  ." end
        if not msg.SudoBase and not redis:get(max..'lock_brod') then
            return "-› الاذاعه مقفوله من قبل Myth ."
        end
        redis:setex(max..'fwd:all'..msg.sender_user_id_,300, true)
        return "- حسناً الان ارسل الرسالة للاذاعه عام ."
    end

    if MsgText[1] == "اذاعه خاص" or MsgText[1] == "اذاعه خاص" then
        if not msg.SudoUser then return "-› هذا الامر يخص \n- الـMyth فقط  ." end
        if not msg.SudoBase and not redis:get(max..'lock_brod') then
            return "- الاذاعه مقفوله من قبل Myth  ."
        end
        redis:setex(max..'fwd:pv'..msg.sender_user_id_,300, true)
        return "- حسناً الان ارسل الرسالة للاذاعه خاص ."
    end

    if MsgText[1] == "اذاعه" or MsgText[1] == "اذاعه" then
        if not msg.SudoUser then return"-› هذا الامر يخص \n- الـMyth فقط  ." end
        if not msg.SudoBase and not redis:get(max..'lock_brod') then
            return "- الاذاعه مقفوله من قبل Myth ."
        end
        redis:setex(max..'fwd:groups'..msg.sender_user_id_,300, true)
        return "- حسناً الان ارسل الرسالة للاذاعه للمجموعات ."
    end

    if MsgText[1] == "قائمة DV" or MsgText[1] == "قائمة Dev🎖" then
        if not msg.SudoUser then return"-› هذا الامر يخص \n- ( Dev ) فقط  ." end
        return vsudolist(msg)
    end

    if MsgText[1] == "قائمة D" or MsgText[1] == "قائمة Dev" then
        if not msg.SudoUser then return"-› هذا الامر يخص \n- ( Dev ) فقط  ." end
        return sudolist(msg)
    end

    if MsgText[1] == "قائمة العام" or MsgText[1]=="قائمة العام" then
        if not msg.SudoUser then return"-› هذا الامر يخص \n- ( Dev ) فقط  ." end
        return GetListGeneralBanned(msg)
    end

    if MsgText[1] == "تعطيل" and (MsgText[2] == "التواصل" or MsgText[2]=="التواصل ") then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        return lock_twasel(msg)
    end

    if MsgText[1] == "تفعيل" and (MsgText[2] == "التواصل" or MsgText[2]=="التواصل ") then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        return unlock_twasel(msg)
    end

    if MsgText[1] == "حظر عام" then
        if not msg.SudoBaseA then
            return "‎-› هذا الامر يخص Myth فقط  ."
        end

        if not MsgText[2] and msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="banall"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="bandall"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="banall"})
            return false
        end
    end

    if MsgText[1] == "الغاء العام" or MsgText[1] == "الغاء عام" then
        if not msg.SudoBaseA then return"‎-› هذا الامر يخص Myth فقط  ." end

        if not MsgText[2] and msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,action_by_reply,{msg=msg,cmd="unbanall"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('^%d+$') then
            GetUserID(MsgText[2],action_by_id,{msg=msg,cmd="unbandall"})
            return false
        end
        if MsgText[2] and MsgText[2]:match('@[%a%d_]+') then
            GetUserName(MsgText[2],action_by_username,{msg=msg,cmd="unbanall"})
            return false
        end
    end

    if MsgText[1] == "رتبتي" then return '- رتبتك ⇜ ❪ '..msg.TheRank..' ❫.' end

    ----------------- استقبال الرسائل ---------------
    if MsgText[1] == "الغاء الامر" or MsgText[1] == "الغاء" then
        if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
        redis:del(max..'welcom:witting'..msg.sender_user_id_,
                max..'rulse:witting'..msg.sender_user_id_.." "..msg.chat_id_,
                max..'rulse:witting'..msg.sender_user_id_.." "..msg.chat_id_,
                max..'name:witting'..msg.sender_user_id_.." "..msg.chat_id_,
                max..'about:witting'..msg.sender_user_id_.." "..msg.chat_id_,
                max..'fwd:all'..msg.sender_user_id_,
                max..'fwd:pv'..msg.sender_user_id_,
                max..'fwd:groups'..msg.sender_user_id_,
                max..'namebot:witting'..msg.sender_user_id_,
                max..'addrd_all:'..msg.sender_user_id_,
                max..'delrd:'..msg.sender_user_id_.." "..msg.chat_id_,
                max..'addrd:'..msg.sender_user_id_,
                max..'delrdall:'..msg.sender_user_id_,
                max..'text_sudo:witting'..msg.sender_user_id_,
                max..'addrd:'..msg.chat_id_..msg.sender_user_id_,
                max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_)
        return '- تم الغاء الأمر .'
    end


    if MsgText[1] == 'اصدار السورس' or MsgText[1] == 'الاصدار' then
        return '- اصدار سورس فوري : *v'..version..'* .'
    end



    if MsgText[1] == 'نسخه احتياطيه للمجموعات' then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        return buck_up_groups(msg)
    end

    if MsgText[1] == 'رفع نسخه الاحتياطيه' then
        if not msg.SudoBase then return "‎-› هذا الامر يخص Myth فقط  ." end
        if msg.reply_id then
            GetMsgInfo(msg.chat_id_,msg.reply_id,function(arg, data)
                if data.content_.ID == 'MessageDocument' then
                    local file_name = data.content_.document_.file_name_
                    if file_name:match('.json')then
                        if file_name:match('@[%a%d_]+.json') then
                            if file_name:lower():match('@[%a%d_]+') == Bot_User:lower() then
                                io.popen("rm -f ../.telegram-cli/data/document/*")
                                local file_id = data.content_.document_.document_.id_
                                tdcli_function({ID = "DownloadFile",file_id_ = file_id},function(arg, data)
                                    if data.ID == "Ok" then
                                        Uploaded_Groups_Ok = true
                                        Uploaded_Groups_CH = msg.chat_id_
                                        Uploaded_Groups_MS = msg.id_
                                        print(Uploaded_Groups_CH)
                                        print(Uploaded_Groups_MS)
                                        sendMsg(msg.chat_id_,msg.id_,'- جاري رفع النسخه انتظر قليلا ... ')
                                    end
                                end,nil)
                            else
                                sendMsg(msg.chat_id_,msg.id_,"- عذرا النسخه الاحتياطيه هذا ليست للبوت ➞ ["..Bot_User.."] .")
                            end
                        else
                            sendMsg(msg.chat_id_,msg.id_,'- عذرا اسم الملف غير مدعوم للنظام او لا يتوافق مع سورس ناشي يرجى جلب الملف الاصلي الذي قمت بسحبه وبدون تعديل ع الاسم .')
                        end
                    else
                        sendMsg(msg.chat_id_,msg.id_,'- عذرا الملف ليس بصيغه Json !?.')
                    end
                else
                    sendMsg(msg.chat_id_,msg.id_,'- عذرا هذا ليس ملف النسحه الاحتياطيه للمجموعات.')
                end
            end,nil)
        else
            return "- ارسل ملف النسخه الاحتياطيه اولا\n- ثم قم بالرد على الملف وارسل \" `رفع نسخه الاحتياطيه` \" "
        end
        return false
    end

    if (MsgText[1]=="تيست" or MsgText[1]=="test") then
        if msg.SudoBase then return "- البوت شـغــال ." end
        return
    end

    if (MsgText[1]== "ايدي" or MsgText[1]=="ايديي") and msg.type == "pv" then return  "\n- أهلاًً عزيزي ايديك هو \n\n- "..msg.sender_user_id_.."\n"  end



    if (MsgText[1]== "الاحصائيات" or MsgText[1]=="الاحصائيات") then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        return '- الاحصائيات - \n\n- عدد المجموعات المفعله *(* '..redis:scard(max..'group:ids')..' *)*\n- عدد المشتركين في البوت *(* '..redis:scard(max..'users')..' *)* '
    end
    ---------------[End Function data] -----------------------
    if MsgText[1]=="اضف رد عام" or MsgText[1]=="اضف رد عام" then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        redis:setex(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_,300,true)
        redis:del(max..'allreplay:'..msg.chat_id_..msg.sender_user_id_)
        return "-› حسناً الان ارسل كلمة الرد العام ."
    end

    if MsgText[1]== 'مسح' and MsgText[2]== 'الردود' then
        if not msg.Creator then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
        local names 	= redis:exists(max..'replay:'..msg.chat_id_)
        local photo 	= redis:exists(max..'replay_photo:group:'..msg.chat_id_)
        local voice 	= redis:exists(max..'replay_voice:group:'..msg.chat_id_)
        local imation   = redis:exists(max..'replay_animation:group:'..msg.chat_id_)
        local audio	 	= redis:exists(max..'replay_audio:group:'..msg.chat_id_)
        local sticker 	= redis:exists(max..'replay_sticker:group:'..msg.chat_id_)
        local video 	= redis:exists(max..'replay_video:group:'..msg.chat_id_)
        if names or photo or voice or imation or audio or sticker or video then
            redis:del(max..'replay:'..msg.chat_id_,max..'replay_photo:group:'..msg.chat_id_,max..'replay_voice:group:'..msg.chat_id_,
                    max..'replay_animation:group:'..msg.chat_id_,max..'replay_audio:group:'..msg.chat_id_,max..'replay_sticker:group:'..msg.chat_id_,max..'replay_video:group:'..msg.chat_id_)
            return "- تم مسح كل الردود ."
        else
            return '- لا يوجد ردود ليتم مسحها .'
        end
    end

    if MsgText[1]== 'مسح' and MsgText[2]== 'الردود العامه' then
        if not msg.SudoBase then return"-› هذا الأمر للـMyth ." end
        local names 	= redis:exists(max..'replay:all')
        local photo 	= redis:exists(max..'replay_photo:group:')
        local voice 	= redis:exists(max..'replay_voice:group:')
        local imation 	= redis:exists(max..'replay_animation:group:')
        local audio 	= redis:exists(max..'replay_audio:group:')
        local sticker 	= redis:exists(max..'replay_sticker:group:')
        local video 	= redis:exists(max..'replay_video:group:')
        if names or photo or voice or imation or audio or sticker or video then
            redis:del(max..'replay:all',max..'replay_photo:group:',max..'replay_voice:group:',max..'replay_animation:group:',max..'replay_audio:group:',max..'replay_sticker:group:',max..'replay_video:group:')
            return "- تم مسح كل الردود العامه ."
        else
            return "- لا يوجد ردود عامه ليتم مسحها !."
        end
    end

    if MsgText[1]== 'مسح' and MsgText[2]== 'رد عام' then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        redis:set(max..'delrdall:'..msg.sender_user_id_,true)
        return "-› حسناً عزيزي \n- الأن أرسل الرد لمسحه من المجموعات ."
    end

    if MsgText[1]== 'مسح' and MsgText[2]== 'رد' then
        if not msg.Admin then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
        redis:set(max..'delrd:'..msg.sender_user_id_.." "..msg.chat_id_,true)
        return "-› حسناً عزيزي \n- الأن أرسل الرد لمسحه من المجموعة ."
    end

    if MsgText[1]== 'الردود' then
        if not msg.Admin then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
        local names  	= redis:hkeys(max..'replay:'..msg.chat_id_)
        local photo 	= redis:hkeys(max..'replay_photo:group:'..msg.chat_id_)
        local voice  	= redis:hkeys(max..'replay_voice:group:'..msg.chat_id_)
        local imation 	= redis:hkeys(max..'replay_animation:group:'..msg.chat_id_)
        local audio 	= redis:hkeys(max..'replay_audio:group:'..msg.chat_id_)
        local sticker 	= redis:hkeys(max..'replay_sticker:group:'..msg.chat_id_)
        local video 	= redis:hkeys(max..'replay_video:group:'..msg.chat_id_)
        if #names==0 and #photo==0 and #voice==0 and #imation==0 and #audio==0 and #sticker==0 and #video==0 then
            return '- لا يوجد ردود مضافه حالياً .'
        end
        local ii = 1
        local message = '- ردود البوت في المجموعة  :\n\n'
        for i=1, #photo 	do message = message ..ii..' - *{* '..	photo[i]..' *}_*( صوره ) \n' 	 ii = ii + 1 end
        for i=1, #names 	do message = message ..ii..' - *{* '..	names[i]..' *}_*( نص ) \n'  	 ii = ii + 1 end
        for i=1, #voice 	do message = message ..ii..' - *{* '..  voice[i]..' *}_*( بصمه ) \n' 	 ii = ii + 1 end
        for i=1, #imation 	do message = message ..ii..' - *{* '..imation[i]..' *}_*( متحركه ) \n' ii = ii + 1 end
        for i=1, #audio 	do message = message ..ii..' - *{* '..	audio[i]..' *}_*( صوتيه ) \n'  ii = ii + 1 end
        for i=1, #sticker 	do message = message ..ii..' - *{* '..sticker[i]..' *}_*( ملصق ) \n' 	 ii = ii + 1 end
        for i=1, #video 	do message = message ..ii..' - *{* '..	video[i]..' *}_*( فيديو  ) \n' ii = ii + 1 end
        return message..'\n➖➖➖'
    end

    if MsgText[1]== 'الردود العامه' or MsgText[1]=='-الردود العامه-' then
        if not msg.SudoBase then return "- فقط للـMyth ." end
        local names 	= redis:hkeys(max..'replay:all')
        local photo 	= redis:hkeys(max..'replay_photo:group:')
        local voice 	= redis:hkeys(max..'replay_voice:group:')
        local imation 	= redis:hkeys(max..'replay_animation:group:')
        local audio 	= redis:hkeys(max..'replay_audio:group:')
        local sticker 	= redis:hkeys(max..'replay_sticker:group:')
        local video 	= redis:hkeys(max..'replay_video:group:')
        if #names==0 and #photo==0 and #voice==0 and #imation==0 and #audio==0 and #sticker==0 and #video==0 then
            return '- لا يوجد ردود مضافه حالياً .'
        end
        local ii = 1
        local message = '- الردود العامه في البوت :   :\n\n'
        for i=1, #photo 	do message = message ..ii..' - *{* '..	photo[i]..' *}_*( صوره ) \n' 	ii = ii + 1 end
        for i=1, #names 	do message = message ..ii..' - *{* '..	names[i]..' *}_*( نص ) \n'  	ii = ii + 1 end
        for i=1, #voice 	do message = message ..ii..' - *{* '..	voice[i]..' *}_*( بصمه ) \n' 	ii = ii + 1 end
        for i=1, #imation 	do message = message ..ii..' - *{* '..imation[i]..' *}_*( متحركه ) \n'ii = ii + 1 end
        for i=1, #audio 	do message = message ..ii..' - *{* '..	audio[i]..' *}_*( صوتيه ) \n' ii = ii + 1 end
        for i=1, #sticker 	do message = message ..ii..' - *{* '..sticker[i]..' *}_*( ملصق ) \n' 	ii = ii + 1 end
        for i=1, #video 	do message = message ..ii..' - *{* '..	video[i]..' *}_*( فيديو ) \n'ii = ii + 1 end


        if utf8.len(message) > 4096 then
            sendMsg(msg.chat_id_,1,'-› عذراً عندك الكثيير من المجموعات\n- لحظة بس وبرسل لك ملف فيه قائمة المجموعات المفعلة .')
            file = io.open("./inc/All_rdod.html", "w")
            file:write([[
<html dir="rtl">
<head>
<title>قائمة الردود</title>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type"/>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://fonts.googleapis.com/css?family=Harmattan" rel="stylesheet">

</head>
<style>*{font-family: 'Harmattan', sans-serif;font-weight: 600;text-shadow: 1px 1px 16px black;}</style>
<body>
<p style="color:#018bb6;font-size: 17px;font-weight: 600;" aligin="center">قائمة الردود</p>
<hr>
]]..message..[[

</body>
</html>
]])
            file:close()
            return sendDocument(msg.chat_id_,msg.id_,'./inc/All_rdod.html','-› قائمة المجموعات كاملة \n- تحتوي ('..#list..') مجموعة \n- افتح الملف في عارض HTML او بالمتصفح',dl_cb,nil)
        else
            return sendMsg(msg.chat_id_,1,message)
        end
        return message..'\n➖➖➖'
    end


    if MsgText[1]=="اضف رد" and msg.GroupActive then
        if not msg.Admin then return "-› هذا الامر يخص\n-(المدير، المالك، Dev) فقط ." end
        redis:setex(max..'addrd:'..msg.chat_id_..msg.sender_user_id_,300,true)
        redis:del(max..'replay1'..msg.chat_id_..msg.sender_user_id_)
        return "- حسناً , الان ارسل كلمه الرد ."
    end

    if MsgText[1] == "ضع اسم للبوت" or MsgText[1]== '-ضع اسم للبوت-' then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        redis:setex(max..'namebot:witting'..msg.sender_user_id_,300,true)
        return"-› حسناً عزيزي\n- الأن أرسل اسم للبوت . ."
    end



    if MsgText[1] == 'server' then
        if msg.SudoUser then
            return io.popen([[

linux_version=`lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om`
memUsedPrc=`free -m | awk 'NR==2{printf "%sMB/%sMB {%.2f%}\n", $3,$2,$3*100/$2 }'`
HardDisk=`df -lh | awk '{if ($6 == "/") { print $3"/"$2" ~ {"$5"}" }}'`
CPUPer=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
uptime=`uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes."}'`

echo '- ( System )\n*»» '"$linux_version"'*'
echo '*\n*- ( Memory )\n*»» '"$memUsedPrc"'*'
echo '*\n*- ( HardDisk )\n*»» '"$HardDisk"'*'
echo '*\n*- ( Processor )\n*»» '"`grep -c processor /proc/cpuinfo`""Core ~ {$CPUPer%} "'*'
echo '*\n*-  ( Login )\n*»» '`whoami`'*'
echo '*\n* - ( Uptime )  \n*»» '"$uptime"'*'
]]):read('*all')

        end
    end


    if MsgText[1] == 'السيرفر' then
        if msg.SudoUser then
            return io.popen([[

linux_version=`lsb_release -ds`
memUsedPrc=`free -m | awk 'NR==2{printf "%sMB/%sMB {%.2f%}\n", $3,$2,$3*100/$2 }'`
HardDisk=`df -lh | awk '{if ($6 == "/") { print $3"/"$2" ~ {"$5"}" }}'`
CPUPer=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
uptime=`uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes."}'`

echo '- ( نظام التشغيل )\n*»» '"$linux_version"'*'
echo '*\n*- ( الذاكره العشوائيه )\n*»» '"$memUsedPrc"'*'
echo '*\n*- ( وحـده الـتـخـزيـن )\n*»» '"$HardDisk"'*'
echo '*\n*- ( الـمــعــالــج )\n*»» '"`grep -c processor /proc/cpuinfo`""Core ~ {$CPUPer%} "'*'
echo '*\n*- ( الــدخــول )\n*»» '`whoami`'*'
echo '*\n*- ( مـده تـشغيـل الـسـيـرفـر )  \n*»» '"$uptime"'*'
]]):read('*all')


        end
    end
    if MsgText[1] == 'تنظيف' then
        if msg.SudoUser then
            return io.popen([[

clyt_mp3=`sudo rm MAX/tmp/*`
clyt_mp4=`sudo rm MAX/tmp1/*`


echo '- ( جارٍ تنظيف الصوت )\n*»» '"$clyt_mp3"'*'
echo '*\n*- ( جارِ تنظيف الفديو )\n*»» '"$clyt_mp4"'*'

]]):read('*all')


        end
    end


    if msg.type == 'channel' and msg.GroupActive then
	if MsgText[1] == "الاوامر" then
	if not msg.Admin then return "*-*هذا الامر يخص {نائب المدير,المدير,المنشئ,Dev} فقط  \n-" end
	local texs = [[  ‌‌‏‌‌‏‌‌‌‌‏                                    
										 ‌‌— قائمة الأوامر ↓
م1 ━ اوامر الأداره
م2 ━ اوامر المجموعة
م3 ━ اوامر حماية المجموعة
م4 ━ الاوامر العامة
م M ━ اوامر Myth
سورس ━ معلومات سورس  
	 ]]
	 keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '⓵', callback_data="/help1@"..msg.sender_user_id_},{text = '⓶', callback_data="/help2@"..msg.sender_user_id_},{text = '⓷', callback_data="/help3@"..msg.sender_user_id_},
},
{
{text = '⓸', callback_data="/help4@"..msg.sender_user_id_},
},
{
local msg_id = msg.id_/2097152/0.5
https.request(ApiToken..'/sendMessage?chat_id=' .. msg.chat_id_ .. '&text=' .. URL.escape(texs).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
        if MsgText[1]== 'م1' then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            local text =[[
↜ الرفع والتنزيل ↝
رفع ◢◤ تنزيل
✥ مشرف
✥ مالك
✥ مدير
✥ نائب مدير
✥ مميز
↜ اوامر المالك ↝
✥ مسح المدراء
✥ مسح نائبين المدراء
✥ مسح المميزين
✥ طرد البوتات
✥ طرد المحذوفين
✥ كشف البوتات
↜ اوامر بالرد أو بالمعرف ↝
✥ التفاعل
✥ كشف
✥ الرتبه
✥ طرد
✥ حظر ◢◤ الغاء الحظر
✥ تقييد ◢◤ الغاء التقييد
✥ كتم ◢◤ الغاء الكتم
↜ اوامر المنع ↝
✥ منع + الكلمة المراد منعها
✥ الغاء منع + الكلمة المراد الغاء منعها
✥ قائمة المنع
✥ مسح قائمة المنع
✎﹏﹏﹏﹏
للاستفسار الرجاء مراسلة المطور في الخاص ]]
            sendMsg(msg.chat_id_,msg.id_,text)
            return false
        end
        if MsgText[1]== 'م2' then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            local text = [[
↜ اوامر الوضع للمجموعة ↝
✥ ضع الترحيب
✥ ضع القوانين
✥ ضع وصف
✥ ضع رابط
↜ اوامر رؤية الاعدادات ↝
✥ المالكين
✥ المدراء
✥ نائبين المدراء
✥ المميزين
✥ المكتومين
✥ الوسائط
✥ الاعدادات
✥ المجموعة
↜ اوامر المجموعة الاخرى ↝
✥ انشاء رابط
✥ تغيير امر + الأمر المطلوب تغييره
✥ مسح امر + الأمر المطلوب تغييره
✥ قائمة الاوامر
✎﹏﹏﹏﹏
للاستفسار الرجاء مراسلة المطور في الخاص ]]
            sendMsg(msg.chat_id_,msg.id_,text)
            return false
        end
        if MsgText[1]== 'م3' then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            local text = [[
↜ اوامر حماية المجموعة ↝
قفل ◢◤ فتح
✥ الكل
✥ منشن
✥ الفيديو
✥ الصور
✥ الملصقات
✥ المتحركه
✥ البصمات
✥ الدردشه
✥ الروابط
✥ البوتات
✥ التعديل
✥ المعرفات
✥ الكلايش
✥ التكرار
✥ الجهات
✥ الانلاين
✥ التوجيه
✥ الدخول بالرابط
✥ البوتات بالطرد

تفعيل ◢◤ تعطيل
✥ الردود
✥ الترحيب
✥ الايدي
✥ الايدي بالصوره
✥ الحماية
✥ الرفع
✥ اليوتيوب
✥ الالعاب
↜ التقييد ↝
قفل ◢◤ فتح
✥ الوسائط بالتقييد
✥ الروابط بالتقييد
✥ التوجيه بالتقييد
✎﹏﹏﹏﹏
للاستفسار الرجاء مراسلة المطور في الخاص ]]
            sendMsg(msg.chat_id_,msg.id_,text)
            return false
        end
        if MsgText[1]== 'م4' then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            local text = [[
↜ الاوامر العامة ↝

✥ الرابط
✥ ايدي
✥ ايديي
✥ معلوماتي
✥ احصائياتي
✥ رسائلي
✥ جهاتي
✥ اسمي
✥ رابط الحذف
↜ اوامر الردود ↝
✥ اضف رد
✥ اضف رد مطور
✥ مسح رد
✥ مسح رد مطور
✥ الردود
✥ الردود المطورة
✥ مسح الردود
✥ مسح الردود المطورة

✎﹏﹏﹏﹏
للاستفسار الرجاء مراسلة المطور في الخاص ]]
            sendMsg(msg.chat_id_,msg.id_,text)
            return false
        end
        if MsgText[1]== "م5" or MsgText[1]== "التسليه" or MsgText[1]== "التسلية"then
            if not msg.Admin then return "‎-› هذا الامر يخص Myth فقط  ." end
            local text = [[
تفعيل ◢◤ تعطيل
✥ اليوتيوب
✥ الكت تويت
✥ الالعاب

✎﹏﹏﹏﹏
للاستفسار الرجاء مراسلة المطور في الخاص



 ]]
            sendMsg(msg.chat_id_,msg.id_,text)
            return false
        end

        if MsgText[1] == "تفعيل" and MsgText[2] == "اطردني"  then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            if not redis:get(max..'lave_me'..msg.chat_id_) then
                return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- المغادره بالتاكيد تم تفعيلها."
            else
                redis:del(max..'lave_me'..msg.chat_id_)
                return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم تفعيل المغادره."
            end
        end
        if MsgText[1] == "تعطيل" and MsgText[2] == "اطردني" then
            if not msg.Admin then return "-› هذا الامر يخص\n-(نائب المدير, المدير، المالك، Dev) فقط ." end
            if redis:get(max..'lave_me'..msg.chat_id_) then
                return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- المغادره من قبل البوت معطله سابقاً ."
            else
                redis:set(max..'lave_me'..msg.chat_id_,true)
                return "-› أهلاً عزيزي "..msg.TheRankCmd.."\n- تم تعطيل المغادره من قبل البوت."
            end
        end

        if MsgText[1] == "اطردني" or MsgText[1] == "احظرني" then
            if not redis:get(max..'lave_me'..msg.chat_id_) then
                if msg.Admin then return "- لا استطيع طرد المدراء ونائبين المدراء والمالكين ." end
                kick_user(msg.sender_user_id_,msg.chat_id_,function(arg,data)
                    if data.ID == "Ok" then
                        StatusLeft(msg.chat_id_,msg.sender_user_id_)
                        send_msg(msg.sender_user_id_,"- أهلاًً عزيزي , لقد تم طردك من المجموعة بأمر منك \n- اذا كان هذا بالخطأ او اردت الرجوع للمجموعة \n\n- فهذا رابط المجموعة \n- │"..Flter_Markdown(redis:get(max..'group:name'..msg.chat_id_)).." :\n\n["..redis:get(max..'linkGroup'..msg.chat_id_).."]\n")
                        sendMsg(msg.chat_id_,msg.id_,"- لقد تم طردك بنجاح , ارسلت لك رابط المجموعة بالخاص تقدر ترجع بالوقت اللي تبي . ")
                    else
                        sendMsg(msg.chat_id_,msg.id_,"- لا استطيع طردك لانك مشرف في المجموعة . ")
                    end
                end)
                return false
            end
        end

    end

    if MsgText[1] == "سورس" or MsgText[1]=="السورس" then
        return [[
-[Fory Channel](t.me/N00NN0)
-[Myth](t.me/iiiziiii)

]]
    end


    if MsgText[1] == "التاريخ" then
        return "التاريخ: "..os.date("%Y/%m/%d")
    end

    if MsgText[1]== "تعديلاتي" then
        return '- عدد تعديلاتك ⇜ ❪ '..(redis:get(max..':edited:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)..' ❫ .'
    end

    if MsgText[1] == 'مسح' and MsgText[2] == 'تعديلاتي'  then
        local rfih = (redis:get(max..':edited:'..msg.chat_id_..':'..msg.sender_user_id_) or 0)
        if rfih == 0 then  return "- لا توجد لك أي تعديلات ." end
        redis:del(max..':edited:'..msg.chat_id_..':'..msg.sender_user_id_)
        return "- تم مسح {* "..rfih.." *} من تعديلاتك ."
    end

    if MsgText[1] == "تفعيل الاشتراك الاجباري" or MsgText[1] == "-تفعيل الاشتراك الاجباري-" then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        if redis:get(max..":UserNameChaneel") then
            return "-› أهلاً حبيبي Myth \n-الاشتراك بالتأكيد مفعل"
        else
            redis:setex(max..":ForceSub:"..msg.sender_user_id_,350,true)
            return "- مرحبا بـك في نظام الاشتراك الاجباري\n- الان ارسل معرف قـنـاتـك"
        end
    end

    if MsgText[1] == "تعطيل الاشتراك الاجباري" or MsgText[1] == "-تعطيل الاشتراك الاجباري-" then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local SubDel = redis:del(max..":UserNameChaneel")
        if SubDel == 1 then
            return "- تم تعطيل الاشتراك الاجباري ."
        else
            return "- الاشتراك الاجباري بالفعل معطل ."
        end
    end

    if MsgText[1] == "الاشتراك الاجباري" or MsgText[1] == "-الاشتراك الاجباري-" then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        local UserChaneel = redis:get(max..":UserNameChaneel")
        if UserChaneel then
            return "- أهلاًً عزيزي الـMyth \n- الاشتراك الاجباري للقناة : ["..UserChaneel.."]."
        else
            return "- لا يوجد قناة مفعله ع الاشتراك الاجباري.."
        end
    end

    if MsgText[1] == "تغيير الاشتراك الاجباري" or MsgText[1] == "-تغيير الاشتراك الاجباري-" then
        if not msg.SudoBase then return"‎-› هذا الامر يخص Myth فقط  ." end
        redis:setex(max..":ForceSub:"..msg.sender_user_id_,350,true)
        return "- مرحبا بـك في نظام الاشتراك الاجباري\n- الان ارسل معرف قـنـاتـك"
    end

end





local function dmax(msg)

    local Text = msg.text
    if Text then

        ------set cmd------
        Black = msg.text
        mmd = redis:get(max..'addcmd'..msg.chat_id_..msg.sender_user_id_)
        if mmd then
            redis:sadd(max..'CmDlist:'..msg.chat_id_,msg.text)
            redis:hset(max..'CmD:'..msg.chat_id_,msg.text,mmd)
            sendMsg(msg.chat_id_,msg.id_,'-› أهلاً عزيزي '..msg.TheRankCmd..'\n-تم تثبيت الامر الجديد.')
            redis:del(max..'addcmd'..msg.chat_id_..msg.sender_user_id_)
        end

        if Black:match('تغيير امر (.*)') then
            if not msg.Kara then return ".-› هذا الامر يخص\n-(المالك الأساسي، Dev، Myth) فقط ." end
            local cmd = Black:match('تغيير امر (.*)')
            redis:setex(max..'addcmd'..msg.chat_id_..msg.sender_user_id_,120,cmd)
            sendMsg(msg.chat_id_,msg.id_,'-› أهلاً عزيزي '..msg.TheRankCmd..'\n-الامر الي تريد تغييره الي  |'..cmd..'| \n-ارسله الان. ')
        end

        if Black and (Black:match('^delcmd (.*)') or Black:match('^مسح امر (.*)')) then
            if not msg.Kara then return ".-› هذا الامر يخص\n-(المالك الأساسي، Dev، Myth) فقط ." end
            local cmd = Black:match('^delcmd (.*)') or Black:match('^مسح امر (.*)')
            redis:hdel(max..'CmD:'..msg.chat_id_,cmd)
            redis:srem(max..'CmDlist:'..msg.chat_id_,cmd)
            sendMsg(msg.chat_id_,msg.id_,"-› أهلاً عزيزي "..msg.TheRankCmd.."\n- الأمر |"..cmd.."|\n- تم مسحه من قائمة الاوامر.")
        end
        if Black == 'مسح قائمة الاوامر' or Black == 'مسح قائمة الاوامر' then
            if not msg.Kara then return ".-› هذا الامر يخص\n-(المالك الأساسي، Dev، Myth) فقط ." end
            redis:del(max..'CmD:'..msg.chat_id_)
            redis:del(max..'CmDlist:'..msg.chat_id_)
            sendMsg(msg.chat_id_,msg.id_,"- أهلاًً عزيزي تم مسح قائمة الاوامر .")
        end
        if Black == "قائمة الاوامر" then
            if not msg.Kara then return ".-› هذا الامر يخص\n-(المالك الأساسي، Dev، Myth) فقط ." end
            local CmDlist = redis:smembers(max..'CmDlist:'..msg.chat_id_)
            local t = '- قائمة الاوامر : \n'
            for k,v in pairs(CmDlist) do
                mmdi = redis:hget(max..'CmD:'..msg.chat_id_,v)
                t = t..k..") "..v.." > "..mmdi.."\n"
            end
            if #CmDlist == 0 then
                t = '- عزيزي لم تقم ب إضافة امر !.'
            end
            sendMsg(msg.chat_id_,msg.id_,t)
        end

        if Text == 'time' or Text == 'الوقت'  then
            local colors = {'blue','green','yellow','magenta','Orange','DarkOrange','red'}
            local fonts = {'mathbf','mathit','mathfrak','mathrm'}
            local url1 = 'http://latex.codecogs.com/png.download?'..'\\dpi{600}%20\\huge%20\\'..fonts[math.random(#fonts)]..'{{\\color{'..colors[math.random(#colors)]..'}'..os.date("%H:%M")..'}}'
            file = download_to_file(url1,'time.webp')

            print('TIMESSSS')
            sendDocument(msg.chat_id_,msg.id_,file,"",dl_cb,nil)
        end



        if Text == 'tovoice' or Text == 'صوت' then
            local bdv = '/home/root/Audm/1.m4a'
            local fv = download_to_file(bdv)
            sendVideo(msg.chat_id_,  'http://nosebleed.alienmelon.com/porn/FaciallyDistraughtDogs/dog1.gif')
        end



        if Text == 'tophoto' or Text == 'صوره' and tonumber(msg.reply_to_message_id_) > 0  then
            function tophoto(kara,max)
                if max.content_.ID == "MessageSticker" then
                    local bd = max.content_.sticker_.sticker_.path_
                    sendPhoto(msg.chat_id_,msg.id_,bd,"")
                else
                    sendMsg(msg.chat_id_,msg.id_,'- عزيزي المستخدم \n- الامر فقط للملصق.')
                end
            end
            tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},tophoto, nil)
        end
    end

    if msg.type == "pv" then

        if not msg.SudoUser then
            local msg_pv = tonumber(redis:get(max..'user:'..msg.sender_user_id_..':msgs') or 0)
            if msg_pv > 5 then
                redis:setex(max..':mute_pv:'..msg.sender_user_id_,18000,true)
                return sendMsg(msg.chat_id_,0,'- تم حظرك من البوت بسبب التكرار .')
            end
            redis:setex(max..'user:'..msg.sender_user_id_..':msgs',2,msg_pv+1)
        end

        if msg.text=="/start" then

            if msg.SudoBase then
                local text = '- أهلاًًً حبيبي الـMyth\n- يمديك توصل للأوامر بشكل اسرع عن طريق الكيبورد .'
                local keyboard = {
                    {"ضع اسم للبوت","ضع صوره للترحيب"},
                    {"تعطيل التواصل","تفعيل التواصل"},
                    {"تعطيل البوت خدمي","تفعيل البوت خدمي"},
                    {"قائمة Dev🎖","قائمة Dev"},
                    {"المشتركين","المجموعات","الاحصائيات"},
                    {"اضف رد عام","الردود العامه"},
                    {"اذاعه","اذاعه خاص"},
                    {"اذاعه عام","اذاعه عام بالتوجيه"},
                    {"تحديث","قائمة العام","ايديي"},
                    {"تعطيل الاشتراك الاجباري","تفعيل الاشتراك الاجباري"},
                    {"تغيير الاشتراك الاجباري","الاشتراك الاجباري"},
                    {"تنظيف المشتركين","تنظيف المجموعات"},
                    {"نسخه احتياطيه للمجموعات"},
                    {"قناة السورس"},
                    {"تحديث السورس"},
                    {"الغاء الامر"}}
                return send_key(msg.sender_user_id_,text,keyboard,nil,msg.id_)
            else
                redis:sadd(max..'users',msg.sender_user_id_)
                if redis:get(max..'lock_service') then
                    text = [[ اهلاً
أنا بوت Fory لإدارة المجموعات
-  يوتيوب, كت تويت, إستجابة سريعه والمزيد ..
- ارفع البوت مشرف بالقروب ثم اكتب كلمة تفعيل .
قناة أخبار وتحديثات Fory @rnnni
Myth: @iiiziiii

]]
                else
                    text = [[ اهلاً
أنا بوت Fory لإدارة المجموعات
-  يوتيوب, كت تويت, إستجابة سريعه والمزيد ..
- ارفع البوت مشرف بالقروب ثم اكتب كلمة تفعيل .
قناة أخبار وتحديثات Fory @N00NN0
Myth: @iiiziiii

]]
                end
                xsudouser = SUDO_USER:gsub('@',"")
                xsudouser = xsudouser:gsub([[\_]],'_')
                local inline = {{{text="مـطـور الـبـوت.",url="t.me/"..xsudouser}}}
                send_key(msg.sender_user_id_,text,nil,inline,msg.id_)
                return false
            end
        end

        if msg.SudoBase then
            if msg.reply_id and msg.text ~= "رفع نسخه الاحتياطيه" then
                GetMsgInfo(msg.chat_id_,msg.reply_id,function(arg,datainfo)
                    if datainfo.forward_info_ then
                        local FwdUser = datainfo.forward_info_.sender_user_id_
                        local FwdDate = datainfo.forward_info_.date_
                        GetUserID(FwdUser,function(arg,data)
                            local MSG_ID = (redis:get(max.."USER_MSG_TWASEL"..FwdDate) or 1)
                            if msg.text then
                                sendMsg(FwdUser,MSG_ID,Flter_Markdown(msg.text))
                            elseif msg.sticker then
                                sendSticker(FwdUser,MSG_ID,sticker_id,msg.content_.caption_ or " ")
                            elseif msg.photo then
                                sendPhoto(FwdUser,MSG_ID,photo_id,msg.content_.caption_ or " ")
                            elseif msg.voice then
                                sendVoice(FwdUser,MSG_ID,voice_id,msg.content_.caption_ or " ")
                            elseif msg.animation then
                                sendAnimation(FwdUser,MSG_ID,animation_id,msg.content_.caption_ or " ")
                            elseif msg.video then
                                sendVideo(FwdUser,MSG_ID,video_id,msg.content_.caption_ or " ")
                            elseif msg.audio then
                                sendAudio(FwdUser,MSG_ID,audio_id,msg.content_.caption_ or " ")
                            end

                            if data.username_ then
                                USERNAME = '@'..data.username_
                            else
                                USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or ""),20)
                            end
                            USERCAR = utf8.len(USERNAME)

                            SendMention(msg.sender_user_id_,data.id_,msg.id_,"- تم إرسال الرسالة \n- إلى "..USERNAME.." ",39,USERCAR)
                            return false
                        end,nil)
                    end
                end,nil)
            end
        else
            if not redis:get(max..'lock_twasel') then
                if msg.forward_info_ or msg.sticker or msg.content_.ID == "MessageUnsupported" then
                    sendMsg(msg.chat_id_,msg.id_,"-› لا يمكنك إرسال *(* ملصق, فيديو كام, توجيه *)* .")
                    return false
                end
                redis:setex(max.."USER_MSG_TWASEL"..msg.date_,43200,msg.id_)
                sendMsg(msg.chat_id_,msg.id_,"- تم ارسال رسالتك للـMyth\n- سأرد عليك بأقرب وقت \n- Myth: "..SUDO_USER)
                tdcli_function({ID='GetChat',chat_id_ = SUDO_ID},function(arg,data)
                    fwdMsg(SUDO_ID,msg.chat_id_,msg.id_)
                end,nil)
                return false
            end
        end
    end
    --==== Reply Pro ====
    if redis:get(max..'addpro:'..msg.chat_id_..msg.sender_user_id_) and redis:get(max..'replaypro:'..msg.chat_id_..msg.sender_user_id_) then
        local klma = redis:get(max..'replaypro:'..msg.chat_id_..msg.sender_user_id_)
        if msg.text then
            redis:hset(max..'preplay:'..msg.chat_id_,klma,Flter_Markdown(msg.text))
            redis:del(max..'addpro:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'(['..klma..'])\n. تم إضافة الرد  \n-')
        elseif msg.photo then
            redis:hset(max..'preplay_photo:group:'..msg.chat_id_,klma,photo_id)
            redis:del(max..'addpro:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة صوره للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصوره . ')
        elseif msg.voice then
            redis:hset(max..'preplay_voice:group:'..msg.chat_id_,klma,voice_id)
            redis:del(max..'addpro:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة بصمه صوت للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لسماع البصمه . ')
        elseif msg.animation then
            redis:hset(max..'preplay_animation:group:'..msg.chat_id_,klma,animation_id)
            redis:del(max..'addpro:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة متحركه للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصوره . ')
        elseif msg.video then
            redis:hset(max..'preplay_video:group:'..msg.chat_id_,klma,video_id)
            redis:del(max..'addpro:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة فيديو للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الفيديو . ')
        elseif msg.audio then
            redis:hset(max..'preplay_audio:group:'..msg.chat_id_,klma,audio_id)
            redis:del(max..'addpro:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة للصوت للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصوت . ')
        elseif msg.sticker then
            redis:hset(max..'preplay_sticker:group:'..msg.chat_id_,klma,sticker_id)
            redis:del(max..'addpro:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة ملصق للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الملصق .')
        end

    end
    --====================== Reply Only Group ====================================
    if redis:get(max..'addrd:'..msg.chat_id_..msg.sender_user_id_) and redis:get(max..'replay1'..msg.chat_id_..msg.sender_user_id_) then
        local klma = redis:get(max..'replay1'..msg.chat_id_..msg.sender_user_id_)
        if msg.text then
            redis:hset(max..'replay:'..msg.chat_id_,klma,Flter_Markdown(msg.text))
            redis:del(max..'addrd:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'(['..klma..'])\n. تم إضافة الرد  \n-')
        elseif msg.photo then
            redis:hset(max..'replay_photo:group:'..msg.chat_id_,klma,photo_id)
            redis:del(max..'addrd:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة صوره للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصوره . ')
        elseif msg.voice then
            redis:hset(max..'replay_voice:group:'..msg.chat_id_,klma,voice_id)
            redis:del(max..'addrd:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة بصمه صوت للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لسماع البصمه . ')
        elseif msg.animation then
            redis:hset(max..'replay_animation:group:'..msg.chat_id_,klma,animation_id)
            redis:del(max..'addrd:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة متحركه للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصوره . ')
        elseif msg.video then
            redis:hset(max..'replay_video:group:'..msg.chat_id_,klma,video_id)
            redis:del(max..'addrd:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة فيديو للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الفيديو . ')
        elseif msg.audio then
            redis:hset(max..'replay_audio:group:'..msg.chat_id_,klma,audio_id)
            redis:del(max..'addrd:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة للصوت للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصوت . ')
        elseif msg.sticker then
            redis:hset(max..'replay_sticker:group:'..msg.chat_id_,klma,sticker_id)
            redis:del(max..'addrd:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة ملصق للرد بنجاح.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الملصق .')
        end

    end

    --====================== Reply All Groups =====================================
    if redis:get(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_) and redis:get(max..'allreplay:'..msg.chat_id_..msg.sender_user_id_) then
        local klma = redis:get(max..'allreplay:'..msg.chat_id_..msg.sender_user_id_)
        if msg.text then
            redis:hset(max..'replay:all',klma,Flter_Markdown(msg.text))
            redis:del(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'(['..klma..'])\n- تم إضافة الرد لكل المجموعات  ')
        elseif msg.photo then
            redis:hset(max..'replay_photo:group:',klma,photo_id)
            redis:del(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة صوره للرد العام.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصوره . ')
        elseif msg.voice then
            redis:hset(max..'replay_voice:group:',klma,voice_id)
            redis:del(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة بصمه صوت للرد العام.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لسماع البصمه . ')
        elseif msg.animation then
            redis:hset(max..'replay_animation:group:',klma,animation_id)
            redis:del(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة متحركه للرد العام.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصورة . ')
        elseif msg.video then
            redis:hset(max..'replay_video:group:',klma,video_id)
            redis:del(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة فيديو للرد العام.\n- يمكنك ارسال ❴ ['..klma..'] ❵لإظهار الفيديو . ')
        elseif msg.audio then
            redis:hset(max..'replay_audio:group:',klma,audio_id)
            redis:del(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة الصوت للرد العام.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الصوت . ')
        elseif msg.sticker then
            redis:hset(max..'replay_sticker:group:',klma,sticker_id)
            redis:del(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_)
            return sendMsg(msg.chat_id_,msg.id_,'- تم إضافة ملصق للرد العام.\n- يمكنك ارسال ❴ ['..klma..'] ❵ لإظهار الملصق . ')
        end

    end

    if msg.text then
        --====================== Requst UserName Of Channel For ForceSub ==============




        if redis:get(max..'KID'..msg.chat_id_) then       -------استقبال الايدي
        redis:del(max..'KID'..msg.chat_id_)
            redis:set(max.."ChatID"..msg.chat_id_,msg.text)
            return sendMsg(msg.chat_id_,msg.id_,"- تم وضع الايدي ." )
        end






        if redis:get(max..":ForceSub:"..msg.sender_user_id_) then
            if msg.text:match("^@[%a%d_]+$") then
                redis:del(max..":ForceSub:"..msg.sender_user_id_)
                local url , res = https.request(ApiToken..'/getchatmember?chat_id='..msg.text..'&user_id='..msg.sender_user_id_)
                if res == 400 then
                    local Req = JSON.decode(url)
                    if Req.description == "Bad Request: chat not found" then
                        sendMsg(msg.chat_id_,msg.id_,"- عذرا , هناك خطأ لديك \n- المعرف الذي ارسلته ليس معرف قناة.")
                        return false
                    elseif Req.description == "Bad Request: CHAT_ADMIN_REQUIRED" then
                        sendMsg(msg.chat_id_,msg.id_,"- عذرا , لقد نسيت شيئا \n- يجب رفع البوت مشرف في قناتك لتتمكن من تفعيل الاشتراك الاجباري .")
                        return false
                    end
                else
                    redis:set(max..":UserNameChaneel",msg.text)
                    sendMsg(msg.chat_id_,msg.id_,"- جـيـد , الان لقد تم تفعيل الاشتراك الاجباري\n- على قناتك ⇜ ["..msg.text.."]")
                    return false
                end
            else
                sendMsg(msg.chat_id_,msg.id_,"- عذرا , عزيزي Dev \n- هذا ليس معرف قناة , حاول مجددا .")
                return false
            end
        end

        if redis:get(max..'namebot:witting'..msg.sender_user_id_) then --- استقبال اسم البوت
        redis:del(max..'namebot:witting'..msg.sender_user_id_)
            redis:set(max..':NameBot:',msg.text)
            Start_Bot()
            sendMsg(msg.chat_id_,msg.id_,"- تم تغيير اسم البوت  \n- اسمه الأن "..Flter_Markdown(msg.text)..".")
            return false
        end

        if redis:get(max..'addrd_all:'..msg.chat_id_..msg.sender_user_id_) then -- استقبال الرد لكل المجموعات
            if not redis:get(max..'allreplay:'..msg.chat_id_..msg.sender_user_id_) then -- استقبال كلمه الرد لكل المجموعات
                redis:hdel(max..'replay_photo:group:',msg.text)
                redis:hdel(max..'replay_voice:group:',msg.text)
                redis:hdel(max..'replay_animation:group:',msg.text)
                redis:hdel(max..'replay_audio:group:',msg.text)
                redis:hdel(max..'replay_sticker:group:',msg.text)
                redis:hdel(max..'replay_video:group:',msg.text)
                redis:setex(max..'allreplay:'..msg.chat_id_..msg.sender_user_id_,300,msg.text)
                return sendMsg(msg.chat_id_,msg.id_,"- حلو, الحين ارسل جواب الرد . \n- *(* نص,صوره,فيديو,متحركه,بصمه,اغنيه *)* .")
            end
        end

        if redis:get(max..'delrdall:'..msg.sender_user_id_) then
            redis:del(max..'delrdall:'..msg.sender_user_id_)
            local names = redis:hget(max..'replay:all',msg.text)
            local photo =redis:hget(max..'replay_photo:group:',msg.text)
            local voice = redis:hget(max..'replay_voice:group:',msg.text)
            local animation = redis:hget(max..'replay_animation:group:',msg.text)
            local audio = redis:hget(max..'replay_audio:group:',msg.text)
            local sticker = redis:hget(max..'replay_sticker:group:',msg.text)
            local video = redis:hget(max..'replay_video:group:',msg.text)
            if not (names or photo or voice or animation or audio or sticker or video) then
                return sendMsg(msg.chat_id_,msg.id_,'- هذا الرد ليس مضاف في قائمة الردود .')
            else
                redis:hdel(max..'replay:all',msg.text)
                redis:hdel(max..'replay_photo:group:',msg.text)
                redis:hdel(max..'replay_voice:group:',msg.text)
                redis:hdel(max..'replay_audio:group:',msg.text)
                redis:hdel(max..'replay_animation:group:',msg.text)
                redis:hdel(max..'replay_sticker:group:',msg.text)
                redis:hdel(max..'replay_video:group:',msg.text)
                return sendMsg(msg.chat_id_,msg.id_,'('..Flter_Markdown(msg.text)..')\n. تم مسح الرد . ')
            end
        end


        if redis:get(max..'text_sudo:witting'..msg.sender_user_id_) then -- استقبال كليشه Dev
            redis:del(max..'text_sudo:witting'..msg.sender_user_id_)
            redis:set(max..':TEXT_SUDO',Flter_Markdown(msg.text))
            return sendMsg(msg.chat_id_,msg.id_, "- تم وضع الكليشه بنجاح كلاتي \n\n*{*  "..Flter_Markdown(msg.text).."  *}*.")
        end
        if redis:get(max..'welcom:witting'..msg.sender_user_id_.." "..msg.chat_id_) then -- استقبال كليشه الترحيب
            redis:del(max..'welcom:witting'..msg.sender_user_id_.." "..msg.chat_id_)
            redis:set(max..'welcome:msg'..msg.chat_id_,msg.text)
            return sendMsg(msg.chat_id_,msg.id_,"- تم وضع الترحيب ." )
        end
        if redis:get(max..'rulse:witting'..msg.sender_user_id_.." "..msg.chat_id_) then --- استقبال القوانين
        redis:del(max..'rulse:witting'..msg.sender_user_id_.." "..msg.chat_id_)
            redis:set(max..'rulse:msg'..msg.chat_id_,Flter_Markdown(msg.text))
            return sendMsg(msg.chat_id_,msg.id_,'-› مرحباً عزيزي\n- تم حفظ القوانين بنجاح.\n- ارسل *(* القوانين *)* لعرضها .')
        end
        if redis:get(max..'name:witting'..msg.sender_user_id_.." "..msg.chat_id_) then --- استقبال الاسم
        redis:del(max..'name:witting'..msg.sender_user_id_.." "..msg.chat_id_)
            tdcli_function({ID= "ChangeChatTitle",chat_id_=msg.chat_id_,title_=msg.text},dl_cb,nil)
        end
        if redis:get(max..'linkGroup'..msg.sender_user_id_,link) then --- استقبال الرابط
        redis:del(max..'linkGroup'..msg.sender_user_id_,link)
            redis:set(max..'linkGroup'..msg.chat_id_,Flter_Markdown(msg.text))
            return sendMsg(msg.chat_id_,msg.id_,'- تم وضع الرابط الجديد بنجاح .')
        end
        if redis:get(max..'about:witting'..msg.sender_user_id_.." "..msg.chat_id_) then --- استقبال الوصف
        redis:del(max..'about:witting'..msg.sender_user_id_.." "..msg.chat_id_)
            tdcli_function({ID="ChangeChannelAbout",channel_id_=msg.chat_id_:gsub('-100',""),about_ = msg.text},function(arg,data)
                if data.ID == "Ok" then
                    return sendMsg(msg.chat_id_,msg.id_,"- تم وضع الوصف بنجاح.")
                end
            end,nil)
        end


        if redis:get(max..'fwd:all'..msg.sender_user_id_) then ---- استقبال رساله الاذاعه عام
        redis:del(max..'fwd:all'..msg.sender_user_id_)
            local pv = redis:smembers(max..'users')
            local groups = redis:smembers(max..'group:ids')
            local allgp =  #pv + #groups
            if allgp >= 300 then
                sendMsg(msg.chat_id_,msg.id_,'-› أهلاً حبيبي Myth \n-جاري نشر التوجيه للمجموعات وللمشتركين ...')
            end
            for i = 1, #pv do
                sendMsg(pv[i],0,Flter_Markdown(msg.text),nil,function(arg,data)
                    if data.send_state_ and data.send_state_.ID == "MessageIsBeingSent"  then
                        print("Sender Ok")
                    else
                        print("Rem user From list")
                        redis:srem(max..'users',pv[i])
                    end
                end)
            end
            for i = 1, #groups do
                sendMsg(groups[i],0,Flter_Markdown(msg.text),nil,function(arg,data)
                    if data.send_state_ and data.send_state_.ID == "MessageIsBeingSent"  then
                        print("Sender Ok")
                    else
                        print("Rem Group From list")
                        rem_data_group(groups[i])
                    end
                end)
            end
            return sendMsg(msg.chat_id_,msg.id_,'- تم اذاعه الكليشه بنجاح \n- للمجموعات » ❴ *'..#groups..'* ❵ مجموعة \n- للمـشـترگين » ❴ '..#pv..' ❵ مشترك .')
        end

        if redis:get(max..'fwd:pv'..msg.sender_user_id_) then ---- استقبال رساله الاذاعه خاص
        redis:del(max..'fwd:pv'..msg.sender_user_id_)
            local pv = redis:smembers(max..'users')
            if #pv >= 300 then
                sendMsg(msg.chat_id_,msg.id_,'-› أهلاً حبيبي Myth \n-جاري نشر الرساله للمشتركين ...')
            end
            local NumPvDel = 0
            for i = 1, #pv do
                sendMsg(pv[i],0,Flter_Markdown(msg.text),nil,function(arg,data)
                    if data.send_state_ and data.send_state_.ID == "MessageIsBeingSent"  then
                        print("Sender Ok")
                    else
                        print("Rem Group From list")
                        redis:srem(max..'users',pv[i])
                        NumPvDel = NumPvDel + 1
                    end
                    if #pv == i then
                        local SenderOk = #pv - NumPvDel
                        sendMsg(msg.chat_id_,msg.id_,'- عدد المشتركين : ❴ '..#pv..' ❵\n- تم الاذاعه الى ❴ '..SenderOk..'  ❵ مشترك \n.')
                    end
                end)
            end
        end

        if redis:get(max..'fwd:groups'..msg.sender_user_id_) then ---- استقبال رساله الاذاعه خاص
        redis:del(max..'fwd:groups'..msg.sender_user_id_)
            local groups = redis:smembers(max..'group:ids')
            if #groups >= 300 then
                sendMsg(msg.chat_id_,msg.id_,'-› أهلاً حبيبي Myth \n-جاري نشر الرساله للمجموعات ...')
            end
            local NumGroupsDel = 0
            for i = 1, #groups do
                sendMsg(groups[i],0,Flter_Markdown(msg.text),nil,function(arg,data)
                    if data.send_state_ and data.send_state_.ID == "MessageIsBeingSent"  then
                        print("Sender Ok")
                    else
                        print("Rem Group From list")
                        rem_data_group(groups[i])
                        NumGroupsDel = NumGroupsDel + 1
                    end
                    if #groups == i then
                        local AllGroupSend = #groups - NumGroupsDel
                        if NumGroupsDel ~= 0 then
                            MsgTDel = '- تم حذف ❴ *'..NumGroupsDel..'* ❵ من قائمة الاذاعه لانهم قامو بطرد البوت من المجموعه'
                        else
                            MsgTDel = ""
                        end
                        sendMsg(msg.chat_id_,msg.id_,'- عدد المجموعات ❴ *'..#groups..'* ❵\n- تـم الاذاعه الى ❴ *'..AllGroupSend..'* ❵\n'..MsgTDel..'.')
                    end
                end)
            end
        end
    end

    if msg.adduser and msg.adduser == our_id and redis:get(max..':WELCOME_BOT') then
        sendPhoto(msg.chat_id_,msg.id_,redis:get(max..':WELCOME_BOT'),[[ اهلاً
أنا بوت Fory لإدارة المجموعات
-  يوتيوب, كت تويت, إستجابة سريعه والمزيد ..
- ارفع البوت مشرف بالقروب ثم اكتب كلمة تفعيل .
قناة أخبار وتحديثات Fory @N00NN0
Myth: @iiiziiii

]])
        return false
    end

    if msg.forward_info and redis:get(max..'fwd:'..msg.sender_user_id_) then
        redis:del(max..'fwd:'..msg.sender_user_id_)
        local pv = redis:smembers(max..'users')
        local groups = redis:smembers(max..'group:ids')
        local allgp =  #pv + #groups
        if allgp == 500 then
            sendMsg(msg.chat_id_,msg.id_,'-› أهلاً حبيبي Myth \n-جاري نشر التوجيه للمجموعات وللمشتركين ...')
        end
        local number = 0
        for i = 1, #pv do
            fwdMsg(pv[i],msg.chat_id_,msg.id_,dl_cb,nil)
        end
        for i = 1, #groups do
            fwdMsg(groups[i],msg.chat_id_,msg.id_,dl_cb,nil)
        end
        return sendMsg(msg.chat_id_,msg.id_,'- تم اذاعه التوجيه بنجاح \n- للمجموعات » ❴ *'..#groups..'* ❵\n- للخاص » ❴ '..#pv..' ❵.')
    end



    if msg.text and msg.type == "channel" then
        if msg.text:match("^"..Bot_Name.." انقلع$") and (msg.SudoBase or msg.SudoBase or msg.Director) then
            sendMsg(msg.chat_id_,msg.id_,'-  ')
            rem_data_group(msg.chat_id_)
            StatusLeft(msg.chat_id_,our_id)
            return false
        end
    end

    if msg.content_.ID == "MessagePhoto" and redis:get(max..'welcom_ph:witting'..msg.sender_user_id_) then
        redis:del(max..'welcom_ph:witting'..msg.sender_user_id_)
        if msg.content_.photo_.sizes_[3] then
            photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
        else
            photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
        end
        redis:set(max..':WELCOME_BOT',photo_id)
        return sendMsg(msg.chat_id_,msg.id_,'- تم تغيير صورة الترحيب للبوت .')
    end

    if msg.content_.ID == "MessagePhoto" and msg.type == "channel" and msg.GroupActive then
        if redis:get(max..'photo:group'..msg.chat_id_..msg.sender_user_id_) then
            redis:del(max..'photo:group'..msg.chat_id_..msg.sender_user_id_)
            if msg.content_.photo_.sizes_[3] then
                photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_
            else
                photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_
            end
            tdcli_function({ID="ChangeChatPhoto",chat_id_=msg.chat_id_,photo_=GetInputFile(photo_id)},function(arg,data)
                if data.code_ == 3 then
                    sendMsg(arg.chat_id_,arg.id_,'- ليس لدي صلاحيه تغيير الصوره \n- يجب اعطائي صلاحيه `تغيير معلومات المجموعه ` ⠀.')
                end
            end,{chat_id_=msg.chat_id_,id_=msg.id_})
            return false
        end
    end

    if not msg.GroupActive then return false end
    if msg.text then
        --====== استقبال الردود المطورة للمجموعة



        --=======================
   
        if redis:get(max..'addrd:'..msg.chat_id_..msg.sender_user_id_) then -- استقبال الرد للمجموعه فقط

            if not redis:get(max..'replay1'..msg.chat_id_..msg.sender_user_id_) then  -- كلمه الرد
                redis:hdel(max..'replay:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_photo:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_voice:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_animation:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_audio:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_sticker:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_video:group:'..msg.chat_id_,msg.text)
                redis:setex(max..'replay1'..msg.chat_id_..msg.sender_user_id_,300,msg.text)
                return sendMsg(msg.chat_id_,msg.id_,"- حلو, الحين ارسل جواب الرد \n- *(* نص,صوره,فيديو,متحركه,بصمه,اغنيه *)* .")
            end
        end

        if redis:get(max..'delrd:'..msg.sender_user_id_.." "..msg.chat_id_) then
            redis:del(max..'delrd:'..msg.sender_user_id_.." "..msg.chat_id_)
            local names 	= redis:hget(max..'replay:'..msg.chat_id_,msg.text)
            local photo 	= redis:hget(max..'replay_photo:group:'..msg.chat_id_,msg.text)
            local voice 	= redis:hget(max..'replay_voice:group:'..msg.chat_id_,msg.text)
            local animation = redis:hget(max..'replay_animation:group:'..msg.chat_id_,msg.text)
            local audio 	= redis:hget(max..'replay_audio:group:'..msg.chat_id_,msg.text)
            local sticker 	= redis:hget(max..'replay_sticker:group:'..msg.chat_id_,msg.text)
            local video 	= redis:hget(max..'replay_video:group:'..msg.chat_id_,msg.text)
            if not (names or photo or voice or animation or audio or sticker or video) then
                return sendMsg(msg.chat_id_,msg.id_,'- هذا الرد ليس مضاف في قائمة الردود .')
            else
                redis:hdel(max..'replay:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_photo:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_voice:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_audio:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_animation:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_sticker:group:'..msg.chat_id_,msg.text)
                redis:hdel(max..'replay_video:group:'..msg.chat_id_,msg.text)
                return sendMsg(msg.chat_id_,msg.id_,'(['..msg.text..'])\n. تم مسح الرد . ')
            end
        end

    end

    if msg.pinned then
        print(" -- pinned -- ")
        local msg_pin_id = redis:get(max..":MsgIDPin:"..msg.chat_id_)
        if not msg.Director and redis:get(max..'lock_pin'..msg.chat_id_) then
            if msg_pin_id then
                print(" -- pinChannelMessage -- ")
                tdcli_function({ID ="PinChannelMessage",
                                channel_id_ = msg.chat_id_:gsub('-100',""),
                                message_id_ = msg_pin_id,
                                disable_notification_ = 0},
                        function(arg,data)
                            if data.ID == "Ok" then
                                return sendMsg(msg.chat_id_,msg.id_,"- عذرا التثبيت مقفل من قبل الاداره تم ارجاع التثبيت القديم .")
                            end
                        end,nil)
            else
                tdcli_function({ID="UnpinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',"")},
                        function(arg,data)
                            if data.ID == "Ok" then
                                return sendMsg(msg.chat_id_,msg.id_,"- عذرا التثبيت مقفل من قبل الاداره تم الغاء التثبيت.")
                            end
                        end,nil)
            end
            return false
        end
        redis:set(max..":MsgIDPin:"..msg.chat_id_,msg.id_)
    end

    if msg.content_.ID == "MessageChatChangePhoto" then
        GetUserID(msg.sender_user_id_,function(arg,data)
            if data.username_ then UserName = "@"..data.username_ else UserName = "احد المشرفين" end
            return sendMsg(msg.chat_id_,msg.id_,"- قام ["..UserName.."] بتغير صوره المجموعه.\n")
        end)
    end

    if msg.content_.ID == "MessageChatChangeTitle" then
        GetUserID(msg.sender_user_id_,function(arg,data)
            redis:set(max..'group:name'..msg.chat_id_,msg.content_.title_)
            if data.username_ then UserName = "@"..data.username_ else UserName = "احد المشرفين" end

            return sendMsg(msg.chat_id_,msg.id_,"- قام  ["..UserName.."]\n- بتغيير اسم المجموعة \n- إلى "..Flter_Markdown(msg.content_.title_)..".")
        end)
    end
    if msg.content_.ID == "MessageChatAddMembers" and redis:get(max..'welcome:get'..msg.chat_id_) then
        local adduserx = tonumber(redis:get(max..'user:'..msg.sender_user_id_..':msgs') or 0)
        if adduserx > 3 then
            redis:del(max..'welcome:get'..msg.chat_id_)
        end
        redis:setex(max..'user:'..msg.sender_user_id_..':msgs',3,adduserx+1)
    end

    if msg.content_.ID == "MessageChatAddMembers" and redis:get(max..'welcome:get'..msg.chat_id_) then
        local adduserx = tonumber(redis:get(max..'user:'..msg.sender_user_id_..':msgs') or 0)
        if adduserx > 3 then
            redis:del(max..'welcome:get'..msg.chat_id_)
        end
        redis:setex(max..'user:'..msg.sender_user_id_..':msgs',3,adduserx+1)
    end

    if (msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == "MessageChatJoinByLink") then
        if redis:get(max..'welcome:get'..msg.chat_id_) then
            if msg.adduserType then
                welcome = (redis:get(max..'welcome:msg'..msg.chat_id_) or "- أهلاًً حبيبي\n-نورت المجموعة .")
                welcome = welcome:gsub("{القوانين}", redis:get(max..'rulse:msg'..msg.chat_id_) or "- الابتعاد عن الألفاظ القذرة.\n- الابتعاد عن العنصرية.\n- عدم نشر صور ومقاطع غير اخلاقية.\n- احترام مالك القروب واعضاء القروب.")
                if msg.addusername then UserName = '@'..msg.addusername else UserName = '< لا يوجد معرف >' end
                welcome = welcome:gsub("{المجموعه}",Flter_Markdown((redis:get(max..'group:name'..msg.chat_id_) or "")))
                local welcome = welcome:gsub("{المعرف}",UserName)
                local welcome = welcome:gsub("{الاسم}",FlterName(msg.addname,20))
                sendMsg(msg.chat_id_,msg.id_,Flter_Markdown(welcome))
                return false
            else
                GetUserID(msg.sender_user_id_,function(arg,data)
                    welcome = (redis:get(max..'welcome:msg'..msg.chat_id_) or "- أهلاًً حبيبي\n-نورت المجموعة .")
                    welcome = welcome:gsub("{القوانين}", redis:get(max..'rulse:msg'..msg.chat_id_) or "- الابتعاد عن الألفاظ القذرة.\n- الابتعاد عن العنصرية.\n- عدم نشر صور ومقاطع غير اخلاقية.\n- احترام مالك القروب واعضاء القروب.")
                    if data.username_ then UserName = '@'..data.username_ else UserName = '< لا يوجد معرف >' end
                    welcome = welcome:gsub("{المجموعه}",Flter_Markdown((redis:get(max..'group:name'..msg.chat_id_) or "")))
                    local welcome = welcome:gsub("{المعرف}",UserName)
                    local welcome = welcome:gsub("{الاسم}",FlterName(data.first_name_..' '..(data.last_name_ or "" ),20))
                    sendMsg(msg.chat_id_,msg.id_,Flter_Markdown(welcome))
                end)
            end
        end
        return false
    end

    if not msg.Admin and not msg.Special and not (msg.adduser or msg.joinuser or msg.deluser ) then -- للاعضاء فقط

        if not msg.forward_info and redis:get(max..'lock_flood'..msg.chat_id_)  then
            local msgs = (redis:get(max..'user:'..msg.sender_user_id_..':msgs') or 0)
            local NUM_MSG_MAX = (redis:get(max..'num_msg_max'..msg.chat_id_) or 5)
            if tonumber(msgs) > tonumber(NUM_MSG_MAX) then
                GetUserID(msg.sender_user_id_,function(arg,datau)
                    Restrict(msg.chat_id_,msg.sender_user_id_,1)
                    redis:setex(max..'sender:'..msg.sender_user_id_..':flood',30,true)
                    if datau.username_ then USERNAME = '@'..datau.username_ else USERNAME = FlterName(datau.first_name_..' '..(datau.last_name_ or "")) end
                    local USERCAR = utf8.len(USERNAME)
                    SendMention(msg.chat_id_,datau.id_,msg.id_,"-› العضو » "..USERNAME.."\n- قمت بتكرار اكثر من "..NUM_MSG_MAX.." رسالة لذا تم تقييدك .",12,USERCAR)
                    return false
                end)
            end
            redis:setex(max..'user:'..msg.sender_user_id_..':msgs',2,msgs+1)
        end

        function Get_Info(msg,chat,user) --// ارسال نتيجة الصلاحيه
            local Chek_Info = https.request('https://api.telegram.org/bot'..Token..'/getChatMember?chat_id='.. chat ..'&user_id='.. user..'')
            local Json_Info = JSON.decode(Chek_Info)
            if Json_Info.ok == true then
                if Json_Info.result.status == "creator" then
                    return sendMsg(msg.chat_id_,msg.id_,'-› صلاحياته مالك القروب .')
                end
                if Json_Info.result.status == "member" then
                    return sendMsg(msg.chat_id_,msg.id_,'-› مجرد عضو هنا .')
                end
                if Json_Info.result.status == "administrator" then
                    if Json_Info.result.can_change_info == true then
                        info = 'ꪜ' else info = '✘' end
                    if Json_Info.result.can_delete_messages == true then
                        delete = 'ꪜ' else delete = '✘' end
                    if Json_Info.result.can_invite_users == true then
                        invite = 'ꪜ' else invite = '✘' end
                    if Json_Info.result.can_pin_messages == true then
                        pin = 'ꪜ' else pin = '✘' end
                    if Json_Info.result.can_restrict_members == true then
                        restrict = 'ꪜ' else restrict = '✘' end
                    if Json_Info.result.can_promote_members == true then
                        promote = 'ꪜ' else promote = '✘' end
                    return sendMsg(chat,msg.id_,'- الرتبة : مشرف \n- والصلاحيات هي ⇓ \nـــــــــــــــــــــــــــــــــــــــــــــــــــــــــ\n- تغير معلومات المجموعه ↞ ❪ '..info..' ❫\n- حذف الرسائل ↞ ❪ '..delete..' ❫\n- حظر المستخدمين ↞ ❪ '..restrict..' ❫\n- دعوة مستخدمين ↞ ❪ '..invite..' ❫\n- تثبيت الرسائل ↞ ❪ '..pin..' ❫\n- اضافة مشرفين جدد ↞ ❪ '..promote..' ❫\n\n- ملاحظة » علامة ❪  ꪜ ❫ تعني لديه الصلاحية وعلامة ❪ ✘ ❫ تعني ليس لديه الصلاحيه')
                end
            end
        end

        if msg.forward_info_ then
            if redis:get(max..'mute_forward'..msg.chat_id_) then -- قفل التوجيه
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del Becuse Send Fwd \27[0m")

                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) and not redis:get(max..':User_Fwd_Msg:'..msg.sender_user_id_..':flood') then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-› عذرا ممنوع اعادة التوجيه ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR)
                            return redis:setex(max..':User_Fwd_Msg:'..msg.sender_user_id_..':flood',15,true)
                        end,nil)
                    end
                end)
                return false
            elseif redis:get(max..':tqeed_fwd:'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del Becuse Send Fwd tqeed \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    Restrict(msg.chat_id_,msg.sender_user_id_,1)
                end)
                return false
            end
        elseif tonumber(msg.via_bot_user_id_) ~= 0 and redis:get(max..'mute_inline'..msg.chat_id_) then -- قفل الانلاين
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send inline \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا الانلاين مقفول ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.text then -- رسايل فقط
            if utf8.len(msg.text) > 500 and redis:get(max..'lock_spam'..msg.chat_id_) then -- قفل الكليشه
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send long msg \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-›ممنوع ارسال الكليشه والا سوف تجبرني على طردك ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif (msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/")
                    or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/")
                    or msg.text:match("[Tt].[Mm][Ee]/")
                    or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
                    or msg.text:match(".[Pp][Ee]")
                    or msg.text:match("[Hh][Tt][Tt][Pp][Ss]://")
                    or msg.text:match("[Hh][Tt][Tt][Pp]://")
                    or msg.text:match("[Ww][Ww][Ww].")
                    or msg.text:match(".[Cc][Oo][Mm]"))
                    and redis:get(max..':tqeed_link:'..msg.chat_id_)  then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m The user i restricted becuse send link \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    Restrict(msg.chat_id_,msg.sender_user_id_,1)
                end)
                return false
            elseif(msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/")
                    or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/")
                    or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Oo][Rr][Gg]/")
                    or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match(".[Pp][Ee]"))
                    and redis:get(max..'lock_link'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send link \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-›ممنوع ارسال الروابط ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif (msg.text:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.text:match("[Hh][Tt][Tt][Pp]://") or msg.text:match("[Ww][Ww][Ww].") or msg.text:match(".[Cc][Oo][Mm]") or msg.text:match(".[Tt][Kk]") or msg.text:match(".[Mm][Ll]") or msg.text:match(".[Oo][Rr][Gg]")) and redis:get(max..'lock_webpage'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send web link \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-›ممنوع ارسال روابط الويب  ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif msg.text:match("#[%a%d_]+") and redis:get(max..'lock_tag'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send tag \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-›ممنوع ارسال التاك ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif msg.text:match("@[%a%d_]+")  and redis:get(max..'lock_username'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send username \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-›ممنوع ارسال المعرف  ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR)
                        end,nil)
                    end
                end)
                return false
            elseif not msg.textEntityTypeBold and (msg.textEntityTypeBold or msg.textEntityTypeItalic) and redis:get(max..'lock_markdown'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send markdown \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-›ممنوع ارسال الماركدوان ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif msg.textEntityTypeTextUrl and redis:get(max..'lock_webpage'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send web page \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-›ممنوع ارسال روابط الويب  ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false

            elseif msg.edited and redis:get(max..'lock_edit'..msg.chat_id_) then -- قفل التعديل
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send Edit \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-› عذراً ممنوع التعديل تم المسح  ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            end
        elseif msg.content_.ID == "MessageUnsupported" and redis:get(max..'mute_video'..msg.chat_id_) then -- قفل الفيديو
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send video \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا ممنوع ارسال الفيديو كام  ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.photo then
            if redis:get(max..'mute_photo'..msg.chat_id_)  then -- قفل الصور
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send photo \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-› عذرا ممنوع ارسال الصور ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif redis:get(max..':tqeed_photo:'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m The user resctricted becuse send photo \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    Restrict(msg.chat_id_,msg.sender_user_id_,3)
                end)
                return false
            end
        elseif msg.video then
            if redis:get(max..'mute_video'..msg.chat_id_) then -- قفل الفيديو
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send vedio \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-› عذرا ممنوع ارسال الفيديو ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif redis:get(max..':tqeed_video:'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m The user restricted becuse send video \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    Restrict(msg.chat_id_,msg.sender_user_id_,3)
                end)
                return false
            end
        elseif msg.document and redis:get(max..'mute_document'..msg.chat_id_) then -- قفل الملفات
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send file \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا ممنوع ارسال الملفات ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.sticker and redis:get(max..'mute_sticker'..msg.chat_id_) then --قفل الملصقات
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send sticker \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا ممنوع ارسال الملصقات ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.animation then
            if redis:get(max..'mute_gif'..msg.chat_id_) then -- قفل المتحركه
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send gif \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-› عذرا ممنوع ارسال الصور المتحركه ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif redis:get(max..':tqeed_gif:'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m The user restricted becuse send gif \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    Restrict(msg.chat_id_,msg.sender_user_id_,3)
                end)
                return false
            end
        elseif msg.contact and redis:get(max..'mute_contact'..msg.chat_id_) then -- قفل الجهات
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send Contact \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا ممنوع ارسال جهات الاتصال ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.location and redis:get(max..'mute_location'..msg.chat_id_) then -- قفل الموقع
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send location \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا ممنوع ارسال الموقع ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.voice and redis:get(max..'mute_voice'..msg.chat_id_) then -- قفل البصمات
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send voice \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا ممنوع ارسال البصمات ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.game and redis:get(max..'mute_game'..msg.chat_id_) then -- قفل الالعاب
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send game \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "│╿عذرا ممنوع لعب الالعاب ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.audio and redis:get(max..'mute_audio'..msg.chat_id_) then -- قفل الصوت
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send audio \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا ممنوع ارسال الصوت ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        elseif msg.replyMarkupInlineKeyboard and redis:get(max..'mute_keyboard'..msg.chat_id_) then -- كيبورد
            Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                print("\27[1;31m Msg Del becuse send keyboard \27[0m")
                if data.ID == "Error" and data.code_ == 6 then
                    return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                end
                if redis:get(max..'lock_woring'..msg.chat_id_) then
                    GetUserID(msg.sender_user_id_,function(arg,data)
                        local msgx = "-› عذرا الكيبورد مقفول ."
                        if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                        local USERCAR = utf8.len(USERNAME)
                        SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                end
            end)
            return false
        end

        if msg.content_ and msg.content_.caption_ then -- الرسايل الي بالكابشن
            print("sdfsd     f- ---------- ")
            if (msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/")
                    or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/")
                    or msg.content_.caption_:match("[Tt].[Mm][Ee]/")
                    or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
                    or msg.content_.caption_:match(".[Pp][Ee]"))
                    and redis:get(max..'lock_link'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send link caption \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-› عذرا ممنوع ارسال الروابط ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif (msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://")
                    or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://")
                    or msg.content_.caption_:match("[Ww][Ww][Ww].")
                    or msg.content_.caption_:match(".[Cc][Oo][Mm]"))
                    and redis:get(max..'lock_webpage'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send webpage caption \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            local msgx = "-› عذرا ممنوع ارسال روابط الويب ."
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            elseif msg.content_.caption_:match("@[%a%d_]+") and redis:get(max..'lock_username'..msg.chat_id_) then
                Del_msg(msg.chat_id_,msg.id_,function(arg,data)
                    print("\27[1;31m Msg Del becuse send username caption \27[0m")
                    if data.ID == "Error" and data.code_ == 6 then
                        return sendMsg(msg.chat_id_,msg.id_,'-› لا يمكنني مسح الرساله المخالفه .\n- لست مشرف او ليس لدي صلاحيه الحذف .')
                    end
                    if redis:get(max..'lock_woring'..msg.chat_id_) then
                        local msgx = "-› عذرا ممنوع ارسال التاك او المعرف  ."
                        GetUserID(msg.sender_user_id_,function(arg,data)
                            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                            local USERCAR = utf8.len(USERNAME)
                            SendMention(msg.chat_id_,data.id_,msg.id_,"-› العضو » "..USERNAME..'\n'..msgx,12,USERCAR) end,nil)
                    end
                end)
                return false
            end

        end --========{ End if } ======

    end
    SaveNumMsg(msg)



    ------------------------------{ Start Replay Send }------------------------

    if msg.text and redis:get(max..'replay'..msg.chat_id_) then

        
        
        local Replay = false
        
                    --======= استقبال الردود العشوائيه ======--
            
            
 GetUserID(msg.sender_user_id_,function(arg,data)
Replay = 0
Replay = redis:smembers(max..':ReplayRandom:'..msg.text)  
if #Replay ~= 0 then  
local Replay = Replay[math.random(#Replay)] 
Replay = convert_Klmat(msg,data,Replay,true) 
local CaptionFilter = Replay:gsub(":Text:",""):gsub(":Document:",""):gsub(":Voice:",""):gsub(":Photo:",""):gsub(":Animation:",""):gsub(":Audio:",""):gsub(":Sticker:",""):gsub(":Video:","") 
Caption = redis:hget(max..':caption_replay:Random:'..msg.text,CaptionFilter) 
Caption = convert_Klmat(msg,data,Caption) 
if Replay:match(":Text:") then 
return sendMsg(msg.chat_id_,msg.id_,Flter_Markdown(Replay:gsub(":Text:",""))) 
elseif Replay:match(":Document:") then  
return sendDocument(msg.chat_id_,msg.id_,Replay:gsub(":Document:",""),Caption)   
elseif Replay:match(":Photo:") then  
return sendPhoto(msg.chat_id_,msg.id_,Replay:gsub(":Photo:",""),Caption)   
elseif Replay:match(":Voice:") then  
return sendVoice(msg.chat_id_,msg.id_,Replay:gsub(":Voice:",""),Caption) 
elseif Replay:match(":Animation:") then  
return sendAnimation(msg.chat_id_,msg.id_,Replay:gsub(":Animation:",""),Caption)   
elseif Replay:match(":Audio:") then  
return sendAudio(msg.chat_id_,msg.id_,Replay:gsub(":Audio:",""),"",Caption)   
elseif Replay:match(":Sticker:") then  
return sendSticker(msg.chat_id_,msg.id_,Replay:gsub(":Sticker:",""))   
elseif Replay:match(":Video:") then  
return sendVideo(msg.chat_id_,msg.id_,Replay:gsub(":Video:",""),Caption) 
end 
end 
 
 

Replay = redis:smembers(max..':ReplayRandom:'..msg.chat_id_..":"..msg.text)  
if #Replay ~= 0 then  
local Replay = Replay[math.random(#Replay)] 
Replay = convert_Klmat(msg,data,Replay,true) 
local CaptionFilter = Replay:gsub(":Text:",""):gsub(":Document:",""):gsub(":Voice:",""):gsub(":Photo:",""):gsub(":Animation:",""):gsub(":Audio:",""):gsub(":Sticker:",""):gsub(":Video:","") 
Caption = redis:hget(max..':caption_replay:Random:'..msg.chat_id_..msg.text,CaptionFilter) 
Caption = convert_Klmat(msg,data,Caption) 
if Replay:match(":Text:") then 
return sendMsg(msg.chat_id_,msg.id_,Flter_Markdown(Replay:gsub(":Text:",""))) 
elseif Replay:match(":Document:") then  
return sendDocument(msg.chat_id_,msg.id_,Replay:gsub(":Document:",""),Caption)   
elseif Replay:match(":Photo:") then  
return sendPhoto(msg.chat_id_,msg.id_,Replay:gsub(":Photo:",""),Caption)   
elseif Replay:match(":Voice:") then  
return sendVoice(msg.chat_id_,msg.id_,Replay:gsub(":Voice:",""),Caption) 
elseif Replay:match(":Animation:") then  
return sendAnimation(msg.chat_id_,msg.id_,Replay:gsub(":Animation:",""),Caption)   
elseif Replay:match(":Audio:") then  
return sendAudio(msg.chat_id_,msg.id_,Replay:gsub(":Audio:",""),"",Caption)   
elseif Replay:match(":Sticker:") then  
return sendSticker(msg.chat_id_,msg.id_,Replay:gsub(":Sticker:",""))   
elseif Replay:match(":Video:") then  
return sendVideo(msg.chat_id_,msg.id_,Replay:gsub(":Video:",""),Caption) 
end 
end 
 



 end)
 
  --======= نهاية استقبال الردود العشوائيه =======--
            
        

        Replay = redis:hget(max..'replay:all',msg.text)
        if Replay then
            sendMsg(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay:'..msg.chat_id_,msg.text)
        if Replay then
            sendMsg(msg.chat_id_,msg.id_,Replay)
            return false
        end
        Replay = redis:hget(max..'replay_photo:group:',msg.text)
        if Replay then
            sendPhoto(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_voice:group:',msg.text)
        if Replay then
            sendVoice(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_animation:group:',msg.text)
        if Replay then
            sendAnimation(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_audio:group:',msg.text)
        if Replay then
            sendAudio(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_sticker:group:',msg.text)
        if Replay then
            sendSticker(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_video:group:',msg.text)
        if Replay then
            print("0000000000000")
            sendVideo(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_photo:group:'..msg.chat_id_,msg.text)
        if Replay then
            sendPhoto(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_voice:group:'..msg.chat_id_,msg.text)
        if Replay then
            sendVoice(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_animation:group:'..msg.chat_id_,msg.text)
        if Replay then
            sendAnimation(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_audio:group:'..msg.chat_id_,msg.text)
        if Replay then
            sendAudio(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_sticker:group:'..msg.chat_id_,msg.text)
        if Replay then
            sendSticker(msg.chat_id_,msg.id_,Replay)
            return false
        end

        Replay = redis:hget(max..'replay_video:group:'..msg.chat_id_,msg.text)
        if Replay then
            sendVideo(msg.chat_id_,msg.id_,Replay)
            return false
        end

        if not Replay then

            --================================{{  Reply Bot  }} ===================================


            local su = {
                "سم أبوي",
                "سم ناشي",
                "لبيه يا بابا",
                "يمه, هلا؟",
                "Dev, tell me.",
                "جعل ما يناديني غيره",
            }

            local ss97 = {
                "لبيه ياعيون بيسو",
                "آآههخخ, لبيييهه سسمم",
                "ياروحها",
                "امرني ياقلب بيسو",
                "ياخي يا حظ بيسو بس 😔",
            }

            local ra97 = {
                "لبيه رهوفتي",
                "كيف البوت يصير كيبورد يا اخوان : ( ",
                "لبيه يا ماما",
                "سمي ماما",
                "لبيه عيوني",
				"يا عروق قلبي, سمي.",
            }

            local M7 = {
                "لبيه  حامودي",
                "الحكيم, امرني. ",
                "سم عمي محمد",
                "يمه, هلا؟",
                "لبيه عيوني",
                "عيوني حمودي",
                "محممااااددد",
            }

            local FS = {
                "لبيه جدو",
                "عيوني فيصل",
                "سم جدي",
            }

            local ABD = {
                "عمي فوالي, امرني.",
                "عايز إيه حضرتك",
                "امرني يسطا",
                "أنداءٌ هذا, أم أنتم لا تفقهون.",
                "كونننيي, لبيه",
            }

            local ISY = {
                "لبيه اسينو",
                "عيوني كوكبي",
                "لبيه خالتي اسيان",
                "سمي ي كوني",
            }



            local sss = {

                "مسلسل يستحق المشاهدة؟",   
                "أفضل نوع عطر بالنسبة لك؟",   
                "مدينة تود زيارتها لقضاء فترة الشتاء ❄️؟",   
                " لقب تُعرف به عند صديقك المقرّب?",   
                "هل تفضّل نوع معين من السيارات أم المهم سيارة جيدة وتقود؟",   
                "أسوأ تطبيق بعد تيك توك؟",   
                "أسوأ ظاهرة منتشرة في مواقع التواصل الاجتماعي؟",   
                "تصوّرك لشكل 2021 وأحداثها؟ ",   
                "أكلة يُحبها جميع أفراد المنزل ما عدا انت؟",   
                " معروف عنك انك فنان في …؟",   
                "‏- بلد تود أن تزورها وتعيش فيها لفترة من الزمن؟✈️",   
                "هل عندك صديق نادر مختلف عن كل الأشخاص الذين تعرّفت عليهم؟",   
                "شخص يقول لك تصرفاتك لا تعجبني غيّرها، لكن أنت ترى أن تصرفاتك عادية، ماذا تفعل؟",   
                "اكتشفت أن الشخص الذي أحببته يتسلى بك لملئ فراغه، موقفك؟",   
                "اكتشفت أن الشخص المقرّب أخبر أصدقائك بِسر مهم عنك، ردة فعلك؟👀",   
                "محظوظ لأني تعرفت على ....؟",   
                "هل تُظهِر حزنك واستيائك من شخص للآخرين أم تفضّل مواجهته في وقتٍ لاحق؟",   
                "أقوى عقاب لشخص مقرّب يتجاهلك؟",   
                "تاريخ جميل لا تنساه؟",   
                "مسلسل كرتوني عالق في ذاكرتك من أيام الطفولة؟",   
                "هل يوجد شخص من عائلتك في الغربة؟ دعوة له ❤️",   
                " كيف تتعامل مع الشخص المُتطفل ( الفضولي ) ؟",   
                "آخر غلطات عمرك؟",   
                " انت حزين اول شخص تتصل عليه؟",   
                " قد تخيلت شي في بالك وصار ؟",   
                " من طلاسم لهجتكم ؟",   
                "كلمة معينة لا يفهمها إلا أصحابك؟",   
                "منشن واحد يقول نكته؟😅",   
                "ما معنَى الحُرية في قامُوسك ؟",   
                "تحب النقاش الطويل ولا تختصر الكلام ؟",   
                "تكلم عن شخص تحبه بدون ماتحط اسمه",   
                "كم تاخذ عشان تثق بأحد؟ و تثق بكثرة المواقف او السنين؟",   
                "من اللي يجب ان يبادر بالحب اول البنت او الولد؟",   
                "‏- شاركنا مقولة أو بيت شعبي يُعجبك؟",   
                "‏- كم تحتاج من وقت لتثق بشخص؟",   
                "‏- شعورك الحالي في جملة؟",   
                "‏- تصوّرك لشكل 2021 وأحداثها؟",   
                "‏- أكلة يُحبها جميع أفراد المنزل ما عدا انت؟",   
                "‏- تحافظ على الرياضة اليومية أم الكسل يسيطر عليك؟",   
                "‏- مبدأ في الحياة تعتمد عليه دائما؟",   
                "‏- نسبة رضاك عن تصرفات مَن تعرفهم في الفترة الأخيرة؟",   
                "‏- كتاب تقرأه هذه الأيام؟",   
                "‏- نسبة رضاك عن تصرفات مَن تعرفهم في الفترة الأخيرة؟",   
                "‏- اكتشفت أن الشخص المقرّب أخبر أصدقائك بِسر مهم عنك، ردة فعلك؟👀",   
                "‏- شخص يقول لك تصرفاتك لا تعجبني غيّرها، لكن أنت ترى أن تصرفاتك عادية، ماذا تفعل؟",   
                "حالياً الاغنية المترأسة قلبك هي؟",   
                "‏- أقوى عقاب بتسويه لشخص مقرّب اتجاهك؟",   
                "‏- هل تُظهِر حزنك واستيائك من شخص للآخرين أم تفضّل مواجهته في وقتٍ لاحق؟",   
                "‏- أكلة يُحبها جميع أفراد المنزل ما عدا انت؟",   
                " مين افخم بوت في التيلجرام?",   
                " ‏- اكتشفت أن الشخص الذي أحببته يتسلى بك لملئ فراغه، موقفك؟",   
                "‏- تاريخ جميل لا تنساه؟",   
                "لو اتيحت لك فرصة لمسح ذكرى من ذاكرتك ماهي هذه الذكرى؟",  
				" -  من علامات الجمال وتعجبك بقوة؟",   
				" -  يومي ضاع على ....؟",   
				" -  أكثر شيء تقدِّره في الصـداقات؟",   
				" -  صفة تُجمّل الشخـص برأيك؟",   
				" -  كلمة غريبة من لهجتك ومعناها؟",   
				" -  شيء تتميز فيه عن الآخرين؟",   
				" -  صريح كيف سيكون العالم لو كنا جميعا مثلك؟🌚",   
				" -  المدمّر الصغير في بيتكم، ما اسمه؟👶🏻😅",   
				" -  فاقِد العقل يُسمى بالمجنون، ماذا عن فاقد القلب؟",   
				" -  لو كان السفر مجانًا، أين ستكون الآن؟✈️",   
				" -  تتخيل/ي نفسك مستعد لتحمّل مسؤولية تكوين أسرة وأطفال؟🏃🏻‍♂️",   
				" -  هل مر فى حياتك شخص كنت تعتبره محل ثقة، ثم اكتشفت أنه محل أحذية؟",   
				" -  يقولون، السهرانين للآن أجمل ناس، تتفق؟😴↗️",   
				" -  بماذا تناديك والدتك عادةً غير اسمك؟😁❤️",   
				" -  مشروبك الساخن المفضّل؟☕️",   
				" -  تعرف ترد بسرعة على الكلام الحلو، أم تصمت لوهلة؟😅❤️",   
				" -  حكمة لا تغيب عن بالك؟",   
				" -  هل يفسد البلوك للود قضية؟",   
				" -  صفة فيك ترفع ضغط اللي حوليك؟🌚",   
				" -  ‏وش أول جهاز جوال اشتريته ؟؟",   
				" -  ‏وش اول برنامج تفتحه لما تصحى من النوم وتمسك جوالك ؟",   
				" -  ‏كلما ازدادت ثقافة المرء ازداد بؤسه, تتفق؟",   
				" -  ‏برايك من أهم مخترع المكيف ولا مخترع النت ؟",   
				" -  ‏وش رايك بالزواج المبكر ؟",   
				" -  ‏وش أكثر صفه ماتحبها بشخصيتك  ؟",   
				" -  ‏من اللي يجب ان يبادر بالحب اول البنت لو الولد؟",   
				" -  ‏هل تعايشت مع الوضع الى الان او لا؟",   
				" -  ‏كيفك مع العناد؟",   
				" -  ‏هل ممكن الكره يتبدل؟",   
				" -  ‏بشنو راح ترد اذا شخص استفزك؟",   
				" -  ‏كم زدت او نقصت وزن في الفتره ذي؟",   
				" -  ‏تشوف في فرق بين الجرأة والوقاحة؟",   
				" -  ‏اكثر مدة م نمت فيها؟",   
				" -  ‏اغلب قراراتك الصح تكون من قلبك وله عقلك؟",   
				" -  ‏كم تريد يكون طول شريكك؟",   
				" -  ‏لو فونك بيد احد اكثر برنامج م تبيه يدخله هو؟",   
				" -  ‏اعظم نعمة من نعم الله عندك؟.",   
				" -  ‏اغلب فلوسك تروح على وش؟",   
				" -  ‏رايك بالناس اللي تحكم ع الشخص من قبيلته؟.",   
				" -  ‏اكثر اسم تحب ينادوك فيه؟",   
				" -  كم من مية تحب تشوف مباريات؟",   
				" -  ‏اكثر شي مع اهل امك وله ابوك؟",   
				" -  ‏صراحةً شكل الشخص يهم اذا انت بتحب شخص؟",   
				" -  ‏فراق الصديق ام فراق الحبيب ايهم اسوء؟",   
                " -  مين أعظم وأفخم بوت في التيلي؟",
				" -  كم لغة تتقن؟",
				" -  وش اجمل لغة برأيك؟", 
				" -  تحب الكيبوب؟",
				" -  فالتواصل مع الناس تفضل الدردشه كتابياً ولا المكالمات الصوتيه؟", 
				" -  في أي سنة بديت تستخدم تطبيقات التواصل الإجتماعي؟",
				" -  شاركنا أغنية غريبة تسمعها دايم؟",
				" -  عن ماذا تبحث؟",
				" -  تحبني ولا تحب الدراهم؟", 
				" -  انا أحبك, وانت؟", 
				" -  روحك تنتمي لمكان غير المكان اللي انت عايش فيه؟",
				" -  كيف تتصرف لو تغيّر عليك أقرب شخص؟",
                " - ‏أغبى نصيحة وصلتك؟",
                " - هل اقتربت من تحقيق أحد أهدافك؟",
                " - رأيك بمن يستمر في علاقة حب مع شخص وهو يعلم أنه على علاقة حب مع غيره؟",
                "‏ - شخصية تاريخية تُحبها؟",
                " - ‏كم ساعة نمت؟",
                " - أكثر شخصية ممكن تستفزك؟",
                " - ‏كلمة لمتابعينك؟",
                "‏ - أجمل شعــور؟",
                " - أسوأ شعور؟",
                " - أقبح العادات المجتمعية في بلدك؟",
                " - أحب مُدن بلادك إلى قلبك؟",
                "‏ - أصعب أنواع الانتظار؟",
                " - ‏ ماذا لو لم يتم اختراع الانترنت؟",
                " - هل تعتقد أن امتلاكك لأكثر من صديق أفضل من امتلاكك لصديق واحد؟",
                " - ‏ردة فعلك على شخص يقول لك: ما حد درى عنك؟",
                " - كتاب تقرأه هذه الأيام؟",
                " - ‏هل صحيح الشوق ياخذ من العافية ؟",
                " - ‏لماذا الانسان يحب التغيير ؟ حتى وان كان سعيدا !",
                "‏ - الاحباط متى ينال منك ؟",
                " - ‏بعد مرور اكثر من عام هل مازال هناك من يعتقد ان كورونا كذبة  ؟",
                " - هل  تشمت بعدوك وتفرح لضرره مهما كان الضرر قاسيا  ؟",
                " - ‏ان كانت الصراحة ستبعد عنك من تحب هل تمتلك الشجاعة للمصارحة  ام لا ؟",
                " - ‏ماهو حلك اذا اصابك الارق ؟",
                " - ‏ماهو الامر  الذي لايمكن ان تسمح به ؟",
                "‏ - هل تلتزم بمبادئك وان كان ثمنها غاليا ؟",
                " - ‏ماهو اولى اولوياتك في الحياة ؟",
                " - لو خيرت بين ان تعيش وحيدا برفاه  او بين الاحباب بشقاء ماذا ستختار ؟",
                " - هل تلجأ الى شخص ينتظر سقوطك وهو الوحيد الذي بامكانه مساعدتك ؟",
                " - ‏اكثر شيء تحب امتلاكه ؟",
                " - معنى الراحة بالنسبة لك ؟",
                " - عرف نفسك بكلمة ؟",
                "‏ - لماذا لا ننتبه إلا حينما تسقُط الأشياء ؟",
                " - ‏هل شعرت يومًا أنَّك تحتاج لطرح سؤال ما، لكنَّك تعرف في قلبك أنَّك لن تكون قادرًا على التعامل مع الإجابة؟",
                " - ‏هل تبحث عن الحقيقة وهناك احتمال بانها ستكون قاسية عليك ؟",
                " - ‏هل ظننت أن الأمر الذي أجلتهُ مرارًا لن تواجهه لاحقًا ؟",
                " - قهوتك المفضلة وفي اي وقت تفضلها ؟",
                " - ‏تطبيق مستحيل تحذفه؟",
                " - ‏تسلك كثير ولا صريح؟",
                " - ‏كلمة دايم تقولها؟",
                " - كيف تعرف ان هالشخص يحبك ؟",
                " - ‏ايش الشي الي يغير جوك ويخليك سعيد؟",
                "‏ - تقدر تتقبل رأي الكل حتى لو كان غلط؟",
                " - أكثر شيء تحبه في نفسك؟",
                " - يا ليت كل الحياة بدايات.. مع أو ضد؟",
                " - ما هي العناصر التي تؤمن النجاح في الحياة بنظرك؟",
                " - هل تعاتِب من يُخطئ بحقك أم تتبع مبدأ التجاهل؟",
                " - كم لعبة في هاتفك؟",
                " - أجمل مرحلة دراسية مرت بحياتك؟",
                " - ما هو مفتاح القلوب؟ الكلمة الطيبة أم الجمال؟",
                " - الخصام لا يعني الكُره.. تتفقون؟",
                " - مِن مواصفات الرجل المثالي؟",
                " - ما رأيك بمقولة: الناس معك على قد ما معك؟",
                " - كلمة لمن يتصفح حسابك بشكل يومي؟",
                " - خُرافة كنت تصدقها في طفولتك؟",
                " - ‏ إنما الناس لطفاء بحجم المصلحة.. مع أو ضد؟",
                " - ‏ حلم تفكر به دائمًا لكن تعلم دائما أن نسبة تحقيقه ضئيلة؟💔",
                " - لو كان الأمر بيدك، ما أول قاعدة ستقوم بتطبيقها؟",
                " - يزيد احترامي لك، لمّا ....؟",
                " - هل سبق وأُعجبت بشخص من أسلوبه؟",
                " - كل شيء يتعوّض إلا .. ؟",
                " - ما النشاط الذي لن تمل يوماً من فعله؟",
                " - ‏ لَون تتفاءل فيه؟",
                " - تعتبر نفسك من النوع الصريح؟ أم تجامل بين الحين والآخر؟",
                " - أكثر سؤال يثير غضبك؟",
                " - أكثر شيء يضيع منك؟😅",
                " - شيء سلبي في شخصيتك وتود التخلص منه؟",
                " - ‏- هل تتذكر نوع أول هاتف محمول حصلت عليه؟",
                " - اكثر مكان تحب تروح له ف الويكند ؟",
                " - كم وجبه تاكل ف اليوم ؟",
                " - منشن شخص فاهمك ف كل شيء ؟",
                " - من علامات روقانك ؟",
                " - تشوف انو التواصل بشكل يومي من اساسيات الحب ؟",
                " - كيف تتصرف مع شخص تكلمه في سالفه مهمه ويصرفك ؟",
                " - هل برأيك أن عبارة محد لأحد صحيحه ام تعقتد عكس ذلك؟",
                " - شي مشتهر فيه عند عايلتك؟",
                " - اكثر مكان تكتب فيه  وتفضفض ؟",
                " - وقفة إحترام للي إخترع ؟",
                " - أقدم شيء محتفظ فيه من صغرك؟",
                " - أمنيه تمنيتها وتحققت؟",
                " - شي ما تستغني عنه ف الطلعات ؟",
                " - لغة تود تعلمها ؟",
                " - اكثر شي مضيع عليه فلوسك ؟",
                " - هل انت من الناس اللي تخطط وتفكر كثير قبل ماتتكلم؟",
                " - اهم نصيحه للنجاح بشكل عام ؟",
                " - كيف تتعاملون مع شخص كنت طيب معه و تمادى صار يحس كل شئ منك مفروض و واجب بالغصب؟!",
                " - شي نفسك تجربه ؟",
                " - أشياء توترك ؟",
                " - لعبة تشوف نفسك فنان فيها ؟",
                " - اكثر مبلغ ضيعته ؟",
                " - تعتمد على غيرك كثير ؟.",
                " - ردة فعلك اذا احد قام يهاوشك بدون سبب ؟",
                " - لو خيروك، سفرة عمل أو إجازة في البيت؟",
                " - اكثر شي يعتمدون عليك فيه ؟",
                " - موقفك من شخص أخفى عنك حقيقة ما، تخوفًا من خسارتك؟",
                " - الوضع مع ابوك فله ولا رسمي؟",
                " - ما الذي يرضي المرأه الغاضبه ؟",
                " - كيف تتعامل مع الاشخاص السلبيين ؟",
                " - تتكلم عن الشخص اللي تحبه قدام الناس ؟",

            }
            local Text = msg.text
            local Text2 = Text:match("^"..Bot_Name.." (%d+)$")

            if msg.SudoBase and Text == Bot_Name and not Text2 then
                return sendMsg(msg.chat_id_,msg.id_,su[math.random(#su)])
                elseif msg.SudoBaseV and Text== Bot_Name and not Text2 then
                return sendMsg(msg.chat_id_,msg.id_,ra97[math.random(#ra97)])
				elseif msg.SudoBaseM and Text== Bot_Name and not Text2 then
                return sendMsg(msg.chat_id_,msg.id_,M7[math.random(#M7)])
				elseif msg.SudoBaseA and Text== Bot_Name and not Text2 then
                return sendMsg(msg.chat_id_,msg.id_,ABD[math.random(#ABD)])
                elseif msg.SudoBaseP and Text== Bot_Name and not Text2 then
                return sendMsg(msg.chat_id_,msg.id_,ISY[math.random(#ISY)])
                 elseif msg.SudoBaseF and Text== Bot_Name and not Text2 then
                return sendMsg(msg.chat_id_,msg.id_,FS[math.random(#FS)])
                elseif not msg.SudoBase and Text== Bot_Name and not Text2 then
                return sendMsg(msg.chat_id_,msg.id_,ss97[math.random(#ss97)])
                elseif not msg.SudoUser and Text=="تويت" or Text == "كت تويت" then
                if
                redis:get(max..'lock_qt'..msg.chat_id_) then
                    return
                    sendMsg(msg.chat_id_,msg.id_,sss[math.random(#sss)])
                end
            end
            if msg.SudoUser and Text == Bot_Name and not Text2 then
                return
                --          elseif Text== "ايديي" or Text=="ايدي 🆔" then
                --        GetUserID(msg.sender_user_id_,function(arg,data)
                --            if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                --            local USERCAR = utf8.len(USERNAME)
                --            SendMention(msg.chat_id_,data.id_,msg.id_,"-› تفضل الايدي والمعرف \n\n "..USERNAME.." ━  "..data.id_.."  ",37,USERCAR)
                --            return false
                --        end)
            elseif Text== "ايديي" or Text=="ايدي 🆔" then
                GetUserID(msg.sender_user_id_,function(arg,data)
                    if data.username_ then USERNAME = '@'..data.username_ else USERNAME = FlterName(data.first_name_..' '..(data.last_name_ or "")) end
                    local USERCAR = utf8.len(USERNAME)
                    SendMention(msg.chat_id_,data.id_,msg.id_,"-› تفضل الايدي والمعرف \n\n "..USERNAME.." ~⪼ ( "..data.id_.." )",37,USERCAR)
                    return false
                end)
            elseif Text=="ابي رابط الحذف" or Text=="ابي رابط حذف" or Text=="رابط حذف" or Text=="رابط الحذف" then
                return sendMsg(msg.chat_id_,msg.id_,[[
- رابط حذف حساب التليجرام
[- اضغط هنا -](https://telegram.org/deactivate) .
]] )
                --=====================================

            end




        end


    end


    ------------------------------{ End Replay Send }------------------------

    ------------------------------{ Start Checking CheckExpire }------------------------

    if not redis:get('kar') then
        redis:setex('kar',86400,true)
        json_data = '{"BotID": '..max..',"UserBot": "'..Bot_User..'","Groups" : {'
        local All_Groups_ID = redis:smembers(max..'group:ids')
        for key,GroupS in pairs(All_Groups_ID) do
            local NameGroup = (redis:get(max..'group:name'..GroupS) or "")
            NameGroup = NameGroup:gsub('"',"")
            NameGroup = NameGroup:gsub([[\]],"")
            if key == 1 then
                json_data =  json_data ..'"'..GroupS..'":{"Title":"'..NameGroup..'"'
            else
                json_data =  json_data..',"'..GroupS..'":{"Title":"'..NameGroup..'"'
            end
            local admins = redis:smembers(max..'admins:'..GroupS)
            if #admins ~= 0 then
                json_data =  json_data..',"Admins" : {'
                for key,value in pairs(admins) do
                    local info = redis:hgetall(max..'username:'..value)
                    if info then
                        UserName_ = (info.username or "")
                        UserName_ = UserName_:gsub([[\]],"")
                        UserName_ = UserName_:gsub('"',"")
                    end
                    if key == 1 then
                        json_data =  json_data..'"'..UserName_..'":'..value
                    else
                        json_data =  json_data..',"'..UserName_..'":'..value
                    end
                end
                json_data =  json_data..'}'
            end
            local creator = redis:smembers(max..':KARA_BOT:'..GroupS)
            if #creator ~= 0 then
                json_data =  json_data..',"Kara" : {'
                for key,value in pairs(creator) do
                    local info = redis:hgetall(max..'username:'..value)
                    if info then
                        UserName_ = (info.username or "")
                        UserName_ = UserName_:gsub([[\]],"")
                        UserName_ = UserName_:gsub('"',"")
                    end
                    if key == 1 then
                        json_data =  json_data..'"'..UserName_..'":'..value
                    else
                        json_data =  json_data..',"'..UserName_..'":'..value
                    end
                end
                json_data =  json_data..'}'
            end
            local owner = redis:smembers(max..'owners:'..GroupS)
            if #owner ~= 0 then
                json_data =  json_data..',"Owner" : {'
                for key,value in pairs(owner) do
                    local info = redis:hgetall(max..'username:'..value)
                    if info then
                        UserName_ = (info.username or "")
                        UserName_ = UserName_:gsub([[\]],"")
                        UserName_ = UserName_:gsub('"',"")
                    end
                    if key == 1 then
                        json_data =  json_data..'"'..UserName_..'":'..value
                    else
                        json_data =  json_data..',"'..UserName_..'":'..value
                    end
                end
                json_data =  json_data..'}'
            end
            json_data =  json_data.."}"
        end
        local Save_Data = io.open("./inc/"..Bot_User..".json","w+")
        Save_Data:write(json_data..'}}')
        Save_Data:close()
        sendDocument(SUDO_ID,0,"./inc/"..Bot_User..".json","- ملف نسخه تلقائيه\n-  اليك مجموعاتك » { "..#All_Groups_ID.." }- للبوت » "..Bot_User.."\n- التاريخ » "..os.date("%Y/%m/%d").."\n",dl_cb,nil)
    end
    if redis:get(max..'CheckExpire::'..msg.chat_id_) then
        local ExpireDate = redis:ttl(max..'ExpireDate:'..msg.chat_id_)
        if not ExpireDate and not msg.SudoUser then
            rem_data_group(msg.chat_id_)
            sendMsg(SUDO_ID,0,'🕵🏼️‍♀️╿انتهى الاشتراك في احد المجموعات ✋🏿\n👨🏾‍🔧│المجموعه : '..FlterName(redis:get(max..'group:name'..msg.chat_id_))..'🍃\n💂🏻‍♀️╽ايدي : '..msg.chat_id_)
            sendMsg(msg.chat_id_,0,'🕵🏼️‍♀️╿انتهى الاشتراك البوت✋🏿\n💂🏻‍♀️│سوف اغادر المجموعه فرصه سعيده 👋🏿\n👨🏾‍🔧╽او راسل Dev للتجديد '..SUDO_USER..' 🍃')
            return StatusLeft(msg.chat_id_,our_id)
        else
            local DaysEx = (redis:ttl(max..'ExpireDate:'..msg.chat_id_) / 86400)
            if tonumber(DaysEx) > 0.208 and ExpireDate ~= -1 and msg.Admin then
                if tonumber(DaysEx + 1) == 1 and not msg.SudoUser then
                    sendMsg(msg.chat_id_,'🕵🏼️‍♀️╿باقي يوم واحد وينتهي الاشتراك ✋🏿\n👨🏾‍🔧╽راسل Dev للتجديد '..SUDO_USER..' .')
                end
            end
        end
    end

    ------------------------------{ End Checking CheckExpire }------------------------


end


return {
    max = {
        "^(تقييد)$",
        "^(تقييد) (%d+)$",
        "^(تقييد) (@[%a%d_]+)$",
        "^(فك التقييد)$",
        "^(فك التقييد) (%d+)$",
        "^(فك التقييد) (@[%a%d_]+)$",
        "^(فك تقييد)$",
        "^(فك تقييد) (%d+)$",
        "^(فك تقييد) (@[%a%d_]+)$",
        "^(ضع شرط التفعيل) (%d+)$",
        "^(التفاعل)$",
        "^(التفاعل) (@[%a%d_]+)$",
        "^([iI][dD])$",
        "^(تفعيل الايدي بالصوره)$",
        "^(تعطيل الايدي بالصوره)$",
        "^(تعطيل الرفع)$",
        "^(تفعيل الرفع)$",
        "^(قفل الدخول بالرابط)$",
        "^(فتح الدخول بالرابط)$",
        "^(ايدي)$",
        "^(ايدي) (@[%a%d_]+)$",
        "^(كشف)$",
        "^(كشف) (%d+)$",
        "^(كشف) (@[%a%d_]+)$",
        '^(رفع مميز)$',
        '^(رفع مميز) (@[%a%d_]+)$',
        '^(رفع مميز) (%d+)$',
        '^(تنزيل مميز)$',
        '^(تنزيل مميز) (@[%a%d_]+)$',
        '^(تنزيل مميز) (%d+)$',
        '^(رفع نائب مدير)$',
        '^(رفع نائب مدير) (@[%a%d_]+)$',
        '^(رفع نائب مدير) (%d+)$',
        '^(تنزيل نائب مدير)$',
        '^(تنزيل نائب مدير) (@[%a%d_]+)$',
        '^(تنزيل نائب مدير) (%d+)$',
        '^(رفع المدير)$',
        '^(رفع مدير)$',
        '^(رفع مدير) (@[%a%d_]+)$',
        '^(رفع المدير) (@[%a%d_]+)$',
        '^(رفع المدير) (%d+)$',
        '^(رفع مدير) (%d+)$',
        '^(رفع مالك اساسي)$',
        '^(رفع مالك اساسي) (@[%a%d_]+)$',
        '^(تنزيل مالك اساسي)$',
        '^(تنزيل مالك اساسي) (%d+)$',
        '^(تنزيل مالك اساسي) (@[%a%d_]+)$',
        '^(رفع مالك)$',
        '^(رفع مالك) (@[%a%d_]+)$',
        '^(تنزيل مالك)$',
        '^(تنزيل مالك) (%d+)$',
        '^(تنزيل مالك) (@[%a%d_]+)$',
        '^(تنزيل المدير)$',
        '^(تنزيل مدير)$',
        '^(تنزيل مدير) (@[%a%d_]+)$',
        '^(تنزيل المدير) (@[%a%d_]+)$',
        '^(تنزيل المدير) (%d+)$',
        '^(تنزيل مدير) (%d+)$',
        '^(صلاحياته)$',
        '^(صلاحياتي)$',
        '^(صلاحياته) (@[%a%d_]+)$',
        '^(قفل) (.+)$',
        '^(فتح) (.+)$',
        '^(تفعيل)$',
        '^(تفعيل) (.+)$',
        '^(تعطيل)$',
        '^(تعطيل) (.+)$',
        '^(ضع تكرار) (%d+)$',
        "^(مسح)$",
        "^(مسح) (.+)$",
        '^(اضف رد مطور) (.+)$',
        '^(مسح رد مطور) (.+)$',
        '^(منع) (.+)$',
        '^(الغاء منع) (.+)$',
        "^(حظر عام)$",
        "^(حظر عام) (@[%a%d_]+)$",
        "^(حظر عام) (%d+)$",
        "^(الغاء العام)$",
        "^(الغاء العام) (@[%a%d_]+)$",
        "^(الغاء العام) (%d+)$",
        "^(الغاء عام)$",
        "^(الغاء عام) (@[%a%d_]+)$",
        "^(الغاء عام) (%d+)$",
        "^(حظر)$",
        "^(حظر) (@[%a%d_]+)$",
        "^(حظر) (%d+)$",
        "^(الغاء الحظر)$",
        "^(الغاء الحظر) (@[%a%d_]+)$",
        "^(الغاء الحظر) (%d+)$",
        "^(الغاء حظر)$",
        "^(الغاء حظر) (@[%a%d_]+)$",
        "^(الغاء حظر) (%d+)$",
        "^(طرد)$",
        "^(طرد) (@[%a%d_]+)$",
        "^(طرد) (%d+)$",
        "^(كتم)$",
        "^(كتم) (@[%a%d_]+)$",
        "^(كتم) (%d+)$",
        "^(الغاء الكتم)$",
        "^(الغاء الكتم) (@[%a%d_]+)$",
        "^(الغاء الكتم) (%d+)$",
        "^(الغاء كتم)$",
        "^(الغاء كتم) (@[%a%d_]+)$",
        "^(الغاء كتم) (%d+)$",
        "^(رفع D)$",
        "^(رفع D) (@[%a%d_]+)$",
        "^(رفع D) (%d+)$",
        "^(تنزيل D)$",
        "^(تنزيل D) (%d+)$",
        "^(تنزيل D) (@[%a%d_]+)$",
        "^(رفع R)$",
        "^(رفع R) (@[%a%d_]+)$",
        "^(رفع R) (%d+)$",
        "^(تنزيل R)$",
        "^(تنزيل R) (%d+)$",
        "^(تنزيل R) (@[%a%d_]+)$",
		"^(رفع F)$",
        "^(رفع F) (@[%a%d_]+)$",
        "^(رفع F) (%d+)$",
        "^(تنزيل F)$",
        "^(تنزيل F) (%d+)$",
        "^(تنزيل F) (@[%a%d_]+)$",
        "^(رفع فوله)$",
        "^(رفع فوله) (@[%a%d_]+)$",
        "^(رفع فوله) (%d+)$",
        "^(تنزيل فوله)$",
        "^(تنزيل فوله) (%d+)$",
        "^(تنزيل فوله) (@[%a%d_]+)$",
        "^(رفع كوكب)$",
        "^(رفع كوكب) (@[%a%d_]+)$",
        "^(رفع كوكب) (%d+)$",
        "^(تنزيل كوكب)$",
        "^(تنزيل كوكب) (%d+)$",
        "^(تنزيل كوكب) (@[%a%d_]+)$",
		        "^(رفع M)$",
        "^(رفع M) (@[%a%d_]+)$",
        "^(رفع M) (%d+)$",
        "^(تنزيل M)$",
        "^(تنزيل M) (%d+)$",
        "^(تنزيل M) (@[%a%d_]+)$",
        "^(تعطيل) (-%d+)$",
        "^(الاشتراك) ([123])$",
        "^(الاشتراك)$",
        "^(تنزيل الكل)$",
        "^(شحن) (%d+)$",
        "^(المجموعة)$",
        "^(كشف البوت)$",
        "^(انشاء رابط)$",
        "^(ضع الايدي)$",
        "^(مسح الايدي)$",
        "^(ضع الرابط)$",
        "^(تثبيت)$",
        "^(الغاء التثبيت)$",
        "^(الغاء تثبيت)$",
        "^(رابط)$",
        "^(الرابط)$",
        "^(ضع رابط)$",
        "^(رابط خاص)$",
        "^(الرابط خاص)$",
        "^(يوتيوب؟) (.+)$",
        "^(يوتيوب!) (.+)$",
        "^(القوانين)$",
        "^(ضع القوانين)$",
        "^(ضع قوانين)$",
        "^(ضع تكرار)$",
        "^(ضع التكرار)$",
        "^(نائبين المدراء)$",
        "^(منشن للكل)$",
        "^(كشف المجموعة)$",
        "^(منشن)$",
        "^(قائمة المنع)$",
        "^(المدراء)$",
        "^(المميزين)$",
        "^(المكتومين)$",
        "^(ضع الترحيب)$",
        "^(الترحيب)$",
        "^(المالك الاساسي)$",
        "^(المحظورين)$",
        "^(ضع اسم)$",
        "^(ضع صوره)$",
        "^(ضع وصف)$",
        "^(طرد البوتات)$",
        "^(كشف البوتات)$",
        "^(طرد المحذوفين)$",
        "^(رسائلي)$",
        "^(رسايلي)$",
        "^(احصائياتي)$",
        "^(معلوماتي)$",
        "^(مسح معلوماتي)$",
        "^(موقعي)$",
        "^(رفع المشرفين)$",
        "^(صوره الترحيب)$",
        "^(اضف رد المطور)$",
        "^(المطور)$",
        "^(شرط التفعيل)$",
        "^(قائمة المجموعات)$",
        "^(المجموعات)$",
        "^(-المجموعات-)$",
        "^(المشتركين)$",
        "^(-المشتركين-)$",
        "^(قائمة العام)$",
        "^(قائمة العام 📜)$",
        "^(قائمة Dev)$",
        "^(قائمة Dev🎖)$",
        "^(قائمة DV)$",
        "^(قائمة D)$",
        "-^(تيست)$",
        "^(test)$",
        "^(ايديي)$",
        "^(قناة السورس)$",
        "^(الاحصائيات)$",
        "^(-الاحصائيات-)$",
        "^(اضف رد عام)$",
        "^(-اضف رد عام-)$",
        "^(مسح الردود)$",
        "^(مسح الردود العامه)$",
        "^(ضع اسم للبوت)$",
        "^(مسح الصوره)$",
        "^(مسح رد)$",
        "^(الردود)$",
        "^(الردود العامه)$",
        "^(-الردود العامه-)$",
        "^(اضف رد)$",
        "^(/UpdateSource)$",
        "^(اضف رد مطور)$",
        "^(-تحديث السورس-)$",
        "^(تحديث السورس)$",
        "^(رتبتي)$",
        "^(-ضع اسم للبوت-)$",
        "^(-ضع صوره للترحيب-)$",
        "^(ضع صوره للترحيب)$",
        "^(الحمايه)$",
        "^(الاعدادات)$",
        "^(الوسائط)$",
        "^(-الغاء الامر-)$",
        "^(الرتبه)$",
        "^(الغاء)$",
        "^(تعديلاتي)$",
        "^(اسمي)$",
        "^(التاريخ)$",
        "^(/[Ss]tore)$",
        "^(اصدار السورس)$",
        "^(الاصدار)$",
        "^(server)$",
        "^(السيرفر)$",
        "^(فحص البوت)$",
        "^(نسخه احتياطيه للمجموعات)$",
        "^(احظرني)$",
        "^(اطردني)$",
        "^(جهاتي)$",
        "^(تعطيل الكت تويت )$",
        "^(تفعيل الكت تويت )$",
        "^(كت تويت)$",
        "^(الكت تويت)$",







        "^(السورس)$",
        "^(سورس)$",
        "^(م M)$",
        "^(الاوامر)$",
        "^(م1)$",
        "^(م2)$",
        "^(م3)$",
        "^(م4)$",
        "^(م5)$",
        "^(تحديث)$",
        "^(التسلية)$",
        "^(التسليه)$",
    },
    imax = imax,
    dmax = dmax,
}
