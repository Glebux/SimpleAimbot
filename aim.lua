local enabledddd = true
if not enabledddd then return end
--[[if game.PlaceId == 286090429 then
	local req
	req = hookfunction(getrenv().require, newcclosure(function(arg)
		if arg.Name == "NewMouse" then
			print("successfully spoofed mouse!")
			return nil--game.Players.LocalPlayer:GetMouse()
		end
		return req(arg)
	end))
end]]--
--[[local function formattbl(tbl)
	local text = ""
	local indexed2 = false
	if tbl[1] then indexed2 = true end
	local layer = 0
	local index
	index = function(tbl2)
		layer = layer + 1
		local indexed = false
		if tbl[1] then indexed = true end
		if indexed then
			for i, v in ipairs(tbl2) do
				for i = 1, layer do text = text.."	" end
				if type(v) == "table" then
					local indexed3 = false
					if v[1] then indexed3 = true end
					if indexed3 then
						text = text.."index: "..i.." value: [\n"..index(v).."] (type: "..type(v)..")\n"
					else
						text = text.."index: "..i.." value: {\n"..index(v).."} (type: "..type(v)..")\n"
					end
				else
					text = text.."index: "..i.." value: "..v.." (type: "..type(v)..")\n"
				end
				for i = 1, layer do text = text.."	" end
			end
		else
			for i, v in pairs(tbl2) do
				for i = 1, layer do text = text.."	" end
				if type(v) == "table" then
					local indexed3 = false
					if v[1] then indexed3 = true end
					if indexed3 then
						text = text.."key: "..i.." (type: "..type(i)..") value: [\n"..index(v).."] (type: "..type(v)..")\n"
					else
						text = text.."key: "..i.." (type: "..type(i)..") value: {\n"..index(v).."} (type: "..type(v)..")\n"
					end
				else
					text = text.."key: "..i.." (type: "..type(i)..") value: "..v.." (type: "..type(v)..")\n"
				end
			end
		end
		layer = layer - 1
	end
	if indexed2 then
		text = text.."[\n"
	else
		text = text.."{\n"
	end
	if indexed2 then
		text = text.."]\n"
	else
		text = text.."}\n"
	end
	return text
end]]
--[[local getmt
getmt = hookfunction(getrenv().getmetatable, newcclosure(function(self, arg)
	spawn(function()
		wait(.2)
			for i, v in pairs(self) do
			print("getmt", "self", formattbl(self), i, v, type(v))
		end
	end)
	print(getcallingscript())
	if not checkcaller() and arg == game then
		return nil
	end
	return getmt(self, arg)
end))
local setmt
setmt = hookfunction(getrenv().setmetatable, newcclosure(function(self, arg)
	spawn(function()
		wait(.2)
		for i, v in pairs(self) do
			print("setmt", "self", formattbl(self), i, v, type(v))
		end
		for i, v in pairs(arg) do
			print("setmt", "arg", formattbl(arg), i, v, type(v))
		end
	end)
	print(getcallingscript())
	if not checkcaller() and arg == game then
		return nil
	end
	return setmt(self, arg)
end))]]
local gameids = {
	{286090429},
	{155615604},
	{6158075274},
	{5817894209},
	{621129760},
	{6514923093},
	{142823291},
	{6407649031}
}
local isacs = false
if game.ReplicatedStorage:FindFirstChild("ACS_Engine") then
	isacs = true
end
print(isacs)
local lopus = false
for i, v in pairs(gameids) do
	if v[1] == game.PlaceId then
		lopus = true
		break
	end
end
if lopus == false or isacs then print("fail") return nil end
while not game:IsLoaded() do wait() end
local aimforhead = true
local showtarget = true
local toggle = false
local teamcheck = true
local wallbang = false
local vischeck = true
local islocked = true
local key = Enum.KeyCode.F
local ismidclick = false
local function getRoot(char, forcehum)
	if not char then return nil end
	if aimforhead and not forcehum then
		return char:FindFirstChild("Head")
	else
		return char:FindFirstChild("HumanoidRootPart")
	end
