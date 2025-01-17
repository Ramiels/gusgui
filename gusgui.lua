return {
    init =
    --- ### Initializes GusGui, and sets up file paths.
    --- ***
    --- @param path string The file path where `gusgui/` is located, within the mods folder. Example path would be `mods/modname/gusgui`
    function(path)
        path = path:gsub("/$", "") .. "/"
        local files = {
            "class.lua",
            "Gui.lua",
            "GuiElement.lua",
            "elems/Button.lua",
            "elems/Text.lua",
            "elems/Image.lua",
            "elems/ImageButton.lua",
            "elems/HLayout.lua",
            "elems/HLayoutForEach.lua",
            "elems/VLayout.lua",
            "elems/VLayoutForEach.lua",
            "elems/Slider.lua",
            "elems/TextInput.lua",
            "elems/ProgressBar.lua",
            "elems/Checkbox.lua",
            --"elems/DraggableElement.lua"
        }
        for i, v in ipairs(files) do
            local m = ModTextFileGetContent(path .. v)
            m = m:gsub("GUSGUI_PATH", path)
            ModTextFileSetContent(path .. v, m)
        end
    end
}
