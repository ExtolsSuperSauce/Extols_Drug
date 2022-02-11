local entity_id = GetUpdatedEntityID()
if GameHasFlagRun( "Extol_Every_Other" ) then
	GameSetPostFxParameter( "extol_edrug_rand", Randomf( 0.0 , 1.0 ), Randomf( 0.0, 1.0 ), Randomf( 0.0 , 1.0 ), Randomf( 0.0, 1.0 ) )
	GameSetPostFxParameter( "extol_edrug_rand2", Randomf( 0.01 , 0.25 ), Randomf( 0.01, 0.1 ), Randomf( 0.01 , 0.25 ), ModSettingGet( "extol_trip_mod.fisheye_mult" ) )
	GameSetPostFxParameter( "extol_edrug_rand_black", Random( 0 , 1 ), Random( 0, 1 ), Random( 0 , 1 ), Random( 0 , 1 ) )
	GameRemoveFlagRun( "Extol_Every_Other" )
else
	GameAddFlagRun( "Extol_Every_Other" )
end
if ModSettingGet( "extol_trip_mod.edrug_bool" ) == 0.0 then
	EntityKill( entity_id )
end
