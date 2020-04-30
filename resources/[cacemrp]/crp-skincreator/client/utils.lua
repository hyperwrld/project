drawableNames = {
    'face', 'masks', 'hair', 'torsos', 'legs', 'bags', 'shoes', 'neck', 'undershirts', 'vest', 'decals', 'jackets'
}

propNames = {
    'hats', 'glasses', 'earrings', 'mouth', 'lhand', 'rhand', 'watches', 'braclets'
}

local headOverlays = {
    'Blemishes', 'FacialHair', 'Eyebrows', 'Ageing', 'Makeup', 'Blush', 'Complexion', 'SunDamage', 'Lipstick', 'MolesFreckles', 'ChestHair', 'BodyBlemishes', 'AddBodyBlemishes'
}

local faceFeatures = {
    'Nose_Width', 'Nose_Peak_Hight', 'Nose_Peak_Lenght', 'Nose_Bone_High', 'Nose_Peak_Lowering', 'Nose_Bone_Twist', 'EyeBrown_High', 'EyeBrown_Forward', 'Cheeks_Bone_High', 'Cheeks_Bone_Width',
    'Cheeks_Width', 'Eyes_Openning', 'Lips_Thickness', 'Jaw_Bone_Width', 'Jaw_Bone_Back_Lenght', 'Chimp_Bone_Lowering', 'Chimp_Bone_Lenght', 'Chimp_Bone_Width', 'Chimp_Hole', 'Neck_Thikness'
}

