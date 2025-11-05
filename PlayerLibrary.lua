-- PlayerLibrary.lua
-- Comprehensive player and NPC tracking API for ESP/Aimbot systems
-- Author: LxckStxp / GitHub Copilot
-- 
-- API:
--   local Tracker = PlayerLibrary.new(LocalPlayer)
--   Tracker:OnEntityAdded(function(entity) ... end)
--   Tracker:OnEntityRemoved(function(entity) ... end)
--   Tracker:OnEntityUpdated(function(entity) ... end)
--   Tracker:start()
--   Tracker:stop()
--   Tracker:GetAll() -> {entity, ...}
--   Tracker:GetPlayers() -> {entity, ...}
--   Tracker:GetNPCs() -> {entity, ...}
--   Tracker:GetByPlayer(player) -> entity?
--   Tracker:GetByModel(model) -> entity?
--   Tracker:IsAlive(entity) -> bool
--   Tracker:GetDistance(entity, from) -> number?
--   Tracker:IsTeammate(entity) -> bool
--
-- Entity shape: {
--   kind = "player"|"npc",
--   model = Model,
--   humanoid = Humanoid?,
--   rootPart = BasePart?,
--   head = BasePart?,
--   player = Player? -- when kind == "player"
--   team = Team?,
--   health = number,
--   maxHealth = number,
--   displayName = string,
--   userId = number? -- for players
-- }

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local PlayerLibrary = {}
PlayerLibrary.__index = PlayerLibrary

-- ═══════════════════════════════════════════════════════════════════════════
-- HELPERS
-- ═══════════════════════════════════════════════════════════════════════════

local function findHumanoid(model)
	return model and model:FindFirstChildOfClass("Humanoid")
end

local function findRoot(model)
	return model and (model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso"))
end

local function findHead(model)
	return model and model:FindFirstChild("Head")
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

local function buildEntity(kind, model, player)
	local humanoid = findHumanoid(model)
	local entity = {
		kind = kind,
		model = model,
		humanoid = humanoid,
		rootPart = findRoot(model),
		head = findHead(model),
		player = player,
		team = player and player.Team or nil,
		health = humanoid and humanoid.Health or 0,
		maxHealth = humanoid and humanoid.MaxHealth or 100,
		displayName = "",
		userId = player and player.UserId or nil,
	}
	
	-- Set display name
	if kind == "player" and player then
		entity.displayName = player.DisplayName or player.Name
	elseif humanoid then
		entity.displayName = (humanoid.DisplayName ~= "" and humanoid.DisplayName) or model.Name or "Unknown"
	else
		entity.displayName = model.Name or "Unknown"
	end
	
	return entity
end

local function updateEntity(entity)
	if not entity or not entity.model or not entity.model.Parent then return false end
	
	entity.humanoid = findHumanoid(entity.model)
	entity.rootPart = findRoot(entity.model)
	entity.head = findHead(entity.model)
	
	if entity.humanoid then
		entity.health = entity.humanoid.Health
		entity.maxHealth = entity.humanoid.MaxHealth
	end
	
	if entity.player then
		entity.team = entity.player.Team
	end
	
	return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CONSTRUCTOR
-- ═══════════════════════════════════════════════════════════════════════════

function PlayerLibrary.new(localPlayer)
	local self = setmetatable({}, PlayerLibrary)
	self.localPlayer = localPlayer
	self.entities = {}          -- [Model] -> entity
	self.byPlayer = {}          -- [Player] -> entity
	self.connections = {}       -- named connections
	self.modelConns = {}        -- [Model] -> {conn1, conn2, ...}
	self.addedCbs = {}
	self.removedCbs = {}
	self.updatedCbs = {}
	self.updateInterval = 0.5   -- seconds between automatic entity updates
	self._lastUpdate = 0
	return self
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INTERNAL: CALLBACKS
-- ═══════════════════════════════════════════════════════════════════════════


function PlayerLibrary:_fireAdded(entity)
	for _, cb in ipairs(self.addedCbs) do
		task.spawn(cb, entity)
	end
end

function PlayerLibrary:_fireRemoved(entity)
	for _, cb in ipairs(self.removedCbs) do
		task.spawn(cb, entity)
	end
end

function PlayerLibrary:_fireUpdated(entity)
	for _, cb in ipairs(self.updatedCbs) do
		task.spawn(cb, entity)
	end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INTERNAL: ENTITY MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

function PlayerLibrary:_trackModel(model, player)
	if not model or not model.Parent then return end
	if self.entities[model] then return end
	
	-- Wait a frame for character to fully load
	task.wait()
	if not model or not model.Parent then return end
	
	local kind = player and "player" or "npc"
	local entity = buildEntity(kind, model, player)
	
	-- Don't track if no humanoid found
	if not entity.humanoid or not entity.rootPart then
		return
	end
	
	self.entities[model] = entity
	if player then self.byPlayer[player] = entity end
	
	-- Track model connections
	self.modelConns[model] = {}
	
	-- Watch for removal
	table.insert(self.modelConns[model], model.AncestryChanged:Connect(function(_, parent)
		if not parent then
			self:_removeModel(model)
		end
	end))
	
	-- Watch for humanoid changes
	if entity.humanoid then
		table.insert(self.modelConns[model], entity.humanoid.Died:Connect(function()
			updateEntity(entity)
			self:_fireUpdated(entity)
		end))
		
		table.insert(self.modelConns[model], entity.humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			entity.health = entity.humanoid.Health
			self:_fireUpdated(entity)
		end))
	end
	
	self:_fireAdded(entity)
