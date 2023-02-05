--[[
**
**  obs-studio.lua -- OBS Studio Lua Script for VDON Call Configuration
**  Copyright (c) 2022-2023 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
**
--]]

--  global OBS API
local obs = obslua

--  global context information
local ctx = {
    --  properties
    propsDef      = nil,
    propsDefBase  = nil,
    propsDefOrg   = nil,
    propsDefRoom  = nil,
    propsVal      = {},
    propsValBase  = "https://caller.studio/",
    propsValOrg   = "example",
    propsValRoom  = "example",
}

--  update a single target browser source
local function updateBrowserSource (name, url)
    local source = obs.obs_get_source_by_name(name)
    if source ~= nil then
        local settings = obs.obs_source_get_settings(source)
        obs.obs_data_set_string(settings, "url", url)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end

--  update entire configuration
local function updateConfiguration ()
    local baseURL  = ctx.propsVal.textBase
	local orgName  = ctx.propsVal.textOrg
	local roomName = ctx.propsVal.textRoom
    local url      = string.format("%s#/%s/%s", baseURL, orgName, roomName)
    updateBrowserSource("Caller-1-Camera-VDON",  url .. "/C1?stream=camera")
    updateBrowserSource("Caller-1-Content-VDON", url .. "/C1?stream=content")
    updateBrowserSource("Caller-2-Camera-VDON",  url .. "/C2?stream=camera")
    updateBrowserSource("Caller-2-Content-VDON", url .. "/C2?stream=content")
    updateBrowserSource("Caller-3-Camera-VDON",  url .. "/C3?stream=camera")
    updateBrowserSource("Caller-3-Content-VDON", url .. "/C3?stream=content")
    updateBrowserSource("Caller-4-Camera-VDON",  url .. "/C4?stream=camera")
    updateBrowserSource("Caller-4-Content-VDON", url .. "/C4?stream=content")
    updateBrowserSource("Caller-5-Camera-VDON",  url .. "/C5?stream=camera")
    updateBrowserSource("Caller-5-Content-VDON", url .. "/C5?stream=content")
    updateBrowserSource("Caller-6-Camera-VDON",  url .. "/C6?stream=camera")
    updateBrowserSource("Caller-6-Content-VDON", url .. "/C6?stream=content")
    updateBrowserSource("Caller-7-Camera-VDON",  url .. "/C7?stream=camera")
    updateBrowserSource("Caller-7-Content-VDON", url .. "/C7?stream=content")
    updateBrowserSource("Caller-8-Camera-VDON",  url .. "/C8?stream=camera")
    updateBrowserSource("Caller-8-Content-VDON", url .. "/C8?stream=content")
end

--  script hook: description displayed on script window
function script_description ()
    return [[
        <h2>VDON Call Configuration</h2>

        Copyright &copy; 2022 <a style="color: #ffffff; text-decoration: none;"
        href="http://engelschall.com">Dr. Ralf S. Engelschall</a><br/>
        Distributed under <a style="color: #ffffff; text-decoration: none;"
        href="https://spdx.org/licenses/MIT.html">MIT license</a>

        <p>
        <b>This script updates the VDON Call organisation and room configuration
        in all OBS Studio browser sources with the provided ones below.</b>
    ]]
end

--  script hook: define UI properties
function script_properties ()
    --  create new properties
    local props = obs.obs_properties_create()

    --  create text fields
    ctx.propsDefBase = obs.obs_properties_add_text(props,
        "textBase", "Base URL", obs.OBS_TEXT_DEFAULT)
    ctx.propsDefOrg = obs.obs_properties_add_text(props,
        "textOrg", "Organisation Name", obs.OBS_TEXT_DEFAULT)
    ctx.propsDefRoom = obs.obs_properties_add_text(props,
        "textRoom", "Room Name", obs.OBS_TEXT_DEFAULT)

    --  create update button
	obs.obs_properties_add_button(props, "buttonUpdate", "Update Configuration", function ()
        updateConfiguration()
	    return true
    end)

    return props
end

--  script hook: define property defaults
function script_defaults (settings)
    --  provide default values
    obs.obs_data_set_default_string(settings, "textBase", ctx.propsValBase)
    obs.obs_data_set_default_string(settings, "textOrg",  ctx.propsValOrg)
    obs.obs_data_set_default_string(settings, "textRoom", ctx.propsValRoom)
end

--  script hook: update state from UI properties
function script_update (settings)
    --  fetch property values
	ctx.propsVal.textBase = obs.obs_data_get_string(settings, "textBase")
	ctx.propsVal.textOrg  = obs.obs_data_get_string(settings, "textOrg")
	ctx.propsVal.textRoom = obs.obs_data_get_string(settings, "textRoom")
end

