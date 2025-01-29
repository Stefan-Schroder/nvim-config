-- 1. `StatusLine`: The status line of the current window.
-- 2. `StatusLineNC`: The status line of non-current windows.
-- 3. `TabLine`: The tab pages line, not active tab page label.
-- 4. `TabLineFill`: The tab pages line, where there are no labels.
-- 5. `TabLineSel`: The tab pages line, active tab page label.
-- 6. `Normal`: Normal text.
-- 7. `Visual`: Visual mode selection.
-- 8. `ErrorMsg`: Error messages.
-- 9. `WarningMsg`: Warning messages.
-- 10. `MoreMsg`: More-prompt.
-- 11. `ModeMsg`: Mode (e.g., "-- INSERT --").
-- 12. `LineNr`: Line number.
-- 13. `CursorLineNr`: Line number of the cursor line.
-- 14. `CursorLine`: Line where the cursor is.
-- 15. `CursorColumn`: Column where the cursor is.
-- 16. `Pmenu`: Popup menu.
-- 17. `PmenuSel`: Selected item in popup menu.
-- 18. `PmenuSbar`: Popup menu scrollbar.
-- 19. `PmenuThumb`: Popup menu scrollbar thumb.
-- 20. `Search`: Search highlighting.
-- 21. `IncSearch`: Incremental search highlighting.
-- 22. `MatchParen`: Matching parentheses.
-- 23. `Title`: Titles for output from commands.
-- 24. `Comment`: Comments.
-- 25. `Constant`: Constants.
-- 26. `Identifier`: Identifiers.
-- 27. `Statement`: Statements.
-- 28. `PreProc`: Preprocessor commands.
-- 29. `Type`: Types.
-- 30. `Special`: Special items.
-- 31. `Underlined`: Underlined text.
-- 32. `Ignore`: Ignored text.
-- 33. `Error`: Error text.
-- 34. `Todo`: Todo items.

local function make_label(tabpage_number)
    local bufname = vim.api.nvim_buf_get_name(
        vim.api.nvim_win_get_buf(
            vim.api.nvim_tabpage_get_win(tabpage_number)
        )
    )

    -- shortern bufname
    return bufname:reverse():gsub('/.*', ''):reverse()
end

local function is_tab_modified(tab_number)
    local windows = vim.api.nvim_tabpage_list_wins(tab_number)

    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)

        if (vim.api.nvim_get_option_value('modified', {buf=buf})) then
            return true
       end
    end
    return false
end

local function tab_table_to_line(tab_table, selected_index)

    local max_width = vim.o.columns
    local current_width = string.len(tab_table[selected_index]) + 3 -- add 2 for spaces and 1 for the >

    local made_line = '%#PmenuThumb#' .. '%' .. selected_index .. 'T' -- make selectable and highlight

    if (current_width > max_width) then
        for i=1,max_width do
            made_line = made_line .. '-'
        end
        return made_line
    end

    made_line = made_line .. ' ' .. tab_table[selected_index] .. ' '
    made_line = made_line .. '%#StatusLine#'

    local full = false;


    for i=selected_index-1, 1, -1 do
        local tab_name = ' ' .. tab_table[i] .. ' '
        current_width = current_width + string.len(tab_name)

        if (current_width > max_width) then
            full = true
            tab_name = '<' .. string.sub(tab_name, current_width - max_width + 1, string.len(tab_name))
        end

        made_line = '%#StatusLine#%' .. i .. 'T' .. tab_name .. made_line

        if (full) then
            break
        end
    end

    if (full and selected_index ~= #tab_table) then
        made_line = made_line .. '%#StatusLine#>'
        return made_line
    end

    for i=selected_index+1, #tab_table do
        local tab_name = ' ' .. tab_table[i] .. ' '
        current_width = current_width + string.len(tab_name)

        if (current_width > max_width) then
            full = true
            tab_name = string.sub(tab_name, 1, string.len(tab_name) - (current_width - max_width + 1)) .. '>'
        end

        made_line = made_line .. '%#StatusLine#%' .. i .. 'T' .. tab_name

        if (full) then
            break
        end
    end

    return made_line
end

function make_tabeline()
    local tabs = vim.api.nvim_list_tabpages()

    local tab_table = {}

    local current = vim.api.nvim_get_current_tabpage()
    local current_index = 0;

    for i, tab in ipairs(tabs) do

        if (tab == current) then
            current_index = i
        end

        local tab_name = tostring(i)

        if (is_tab_modified(tab)) then
            tab_name = tab_name .. '*'
        else
            tab_name = tab_name .. ' '
        end

        tab_name = tab_name .. make_label(tab)

        tab_table[i] = tab_name
    end

    return tab_table_to_line(tab_table, current_index)
end

vim.o.tabline='%!v:lua.make_tabeline()'
