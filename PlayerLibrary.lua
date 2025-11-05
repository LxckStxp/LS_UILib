-- PlayerLibrary.lua
-- Robust player and NPC tracking for ESP/Aimbot systems
-- Author: LxckStxp / GitHub Copilot
-- API: local Tracker = PlayerLibrary.new(LocalPlayer)
--      Tracker:OnAdded(function(target) ... end)
--      Tracker:OnRemoved(function(target) ... end)
--      Tracker:start()
--      Tracker:stop()
-- Target shape: {
--   kind = "player"|"npc",
--   model = Model,
--   humanoid = Humanoid?,
--   rootPart = BasePart?,
--   player = Player? -- when kind == "player"
-- }

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local PlayerLibrary = {}
PlayerLibrary.__index = PlayerLibrary

local function findHumanoid(model)
	return model and model:FindFirstChildOfClass("Humanoid") or nil
end

local function findRoot(model)
	return model and (model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")) or nil
end

local function isPlayerModel(model)
	if not model then return false, nil end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character == model then
			return true, plr
		end
	end
	return false, nil
end

function PlayerLibrary.new(localPlayer)
	local self = setmetatable({}, PlayerLibrary)
	self.localPlayer = localPlayer
	self.entities = {}       -- [Model] -> target
	self.byPlayer = {}       -- [Player] -> target
	self.connections = {}    -- various connections (and per-model)
	self.modelConns = {}     -- [Model] -> Connection
	self.addedCbs = {}
	self.removedCbs = {}
	return self
end

local function buildTarget(kind, model, player)
	return {
		kind = kind,
		model = model,
		humanoid = findHumanoid(model),
		rootPart = findRoot(model),
		player = player,
	}
end

function PlayerLibrary:_fireAdded(target)
	for _, cb in ipairs(self.addedCbs) do
		pcall(cb, target)
	end
end

function PlayerLibrary:_fireRemoved(target)
	for _, cb in ipairs(self.removedCbs) do
		pcall(cb, target)
	end
end

function PlayerLibrary:_trackModel(model, player)
	if not model or self.entities[model] then return end
	local kind = player and "player" or "npc"
	local target = buildTarget(kind, model, player)
	self.entities[model] = target
	if player then self.byPlayer[player] = target end

	-- Watch for removal
	self.modelConns[model] = model.AncestryChanged:Connect(function(_, parent)
		if not parent then
			self:removeModel(model)
		end
	end)

	self:_fireAdded(target)
end

function PlayerLibrary:removeModel(model)
	local target = self.entities[model]
	if not target then return end
	if self.modelConns[model] then
		pcall(function() self.modelConns[model]:Disconnect() end)
		self.modelConns[model] = nil
	end
	if target.player and self.byPlayer[target.player] == target then
		self.byPlayer[target.player] = nil
	end
	self.entities[model] = nil
	self:_fireRemoved(target)
end

function PlayerLibrary:_onPlayerAdded(plr)
	-- Initial character if present
	if plr.Character then
		self:_trackModel(plr.Character, plr)
	end
	-- Character lifecycle
	self.connections["charAdded_"..plr.UserId] = plr.CharacterAdded:Connect(function(char)
		-- Replace previous tracked model for this player
		local prev = self.byPlayer[plr]
		if prev then self:removeModel(prev.model) end
		self:_trackModel(char, plr)
	end)
	self.connections["charRemoving_"..plr.UserId] = plr.CharacterRemoving:Connect(function(char)
		-- Keep tracked until actually removed; AncestryChanged will handle
	end)
end

function PlayerLibrary:start()
	-- Existing players
	for _, plr in ipairs(Players:GetPlayers()) do
		self:_onPlayerAdded(plr)
	end
	self.connections.playersAdded = Players.PlayerAdded:Connect(function(plr)
		self:_onPlayerAdded(plr)
	end)
	self.connections.playersRemoving = Players.PlayerRemoving:Connect(function(plr)
		local prev = self.byPlayer[plr]
		if prev then self:removeModel(prev.model) end
		local a = self.connections["charAdded_"..plr.UserId]
		local r = self.connections["charRemoving_"..plr.UserId]
		if a then a:Disconnect() self.connections["charAdded_"..plr.UserId] = nil end
		if r then r:Disconnect() self.connections["charRemoving_"..plr.UserId] = nil end
	end)

	-- NPC discovery via Humanoid appearances (with short defer)
	self.connections.descAdded = Workspace.DescendantAdded:Connect(function(inst)
		if inst:IsA("Humanoid") then
			local model = inst.Parent
			task.delay(0.1, function()
				if not model or not model.Parent then return end
				if self.entities[model] then return end
				local isPlayer, plr = isPlayerModel(model)
				if isPlayer then
					-- If for some reason CharacterAdded hasn't fired yet, ensure tracked
					if not self.byPlayer[plr] then
						self:_trackModel(model, plr)
					end
				else
					self:_trackModel(model, nil)
				end
			end)
		end
	end)

	-- Initial pass for Humanoids (NPCs and existing characters)
	for _, hum in ipairs(Workspace:GetDescendants()) do
		if hum:IsA("Humanoid") and hum.Parent then
			local model = hum.Parent
			if not self.entities[model] then
				local isPlayer, plr = isPlayerModel(model)
				if isPlayer then
					if not self.byPlayer[plr] then
						self:_trackModel(model, plr)
					end
				else
					self:_trackModel(model, nil)
				end
			end
		end
	end
end

function PlayerLibrary:stop()
	for _, c in pairs(self.connections) do
		pcall(function() c:Disconnect() end)
	end
	self.connections = {}
	for model, _ in pairs(self.modelConns) do
		pcall(function() self.modelConns[model]:Disconnect() end)
	end
	self.modelConns = {}
	for model, _ in pairs(self.entities) do
		self:removeModel(model)
	end
end

function PlayerLibrary:OnAdded(cb)
	table.insert(self.addedCbs, cb)
end

function PlayerLibrary:OnRemoved(cb)
	table.insert(self.removedCbs, cb)
end

function PlayerLibrary:GetAll()
	local list = {}
	for _, t in pairs(self.entities) do table.insert(list, t) end
	return list
end

return PlayerLibrary