local tattoosList = {
    ['mpbusiness_overlays'] = {
        'MP_Buis_M_Neck_000', 'MP_Buis_M_Neck_001', 'MP_Buis_M_Neck_002', 'MP_Buis_M_Neck_003', 'MP_Buis_M_LeftArm_000', 'MP_Buis_M_LeftArm_001', 'MP_Buis_M_RightArm_000', 'MP_Buis_M_RightArm_001',
        'MP_Buis_M_Stomach_000', 'MP_Buis_M_Chest_000', 'MP_Buis_M_Chest_001', 'MP_Buis_M_Back_000', 'MP_Buis_F_Chest_000', 'MP_Buis_F_Chest_001', 'MP_Buis_F_Chest_002', 'MP_Buis_F_Stom_000',
        'MP_Buis_F_Stom_001', 'MP_Buis_F_Stom_002', 'MP_Buis_F_Back_000', 'MP_Buis_F_Back_001', 'MP_Buis_F_Neck_000', 'MP_Buis_F_Neck_001', 'MP_Buis_F_RArm_000', 'MP_Buis_F_LArm_000',
        'MP_Buis_F_LLeg_000', 'MP_Buis_F_RLeg_000'
    },

	['mphipster_overlays'] = {
		'FM_Hip_M_Tat_000', 'FM_Hip_M_Tat_001', 'FM_Hip_M_Tat_002', 'FM_Hip_M_Tat_003', 'FM_Hip_M_Tat_004', 'FM_Hip_M_Tat_005', 'FM_Hip_M_Tat_006', 'FM_Hip_M_Tat_007', 'FM_Hip_M_Tat_008',
		'FM_Hip_M_Tat_009', 'FM_Hip_M_Tat_010', 'FM_Hip_M_Tat_011', 'FM_Hip_M_Tat_012', 'FM_Hip_M_Tat_013', 'FM_Hip_M_Tat_014', 'FM_Hip_M_Tat_015', 'FM_Hip_M_Tat_016', 'FM_Hip_M_Tat_017',
		'FM_Hip_M_Tat_018', 'FM_Hip_M_Tat_019', 'FM_Hip_M_Tat_020', 'FM_Hip_M_Tat_021', 'FM_Hip_M_Tat_022', 'FM_Hip_M_Tat_023', 'FM_Hip_M_Tat_024', 'FM_Hip_M_Tat_025', 'FM_Hip_M_Tat_026',
		'FM_Hip_M_Tat_027', 'FM_Hip_M_Tat_028', 'FM_Hip_M_Tat_029', 'FM_Hip_M_Tat_030', 'FM_Hip_M_Tat_031', 'FM_Hip_M_Tat_032', 'FM_Hip_M_Tat_033', 'FM_Hip_M_Tat_034', 'FM_Hip_M_Tat_035',
		'FM_Hip_M_Tat_036', 'FM_Hip_M_Tat_037', 'FM_Hip_M_Tat_038', 'FM_Hip_M_Tat_039', 'FM_Hip_M_Tat_040', 'FM_Hip_M_Tat_041', 'FM_Hip_M_Tat_042', 'FM_Hip_M_Tat_043', 'FM_Hip_M_Tat_044',
		'FM_Hip_M_Tat_045', 'FM_Hip_M_Tat_046', 'FM_Hip_M_Tat_047', 'FM_Hip_M_Tat_048'
    },

	['mpbiker_overlays'] = {
		'MP_MP_Biker_Tat_000_M', 'MP_MP_Biker_Tat_001_M', 'MP_MP_Biker_Tat_002_M', 'MP_MP_Biker_Tat_003_M', 'MP_MP_Biker_Tat_004_M', 'MP_MP_Biker_Tat_005_M', 'MP_MP_Biker_Tat_006_M',
		'MP_MP_Biker_Tat_007_M', 'MP_MP_Biker_Tat_008_M', 'MP_MP_Biker_Tat_009_M', 'MP_MP_Biker_Tat_010_M', 'MP_MP_Biker_Tat_011_M', 'MP_MP_Biker_Tat_012_M', 'MP_MP_Biker_Tat_013_M',
		'MP_MP_Biker_Tat_014_M', 'MP_MP_Biker_Tat_015_M', 'MP_MP_Biker_Tat_016_M', 'MP_MP_Biker_Tat_017_M', 'MP_MP_Biker_Tat_018_M', 'MP_MP_Biker_Tat_019_M', 'MP_MP_Biker_Tat_020_M',
		'MP_MP_Biker_Tat_021_M', 'MP_MP_Biker_Tat_022_M', 'MP_MP_Biker_Tat_023_M', 'MP_MP_Biker_Tat_024_M', 'MP_MP_Biker_Tat_025_M', 'MP_MP_Biker_Tat_026_M', 'MP_MP_Biker_Tat_027_M',
		'MP_MP_Biker_Tat_028_M', 'MP_MP_Biker_Tat_029_M', 'MP_MP_Biker_Tat_030_M', 'MP_MP_Biker_Tat_031_M', 'MP_MP_Biker_Tat_032_M', 'MP_MP_Biker_Tat_033_M', 'MP_MP_Biker_Tat_034_M',
		'MP_MP_Biker_Tat_035_M', 'MP_MP_Biker_Tat_036_M', 'MP_MP_Biker_Tat_037_M', 'MP_MP_Biker_Tat_038_M', 'MP_MP_Biker_Tat_039_M', 'MP_MP_Biker_Tat_040_M', 'MP_MP_Biker_Tat_041_M',
		'MP_MP_Biker_Tat_042_M', 'MP_MP_Biker_Tat_043_M', 'MP_MP_Biker_Tat_044_M', 'MP_MP_Biker_Tat_045_M', 'MP_MP_Biker_Tat_046_M', 'MP_MP_Biker_Tat_047_M', 'MP_MP_Biker_Tat_048_M',
		'MP_MP_Biker_Tat_049_M', 'MP_MP_Biker_Tat_050_M', 'MP_MP_Biker_Tat_051_M', 'MP_MP_Biker_Tat_052_M', 'MP_MP_Biker_Tat_053_M', 'MP_MP_Biker_Tat_054_M', 'MP_MP_Biker_Tat_055_M',
		'MP_MP_Biker_Tat_056_M', 'MP_MP_Biker_Tat_057_M', 'MP_MP_Biker_Tat_058_M', 'MP_MP_Biker_Tat_059_M', 'MP_MP_Biker_Tat_060_M'
    },

	['mpairraces_overlays'] = {
		'MP_Airraces_Tattoo_000_M', 'MP_Airraces_Tattoo_001_M', 'MP_Airraces_Tattoo_002_M', 'MP_Airraces_Tattoo_003_M', 'MP_Airraces_Tattoo_004_M', 'MP_Airraces_Tattoo_005_M',
		'MP_Airraces_Tattoo_006_M', 'MP_Airraces_Tattoo_007_M'
    },

	['mpbeach_overlays'] = {
		'MP_Bea_M_Back_000', 'MP_Bea_M_Chest_000', 'MP_Bea_M_Chest_001', 'MP_Bea_M_Head_000', 'MP_Bea_M_Head_001', 'MP_Bea_M_Head_002', 'MP_Bea_M_Lleg_000', 'MP_Bea_M_Rleg_000',
		'MP_Bea_M_RArm_000', 'MP_Bea_M_Head_000', 'MP_Bea_M_LArm_000', 'MP_Bea_M_LArm_001', 'MP_Bea_M_Neck_000', 'MP_Bea_M_Neck_001', 'MP_Bea_M_RArm_001', 'MP_Bea_M_Stom_000',
		'MP_Bea_M_Stom_001'
    },

	['mpchristmas2_overlays'] = {
		'MP_Xmas2_M_Tat_000', 'MP_Xmas2_M_Tat_001', 'MP_Xmas2_M_Tat_003', 'MP_Xmas2_M_Tat_004', 'MP_Xmas2_M_Tat_005', 'MP_Xmas2_M_Tat_006', 'MP_Xmas2_M_Tat_007', 'MP_Xmas2_M_Tat_008',
		'MP_Xmas2_M_Tat_009', 'MP_Xmas2_M_Tat_010', 'MP_Xmas2_M_Tat_011', 'MP_Xmas2_M_Tat_012', 'MP_Xmas2_M_Tat_013', 'MP_Xmas2_M_Tat_014', 'MP_Xmas2_M_Tat_015', 'MP_Xmas2_M_Tat_016',
		'MP_Xmas2_M_Tat_017', 'MP_Xmas2_M_Tat_018', 'MP_Xmas2_M_Tat_019', 'MP_Xmas2_M_Tat_022', 'MP_Xmas2_M_Tat_023', 'MP_Xmas2_M_Tat_024', 'MP_Xmas2_M_Tat_025', 'MP_Xmas2_M_Tat_026',
		'MP_Xmas2_M_Tat_027', 'MP_Xmas2_M_Tat_028', 'MP_Xmas2_M_Tat_029'
    },

	['mpgunrunning_overlays'] = {
		'MP_Gunrunning_Tattoo_000_M', 'MP_Gunrunning_Tattoo_001_M', 'MP_Gunrunning_Tattoo_002_M', 'MP_Gunrunning_Tattoo_003_M', 'MP_Gunrunning_Tattoo_004_M', 'MP_Gunrunning_Tattoo_005_M',
		'MP_Gunrunning_Tattoo_006_M', 'MP_Gunrunning_Tattoo_007_M', 'MP_Gunrunning_Tattoo_008_M', 'MP_Gunrunning_Tattoo_009_M', 'MP_Gunrunning_Tattoo_010_M', 'MP_Gunrunning_Tattoo_011_M',
		'MP_Gunrunning_Tattoo_012_M', 'MP_Gunrunning_Tattoo_013_M', 'MP_Gunrunning_Tattoo_014_M', 'MP_Gunrunning_Tattoo_015_M', 'MP_Gunrunning_Tattoo_016_M', 'MP_Gunrunning_Tattoo_017_M',
		'MP_Gunrunning_Tattoo_018_M', 'MP_Gunrunning_Tattoo_019_M', 'MP_Gunrunning_Tattoo_020_M', 'MP_Gunrunning_Tattoo_021_M', 'MP_Gunrunning_Tattoo_022_M', 'MP_Gunrunning_Tattoo_023_M',
		'MP_Gunrunning_Tattoo_024_M', 'MP_Gunrunning_Tattoo_025_M', 'MP_Gunrunning_Tattoo_026_M', 'MP_Gunrunning_Tattoo_027_M', 'MP_Gunrunning_Tattoo_028_M', 'MP_Gunrunning_Tattoo_029_M',
		'MP_Gunrunning_Tattoo_030_M'
    },

	['mpimportexport_overlays'] = {
		'MP_MP_ImportExport_Tat_000_M', 'MP_MP_ImportExport_Tat_001_M', 'MP_MP_ImportExport_Tat_002_M', 'MP_MP_ImportExport_Tat_003_M', 'MP_MP_ImportExport_Tat_004_M', 'MP_MP_ImportExport_Tat_005_M',
		'MP_MP_ImportExport_Tat_006_M', 'MP_MP_ImportExport_Tat_007_M', 'MP_MP_ImportExport_Tat_008_M', 'MP_MP_ImportExport_Tat_009_M', 'MP_MP_ImportExport_Tat_010_M', 'MP_MP_ImportExport_Tat_011_M'
    },

	['mplowrider2_overlays'] = {
		'MP_LR_Tat_000_M', 'MP_LR_Tat_003_M', 'MP_LR_Tat_006_M', 'MP_LR_Tat_008_M', 'MP_LR_Tat_011_M', 'MP_LR_Tat_012_M', 'MP_LR_Tat_016_M', 'MP_LR_Tat_018_M', 'MP_LR_Tat_019_M',
		'MP_LR_Tat_022_M', 'MP_LR_Tat_028_M', 'MP_LR_Tat_029_M', 'MP_LR_Tat_030_M', 'MP_LR_Tat_031_M', 'MP_LR_Tat_032_M', 'MP_LR_Tat_035_M'
    },

	['mplowrider_overlays'] = {
		'MP_LR_Tat_001_M', 'MP_LR_Tat_002_M', 'MP_LR_Tat_004_M', 'MP_LR_Tat_005_M', 'MP_LR_Tat_007_M', 'MP_LR_Tat_009_M', 'MP_LR_Tat_010_M', 'MP_LR_Tat_013_M', 'MP_LR_Tat_014_M',
		'MP_LR_Tat_015_M', 'MP_LR_Tat_017_M', 'MP_LR_Tat_020_M', 'MP_LR_Tat_021_M', 'MP_LR_Tat_023_M', 'MP_LR_Tat_026_M', 'MP_LR_Tat_027_M', 'MP_LR_Tat_033_M'
	}
}

