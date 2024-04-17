-- Declarations
Dash = {}

shaderState = {}

shaderDef = {
  {
    name = "Dash",
    frag = "Dash.frag",
    useFramebuffer = true
  },
  {
    name = "Ghost1",
    frag = "Ghost1.frag"
  },
  {
    name = "Ghost2",
    frag = "Ghost2.frag"
  },
  {
    name = "Ghost3",
    frag = "Ghost3.frag"
  },
  {
    name = "Ghost4",
    frag = "Ghost4.frag"
  },
}

-- Main Hooks
function init()
	-- coppied from shaders.lua as I couldn't get it to work otherwise
    local registerShader = function(opts, method)
        local fragmentShaderPath = resolvepath(opts.frag)

        if fragmentShaderPath ~= nil then
            --  local shader = g_shaders.createShader()
            g_shaders.createFragmentShader(opts.name, opts.frag, opts.useFramebuffer or false)

            if opts.tex1 then
                g_shaders.addMultiTexture(opts.name, opts.tex1)
            end
            if opts.tex2 then
                g_shaders.addMultiTexture(opts.name, opts.tex2)
            end

            -- Setup proper uniforms
            g_shaders[method](opts.name)
        end
    end
	
	-- Load the shader
	for i=1,#shaderDef do
	  registerShader(shaderDef[i], "setupOutfitShader")
	end
	-- Hook into a custom opcode
	ProtocolGame.registerExtendedOpcode(14, Dash.toggle)
end


function terminate()
	-- Looks like we can't unload the shader, that might be a memory leak, but oh well
	-- Unhook from custom opcode
	ProtocoGame.unregisterExtendedOpcode(14, Dash.toggle)
	Dash = nil
	shaderState = {}
end

local function getNextValue(buffer, start)
  local nextEnd = string.find(buffer, ",", start)
  local rv = ""
  local nextStart = nextEnd;
  if nextEnd then
    rv = string.sub(buffer, start, nextEnd - 1)
    nextStart = nextEnd + 1
  else 
    rv = string.sub(buffer, start, nextEnd)
  end
  return rv, nextStart
end

function Dash.toggle(protocol, opcode, buffer)
  local value, nextStart = getNextValue(buffer, 1)
  local creatureId = value;
  value, nextStart  = getNextValue(buffer, nextStart)
  local turnOff = value
  local ghostIds = {}
  while nextStart do
    value, nextStart = getNextValue(buffer, nextStart)
    table.insert(ghostIds, value)
  end

  local creature = g_map.getCreatureById(creatureId)
  -- Toggle dash shader
  -- Tried to remember whether a shader was on previously
  --  but I don't see any way to get the active shader, and I don't wanna add one
  if (turnOff == "0") then
    creature:setShader("")
  else
    creature:setShader("Dash")
  end
  
  for i=1,#ghostIds do
    -- Handle ghosts
	local ghost = g_map.getCreatureById(ghostIds[i])
	ghost:setShader("Ghost"..i)
  end
end