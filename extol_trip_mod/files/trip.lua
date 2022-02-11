local entity_id = GetUpdatedEntityID()
local player = EntityGetRootEntity( entity_id )
local dec_id = EntityGetFirstComponentIncludingDisabled( player, "DrugEffectComponent" )
if ModIsEnabled( "extol_trip_mod" ) == false then
	EntityKill( entity_id )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "color_amount", 0 )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "distortion_amount", 0 )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_amount", 0 )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_size", 0 )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "nightvision_amount", 0 )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "doublevision_amount", 0 )
	return
end

local function hslToRgb(h, s, l)
  if s == 0 then return l, l, l end
  local function to(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < .16667 then return p + (q - p) * 6 * t end
      if t < .5 then return q end
      if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
      return p
  end
  local q = l < .5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q
  return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end

local function get_color(h, s, l)
  local r, g, b = hslToRgb(h, s, l)
  return {r, b, g}
end

local check = tonumber(ModSettingGet( "extol_trip_mod.edrug_bool" ))
local col_control = {}
local col_control = get_color( ModSettingGet( "extol_trip_mod.edrug_color" ), ModSettingGet( "extol_trip_mod.edrug_sat" ), ModSettingGet( "extol_trip_mod.edrug_light" ) )
GameSetPostFxParameter( "extol_edrug_color", col_control[1], col_control[2], col_control[3], ModSettingGet( "extol_trip_mod.edrug_opacity" ) )
GameSetPostFxParameter( "extol_monochrome", ModSettingGet( "extol_trip_mod.mono_min" ), ModSettingGet( "extol_trip_mod.mono_max" ), check, tonumber(ModSettingGet( "extol_trip_mod.shader_bool" ))  )
GameSetPostFxParameter( "extol_extras", ModSettingGet( "extol_trip_mod.inverted" ), ModSettingGet( "extol_trip_mod.fisheye" ), ModSettingGet( "extol_trip_mod.invert_strength" ), 0 )  
if check == 1 and EntityGetWithName( "extol_edrug_entity" ) == 0 then
	local edrug = EntityLoad("mods/extol_trip_mod/files/edrug.xml")
	EntityAddChild( player, edrug )
end

local lua_comp_id = GetUpdatedComponentID()
ComponentSetValue2( lua_comp_id, "execute_every_n_frame", ModSettingGet( "extol_trip_mod.trip_frames" ) ) 

local color_amount = tonumber(ModSettingGet( "extol_trip_mod.color_amount" )) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) ) 
local distortion_amount = tonumber(ModSettingGet( "extol_trip_mod.distortion_amount" )) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
local fractals_amount = tonumber(ModSettingGet( "extol_trip_mod.fractals_amount" )) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
local fractals_size = tonumber(ModSettingGet( "extol_trip_mod.fractals_size" )) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
local nightvision_amount = tonumber(ModSettingGet( "extol_trip_mod.nightvision_amount" )) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
local doublevision_amount = tonumber(ModSettingGet( "extol_trip_mod.doublevision_amount" )) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
if ModSettingGet( "extol_trip_mod.random_bool" ) or ModSettingGet( "extol_trip_mod.true_random_bool" ) then
	if ModSettingGet( "extol_trip_mod.true_random_bool" ) then
		local true_rand = ModSettingGet( "extol_trip_mod.true_random_vary" )
		if color_amount > 0 then
			color_amount = Randomf( 0, true_rand ) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
		end
		if distortion_amount > 0 then
			distortion_amount = Randomf( 0, true_rand ) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
		end
		if fractals_amount > 0 then
			fractals_amount = Randomf( 0, true_rand ) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
		end
		if fractals_size > 0 then
			fractals_size = Randomf( 0, true_rand ) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
		end
		if nightvision_amount > 0 then
			nightvision_amount = Randomf( 0, true_rand ) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
		end
		if doublevision_amount > 0 then
			doublevision_amount = Randomf( 0, true_rand ) * tonumber(ModSettingGet( "extol_trip_mod.trip_mult" ) )
		end
	else
		local vary_rand = ModSettingGet( "extol_trip_mod.random_vary" )
		if color_amount > 0 then
			color_amount = Randomf( color_amount - vary_rand, color_amount + vary_rand )
		end
		if distortion_amount > 0 then
			distortion_amount = Randomf( distortion_amount - vary_rand, distortion_amount + vary_rand )
		end
		if fractals_amount > 0 then
			fractals_amount = Randomf( fractals_amount - vary_rand, fractals_amount + vary_rand )
		end
		if fractals_size > 0 then
			fractals_size = Randomf( fractals_size - vary_rand, fractals_size + vary_rand )
		end
		if nightvision_amount > 0 then
			nightvision_amount = Randomf( nightvision_amount - vary_rand, nightvision_amount + vary_rand )
		end
		if doublevision_amount > 0 then
			doublevision_amount = Randomf( doublevision_amount - vary_rand, doublevision_amount + vary_rand )
		end
	end
end
if ModSettingGet("extol_trip_mod.scale_bool") then
	local factor = tonumber(ModSettingGet("extol_trip_mod.trip_scaling"))
	local current_cola = ComponentObjectGetValue2( dec_id, "m_drug_fx_current", "color_amount" )
	if current_cola + factor < color_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "color_amount", current_cola + factor )
	elseif current_cola - factor > color_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "color_amount", current_cola - factor )
	else
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "color_amount", color_amount )
	end
	
	local current_dista = ComponentObjectGetValue2( dec_id, "m_drug_fx_current", "distortion_amount" )
	if current_dista + factor < distortion_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "distortion_amount", current_dista + factor )
	elseif current_dista - factor > distortion_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "distortion_amount", current_dista - factor )
	else
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "distortion_amount", distortion_amount )
	end
	
	local current_fracta = ComponentObjectGetValue2( dec_id, "m_drug_fx_current", "fractals_amount" )
	if current_fracta + factor < fractals_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_amount", current_fracta + factor )
	elseif current_fracta - factor > fractals_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_amount", current_fracta - factor )
	else
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_amount", fractals_amount )
	end
	
	local size_fract = ComponentObjectGetValue2( dec_id, "m_drug_fx_current", "fractals_size" )
	if size_fract + factor < fractals_size then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_size", size_fract + factor )
	elseif size_fract - factor > fractals_size then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_size", size_fract - factor )
	else
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_size", fractals_size )
	end
	
	local current_nighta = ComponentObjectGetValue2( dec_id, "m_drug_fx_current", "nightvision_amount" )
	if current_nighta + factor < nightvision_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "nightvision_amount", current_nighta + factor )
	elseif current_nighta - factor > nightvision_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "nightvision_amount", current_nighta - factor )
	else
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "nightvision_amount", nightvision_amount )
	end
	
	local current_doubla = ComponentObjectGetValue2( dec_id, "m_drug_fx_current", "doublevision_amount" )
	if current_doubla + factor < doublevision_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "doublevision_amount", current_doubla + factor )
	elseif current_doubla - factor > doublevision_amount then
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "doublevision_amount", current_doubla - factor )
	else
		ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "doublevision_amount", doublevision_amount )
	end
else
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "color_amount", color_amount )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "distortion_amount", distortion_amount )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_amount", fractals_amount )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "fractals_size", fractals_size )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "nightvision_amount", nightvision_amount )
	ComponentObjectSetValue2( dec_id, "m_drug_fx_current", "doublevision_amount", doublevision_amount )
end
