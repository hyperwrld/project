'use strict';

var inventoryType = 1, inventorySlots = 40, inventoryCoords = undefined;
var isInventoryOpen = false, shopType = 1, scrollingSensitivity = 60, scrollingSpeed = 30;
var playerItems = {}, personalMaxWeight = 325, otherItems = {}, secondaryMaxWeight = 1000;
var defaultHTML, personalWeight, secondaryWeight;

let itemList = {};

// * INVENTORY WEAPONS

itemList['1737195953'] = { displayname: 'Cacetete', weight: 10, nonStack: true, image: 'crp-cacetete.png', weapon: true };
itemList['911657153'] = { displayname: 'Taser', weight: 10, nonStack: true, image: 'crp-stungun.png', weapon: true };
itemList['453432689'] = { displayname: 'Pistola', weight: 15, nonStack: true, image: 'crp-pistol.png', weapon: true };
itemList['-1076751822'] = { displayname: 'Pistola SNS', weight: 15, nonStack: true, image: 'crp-snspistol.png', weapon: true };
itemList['137902532'] = { displayname: 'Pistola Vintage', weight: 15, nonStack: true, image: 'crp-vintagepistol.png', weapon: true };
itemList['-771403250'] = { displayname: 'Pistola Pesada', weight: 20, nonStack: true, image: 'crp-heavypistol.png', weapon: true };
itemList['1593441988'] = { displayname: 'Pistola de Combate', weight: 15, nonStack: true, image: 'crp-combatpistol.png', weapon: true };
itemList['-619010992'] = { displayname: 'Pistola-Metralhadora', weight: 30, nonStack: true, image: 'crp-machinepistol.png', weapon: true };
itemList['-1121678507'] = { displayname: 'Mini Submetralhadora', weight: 30, nonStack: true, image: 'crp-minismg.png', weapon: true };
itemList['324215364'] = { displayname: 'Micro Submetralhadora', weight: 30, nonStack: true, image: 'crp-microsmg.png', weapon: true };
itemList['736523883'] = { displayname: 'Submetralhadora', weight: 35, nonStack: true, image: 'crp-smg.png', weapon: true };
itemList['1649403952'] = { displayname: 'Rifle Compacto', weight: 45, nonStack: true, image: 'crp-compactrifle.png', weapon: true };
itemList['-1074790547'] = { displayname: 'Rifle de Assalto', weight: 55, nonStack: true, image: 'crp-assaultrifle.png', weapon: true,  };
itemList['-2084633992'] = { displayname: 'Carabina', weight: 55, nonStack: true, image: 'crp-carbinerifle.png', weapon: true };

// * NORMAL ITEMS

itemList['156805094'] = { displayname: 'Colete', weight: 25, nonStack: false, image: 'crp-colete.png', weapon: false, price: 20 };
itemList['130895348'] = { displayname: 'Ligadura', weight: 2.5, nonStack: false, image: 'crp-ligadura.png', weapon: false, price: 150 };

itemList['196068078'] = { displayname: 'Coca-Cola', weight: 1, nonStack: false, image: 'crp-coca.png', weapon: false, price: 500 };
itemList['129942349'] = { displayname: 'Batatas', weight: 1, nonStack: false, image: 'crp-batatas.png', weapon: false, price: 3 };

