-- Function to change two hex color codes together (ChatGPT)
local function manipulate_hex_colors(hex1, hex2, operation)
    -- Function to convert a hex color to RGB
    local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")  -- Remove the '#' if present
        return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
    end

    -- Function to convert RGB to hex
    local function rgb_to_hex(r, g, b)
        return string.format("#%02x%02x%02x", math.min(255, math.max(0, r)), math.min(255, math.max(0, g)), math.min(255, math.max(0, b)))
    end

    -- Convert hex colors to RGB
    local r1, g1, b1 = hex_to_rgb(hex1)
    local r2, g2, b2 = hex_to_rgb(hex2)

    local r_result, g_result, b_result

    -- Perform the specified operation
    if operation == "add" then
        r_result = r1 + r2
        g_result = g1 + g2
        b_result = b1 + b2
    elseif operation == "subtract" then
        r_result = r1 - r2
        g_result = g1 - g2
        b_result = b1 - b2
    else
        error("Invalid operation. Use 'add' or 'subtract'.")
    end

    -- Convert the resulting RGB values back to hex
    return rgb_to_hex(r_result, g_result, b_result)
end

local function hex_sub(hex1, hex2)
    return manipulate_hex_colors(hex1, hex2, "subtract")
end
local function hex_add(hex1, hex2)
    return manipulate_hex_colors(hex1, hex2, "add")
end

function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)
    vim.opt.background = "dark"

    -- Load in pywal colours
    local handle = io.popen('cat ~/.cache/wal/colors.json')
    if handle then
        local colors_json = handle:read("*a")
        handle:close()
        local colors = vim.fn.json_decode(colors_json)

        -- Set UI colors
        vim.api.nvim_set_hl(0, 'Normal', { bg = hex_add(colors.special.background, "#010101"), fg = colors.special.foreground})
        vim.api.nvim_set_hl(0, 'NormalNC', { link='Normal', strikethrough=true})
        -- vim.api.nvim_set_hl(0, 'NormalNC', { bg = hex_sub(colors.special.background, "#1A1A1A"), fg = colors.special.foreground})

        vim.api.nvim_set_hl(0, 'WinSeparator', { bg = hex_add(colors.special.background, "#010101"), fg = colors.special.foreground})

        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = hex_add(colors.special.background, "#010101"), fg = colors.special.foreground})
        vim.api.nvim_set_hl(0, 'FloatBorder', { link='WinSeparator' })
        vim.api.nvim_set_hl(0, 'FloatFooter', { bg = hex_add(colors.special.background, "#010101"), fg = colors.special.foreground})
        vim.api.nvim_set_hl(0, 'FloatTitle', { bg = hex_add(colors.special.background, "#010101"), fg = colors.special.foreground})

        vim.api.nvim_set_hl(0, 'Tabline', { bg = hex_add(colors.special.background, "#010101"), fg = colors.special.foreground})
        vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = hex_add(colors.colors.color1, "#000000"), fg = hex_sub(colors.colors.color8, "#444444"), bold=true})
        vim.api.nvim_set_hl(0, 'StatusLine', { bg = hex_add(colors.colors.color8, "#000000"), fg = colors.colors.color7, bold=false})
        vim.api.nvim_set_hl(0, 'CursorLine', { bg = hex_sub(colors.colors.color8, "#0A0A0A")})
        -- vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = hex_sub(colors.colors.color8, "#0A0A0A"), bold=true, standout=true})
        vim.api.nvim_set_hl(0, 'CursorLineNr', { link='Search'})
        vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.colors.color7, bold=false})
        vim.api.nvim_set_hl(0, 'Comment', { fg = hex_sub(colors.special.foreground, "#777777")})

        vim.api.nvim_set_hl(0, 'TelescopeNormal', { link='Normal' })
        vim.api.nvim_set_hl(0, 'TelescopeBorder', { link='WinSeparator' })
        vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { link='NormalNC' })
        vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { link='WinSeparator' })
        vim.api.nvim_set_hl(0, 'TelescopeSelection', { link='CursorLine' })
        -- vim.api.nvim_set_hl(0, 'TelescopePromptPrefix', { bg= })
        -- vim.api.nvim_set_hl(0, 'TelescopeMatching', { bg= })
        -- vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg= })
        -- vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg= })
        -- vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg= })
        -- vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg= })
    end
end

ColorMyPencils()