end
local getcharfrompart
getcharfrompart = function(part)
	if part.Parent == game then return end
	local parent = part.Parent
	if parent.ClassName == "Model" then
		local ffind = game.Players:GetPlayerFromCharacter(parent)
		if not ffind then
			return getcharfrompart(parent)
		else
			return ffind
		end
	else
		return getcharfrompart(parent)
	end
end
local function isvisible(player)
	if not vischeck then return true end
	if not game.Players.LocalPlayer.Character then return end
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	local ffind = game.Workspace.CurrentCamera.CFrame.Position
	local thrp = getRoot(player.Character)
	if not thrp and not ffind then return end
	local unit = (thrp.Position-ffind).Unit
	local magnitude = (thrp.Position-ffind).Magnitude
	local ray = game.Workspace:Raycast(ffind, unit * magnitude, raycastParams)
	if ray then
		local lol = getcharfrompart(ray.Instance)
		if lol then
			if getRoot(lol.Character) then
				return true
			end
		end
	end
	return false
end
local function findpartwithname(part, name)
	if part.Parent == game then return end
	local parent = part.Parent
	local ffind = parent:FindFirstChild(name)
	if not ffind then
		return findpartwithname(parent, name)
	else
		return ffind
	end
end
local function getplayer(name)
	name = string.lower(name)
	local target
	for _, v in pairs(game.Players:GetPlayers()) do
		if string.find(string.lower(v.Name), name) or string.find(string.lower(v.DisplayName), name) then
			target = v
		end
	end
	return target
end
local function get2d(camera, pos)
	local pos, vis = camera:WorldToViewportPoint(pos)
	if vis then return pos.X, pos.Y end
end
local function calcdistsize(start, endd, divider1, divider2)
	if not divider1 then divider1 = 50 end
	if not divider2 then divider2 = 10 end
	local magnitude = (endd-start).Magnitude
	local size = Vector2.new(divider1/(magnitude/divider2), divider1/(magnitude/divider2))
	return size.X, size.Y
end
local target = nil
local hrp = nil
local localhrp = nil
local fart = Instance.new("ScreenGui", game.CoreGui)
syn.protect_gui(fart)
fart.IgnoreGuiInset = true
local square = Instance.new("Frame", fart)
square.Size = UDim2.new(0, 50, 0, 50)
square.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
square.BorderSizePixel = 0
square.AnchorPoint = Vector2.new(0.5, 0.5)
local isenabled = false
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if ((ismidclick and input.UserInputType == Enum.UserInputType.MouseButton3) or (input.KeyCode == key and not ismidclick)) and not game:GetService("UserInputService"):GetFocusedTextBox() then
		if not toggle then
			isenabled = true
		else
			isenabled = (not isenabled)
		end
	end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
	if ((ismidclick and input.UserInputType == Enum.UserInputType.MouseButton3) or (input.KeyCode == key and not ismidclick)) and not game:GetService("UserInputService"):GetFocusedTextBox() then
		if not toggle then
			isenabled = false
		end
	end
end)
local label = Instance.new("TextLabel", fart)
label.BackgroundTransparency = 1
label.BorderSizePixel = 0
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.TextColor3 = Color3.fromRGB(0, 100, 255)
label.Position = UDim2.new(0.5, 0, 0.9, 0)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 24
local magnitude
local unit
local origsort = function(playertable, x, y)
	local tmpprior = nil
	local lastmagnitude = nil
	repeat
		for i, v in ipairs(playertable) do
			if v.Character then
				local hrp = getRoot(v.Character)
				if hrp then
					local xx, yy = get2d(game.Workspace.CurrentCamera, hrp.Position)
					if xx and yy then
						local magnitude = (Vector2.new(xx, yy)-Vector2.new(x, y)).Magnitude
						if lastmagnitude then
							if lastmagnitude < magnitude then
								table.remove(playertable, i)
							else
								lastmagnitude = magnitude
								tmpprior = v
							end
						else
							tmpprior = v
							lastmagnitude = magnitude
						end
					else
						table.remove(playertable, i)
					end
				else
					table.remove(playertable, i)
				end
			else
				table.remove(playertable, i)
			end
		end
	until table.getn(playertable) ~= 1 or table.getn(playertable) ~= 0
	return tmpprior
