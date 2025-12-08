-- Swift snippets for LuaSnip
-- Common Swift code patterns and templates

local function setup_swift_snippets()
	local ok, luasnip = pcall(require, "luasnip")
	if not ok then
		return
	end

	local s = luasnip.snippet
	local sn = luasnip.snippet_node
	local t = luasnip.text_node
	local i = luasnip.insert_node
	local f = luasnip.function_node
	local c = luasnip.choice_node
	local d = luasnip.dynamic_node
	local r = luasnip.restore_node

	-- Function
	luasnip.add_snippets("swift", {
		s("func", {
			t("func "),
			i(1, "functionName"),
			t("("),
			i(2),
			t(")"),
			c(3, {
				t(""),
				sn(nil, {
					t(" -> "),
					i(1, "ReturnType"),
				}),
			}),
			t(" {"),
			t({ "", "\t" }),
			i(4),
			t({ "", "}" }),
		}),
	})

	-- Class
	luasnip.add_snippets("swift", {
		s("class", {
			c(1, {
				t("class "),
				t("final class "),
			}),
			i(2, "ClassName"),
			c(3, {
				t(""),
				sn(nil, {
					t(": "),
					i(1, "SuperClass"),
				}),
				sn(nil, {
					t(": "),
					i(1, "Protocol"),
				}),
			}),
			t(" {"),
			t({ "", "\t" }),
			i(4),
			t({ "", "}" }),
		}),
	})

	-- Struct
	luasnip.add_snippets("swift", {
		s("struct", {
			t("struct "),
			i(1, "StructName"),
			c(2, {
				t(""),
				sn(nil, {
					t(": "),
					i(1, "Protocol"),
				}),
			}),
			t(" {"),
			t({ "", "\t" }),
			i(3),
			t({ "", "}" }),
		}),
	})

	-- Enum
	luasnip.add_snippets("swift", {
		s("enum", {
			c(1, {
				t("enum "),
				t("enum "),
			}),
			i(2, "EnumName"),
			c(3, {
				t(""),
				sn(nil, {
					t(": "),
					i(1, "RawValue"),
				}),
			}),
			t(" {"),
			t({ "", "\tcase " }),
			i(4, "caseName"),
			t({ "", "}" }),
		}),
	})

	-- Protocol
	luasnip.add_snippets("swift", {
		s("protocol", {
			t("protocol "),
			i(1, "ProtocolName"),
			t(" {"),
			t({ "", "\t" }),
			i(2),
			t({ "", "}" }),
		}),
	})

	-- Extension
	luasnip.add_snippets("swift", {
		s("ext", {
			t("extension "),
			i(1, "TypeName"),
			c(2, {
				t(""),
				sn(nil, {
					t(": "),
					i(1, "Protocol"),
				}),
			}),
			t(" {"),
			t({ "", "\t" }),
			i(3),
			t({ "", "}" }),
		}),
	})

	-- If statement
	luasnip.add_snippets("swift", {
		s("if", {
			t("if "),
			i(1, "condition"),
			t(" {"),
			t({ "", "\t" }),
			i(2),
			t({ "", "}" }),
		}),
	})

	-- If-else statement
	luasnip.add_snippets("swift", {
		s("ife", {
			t("if "),
			i(1, "condition"),
			t(" {"),
			t({ "", "\t" }),
			i(2),
			t({ "", "} else {", "\t" }),
			i(3),
			t({ "", "}" }),
		}),
	})

	-- Guard statement
	luasnip.add_snippets("swift", {
		s("guard", {
			t("guard "),
			i(1, "condition"),
			t(" else {"),
			t({ "", "\treturn" }),
			c(2, {
				t(""),
				sn(nil, {
					t(" "),
					i(1),
				}),
			}),
			t({ "", "}" }),
		}),
	})

	-- For loop
	luasnip.add_snippets("swift", {
		s("for", {
			t("for "),
			i(1, "item"),
			t(" in "),
			i(2, "collection"),
			t(" {"),
			t({ "", "\t" }),
			i(3),
			t({ "", "}" }),
		}),
	})

	-- For loop with index
	luasnip.add_snippets("swift", {
		s("fori", {
			t("for "),
			i(1, "index"),
			t(" in "),
			i(2, "0..<count"),
			t(" {"),
			t({ "", "\t" }),
			i(3),
			t({ "", "}" }),
		}),
	})

	-- While loop
	luasnip.add_snippets("swift", {
		s("while", {
			t("while "),
			i(1, "condition"),
			t(" {"),
			t({ "", "\t" }),
			i(2),
			t({ "", "}" }),
		}),
	})

	-- Switch statement
	luasnip.add_snippets("swift", {
		s("switch", {
			t("switch "),
			i(1, "value"),
			t(" {"),
			t({ "", "\tcase " }),
			i(2, "case1"),
			t(":"),
			t({ "", "\t\t" }),
			i(3),
			t({ "", "\tdefault:", "\t\t" }),
			i(4, "break"),
			t({ "", "}" }),
		}),
	})

	-- Property with getter/setter
	luasnip.add_snippets("swift", {
		s("prop", {
			c(1, {
				t("var "),
				t("let "),
			}),
			i(2, "propertyName"),
			t(": "),
			i(3, "Type"),
			t(" {"),
			t({ "", "\tget {", "\t\treturn " }),
			i(4),
			t({ "", "\t}", "\tset {", "\t\t" }),
			i(5),
			t({ "", "\t}", "}" }),
		}),
	})

	-- Computed property
	luasnip.add_snippets("swift", {
		s("computed", {
			c(1, {
				t("var "),
				t("let "),
			}),
			i(2, "propertyName"),
			t(": "),
			i(3, "Type"),
			t(" {"),
			t({ "", "\treturn " }),
			i(4),
			t({ "", "}" }),
		}),
	})

	-- Lazy property
	luasnip.add_snippets("swift", {
		s("lazy", {
			t("lazy var "),
			i(1, "propertyName"),
			t(": "),
			i(2, "Type"),
			t(" = "),
			i(3),
		}),
	})

	-- Property wrapper
	luasnip.add_snippets("swift", {
		s("pw", {
			t("@"),
			i(1, "PropertyWrapper"),
			t(" "),
			c(2, {
				t("var "),
				t("let "),
			}),
			i(3, "propertyName"),
			t(": "),
			i(4, "Type"),
		}),
	})

	-- Try-catch
	luasnip.add_snippets("swift", {
		s("try", {
			t("do {"),
			t({ "", "\ttry " }),
			i(1),
			t({ "", "} catch " }),
			i(2, "error"),
			t(" {"),
			t({ "", "\t" }),
			i(3),
			t({ "", "}" }),
		}),
	})

	-- Async function
	luasnip.add_snippets("swift", {
		s("async", {
			t("func "),
			i(1, "functionName"),
			t("("),
			i(2),
			t(") async"),
			c(3, {
				t(""),
				sn(nil, {
					t(" throws"),
				}),
			}),
			c(4, {
				t(""),
				sn(nil, {
					t(" -> "),
					i(1, "ReturnType"),
				}),
			}),
			t(" {"),
			t({ "", "\t" }),
			i(5),
			t({ "", "}" }),
		}),
	})

	-- Print statement
	luasnip.add_snippets("swift", {
		s("print", {
			t("print("),
			i(1),
			t(")"),
		}),
	})

	-- Debug print
	luasnip.add_snippets("swift", {
		s("dprint", {
			t("print(\"[DEBUG] "),
			i(1, "message"),
			t(": \", "),
			i(2),
			t(")"),
		}),
	})

	-- TODO comment
	luasnip.add_snippets("swift", {
		s("todo", {
			t("// TODO: "),
			i(1),
		}),
	})

	-- MARK comment
	luasnip.add_snippets("swift", {
		s("mark", {
			t("// MARK: - "),
			i(1),
		}),
	})
end

-- Setup snippets when LuaSnip is available
vim.api.nvim_create_autocmd("FileType", {
	pattern = "swift",
	callback = function()
		setup_swift_snippets()
	end,
})

-- Also try to setup immediately if LuaSnip is already loaded
vim.defer_fn(function()
	setup_swift_snippets()
end, 100)
