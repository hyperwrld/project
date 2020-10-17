'use strict';

function degreesToRadians(degree) {
	return degree * (Math.PI / 180);
}

function getDegreePosition(angleDegree, length) {
	return {
        x: Math.sin(degreesToRadians(angleDegree)) * length,
        y: Math.cos(degreesToRadians(angleDegree)) * length
    };
}

function pointToString(point) {
	return numberToString(point.x) + ' ' + numberToString(point.y);
}

function numberToString(number) {
	if (Number.isInteger(number)) {
		return number.toString();
	}

	if (number) {
		let r = (+number).toFixed(5);

		if (r.match(/\./)) {
			r = r.replace(/\.?0+$/, '');
		}

		return r;
	}
}

function resolveLoopIndex(index, length) {
	if (index < 0) {
        index = length + index;
	}

	if (index >= length) {
        index = index - length;
	}

    if (index < length) {
        return index;
	}

    return null;
}

function waitForTransitionEnd(node, propertyName) {
	return new Promise(function (resolve) {
        function handler(event) {
            if (event.target == node && event.propertyName == propertyName) {
				node.removeEventListener('transitionend', handler);
                resolve();
            }
		}

        node.addEventListener('transitionend', handler);
    });
}

function nextTick(funct) {
	setTimeout(funct, 15);
}

function getIndexOffset(items, sectorCount) {
	if (items.length < sectorCount) {
        switch (items.length) {
            case 1:
                return -2;
            case 2:
                return -2;
            case 3:
                return -2;
            default:
                return -1;
        }
	}

    return -1;
}

function calculateScale(sectorSpace, sectorCount, radius) {
	let totalSpace = sectorSpace * sectorCount;
    let circleLength = Math.PI * 2 * radius;
	let radiusDelta = radius - (circleLength - totalSpace) / (Math.PI * 2);

    return (radius - radiusDelta) / radius;
}

export { degreesToRadians, getDegreePosition, pointToString, numberToString, resolveLoopIndex, waitForTransitionEnd, nextTick, getIndexOffset, calculateScale };