end
local customsort = nil
game["Run Service"].RenderStepped:Connect(function()
	if isenabled then
		label.Text = "AimLock Enabled"
	else
		label.Text = "AimLock Disabled"
	end
	if (not isenabled or not islocked) or key == nil then
		local playertable = {}
		local mouse = game.Players.LocalPlayer:GetMouse()
		local x, y = mouse.X, mouse.Y
		for _, v in pairs(game.Players:GetPlayers()) do
			if v ~= game.Players.LocalPlayer and v.Character then
				if getRoot(v.Character) and getRoot(game.Players.LocalPlayer.Character) then
					if get2d(game.Workspace.CurrentCamera, getRoot(v.Character).Position) and isvisible(v) then
						if not teamcheck then
							table.insert(playertable, v)
						else
							if v.Team ~= game.Players.LocalPlayer.Team then
								table.insert(playertable, v)
							end
						end
					end
				end
			end
		end
		if not customsort then
			target = origsort(playertable, x, y)
		else
			target = customsort(playertable, x, y)
		end
		pcall(function()
			if target.Character then
				hrp = getRoot(target.Character)
			else
				hrp = nil
			end
		end)
		pcall(function()
			if getRoot(game.Players.LocalPlayer.Character) then
				localhrp = getRoot(game.Players.LocalPlayer.Character)
			else
				localhrp = nil
			end
		end)
	end
	if hrp and localhrp then
		magnitude = (hrp.Position-localhrp.Position).Magnitude
		unit = (hrp.Position-localhrp.Position).Unit
	end
	if target and showtarget and getRoot(target.Character) then
		local pos = getRoot(target.Character).Position
		local x, y = get2d(game.Workspace.CurrentCamera, pos)
		if x and y and game.Players.LocalPlayer.Character then
			square.BackgroundTransparency = 0
			local xx, yy = calcdistsize(game.Workspace.CurrentCamera.CFrame.Position, pos)
			square.Size = UDim2.new(0, xx, 0, yy)
			square.Position = UDim2.new(0, x, 0, y)
		else
			square.BackgroundTransparency = 1
		end
	else
		square.BackgroundTransparency = 1
	end
end)
gameids[1][2] = function()
	key = Enum.KeyCode.E
	local dostuff = true
	local MT = getrawmetatable(game)
	setreadonly(MT, false)
	local namecall = MT.__namecall
	MT.__namecall = function(self, ...)
		local method = getnamecallmethod()
		local args = {...}
		if dostuff and not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and method == "FindPartOnRayWithIgnoreList" then
			local newargs = {}
			newargs[1] = Ray.new(localhrp.Position, magnitude * unit)
			newargs[2] = args[2]
			if wallbang then
				table.insert(newargs[2], game.Workspace.Map)
			end
			newargs[3] = args[3]
			newargs[4] = args[4]
			return namecall(self, table.unpack(newargs))
	    --[[print("raycast called")
		local newargs = {}
		local p = hrp.CFrame:ToWorldSpace(CFrame.new(0, 0, -3)).Position
        local dest = hrp.Position
        local u = (dest-p).Unit
        local m = (dest-p).Magnitude
        setnamecallmethod("Raycast")
        local ray = namecall(workspacee, p, u*m)
        setnamecallmethod(method)
        if ray then
            if ray.Instance == hrp then
                print("raycast spoofed")
                newargs[1] = Ray.new(p, u * m)
		        newargs[2] = args[2]
		        if wallbang then
			        table.insert(newargs[2], game.Workspace.Map)
	        	end
		        newargs[3] = args[3]
		        newargs[4] = args[4]
		        return namecall(self, table.unpack(newargs))
            else
                print("didn't hit")
            end
        else
            print("failed to cast")
        end]]--
		end
		return namecall(self, ...) 
	end
	local func
	local antiloop = false
	local assfunc = MT.__index
	local workspacee = game.workspace
	local ass = Instance.new("NumberValue")
	ass.Value = 0
	local assfunc2 = function(self, key, lolus)
		--if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and key == "CFrame" and func(self, "ClassName") == "Camera" then
		--print("camera cframe asked")
		--return assfunc(hrp, "CFrame"):ToWorldSpace(CFrame.new(0, 0, -3))
		--end
    --[[if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and self == Ray and key == "new" then
        print("called ray new")
        return function(orig, direction)
            orig = assfunc(localhrp, "Position")
            direction = unit * magnitude
            return assfunc(Ray, "new")(orig, direction)
        end
    end]]--
		if not checkcaller() then
			if --[[key == "Spread" or key == "SpreadRecovery" or ]]key == "RecoilControl" then
				return ass
			elseif key == "SpreadRecovery" then
				return assfunc(self, "Spread")
			end
		end
		if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and key == "Hit" then
			return assfunc(hrp, "CFrame")
		elseif not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and key == "UnitRay" then
		elseif not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and key == "Target" then
			return hrp
		end
		return assfunc(self, key)
	end
	MT.__index = assfunc2
	local gayfunc
