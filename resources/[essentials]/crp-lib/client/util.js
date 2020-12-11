exports('getHeadBlend', (playerPed) => {
	let arrayInt = new Uint32Array(new ArrayBuffer(10 * 8)), arrayFloat = new Float32Array(new ArrayBuffer(10 * 8));

    if (!Citizen.invokeNative('0x2746BD9D88C5C5D0', playerPed, arrayInt, true)) {
        return false;
    };

    Citizen.invokeNative('0x2746BD9D88C5C5D0', playerPed, arrayFloat, true);

	return [
		arrayInt[0], arrayInt[2], arrayInt[4], arrayInt[6], arrayInt[8],
		arrayInt[10], arrayFloat[12], arrayFloat[14], arrayFloat[16]
	];
});