local tattoosCategoriesList = {
    { 'ZONE_TORSO', 0 }, { 'ZONE_HEAD', 0 }, { 'ZONE_LEFT_ARM', 0 }, { 'ZONE_RIGHT_ARM', 0 }, { 'ZONE_LEFT_LEG', 0 }, { 'ZONE_RIGHT_LEG', 0 }, { 'ZONE_UNKNOWN', 0 }, { 'ZONE_NONE', 0 }
}

maleSkins = {
    'mp_m_freemode_01', 'player_one', 'player_two', 'player_zero', 'ig_trafficwarden', 'hc_driver', 'hc_gunman', 'hc_hacker', 'ig_paige', 'ig_abigail', 'ig_bankman', 'ig_barry',
    'ig_bestmen', 'ig_beverly', 'ig_brad', 'ig_bride', 'ig_car3guy1', 'ig_car3guy2', 'ig_casey', 'ig_chef', 'ig_chengsr', 'ig_chrisformage', 'ig_clay', 'ig_claypain', 'ig_cletus',
    'ig_dale', 'ig_davenorton', 'ig_denise', 'ig_devin', 'ig_dom', 'ig_dreyfuss', 'ig_drfriedlander', 'ig_fabien', 'ig_fbisuit_01', 'ig_floyd', 'ig_groom', 'ig_hao', 'ig_hunter',
    'csb_prolsec', 'ig_jay_norris', 'ig_jimmyboston', 'ig_jimmydisanto', 'ig_joeminuteman', 'ig_johnnyklebitz', 'ig_josef', 'ig_josh', 'ig_lamardavis', 'ig_lazlow', 'ig_lestercrest',
    'ig_lifeinvad_01', 'ig_lifeinvad_02', 'ig_manuel', 'ig_milton', 'ig_mrk', 'ig_nervousron', 'ig_nigel', 'ig_old_man1a', 'ig_old_man2', 'ig_oneil', 'ig_orleans', 'ig_ortega',
    'ig_paper', 'ig_priest', 'ig_prolsec_02', 'ig_ramp_gang', 'ig_ramp_hic', 'ig_ramp_hipster', 'ig_ramp_mex', 'ig_roccopelosi', 'ig_russiandrunk', 'ig_siemonyetarian', 'ig_solomon',
    'ig_stevehains', 'ig_stretch', 'ig_talina', 'ig_taocheng', 'ig_taostranslator', 'ig_tenniscoach', 'ig_terry', 'ig_tomepsilon', 'ig_tylerdix', 'ig_wade', 'ig_zimbor', 's_m_m_paramedic_01',
    'a_m_m_afriamer_01', 'a_m_m_beach_01', 'a_m_m_beach_02', 'a_m_m_bevhills_01', 'a_m_m_bevhills_02', 'a_m_m_business_01', 'a_m_m_eastsa_01', 'a_m_m_eastsa_02', 'a_m_m_farmer_01',
    'a_m_m_fatlatin_01', 'a_m_m_genfat_01', 'a_m_m_genfat_02', 'a_m_m_golfer_01', 'a_m_m_hasjew_01', 'a_m_m_hillbilly_01', 'a_m_m_hillbilly_02', 'a_m_m_indian_01', 'a_m_m_ktown_01',
    'a_m_m_malibu_01', 'a_m_m_mexcntry_01', 'a_m_m_mexlabor_01', 'a_m_m_og_boss_01', 'a_m_m_paparazzi_01', 'a_m_m_polynesian_01', 'a_m_m_prolhost_01', 'a_m_m_rurmeth_01', 'a_m_m_salton_01',
    'a_m_m_salton_02', 'a_m_m_salton_03', 'a_m_m_salton_04', 'a_m_m_skater_01', 'a_m_m_skidrow_01', 'a_m_m_socenlat_01', 'a_m_m_soucent_01', 'a_m_m_soucent_02', 'a_m_m_soucent_03',
    'a_m_m_soucent_04', 'a_m_m_stlat_02', 'a_m_m_tennis_01', 'a_m_m_tourist_01', 'a_m_m_trampbeac_01', 'a_m_m_tramp_01', 'a_m_m_tranvest_01', 'a_m_m_tranvest_02', 'a_m_o_beach_01',
    'a_m_o_genstreet_01', 'a_m_o_ktown_01', 'a_m_o_salton_01', 'a_m_o_soucent_01', 'a_m_o_soucent_02', 'a_m_o_soucent_03', 'a_m_o_tramp_01', 'a_m_y_beachvesp_01', 'a_m_y_beachvesp_02',
    'a_m_y_beach_01', 'a_m_y_beach_02', 'a_m_y_beach_03', 'a_m_y_bevhills_01', 'a_m_y_bevhills_02', 'a_m_y_breakdance_01', 'a_m_y_busicas_01', 'a_m_y_business_01', 'a_m_y_business_02',
    'a_m_y_business_03', 'a_m_y_cyclist_01', 'a_m_y_dhill_01', 'a_m_y_downtown_01', 'a_m_y_eastsa_01', 'a_m_y_eastsa_02', 'a_m_y_epsilon_01', 'a_m_y_epsilon_02', 'a_m_y_gay_01',
    'a_m_y_gay_02', 'a_m_y_genstreet_01', 'a_m_y_genstreet_02', 'a_m_y_golfer_01', 'a_m_y_hasjew_01', 'a_m_y_hiker_01', 'a_m_y_hipster_01', 'a_m_y_hipster_02', 'a_m_y_hipster_03',
    'a_m_y_indian_01', 'a_m_y_jetski_01', 'a_m_y_juggalo_01', 'a_m_y_ktown_01', 'a_m_y_ktown_02', 'a_m_y_latino_01', 'a_m_y_methhead_01', 'a_m_y_mexthug_01', 'a_m_y_motox_01',
    'a_m_y_motox_02', 'a_m_y_musclbeac_01', 'a_m_y_musclbeac_02', 'a_m_y_polynesian_01', 'a_m_y_roadcyc_01', 'a_m_y_runner_01', 'a_m_y_runner_02', 'a_m_y_salton_01', 'a_m_y_skater_01',
    'a_m_y_skater_02', 'a_m_y_soucent_01', 'a_m_y_soucent_02', 'a_m_y_soucent_03', 'a_m_y_soucent_04', 'a_m_y_stbla_01', 'a_m_y_stbla_02', 'a_m_y_stlat_01', 'a_m_y_stwhi_01',
    'a_m_y_stwhi_02', 'a_m_y_sunbathe_01', 'a_m_y_surfer_01', 'a_m_y_vindouche_01', 'a_m_y_vinewood_01', 'a_m_y_vinewood_02', 'a_m_y_vinewood_03', 'a_m_y_vinewood_04', 'a_m_y_yoga_01',
    'g_m_m_armboss_01', 'g_m_m_armgoon_01', 'g_m_m_armlieut_01', 'g_m_m_chemwork_01', 'g_m_m_chiboss_01', 'g_m_m_chicold_01', 'g_m_m_chigoon_01', 'g_m_m_chigoon_02', 'g_m_m_korboss_01',
    'g_m_m_mexboss_01', 'g_m_m_mexboss_02', 'g_m_y_armgoon_02', 'g_m_y_azteca_01', 'g_m_y_ballaeast_01', 'g_m_y_ballaorig_01', 'g_m_y_ballasout_01', 'g_m_y_famca_01', 'g_m_y_famdnf_01',
    'g_m_y_famfor_01', 'g_m_y_korean_01', 'g_m_y_korean_02', 'g_m_y_korlieut_01', 'g_m_y_lost_01', 'g_m_y_lost_02', 'g_m_y_lost_03', 'g_m_y_mexgang_01', 'g_m_y_mexgoon_01',
    'g_m_y_mexgoon_02', 'g_m_y_mexgoon_03', 'g_m_y_pologoon_01', 'g_m_y_pologoon_02', 'g_m_y_salvaboss_01', 'g_m_y_salvagoon_01', 'g_m_y_salvagoon_02', 'g_m_y_salvagoon_03',
    'g_m_y_strpunk_01', 'g_m_y_strpunk_02', 'mp_m_claude_01', 'mp_m_exarmy_01', 'mp_m_shopkeep_01', 's_m_m_ammucountry', 's_m_m_autoshop_01', 's_m_m_autoshop_02', 's_m_m_bouncer_01',
    's_m_m_chemsec_01', 's_m_m_cntrybar_01', 's_m_m_dockwork_01', 's_m_m_doctor_01', 's_m_m_fiboffice_01', 's_m_m_fiboffice_02', 's_m_m_gaffer_01', 's_m_m_gardener_01', 's_m_m_gentransport',
    's_m_m_hairdress_01', 's_m_m_highsec_01', 's_m_m_highsec_02', 's_m_m_janitor', 's_m_m_lathandy_01', 's_m_m_lifeinvad_01', 's_m_m_linecook', 's_m_m_lsmetro_01', 's_m_m_mariachi_01',
    's_m_m_marine_01', 's_m_m_marine_02', 's_m_m_migrant_01', 's_m_m_movalien_01', 's_m_m_movprem_01', 's_m_m_movspace_01', 's_m_m_pilot_01', 's_m_m_pilot_02', 's_m_m_postal_01',
    's_m_m_postal_02', 's_m_m_scientist_01', 's_m_m_security_01', 's_m_m_strperf_01', 's_m_m_strpreach_01', 's_m_m_strvend_01', 's_m_m_trucker_01', 's_m_m_ups_01', 's_m_m_ups_02',
    's_m_o_busker_01', 's_m_y_airworker', 's_m_y_ammucity_01', 's_m_y_armymech_01', 's_m_y_autopsy_01', 's_m_y_barman_01', 's_m_y_baywatch_01', 's_m_y_blackops_01', 's_m_y_blackops_02',
    's_m_y_busboy_01', 's_m_y_chef_01', 's_m_y_clown_01', 's_m_y_construct_01', 's_m_y_construct_02', 's_m_y_cop_01', 's_m_y_dealer_01', 's_m_y_devinsec_01', 's_m_y_dockwork_01',
    's_m_y_doorman_01', 's_m_y_dwservice_01', 's_m_y_dwservice_02', 's_m_y_factory_01', 's_m_y_garbage', 's_m_y_grip_01', 's_m_y_marine_01', 's_m_y_marine_02', 's_m_y_marine_03',
    's_m_y_mime', 's_m_y_pestcont_01', 's_m_y_pilot_01', 's_m_y_prismuscl_01', 's_m_y_prisoner_01', 's_m_y_robber_01', 's_m_y_shop_mask', 's_m_y_strvend_01', 's_m_y_uscg_01',
    's_m_y_valet_01', 's_m_y_waiter_01', 's_m_y_winclean_01', 's_m_y_xmech_01', 's_m_y_xmech_02', 'u_m_m_aldinapoli', 'u_m_m_bankman', 'u_m_m_bikehire_01', 'u_m_m_fibarchitect',
    'u_m_m_filmdirector', 'u_m_m_glenstank_01', 'u_m_m_griff_01', 'u_m_m_jesus_01', 'u_m_m_jewelsec_01', 'u_m_m_jewelthief', 'u_m_m_markfost', 'u_m_m_partytarget', 'u_m_m_prolsec_01',
    'u_m_m_promourn_01', 'u_m_m_rivalpap', 'u_m_m_spyactor', 'u_m_m_willyfist', 'u_m_o_finguru_01', 'u_m_o_taphillbilly', 'u_m_o_tramp_01', 'u_m_y_abner', 'u_m_y_antonb', 'u_m_y_babyd',
    'u_m_y_baygor', 'u_m_y_burgerdrug_01', 'u_m_y_chip', 'u_m_y_cyclist_01', 'u_m_y_fibmugger_01', 'u_m_y_guido_01', 'u_m_y_gunvend_01', 'u_m_y_imporage', 'u_m_y_mani', 'u_m_y_militarybum',
    'u_m_y_paparazzi', 'u_m_y_party_01', 'u_m_y_pogo_01', 'u_m_y_prisoner_01', 'u_m_y_proldriver_01', 'u_m_y_rsranger_01', 'u_m_y_sbike', 'u_m_y_staggrm_01', 'u_m_y_tattoo_01', 'u_m_y_zombie_01',
    'u_m_y_hippie_01', 'a_m_y_hippy_01', 'a_m_y_stbla_m', 'ig_terry_m', 'a_m_m_ktown_m', 'a_m_y_skater_m', 'u_m_y_coop', 'ig_car3guy1_m', 'tony', 'g_m_m_chigoon_02_m', 'g_m_y_famfor_01_m',
    'ig_trafficwarden_m', 'g_m_m_chiboss_01_m'
}

