--[[
LuCI - Lua Configuration Interface

Copyright 2010 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

m = Map("sguclient", "SGUClient LuCI", translate("ShaoGuan University 3rd Party Network Authentication Client")
        .. [[<br/>]]
        .. translate("SGUClient is free, You can get the software and source code from")
        .. [[&nbsp;]]
        .. [[<a href="https://github.com/FurryAcetylCoA/sguclient" target="_blank">]]
        .. "Github"
        .. [[</a><br/>]]
        .. translate("QQ Group:")
        .. [[&nbsp;]]
        .. [[<a href="https://jq.qq.com/?_wv=1027&k=C9jldpAy" style='color:red' target="_blank">]]
        .. "638138948"
        .. [[</a>]]
)

m:section(SimpleSection).template  = "sguclient/sguclient_status"

s = m:section(TypedSection, "sguclient", translate("General Settings"))
s.addremove = false
s.anonymous = true
s:option(Flag, "enable", translate("Enable"), translate("Main control of SGUClient"))
s:option(Value, "username", translate("1x Username"), translate("Fill in your 802.1x username"))
s:option(Value, "password", translate("1x Password"), translate("Fill in your 802.1x password")).password = true
isptype = s:option(ListValue, "isptype", translate("ISP Type"), translate("Chose your ISP Type"))
isptype:value("D", translate("CTCC(DX)"))
isptype:value("Y", translate("CMCC(YD)"))
ifname = s:option(ListValue, "ifname", translate("AuthInterface"), translate("Chose your authentication interface"))
for _, network in pairs(luci.sys.net.devices()) do
    if network ~= "lo" then
        for _, v in pairs(nixio.getifaddrs()) do
            if v.family == "inet" and v.name == network then
                ifip = v.addr
                ifname:value(network, translate("%s (%s)" % { network, ifip }))
            end
        end
    end
end

s = m:section(NamedSection, "config", "sguclient", translate("Extra Settings"))
s.addremove = false
s.anonymous = true
s:option(Flag, "autoreconnect", translate("Auto Reconnect"), translate("Suggest enable(Otherwise, the program will only be reconnected five times)"))
s:option(Flag, "noheartbeat", translate("No 1x Heart Beat"), translate("No 802.1x heart beat and cancel alarm(Generally NOT checked)"))
s:option(Flag, "debug", translate("Debug mode"), translate("Logs will not be cleared automatically in debug mode, and the log will be more detailed(Do not open it for a long time)"))

local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/etc/init.d/sguclient restart")
end

return m