end
gameids[2][2] = function()
	local gmt = getrawmetatable(game)
	setreadonly(gmt, false)
	local old = gmt.__namecall
	local localplayer = game.Players.LocalPlayer
	local lolspace = game.Workspace
	local index
	local fart = game.Workspace
	local function gethrp()
		return hrp
	end
	local namecall
	local function callfromnamecall(nc, inst, method, ...)
		local pastme = getnamecallmethod()
		setnamecallmethod(method)
		local val = nc(inst, ...)
		setnamecallmethod(pastme)
		return val
	end
	local req
	req = hookfunction(getrenv().require, function(self, ...)
		local args = {...}
		if self.Name == "GunStates" then
			local fart = req(self, ...)
			fart.FireRate = 0.01
			fart.Spread = 20
			--fart.AutoFire = true
			fart.Damage = 100
			fart.Bullets = fart.Bullets*5
			--fart.ReloadTime = 0.1
			--fart.MaxAmmo = 9999
			--fart.CurrentAmmo = 9999
			--fart.StoredAmmo = 9999*10
			return fart
		end
		return req(self, ...)
	end)
	namecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		if self == game.Workspace and method == "FindPartOnRay" and not checkcaller() and isenabled and hrp and localhrp and magnitude and unit then
        --[[local ray = callfromnamecall(namecall, game.Workspace, "Raycast", localhrp.Position, unit * magnitude)
        if ray then
            return ray.Instance, ray.Position
        end]]
			return hrp, hrp.Position
		end
		return namecall(self, ...)
	end)
	--index = hookmetamethod(game, "__index", function(self, key)
	--local method = getnamecallmethod()
	--local gay = findpartwithname(self, game.Name)
    --[[if not checkcaller() and self.Name == "ShootEvent" and method == "FireServer" and isenabled and target then
        local tbl = ({...})[1][1]
        local arg2 = ({...})[2]
        print("lolled")
        local hrppos = hrp.Position
        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local muzzle = tool.Muzzle
        local magnitude = (hrppos-muzzle.Position).Magnitude
        local ray = Ray.new(muzzle.Position, (hrppos-muzzle.Position).Unit * magnitude)
        local v24 = Instance.new("Part", muzzle);
		Instance.new("BlockMesh", v24).Scale = Vector3.new(0.5, 0.5, 1);
		v24.Name = "RayPart";
		v24.BrickColor = BrickColor.Yellow();
		v24.Material = Enum.Material.Neon;
		v24.Anchored = true;
		v24.CanCollide = false;
		v24.Transparency = 0.5;
		v24.formFactor = Enum.FormFactor.Custom;
		v24.Size = Vector3.new(0.2, 0.2, magnitude);
		v24.CFrame = CFrame.new(hrppos, muzzle.Position) * CFrame.new(0, 0, -magnitude / 2);
		spawn(function()
		    wait(0.05)
		    v24:Destroy()
		end)
		local farttable = {
		    {
		        Hit = hrp,
		        Distance = tbl.Distance,
		        Cframe = CFrame.new(hrp.Position),
		        RayObject = tbl.RayObject
		    }
		}
		--tbl.Hit = hrp
		--tbl.Distance = magnitude
		--tbl.Cframe = v24.CFrame
		--tbl.RayObject = ray
        return index(self, farttable, arg2)
        if target.Character then
            local hrp = getRoot(target.Character)
            if hrp then
                
            end
        end]]
   --[[ elseif self == game.Debris and method == "AddItem" then
        if ({...})[1].Name == "RayPart" and ({...})[1].Parent.Parent.Parent.Name == game.Players.LocalPlayer.Name then
            print(({...})[1], 2)
            return old(({...})[1], 2)
        end
        return old(self, ...)]]--
	--if index(self, "ClassName") == "Mouse" and key == "Hit" and isenabled and hrp and localhrp and not checkcaller() then
	--local ray = game.Workspace:Raycast(localhrp.Position, unit * magnitude)
	--if ray then
	--return CFrame.new(ray.Instance.Position)
	--end
	--end
	--return index(self, key)
	--end)