femaleSkins = {
    'mp_f_freemode_01', 'a_f_m_beach_01', 'a_f_m_bevhills_01', 'a_f_m_bevhills_02', 'a_f_m_bodybuild_01', 'a_f_m_business_02', 'a_f_m_downtown_01', 'a_f_m_eastsa_01', 'a_f_m_eastsa_02',
    'a_f_m_fatbla_01', 'a_f_m_fatcult_01', 'a_f_m_fatwhite_01', 'a_f_m_ktown_01', 'a_f_m_ktown_02', 'a_f_m_prolhost_01', 'a_f_m_salton_01', 'a_f_m_skidrow_01', 'a_f_m_soucentmc_01',
    'a_f_m_soucent_01', 'a_f_m_soucent_02', 'a_f_m_tourist_01', 'a_f_m_trampbeac_01', 'a_f_m_tramp_01', 'a_f_o_genstreet_01', 'a_f_o_indian_01', 'a_f_o_ktown_01', 'a_f_o_salton_01',
    'a_f_o_soucent_01', 'a_f_o_soucent_02', 'a_f_y_beach_01', 'a_f_y_bevhills_01', 'a_f_y_bevhills_02', 'a_f_y_bevhills_03', 'a_f_y_bevhills_04', 'a_f_y_business_01', 'a_f_y_business_02',
    'a_f_y_business_03', 'a_f_y_business_04', 'a_f_y_eastsa_01', 'a_f_y_eastsa_02', 'a_f_y_eastsa_03', 'a_f_y_epsilon_01', 'a_f_y_fitness_01', 'a_f_y_fitness_02', 'a_f_y_genhot_01',
    'a_f_y_golfer_01', 'a_f_y_hiker_01', 'a_f_y_hipster_01', 'a_f_y_hipster_02', 'a_f_y_hipster_03', 'a_f_y_hipster_04', 'a_f_y_indian_01', 'a_f_y_juggalo_01', 'a_f_y_runner_01',
    'a_f_y_rurmeth_01', 'a_f_y_scdressy_01', 'a_f_y_skater_01', 'a_f_y_soucent_01', 'a_f_y_soucent_02', 'a_f_y_soucent_03', 'a_f_y_tennis_01', 'a_f_y_tourist_01', 'a_f_y_tourist_02',
    'a_f_y_vinewood_01', 'a_f_y_vinewood_02', 'a_f_y_vinewood_03', 'a_f_y_vinewood_04', 'a_f_y_yoga_01', 'g_f_y_ballas_01', 'g_f_y_families_01', 'g_f_y_lost_01', 'g_f_y_vagos_01',
    'mp_f_deadhooker', 'mp_f_misty_01', 'mp_f_stripperlite', 'mp_s_m_armoured_01', 's_f_m_fembarber', 's_f_m_maid_01', 's_f_m_shop_high', 's_f_m_sweatshop_01', 's_f_y_airhostess_01',
    's_f_y_bartender_01', 's_f_y_baywatch_01', 's_f_y_cop_01', 's_f_y_factory_01', 's_f_y_hooker_01', 's_f_y_hooker_02', 's_f_y_hooker_03', 's_f_y_migrant_01', 's_f_y_movprem_01',
    'ig_kerrymcintosh', 'ig_janet', 'ig_jewelass', 'ig_magenta', 'ig_marnie', 'ig_patricia', 'ig_screen_writer', 'ig_tanisha', 'ig_tonya', 'ig_tracydisanto', 'u_f_m_corpse_01',
    'u_f_m_miranda', 'u_f_m_promourn_01', 'u_f_o_moviestar', 'u_f_o_prolhost_01', 'u_f_y_bikerchic', 'u_f_y_comjane', 'u_f_y_corpse_01', 'u_f_y_corpse_02', 'u_f_y_hotposh_01',
    'u_f_y_jewelass_01', 'u_f_y_mistress', 'u_f_y_poppymich', 'u_f_y_princess', 'u_f_y_spyactress', 'ig_amandatownley', 'ig_ashley', 'ig_andreas', 'ig_ballasog', 'ig_maryannn',
    'ig_maude', 'ig_michelle', 'ig_mrs_thornhill', 'ig_natalia', 's_f_y_scrubs_01', 's_f_y_sheriff_01', 's_f_y_shop_low', 's_f_y_shop_mid', 's_f_y_stripperlite', 's_f_y_stripper_01',
    's_f_y_stripper_02', 'ig_mrsphillips', 'ig_mrs_thornhill', 'ig_molly', 'ig_natalia', 's_f_y_sweatshop_01', 'ig_paige', 'a_f_y_femaleagent', 'a_f_y_hippie_01'
}

