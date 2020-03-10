local presets = {}

function ImportString(importString)
	local ok, importTable = serpent.load(game.decode_string(importString))
	
	-- Check validity
	if ok and importTable.terrain_artisan == 1 then
		return importTable.preset
	end

	return nil
end

function GetBuiltInPresets() 
	local presets = {}
	
	presets[#presets + 1] =  {
		name = "Forest - Dirt Path",
		created = 0,
		author = "knighty",
		locked = true,
		layers = {
			{
				name = "Path",
				enabled = true,
				paints = {
					{
						type = "tile",
						tile = "dirt-7",
						radius = 5,
						brushStrength = 1,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 1,
								scale = 16,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "brown-hairy-grass",
						minimum = -3,
						maximum = 5,
						radius = 5,
						frequency = 1,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,									
								scale = 6,
								midpoint = 1
							}
						},
					}
				}
			},
			{
				name = "Path Border",
				enabled = true,
				paints = {
					{
						type = "tile",
						tile = "dry-dirt",
						radius = 10,
						brushStrength = 1,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {									
								contrast = 2,
								scale = 16,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "red-desert-bush",
						minimum = -2,
						maximum = 4,
						radius = 10,
						frequency = 1,
						threshold = 0,
						noiseStrength = 1,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 16,
								midpoint = 1
							}
						},
					}
				}
			},
			{
				name = "Grass Border",
				enabled = true,
				paints = {
					{
						type = "tile",
						tile = "red-desert-0",
						radius = 24,
						brushStrength = 1,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {									
								contrast = 2,
								scale = 14,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "green-hairy-grass",
						minimum = 1,
						maximum = 4,
						radius = 24,
						frequency = 0.5,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 8,
								midpoint = 1
							}
						},
					},
					{
						type = "entity",
						entity = "rock-huge",
						radius = 24,
						frequency = 0.3,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0.5,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 8,
								midpoint = 1,
								range = 1
							}
						},
					}
				}
			},
			{
				name = "Forest",
				enabled = true,
				paints = {
					{
						type = "tile",
						tile = "grass-2",
						radius = 32,
						brushStrength = 1,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 32,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "green-carpet-grass",
						minimum = 1,
						maximum = 2,
						radius = 32,
						frequency = 0.9,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 1,
								scale = 4,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "green-bush-mini",
						minimum = 1,
						maximum = 8,
						radius = 32,
						frequency = 0.6,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0.5,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 10,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "rock-medium",
						minimum = 1,
						maximum = 8,
						radius = 32,
						frequency = 0.25,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0.5,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 8,
								midpoint = 1
							}
						},
					},
					{
						type = "entity",
						entity = "tree-02",
						radius = 32,
						frequency = 0.5,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0.1,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 4,
								scale = 48,
								midpoint = 1,
							}
						},
					}
				}
			}
		},
		masks = {
			{
				type = "tile",
				tile = "water",
				margin = 0,
				whitelist = false,
				enabled = false
			},
			{
				type = "entity",
				entity = "straight-rail",
				margin = 0,
				whitelist = false,
				enabled = false
			}
		},
		brush = {
			radius = 1,
			noiseMidpoint = 1,
			noiseRange = 1,
			noiseContrast = 1,
			shape = "circle"
		}		
	}

	presets[#presets + 1] = {
		name = "Forest - Green",
		created = 0,
		author = "knighty",
		locked = true,
		layers = {
			{
				name = "Forest",
				enabled = true,
				paints = {
					{
						type = "tile",
						tile = "grass-2",
						radius = 32,
						brushStrength = 1,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 32,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "green-carpet-grass",
						minimum = 1,
						maximum = 2,
						radius = 32,
						frequency = 0.9,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 1,
								scale = 4,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "green-bush-mini",
						minimum = 1,
						maximum = 8,
						radius = 32,
						frequency = 0.6,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0.5,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 10,
								midpoint = 1
							}
						},
					},
					{
						type = "decorative",
						decorative = "rock-medium",
						minimum = 1,
						maximum = 8,
						radius = 32,
						frequency = 0.25,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0.5,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 2,
								scale = 8,
								midpoint = 1
							}
						},
					},
					{
						type = "entity",
						entity = "tree-02",
						radius = 32,
						frequency = 0.5,
						brushStrength = 0,
						noiseStrength = 1,
						threshold = 0.1,
						noiseSource = {
							type = "perlin",
							parameters = {
								contrast = 4,
								scale = 48,
								midpoint = 1,
							}
						},
					}
				}
			}
		},
		masks = {},
		brush = {
			radius = 1,
			noiseMidpoint = 1,
			noiseRange = 1,
			noiseContrast = 1,
			shape = "circle"
		}		
	}

	-- lush desert
	presets[#presets + 1] = ImportString("eNrNV9GSmjAU/RWH57BjQFFmJ0/t47YP7Qc4EW4ls5DQS6h1HP+9F9F1w7rqsuqUJ0Pk5px7Tg4hNYPcJDIfzMTaAqJUeibRqkpqwVmJUIEV61yuACuxXmtZgPC+w3Lw1NzyWEkP2GbGrkqasSoHj6FMVV2JMGBzrKvsp0XQC5tRQW1UBa/GNqMVMpOnYvgQR7Fzhbt/mxoTELsFSsBc6WZdJCh2iyox2qKsrAge4qFzjVhF3EDw8ZQVKi0NgaWVxpsNa5AKbymphF9lMs/N0qPboOU8h1RYrGHDbss3dOhOoz58zxFMFVp/5BGVtl4KiUFp1Z8TsIcnYQeR22P+cdg70K8gcwJ8gCa8BQJoP5MKV/6CHqo89gvhdw06WRGGiQthGFMlrYq6IKyF/Lv9Fd9XzXDiunfaQ83xcfcSEqdRrbIIqZ/S9iR9hwd9QVtlV321HXW0HX+YBO9qsxc74C6JFij1nJT2h1NX36ir7xX9O+khDO9a/kIDl8pK74g3p/diexeuczRL7ScSS7D73fqWc+Du4PHtFP68i/t0odmPCRpr9DnF+f/pZh6eJnehmV1h+fTOMRy65PocIqLj/QnjMzHMrxTDPUJ3fDx0u2+OfejS6S710STP/lwt3Ojl3VJXNGsYdGHeamO+ZjRynHygXhV06jtq6Ltatofa8WVqtwbdEg68q+brpw/q+8iJzr1V3j0CvsmZS4Tc0FT1TEg2LWGx3nVgp9C3FzDt+IfUC9gPvrwIwOiDoeGYKExI9w1r7fFEFQdft1kwCDyWINDXRSrCCY/CiMnaZgYbmo8ItkY9mD2CTv8BPxanDQ==")

	-- moors
	presets[#presets + 1] = ImportString("eNq9l09zmzAQxb+KhzNk+G88GZ16bXpoj5lORoat0QRLdBF1PR6+excHOxbBiUuwORkw0vvteyxSpmaFSnkxe2I7DYhcyCeOWlRcMs8uESrQbFfwLWDFdjvJ18Csb7CZfW0vWXZJD+j2jt6WdEeLAiwbeSbqigW+vcS6yn9oBLnSOQ0olajg5FznNEOuioy5d4uFaxxh929VYwqsm6AELIRs50WSoveqUiU18koz/+7NEBWxAfOj2F6LrFQklmaKbBqmEpUGSSO7d4Hbe6xp7JaEWRtOUzhVzotCbSy6DJIvC8iYxhoa+3w9Hr2fbIqaJKay+ZiaXFiEI3QmUDuB1diPwYUQ7rsQUTiBsQeIEwbvLAGlN2sJLvdrAq9Cd2Ec8QjMaDi/cXhCfaRc0UOV45NR3eAgtdDb0TbFpv5ghH7P1O91+ueeqf9FKJUbARzXt+xfCL9rsnFLOua9t3Fx5MsgVci1+DM6ivPpmBIT6VVbawyAdEqhuUV/kmJdr0nHmv/d/0oM2mg6uhuypRxL0M4+gUOMvulodD1Hw9gcO7phFZYk02nhP7b5mqGO5uaLm0xXAt87X4NCpDnISxJ+2zbsf74a8XA1onfacDBVG457UfGvFuhDF0aVPjt5vQKzD8dXjGzg3wrylCg08rvHrta0tBvM8IS03mK6DHreeb7E4Fui2kgn5wK3/UbtDmB+KrX/zef1lzp+x0fzDoY0I4p2uWBmNJiyjU6wTO3tJIKPM/nmwzD0tUWl1XCnvWlvHeHy4jKXTzupZ01oqv+mS4xYlB8+hu5HCwLjZXt3BTTgZdz3sqFb1TNpaV6Q2a6rQQfx8LoR2p9/53IFh5MvRw9s2r62lKnAlKxv7JeEPCiFpDJFoD1uxrwkDJMosnmtc4Ut3z2CrlHOnu5BZv8AL8KMTQ==")

	-- track
	presets[#presets + 1] = ImportString("eNrFltuO2jAQhl8F5dpBSTg0q5VvWqm96VZV23tk4tnEIrHpxClFiHfvmHBIOOwuLNBckFgJnvk8/z+2NJ3cJCLvjPjCAqJQeiTQqlJoHrIpQgmWL3IxByz5YqFFAdz7LmzmMdBinIPkFitgU/qjdV/Y+ZS+sCoHj7lf7iFIX9I8aP3QYyikqkoeDtkYqzL7aRF0ajMKpo0qoTG2GUXPTC55sH5nKkyAr0NMAXOlPYqMlJRd5ZcYbVGUlkfdOGhdfVYSJfAPrFByaihZHi6XrBDl5MlIoAFbzyshMSis+kMAu2fujdHMtJ8JhXM/pSClR1NpVVQF93s00d/V46AB+IzwuwKdzAmmDRtcF3bNNmyxvQqUIoD2x5SX70B2OOGWJn4/TTcOH1pX73rFDIM2sWOuFfoNZp2vTrTecWWuseKbijBcpxm3NVe7QqraD1sFRvSqaakti3Nb56NB6Wg2XzyLvHzRdZJk6mLsHBfc1nGbmpypwkZ3cFJsmCrayrDfYGjK8DDffbb357/T1Bdn+oNCnNH9gm0tov59atG/pCMcbXHhYTEIYleMoDu4S4+LjxOBtsrOXVXcnVbdJBM/q1LwTmTbO6uHDa6SL6WiU9hT1WdDYewZxl4Vxo+2YL3oLlqiMBdoKRE4BXtaTFGDolmeh5uKadOY+7fbMPd4hneS2/6O+Gr3dT4pgFIuzsGJBv/BPi/YncKCH7Q8cXFr6p6/d2zOI/14f++oT5jHjTwT1m0khcBUacpplikLuaL56h7Q6ggn0UtKQaWZ9emWv2G21dFiWS8IX2z21Rr5adeqVuMfdb+qB58a7smESyVRmBDOktWd7BeKZOKxBIHAJB9GwTCKmahsZtAtxyOCrVB3Ro+g5T/LN472")

	--deciduous forest eNrNV82OmzAQfpWIs4liCJBo5VOrntoe2geIHJgN1oJNx6ZthPLuNeQXliSbiE2XUxwbz/czMzaJGmUq5tlowSoDiFzIBUcjNJeMkgJBg2FVxteAmlWV5Dkw5zv8GX2t/3JIYV8wdkaKjFRmXdhZIzJwCPJElJr5HlliqdOfBkGuTGo3lUpoOBmb1EZJVZawyXgezFtPuFutSoyB7QIUgJmQdWy0cEyDLFbSINeGTYm2dIB5QUhykRTK4rMbB5sNqYExJxFoXN/ZDAJ3Nmk90TvBpY4dg+TLDBJmsASL/qwVb185gAI+bStAb1bAGwftLfaShNOjIvSgx8q+pF3v6B9II8z6PP7JRfxe1A7u3YE/7EqwxR/RNv4tUCs3ArgTz0VIHPKM8KsEGa8b0/ecEogVciN+w728ojt40H4eszaNI7baDADpFsJwxy6SIi9ziyPnf5tfsxa7qGPzfDi2D+QacyzAuE0W9nH2HsV5PO2kXfBAFZYWpluTv2Y7/fhlGgYXy7Rboo/trsPRDC50U3+obhoOYNPbcnLvEqr4xU3LFbR96ogwaOH53qNInjKatsqwoa1znmW9FfgRWyul58lFXbvu6bzD5PBw9xcb97bzPxzyAhBMu6huJ+a3t/CvZSntsw2VUbI/S4+99Jln+p2b6c386XjeLfR+Y3cXdVy79WXd+a/FF+zb/bUjPOXCAt5V06mFr40Ku4fexk7pl+ZTo2HDqh29nQHfDqG34x9crmA/+HTQl+iU15RigbG1dUO27n+GWCSlKvXoi7JSGIfECNzY4POQUm9GeGlShTWvJwRTohwtnkAm/wAXLiGp

	--steppe
	presets[#presets + 1] = ImportString("eNrFlU2PmzAQhv9KxNlEfBO08qnXtofucVVFDkyDVWLTsek2Qvz3DglJQzYfSjarcsLYeJ533vG40JNK56KazHlrAVFINRdopRGK+6xGMGB5W4k1oOHtS/Cdt0qsgDtf4XXyuf/ssJp+sjTb2nVNM1ZW4DAUhWwMDwO2wMaUzxZBLW1JmyotDRyMbUlRSl0V3JtmXjZ6kmG1bjAHPgSoASup+rhIKHZDlmtlURjLfY8Z0gM8iBO2kkWtCY52jruO9WTcWdI64wZOx4b9QFlp1/cix/HNjMGASJH2hD7xbUEogwjgeqnDfiD8akDla4qTeOMn+//8QXKJP7jG3/8gFhUU3GIDHXsJP7i6wnSMENyufBqPt4iGVCTROBXbUkMo3IKOEFrXo3pTstp5VkCuUVj5+4IY7/JRCcck6R1i/PEW/q4us+OT8w+XOwvUr8othcS1uzlLDq1WctWsiHAl/mzeZiPv0/hc7b47D3eozk5bOBs7eCh5SQWt3FxgDfa85nCkefZgv6M32A/zO/CvSkdttbpudBQ/ztlpGr1fcXTa6+PO+1bxbfV9vbfFH9vbbr8nj4/BuUvp8NIMnQfaG9/TfQdI37/Jv0OvshNuJsd+dTRlflLsbiuJt4PGwYQv++Db8TehlrAbfNrnmJlS9KpyiTlZSx1hUwHPFuqa8pYjCEshqZWnacZEY0uNvZ4nBNugmsyfQBV/ARFQWwI=")

	--lakes
	presets[#presets + 1] = ImportString("eNqtlMFO4zAQhl+lytlBdUJpI+TTXlkOcESocuOhsUjsMJ5QqijvzqSEQhBbLaU+xbE9/v5/Zmz8pPS5LidL1RIgauuWGskG7ZQUNUIAUm2pt4BBtc6WonW6AhVdw2Zy1f+ORM2HiFdb2ta8QraESKA2tgkqTcQKm1DcEoJbU8FBnbcBPs2p4FsKXxo1PZsNq77BHNQQsAYsrevvQb6adiS5d4Q6kEr4TGABoORiJipras80Snad6EFUtNF8IupEz77j/z3lPMlGY/Fjajk9DG0A6gG8E+D0qgSjCBvoDvh/J+/VCdSdX0xH46icjEOcH1aLYGLDlYYUS87UXfKfOqanrqUBM5PfUXJLmDjt+dI9n4Hcoyb7fDRllo6tmh/hthyHkIOMNPuQwXawkA9cFa3Qb1xcaIvbeM2BQsS7na2aigkr/bL7WogHhKcGXL7t6/5LWjP2Yn5CLy5+3Vf/9iIZp/SzE2sE+JET8mtTdrwtPDJI96ZXtYMBQ6f93V/9Nr/Rbg3vkz/7R0GEQvcSc4s51z2/WbtWv9KPwEw5Ar8Iht+O2XzBjaQbKjz2MJcI1KCbLC/BmVew+wnG")

	--ice field forest
	presets[#presets + 1] = ImportString("eNq9ltuO2jAQhl8lyrWDEnIAtPJVpZUqtb1oHwAZZ5ZYm9jpZFJKEe9eZwO7a8ouNMDmKs5h/H/zj2acG680UpTenG8IEIXSc4GkGqF5xGqEBohvSrEGbPhmo0UF3P8GK+9L98hntf2Buje0ru0bUiX4DEWu2obHY7bAtil+EIJeUmEDaqMaeLWmwu5QmDLn4SjNZs4V7742LUrguw1qwFLpbl+0UuhJlTSaUDTEx6NZ6FwJaywb8CiMWaXy2lixPNpuWaeT+w9o/oAOGm1WQepv2VkQ4bsQycUQ8Sh2IeIdRHKSIbsOQxa6DNmtGVbC/h9Ube7bR6DFooScE7ZgcW5ZcUk6pMTOr6nxix85SIOC1K/BrgzQuld6IPRFC/fRyMeAlF4Hq0KRFfeA8LMFLdd9fiqlVdVWVkslfj/dzT7UowEGpcd7QJYcs8vyAYoyIKGDXCG99gw0KVoP7wSujv/3LxpN3BB7Q6eRi9ILtXlGgL7yhGvkQZxwdsW6nAywKHLlRHuut+t0adF0UCuyZP/W5NShzW5H+4GsUmANFCxtmOYY89h1OL2dw5dX8vAsLKzMoIM/ZXt0zVY7cQfg9HrA7/XiUskC9On6Ts+c8qeOW5e7+karHYdnTMaDKbK1sM2jDb/tKfhmh7Wj+PocsF9/F3oJ+8Wn55bJmkJ0wqVCaXOzZf1s+izBu1dQ5t69sSkgn0kEe+rIeZRO0lkSMdFSYbCTe4dALWpvfgc6/wumk9uf")

	-- deciduous
	presets[#presets + 1] = ImportString("eNrNlU2P2jAQhv8KytlB+SB8aOVTq57aHtrjqkImmSXWJnY6npQixH/vJLCwybK0ILranDB2PO/zzkcyOyhsqorBXG4IEJU2c4WknTIyFBWCA5KbQq0Bndzchz/kxqgSpPcVVoPPzd+eqPgl4l2jC7GhdcW7pAvwBKpM107GkVhg7fLvhGCWlPPFxmoHz9aUc6TcFpkMhrNp0Hkm+9O2xhTkPkAFWGjTxEaWQ6261BpC5UiOh9Gs80yFY0aQUTIWpc4qy4I5UiL4GqcdgeGbg+FouxWNcukhZH7G7Eh+4G1vQjXrUo0uphpdCpFplh97vAajFgVkkrCGrbiPzmXxxen43OkbOBOHXWfCi52Jhknf3J1VcXB0Kjz4suSXnB8d8wqGNK1f1x+c1R9NusGjK/SP+xbs9E/Crv6dULYbAfwVUKFM5i888YDws+b8r5t6OGBlkFpUpH/BtWjJuNtH8RVo4Wm0aZfsqHXXfClasnxpqY0u65J1lep3+2vaoe0ZF8xuR/8mrAu0K+OnCisgvy3MU8xRl/mWKR71HEzeBHvJBWz8Bcv0G9p/yHPy/rt1nJzp1ja3bb8+9vv1xcRN/u/EvZg4HM76pu3na/T6fA29dzaIkifRfyvLbjc+z9X0RJ3G/fxtecs9tl/SFlFu9sz7pHw5RN+tvymzhKfFh4PnwuWqoUo1ppzqrdhVxEdIdVbb2g0+WfaHPJEiKOLgURhGcRALVVNusWG7Q6AazWB+Byb7A9uccA4=")
	
	-- lakes and rivers
	presets[#presets + 1] = ImportString(	"eNqtlMFuozAQhl8FcTYIQyFBlU977e6hPVaryMHTYBVsdmw2jSLefYcmaUMVVRsUnxgM4+//Z8bKBo2tZBOsxN4DotRmJdFrJ43grENw4MW+kTtAJ/Z7I1sQ4S/YBg/jq5B19IMfd/yuox2vGwgZSqV7J7KUrbF39ZNHMBtfU0JjtYOz2Nd0Qm0bJZK4OO7aHisQx4QdYKPNeA7S0f6dorLGo3RepHGZTNYdc6QFRJoXrNWqswQn+DCwkUuEW0kJQgrByHUDSnjsYWDXqeLFVarKdELI+dUqF3FeTlZxUpnknyqTOGeUxmnnwVDmJM7yL+bM9+GZ/xY3qPBdMSXKZ1Q8v1xxvswvVRxBRYp6GH3Ew4E9p/+pI/lWxwzuI2bJL1HSsKkoG/myDz4FlUXp9d/ZlGU2tWoxw20+TcGPMrJy0ngk5BNXhGu0WxPVUuMu2lAiF9LXRrd9S4StfHt/WrIXhD899eqOUiy+lLUkLxY39KJIpyO0vKEX6bSk505sEOAqJ/jZUL7IxgHFrXSvRDIcBIv96R46SPj5cfYhfpRmA6fgx4meYGs5aqw0VtT4AzvM+oN8BRdQ+wWPBIzEVyHQ7aBooLIs5zmTva8tjmD3CL5HE6zuwah/IkkmOQ==")
	
	-- volcanic lowlands
	presets[#presets + 1] = ImportString("eNrNl01v4jAQhv8KytmOYvIBqPJpr9097Ep7rUwyNFYdm7Wdsgjx33dSSKmBfkAp2pxIrMy8j9/JjKnMQJlSqMEdX3mwVkh9J6yXTmjOyNyCA89XSizBOr5aadEAj37AYnDbPYrIHF/w3YpfznHFSwURsaKSreOsIFPbuvqXt6DvfY0BtZEOXtz7GjPURlU8iSf5dtm0tgS+jTgHq6TuElnM7Z9klEZ7K5zneZwTh+qBD/OCNLKaG5SDsXKC7znpPGgMlcTZek06bTxaCIxBXS2UMosIH4MWUwUV97aFNTmNMB2eRJgXk+BKTwYexpMkuLItP0vSHT97pn00qhRaltRYoe+B1iA8TSPk/AhN8iZN9mmaNE5DmnRLU3yYJbsMy5gFOlh2MksWH2zH1pnsrcJM8z0//4tCzfJzKvOMUmQ7+yooccXLx7NNPEN0L3lP8czCnxYdWm72opFaNm2D6Rrx9+lXQXZyeWRN+UAbQM0N7TF3YKC99MvrQ6XF61AHZXeUcaMcrbFLiurgulV4Rgnmx5tjkR0rSCQGKxT1QtNK2qAvfs6z7KBJn4rC4lEYojd1zEKU3qLOHroAr4SuKO74S7OLcFvY+ILf3OgMl8Jem7AeLSR7+YFNrVloWguJhXiPUVx0pF7HIXSYJJlcDvqKyKWwc/CvMw8D5lH+Zcw47cPY+VV24amzugZnIJ0qUT685zu75DgZhQN9fDni/XlzaPxMtbMZxcb7fqXnHzwBvXc2/by/r7TfYXLKeWBvxKyR2j1gnvUGh6/6fxcbgd+fI2/uf3bB+ptvz/2U4EGqIyilLXGT1mQzuH5vRQxuzaJrnfiRlRaFYHY2yUZ5OiGi9bWxnfAbC761enB3A7r6B6DNmrw=")
	
	-- glacier
	presets[#presets + 1] = ImportString("	eNrFlMtugzAQRX8lYu0gwjNR5FUX3bRdtB8QOTANVsFGY6MoRfx7h5KkIZXyaqt6Zxuu77kzmkyPCp2KYrTgjQVEIdVCoJVGKD5hFYIBy5tCbAANbxolSuDOE6xHD92Rwyr6wXY3dlPRjZUFOAxFJmvDJzFbYm3yF4ugVjYnQaWlgYO9zemFXBcZ99zI9wbL336ta0yBbx+oAAupuneRrNhPV6lWFoWxpGcIBXg8ZaXMKk3W+KRtWeeKO6+o30GNjdLrse/QMSixLCDjFmto2Z+yTadDtuRqtsBNjuPpYZP4C5ZCZKRipLGgSNhzwz3+WpDiuKyzn6IH/jXoV4P67mwIGm5BJ15wrqyRQzCXWPZOViuMZ4MV3FCtYAgR7CD8cwzx7zAk4XGK1zJE+9xPNVjw3w3mhtEtPXZ5U32fFS0rhXkjwbY3ypvdVOidPO4F+/2zUCvYbe4OplUuOqupxJTwW9andF+IVHYZpQgUacb9JEqSKGKitrnGzuUcwdaoRos5qOwDT6EHVg==")
	
	-- swamp
	presets[#presets + 1] = ImportString("eNrdld1ymzAQhV/Fw7Xs4cfQeDK6ym3bi+YBPBvYGk1B0NVS1+Pxu3fxX4wdJyFx0rRcIUCrc/TpLFk1KKoUisFULxmJwNgpEBsHVgeqJnTIelnAAsnp5dJCidr7ivPB5/aRp2qZwO0bXtTyhk2BniLITON0kKg7alx+y4R2xrkUtJVxeDDmXFbIqyLT/mgSTzpXsv26aihFvV2gRiqMbdclkcJrVWllmcCxjkZjv3ONlRNvqMM4UaXJ6krEykqxkjLOOEYrlf1R5B9NW61U60R7GWI9B1lmOCNE663UVkeGaUXA5tdL7fY2F2y9ROG9lUCE3ivR3lrkMAdDCxEMznnyrTVlU8r0En6v70L1nfBnI94X4j2MpQZauCsw00wNisU3pRx1IF99BMr/G+HofZFenfDojzTploifiXSPcL0Xw0DwWVNcCmHwhghToBr5EYadlCbx/ly+ilTQ2eVgfLnwBf7zQP1zWesHKn7fdnox34cpCv8qmNHkzAFL+pHqxOeo9U8ebJo702jZ8OKlGYte3Q3DY73noG2EygES+8M5cgE2G5ZPWL8c21F80rX7Wz3XTsZP0a4Nw0N5jDv2P53YP4rnSia6H6JptbGul7u92Jj5slexGX8DO8Pd4OYgVjm0blNDqaRZfkPr0N/Ooaw9lRJK28t06IdhINag4byi1tg1ITdkB9NrtNkfldUJGg==")

	return presets
end