$(function () {
	defaultHTML = $('.ui').clone();

	window.addEventListener('message', function (event) {
		switch (event.data.event) {
			case 'open':
				var data = event.data.playerData, _data = event.data.secondaryData;

                (isInventoryOpen = true), (inventoryType = _data.type), (inventoryCoords = _data.coords), (shopType = _data.shopType);

                // * inventoryType: 1 (drop) | 2 (store) | 3 (custom) | 4 (undefined) * //

                if (inventoryType == 3) { secondaryMaxWeight = _data.weight,  inventorySlots = _data.slots }

				SetupInventories(data.id, data.items, _data.id, _data.items);

				$('.ui').fadeIn(400);

				break;
			case 'close':
				var inventory = $('.ui');

				inventory.fadeOut(400, function () {
					inventory.replaceWith(defaultHTML.clone());
				});

                (isInventoryOpen = false), (playerItems = {}), (otherItems = {}), (inventorySlots = 40), (secondaryMaxWeight = 1000);

				$.post('http://crp-inventory/nuiMessage', JSON.stringify({ close: true }));

				break;
			default:
				console.log('Received unhandled event ' + event.data.event);

				break;
		}
	});

	$(document).keyup(function (event) {
		if ((event.key == 'Escape' || event.key == 'F2') && isInventoryOpen) {
			var inventory = $('.ui');

			inventory.fadeOut(400, function () {
				inventory.replaceWith(defaultHTML.clone());
			});

            (isInventoryOpen = false), (playerItems = {}), (otherItems = {}), (inventorySlots = 40), (secondaryMaxWeight = 1000);

			$.post('http://crp-inventory/nuiMessage', JSON.stringify({ close: true }));
		}
	});
});

function SetupInventories(playerid, playerData, otherid, otherData) {
	$('.player-inventory h3').html('character-' + playerid);
	$('.secondary-inventory h3').html(otherid);

	if (playerData != undefined) {
		for (const [key, value] of Object.entries(playerData)) {
			playerItems[value.slot] = { id: value.item, quantity: value.count };
		}
	}

	for (var i = 1; i <= 40; i++) {
		$('.player-inventory').append('<div class="inventory-cell" id="p' + i + '"><div class="inventory-bottom disable"></div></div>');

		if (i <= 4) {
			$('.player-inventory > #p' + i).prepend('<div class="number disable"><span> ' + i + ' </span></div>');
		}

		if (playerItems[i] != undefined) {
			var item = itemList[playerItems[i].id];
			var itemWeight = item.weight * playerItems[i].quantity;

			$('.player-inventory > #p' + i).append(
				'<div class="item"><p>' + playerItems[i].quantity + ' (' + itemWeight.toFixed(2) + ')</p><img class="picture" src="items/' +
				item.image + '" ><div class="item-name">' + item.displayname + '</div></div>'
			);

			$('.player-inventory > #p' + i + ' > .item').data('item', playerItems[i]);
		}
	}

	if (otherData != undefined) {
		for (const [key, value] of Object.entries(otherData)) {
			otherItems[value.slot] = { id: value.item, quantity: value.count, price: value.price };
		}
	}

	for (var i = 1; i <= inventorySlots; i++) {
		$('.secondary-inventory').append('<div class="inventory-cell" id="s' + i + '"><div class="inventory-bottom disable"></div></div>');

		if (inventoryType == 1) {
			$('#s' + i).addClass('drop-cell');
		}

		if (otherItems[i] != undefined) {
			var item = itemList[otherItems[i].id];
			var itemWeight = item.weight * otherItems[i].quantity;
			var div = '<div class="item"><p>' + otherItems[i].quantity + ' (' + itemWeight.toFixed(2) + ')</p><img class="picture" src="items/' +
				item.image + '" ><div class="item-name">' + item.displayname + '</div></div>';

			if (inventoryType == 2) {
				div = '<div class="item"><p>' + otherItems[i].quantity + ' (' + itemWeight.toFixed(2) + ')</p><img class="picture" src="items/' +
                    item.image + '" ><div class="item-name">' + item.displayname + ' - <font color="#60B643">' + otherItems[i].price +
					'€</font></div></div>';
			}

			$('.secondary-inventory > #s' + i).append(div);
			$('.secondary-inventory > #s' + i + ' > .item').data('item', otherItems[i]);
		}
	}

	CalculateInventoriesWeight();

	$('.control-close').on('click', function () {
		var inventory = $('.ui');

		inventory.fadeOut(400, function () {
			inventory.replaceWith(defaultHTML.clone());
		});

		(isInventoryOpen = false), (playerItems = {}), (otherItems = {});

		$.post('http://crp-inventory/nuiMessage', JSON.stringify({ close: true }));
	});

	$('.item').hover(
		function () {
			var item = $(this).data('item'), itemInfo = $('.item-info');
			var itemData = itemList[item.id];

			itemInfo.fadeIn();

			if (item.information) {
				console.log(item.information.serial);
			} else {
				itemInfo.html(
					itemData.displayname + '<br> ' + itemData.description + '<br> <b>Peso:</b> ' + item.quantity * itemData.weight +
					'&nbsp;&nbsp;&nbsp;&nbsp; / &nbsp;&nbsp;&nbsp;&nbsp;<b>Quantidade:</b> ' + item.quantity
				);
			}
		},
		function () {
			$('.item-info').fadeOut();
		}
	);

	SetupDraggingFunction();
}