end
gameids[3][2] = function()
	key = Enum.KeyCode.E
	local dostuff = true
	local namecall
	namecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		local args = {...}
		if dostuff and not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and method == "FindPartOnRayWithIgnoreList" then
			local newargs = {}
			newargs[1] = Ray.new(localhrp.Position, magnitude * unit)
			newargs[2] = args[2]
			if wallbang then
				table.insert(newargs[2], game.Workspace.Map)
			end
			newargs[3] = args[3]
			newargs[4] = args[4]
			return namecall(self, table.unpack(newargs))
	    --[[print("raycast called")
		local newargs = {}
		local p = hrp.CFrame:ToWorldSpace(CFrame.new(0, 0, -3)).Position
        local dest = hrp.Position
        local u = (dest-p).Unit
        local m = (dest-p).Magnitude
        setnamecallmethod("Raycast")
        local ray = namecall(workspacee, p, u*m)
        setnamecallmethod(method)
        if ray then
            if ray.Instance == hrp then
                print("raycast spoofed")
                newargs[1] = Ray.new(p, u * m)
		        newargs[2] = args[2]
		        if wallbang then
			        table.insert(newargs[2], game.Workspace.Map)
	        	end
		        newargs[3] = args[3]
		        newargs[4] = args[4]
		        return namecall(self, table.unpack(newargs))
            else
                print("didn't hit")
            end
        else
            print("failed to cast")
        end]]--
		end
		return namecall(self, ...) 
	end)
	local func
	local antiloop = false
	local assfunc
	local workspacee = game.workspace
	assfunc = function(self, key, lolus)
		--if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and key == "CFrame" and func(self, "ClassName") == "Camera" then
		--print("camera cframe asked")
		--return func(hrp, "CFrame"):ToWorldSpace(CFrame.new(0, 0, -3))
		--end
    --[[if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and self == Ray and key == "new" then
        print("called ray new")
        return function(orig, direction)
            orig = func(localhrp, "Position")
            direction = unit * magnitude
            return func(Ray, "new")(orig, direction)
        end
    end]]--
		if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and key == "Hit" then
			return func(hrp, "CFrame")
		elseif not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and key == "UnitRay" then
		elseif not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and key == "Target" then
			return hrp
		end
		return func(self, key)
	end
	func = hookmetamethod(game, "__index", assfunc)
