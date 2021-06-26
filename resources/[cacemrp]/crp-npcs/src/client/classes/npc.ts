import Utils from './../utils';

export class NPC {
    protected id: string;
    protected model: number;
    protected position: any;
    protected appearance: any;
    protected animation: string;
    protected isNetworked: boolean;
    protected settings: [];
    protected decors: [];
    protected scenario: string;
    protected blip: any;

    protected entity: number;
    protected isSpawned: boolean;
    protected isDisabled: boolean;
    protected tasks: any;
    protected props: any;

    constructor(
        id: string,
        model: string,
        position: unknown,
        appearance: unknown,
        animation: string,
        networkState: boolean,
        settings: [],
        decors: [],
        scenario: string,
        blip: unknown,
    ) {
        (this.id = id), (this.model = GetHashKey(model));
        (this.position = position), (this.appearance = appearance);
        (this.animation = animation), (this.isNetworked = networkState);
        (this.settings = settings), (this.decors = decors);
        (this.scenario = scenario), (this.blip = blip);

        (this.entity = undefined), (this.isSpawned = false);
        (this.isDisabled = false), (this.tasks = {}), (this.props = undefined);
    }

    public async spawnNpc(): Promise<void> {
        if (this.isSpawned) return;

        await Utils.LoadModel(this.model);

        const NpcPed = CreatePed(
            4,
            this.model,
            this.position.coords.x,
            this.position.coords.y,
            this.position.coords.z,
            this.position.heading + 0.0,
            this.isNetworked,
            false,
        );

        await Utils.Wait(0);

        if (DoesEntityExist(NpcPed)) {
            SetPedDefaultComponentVariation(NpcPed);

            (this.entity = NpcPed), (this.isSpawned = true);

            Utils.SetDecor(NpcPed, 'PedDecors', 'isNpc', true);
            DecorSetInt(this.entity, 'NpcId', GetHashKey(this.id));

            if (this.settings) {
                this.setSettings();
            }
            if (this.appearance) this.setAppearance();
            if (this.decors) this.setDecors();
            if (this.animation) this.setAnimation();
            if (this.scenario) this.setScenario();
        }

        SetModelAsNoLongerNeeded(this.model);
    }

    public async deleteNpc(): Promise<void> {
        if (!this.isSpawned) return;

        this.isSpawned = false;

        if (this.props) {
            DeleteObject(this.props);
            this.props = undefined;
        }

        if (DoesEntityExist(this.entity)) {
            DeleteEntity(this.entity);
        }
    }

    public async setState(state: boolean): Promise<void> {
        this.isDisabled = state;
    }

    private setSettings() {
        for (const setting of this.settings) {
            const state = setting['active'];

            switch (setting['mode']) {
                case 'invincible':
                    SetEntityInvincible(this.entity, state);
                    break;
                case 'freeze':
                    FreezeEntityPosition(this.entity, state);
                    break;
                case 'ignore':
                    SetBlockingOfNonTemporaryEvents(this.entity, state);
                    break;
                case 'collision':
                    SetEntityCompletelyDisableCollision(this.entity, false, false);
                    SetEntityCoordsNoOffset(
                        this.entity,
                        this.position.coords.x,
                        this.position.coords.y,
                        this.position.coords.z,
                        false,
                        false,
                        false,
                    );
                    break;
                case 'casino':
                    if (state)
                        this.setDealerClothes(
                            setting['gender']
                                ? Utils.GetRandomNumber(0, 6)
                                : Utils.GetRandomNumber(7, 13),
                        );

                    break;
                default:
                    break;
            }
        }
    }

