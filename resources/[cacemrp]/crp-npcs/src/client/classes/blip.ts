import { Vec3 } from 'fivem-js/lib/utils/Vector3';

export class Blip {
    protected blipHandle: any;
    protected coords: Vec3;
    protected settings: any;

    constructor(coords: Vec3, settings: unknown) {
        this.blipHandle = undefined;
        this.coords = coords;
        this.settings = settings;
    }

    public async addBlip(): Promise<void> {
        this.blipHandle = AddBlipForCoord(this.coords.x, this.coords.y, this.coords.z);
        this.setSettings;
    }

    public async deleteBlip(): Promise<void> {
        if (DoesBlipExist(this.blipHandle)) RemoveBlip(this.blipHandle);
    }

    private setSettings(): void {
        if (!this.settings) return;

        if (this.settings.route) SetBlipRoute(this.blipHandle, this.settings.route);

        if (this.settings.short) SetBlipAsShortRange(this.blipHandle, this.settings.short);

        if (this.settings.scale) SetBlipScale(this.blipHandle, this.settings.scale);

        if (this.settings.heading)
            ShowHeadingIndicatorOnBlip(this.blipHandle, this.settings.heading);

        if (this.settings.category) SetBlipCategory(this.blipHandle, this.settings.category);

        if (this.settings.sprite) SetBlipSprite(this.blipHandle, this.settings.sprite);

        if (this.settings.text) {
            BeginTextCommandSetBlipName('STRING');
            AddTextComponentString(this.settings.text);
            EndTextCommandSetBlipName(this.blipHandle);
        }
    }
}
