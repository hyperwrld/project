(function(t){function e(e){for(var r,c,o=e[0],i=e[1],d=e[2],u=0,h=[];u<o.length;u++)c=o[u],Object.prototype.hasOwnProperty.call(n,c)&&n[c]&&h.push(n[c][0]),n[c]=0;for(r in i)Object.prototype.hasOwnProperty.call(i,r)&&(t[r]=i[r]);l&&l(e);while(h.length)h.shift()();return s.push.apply(s,d||[]),a()}function a(){for(var t,e=0;e<s.length;e++){for(var a=s[e],r=!0,o=1;o<a.length;o++){var i=a[o];0!==n[i]&&(r=!1)}r&&(s.splice(e--,1),t=c(c.s=a[0]))}return t}var r={},n={app:0},s=[];function c(e){if(r[e])return r[e].exports;var a=r[e]={i:e,l:!1,exports:{}};return t[e].call(a.exports,a,a.exports,c),a.l=!0,a.exports}c.m=t,c.c=r,c.d=function(t,e,a){c.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:a})},c.r=function(t){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},c.t=function(t,e){if(1&e&&(t=c(t)),8&e)return t;if(4&e&&"object"===typeof t&&t&&t.__esModule)return t;var a=Object.create(null);if(c.r(a),Object.defineProperty(a,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var r in t)c.d(a,r,function(e){return t[e]}.bind(null,r));return a},c.n=function(t){var e=t&&t.__esModule?function(){return t["default"]}:function(){return t};return c.d(e,"a",e),e},c.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},c.p="";var o=window["webpackJsonp"]=window["webpackJsonp"]||[],i=o.push.bind(o);o.push=e,o=o.slice();for(var d=0;d<o.length;d++)e(o[d]);var l=i;s.push([0,"chunk-vendors"]),a()})({0:function(t,e,a){t.exports=a("56d7")},"1b6c":function(t,e,a){},5533:function(t,e,a){"use strict";var r=a("bb72"),n=a.n(r);n.a},"56d7":function(t,e,a){"use strict";a.r(e);a("e260"),a("e6cf"),a("cca6"),a("a79d");var r=a("2b0e"),n=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("v-app",[a("cash"),a("hud"),t.isEnabled?a(t.currentComponent,{tag:"component"}):t._e(),t.isEnabled?a("dialogs"):t._e()],1)},s=[],c=a("5530"),o=(a("d3b7"),a("96cf"),a("1da1")),i={send:function(t){var e=arguments;return Object(o["a"])(regeneratorRuntime.mark((function a(){var r;return regeneratorRuntime.wrap((function(a){while(1)switch(a.prev=a.next){case 0:return r=e.length>1&&void 0!==e[1]?e[1]:{},a.next=3,fetch("http://crp-ui/".concat(t),{method:"post",headers:{"Content-type":"application/json; charset=UTF-8"},body:JSON.stringify(r)}).then((function(t){return t.json()}));case 3:return a.abrupt("return",a.sent);case 4:case"end":return a.stop()}}),a)})))()}},d=a("2f62"),l=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("v-container",[a("v-dialog",{attrs:{"content-class":"dialog","max-width":"350"},model:{value:t.dialogsData["deleteCharacter"].status,callback:function(e){t.$set(t.dialogsData["deleteCharacter"],"status",e)},expression:'dialogsData["deleteCharacter"].status'}},[a("v-card",[a("v-card-title",{staticClass:"headline"},[t._v("Tens a certeza que desejas apagar esta personagem?")]),a("v-card-actions",[a("v-spacer"),a("v-btn",{attrs:{color:"green darken-1",text:""},on:{click:function(e){return t.$store.dispatch("dialogs/setDialogStatus",{name:"deleteCharacter",status:!1})}}},[t._v(" Não ")]),a("v-btn",{attrs:{color:"green darken-1",text:""},on:{click:t.handleCharacterDeletion}},[t._v(" Sim ")])],1)],1)],1),a("v-dialog",{attrs:{"content-class":"dialog","max-width":"500"},model:{value:t.dialogsData["createCharacter"].status,callback:function(e){t.$set(t.dialogsData["createCharacter"],"status",e)},expression:'dialogsData["createCharacter"].status'}},[a("v-card",[a("v-card-title",[t._v(" Criação de Personagem ")]),a("v-divider"),a("v-card-text",[a("v-container",[a("v-row",[a("v-col",{attrs:{cols:"12",sm:"6"}},[a("v-text-field",{attrs:{label:"Primeiro nome",counter:"10",filled:""},model:{value:t.dialogsData["createCharacter"].data.firstname,callback:function(e){t.$set(t.dialogsData["createCharacter"].data,"firstname",e)},expression:'dialogsData["createCharacter"].data.firstname'}})],1),a("v-col",{attrs:{cols:"12",sm:"6"}},[a("v-text-field",{attrs:{label:"Último nome",counter:"10",filled:""},model:{value:t.dialogsData["createCharacter"].data.lastname,callback:function(e){t.$set(t.dialogsData["createCharacter"].data,"lastname",e)},expression:'dialogsData["createCharacter"].data.lastname'}})],1),a("v-col",{attrs:{cols:"12",sm:"6"}},[a("v-menu",{ref:"datePicker",attrs:{"close-on-content-click":!1,transition:"scale-transition","offset-y":"","min-width":"290px"},scopedSlots:t._u([{key:"activator",fn:function(e){var r=e.on,n=e.attrs;return[a("v-text-field",t._g(t._b({attrs:{label:"Data de nascimento",readonly:"",filled:""},model:{value:t.computedFormatDate,callback:function(e){t.computedFormatDate=e},expression:"computedFormatDate"}},"v-text-field",n,!1),r))]}}]),model:{value:t.dialogsData["createCharacter"].datePicker,callback:function(e){t.$set(t.dialogsData["createCharacter"],"datePicker",e)},expression:'dialogsData["createCharacter"].datePicker'}},[a("v-date-picker",{attrs:{"no-title":"",locale:"pt-pt",min:"1920-01-01",max:"2002-01-01",scrollable:""},model:{value:t.dialogsData["createCharacter"].data.dob,callback:function(e){t.$set(t.dialogsData["createCharacter"].data,"dob",e)},expression:'dialogsData["createCharacter"].data.dob'}},[a("v-spacer"),a("v-btn",{attrs:{text:"",color:"primary"},on:{click:function(e){t.dialogsData["createCharacter"].datePicker=!1}}},[t._v("Cancelar")]),a("v-btn",{attrs:{text:"",color:"primary"},on:{click:function(e){t.dialogsData["createCharacter"].datePicker=!1}}},[t._v("Salvar")])],1)],1)],1),a("v-col",{attrs:{cols:"12",sm:"6"}},[a("v-select",{attrs:{items:["Masculino","Feminino"],filled:"",label:"Sexo"},model:{value:t.dialogsData["createCharacter"].data.gender,callback:function(e){t.$set(t.dialogsData["createCharacter"].data,"gender",e)},expression:'dialogsData["createCharacter"].data.gender'}})],1),a("v-col",{attrs:{cols:"12"}},[a("v-textarea",{attrs:{filled:"","no-resize":"",counter:"500",label:"História"},model:{value:t.dialogsData["createCharacter"].data.story,callback:function(e){t.$set(t.dialogsData["createCharacter"].data,"story",e)},expression:'dialogsData["createCharacter"].data.story'}})],1)],1)],1)],1),a("v-divider"),a("v-card-actions",[a("v-spacer"),a("v-btn",{attrs:{color:"error",text:""},on:{click:function(e){return t.$store.dispatch("dialogs/setDialogStatus",{name:"createCharacter",status:!1})}}},[t._v("Fechar")]),a("v-btn",{attrs:{text:""},on:{click:t.handleCharacterCreation}},[t._v("Salvar")])],1)],1)],1)],1)},u=[],h=(a("99af"),a("ac1f"),a("1276"),a("3835")),m={name:"dialogs",computed:Object(c["a"])(Object(c["a"])({},Object(d["b"])({dialogsData:function(t){return t.dialogs.dialogsData}})),{},{computedFormatDate:function(){return this.formatDate(this.dialogsData["createCharacter"].data.dob)}}),methods:{handleCharacterDeletion:function(){this.$store.dispatch("dialogs/setDialogStatus",{name:"deleteCharacter",status:!1}),this.$store.dispatch("characterList/removeCharacter")},formatDate:function(t){if(!t)return null;var e=t.split("-"),a=Object(h["a"])(e,3),r=a[0],n=a[1],s=a[2];return"".concat(s,"/").concat(n,"/").concat(r)},handleCharacterCreation:function(){var t=this,e="",a=this.dialogsData["createCharacter"].data;!a.firstname||a.firstname.length>10||0==a.firstname.length?e="Escolha um primeiro nome entre 1 a 10 caracteres.":!a.lastname||a.lastname.length>10||0==a.lastname.length?e="Escolha um segundo nome entre 1 a 10 caracteres.":a.dob&&0!=a.dob.length?"Masculino"!=a.gender&&"Feminino"!=a.gender?e="Selecione o sexo do seu personagem.":(!a.story||a.story.length>500||a.story.length<100)&&(e="A história do seu personagem pode ter no mínimo 100 caracteres e no máximo 500 caracteres."):e="Selecione uma data de nascimento para o seupersonagem.",e.length>0?i.send("error",message):i.send("createCharacter",{firstname:a.firstname,lastname:a.lastname,dob:this.formatDate(a.dob),gender:a.gender,story:a.story}).then((function(e){e.status&&(t.$store.dispatch("dialogs/setDialogStatus",{name:"createCharacter",status:!1,reset:!0}),t.$store.dispatch("characterList/addCharacter",e.characterData))}))}}},v=m,f=a("2877"),g=a("6544"),p=a.n(g),b=a("8336"),C=a("b0af"),y=a("99d9"),D=a("62ad"),_=a("a523"),w=a("2e4b"),x=a("169a"),S=a("ce7e"),M=a("e449"),k=a("0fd9"),I=a("b974"),O=a("2fa4"),j=a("8654"),$=a("a844"),V=Object(f["a"])(v,l,u,!1,null,null,null),T=V.exports;p()(V,{VBtn:b["a"],VCard:C["a"],VCardActions:y["a"],VCardText:y["b"],VCardTitle:y["c"],VCol:D["a"],VContainer:_["a"],VDatePicker:w["a"],VDialog:x["a"],VDivider:S["a"],VMenu:M["a"],VRow:k["a"],VSelect:I["a"],VSpacer:O["a"],VTextField:j["a"],VTextarea:$["a"]});var E=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("v-container",{staticClass:"fill-height",attrs:{fluid:""}},[a("v-row",{staticStyle:{height:"fit-content"},attrs:{align:"center",justify:"center"}},[a("v-card",{staticClass:"mainMenu"},[a("v-card-text",{staticClass:"mainDiv"},[t.loadingData.status?a("div",{staticClass:"loading"},[a("div",{staticClass:"multi-ripple"},[a("div"),a("div")]),a("p",[t._v(t._s(t.loadingData.message))])]):a("div",{staticClass:"characterList"},t._l(t.charactersData,(function(e,r){return a("v-hover",{key:r,attrs:{item:e},scopedSlots:t._u([{key:"default",fn:function(n){var s=n.hover;return e.option?a("v-card",{staticClass:"character",class:[{active:t.currentItem==r},s?"on-hover":"not-hover"],attrs:{ripple:!1},on:{click:function(e){return t.handleChangeItem(r)}}},[a("v-card-text",{staticClass:"characterName"},[t._v(" "+t._s(e.name)+" ")])],1):a("v-card",{staticClass:"character",class:[{active:t.currentItem==r},s?"on-hover":"not-hover"],attrs:{ripple:!1},on:{click:function(e){return t.handleChangeItem(r)}}},[a("v-card-text",{staticClass:"characterName"},[t._v(" "+t._s(e.firstname+" "+e.lastname)+" ")]),t.currentItem===r?a("v-card-actions",[a("v-spacer"),a("v-btn",{attrs:{ripple:!1,icon:""},on:{click:function(e){t.isShowingInfo=!t.isShowingInfo}}},[t.isShowingInfo?a("font-awesome-icon",{attrs:{icon:"angle-up"}}):a("font-awesome-icon",{attrs:{icon:"angle-down"}})],1)],1):t._e()],1)}}],null,!0)})})),1)]),t.isShowingInfo?a("v-card-text",{staticClass:"characterInfo"},[a("div",{staticClass:"textBox"},[a("div",{staticStyle:{width:"50%",float:"left"}},[a("p",[a("b",[t._v("Nome:")]),t._v(" "+t._s(t.charactersData[t.currentItem].firstname+" "+t.charactersData[t.currentItem].lastname))]),a("p",[a("b",[t._v("Data de nascimento:")]),t._v(" "+t._s(t.charactersData[t.currentItem].dob))]),a("p",[a("b",[t._v("Sexo:")]),t._v(" "+t._s(t.charactersData[t.currentItem].gender))]),a("p",[a("b",[t._v("Profissão:")]),t._v(" "+t._s(JSON.parse(t.charactersData[t.currentItem].job).name))]),a("p",[a("b",[t._v("Dinheiro:")]),t._v(" "+t._s(t.charactersData[t.currentItem].money+"€"))]),a("p",[a("b",[t._v("Banco:")]),t._v(" "+t._s(t.charactersData[t.currentItem].bank+"€"))])]),a("div",{staticStyle:{width:"50%",float:"right"}},[a("p",[a("b",[t._v("História:")]),t._v(" "+t._s(t.charactersData[t.currentItem].story))]),a("p",[a("b",[t._v("Número de telemóvel:")]),t._v(" "+t._s(t.charactersData[t.currentItem].phone))])])])]):t._e(),a("v-card-actions",{staticClass:"buttons"},[a("v-btn",{staticClass:"disconnect",attrs:{depressed:""},on:{click:t.handleDisconnect}},[t._v("Desconectar")]),a("v-spacer"),t.loadingData.status||!t.charactersData[t.currentItem]||t.charactersData[t.currentItem].option?t.loadingData.status?t._e():a("div",[a("v-btn",{staticClass:"create",attrs:{depressed:""},on:{click:function(e){return t.$store.dispatch("dialogs/setDialogStatus",{name:"createCharacter",status:!0})}}},[t._v("Criar")])],1):a("div",[a("v-btn",{staticClass:"select",attrs:{depressed:""},on:{click:t.handleCharacterSelection}},[t._v("Selecionar")]),a("v-btn",{staticClass:"delete",attrs:{depressed:""},on:{click:function(e){return t.$store.dispatch("dialogs/setDialogStatus",{name:"deleteCharacter",status:!0})}}},[t._v("Apagar")])],1)],1)],1),a("v-card",{staticClass:"serverInfo",class:t.isShowingInfo?"bigger":"normal"},[a("v-card-text",[a("div",{staticClass:"post"},[a("h3",[t._v("Update 14/06/2020")]),a("v-divider"),a("p",[t._v("[RENDERING]"),a("br"),t._v("– Texture streaming now loads textures flagged with no mip maps or no lod at full initial resolution.")]),a("p",[t._v("[MAPS]"),a("br"),t._v("Chlorine"),a("br"),t._v("-Added missing glowy eyes texture")]),a("p",[t._v("Anubis "),a("br"),t._v("-Fixed many minor issues such as z fighting, prop reflections and invisible faces "),a("br"),t._v("-Improved player readability at canal "),a("br"),t._v("-Improved performance "),a("br"),t._v("-Redesigned B main path & entrance "),a("br"),t._v("-Moved up CT spawn")])],1),a("div",{staticClass:"post"},[a("h3",[t._v("Update 13/06/2020")]),a("v-divider"),a("p",[t._v("[GAMEPLAY]"),a("br"),t._v("– Added the ‘Boost Player Contrast’ advanced video setting, which improves the legibility of players in low contrast situations.")]),a("p",[t._v("[AGENTS]"),a("br"),t._v("– Adjusted some agent textures for improved visibility.")]),a("p",[t._v("[MISC]"),a("br"),t._v("– Adjusted dropped C4 collision geometry. "),a("br"),t._v("– Fixed Danger Zone drone pilot camera getting stuck when drone received burn damage. "),a("br"),t._v("– Added Desert Eagle shell eject event for last bullet fired.")])],1)])],1)],1)],1)},P=[],A={name:"character",computed:Object(c["a"])({},Object(d["b"])({charactersData:function(t){return t.character.userCharacters},currentItem:function(t){return t.character.currentItem},loadingData:function(t){return t.character.loading}})),methods:{handleDisconnect:function(){i.send({disconnect:!0})},handleChangeItem:function(t){this.currentItem!=t&&(this.isShowingInfo=!1,this.$store.dispatch("character/setCurrentItem",t))},handleCharacterSelection:function(){this.$store.dispatch("character/selectCharacter")}},data:function(){return{isShowingInfo:!1}}},N=A,q=(a("d8b5"),a("ce87")),F=Object(f["a"])(N,E,P,!1,null,"cdb4c4a8",null),L=F.exports;p()(F,{VBtn:b["a"],VCard:C["a"],VCardActions:y["a"],VCardText:y["b"],VContainer:_["a"],VDivider:S["a"],VHover:q["a"],VRow:k["a"],VSpacer:O["a"]});var B=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("v-container",{attrs:{fluid:""}},[t.canShow?a("transition",{attrs:{name:"fade"}},[a("div",{staticClass:"money"},[a("span",[t._v("€ ")]),t._v(t._s(t.formatNumber(t.currentMoney)))])]):t._e(),a("transition",{attrs:{name:"fade"}},[t.canShow&&t.changedMoney.status?a("div",{staticClass:"changedMney"},[a("span",{class:"add"==t.changedMoney.type?"add":"remove"},[t._v(t._s(("add"==t.changedMoney.type?"+":"-")+" €"))]),t._v(" "+t._s(t.formatNumber(t.changedMoney.quantity))+" ")]):t._e()])],1)},R=[],U=(a("25f0"),a("5319"),{name:"cash",computed:Object(c["a"])({},Object(d["b"])({canShow:function(t){return t.cash.canShow},currentMoney:function(t){return t.cash.currentMoney},changedMoney:function(t){return t.cash.changedMoney}})),methods:{formatNumber:function(t){return t.toString().replace(/\B(?=(\d{3})+(?!\d))/g," ")}}}),H=U,J=(a("5533"),Object(f["a"])(H,B,R,!1,null,"e8a197ac",null)),z=J.exports;p()(J,{VContainer:_["a"]});var G=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("v-container",{attrs:{fluid:""}},[a("div",{staticClass:"minimap",style:{top:t.top,left:t.left,width:t.width,height:t.height}},[a("div",{staticClass:"bar"},[a("div",{staticClass:"health"},[a("font-awesome-icon",{attrs:{icon:"heart"}}),a("div",{staticClass:"sub-health",style:{width:t.characterData["health"]}})],1),a("div",{staticClass:"armour"},[a("font-awesome-icon",{attrs:{icon:"shield-alt"}}),a("div",{staticClass:"sub-armour",style:{width:t.characterData["armour"]}})],1),a("div",{staticClass:"hunger"},[a("font-awesome-icon",{attrs:{icon:"hamburger"}}),a("div",{staticClass:"sub-hunger",style:{height:t.characterData["hunger"].value,top:t.characterData["hunger"].leftOver}})],1),a("div",{staticClass:"thirst"},[a("font-awesome-icon",{attrs:{icon:"tint"}}),a("div",{staticClass:"sub-thirst",style:{height:t.characterData["thirst"].value,top:t.characterData["thirst"].leftOver}})],1),a("div",{staticClass:"breath"},[a("font-awesome-icon",{attrs:{icon:"lungs"}}),a("div",{staticClass:"sub-breath",style:{height:t.characterData["breath"].value,top:t.characterData["breath"].leftOver}})],1),a("div",{staticClass:"stress"},[a("font-awesome-icon",{attrs:{icon:"brain"}}),a("div",{staticClass:"sub-stress",style:{height:t.characterData["stress"].value,top:t.characterData["stress"].leftOver}})],1)]),a("div",{staticClass:"vehicle-info"},[a("div",{staticClass:"time"}),a("div",{staticClass:"street"}),a("div",{staticClass:"others"})])])])},Y=[],W={name:"hud",computed:Object(c["a"])({},Object(d["b"])({characterData:function(t){return t.hud.characterData}})),methods:{},data:function(){return{top:"0px",left:"0px",width:"0px",height:"0px"}},destroyed:function(){window.removeEventListener("message",this.listener)},mounted:function(){var t=this;this.listener=window.addEventListener("message",(function(e){switch(e.data.eventName){case"setHudPosition":var a=window.innerWidth,r=window.innerHeight,n=e.data.topX,s=e.data.topY;t.top=s*r+"px",t.left=n*a+"px",t.width=.18888*r*1.41+"px",t.height=.18888*r+"px";break;case"updateData":t.$store.dispatch("hud/setCharacterData",e.data.status);break;default:break}}),!1)}},X=W,Z=(a("e75c"),Object(f["a"])(X,G,Y,!1,null,"59522867",null)),K=Z.exports;p()(Z,{VContainer:_["a"]});var Q={name:"app",components:{character:L,dialogs:T,cash:z,hud:K},computed:Object(c["a"])({},Object(d["b"])({charactersData:function(t){return t.character.userCharacters}})),data:function(){return{isEnabled:!0,currentComponent:"character"}},destroyed:function(){window.removeEventListener("message",this.listener)},mounted:function(){var t=this;this.listener=window.addEventListener("message",(function(e){switch(e.data.eventName){case"toggleMenu":"character"==e.data.component&&t.$store.dispatch("character/setUserCharacters"),t.isEnabled=e.data.status,t.currentComponent=e.data.component;break;case"setMoneyStatus":t.$store.dispatch("cash/setMoney",e.data.status);break;case"setMoney":t.$store.dispatch("cash/setMoney",e.data.money);break;case"removeMoney":t.$store.dispatch("cash/removeMoney",e.data.quantity);break;case"addMoney":t.$store.dispatch("cash/addMoney",e.data.quantity);break;case"closeMenu":t.isEnabled=!1;break;default:break}}),!1)}},tt=Q,et=(a("6294"),a("7496")),at=Object(f["a"])(tt,n,s,!1,null,null,null),rt=at.exports;p()(at,{VApp:et["a"]});var nt=a("f309");r["a"].use(nt["a"]);var st=new nt["a"]({}),ct=(a("b0c0"),function(){return{dialogsData:{deleteCharacter:{status:!1},createCharacter:{status:!1,data:{},datePicker:!1}}}}),ot={getDeleteCharacterStatus:function(t){return t.dialogsData["deleteCharacter"].status},getCreateCharacterStatus:function(t){return t.dialogsData["createCharacter"].status},getCreateCharacter:function(t){return t.dialogsData["createCharacter"]}},it={setDialogStatus:function(t,e){t.commit("setDialogStatus",e)}},dt={setDialogStatus:function(t,e){t.dialogsData[e.name]?t.dialogsData[e.name].status=e.status:t.dialogsData[e.name]={status:e.status},e.reset&&(t.dialogsData[e.name].data={})}},lt={namespaced:!0,state:ct,getters:ot,actions:it,mutations:dt},ut=(a("c975"),a("d81d"),function(){return{userCharacters:[],currentItem:0,loading:{status:!1,message:"Aguarde..."}}}),ht={getCharactersData:function(t){return t.userCharacters}},mt={setLoading:function(t,e){setTimeout((function(){t.commit("setLoading",e)}),e.time)},setUserCharacters:function(t){t.commit("setUserCharacters")},setCurrentItem:function(t,e){t.commit("setCurrentItem",e)},addCharacter:function(t,e){t.commit("addCharacter",e)},removeCharacter:function(t){t.commit("removeCharacter")},selectCharacter:function(t){t.commit("selectCharacter")}},vt={setLoading:function(t,e){t.loading={status:e.status,message:e.message}},setUserCharacters:function(t){t.loading={status:!0,message:"Aguarde enquanto carregamos os seus personagens..."},i.send("fetchCharacters").then((function(e){t.userCharacters=e;for(var a=t.userCharacters.length;a<5;a++)t.userCharacters.push({option:"create",name:"..."});setTimeout((function(){t.loading={status:!1}}),5e3)}))},setCurrentItem:function(t,e){t.currentItem=e},addCharacter:function(t,e){t.loading={status:!0,message:"Aguarde enquanto criamos o seu personagem..."};var a=t.userCharacters.map((function(t){return t.option}));t.userCharacters[a.indexOf("create")]=e,setTimeout((function(){t.loading={status:!1}}),3e3)},removeCharacter:function(t){t.loading={status:!0,message:"Aguarde enquanto tentamos eliminar o seu personagem..."},i.send("deleteCharacter",t.userCharacters[t.currentItem].id).then((function(e){e.status&&(t.userCharacters[t.currentItem]={option:"create",name:"..."}),setTimeout((function(){t.loading={status:!1}}),3e3)}))},selectCharacter:function(t){t.loading={status:!0,message:"Aguarde enquanto carregamos o seu personagem..."},i.send("selectCharacter",t.userCharacters[t.currentItem].id).then((function(){setTimeout((function(){t.loading={status:!1}}),2500)}))}},ft={namespaced:!0,state:ut,getters:ht,actions:mt,mutations:vt},gt=function(){return{canShow:!1,currentMoney:0,changedMoney:{status:!1,type:"remove",quantity:0}}},pt={setMoneyStatus:function(t,e){t.commit("setMoneyStatus",e)},setMoney:function(t,e){t.commit("setMoney",e)},removeMoney:function(t,e){t.commit("removeMoney",e)},addMoney:function(t,e){t.commit("addMoney",e)}},bt={setMoneyStatus:function(t,e){t.canShow=e},setMoney:function(t,e){t.currentMoney=e,t.canShow=!0,setTimeout((function(){t.canShow=!1}),15e3)},removeMoney:function(t,e){t.changedMoney={status:!0,type:"remove",quantity:e},t.currentMoney=t.currentMoney-e,t.canShow=!0,setTimeout((function(){t.changedMoney.status=!1,setTimeout((function(){t.canShow=!1}),1e3)}),5e3)},addMoney:function(t,e){t.changedMoney={status:!0,type:"add",quantity:e},t.currentMoney=t.currentMoney+e,t.canShow=!0,setTimeout((function(){t.changedMoney.status=!1,setTimeout((function(){t.canShow=!1}),1e3)}),5e3)}},Ct={namespaced:!0,state:gt,actions:pt,mutations:bt},yt=function(){return{isEnabled:!0,characterData:{health:"100%",armour:"100%",hunger:{value:"100%",leftOver:"0%"},thirst:{value:"100%",leftOver:"0%"},breath:{value:"100%",leftOver:"0%"},stress:{value:"100%",leftOver:"0%"}},isOnVehicle:!1}},Dt={setCharacterData:function(t,e){t.commit("setCharacterData",e)}},_t={setCharacterData:function(t,e){for(var a in e)t.characterData[a]="health"!=a&&"armour"!=a?{value:e[a]+"%",leftOver:100-e[a]+"%"}:e[a]+"%"}},wt={namespaced:!0,state:yt,actions:Dt,mutations:_t};r["a"].use(d["a"]);var xt=new d["a"].Store({modules:{dialogs:lt,character:ft,cash:Ct,hud:wt}}),St=a("ecee"),Mt=a("c074"),kt=a("ad3d");St["c"].add(Mt["b"],Mt["a"],Mt["e"],Mt["g"],Mt["d"],Mt["h"],Mt["f"],Mt["c"]),r["a"].component("font-awesome-icon",kt["a"]),r["a"].config.productionTip=!1,new r["a"]({vuetify:st,store:xt,render:function(t){return t(rt)}}).$mount("#app")},6294:function(t,e,a){"use strict";var r=a("6975"),n=a.n(r);n.a},6975:function(t,e,a){},a06e:function(t,e,a){},bb72:function(t,e,a){},d8b5:function(t,e,a){"use strict";var r=a("1b6c"),n=a.n(r);n.a},e75c:function(t,e,a){"use strict";var r=a("a06e"),n=a.n(r);n.a}});