    private setAppearance() {
        for (const component of this.appearance) {
            const [
                first,
                second,
                third,
                fourth,
                fifth,
                sixth,
                seventh,
                eighth,
                ninth,
                tenth,
            ] = component.params;

            switch (component.mode) {
                case 'component':
                    SetPedComponentVariation(this.entity, first, second, third, fourth);
                    break;
                case 'prop':
                    SetPedPropIndex(this.entity, first, second, third, fourth);
                    break;
                case 'blend':
                    SetPedHeadBlendData(
                        this.entity,
                        first,
                        second,
                        third,
                        fourth,
                        fifth,
                        sixth,
                        seventh,
                        eighth,
                        ninth,
                        tenth,
                    );
                    break;
                case 'overlay':
                    SetPedHeadOverlay(this.entity, first, second, third);
                    break;
                case 'overlayColor':
                    SetPedHeadOverlayColor(this.entity, first, second, third, fourth);
                    break;
                case 'hairColor':
                    SetPedHairColor(this.entity, first, second);
                    break;
                case 'eyeColor':
                    SetPedEyeColor(this.entity, first);
                    break;
                default:
                    break;
            }
        }
    }

    private setDecors() {
        Utils.SetDecors(this.entity, 'PedDecors', this.decors);
    }

    private setAnimation() {
        switch (this.animation) {
            case 'phone': {
                Utils.LoadDictionary('cellphone@');

                TaskPlayAnim(
                    this.entity,
                    'cellphone@',
                    'cellphone_text_read_base',
                    2.0,
                    3.0,
                    -1,
                    49,
                    0,
                    false,
                    false,
                    false,
                );

                const phoneModel = GetHashKey('prop_player_phone_01');

                Utils.LoadModel(phoneModel);

                const object = CreateObject(phoneModel, 1.0, 1.0, 1.0, false, false, false);

                AttachEntityToEntity(
                    object,
                    this.entity,
                    GetPedBoneIndex(this.entity, 57005),
                    0.14,
                    0.01,
                    -0.02,
                    110.0,
                    120.0,
                    -15.0,
                    true,
                    false,
                    false,
                    false,
                    2,
                    true,
                );

                this.props = object;
                break;
            }
            case 'pantherSleep':
                Utils.LoadDictionary('creatures@cougar@amb@world_cougar_rest@idle_a');

                TaskPlayAnim(
                    this.entity,
                    'creatures@cat@amb@world_cat_sleeping_ground@enter',
                    'enter',
                    2.0,
                    0,
                    -1,
                    0,
                    0,
                    false,
                    false,
                    false,
                );
                break;
            case 'catSleep':
                Utils.LoadDictionary('creatures@cat@amb@world_cat_sleeping_ground@enter');

                TaskPlayAnim(
                    this.entity,
                    'creatures@cat@amb@world_cat_sleeping_ground@enter',
                    'enter',
                    2.0,
                    0,
                    -1,
                    0,
                    0,
                    false,
                    false,
                    false,
                );
                SetPedComponentVariation(this.entity, 0, 0, 1, 2);
                break;
            case 'catSleepMeow':
                Utils.LoadDictionary('creatures@cat@amb@world_cat_sleeping_ground@enter');

                TaskPlayAnim(
                    this.entity,
                    'creatures@cat@amb@world_cat_sleeping_ground@enter',
                    'enter',
                    2.0,
                    0,
                    -1,
                    0,
                    0,
                    false,
                    false,
                    false,
                );
                SetPedComponentVariation(this.entity, 0, 0, 2, 2);
                break;
            default:
                break;
        }
    }

    private setScenario() {
        console.log(this.entity, this.scenario);
        TaskStartScenarioInPlace(this.entity, this.scenario, 0, true);
    }

