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

function make_tabeline()
    local tabs = vim.api.nvim_list_tabpages()
    local new_line = ""
    local current = vim.api.nvim_get_current_tabpage()

    for i, tab in ipairs(tabs) do
        -- Highlight selected tab
        if (tab == current) then
            new_line = new_line .. '%#PmenuThumb# '
        else
            new_line = new_line .. '%#StatusLine#'
        end

        -- make tabs clickable
        new_line = new_line .. '%' .. i .. 'T'

        -- Add label name
        new_line = new_line .. '' .. i ..  ' ' .. make_label(tab) .. ' %#StatusLine# '
    end

    return new_line
end

vim.o.tabline='%!v:lua.make_tabeline()'
