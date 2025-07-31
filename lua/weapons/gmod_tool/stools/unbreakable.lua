TOOL.Category = "Constraints"
TOOL.Name = "Unbreakable"
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
}

local function MakeUnbreakable(ply, ent, data)
	if data.On then
		ent.UnbreakableTool = data.On
		duplicator.StoreEntityModifier(ent, "Unbreakable", data)
	else
		ent.UnbreakableTool = nil
		duplicator.ClearEntityModifier(ent, "Unbreakable")
	end
end

if SERVER then
	hook.Add("EntityTakeDamage", "UnbreakableTool", function(ent)
		if ent:GetTable().UnbreakableTool then
			return true
		end
	end)

	duplicator.RegisterEntityModifier("Unbreakable", MakeUnbreakable)
end

if CLIENT then
	language.Add("tool.unbreakable.name", "Unbreakable")
	language.Add("tool.unbreakable.desc", "Makes objects unbreakable")
	language.Add("tool.unbreakable.left", "Make an object unbreakable")
	language.Add("tool.unbreakable.right", "Restore object's previous settings")
	language.Add("tool.unbreakable.reload", "Make the object and everything constrained to it unbreakable")
end

function TOOL:LeftClick(trace)
	local ent = trace.Entity

	if IsValid(ent) then
		if CLIENT then return true end

		MakeUnbreakable(self:GetOwner(), ent, {On = true})

		return true
	end

	return false
end

function TOOL:RightClick(trace)
	local ent = trace.Entity

	if IsValid(ent) then
		if CLIENT then return true end

		MakeUnbreakable(self:GetOwner(), ent, {On = false})

		return true
	end

	return false
end

function TOOL:Reload(trace)
	local ent = trace.Entity

	if IsValid(ent) then
		if CLIENT then return true end

		local owner = self:GetOwner()

		for _, v in pairs(constraint.GetAllConstrainedEntities(ent)) do
			MakeUnbreakable(owner, v, {On = true})
		end

		return true
	end

	return false
end