    private setDealerClothes(randomNumber: number): void {
        SetPedDefaultComponentVariation(this.entity);

        switch (randomNumber) {
            case 0:
                SetPedComponentVariation(this.entity, 0, 3, 0, 0);
                SetPedComponentVariation(this.entity, 1, 1, 0, 0);
                SetPedComponentVariation(this.entity, 2, 3, 0, 0);
                SetPedComponentVariation(this.entity, 3, 1, 0, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 3, 0, 0);
                SetPedComponentVariation(this.entity, 10, 1, 0, 0);
                SetPedComponentVariation(this.entity, 11, 1, 0, 0);
                break;
            case 1:
                SetPedComponentVariation(this.entity, 0, 2, 2, 0);
                SetPedComponentVariation(this.entity, 1, 1, 0, 0);
                SetPedComponentVariation(this.entity, 2, 4, 0, 0);
                SetPedComponentVariation(this.entity, 3, 0, 3, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 1, 0, 0);
                SetPedComponentVariation(this.entity, 10, 1, 0, 0);
                SetPedComponentVariation(this.entity, 11, 1, 0, 0);
                break;
            case 2:
                SetPedComponentVariation(this.entity, 0, 2, 1, 0);
                SetPedComponentVariation(this.entity, 1, 1, 0, 0);
                SetPedComponentVariation(this.entity, 2, 2, 0, 0);
                SetPedComponentVariation(this.entity, 3, 0, 3, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 1, 0, 0);
                SetPedComponentVariation(this.entity, 10, 1, 0, 0);
                SetPedComponentVariation(this.entity, 11, 1, 0, 0);
                break;
            case 3:
                SetPedComponentVariation(this.entity, 0, 2, 0, 0);
                SetPedComponentVariation(this.entity, 1, 1, 0, 0);
                SetPedComponentVariation(this.entity, 2, 3, 0, 0);
                SetPedComponentVariation(this.entity, 3, 1, 3, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 3, 0, 0);
                SetPedComponentVariation(this.entity, 10, 1, 0, 0);
                SetPedComponentVariation(this.entity, 11, 1, 0, 0);
                break;
            case 4:
                SetPedComponentVariation(this.entity, 0, 4, 2, 0);
                SetPedComponentVariation(this.entity, 1, 1, 0, 0);
                SetPedComponentVariation(this.entity, 2, 3, 0, 0);
                SetPedComponentVariation(this.entity, 3, 0, 0, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 1, 0, 0);
                SetPedComponentVariation(this.entity, 10, 1, 0, 0);
                SetPedComponentVariation(this.entity, 11, 1, 0, 0);
                break;
            case 5:
                SetPedComponentVariation(this.entity, 0, 4, 0, 0);
                SetPedComponentVariation(this.entity, 1, 1, 0, 0);
                SetPedComponentVariation(this.entity, 2, 0, 0, 0);
                SetPedComponentVariation(this.entity, 3, 0, 0, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 1, 0, 0);
                SetPedComponentVariation(this.entity, 10, 1, 0, 0);
                SetPedComponentVariation(this.entity, 11, 1, 0, 0);
                break;
            case 6:
                SetPedComponentVariation(this.entity, 0, 4, 1, 0);
                SetPedComponentVariation(this.entity, 1, 1, 0, 0);
                SetPedComponentVariation(this.entity, 2, 4, 0, 0);
                SetPedComponentVariation(this.entity, 3, 1, 0, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 3, 0, 0);
                SetPedComponentVariation(this.entity, 10, 1, 0, 0);
                SetPedComponentVariation(this.entity, 11, 1, 0, 0);
                break;
            case 7:
                SetPedComponentVariation(this.entity, 0, 1, 1, 0);
                SetPedComponentVariation(this.entity, 1, 0, 0, 0);
                SetPedComponentVariation(this.entity, 2, 1, 0, 0);
                SetPedComponentVariation(this.entity, 3, 0, 3, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 0, 0, 0);
                SetPedComponentVariation(this.entity, 7, 0, 0, 0);
                SetPedComponentVariation(this.entity, 8, 0, 0, 0);
                SetPedComponentVariation(this.entity, 10, 0, 0, 0);
                SetPedComponentVariation(this.entity, 11, 0, 0, 0);
                break;
            case 8:
                SetPedComponentVariation(this.entity, 0, 1, 1, 0);
                SetPedComponentVariation(this.entity, 1, 0, 0, 0);
                SetPedComponentVariation(this.entity, 2, 1, 1, 0);
                SetPedComponentVariation(this.entity, 3, 1, 3, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 0, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 1, 0, 0);
                SetPedComponentVariation(this.entity, 10, 0, 0, 0);
                SetPedComponentVariation(this.entity, 11, 0, 0, 0);
                break;
            case 9:
                SetPedComponentVariation(this.entity, 0, 2, 0, 0);
                SetPedComponentVariation(this.entity, 1, 0, 0, 0);
                SetPedComponentVariation(this.entity, 2, 2, 0, 0);
                SetPedComponentVariation(this.entity, 3, 2, 3, 0);
                SetPedComponentVariation(this.entity, 4, 0, 0, 0);
                SetPedComponentVariation(this.entity, 6, 0, 0, 0);
                SetPedComponentVariation(this.entity, 7, 0, 0, 0);
                SetPedComponentVariation(this.entity, 8, 2, 0, 0);
                SetPedComponentVariation(this.entity, 10, 0, 0, 0);
                SetPedComponentVariation(this.entity, 11, 0, 0, 0);
                break;
            case 10:
                SetPedComponentVariation(this.entity, 0, 2, 1, 0);
                SetPedComponentVariation(this.entity, 1, 0, 0, 0);
                SetPedComponentVariation(this.entity, 2, 2, 1, 0);
                SetPedComponentVariation(this.entity, 3, 3, 3, 0);
                SetPedComponentVariation(this.entity, 4, 1, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 3, 0, 0);
                SetPedComponentVariation(this.entity, 10, 0, 0, 0);
                SetPedComponentVariation(this.entity, 11, 0, 0, 0);
                break;
            case 11:
                SetPedComponentVariation(this.entity, 0, 3, 0, 0);
                SetPedComponentVariation(this.entity, 1, 0, 0, 0);
                SetPedComponentVariation(this.entity, 2, 3, 0, 0);
                SetPedComponentVariation(this.entity, 3, 0, 1, 0);
                SetPedComponentVariation(this.entity, 4, 1, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 1, 0, 0);
                SetPedComponentVariation(this.entity, 8, 0, 0, 0);
                SetPedComponentVariation(this.entity, 10, 0, 0, 0);
                SetPedComponentVariation(this.entity, 11, 0, 0, 0);
                SetPedPropIndex(this.entity, 1, 0, 0, false);
                break;
            case 12:
                SetPedComponentVariation(this.entity, 0, 3, 1, 0);
                SetPedComponentVariation(this.entity, 1, 0, 0, 0);
                SetPedComponentVariation(this.entity, 2, 3, 1, 0);
                SetPedComponentVariation(this.entity, 3, 1, 1, 0);
                SetPedComponentVariation(this.entity, 4, 1, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 2, 0, 0);
                SetPedComponentVariation(this.entity, 8, 1, 0, 0);
                SetPedComponentVariation(this.entity, 10, 0, 0, 0);
                SetPedComponentVariation(this.entity, 11, 0, 0, 0);
                break;
            case 13:
                SetPedComponentVariation(this.entity, 0, 4, 0, 0);
                SetPedComponentVariation(this.entity, 1, 0, 0, 0);
                SetPedComponentVariation(this.entity, 2, 4, 0, 0);
                SetPedComponentVariation(this.entity, 3, 2, 1, 0);
                SetPedComponentVariation(this.entity, 4, 1, 0, 0);
                SetPedComponentVariation(this.entity, 6, 1, 0, 0);
                SetPedComponentVariation(this.entity, 7, 1, 0, 0);
                SetPedComponentVariation(this.entity, 8, 2, 0, 0);
                SetPedComponentVariation(this.entity, 10, 0, 0, 0);
                SetPedComponentVariation(this.entity, 11, 0, 0, 0);
                SetPedPropIndex(this.entity, 1, 0, 0, false);
                break;
            default:
                break;
        }
    }
}
