return {
	"L3MON4D3/LuaSnip",
	lazy = false,
	keys = {
		-- { '<C-k>', function() require('luasnip').expand() end, mode = { 'i', 's' } },
		-- { '<C-l>', function() require('luasnip').jump(1) end,  mode = { 'i', 's' } },
		-- { '<C-j>', function() require('luasnip').jump(-1) end, mode = { 'i', 's' } },
		{
			'<C-e>',
			function()
				local ls = require('luasnip')
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end,
			mode = { 'i' }
		}
	},
	config = function()
		local ls = require("luasnip")
		local s = ls.snippet
		local i = ls.insert_node
		local t = ls.text_node

		ls.add_snippets("cs", {
			s("fi", {
				t("for ("),
				i(1, "declaration"),
				t("; "),
				i(2, "condition"),
				t("; "),
				i(3, "update"),
				t(") "),
				t({ "", "{" }),
				t({ "", "\t" }),
				i(0),
				t({ "", "}" })
			}),
			s("fe", {
				t("for ("),
				i(1, "declaration"),
				t(" in "),
				i(2, "container"),
				t(") "),
				t({ "", "{" }),
				t({ "", "\t" }),
				i(0),
				t({ "", "}" })
			}),
			s("cl", {
				t("class "),
				i(1, "name"),
				t({ "", "{" }),
				t({ "", "\t" }),
				i(2, "body"),
				t({ "", "}" })
			}),
		})
	end
}
