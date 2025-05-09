return {
	'ThePrimeagen/harpoon',
	keys = {
		{ '<leader>m', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', desc = 'Harpoon: Show Harpoon [m]enu' },
		{ '<leader>a', '<cmd>lua require("harpoon.mark").add_file()<cr>',        desc = 'Harpoon: [A]dd file to Harpoon' },
		{ '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[1]' },
		{ '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[2]' },
		{ '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[3]' },
		{ '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[4]' },
		{ '<leader>5', '<cmd>lua require("harpoon.ui").nav_file(5)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[5]' },
		{ '<leader>6', '<cmd>lua require("harpoon.ui").nav_file(6)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[6]' },
		{ '<leader>7', '<cmd>lua require("harpoon.ui").nav_file(7)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[7]' },
		{ '<leader>8', '<cmd>lua require("harpoon.ui").nav_file(8)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[8]' },
		{ '<leader>9', '<cmd>lua require("harpoon.ui").nav_file(9)<cr>',         desc = 'Harpoon: Navigate to Harpoon file #[9]' }
	}
}