end

function PlayerLibrary:_removeModel(model)
	local entity = self.entities[model]
	if not entity then return end
	
	-- Disconnect model connections
	if self.modelConns[model] then
		for _, conn in ipairs(self.modelConns[model]) do
			pcall(function() conn:Disconnect() end)
		end
		self.modelConns[model] = nil
	end
	
	if entity.player and self.byPlayer[entity.player] == entity then
		self.byPlayer[entity.player] = nil
	end
	
	self.entities[model] = nil
	self:_fireRemoved(entity)
end

function PlayerLibrary:_onPlayerAdded(plr)
	if plr == self.localPlayer then return end
	
	-- Track initial character if present
	if plr.Character then
		task.spawn(function()
			self:_trackModel(plr.Character, plr)
		end)
	end
	
	-- Character lifecycle
	local charAddedKey = "charAdded_"..plr.UserId
	self.connections[charAddedKey] = plr.CharacterAdded:Connect(function(char)
		-- Remove previous tracked model for this player
		local prev = self.byPlayer[plr]
		if prev and prev.model ~= char then
			self:_removeModel(prev.model)
		end
		
		-- Track new character
		task.spawn(function()
			self:_trackModel(char, plr)
		end)
	end)
end

function PlayerLibrary:_onPlayerRemoving(plr)
	local prev = self.byPlayer[plr]
	if prev then self:_removeModel(prev.model) end
	
	-- Disconnect character tracking
	local charAddedKey = "charAdded_"..plr.UserId
	if self.connections[charAddedKey] then
		self.connections[charAddedKey]:Disconnect()
		self.connections[charAddedKey] = nil
	end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PUBLIC: START/STOP
-- ═══════════════════════════════════════════════════════════════════════════


function PlayerLibrary:start()
	-- Track existing players
	for _, plr in ipairs(Players:GetPlayers()) do
		self:_onPlayerAdded(plr)
	end
	
	-- Watch for new players
	self.connections.playerAdded = Players.PlayerAdded:Connect(function(plr)
		self:_onPlayerAdded(plr)
	end)
	
	self.connections.playerRemoving = Players.PlayerRemoving:Connect(function(plr)
		self:_onPlayerRemoving(plr)
	end)

	-- NPC discovery via Humanoid additions
	self.connections.descendantAdded = Workspace.DescendantAdded:Connect(function(inst)
		if inst:IsA("Humanoid") and inst.Parent then
			local model = inst.Parent
			task.delay(0.15, function()
				if not model or not model.Parent or self.entities[model] then return end
				local isPlayer, plr = isPlayerModel(model)
				if not isPlayer then
					self:_trackModel(model, nil)
				elseif not self.byPlayer[plr] then
					-- Backup: if CharacterAdded didn't fire for some reason
					self:_trackModel(model, plr)
				end
			end)
		end
	end)

	-- Initial pass for existing Humanoids (NPCs and characters already in workspace)
	task.spawn(function()
		for _, desc in ipairs(Workspace:GetDescendants()) do
			if desc:IsA("Humanoid") and desc.Parent then
				local model = desc.Parent
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
	end)
	
	-- Periodic entity update (health, refs, etc.)
	self.connections.heartbeat = RunService.Heartbeat:Connect(function()
		local now = tick()
		if now - self._lastUpdate >= self.updateInterval then
			self._lastUpdate = now
			for model, entity in pairs(self.entities) do
				if updateEntity(entity) then
					-- Entity still valid
				else
					-- Entity invalid, remove
					self:_removeModel(model)
				end
			end
		end
	end)
