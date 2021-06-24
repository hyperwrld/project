let currentFlag = 1;

export enum PedDecors {
    isDead = GenerateNumber(true),
    isCuffed = GenerateNumber(),
    isRobbing = GenerateNumber(),
    isEscorting = GenerateNumber(),
    isEscorted = GenerateNumber(),
    isBlindfolded = GenerateNumber(),
    isInTrunk = GenerateNumber(),
    isInBeatMode = GenerateNumber(),
    isInsideVanillaUnicorn = GenerateNumber(),
    isNPC = GenerateNumber(),
    isJobEmployer = GenerateNumber(),
    isSittingOnChair = GenerateNumber(),
    isPoleDancing = GenerateNumber(),
    isPawnBuyer = GenerateNumber(),
    isRecycleExchange = GenerateNumber(),
    isCommonJobProvider = GenerateNumber(),
    isVehicleSpawner = GenerateNumber(),
    isBoatRenter = GenerateNumber(),
    isMethDude = GenerateNumber(),
    isBankAccountManager = GenerateNumber(),
    isShopKeeper = GenerateNumber(),
    isWeaponShopKeeper = GenerateNumber(),
    isToolShopKeeper = GenerateNumber(),
    isSportShopKeeper = GenerateNumber(),
    isCasinoChipSeller = GenerateNumber(),
    isCasinoMembershipGiver = GenerateNumber(),
    isCasinoDrinkGiver = GenerateNumber(),
    isWeedShopKeeper = GenerateNumber(),
    isJobVehShopKeeper = GenerateNumber(),
    isWineryShopKeeper = GenerateNumber(),
}

export enum VehicleDecors {
    isPlayerVehicle = GenerateNumber(true),
    isStolenVehicle = GenerateNumber(),
    isScrapVehicle = GenerateNumber(),
    isHotwiredVehicle = GenerateNumber(),
    isTowingVehicle = GenerateNumber(),
}

export enum ObjectDecors {}

function GenerateNumber(canReset?: boolean) {
    if (canReset) currentFlag = 1;

    currentFlag *= 2;

    return currentFlag / 2;
}
