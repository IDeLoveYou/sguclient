module("luci.controller.sguclient", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/sguclient") then
        return
    end
    entry({ "admin", "network", "sguclient" }, alias( "admin", "network", "sguclient", "client" ),_("SGUClient LuCI"), 80)
    entry({ "admin", "network", "sguclient", "client" }, cbi("sguclient/sguclient"), _("SGUClient LuCI"), 10)
    entry({ "admin", "network", "sguclient", "status" }, call("act_status")).leaf = true
    entry({ "admin", "network", "sguclient", "log" }, template("sguclient/sguclient_log"), _("Log"), 20).leaf = true
    entry({ "admin", "network", "sguclient", "load_log" }, call("load_log")).leaf = true
end

function act_status()
    local e = {}
    e.running = luci.sys.call("pgrep -f sgud.sh >/dev/null") == 0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end

function load_log()
    luci.http.prepare_content("application/json")
    local log = io.popen("cat /var/log/sguclient.log 2>/dev/null")
    local content = log:read("*a")
    luci.http.write(content)
    log:close()
end