function IsSkinEnabled(skinName)
    for k, v in pairs(maleSkins) do
        if skinName == v then
            return true
        end
    end

    for k, v in pairs(femaleSkins) do
        if skinName == v then
            return true
        end
    end

    return false
end

function ReplaceTattoosList()
    local tattoos = {}

    for k, v in pairs(tattoosList) do
        for i = 1, #tattoosList[k] do
            if tattoos[k] == nil then
                tattoos[k] = {}
            end

            tattoos[k][i] = {
                tattoosList[k][i],
                tattoosCategoriesList[GetPedDecorationZoneFromHashes(k, GetHashKey(tattoosList[k][i])) + 1][1]
            }
        end
    end

    tattoosList = tattoos
end

function GetTemporaryTattoosList()
    local temporaryTattoosHashList = {}

    for k in pairs(tattoosList) do
        for i = 1, #tattoosList[k] do
            local category = tattoosList[k][i][2]

            if temporaryTattoosHashList[category] == nil then
                temporaryTattoosHashList[category] = {}
            end

            table.insert(temporaryTattoosHashList[category], { GetHashKey(tattoosList[k][i][1]), GetHashKey(k)})
        end
    end
    return temporaryTattoosHashList
end

function GetTattoosCategories()
    for k in pairs(tattoosList) do
        for i = 1, #tattoosList[k] do
            local zone = GetPedDecorationZoneFromHashes(k, GetHashKey(tattoosList[k][i][1]))

            tattoosCategoriesList[zone + 1] = { tattoosCategoriesList[zone + 1][1], tattoosCategoriesList[zone + 1][2] + 1 }
        end
    end

    return tattoosCategoriesList
