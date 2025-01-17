--- @module "GuiElement"
local GuiElement = dofile_once("GUSGUI_PATHGuiElement.lua")
dofile_once("GUSGUI_PATHclass.lua")
--- @class ProgressBar: GuiElement
local ProgressBar = class(GuiElement, function(o, config)
    GuiElement.init(o, config, {width = {
        default = 50,
        required = false,
        validate = function(o)
            if type(o) == "number" then
                return o
            end
        end
    }, height = {
        allowsState = true,
        required = false,
        default = 10,
        fromString = function(s)
            return tonumber(s)
        end,
        validate = function(o)
            if type(o) == "number" then
                return o
            end
        end
    }, value = {
        default = 100,
        required = true,
        allowsState = true,
        fromString = function(s)
            return tonumber(s)
        end,
        validate = function(o)
            if type(o) == "number" then
                return o
            end
        end
    }, barColour = {
        default = "green",
        required = false,
        allowsState = true,
        validate = function(o)
            if type(o) == "string" and o == "green" or o == "blue" or o == "yellow" or o == "white" then
                return o
            end
        end
    }, customBarColourPath = {
        default = nil,
        required = false,
        allowsState = true,
        validate = function(o)
            if type(o) == "string" then
                return o
            end
        end
    }})
    o.type = "ProgressBar"
    o.allowsChildren = false
end)

function ProgressBar:GetBaseElementSize()
    return math.max(10, self._config.width) + 2, math.max(2, self._config.height) + 2
end

function ProgressBar:Draw(x, y)
    self.sbgID = self.sbgID or self.gui.nextID()
    self.barID = self.barID or self.gui.nextID()
    local elementSize = self:GetElementSize()
    local barPath
    if self._config.customBarColourPath ~= nil then
        barPath = self._config.customBarColourPath
    else 
        barPath = "GUSGUI_PATHpbar_" .. self._config.barColour .. ".png"
    end
    local value = self._config.value
    if value < 0 or value > 100 then 
        local s = 'GUI: Error while drawing ProgressBar "%s" - value %s was not between 0 and 100'
        return error(s:format(self.id or "NO ELEMENT ID", tostring(value)))
    end
    GuiImageNinePiece(self.gui.guiobj, self.barID, x + elementSize.offsetX + self._config.padding.left,
        y + elementSize.offsetY + self._config.padding.top, self._config.width * (value * 0.01),
        math.max(2, self._config.height), 1, barPath)
    GuiZSetForNextWidget(self.gui.guiobj, self.z + 2)
    GuiImageNinePiece(self.gui.guiobj, self.sbgID, x + elementSize.offsetX + self._config.padding.left,
        y + elementSize.offsetY + self._config.padding.top, math.max(15, self._config.width),
        math.max(2, self._config.height), 1, "GUSGUI_PATHpbarbg.png")
    local clicked, right_clicked, hovered = GuiGetPreviousWidgetInfo(self.gui.guiobj)
    if hovered then
        if self._config.onHover then
            self._config.onHover(self, self.gui.state)
        end
        self.useHoverConfigForNextFrame = true
    else
        self.useHoverConfigForNextFrame = false
    end
end

return ProgressBar
