local GuiElement = dofile_once("GUSGUI_PATHGuiElement.lua")
dofile_once("GUSGUI_PATHclass.lua")

local Slider = class(GuiElement, function(o, config)
    GuiElement.init(o, config, extendedValid)
    o.type = "Slider"
    o.allowsChildren = false
end)

function Slider:GetBaseElementSize()
  return math.max(25, self.width), 8
end

function Slider:Draw()
    self.value = self.value or self.defaultValue
    self.renderID = self.renderID or self.gui.nextID()
    self.z = self:GetDepthInTree() * -100
    local elementSize = self:GetElementSize()
    local paddingLeft = self._config.padding.left
    local paddingTop = self._config.padding.top
    local x = self._config.margin.left
    local y = self._config.margin.top
    local c = self._config.colour
    local border = self._config.drawBorder and 1 or 0
    if self.parent then
        x, y = self.parent:GetManagedXY(self)
    end
    if self._config.drawBorder then
        self:RenderBorder(x, y, elementSize.baseW, elementSize.baseH)
    end
    if self._config.drawBackground then 
        self:RenderBackground(x, y, elementSize.baseW, elementSize.baseH)
    end
    local old = self.value
    GamePrint("min" .. tostring(self.min))
    GamePrint("max" .. tostring(self.max))
    local nv = GuiSlider(self.gui.guiobj, self.renderID, x + elementSize.offsetX + paddingLeft + border, y + elementSize.offsetY + border + paddingTop, "", self.value, self._config.min, self._config.max, self._config.defaultValue, 1, " ", self._config.width)
    self.value = math.floor(nv)
    if nv ~= old then
        self._config.onChange(self)
    end 
end

extendedValid = {
    {
        name = "min",
        fromString = function(s) 
            return tonumber(s)
        end,
        validate = function(o)
            if o == nil then return true, 1, nil end
            local t = type(o)
            if t == "table" and o["_type"] ~= nil and o["value"] then
                return true, nil, nil
            end
            if t == "number" then return true, nil, nil end
        end    
    },
    {
        name = "max",
        fromString = function(s) 
            return tonumber(s)
        end,
        validate = function(o)
            if o == nil then return true, 1, nil end
            local t = type(o)
            if t == "table" and o["_type"] ~= nil and o["value"] then
                return true, nil, nil
            end
            if t == "number" then return true, nil, nil end
        end    
    },
    {
        name = "width",
        fromString = function(s) 
            return tonumber(s)
        end,
        validate = function(o)
            if o == nil then return true, 1, nil end
            local t = type(o)
            if t == "table" and o["_type"] ~= nil and o["value"] then
                return true, nil, nil
            end
            if t == "number" then return true, nil, nil end
        end    
    },
    {
        name = "defaultValue",
        fromString = function(s) 
            return tonumber(s)
        end,
        validate = function(o)
            if o == nil then return true, 1, nil end
            local t = type(o)
            if t == "table" and o["_type"] ~= nil and o["value"] then
                return true, nil, nil
            end
            if t == "number" then return true, nil, nil end
        end    
    },
    {
        name = "onChange",
        validate = function(o)
            if o == nil then
                return false, nil,  "GUI: Invalid value for onChange on element \"%s\" (onChange is required)"
            end
            if type(o) == "function" then return true, nil, nil end
            return false, nil, "GUI: Invalid value for onChange on element \"%s\""
        end    
    },
}
return Slider