end
local function acs()
	ismidclick = true
	teamcheck = false
	vischeck = false
	local oldindex
	local workspacee = game.workspace
	--[[oldindex = hookmetamethod(game, "__index", newcclosure(function(self, key)

	end))]]
	local oldrequire
	oldrequire = hookfunction(getrenv().require, function(module)
		if not checkcaller() and ((module.Name == "ACS_Settings" and module.Parent.ClassName == "Tool") or (module.Name == "Settings" and module.Parent.Name == "Variaveis")) then
			local tbl = oldrequire(module)
			tbl.StoredAmmo = math.huge
			tbl.Jammed = false
			tbl.CanBreak = false
			local rectbl = {
				camRecoilUp 	= {0,0}
				,camRecoilTilt 	= {0,0}
				,camRecoilLeft 	= {0,0}
				,camRecoilRight = {0,0}
			}
			tbl.camRecoil = rectbl
			tbl.gunRecoil = rectbl
			local dmgtbl = {200,200}
			tbl.LimbDamage = dmgtbl
			tbl.TorsoDamage = dmgtbl
			tbl.HeadDamage = dmgtbl
			if tbl.ShootType ~= 3 then
				tbl.ShootType = 1
			end
			return tbl
		end
		return oldrequire(module)
	end)
	local func
	local assfunc
	assfunc = function(Self, ...)
		local args = {...}
		local NamecallMethod = getnamecallmethod()
		if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and Self == workspacee and NamecallMethod == "FindPartOnRayWithIgnoreList" then
			local ray = args[1]
			local ignores = args[2]
			local terrainCellsAreCubes = args[3]
			local ignoreWater = args[4]
			local fray = Ray.new(localhrp.Position, unit * magnitude)
			setnamecallmethod("FindPartOnRayWithWhitelist")
			local data = {func(Self, fray, {hrp,localhrp}, true)}
			setnamecallmethod("FindPartOnRayWithIgnoreList")
			return Self, unpack(data)
		end
		return func(Self, ...)
	end
	func = hookmetamethod(game, "__namecall", assfunc)
	local func2
	local assfunc2
	local huge = math.huge
	assfunc2 = function(Self, key)
		if Self == game then return func2(Self,key) end
		local selfname = func2(Self, "Name")
		local parent = func2(Self, "Parent")
		local parentname
		if parent then
			parentname = func2(parent, "Name")
		else
			return func2(Self, key)
		end
		if (selfname == "LauncherAmmo" or selfname == "StoredAmmo") and parentname == "Variaveis" and key == "Value" then
			return 9999999
		end
		return func2(Self, key)
	end
	func2 = hookmetamethod(game, "__index", assfunc2)
end
gameids[4][2] = acs
gameids[5][2] = function()
	teamcheck = false
	vischeck = false
	local func
	local assfunc
	local workspacee = game.workspace
	assfunc = function(Self, ...)
		local args = {...}
		local NamecallMethod = getnamecallmethod()
		if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and Self == workspacee and NamecallMethod == "FindPartOnRayWithIgnoreList" then
			local ray = args[1]
			local ignores = args[2]
			local terrainCellsAreCubes = args[3]
			local ignoreWater = args[4]
			local fray = Ray.new(localhrp.Position, unit * magnitude)
			--local data = {func(fray, ignores, terrainCellsAreCubes, ignoreWater)}
			return func(Self, fray, ignores, terrainCellsAreCubes, ignoreWater)
		end
		return func(Self, ...)
	end
	func = hookmetamethod(game, "__namecall", assfunc)
end
gameids[6][2] = function()
	teamcheck = false
	local func
	local assfunc
	local workspacee = game.workspace
	assfunc = function(Self, ...)
		local args = {...}
		local NamecallMethod = getnamecallmethod()
		if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and Self == workspacee and NamecallMethod == "FindPartOnRayWithIgnoreList" then
			local ray = args[1]
			local ignores = args[2]
			local terrainCellsAreCubes = args[3]
			local ignoreWater = args[4]
			local fray = Ray.new(localhrp.Position, unit * magnitude)
			--local data = {func(fray, ignores, terrainCellsAreCubes, ignoreWater)}
			return func(Self, fray, ignores, terrainCellsAreCubes, ignoreWater)
		end
		return func(Self, ...)
	end
	func = hookmetamethod(game, "__namecall", assfunc)