end

function GetPedHair()
    local hairColor = {}

    hairColor[1] = GetPedHairColor(playerPed)
    hairColor[2] = GetPedHairHighlightColor(playerPed)

    return hairColor
end

function GetDrawablesTotal()
    local drawables = {}

    for i = 0, #drawableNames - 1 do
        drawables[i] = { drawableNames[i+1], GetNumberOfPedDrawableVariations(playerPed, i) }
    end

    return drawables
end

function GetPropDrawablesTotal()
    local props = {}

    for i = 0, #propNames - 1 do
        props[i] = { propNames[i+1], GetNumberOfPedPropDrawableVariations(playerPed, i) }
    end

    return props
end

function GetTextureTotals()
    local values, draw, props = {}, GetDrawables(), GetProps()

    for i = 0, #draw - 1 do
        local name, value = draw[i][1], draw[i][2]

        values[name] = GetNumberOfPedTextureVariations(playerPed, i, value)
    end

    for i = 0, #props - 1 do
        local name, value = props[i][1], props[i][2]

        values[name] = GetNumberOfPedPropTextureVariations(playerPed, i, value)
    end

    return values
end

function GetHeadOverlayTotals()
    local totals = {}

    for i = 1, #headOverlays do
        totals[headOverlays[i]] = GetNumHeadOverlayValues(i - 1)
    end

    return totals
end