function SetupDraggingFunction() {
	$('.inventory-cell')
		.sortable({
			appendTo: document.body,
			helper: 'clone',
			connectWith: '.inventory-cell',
			cancel: '.disable',
			placeholder: 'inventory-item-sortable-placeholder',
			tolerance: 'pointer',
			scroll: false,
			start: function (event, ui) {
				var item = $(ui.item), helper = $(ui.helper);
				var itemData = item.data('item'), inputCount = $('#count').val();

				if (item.parent().attr('id') == 'use') return;

				var quantity = itemData.quantity;

				if (inputCount > 0 && quantity - inputCount > 0) {
					quantity = parseInt(inputCount);
				}

				var itemWeight = itemList[itemData.id].weight * quantity;

				helper.children('p').text(quantity + ' (' + itemWeight.toFixed(2));

				helper.css({ opacity: '0.8' });

				item.show();
			},
			stop: function (event, ui) {
				if ($(ui.item).parent().attr('id') == 'use') return;

				$(ui.item).fadeOut(0).delay(175).fadeIn(0);
			},
			receive: function (event, ui) {
				var item = $(ui.item);

				var currentInventory = $(ui.sender).parent().attr('class');
				var inventoryDropName = item.parent().parent().attr('class');

				var currentSlot = item.parent().attr('id');
				var lastSlot = $(ui.sender).attr('id');

				var returnItem = $(this).children('.item').not(ui.item);

				if (inventoryDropName == 'controls') {
					$(ui.sender).sortable('cancel');

					$('#use').stop().css('background-color', 'rgba(255, 0, 0, 0.3)').animate({ backgroundColor: 'rgba(0, 0, 0, 0.5)' }, 1500);
					return;
				}

				if (inventoryType == 2 && inventoryDropName == 'secondary-inventory') {
					$(ui.sender).sortable('cancel');

					TriggerNotification(false);
					return;
				}

				if (inventoryType == 2 && currentInventory == 'secondary-inventory' && inventoryDropName == 'player-inventory') {
					var canBuyItem = AttemptBuyFromStore(item, currentInventory, returnItem, inventoryDropName, currentSlot, lastSlot);

					canBuyItem.then((data) => {
						if (data.status == true) {
							if (currentInventory != inventoryDropName) {
								CalculateInventoriesWeight();
							}

							$(this).children('.item').not(ui.item).remove();
						} else $(ui.sender).sortable('cancel');

						TriggerNotification(data.status, data.text);
					});
				} else {
					if (returnItem.attr('class') === undefined) {
						var canMoveItem = AttemptDropInEmptySlot(item, currentInventory, inventoryDropName, currentSlot, lastSlot);

						canMoveItem.then((status) => {
							if (status == true) {
								if (currentInventory != inventoryDropName) {
									CalculateInventoriesWeight();
								}
							} else $(ui.sender).sortable('cancel');

							TriggerNotification(status);
						});
					} else {
						var canMoveItem = AttemptDropInFilledSlot(item, currentInventory, returnItem, inventoryDropName, currentSlot, lastSlot);

						canMoveItem.then((status) => {
							if (status == true) {
								if (currentInventory != inventoryDropName) {
									CalculateInventoriesWeight();
								}

								$(this).children('.item').not(ui.item).remove();
							} else $(ui.sender).sortable('cancel');

							TriggerNotification(status);
						});
					}
				}
			},
			sort: function (event, ui) {
				var scrollContainer = ui.placeholder[0].parentNode.parentNode;
				var overflowOffset = $(scrollContainer).offset();

				if (overflowOffset.top + scrollContainer.offsetHeight - event.pageY < scrollingSensitivity) {
					scrollContainer.scrollTop = scrollContainer.scrollTop + scrollingSpeed;
				} else if (event.pageY - overflowOffset.top < scrollingSensitivity) {
					scrollContainer.scrollTop = scrollContainer.scrollTop - scrollingSpeed;
				}
			}
		})
		.disableSelection();
}

