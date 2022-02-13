dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	print( tostring(new_value) )
end

local mod_id = "extol_trip_mod"
mod_settings_version = 1 
mod_settings = 
{
	{
		category_id = "group_of_settings",
		ui_name = "Trip Settings",
		settings = {
			{
				id = "color_amount",
				ui_name = "Color Amount",
				ui_description = "This one is a bit weird. Changes how much color shifts",
				value_display_formatting = " $0%",
				value_display_multiplier = 2.5,
				value_default = 0.5,
				value_min = 0,
				value_max = 40,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "distortion_amount",
				ui_name = "Distortion Amount",
				ui_description = "Shifts parts of the screen.",
				value_display_formatting = " $0%",
				value_display_multiplier = 2.5,
				value_default = 0,
				value_min = 0,
				value_max = 40,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "fractals_amount",
				ui_name = "Fractals Amount",
				ui_description = "Neat Geometry.",
				value_display_formatting = " $0%",
				value_display_multiplier = 0.25,
				value_default = 1,
				value_min = 0,
				value_max = 400,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "fractals_size",
				ui_name = "Fractals Size",
				ui_description = "How Large the Neat Geometry is.",
				value_display_formatting = " $0%",
				value_display_multiplier = 2.5,
				value_default = 0.5,
				value_min = 0,
				value_max = 40,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "nightvision_amount",
				ui_name = "Nightvision Amount",
				ui_description = "Worm Blood Nightvision.",
				value_display_formatting = " $0%",
				value_display_multiplier = 0.25,
				value_default = 0,
				value_min = 0,
				value_max = 400,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "doublevision_amount",
				ui_name = "Doublevision Amount",
				ui_description = "Drunk effect.",
				value_display_formatting = " $0%",
				value_display_multiplier = 2.5,
				value_default = 0,
				value_min = 0,
				value_max = 40,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				category_id = "sub_group_of_settings",
				ui_name = "Random",
				ui_description = "Multiple settings that randomly change the effect values.",
				foldable = true,
				_folded = true,
				settings = {
					{
						id = "random_bool",
						ui_name = "Random On/Off",
						ui_description = "Controls the random generation of values.",
						value_default = false,
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "random_vary",
						ui_name = "Random Variation",
						ui_description = "Will randomly change each value based off the set ones.",
						value_default = "0.1",
						values = { {"0.1","Small"}, {"0.25","Medium"}, {"0.5","Large"}, {"1","Huge"}, {"10","Giga"}, {"25","FOONGUS GOD"} },
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "true_random_bool",
						ui_name = "True Random",
						ui_description = "Ignores set values, and randomly picks new ones. THIS OVERRIDES THE RANDOMS ABOVE",
						value_default = false,
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "true_random_vary",
						ui_name = "True Random Variation",
						ui_description = "How much variation do you want?",
						value_default = "1",
						values = { {"1","Small"}, {"4","Medium"}, {"10","Large"}, {"20","Huge"}, {"30","Giga"}, {"45","FOONGUS GOD"} },
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "extol_trip_antisetting",
						ui_name = "These work well with Scaling for smoother transitions",
						not_setting = true,
					},
					{
						id = "extol_trip_antisetting1",
						ui_name = "(Random effects will ignore Trip Settings at 0%)",
						not_setting = true,
					}
				}
			},
			{
				category_id = "sub_group_of_settings2",
				ui_name = "Scaling", --unsure what else to make with this, and afraid I'll make it laggy at some point. hmm....
				ui_description = "Multiple settings that change how fast the effect is applied.",
				foldable = true,
				_folded = true,
				settings = {
					{
						id = "trip_frames",
						ui_name = "Frames",
						ui_description = "How many frames do we wait?",
						value_display_formatting = "Every $0 Frames",
						value_default = 2,
						value_min = 1,
						value_max = 90,
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "scale_bool",
						ui_name = "Scaling On/Off",
						ui_description = "Controls how fast the effect is applied.",
						value_default = false,
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "trip_scaling",
						ui_name = "Scaling Speed",
						ui_description = "How much do we scale by?",
						value_default = "0.0005",
						values = { {"0.0005","Small"}, {"0.001","Medium"}, {"0.0025","Large"}, {"0.01","Huge"}, {"0.025","Giga"}, {"0.05","FOONGUS GOD"}, {"5","FOONGUS GOD x 100"} },
						scope = MOD_SETTING_SCOPE_RUNTIME,
					}
				}
			},
			{
				category_id = "sub_group_of_groups",
				ui_name = "Shaders",
				ui_description = "Shader Effects",
				foldable = true,
				_folded = true,
				settings = {
					{
					category_id = "sub_group_of_settings3",
					ui_name = "Monochrome Shader",
					ui_description = "Shader Effects",
					foldable = true,
					_folded = true,
					settings = {
							{
								id = "shader_bool",
								ui_name = "Shader On/Off",
								ui_description = "Determines if the shader is on.",
								value_default = "0.0",
								values = { {"0.0","Off"}, {"1.0","On"},},
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "mono_min",
								ui_name = "Monochrome Min (HSL Color Wheel)",
								ui_description = "How much color do we let though?",
								value_default = 0,
								value_min = 0,
								value_max = 359,
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "mono_max",
								ui_name = "Monochrome Max (HSL Color Wheel)",
								ui_description = "How much color do we let though?",
								value_default = 20,
								value_min = 1,
								value_max = 360,
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
						},
					},
					{
					category_id = "sub_group_of_settings4",
					ui_name = "Edrug",
					ui_description = "Multiple settings that change how fast the effect is applied.",
					foldable = true,
					_folded = true,
					settings = {
							{
								id = "edrug_bool",
								ui_name = "EDrug",
								ui_description = "Turns on 'EDrug Mode'",
								value_default = "0.0",
								values = { {"0.0","Off"}, {"1.0","On"},},
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "edrug_color",
								ui_name = "EDrug Color (HSL Color Wheel)",
								ui_description = "EDrug Color",
								value_display_multiplier = 360,
								value_default = 0,
								value_min = 0.0,
								value_max = 1.0,
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "edrug_sat",
								ui_name = "EDrug Saturation (HSL Color Wheel)",
								ui_description = "Saturation of EDrug Color",
								value_display_multiplier = 360,
								value_default = 0.5,
								value_min = 0.0,
								value_max = 1.0,
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "edrug_light",
								ui_name = "EDrug Lightness (HSL Color Wheel)",
								ui_description = "Dark/Light control",
								value_display_multiplier = 360,
								value_default = 0.5,
								value_min = 0.0,
								value_max = 1.0,
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "edrug_opacity",
								ui_name = "EDrug Opacity (HSL Color Wheel)",
								ui_description = "How 'See Through' are the Boxes/Overlay?",
								value_display_formatting = " $0%",
								value_display_multiplier = 100,
								value_default = 0.5,
								value_min = 0.0,
								value_max = 1.0,
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "fisheye_mult",
								ui_name = "Fisheye Strength",
								ui_description = "How much is the screen distorted?",
								value_display_formatting = " $0%",
								value_display_multiplier = 2000,
								value_default = -0.05,
								value_min = -0.1,
								value_max = 0.1,
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
						},
					},
					{
					category_id = "sub_group_of_settings4",
					ui_name = "Extras",
					ui_description = "Multiple settings that change how fast the effect is applied.",
					foldable = true,
					_folded = true,
					settings = {
							{
								id = "fisheye",
								ui_name = "Fisheye Effect",
								ui_description = "Seperate toggle for the 'Fisheye' effect.",
								value_default = "0.0",
								values = { {"0.0","Off"}, {"1.0","On"},},
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "extol_trip_antisetting2",
								ui_name = "Use the Fisheye Strength in EDrug shader to change this effect",
								not_setting = true,
							},
							{
								id = "inverted",
								ui_name = "Color Invertion",
								ui_description = "Inverts the screen colors",
								value_default = "0.0",
								values = { {"0.0","Off"}, {"1.0","On"},},
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
							{
								id = "invert_strength",
								ui_name = "Invertion Strength",
								ui_description = "Invert the screen colors by how much?",
								value_display_formatting = " $0%",
								value_display_multiplier = 100,
								value_default = 0.45,
								value_min = 0.0,
								value_max = 1.0,
								scope = MOD_SETTING_SCOPE_RUNTIME,
							},
						},
					},
				},
			},
			{
				id = "trip_mult",
				ui_name = "Multiplier",
				ui_description = "How much do we multiply the effect values by? USE AT YOUR OWN RISK",
				value_default = "1",
				values = { {"1","None"}, {"2","x2"}, {"3","x3"}, {"4","x4"}, {"5","x5"}, {"10","x10"}, {"25","FOONGUS GOD"} },
				scope = MOD_SETTING_SCOPE_RUNTIME,
			}
		}
	}
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
