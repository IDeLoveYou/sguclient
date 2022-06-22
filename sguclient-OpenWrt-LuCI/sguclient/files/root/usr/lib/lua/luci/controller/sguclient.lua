module("luci.controller.sguclient", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/sguclient") then
        return
    end
    entry({ "admin", "network", "sguclient" }, alias( "admin", "network", "sguclient", "client" ),_("SGUClient LuCI"), 50).dependent = true
    entry({ "admin", "network", "sguclient", "client" }, cbi("sguclient/sguclient"), _("SGUClient LuCI"), 1)
    entry({ "admin", "network", "sguclient", "log" }, cbi("sguclient/log"), _("Log"), 2).leaf = true
    entry({ "admin", "network", "sguclient", "status" }, call("act_status")).leaf = true
end

function act_status()
    local e = {}
    e.running = luci.sys.call("pgrep -f sgud.sh >/dev/null") == 0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
