local timer = {}

---@param name string -- The name of the timer
---@param action function -- The function to execute when the timer is up
---@vararg any -- Arguments to pass to the action function
local function WaitTimer(name, action, ...)
    if not Config.DefaultAlerts[name] then return end

    if not timer[name] then
        timer[name] = true
        action(...)
        Wait(Config.DefaultAlertsDelay * 1000)
        timer[name] = false
    end
end

---@param witnesses table | Array of peds that witnessed the event
---@param ped number | Ped ID to check
---@return boolean | Returns true if the ped is in the witnesses table
local function isPedAWitness(witnesses, ped)
    for k, v in pairs(witnesses) do
        if v == ped then
            return true
        end
    end
    return false
end

---@param ped number | Ped ID to check
---@return boolean | Returns true if the ped is holding a whitelisted gun
local function BlacklistedWeapon(ped)
	for i = 1, #Config.WeaponWhitelist do
		local weaponHash = joaat(Config.WeaponWhitelist[i])
		if GetSelectedPedWeapon(ped) == weaponHash then
			return true -- Is a whitelisted weapon
		end
	end
	return false -- Is not a whitelisted weapon
end



AddEventHandler('CEventExplosionHeard', function(witnesses, ped)
    if witnesses and not isPedAWitness(witnesses, ped) then return end
    WaitTimer('Explosion', function()
        exports['ps-dispatch']:Explosion()
    end)
end)
