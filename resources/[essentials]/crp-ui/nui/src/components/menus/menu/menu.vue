<script>
	import { mapGetters } from 'vuex';
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faRunning, faTimes, faWalking } from '@fortawesome/free-solid-svg-icons';

	library.add(faTimes, faWalking, faRunning);

	import {
		getDegreePosition, pointToString,
		numberToString, resolveLoopIndex, waitForTransitionEnd,
		nextTick, getIndexOffset, calculateScale
	} from './util.js';

	import { fragment } from '../../../utils/lib.js';

	export default {
		name: 'menu',
		props: ['closeMenu'],
		computed: {
			...mapGetters('menu', {
				menuItems: 'getMenuItems'
			})
		},
		data () {
			return {
				isOpen: true, menuList: []
			}
		},
		created() {
			this.radius = 50;
			this.innerRadius = this.radius * 0.32;
			this.sectorSpace = this.radius * 0.03;

			let layerInfo = this.createMenuLayer(this.menuItems, 0);

			this.menuList.push(layerInfo);

			nextTick(function () {
				layerInfo.inner = false;
			})
		},
		mounted: function () {
			document.addEventListener('keydown', this.keyDown.bind(this));
			document.addEventListener('wheel', this.mouseWheel.bind(this));
		},
		beforeDestroy: function () {
			document.removeEventListener('keydown', this.keyDown);
			document.removeEventListener('wheel', this.mouseWheel);
		},
		methods: {
			mouseWheel: function(event) {
				let delta = -event.deltaY;

				if (delta > 0) {
					this.selectDelta(1);
				} else {
					this.selectDelta(-1);
				}
			},
			keyDown: function(event) {
				switch (event.key) {
					case 'Escape':
					case 'Backspace':
						this.centerClick();
						break;
					case 'Enter':
						this.menuClick(this.getSelectedItem());
						break;
					case 'ArrowRight':
                    case 'ArrowUp':
						this.selectDelta(1);
						break;
					case 'ArrowLeft':
                    case 'ArrowDown':
						this.selectDelta(-1);
						break;
					default:
						break;
				}

				event.preventDefault();
			},
			createMenuLayer: function(items, level) {
				let info = {
					inner: true, outer: false,
					level: level, levelItems: items,
					sectors: [], selectedIndex: 0
				};

				let sectorCount = Math.max(items.length, 3);
				let scale = calculateScale(this.sectorSpace, sectorCount, this.radius);

				let angleStep = 360 / sectorCount;
				let angleShift = angleStep / 2 + 270;
				let indexOffset = getIndexOffset(items, sectorCount);

				for (let i = 0; i < sectorCount; ++i) {
					let startAngle = angleShift + angleStep * i, endAngle = angleShift + angleStep * (i + 1);
					let itemIndex = resolveLoopIndex(sectorCount - i + indexOffset, sectorCount), item;

					if (itemIndex >= 0 && itemIndex < items.length) {
						item = items[itemIndex];
					} else {
						item = null;
					}

					let sector = this.createSector(startAngle, endAngle, scale, item);

					sector.itemIndex = itemIndex;
					info.sectors.push(sector);
				}

				info.centerRadius = this.innerRadius - this.sectorSpace / 3;
				info.centerSize = level > 0 ? 8 : 7;
				info.centerIcon = level > 0 ? '#return' : '#close';
				info.centerTransform = 'translate(-' + numberToString(info.centerSize / 2) + ',-' + numberToString(info.centerSize / 2) + ')';

				return info;
			},
			centerClick: function() {
				if (this.openMenuList.length > 1) {
					let childMenu = this.getCurrentMenu();
					let parentMenu = this.openMenuList[this.openMenuList.length - 2];
					let svgNode = document.getElementById('level' + childMenu.level);

					waitForTransitionEnd(svgNode, 'visibility').then(() => {
						this.openMenuList.pop();
					});

					childMenu.inner = true, parentMenu.outer = false;
				} else {
					this.closeMenu({ appName: 'menu' });
				}
			},
			getCurrentMenu: function() {
				return this.openMenuList[this.openMenuList.length - 1];
			},
			sectorHover: function(event) {
				if (event.target.parentNode.classList.contains('sector')) {
					let dataset = event.target.parentNode.dataset;

					if (dataset.itemIndex !== undefined) {
						let currentMenu = this.getCurrentMenu();

						currentMenu.selectedIndex = parseInt(dataset.itemIndex);
					}
				}
			},
			getSelectedItem: function() {
				let currentMenu = this.getCurrentMenu();

				return currentMenu.levelItems[currentMenu.selectedIndex];
			},
			selectDelta: function(indexDelta) {
				let currentMenu = this.getCurrentMenu();
				let selectedIndex = currentMenu.selectedIndex + indexDelta;

				if (selectedIndex < 0) {
					selectedIndex = currentMenu.levelItems.length + selectedIndex;
				} else if (selectedIndex >= currentMenu.levelItems.length) {
					selectedIndex -= currentMenu.levelItems.length;
				}

				currentMenu.selectedIndex = selectedIndex;
			},
			menuClick: function(item) {
				if (item.items) {
					this.openNestedMenu(item);
				} else {
					this.$emit('clicked', item);

					if (this.closeOnClick) {
						this.closeMenu({ appName: 'menu' });
					}
				}
			},
			sectorClick: function(event) {
				if (event.target.parentNode.classList.contains('sector')) {
					let dataset = event.target.parentNode.dataset;
					let currentMenu = this.getCurrentMenu();

					if (dataset.itemIndex !== undefined) {
						let item = currentMenu.levelItems[dataset.itemIndex];

						this.menuClick(item);
					}
				}
			},
			openNestedMenu: function(item) {
				let parentMenu = this.getCurrentMenu();
				let newMenu = this.createMenuLayer(item.items, this.openMenuList.length);

				parentMenu.outer = true;
				this.openMenuList.push(newMenu);

				nextTick(function () {
					newMenu.inner = false;
				});
			},
			createSector: function(startAngleDeg, endAngleDeg, scale, item) {
				let info = {}, centerPoint = this.getSectorCenter(startAngleDeg, endAngleDeg);

				info.centerX = numberToString(centerPoint.x);
				info.centerY = numberToString(centerPoint.y);

				let translate = {
					x: numberToString((1 - scale) * centerPoint.x),
					y: numberToString((1 - scale) * centerPoint.y)
				};

				info.transform = 'translate(' + translate.x + ',' + translate.y + ') scale(' + scale + ')';
				info.d = this.getSectorPathCmd(startAngleDeg, endAngleDeg, scale);

				if (item) {
					info.className = 'sector', info.id = item.id;

					if (item.label) {
						info.label = item.label;

						if (item.icon) {
							info.textTransform = 'translate(0,8)';
						} else {
							info.textTransform = 'translate(0,2)';
						}
					}

					if (item.icon) {
						info.icon = item.icon;

						if (item.label) {
							info.useTransform = 'translate(-5,-8)';
						} else {
							info.useTransform = 'translate(-5,-5)';
						}
					}
				}

				return info;
			},
			getSectorPathCmd: function(startAngleDeg, endAngleDeg, scale) {
				let initPoint = getDegreePosition(startAngleDeg, this.radius);
				let path = 'M' + pointToString(initPoint);
				let radiusAfterScale = this.radius * (1 / scale);

				path += 'A' + radiusAfterScale + ' ' + radiusAfterScale + ' 0 0 0' + pointToString(getDegreePosition(endAngleDeg, this.radius));
				path += 'L' + pointToString(getDegreePosition(endAngleDeg, this.innerRadius));

				let radiusDiff = this.radius - this.innerRadius;
				let radiusDelta = (radiusDiff - (radiusDiff * scale)) / 2;
				let innerRadius = (this.innerRadius + radiusDelta) * (1 / scale);

				path += 'A' + innerRadius + ' ' + innerRadius + ' 0 0 1 ' + pointToString(getDegreePosition(startAngleDeg, this.innerRadius));
				path += 'Z';

				return path;
			},
			getSectorCenter: function(startAngleDeg, endAngleDeg) {
				return getDegreePosition((startAngleDeg + endAngleDeg) / 2, this.innerRadius + (this.radius - this.innerRadius) / 2);
			}
        },
		render() {
			return (
				<transition appear name='fade'>
					<div class='menu'>
						<svg class='icons'>
							<font-awesome-icon id='close' icon='times'/>
							<font-awesome-icon id='return' icon='undo'/>
							{ this.menuItems.map((menu) => {
								return (
									<font-awesome-icon id={ menu.id } icon={ menu.icon }/>
								)
							})}
						</svg>
						{ this.menuList.map((menu) => {
							return (
								<svg id={ 'level' + menu.level } class={ `container ${ menu.inner ? 'inner' : '', menu.outer ? 'outer' : '' }` } viewBox='-50 -50 100 100'>
									{ menu.sectors.map((sector, index) => {
										return (
											<fragment>
												<g
													class={{ sector: sector.id, dummy: !sector.id, selected: menu.selectedIndex == sector.itemIndex }}
													data-id={ sector.id } data-index={ index } transform={ sector.transform } data-item-index={ sector.itemIndex }
												>
													<path d={ sector.d }/>
													{ sector.label &&
														<text text-anchor='middle' font-size='38%' x={ sector.centerX } y={ sector.centerY } transform={ sector.textTransform }>
															{ sector.label }
														</text>
													}
													<use href={ sector.icon } x={ sector.centerX } y={ sector.centerY } transform={ sector.useTransform } width='10' height='10' fill='white'/>
												</g>
												{ index == 0 &&
													<g class='center'>
														<circle r={ menu.centerRadius }/>
														<use href={ menu.centerIcon } transform={ menu.centerTransform } width={ menu.centerSize } height={ menu.centerSize }/>
													</g>
												}
											</fragment>
										)
									})}
								</svg>
							)
						})}
					</div>
				</transition>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './menu.scss';
</style>