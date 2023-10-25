return {

  { "nvimdev/dashboard-nvim", enabled = false },
  { "echasnovski/mini.starter", enabled = false },
  -- Dashboard. This runs when neovim starts, and is what displays
  -- the "LAZYVIM" banner.
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    enabled = true,
    init = false,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = {
        "                     .:::!~!!!!!:.",
        "                  .xUHWH!! !!?M88WHX:.",
        "                .X*#M@$!!  !X!M$$$$$$WWx:.",
        "               :!!!!!!?H! :!$!$$$$$$$$$$8X:",
        "              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:",
        "             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!",
        "             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!",
        '               !:~~~ .:!M"T#$$$$WX??#MRRMMM!',
        '               ~?WuxiW*`   `"#$$$$8!!!!??!!!',
        '             :X- M$$$$       `"T#$T~!8$WUXU~',
        "            :%`  ~#$$$m:        ~!~ ?$$$$$$",
        '          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"',
        ".....   -~~:<` !    ~?T#$$@@W@*?$$      /`",
        'W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :',
        '#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`',
        ':::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~',
        '.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `',
        'Wi.~!X$?!-~   :: ?$$$B$Wu("**$RM!',
        "$R@i.~~ !    ::   ~$$$$$B$$en:``",
        '?MXT@Wx.~   ::     ~"##*$$$$M',
      }

      dashboard.section.header.val = vim.split(logo, "\n")
      -- stylua: ignore
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
        dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
        dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
        dashboard.button("c", " " .. " Config",          "<cmd> lua require('lazyvim.util').telescope.config_files()() <cr>"),
        dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
        dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
        dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
        dashboard.button("Q", " " .. " Quit",            "<cmd> qa <cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