end
gameids[7][2] = function()
	key = Enum.KeyCode.E
	teamcheck = false
	local func
	local assfunc
	local workspacee = game.workspace
	assfunc = function(Self, ...)
		local args = {...}
		local NamecallMethod = getnamecallmethod()
		local call = getcallingscript()
		if not call then
			return func(Self, ...)
		end
		if call.Name ~= "ControlModule" and not checkcaller() and isenabled and hrp and localhrp and magnitude and unit and Self == workspacee and NamecallMethod == "FindPartOnRayWithIgnoreList" then
			local ray = args[1]
			local ignores = args[2]
			local terrainCellsAreCubes = args[3]
			local ignoreWater = args[4]
			local fray = Ray.new(localhrp.Position, unit * magnitude)
			setnamecallmethod("FindPartOnRayWithWhitelist")
			local data = {func(Self, fray, {hrp,localhrp}, ignoreWater)}
			setnamecallmethod("FindPartOnRayWithIgnoreList")
			return unpack(data)
		end
		return func(Self, ...)
	end
	func = hookmetamethod(game, "__namecall", assfunc)
	local murdname = ""
	local sheriffname = ""
	local murdsquare = Instance.new("Frame", fart)
	murdsquare.Size = UDim2.new(0, 50, 0, 50)
	murdsquare.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	murdsquare.BorderSizePixel = 0
	murdsquare.AnchorPoint = Vector2.new(0.5, 0.5)
	murdsquare.BackgroundTransparency = 1
	local sheriffsquare = Instance.new("Frame", fart)
	sheriffsquare.Size = UDim2.new(0, 50, 0, 50)
	sheriffsquare.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
	sheriffsquare.BorderSizePixel = 0
	sheriffsquare.AnchorPoint = Vector2.new(0.5, 0.5)
	sheriffsquare.BackgroundTransparency = 1
	game["Run Service"].RenderStepped:Connect(function()
		local foundmurd = false
		local foundsherrif = false
		for _, v in pairs(game.Players:GetPlayers()) do
			if v ~= game.Players.LocalPlayer and v.Character then
				if v.Backpack:FindFirstChild("Knife") or v.Character:FindFirstChild("Knife") then
					if murdname ~= v.Name then
						game.StarterGui:SetCore( "ChatMakeSystemMessage",  { Text = "[Glebux's MM2 Module] "..v.DisplayName.." is the murderer!", Color = Color3.fromRGB( 255,0,0 ), Font = Enum.Font.Arial, FontSize = Enum.FontSize.Size24 } )
					end
					murdname = v.Name
					murdsquare.BackgroundTransparency = 0
					foundmurd = true
					local x,y = get2d(game.Workspace.CurrentCamera, v.Character.HumanoidRootPart.Position)
					local xx,yy = calcdistsize(game.Workspace.CurrentCamera.CFrame.Position, v.Character.HumanoidRootPart.Position, 70)
					murdsquare.Size = UDim2.new(0, xx, 0, yy)
					murdsquare.Position = UDim2.new(0, x, 0, y)
				end
				if v.Backpack:FindFirstChild("Gun") or v.Character:FindFirstChild("Gun") then
					if sheriffname ~= v.Name then
						game.StarterGui:SetCore( "ChatMakeSystemMessage",  { Text = "[Glebux's MM2 Module] "..v.DisplayName.." is the sherif!", Color = Color3.fromRGB( 0,0,255 ), Font = Enum.Font.Arial, FontSize = Enum.FontSize.Size24 } )
					end
					sheriffname = v.Name
					sheriffsquare.BackgroundTransparency = 0
					foundsherrif = true
					local x,y = get2d(game.Workspace.CurrentCamera, v.Character.HumanoidRootPart.Position)
					local xx,yy = calcdistsize(game.Workspace.CurrentCamera.CFrame.Position, v.Character.HumanoidRootPart.Position, 70)
					sheriffsquare.Size = UDim2.new(0, xx, 0, yy)
					sheriffsquare.Position = UDim2.new(0, x, 0, y)
				end
			end
		end
		if not foundmurd then
			murdsquare.BackgroundTransparency = 1
		end
		if not foundsherrif then
			sheriffsquare.BackgroundTransparency = 1
		end
	end)
end
gameids[8][2] = function()
	key = Enum.KeyCode.E
	teamcheck = false
	vischeck = false
	local namecall
	namecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		local args = {...}
		if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit then
			if method == "Raycast" then
				local res = namecall(self, localhrp.Position, magnitude * unit, args[3])
				return {Distance = magnitude, Instance = hrp, Material = Enum.Material.Neon, Position = hrp.Position, Normal = res.Normal}
			end
			if method == "FindPartsInRegion3WithIgnoreList" then
				local res = namecall(self, ...)
				table.insert(res, hrp)
				return res
			end
		end
		return namecall(self, ...) 
	end)
	local index
	index = hookmetamethod(game, "__index", function(self, key)
		if not checkcaller() and isenabled and hrp and localhrp and magnitude and unit then
			if string.lower(key) == "hit" then
				return hrp.Position
			end
		end
		return index(self,key)
	end)
end
for _, v in pairs(gameids) do
	if isacs then
		acs()
	elseif v[1] == game.PlaceId then
		v[2]()
	end
end
