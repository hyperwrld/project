itemsList = {
    -- ITEMS (ARMAS)

    ['1737195953']  = { name = 'Cacetete', weight = 1.5, image = 'crp-cacetete.png', canStack = false, isWeapon = true, description = 'Cacetete com apróximadamente 50cm, fabricado em aço e super resistente.' },
    ['911657153']   = { name = 'Taser', weight = 1.5, image = 'crp-stungun.png', canStack = false, isWeapon = true, description = 'Uma arma de eletrochoque é um dispositivo não-letal capaz de emitir uma descarga elétrica de alta tensão e baixa corrente com o objetivo de provocar dor e afastar um agressor.' },
    ['453432689']   = { name = 'Pistola', weight = 10, image = 'crp-pistol.png', canStack = false, isWeapon = true, description = 'Arma de fogo de cano curto usada para uso pessoal em ações de pequeno alcance.' },
    ['-1076751822'] = { name = 'Pistola SNS', weight = 10, image = 'crp-snspistol.png', canStack = false, isWeapon = true, description = 'SNS é uma sigla para "Saturday Night Special", uma gíria inglesa para armas de fogo pequenas e baratas.' },
    ['137902532']   = { name = 'Pistola Vintage', weight = 10, image = 'crp-vintagepistol.png', canStack = false, isWeapon = true, description = 'Arma de fogo com cano cumprido, tem uma ótima precisão mas tem uma velocidade de fogo lenta devido ao seu recoil.' },
    ['-771403250']  = { name = 'Pistola Pesada', weight = 10, image = 'crp-heavypistol.png', canStack = false, isWeapon = true, description = 'Uma arma de fogo .50 apresenta grande semelhança com uma desert eagle e tem um poder imenso.' },
    ['1593441988']  = { name = 'Pistola de Combate', weight = 10, image = 'crp-combatpistol.png', canStack = false, isWeapon = true, description = 'É uma arma fogo poderosa, matando alvos com cerca de 2 tiros e se tornando muito eficaz.' },
    ['-619010992']  = { name = 'Pistola-Metralhadora', weight = 10, image = 'crp-machinepistol.png', canStack = false, isWeapon = true, description = 'Pistola automática tem uma incrível velocidade de fogo, mas não tem uma boa precisão.' },
    ['-1121678507'] = { name = 'Mini Submetralhadora', weight = 15, image = 'crp-minismg.png', canStack = false, isWeapon = true, description = 'Uma pequena sub-metralhadora com uma semelhança da pistola-metraladora mas com uma rapidez de fogo maior.' },
    ['324215364']   = { name = 'Micro Submetralhadora', weight = 15, image = 'crp-microsmg.png', canStack = false, isWeapon = true, description = 'Uma das sub-metralhadoras mais poderosas do mundo.' },
    ['736523883']   = { name = 'Submetralhadora', weight = 15, image = 'crp-smg.png', canStack = false, isWeapon = true, description = 'É uma sub-metralhadora relativamente maior e com mais poder de fogo do que as outras.' },
    ['1649403952']  = { name = 'Rifle Compacto', weight = 20, image = 'crp-compactrifle.png', canStack = false, isWeapon = true, description = 'Um rifle pequeno de cano curto, mas forte, que causa mais dano que o rifle de assalto original em troca de mais recoil.' },
    ['-1074790547'] = { name = 'Rifle de Assalto', weight = 20, image = 'crp-assaultrifle.png', canStack = false, isWeapon = true, description = 'Rifle de assalto com grande capacidade de precisão à longa distância.' },
    ['-2084633992'] = { name = 'Carabina', weight = 20, image = 'crp-carbinerifle.png', canStack = false, isWeapon = true, description = 'A carabina mais leve que a rifle de assalto e com mais precisa, esta arma normalmente é utilizada pela polícia.' },

    -- ITEMS (NORMAIS)

    ['156805094']   = { name = 'Colete', weight = 14, image = 'crp-colete.png', canStack = true, isWeapon = false, description = 'É um artefato militar ou policial e que tem como objetivo proteger os utilizadores contra projéteis ou destroços.' },
    ['130895348']   = { name = 'Ligadura', weight = 0.75, image = 'crp-ligadura.png', canStack = true, isWeapon = false, description = 'Uma faixa de tecido que recobre uma ferida, geralmente para fixar curativos.' },
    ['196068078']   = { name = 'Coca-Cola', weight = 0.75, image = 'crp-coca.png', canStack = true, isWeapon = false, description = 'Coca-Cola é um refrigerante que muda o sabor da tua vida.' },
    ['129942349']   = { name = 'Batatas', weight = 0.75, image = 'crp-batatas.png', canStack = true, isWeapon = false, description = 'Batatas fritas são comumente servidas como petisco ou acompanhamento.' },
    ['119399505']   = { name = 'Gazua', weight = 3, image = 'crp-lockpick.png', canStack = true, isWeapon = false, description = 'Ferramenta utilizada para forçar a abertura de fechaduras.' },
}

vehicleWeights = {
    ['stockade'] = 350, ['stockade3'] = 350, ['pounder2'] = 750, ['pounder'] = 750, ['mule4'] = 500, ['mule3'] = 500, ['mule2'] = 500, ['mule'] = 500, ['benson'] = 650, -- Comercial
    ['rhapsody'] = 150, ['prairie'] = 150, ['panto'] = 100, ['issi3'] = 100, ['issi2'] = 110, ['dilettante2'] = 150, ['dilettante'] = 150, ['brioso'] = 100, ['kanjo'] = 150, ['blista'] = 150, ['asbo'] = 150, -- Compacts
    ['2020explorer'] = 230, ['2016explorer'] = 230, ['camaroRB'] = 200, ['chgr'] = 200, ['cvpilegg'] = 200, ['jeeppol'] = 230, ['r1200rtp'] = 40, ['policebk'] = 10, ['tarlegg'] = 200, ['dinghyy'] = 200, ['fire3'] = 230,  -- Emergência
    ['tug'] = 600, ['tropic'] = 400, ['tropic2'] = 400, ['toro'] = 200, ['toro2'] = 200, ['suntrap'] = 200, ['squalo'] = 200, ['speeder'] = 200, ['speeder2'] = 200, ['seashark2'] = 19, ['seashark'] = 19,
    ['seashark3'] = 19, ['marquis'] = 400, ['jetmax'] = 300, ['dinghy2'] = 180, ['dinghy'] = 180, ['dinghy3'] = 180, ['dinghy4'] = 180, -- Barcos
    ['zion2'] = 200, ['zion'] = 200, ['windsor2'] = 220, ['windsor'] = 220, ['sentinel'] = 200, ['sentinel2'] = 200, ['oracle'] = 200, ['oracle2'] = 200, ['jackal'] = 200, ['felon2'] = 200,
    ['felon'] = 200, ['f620'] = 180, ['exemplar'] = 190, ['cogcabrio'] = 200, -- Coupes

}