async function AttemptBuyFromStore(currentItem, currentInventory, returnItem, returnInventory, currentSlot, lastSlot) {
	var item = currentItem.data('item'), inputCount = $('#count').val();
	var quantity = item.quantity, weight = itemList[item.id].weight;

	if (quantity <= 0) return false;

	if (inputCount > 0 && quantity - parseInt(inputCount) > 0) {
		quantity = parseInt(inputCount);
	}

	var result = ErrorCheck(currentInventory, returnInventory, (weight * quantity));

	if (result == 'Success') {
		var _currentSlot = currentSlot.replace(/\D/g, ''), boolean = { status: false }, canStack = false, _item = undefined;

		_item = returnItem.data('item');

		if (returnItem.attr('class') != undefined && item.id == _item.id) {
			if (itemList[item.id].nonStack) {
				return { status: false, text: 'Não é possível dar stack nesses items.' };
			}
			canStack = true
		} else if (returnItem.attr('class') != undefined) return { status: false, text: 'Não é possível dar stack nesses items.' };

		var promise = new Promise(function (resolve, reject) {
			var data = {
				inventory: $('.player-inventory h3').text(),
				item: item.id,
				quantity: quantity,
				slot: _currentSlot,
				canStack: canStack
			};

			$.post('http://crp-inventory/nuiMessage', JSON.stringify({ buyitem: true, itemdata: data, shoptype: shopType }), function (_data) {
				if (_data.status) {
					if ((item.quantity - quantity) > 0) {
						AddItem(lastSlot, item.id, (item.quantity - quantity), true, true, true);
					} else DeleteItem(lastSlot);

					if (_data.stack) {
						AddItem(currentSlot, item.id, (_item.quantity + quantity), true, false, true);
					} else AddItem(currentSlot, item.id, (quantity), true, false, true);

					boolean = {
						status: true, text: 'Acabaste de comprar o item: ' + itemList[item.id].displayname + ' (' + quantity + '), por: ' + _data.price + ' euros.'
					};
				} else {
					boolean = { status: false, text: _data.text };
				}

				resolve(boolean);
			});
		});

		boolean = await promise;

		return boolean;
	} else {
		return { status: false, text: 'Não consegues carregar esse item.' };
	}
}

async function AttemptDropInEmptySlot(currentItem, currentInventory, returnInventory, currentSlot, lastSlot) {
	var item = currentItem.data('item'), inputCount = $('#count').val();
	var weight = itemList[item.id].weight, quantity = item.quantity;

	if (inputCount > 0 && quantity - parseInt(inputCount) > 0) {
		quantity = parseInt(inputCount);
	}

	var result = ErrorCheck(currentInventory, returnInventory, (weight * quantity));

	if (result == 'Success') {
		var _lastSlot = lastSlot.replace(/\D/g, ''), _currentSlot = currentSlot.replace(/\D/g, '');

		var boolean = false;

		var promise = new Promise(function (resolve, reject) {
			var data = {
				lastInventory: $('.' + currentInventory + ' h3').text(),
				lastSlot: _lastSlot,
				currentInventory: $('.' + returnInventory + ' h3').text(),
				currentSlot: _currentSlot,
				id: item.id,
				quantity: quantity
            };

			if (inventoryType == 1) data['coords'] = inventoryCoords;

			$.post('http://crp-inventory/nuiMessage', JSON.stringify({ moveitem: true, itemdata: data }), function (_data) {
				if (_data.status) {
					if (_data.splitItem) {
						AddItem(lastSlot, item.id, item.quantity - quantity, true, true);

						AddItem(currentSlot, item.id, quantity, true, false);
					} else {
						AddItem(currentSlot, item.id, quantity, true, false);

						DeleteItem(lastSlot);
					}
					boolean = true;
				}
				resolve(boolean);
			});
		});

		boolean = await promise;

		return boolean;
	} else {
		return false;
	}
}

