return {
	'ThePrimeagen/harpoon',
	keys = {
		{ '<leader>m',  function() require("harpoon.ui").toggle_quick_menu() end, desc = 'Harpoon: Show Harpoon [m]enu' },
		{ '<leader>a',  function() require("harpoon.mark").add_file() end,        desc = 'Harpoon: [A]dd file to Harpoon' },
		{ '<leader>!',  function() require("harpoon.ui").nav_file(1) end,         desc = 'Harpoon: Navigate to Harpoon file #1' },
		{ '<leader>@',  function() require("harpoon.ui").nav_file(2) end,         desc = 'Harpoon: Navigate to Harpoon file #2' },
		{ '<leader>#',  function() require("harpoon.ui").nav_file(3) end,         desc = 'Harpoon: Navigate to Harpoon file #3' },
		{ '<leader>$',  function() require("harpoon.ui").nav_file(4) end,         desc = 'Harpoon: Navigate to Harpoon file #4' },
		{ '<leader>%',  function() require("harpoon.ui").nav_file(5) end,         desc = 'Harpoon: Navigate to Harpoon file #5' },
		{ '<leader>^',  function() require("harpoon.ui").nav_file(6) end,         desc = 'Harpoon: Navigate to Harpoon file #6' },
		{ '<leader>&',  function() require("harpoon.ui").nav_file(7) end,         desc = 'Harpoon: Navigate to Harpoon file #7' },
		{ '<leader>*',  function() require("harpoon.ui").nav_file(8) end,         desc = 'Harpoon: Navigate to Harpoon file #8' },
		{ '<leader> (', function() require("harpoon.ui").nav_file(9) end,         desc = 'Harpoon: Navigate to Harpoon file #9' }
	}
}