function GetSkinTotal()
	return { #maleSkins, #femaleSkins }
end

function GetPedHeadBlendData()
    local blob = string.rep("\0\0\0\0\0\0\0\0", 6 + 3 + 1)

    if not Citizen.InvokeNative(0x2746BD9D88C5C5D0, playerPed, blob, true) then
        return nil
    end

    return {
        shapeFirst = string.unpack("<i4", blob, 1),
        shapeSecond = string.unpack("<i4", blob, 9),
        shapeThird = string.unpack("<i4", blob, 17),
        skinFirst = string.unpack("<i4", blob, 25),
        skinSecond = string.unpack("<i4", blob, 33),
        skinThird = string.unpack("<i4", blob, 41),
        shapeMix = string.unpack("<f", blob, 49),
        skinMix = string.unpack("<f", blob, 57),
        thirdMix = string.unpack("<f", blob, 65),
        hasParent = string.unpack("b", blob, 73) ~= 0,
    }
end

function GetHeadOverlayData()
    local headData = {}

    for i = 1, #headOverlays do
        local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(playerPed, i - 1)

        if success then
            headData[i] = {}
            headData[i].name, headData[i].overlayValue = headOverlays[i], overlayValue
            headData[i].colourType, headData[i].firstColour = colourType, firstColour
            headData[i].secondColour, headData[i].overlayOpacity = secondColour, overlayOpacity
        end
    end
    return headData
end

function SetHeadOverlayData(data)
    if json.encode(data) ~= "[]" then
        for i = 1, #headOverlays do
            SetPedHeadOverlay(playerPed,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
        end

        SetPedHeadOverlayColor(playerPed, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(playerPed, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(playerPed, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(playerPed, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(playerPed, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(playerPed, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(playerPed, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(playerPed, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(playerPed, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))

        SetPedHeadOverlayColor(playerPed, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(playerPed, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(playerPed, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

function GetHeadStructureData()
    local structure = {}

    for i = 1, #faceFeatures do
        structure[faceFeatures[i]] = GetPedFaceFeature(playerPed, i - 1)
    end

    return structure
end

function SetHeadStructure(data)
    for i = 1, #faceFeatures do
        SetPedFaceFeature(playerPed, i - 1, data[i])
    end
end

function GetDrawables()
    local drawables, model, isMpModel = {}, GetEntityModel(PlayerPedId()), false

    if (model == `mp_f_freemode_01` or model == `mp_m_freemode_01`) then
        isMpModel = true
    end

    for i = 0, #drawableNames - 1 do
        if isMpModel and drawableNames[i+1] == 'undershirts' and GetPedDrawableVariation(playerPed, i) == -1 then
            SetPedComponentVariation(playerPed, i, 15, 0, 2)
        end

        drawables[i] = { drawableNames[i+1], GetPedDrawableVariation(playerPed, i) }
    end
    return drawables
end

function GetProps()
    local props = {}

    for i = 0, #propNames-1 do
        props[i] = { propNames[i+1], GetPedPropIndex(playerPed, i) }
    end

    return props
end

function GetDrawTextures()
    local textures = {}

    for i = 0, #drawableNames - 1 do
        table.insert(textures, { drawableNames[i+1], GetPedTextureVariation(playerPed, i) })
    end

    return textures
end

function GetPropTextures()
    local textures = {}

    for i = 0, #propNames - 1 do
        table.insert(textures, { propNames[i + 1], GetPedPropTextureIndex(playerPed, i) })
    end

    return textures
end

function GetSkin()
    for i = 1, #maleSkins do
        if (GetHashKey(maleSkins[i]) == GetEntityModel(PlayerPedId())) then
            return { name = 'skin_male', value = i }
        end
    end

    for i = 1, #femaleSkins do
        if (GetHashKey(femaleSkins[i]) == GetEntityModel(PlayerPedId())) then
            return { name = 'skin_female', value = i }
        end
    end
    return false
end

function GetTattoos()
    local tattoos = {}

    if currentTattoos == nil then
        return {}
    end

    for i = 1, #currentTattoos do
        for k, v in pairs(tattoosHashList) do
            for x = 1, #tattoosHashList[k] do
                if tattoosHashList[k][x][1] == currentTattoos[i][2] then
                    tattoos[k] = x
                end
            end
        end
    end
    return tattoos
end

function SetTattoos(data)
    currentTattoos = {}

    for k, v in pairs(data) do
        for category in pairs(tattoosHashList) do
            if k == category then
                local _data = tattoosHashList[category][tonumber(v)]

                if _data ~= nil then
                    table.insert(currentTattoos, { _data[2], _data[1] })
                end
            end
        end
    end

    ClearPedDecorations(PlayerPedId())

    for i = 1, #currentTattoos do
        ApplyPedOverlay(PlayerPedId(), currentTattoos[i][1], currentTattoos[i][2])
    end
end

function RotateEntity(direction)
    local pedRot = GetEntityHeading(PlayerPedId()) + direction

    SetEntityHeading(PlayerPedId(), pedRot % 360)
end

function LoadSkin(data)
    SetSkin(data.model, true)
    SetClothing(data.drawables, data.props, data.drawTextures, data.propTextures)

    Citizen.Wait(500)

    SetPedHairColor(playerPed, tonumber(data.hairColor[1]), tonumber(data.hairColor[2]))

    if (data.model == `mp_f_freemode_01` or data.model == `mp_m_freemode_01`) then
        SetPedHeadBlend(data.headBlend)
    end

    SetHeadStructure(data.headStructure)
    SetHeadOverlayData(data.headOverlay)
    return
end

function SetSkin(model, setDefault)
    SetEntityInvincible(PlayerPedId(), true)

    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)

        while (not HasModelLoaded(model)) do
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)

        playerPed = GetPlayerPed(-1)

        FreezePedCameraRotation(playerPed, true)

        if setDefault and model ~= nil then
            if (model ~= `mp_f_freemode_01` and model ~= `mp_m_freemode_01`) then
                SetPedRandomComponentVariation(playerPed, true)
            else
                SetPedHeadBlendData(playerPed, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)

                SetPedComponentVariation(playerPed, 11, 0, 11, 0)
                SetPedComponentVariation(playerPed, 8, 0, 1, 0)
                SetPedComponentVariation(playerPed, 6, 1, 2, 0)

                SetPedHeadOverlayColor(playerPed, 1, 1, 0, 0)
                SetPedHeadOverlayColor(playerPed, 2, 1, 0, 0)
                SetPedHeadOverlayColor(playerPed, 4, 2, 0, 0)
                SetPedHeadOverlayColor(playerPed, 5, 2, 0, 0)
                SetPedHeadOverlayColor(playerPed, 8, 2, 0, 0)
                SetPedHeadOverlayColor(playerPed, 10, 1, 0, 0)

                SetPedHeadOverlay(playerPed, 1, 0, 0.0)
                SetPedHairColor(playerPed, 1, 1)
            end
        end
    end

    SetEntityInvincible(PlayerPedId(), false)
end

function SetClothing(drawables, props, drawTextures, propTextures)
    for i = 1, #drawableNames do
        if drawables[0] == nil then
            if drawableNames[i] == 'undershirts' and drawables[tostring(i - 1)][2] == -1 then
                SetPedComponentVariation(playerPed, i - 1, 15, 0, 2)
            else
                SetPedComponentVariation(playerPed, i - 1, drawables[tostring(i - 1)][2], drawTextures[i][2], 2)
            end
        else
            if drawableNames[i] == 'undershirts' and drawables[i - 1][2] == -1 then
                SetPedComponentVariation(playerPed, i - 1, 15, 0, 2)
            else
                SetPedComponentVariation(playerPed, i - 1, drawables[i - 1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #propNames do
        local propZ = (drawables[0] == nil and props[tostring(i - 1)][2] or props[i - 1][2])

        ClearPedProp(playerPed, i - 1)
        SetPedPropIndex(playerPed, i - 1, propZ, propTextures[i][2], true)
    end
end

function SetPedHeadBlend(data)
    SetPedHeadBlendData(playerPed, tonumber(data.shapeFirst), tonumber(data.shapeSecond), tonumber(data.shapeThird), tonumber(data.skinFirst),
    tonumber(data.skinSecond), tonumber(data.skinThird), tonumber(data.shapeMix), tonumber(data.skinMix), tonumber(data.thirdMix), false)
end

function hasValue(table, value)
    for i = 1, #table do
        if table[i] == value then
            return i - 1
        end
    end
    return -1
end

function ToggleMenu(status, menu)
    local isInService = false

    if status then
        isInService = exports['crp-userinfo']:isPed('isWhitelisted')
    end

    SetNuiFocus(status, status)

    isMenuOpen = status

    SendNUIMessage({
        eventName = 'enableClothesMenu',
        status = status,
        menuName = menu,
        isInService = isInService,
    })

    if not status then
        TriggerServerEvent('crp-skincreator:payClothes')

        for k, v in pairs(toggleClothes) do
            selectedValue = hasValue(drawableNames, k)

            if (selectedValue > -1) then
                SetPedComponentVariation(playerPed, tonumber(selectedValue), tonumber(toggleClothes[k][1]), tonumber(toggleClothes[k][2]), 2)

                toggleClothes[k] = nil
            else
                selectedValue = hasValue(propNames, k)

                if (selectedValue > -1) then
                    SetPedPropIndex(playerPed, tonumber(selectedValue), tonumber(toggleClothes[k][1]), tonumber(toggleClothes[k][2]), true)
                    toggleClothes[k] = nil
                end
            end
        end

        oldSkin = {}
    end
end

function SaveSkin(data)
    if data then
        currentPed = GetCurrentPed()

        if currentPed.model == `mp_f_freemode_01` or currentPed.model == `mp_m_freemode_01` then
            -- SAVE ON THE DATABASE
        end
        TriggerServerEvent('crp-skincreator:saveSkin', json.encode(currentPed))
    else
        LoadSkin(oldSkin)
    end

    TriggerCustomCamera('torso')
end

function TriggerCustomCamera(position)
    if isCamActive or position == 'torso' then
        FreezePedCameraRotation(playerPed, false)

        SetCamActive(cam, false)
        RenderScriptCams(false,  false,  0,  true,  true)

        if DoesCamExist(cam) then
            DestroyCam(cam, false)
        end

        isCamActive = false
    else
        if DoesCamExist(cam) then
            DestroyCam(cam, false)
        end

        SetEntityRotation(playerPed, 0.0, 0.0, 0.0, 1, true)
        FreezePedCameraRotation(playerPed, true)

        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

        SetCamCoord(cam, playerPed)
        SetCamRot(cam, 0.0, 0.0, 0.0)

        SetCamActive(cam, true)
        RenderScriptCams(true,  false,  0,  true,  true)

        if position == 'cam' then
            local pedRotation = GetEntityHeading(PlayerPedId()) + 90 % 360

            SetEntityHeading(PlayerPedId(), math.floor(pedRotation / 90) * 90.0)
            return
        end

        local bonePosition

        if position == 'head' then
            bonePosition = GetPedBoneCoords(playerPed, 31086)
            bonePosition = vector3(bonePosition.x - 0.1, bonePosition.y + 0.4, bonePosition.z + 0.05)
        elseif position == 'torso' then
            bonePosition = GetPedBoneCoords(playerPed, 11816)
            bonePosition = vector3(bonePosition.x - 0.4, bonePosition.y + 2.2, bonePosition.z + 0.2)
        elseif position == 'leg' then
            bonePosition = GetPedBoneCoords(playerPed, 46078)
            bonePosition = vector3(bonePosition.x - 0.1, bonePosition.y + 1, bonePosition.z)
        end

        SetCamCoord(cam, bonePosition.x, bonePosition.y, bonePosition.z)
        SetCamRot(cam, 0.0, 0.0, 180.0)

        isCamActive = true
    end
end

function ToggleProps(name)
    selectedValue = hasValue(drawableNames, name)

    if (selectedValue > -1) then
        if (toggleClothes[name] ~= nil) then
            SetPedComponentVariation(playerPed, tonumber(selectedValue), tonumber(toggleClothes[name][1]), tonumber(toggleClothes[name][2]), 2)

            toggleClothes[name] = nil
        else
            toggleClothes[name] = { GetPedDrawableVariation(playerPed, tonumber(selectedValue)), GetPedTextureVariation(playerPed, tonumber(selectedValue)) }

            local value = -1

            if (name == 'undershirts' or name == 'torsos') and (not name == 'undershirts' and not GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01')) then
                value = 15
            end

            if name == 'legs' then
                value = 14
            end

            SetPedComponentVariation(playerPed, tonumber(selectedValue), value, 0, 2)
        end
    else
        selectedValue = hasValue(propNames, name)

        if (selectedValue > -1) then
            if (toggleClothes[name] ~= nil) then
                SetPedPropIndex(playerPed, tonumber(selectedValue), tonumber(toggleClothes[name][1]), tonumber(toggleClothes[name][2]), true)

                toggleClothes[name] = nil
            else
                toggleClothes[name] = { GetPedPropIndex(playerPed, tonumber(selectedValue)), GetPedPropTextureIndex(playerPed, tonumber(selectedValue)) }

                ClearPedProp(playerPed, tonumber(selectedValue))
            end
        end
    end
end

function GetCurrentPed()
    playerPed = GetPlayerPed(-1)

    return {
        model = GetEntityModel(PlayerPedId()),
        hairColor = GetPedHair(),
        headBlend = GetPedHeadBlendData(),
        headOverlay = GetHeadOverlayData(),
        headStructure = GetHeadStructureData(),
        drawables = GetDrawables(),
        props = GetProps(),
        drawTextures = GetDrawTextures(),
        propTextures = GetPropTextures(),
    }
end

ReplaceTattoosList()