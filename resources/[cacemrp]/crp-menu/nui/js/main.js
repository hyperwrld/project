'use strict';

var menuItems = [
    {
        id: 'cuffs',
        title: 'Algemar',
        icon: '#cuffs'
    },
    {
        id   : 'general',
        title: 'Geral',
        icon: '#general',
        items: [
            {
                id: 'drag',
                title: 'Arrastar',
                icon: '#drag',
            },
            {
                id: 'give',
                title: 'Dar chaves',
                icon: '#vehicle',
            },
            {
                id: 'enter',
                title: 'Colocar <tspan x="7" y="-31">no veículo</tspan>',
                icon: '#enter',
            },
            {
                id: 'leave',
                title: 'Retirar <tspan x="31" y="-12">do veículo</tspan>',
                icon: '#leave',
            },
            {
                id: 'examine',
                title: 'Examinar',
                icon: '#examine',
            },
            {
                id: 'keys',
                title: 'Abrir/fechar',
                icon: '#keys'
            },
            {
                id   : 'more',
                title: 'Mais',
                icon: '#more',
                items: [
                    {
                        id: 'engine',
                        title: 'Ligar/desligar',
                        icon: '#engine'
                    },
                    {
                        id: 'hood',
                        title: 'Capô',
                        icon: '#hood'
                    },
                    {
                        id: 'trunk',
                        title: 'Porta-malas',
                        icon: '#trunk'
                    }
                ]
            }
        ]
    },
    {
        id   : 'animations',
        title: 'Animações',
        icon: '#walk'
    }
];

$(function() {
    var svgMenu;

    window.addEventListener('message', function (event) {
        switch (event.data.eventName) {
            case 'open':
                if (svgMenu) {
                    $('.menuHolder').remove();
                }

                var svgMenuItems = JSON.parse(JSON.stringify(menuItems));
                var isPoice = false;

                if (isPoice) {
                    svgMenuItems.push({ id : 'medic', title : 'Médico', icon: '#medic', items: [
                            { id: 'examine', title: 'Examinar', icon: '#examine' }, { id: 'heal', title: 'Curar', icon: '#bandage' },
                            { id: 'enter', title: 'Colocar <tspan x="17" y="-27.5">no veículo</tspan>', icon: '#enter' },
                            { id: 'leave', title: 'Retirar <tspan x="35" y="3.0">do veículo</tspan>', icon: '#leave' },
                            { id: 'revive', title: 'Reviver', icon: '#revive' }, { id: 'drag', title: 'Arrastar', icon: '#drag' }
                        ]
                    })
                } else {
                    svgMenuItems.push({ id : 'police', title : 'Polícia', icon: '#police', items: [
                            { id: 'examine', title: 'Examinar', icon: '#examine' }, { id: 'radar', title: 'Radar', icon: '#radar' },
                            { id: 'enter', title: 'Colocar <tspan x="17" y="-27.5">no veículo</tspan>', icon: '#enter' },
                            { id: 'leave', title: 'Retirar <tspan x="35" y="3.0">do veículo</tspan>', icon: '#leave' },
                            { id: 'drag', title: 'Arrastar', icon: '#drag' }, { id: 'search', title: 'Revistar', icon: '#search' }
                        ]
                    })
                }

                svgMenu = new RadialMenu({
                    parent: document.body,
                    size: 400,
                    closeOnClick: true,
                    menuItems: svgMenuItems,
                    onClick: function(item) {
                        console.log('You have clicked:' + item.id + item.title);
                    }
                });

                svgMenu.open();

                break;
            case 'close':
                svgMenu.close();

                break;
            default:
                break;
        }
    });
});