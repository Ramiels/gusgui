local function splitString(s, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(s, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(s, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(s, delimiter, from)
    end
    table.insert(result, string.sub(s, from))
    return result
end

--- @module "GuiElement"
local GuiElement = dofile_once("GUSGUI_PATHGuiElement.lua")
dofile_once("GUSGUI_PATHclass.lua")
--- @class Text: GuiElement
local Text = class(GuiElement, function(o, config)
    GuiElement.init(o, config, {value = {
        required = true,
        allowsState = true,
        validate = function(o)
            if type(o) == "string" then
                return o
            end
            return nil, "GUSGUI: Invalid value for value on element \"%s\""
        end
    }})
    o.type = "Text"
    o.allowsChildren = false
end)

function Text:GetBaseElementSize()
    local w, h = GuiGetTextDimensions(self.gui.guiobj, self:Interp(self._config.value))
    return w, h
end

function Text:Draw(x, y)
    self.maskID = self.maskID or self.gui.nextID()
    self.hoverMaskID = self.hoverMaskID or self.gui.nextID()
    local parsedText = self:Interp(self._config.value)
    local elementSize = self:GetElementSize()
    GuiZSetForNextWidget(self.gui.guiobj, self.z + 1)
    GuiImageNinePiece(self.gui.guiobj, self.maskID, x, y, elementSize.paddingW,
        elementSize.paddingH, 0, "data/ui_gfx/decorations/9piece0_gray.png")
    local clicked, right_clicked, hovered = GuiGetPreviousWidgetInfo(self.gui.guiobj)
    if hovered then
        if self._config.onHover then
            self._config.onHover(self, self.gui.state)
        end
        GuiZSetForNextWidget(self.gui.guiobj, self.z + 3)
        GuiImage(self.gui.guiobj, self.hoverMaskID, x, y, "data/debug/whitebox.png", 0,
            (elementSize.paddingW) / 20, (elementSize.paddingH) / 20)
    end
    if self._config.colour then
        local c = self._config.colour
        GuiColorSetForNextWidget(self.gui.guiobj, c[1] / 255, c[2] / 255, c[3] / 255, 1)
    end
    GuiZSetForNextWidget(self.gui.guiobj, self.z)
    GuiText(self.gui.guiobj, x + elementSize.offsetX + self._config.padding.left,
        y + elementSize.offsetY + self._config.padding.top, parsedText)
    if hovered then self.useHoverConfigForNextFrame = true 
    else self.useHoverConfigForNextFrame = false end
end

return Text