end

function PlayerLibrary:stop()
	for _, c in pairs(self.connections) do
		pcall(function() c:Disconnect() end)
	end
	self.connections = {}
	
	for model, conns in pairs(self.modelConns) do
		for _, conn in ipairs(conns) do
			pcall(function() conn:Disconnect() end)
		end
	end
	self.modelConns = {}
	
	-- Fire removed for all tracked entities
	for model, entity in pairs(self.entities) do
		self:_fireRemoved(entity)
	end
	self.entities = {}
	self.byPlayer = {}
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PUBLIC: CALLBACKS
-- ═══════════════════════════════════════════════════════════════════════════

function PlayerLibrary:OnEntityAdded(cb)
	table.insert(self.addedCbs, cb)
end

function PlayerLibrary:OnEntityRemoved(cb)
	table.insert(self.removedCbs, cb)
end

function PlayerLibrary:OnEntityUpdated(cb)
	table.insert(self.updatedCbs, cb)
end

-- Alias for backwards compatibility
function PlayerLibrary:OnAdded(cb)
	return self:OnEntityAdded(cb)
end

function PlayerLibrary:OnRemoved(cb)
	return self:OnEntityRemoved(cb)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PUBLIC: GETTERS
-- ═══════════════════════════════════════════════════════════════════════════

function PlayerLibrary:GetAll()
	local list = {}
	for _, e in pairs(self.entities) do
		table.insert(list, e)
	end
	return list
end

function PlayerLibrary:GetPlayers()
	local list = {}
	for _, e in pairs(self.entities) do
		if e.kind == "player" then
			table.insert(list, e)
		end
	end
	return list
end

function PlayerLibrary:GetNPCs()
	local list = {}
	for _, e in pairs(self.entities) do
		if e.kind == "npc" then
			table.insert(list, e)
		end
	end
	return list
end

function PlayerLibrary:GetByPlayer(player)
	return self.byPlayer[player]
end

function PlayerLibrary:GetByModel(model)
	return self.entities[model]
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PUBLIC: UTILITY HELPERS
-- ═══════════════════════════════════════════════════════════════════════════

function PlayerLibrary:IsAlive(entity)
	if not entity or not entity.humanoid then return false end
	return entity.health > 0 and entity.humanoid.Health > 0
end

function PlayerLibrary:GetDistance(entity, fromPosition)
	if not entity or not entity.rootPart then return nil end
	return (entity.rootPart.Position - fromPosition).Magnitude
end

function PlayerLibrary:IsTeammate(entity)
	if not entity or entity.kind ~= "player" then return false end
	if not self.localPlayer.Team then return false end
	return entity.team == self.localPlayer.Team
end

function PlayerLibrary:GetHealthPercent(entity)
	if not entity or entity.maxHealth == 0 then return 0 end
	return (entity.health / entity.maxHealth) * 100
end

function PlayerLibrary:IsVisible(entity, fromPosition, ignoreList)
	if not entity or not entity.rootPart then return false end
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = ignoreList or {self.localPlayer.Character, entity.model}
	
	local direction = (entity.rootPart.Position - fromPosition)
	local result = Workspace:Raycast(fromPosition, direction, params)
	
	return result == nil or result.Instance:IsDescendantOf(entity.model)
end

return PlayerLibrary