async function AttemptDropInFilledSlot(currentItem, currentInventory, returnItem, returnInventory, currentSlot, lastSlot) {
	var item = currentItem.data('item'), _item = returnItem.data('item'), inputCount = $('#count').val();
	var weight = itemList[item.id].weight, _weight = itemList[_item.id].weight;

	var quantity = item.quantity, _quantity = _item.quantity;

	if (inputCount > 0 && quantity - parseInt(inputCount) > 0) {
		quantity = parseInt(inputCount);
	}

	var CanStackItems = false;

	if (item.id == _item.id && !itemList[item.id].nonStack) {
		CanStackItems = true;
	} else if (quantity != item.quantity) {
		return false;
	}

	var result = ErrorCheck(currentInventory, returnInventory, (weight * quantity));
	var _result = ErrorCheck(returnInventory, currentInventory, (_weight * _quantity));

	if (result == 'Success' && _result == 'Success') {
		var _lastSlot = lastSlot.replace(/\D/g, ''), _currentSlot = currentSlot.replace(/\D/g, '');

		var boolean = false;

		var promise = new Promise(function (resolve, reject) {
			var data = {
				lastInventory: $('.' + currentInventory + ' h3').text(),
				item: item.id,
				lastSlot: _lastSlot,
				quantity: quantity,
				currentInventory: $('.' + returnInventory + ' h3').text(),
				_item: _item.id,
				currentSlot: _currentSlot,
				_quantity: _quantity,
				canStack: CanStackItems
			};

			$.post('http://crp-inventory/nuiMessage', JSON.stringify({ swapitem: true, itemsdata: data }), function (_data) {
				if (_data.status) {
					if (_data.swapItems) {
						AddItem(lastSlot, _item.id, _quantity, true, true);

						AddItem(currentSlot, item.id, quantity, false, false);
					} else {
						if (_data.delete) {
							AddItem(currentSlot, item.id, quantity + _quantity, true, false);

							DeleteItem(lastSlot);
						} else {
							AddItem(lastSlot, item.id, item.quantity - quantity, true, true);

							AddItem(currentSlot, _item.id, _quantity + quantity, true, false);
						}
					}
					boolean = true;
				}
				resolve(boolean);
			});
		});

		boolean = await promise;

		return boolean;
	} else {
		return false;
	}
}

function ErrorCheck(startingInventory, inventoryDropName, movementWeight) {
	var sameInventory = true;
	var errorReason = 'Success';

	if (startingInventory == 'player-inventory' && inventoryDropName != 'player-inventory') {
		sameInventory = false;
		console.log('Moving a item from player to secondary');
	} else if (startingInventory != inventoryDropName) {
		sameInventory = false;
		console.log('Moving a item from secondary to player');
	}

	if (sameInventory == true) {
		console.log('Moving items in the same inventory');
	} else {
		if (startingInventory == 'player-inventory') {
			if (movementWeight + secondaryWeight > secondaryMaxWeight) {
				console.log('movementWeight + secondaryWeight: ' + (movementWeight + secondaryWeight) + ' > ' + secondaryMaxWeight);
				errorReason = "You can't move the item, because you don't have space on the target inventory";
				console.log(errorReason);
			}
		} else {
			if (movementWeight + personalWeight > personalMaxWeight) {
				console.log('movementWeight + personalWeight: ' + (movementWeight + personalWeight) + ' > ' + personalMaxWeight);
				errorReason = "You can't move the item, because you don't have space on your inventory";
				console.log(errorReason);
			}
		}
	}
	return errorReason;
}

