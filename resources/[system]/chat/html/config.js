window.CONFIG = {
    defaultTemplateId: 'default',
    defaultAltTemplateId: 'defaultAlt',
    templates: {
        'default': '<b>{0}</b>: {1}',
        'defaultAlt': '{0}',
        'orange': '<div style="padding: 0.4vw; margin: 0.3vw; background-color: rgba(249, 176, 21, 0.7); border-radius: 4px;"></i> <b>{0}:</b> {1}</div>',
        'blue': '<div style="padding: 0.4vw; margin: 0.3vw; background-color: rgba(28, 160, 242, 0.7); border-radius: 4px;"></i> <b>{0}:</b> {1}</div>',
        'red': '<div style="padding: 0.4vw; margin: 0.3vw; background-color: rgba(163, 44, 44, 0.7); border-radius: 4px;"></i> <b>{0}:</b> {1}</div>',
    },
    fadeTimeout: 2000,
    suggestionLimit: 5,
    style: {
        background: 'transparent',
        width: '28%',
        height: '23%',
    }
};