function CalculateInventoriesWeight() {
	(personalWeight = 0), (secondaryWeight = 0);

	if (Object.keys(playerItems).length > 0) {
		for (var i = 0; i <= Object.keys(playerItems).reduce(function (a, b) {
			return playerItems[a] > playerItems[b] ? a : b
		}); i++) {
			if (playerItems[i] != undefined) {
				personalWeight = personalWeight + itemList[playerItems[i].id].weight * playerItems[i].quantity;
			}
		}
	}

	if (Object.keys(otherItems).length > 0) {
		for (var i = 0; i <= Object.keys(otherItems).reduce(function (a, b) {
			return otherItems[a] > otherItems[b] ? a : b
		}); i++) {
			if (otherItems[i] != undefined) {
				secondaryWeight = secondaryWeight + itemList[otherItems[i].id].weight * otherItems[i].quantity;
			}
		}
	}

	$('.player-inventory h5').html('Peso: ' + personalWeight.toFixed(2) + ' / ' + personalMaxWeight.toFixed(2));
	$('.secondary-inventory h5').html('Peso: ' + secondaryWeight.toFixed(2) + ' / ' + secondaryMaxWeight.toFixed(2));
}

function AddItem(slot, itemid, count, needUpdate, canCreate, isShopItem) {
	var _slot = slot.replace(/\D/g, ''), GetObject = undefined;

	if (slot.includes('p')) {
		playerItems[_slot] = { id: itemid, quantity: count };

		GetObject = playerItems[_slot];
	} else {
        otherItems[_slot] = { id: itemid, quantity: count, price: (otherItems[_slot] != null ? otherItems[_slot].price : undefined) };

		GetObject = otherItems[_slot];
	}

	if (needUpdate) {
		var inventory = $('#' + slot), item = itemList[itemid];

		var itemWeight = item.weight * GetObject.quantity;

		if (canCreate) {
			if (isShopItem) {
				inventory.append(
					'<div class="item"><p>' + GetObject.quantity + ' (' + itemWeight.toFixed(2) + ')</p><img class="picture" src="items/' +
                    item.image + '" ><div class="item-name">' + item.displayname + ' - <font color="#60B643">' + GetObject.price + '€</font></div></div>'
				);
			} else {
				inventory.append(
					'<div class="item"><p>' + GetObject.quantity + ' (' + itemWeight.toFixed(2) + ')</p><img class="picture" src="items/' +
					item.image + '" ><div class="item-name">' + item.displayname + '</div></div>'
				);
			}
		} else {
			if (isShopItem) {
				inventory.children('.item').children('.item-name').text(itemList[itemid].displayname);
			}

			inventory.children('.item').children('p').text(GetObject.quantity + ' (' + itemWeight.toFixed(2));
		}

		inventory.children('.item').data('item', GetObject);
	}
}

function SwapItem(slot, itemid, count) {
	var inventory = $('#' + slot),
		item = itemList[itemid],
		_slot = slot.replace(/\D/g, '');
	var GetObject = undefined;

	if (slot.includes('p')) {
		playerItems[_slot] = { id: itemid, quantity: count };

		GetObject = playerItems[_slot];
	} else {
		otherItems[_slot] = { id: itemid, quantity: count };

		GetObject = otherItems[_slot];
	}

	var itemWeight = item.weight * GetObject.quantity;

	inventory.remove('.item');

	inventory.append(
		'<div class="item"><p>' + GetObject.quantity + ' (' + itemWeight.toFixed(2) + ')</p><img class="picture" src="items/' +
		item.image + '" ><div class="item-name">' + item.displayname + '</div></div>'
	);

	inventory.children('.item').data('item', GetObject);
}

function DeleteItem(slot) {
	var inventory = $('#' + slot), _slot = slot.replace(/\D/g, '');

	if (slot.includes('p')) {
		playerItems[_slot] = undefined;
	} else {
		otherItems[_slot] = undefined;
	}

	inventory.remove('.item');
}

function CheckInput(event) {
	var charCode = event.which ? event.which : event.keyCode;

	if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
	return true;
}

function TriggerNotification(type, text) {
	if (type) {
		$.post('http://crp-inventory/nuiMessage', JSON.stringify({ success: true, text: text }));
	} else {
		$.post('http://crp-inventory/nuiMessage', JSON.stringify({ error: true, text: text }));
	}
}
