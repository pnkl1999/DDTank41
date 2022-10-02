package bagAndInfo.info
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.PersonalInfoCell;
   import cardSystem.data.CardInfo;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.bagStore.BagStore;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.Experience;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TaskEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.StaticFormula;
   import ddt.view.academyCommon.academyIcon.AcademyIcon;
   import ddt.view.buff.BuffControl;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import im.IMController;
   import room.RoomManager;
   import shop.manager.ShopBuyManager;
   import texpSystem.view.TexpInfoTipArea;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import vip.VipController;   
   import gemstone.info.GemstListInfo;
   import gemstone.GemstoneManager;
   import bagAndInfo.bag.NecklacePtetrochemicalView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.image.Image;
   
   public class PlayerInfoView extends Sprite implements Disposeable
   {
       
      
      private var _info:PlayerInfo;
      
      private var _showSelfOperation:Boolean;
      
      private var _cellPos:Array;
      
      private var _honorNameTxt:FilterFrameText;
      
      private var _playerInfoEffortHonorView:PlayerInfoEffortHonorView;
      
      private var _nickNameTxt:FilterFrameText;
      
      private var _consortiaTxt:FilterFrameText;
      
      private var _dutyField:FilterFrameText;
      
      private var _storeBtn:BaseButton;
      
      private var _reputeField:FilterFrameText;
      
      private var _gesteField:FilterFrameText;
      
      private var _iconContainer:VBox;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _academyIcon:AcademyIcon;
      
      private var _badge:Badge;
      
      private var _bagDefinitionGroup:SelectedButtonGroup;
      
      private var _bagDefinitionBtnI:SelectedCheckButton;
      
      private var _bagDefinitionBtnII:SelectedCheckButton;
      
      private var _battle:FilterFrameText;
      
      private var _levelTxt:FilterFrameText;
      
      private var _hiddenControlsBg:Bitmap;
      
      private var _hideHatBtn:SelectedCheckButton;
      
      private var _hideGlassBtn:SelectedCheckButton;
      
      private var _hideSuitBtn:SelectedCheckButton;
      
      private var _hideWingBtn:SelectedCheckButton;
      
      private var _achvBtn:BaseButton;
      
      private var _achvLight:IEffect;
      
      private var _achvEnable:Boolean = true;
      
      private var _addFriendBtn:BaseButton;
      
      private var _buyAvatar:SimpleBitmapButton;
      
      private var _attackTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _defenceTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _attackButton:GlowPropButton;
      
      private var _agilityButton:GlowPropButton;
      
      private var _defenceButton:GlowPropButton;
      
      private var _luckButton:GlowPropButton;
      
      private var _damageTxt:FilterFrameText;
      
      private var _damageButton:PropButton;
      
      private var _armorTxt:FilterFrameText;
      
      private var _armorButton:PropButton;
      
      private var _HPText:FilterFrameText;
      
      private var _hpButton:PropButton;
      
      private var _vitality:FilterFrameText;
      
      private var _vitalityBuntton:PropButton;
      
      private var _textLevelPrpgress:FilterFrameText;
      
      private var _progressLevel:LevelProgress;
      
      private var _cellContent:Sprite;
      
      private var _character:RoomCharacter;
      
      private var _cells:Vector.<PersonalInfoCell>;
      
      private var _buff:BuffControl;
      
      private var _dragDropArea:PersonalInfoDragInArea;
      
      private var _offerLabel:Bitmap;
      
      private var _offerSourcePosition:Point;
      
      private var _vipName:GradientText;
      
      private var _showEquip:Sprite;
      
      private var _showCard:Sprite;
      
      private var _cardEquipView:CardEquipView;
      
      private var _bg:Bitmap;
      
      private var _characterSprite:TexpInfoTipArea;
      
      private var _switchShowII:Boolean = true;
	  
	  private var _openNecklacePtetrochemicalView:SimpleBitmapButton;
	  
	  private var _necklacePtetrochemicalView:NecklacePtetrochemicalView;
	  
	  private var _fineSuitIcon:Image;
      
      public function PlayerInfoView()
      {
         super();
         this.initView();
         this.initProperties();
         this.initPos();
         this.creatCells();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.personalInfoBgAsset");
         addChild(this._bg);
         this._dragDropArea = new PersonalInfoDragInArea();
         addChild(this._dragDropArea);
         this._showEquip = new Sprite();
         addChild(this._showEquip);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.bagAndInfo.iconContainer");
         this._showEquip.addChild(this._iconContainer);
         this._showCard = new Sprite();
         addChild(this._showCard);
         this._showCard.visible = false;
         this._honorNameTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNameText");
         if(PathManager.solveAchieveEnable())
         {
            addChild(this._honorNameTxt);
         }
         this._honorNameTxt.setTextFormat(this._honorNameTxt.getTextFormat());
         this._nickNameTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNickNameText");
         this._consortiaTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewConsortiaText");
         addChild(this._consortiaTxt);
         this._battle = ComponentFactory.Instance.creatComponentByStylename("personInfoViewBattleText");
         this._showEquip.addChild(this._battle);
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLevelText");
         this._showEquip.addChild(this._levelTxt);
         this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("LevelProgress");
         this._showEquip.addChild(this._progressLevel);
         this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressLevel.tipDirctions = "3,7,6";
         this._progressLevel.tipGapV = 4;
         this._bagDefinitionBtnI = ComponentFactory.Instance.creat("bag.DefinitionBtnI");
         addChild(this._bagDefinitionBtnI);
         this._bagDefinitionBtnII = ComponentFactory.Instance.creat("bag.DefinitionBtnII");
         addChild(this._bagDefinitionBtnII);
         this._bagDefinitionGroup = new SelectedButtonGroup();
         this._bagDefinitionGroup.addSelectItem(this._bagDefinitionBtnI);
         this._bagDefinitionGroup.addSelectItem(this._bagDefinitionBtnII);
         this._bagDefinitionBtnI.visible = false;
         this._bagDefinitionBtnII.visible = false;
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAttackText");
         addChild(this._attackTxt);
         this._attackButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.AttackButton");
         this._attackButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.attact");
         this._attackButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.attactDetail");
         ShowTipManager.Instance.addTip(this._attackButton);
         addChild(this._attackButton);
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAgilityText");
         addChild(this._agilityTxt);
         this._agilityButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.AgilityButton");
         this._agilityButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.agility");
         this._agilityButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.agilityDetail");
         ShowTipManager.Instance.addTip(this._agilityButton);
         addChild(this._agilityButton);
         this._defenceTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDefenceText");
         addChild(this._defenceTxt);
         this._defenceButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.DefenceButton");
         this._defenceButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.defense");
         this._defenceButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.defenseDetail");
         ShowTipManager.Instance.addTip(this._defenceButton);
         addChild(this._defenceButton);
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLuckText");
         addChild(this._luckTxt);
         this._luckButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.LuckButton");
         this._luckButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.luck");
         this._luckButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.luckDetail");
         ShowTipManager.Instance.addTip(this._luckButton);
         addChild(this._luckButton);
         this._damageTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDamageText");
         addChild(this._damageTxt);
         this._damageButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.DamageButton");
         this._damageButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.damage");
         this._damageButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.damageDetail");
         ShowTipManager.Instance.addTip(this._damageButton);
         addChild(this._damageButton);
         this._armorTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewArmorText");
         addChild(this._armorTxt);
         this._armorButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.ArmorButton");
         this._armorButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.recovery");
         this._armorButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryDetail");
         ShowTipManager.Instance.addTip(this._armorButton);
         addChild(this._armorButton);
         this._HPText = ComponentFactory.Instance.creatComponentByStylename("personInfoViewHPText");
         addChild(this._HPText);
         this._hpButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.HPButton");
         this._hpButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.hp");
         this._hpButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpDetail");
         ShowTipManager.Instance.addTip(this._hpButton);
         addChild(this._hpButton);
         this._vitality = ComponentFactory.Instance.creatComponentByStylename("personInfoViewVitalityText");
         addChild(this._vitality);
         this._vitalityBuntton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.VitalityButton");
         this._vitalityBuntton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.energy");
         this._vitalityBuntton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.energyDetail");
         ShowTipManager.Instance.addTip(this._vitalityBuntton);
         addChild(this._vitalityBuntton);
         this._storeBtn = ComponentFactory.Instance.creatComponentByStylename("personInfoViewStoreButton");
         this._storeBtn.tipData = LanguageMgr.GetTranslation("tank.view.shortcutforge.tip");
         addChild(this._storeBtn);
         this._hiddenControlsBg = ComponentFactory.Instance.creatBitmap("asset.shop.HiddenControlsBg");
         this._showEquip.addChild(this._hiddenControlsBg);
         this._hiddenControlsBg.x = 321;
         this._hiddenControlsBg.y = 285;
         this._hideGlassBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         this._showEquip.addChild(this._hideGlassBtn);
         this._hideHatBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideGlassCheckBox");
         this._showEquip.addChild(this._hideHatBtn);
         this._hideSuitBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideSuitCheckBox");
         this._showEquip.addChild(this._hideSuitBtn);
         this._hideWingBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideWingCheckBox");
         this._showEquip.addChild(this._hideWingBtn);
         this._achvBtn = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAchvButton");
         if(PathManager.solveAchieveEnable())
         {
            this._showEquip.addChild(this._achvBtn);
         }
         this._achvLight = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._achvBtn,"bagAndInfo.info.achvBtnAsset","asset.core.lightII_mc",new Point(0,0),new Point(3,1));
         if(TaskManager.achievementQuest && TaskManager.achievementQuest.data && TaskManager.achievementQuest.data.progress[0] <= 0 && this._info is SelfInfo)
         {
            this._achvLight.play();
         }
         else
         {
            this._achvLight.stop();
         }
         this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAddFriendButton");
         addChild(this._addFriendBtn);
         this._buyAvatar = ComponentFactory.Instance.creatComponentByStylename("personInfoView.buyAvatarBtn");
         this._showEquip.addChild(this._buyAvatar);
         this._cellContent = new Sprite();
         this._showEquip.addChild(this._cellContent);
         this._playerInfoEffortHonorView = new PlayerInfoEffortHonorView();
         if(PathManager.solveAchieveEnable())
         {
            addChild(this._playerInfoEffortHonorView);
         }
         this._buff = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.buff");
         this._showEquip.addChild(this._buff);
         this._reputeField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.ReputeField");
         addChild(this._reputeField);
         this._gesteField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.GesteField");
         addChild(this._gesteField);
         this._offerLabel = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.OfferLabel");
         addChild(this._offerLabel);
         this._offerSourcePosition = new Point(this._offerLabel.x,this._offerLabel.y);
         this._dutyField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.DutyField");
         addChild(this._dutyField);
		 this._openNecklacePtetrochemicalView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.OpenBtn");
		 //ExternalInterface.call("console.log", "openNecklace", _openNecklacePtetrochemicalView);
		 //ExternalInterface.call("console.log", "NecklaceEnable", PathManager.NecklaceEnable);
		 if(!PathManager.NecklaceEnable)
		 {
			 this._openNecklacePtetrochemicalView.x = 999;
			 this._openNecklacePtetrochemicalView.y = 999;
		 }
		 addChild(this._openNecklacePtetrochemicalView);
		 
		 this._fineSuitIcon = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.Icon");
		 this._showEquip.addChild(this._fineSuitIcon);
      }
      
      private function __createCardView(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CARD_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createCardView);
            this.createCardEquip();
         }
      }
      
      private function createCardEquip() : void
      {
         try
         {
            this._cardEquipView = ComponentFactory.Instance.creatCustomObject("cardEquipView");
            this._showCard.addChild(this._cardEquipView);
            if(this._info)
            {
               this._cardEquipView.playerInfo = this._info;
            }
            this._cardEquipView.clickEnable = this._switchShowII;
            return;
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CARD_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createCardView);
            return;
         }
      }
      
      public function switchShow(param1:Boolean) : void
      {
         this._showEquip.visible = !param1;
         if(param1 && this._cardEquipView == null)
         {
            this.createCardEquip();
         }
         this._showCard.visible = param1;
		 if(this._showSelfOperation && this._showEquip.visible)
		 {
			 this._openNecklacePtetrochemicalView.visible = true;
		 }
		 else
		 {
			 this._openNecklacePtetrochemicalView.visible = false;
		 }
      }
      
      public function cardEquipShine(param1:CardInfo) : void
      {
         if(param1.templateInfo.Property8 == "1")
         {
            this._cardEquipView.shineMain();
         }
         else
         {
            this._cardEquipView.shineVice();
         }
      }
      
      public function switchShowII(param1:Boolean) : void
      {
         this._switchShowII = !param1;
         this.switchShow(param1);
         if(this._cardEquipView)
         {
            this._cardEquipView.clickEnable = this._showSelfOperation;
         }
         this._addFriendBtn.visible = !param1;
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this._addFriendBtn.visible = false;
         }
      }
      
      private function initProperties() : void
      {
         this._storeBtn.transparentEnable = true;
         this._hideHatBtn.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
         this._hideGlassBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
         this._hideSuitBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
         this._hideWingBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
      }
      
      private function initPos() : void
      {
         this._cellPos = [ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos1"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos2"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos3"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos4"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos5"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos6"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos7"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos8"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos9"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos10"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos11"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos12"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos13"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos14"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos15"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos16"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos17"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos18"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos19")];
      }
      
      private function initEvents() : void
      {
         this._storeBtn.addEventListener(MouseEvent.CLICK,this.__storeBtnClickHandler);
         this._achvBtn.addEventListener(MouseEvent.CLICK,this.__achvBtnClickHandler);
         this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__addFriendClickHandler);
         this._buyAvatar.addEventListener(MouseEvent.CLICK,this.__buyAvatarClickHandler);
         this._hideGlassBtn.addEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.addEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.addEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.addEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         TaskManager.addEventListener(TaskEvent.CHANGED,this.__lightPlay);
         this._bagDefinitionGroup.addEventListener(Event.CHANGE,this._definitionGroupChange);
		 this._openNecklacePtetrochemicalView.addEventListener(MouseEvent.CLICK,this.__openNecklacePtetrochemicalView);
      }
      
      private function removeEvent() : void
      {
         this._storeBtn.removeEventListener(MouseEvent.CLICK,this.__storeBtnClickHandler);
         this._achvBtn.removeEventListener(MouseEvent.CLICK,this.__achvBtnClickHandler);
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__addFriendClickHandler);
         this._buyAvatar.removeEventListener(MouseEvent.CLICK,this.__buyAvatarClickHandler);
         this._hideGlassBtn.removeEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.removeEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.removeEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.removeEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         if(this._info)
         {
            this._info.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCells);
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
         }
         TaskManager.removeEventListener(TaskEvent.CHANGED,this.__lightPlay);
         PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
         this._bagDefinitionGroup.removeEventListener(Event.CHANGE,this._definitionGroupChange);
		 this._openNecklacePtetrochemicalView.removeEventListener(MouseEvent.CLICK,this.__openNecklacePtetrochemicalView);
      }
      
      private function __lightPlay(param1:TaskEvent) : void
      {
         if(!this.showSelfOperation || !(this._info is SelfInfo) || this._info.ZoneID != PlayerManager.Instance.Self.ZoneID && this._info.ZoneID != 0)
         {
            return;
         }
         if(TaskManager.achievementQuest.data && TaskManager.achievementQuest.data.progress[0] <= 0)
         {
            this._achvLight.play();
         }
         else
         {
            this._achvLight.stop();
         }
      }
      
      private function __storeBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            if(PlayerManager.Instance.Self.Grade < 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
               return;
            }
         }
         BagStore.instance.show();
         BagStore.instance.isFromBagFrame = true;
      }
      
      private function __achvBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._info && PlayerManager.Instance.Self.ID != this._info.ID)
         {
            EffortManager.Instance.lookUpEffort(this._info.ID);
         }
         else if(!EffortManager.Instance.getMainFrameVisible())
         {
            EffortManager.Instance.isSelf = true;
            EffortManager.Instance.switchVisible();
         }
         BagAndInfoManager.Instance.hideBagAndInfo();
         PlayerInfoViewControl.closeView();
      }
      
      private function __addFriendClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.addFriend(this._info.NickName);
      }
      
      private function __buyAvatarClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ShopBuyManager.Instance.buyAvatar(this._info);
      }
      
      private function __hideGlassClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.GLASS,this._hideGlassBtn.selected);
      }
      
      private function __hideHatClickHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.HEAD,this._hideHatBtn.selected);
      }
      
      private function __hideSuitClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.SUITS,this._hideSuitBtn.selected);
      }
      
      private function __hideWingClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.WING,this._hideWingBtn.selected);
      }
      
      private function creatCells() : void
      {
         var _loc2_:PersonalInfoCell = null;
         this._cells = new Vector.<PersonalInfoCell>();
         var _loc1_:int = 0;
         while(_loc1_ < 19)
         {
            _loc2_ = CellFactory.instance.createPersonalInfoCell(_loc1_) as PersonalInfoCell;
            _loc2_.addEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
            _loc2_.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
            _loc2_.x = this._cellPos[_loc1_].x;
            _loc2_.y = this._cellPos[_loc1_].y;
            this._cellContent.addChild(_loc2_);
            this._cells.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function clearCells() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._cells.length)
         {
            if(this._cells[_loc1_])
            {
               this._cells[_loc1_].removeEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
               this._cells[_loc1_].removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
               if(this._cells[_loc1_].parent)
               {
                  this._cells[_loc1_].parent.removeChild(this._cells[_loc1_] as PersonalInfoCell);
               }
               this._cells[_loc1_].dispose();
               this._cells[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      public function set info(param1:PlayerInfo) : void
      {
		 PlayerInfoViewControl.currentPlayer = param1;
         if(this._info == param1)
         {
            return;
         }
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
            this._info.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCells);
            this._info = null;
         }
         this._info = param1;
         if(this._info)
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
            this._info.Bag.addEventListener(BagEvent.UPDATE,this.__updateCells);
            if(this._cardEquipView)
            {
               this._cardEquipView.playerInfo = this._info;
            }
         }
         this.updateView();
      }
      
      private function __changeHandler(param1:PlayerPropertyEvent) : void
      {
         this.updatePersonInfo();
         this.updateHide();
         this.updateIcons();
         if(this._info && this._characterSprite)
         {
            this._characterSprite.info = this._info;
         }
      }
      
      private function __upVip(param1:Event) : void
      {
         this.__changeHandler(null);
      }
      
      private function __updateCells(param1:BagEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1.changedSlots)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ <= BagInfo.PERSONAL_EQUIP_COUNT)
            {
               this._cells[_loc3_].info = this._info.Bag.getItemAt(_loc3_);
            }
			if(GemstoneManager.Instance.getByPlayerInfoList(_loc3_,this._info.ID))
			{
				if(this._cells[_loc3_].info)
				{
					(this._cells[_loc3_].info as InventoryItemInfo).gemstoneList = GemstoneManager.Instance.getByPlayerInfoList(_loc3_,this._info.ID);
				}
			}
         }
      }
      
      private function __cellClickHandler(param1:CellEvent) : void
      {
         var _loc2_:PersonalInfoCell = null;
         if(this._showSelfOperation)
         {
            _loc2_ = param1.data as PersonalInfoCell;
            _loc2_.dragStart();
         }
      }
      
      private function __cellDoubleClickHandler(param1:CellEvent) : void
      {
         var _loc2_:PersonalInfoCell = null;
         var _loc3_:InventoryItemInfo = null;
         if(this._showSelfOperation)
         {
            _loc2_ = param1.data as PersonalInfoCell;
            if(_loc2_ && _loc2_.info)
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,-1,_loc3_.Count);
            }
         }
      }
      
      private function updateView() : void
      {
         this.updateCharacter();
         this.updateCells();
         this.updatePersonInfo();
         this.updateHide();
         this.updateIcons();
         this.updateShowOperation();
      }
      
      private function updateHide() : void
      {
         if(this._info)
         {
            this._hideGlassBtn.selected = this._info.getGlassHide();
            this._hideHatBtn.selected = this._info.getHatHide();
            this._hideSuitBtn.selected = this._info.getSuitesHide();
            this._hideWingBtn.selected = this._info.wingHide;
         }
      }
      
      private function updateCharacter() : void
      {
         if(this._info)
         {
            if(this._character)
            {
               this._character.dispose();
               this._character = null;
            }
            this._character = CharactoryFactory.createCharacter(this._info,"room") as RoomCharacter;
            this._character.showGun = false;
            this._character.show(false,-1);
            this._character.x = 267;
            this._character.y = 121;
            this._showEquip.addChildAt(this._character,0);
            if(!this._characterSprite)
            {
               this._characterSprite = new TexpInfoTipArea();
               this._characterSprite.x = this._character.x;
               this._characterSprite.y = this._character.y;
               this._characterSprite.scaleX = -1;
               this._showEquip.addChildAt(this._characterSprite,0);
            }
            this._characterSprite.info = this._info;
         }
         else
         {
            this._character.dispose();
            this._character = null;
            ObjectUtils.disposeObject(this._characterSprite);
            this._characterSprite = null;
         }
      }
      
      private function updateCells() : void
      {
         var _loc1_:PersonalInfoCell = null;
		 var _loc2_:InventoryItemInfo = null;
         for each(_loc1_ in this._cells)
         {
			 _loc2_ = this._info.Bag.getItemAt(_loc1_.place);
            _loc1_.info = this._info == null ? null : _loc2_;//this._info.Bag.getItemAt(_loc1_.place);
			if(_loc2_)
			{
				_loc2_.gemstoneList = GemstoneManager.Instance.getByPlayerInfoList(_loc1_.place,this._info.ID);
			}
         }
		 if(PlayerManager.Instance.Self.Bag.items[12])
		 {
			 if(!this._openNecklacePtetrochemicalView.parent)
			 {
				 addChild(this._openNecklacePtetrochemicalView);
			 }
		 }
		 else if(this._openNecklacePtetrochemicalView.parent)
		 {
			 this._openNecklacePtetrochemicalView.parent.removeChild(this._openNecklacePtetrochemicalView);
		 }
      }
      
      public function allowLvIconClick() : void
      {
         if(this._levelIcon)
         {
            this._levelIcon.allowClick();
         }
      }
      
      private function updateIcons() : void
      {
         var _loc1_:int = 0;
         if(this._info)
         {
            if(this._levelIcon == null)
            {
               this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.levelIcon");
            }
            this._levelIcon.setSize(LevelIcon.SIZE_BIG);
            _loc1_ = 1;
            if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               _loc1_ = GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) == null ? int(int(-1)) : int(int(GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team));
            }
            this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false,_loc1_);
            this._showEquip.addChild(this._levelIcon);
            if(this._info.ID == PlayerManager.Instance.Self.ID || this._info.IsVIP)
            {
               if(this._vipIcon == null)
               {
                  this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.VipIcon");
                  this._iconContainer.addChild(this._vipIcon);
               }
               this._vipIcon.setInfo(this._info);
               if(!this._info.IsVIP)
               {
                  this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               }
               else
               {
                  this._vipIcon.filters = null;
               }
            }
            else if(this._vipIcon)
            {
               this._vipIcon.dispose();
               this._vipIcon = null;
            }
            if(this._info.SpouseID > 0)
            {
               if(this._marriedIcon == null)
               {
                  this._marriedIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.MarriedIcon");
               }
               this._marriedIcon.tipData = {
                  "nickName":this._info.SpouseName,
                  "gender":this._info.Sex
               };
               this._iconContainer.addChild(this._marriedIcon);
            }
            else if(this._marriedIcon)
            {
               this._marriedIcon.dispose();
               this._marriedIcon = null;
            }
            if(this._info.shouldShowAcademyIcon() && this.getShowAcademyIcon())
            {
               if(this._academyIcon == null)
               {
                  this._academyIcon = ComponentFactory.Instance.creatCustomObject("bagAndInfo.AcademyIcon");
                  this._academyIcon.tipData = this._info;
                  this._academyIcon.visible = true;
                  this._iconContainer.addChild(this._academyIcon);
               }
            }
            else if(this._academyIcon)
            {
               this._academyIcon.dispose();
               this._academyIcon = null;
            }
            if(this._info.ConsortiaID > 0 && this._info.badgeID > 0)
            {
               if(this._badge == null)
               {
                  this._badge = new Badge();
                  this._badge.badgeID = this._info.badgeID;
                  this._badge.showTip = true;
                  this._badge.tipData = this._info.ConsortiaName;
                  this._iconContainer.addChild(this._badge);
               }
            }
            else if(this._badge)
            {
               this._badge.dispose();
               this._badge = null;
            }
			if(this._fineSuitIcon)
			{
				this._fineSuitIcon.tipData = this._info.fineSuitExp;
			}
         }
         else
         {
            if(this._levelIcon)
            {
               this._levelIcon.dispose();
               this._levelIcon = null;
            }
            if(this._vipIcon)
            {
               this._vipIcon.dispose();
               this._vipIcon = null;
            }
            if(this._marriedIcon)
            {
               this._marriedIcon.dispose();
               this._marriedIcon = null;
            }
            if(this._academyIcon)
            {
               this._academyIcon.dispose();
               this._academyIcon = null;
            }
            if(this._badge)
            {
               this._badge.dispose();
               this._badge = null;
            }
         }
      }
      
      private function updatePersonInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._info == null)
         {
            return;
         }
         this._reputeField.text = this._info == null ? "" : this._info.Repute.toString();
         this._gesteField.text = this._info == null ? "" : this._info.Offer.toString();
         this._dutyField.text = this._info.DutyName == null || this._info.DutyName == "" ? "" : (this._info.ConsortiaID > 0 ? "< " + this._info.DutyName + " >" : "");
         this._honorNameTxt.text = this._info.honor == null ? "" : this._info.honor;
         this._nickNameTxt.text = this._info.NickName == null ? "" : this._info.NickName;
         if(this._info.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(114,this._info.typeVIP);
            this._vipName.x = this._nickNameTxt.x;
            this._vipName.y = this._nickNameTxt.y;
            this._vipName.text = this._nickNameTxt.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._nickNameTxt);
         }
         else
         {
            addChild(this._nickNameTxt);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._consortiaTxt.text = this._info.ConsortiaName == null ? "" : (this._info.ConsortiaID > 0 ? this._info.ConsortiaName : "");
         this._dutyField.x = this._consortiaTxt.x + this._consortiaTxt.width + 6;
         if(this._info.ConsortiaID > 0 && this._dutyField.x + this._dutyField.width > this._offerSourcePosition.x)
         {
            this._offerLabel.x = this._dutyField.x + this._dutyField.width;
         }
         else
         {
            this._offerLabel.x = this._offerSourcePosition.x + 32;
         }
         this._gesteField.x = this._offerLabel.x + this._offerLabel.width + 4;
         this._offerLabel.visible = this._gesteField.visible = this._info.ID == PlayerManager.Instance.Self.ID;
         this._levelTxt.text = this._info == null ? "" : this._info.Grade.toString();
         if(this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._attackTxt.htmlText = this.getHtmlTextByString(String(this._info.Attack <= 0 ? "" : this._info.Attack),0);
            this._defenceTxt.htmlText = this.getHtmlTextByString(String(this._info.Defence <= 0 ? "" : this._info.Defence),0);
            this._agilityTxt.htmlText = this.getHtmlTextByString(String(this._info.Agility <= 0 ? "" : this._info.Agility),0);
            this._luckTxt.htmlText = this.getHtmlTextByString(String(this._info.Luck <= 0 ? "" : this._info.Luck),0);
            this._damageTxt.htmlText = this.getHtmlTextByString(String(Math.round(StaticFormula.getDamage(this._info)) <= 0 ? "" : Math.round(StaticFormula.getDamage(this._info))),1);
            this._armorTxt.htmlText = this.getHtmlTextByString(String(StaticFormula.getRecovery(this._info) <= 0 ? "" : StaticFormula.getRecovery(this._info)),1);
            this._HPText.htmlText = this.getHtmlTextByString(String(StaticFormula.getMaxHp(this._info)),1);
            this._vitality.htmlText = this.getHtmlTextByString(String(StaticFormula.getEnergy(this._info) <= 0 ? "" : StaticFormula.getEnergy(this._info)),1);
            if(this._info.isSelf)
            {
               this._battle.htmlText = this.getHtmlTextByString(String(this._info.FightPower),2);
            }
            else if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               if(GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) != null && GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team == GameManager.Instance.Current.selfGamePlayer.team)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else
               {
                  this._battle.htmlText = "";
               }
            }
         }
         else
         {
            if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               if(RoomManager.Instance.current.selfRoomPlayer.playerInfo.ID == this._info.ID)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else if(GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) != null && GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team == GameManager.Instance.Current.selfGamePlayer.team)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else
               {
                  this._battle.htmlText = "";
               }
            }
            else
            {
               this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
            }
            this._attackTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Attack < 0 ? 0 : this._info.Attack),0);
            this._agilityTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Agility < 0 ? 0 : this._info.Agility),0);
            this._defenceTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Defence < 0 ? 0 : this._info.Defence),0);
            this._luckTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Luck < 0 ? 0 : this._info.Luck),0);
            this._damageTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(Math.round(StaticFormula.getDamage(this._info))),1);
            this._armorTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getRecovery(this._info)),1);
            this._HPText.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getMaxHp(this._info)),1);
            this._vitality.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getEnergy(this._info)),1);
         }
         if(this._info)
         {
            this._progressLevel.setProgress(Experience.getExpPercent(this._info.Grade,this._info.GP) * 100,100);
            _loc1_ = Experience.expericence[this._info.Grade] - Experience.expericence[this._info.Grade - 1];
            _loc2_ = this._info.GP - Experience.expericence[this._info.Grade - 1];
            _loc2_ = _loc2_ > _loc1_ ? int(int(_loc1_)) : int(int(_loc2_));
            if(StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
            {
               this._progressLevel.tipData = "0/" + _loc1_;
            }
            else if(_loc2_ > 0 && this._info.Grade < 50)
            {
               this._progressLevel.tipData = _loc2_ + "/" + _loc1_;
            }
            else if(this._info.Grade == 50)
            {
               this._progressLevel.tipData = "0/1";
            }
            else
            {
               this._progressLevel.tipData = "0/" + _loc1_;
            }
         }
         if(this._info && this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this._definitionGroupChange();
         }
      }
      
      private function getHtmlTextByString(param1:String, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         switch(param2)
         {
            case 0:
               _loc3_ = "<TEXTFORMAT LEADING=\'2\'><P ALIGN=\'CENTER\'><FONT FACE=\'Arial\' SIZE=\'15\' COLOR=\'#000000\' LETTERSPACING=\'0\' KERNING=\'0\'><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
               break;
            case 1:
               _loc3_ = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'Tahoma\' SIZE=\'14\' COLOR=\'#fff4ba\' LETTERSPACING=\'0\' KERNING=\'1\'><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
               break;
            case 2:
               _loc3_ = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'Tahoma\' SIZE=\'14\' COLOR=\'#fff000\' LETTERSPACING=\'0\' KERNING=\'1\'><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
         }
         return _loc3_ + param1 + _loc4_;
      }
      
      public function dispose() : void
      {
         EffectManager.Instance.removeEffect(this._achvLight);
         this._achvLight = null;
         this.removeEvent();
         this.clearCells();
         if(parent)
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._attackTxt);
         this._attackTxt = null;
         ObjectUtils.disposeObject(this._agilityTxt);
         this._agilityTxt = null;
         ObjectUtils.disposeObject(this._defenceTxt);
         this._defenceTxt = null;
         ObjectUtils.disposeObject(this._luckTxt);
         this._luckTxt = null;
         ObjectUtils.disposeObject(this._damageTxt);
         this._damageTxt = null;
         ObjectUtils.disposeObject(this._armorTxt);
         this._armorTxt = null;
         ObjectUtils.disposeObject(this._HPText);
         this._HPText = null;
         ObjectUtils.disposeObject(this._vitality);
         this._vitality = null;
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
         if(this._attackButton)
         {
            ShowTipManager.Instance.removeTip(this._attackButton);
            ObjectUtils.disposeObject(this._attackButton);
            this._attackButton = null;
         }
         if(this._agilityButton)
         {
            ShowTipManager.Instance.removeTip(this._agilityButton);
            ObjectUtils.disposeObject(this._agilityButton);
            this._agilityButton = null;
         }
         if(this._defenceButton)
         {
            ShowTipManager.Instance.removeTip(this._defenceButton);
            ObjectUtils.disposeObject(this._defenceButton);
            this._defenceButton = null;
         }
         if(this._luckButton)
         {
            ShowTipManager.Instance.removeTip(this._luckButton);
            ObjectUtils.disposeObject(this._luckButton);
            this._luckButton = null;
         }
         if(this._damageButton)
         {
            ShowTipManager.Instance.removeTip(this._damageButton);
            ObjectUtils.disposeObject(this._damageButton);
            this._damageButton = null;
         }
         if(this._armorButton)
         {
            ShowTipManager.Instance.removeTip(this._armorButton);
            ObjectUtils.disposeObject(this._armorButton);
            this._armorButton = null;
         }
         if(this._hpButton)
         {
            ShowTipManager.Instance.removeTip(this._hpButton);
            ObjectUtils.disposeObject(this._hpButton);
            this._hpButton = null;
         }
         if(this._vitalityBuntton)
         {
            ShowTipManager.Instance.removeTip(this._vitalityBuntton);
            ObjectUtils.disposeObject(this._vitalityBuntton);
            this._vitalityBuntton = null;
         }
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._academyIcon);
         this._academyIcon = null;
         if(this._buff)
         {
            this._buff.dispose();
         }
         this._buff = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._showEquip);
         this._showEquip = null;
         ObjectUtils.disposeObject(this._showCard);
         this._showCard = null;
         ObjectUtils.disposeObject(this._cardEquipView);
         this._cardEquipView = null;
         ObjectUtils.disposeObject(this._honorNameTxt);
         this._honorNameTxt = null;
         ObjectUtils.disposeObject(this._nickNameTxt);
         this._nickNameTxt = null;
         ObjectUtils.disposeObject(this._consortiaTxt);
         this._consortiaTxt = null;
         ObjectUtils.disposeObject(this._battle);
         this._battle = null;
         ObjectUtils.disposeObject(this._levelTxt);
         this._levelTxt = null;
         ObjectUtils.disposeObject(this._attackTxt);
         this._attackTxt = null;
         ObjectUtils.disposeObject(this._agilityTxt);
         this._agilityTxt = null;
         ObjectUtils.disposeObject(this._defenceTxt);
         this._defenceTxt = null;
         ObjectUtils.disposeObject(this._luckTxt);
         this._luckTxt = null;
         ObjectUtils.disposeObject(this._character);
         this._character = null;
         ObjectUtils.disposeObject(this._characterSprite);
         this._characterSprite = null;
         ObjectUtils.disposeObject(this._progressLevel);
         this._progressLevel = null;
         ObjectUtils.disposeObject(this._reputeField);
         this._reputeField = null;
         ObjectUtils.disposeObject(this._gesteField);
         this._gesteField = null;
         ObjectUtils.disposeObject(this._dutyField);
         this._dutyField = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._marriedIcon);
         this._marriedIcon = null;
         if(this._hiddenControlsBg)
         {
            ObjectUtils.disposeObject(this._hiddenControlsBg);
         }
         this._hiddenControlsBg = null;
         ObjectUtils.disposeObject(this._hideGlassBtn);
         this._hideGlassBtn = null;
         ObjectUtils.disposeObject(this._hideHatBtn);
         this._hideHatBtn = null;
         ObjectUtils.disposeObject(this._hideSuitBtn);
         this._hideSuitBtn = null;
         ObjectUtils.disposeObject(this._hideWingBtn);
         this._hideWingBtn = null;
         ObjectUtils.disposeObject(this._storeBtn);
         this._storeBtn = null;
         ObjectUtils.disposeObject(this._achvBtn);
         this._achvBtn = null;
         ObjectUtils.disposeObject(this._addFriendBtn);
         this._addFriendBtn = null;
         ObjectUtils.disposeObject(this._buyAvatar);
         this._buyAvatar = null;
         ObjectUtils.disposeObject(this._bagDefinitionBtnI);
         this._bagDefinitionBtnI = null;
         ObjectUtils.disposeObject(this._bagDefinitionGroup);
         this._bagDefinitionGroup = null;
         ObjectUtils.disposeObject(this._bagDefinitionBtnII);
         this._bagDefinitionBtnII = null;
         ObjectUtils.disposeObject(this._playerInfoEffortHonorView);
         this._playerInfoEffortHonorView = null;
         ObjectUtils.disposeObject(this._cellContent);
         this._cellContent = null;
         ObjectUtils.disposeObject(this._offerLabel);
         this._offerLabel = null;
		 ObjectUtils.disposeObject(this._openNecklacePtetrochemicalView);
		 this._openNecklacePtetrochemicalView = null;
         ObjectUtils.disposeObject(this._dragDropArea);
         this._dragDropArea = null;
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
		 ObjectUtils.disposeObject(this._fineSuitIcon);
		 this._fineSuitIcon = null;
      }
      
      public function startShine(param1:ItemTemplateInfo) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1.NeedSex == 0 || param1.NeedSex == (!!PlayerManager.Instance.Self.Sex ? 1 : 2))
         {
            _loc2_ = this.getCellIndex(param1).split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(int(_loc2_[_loc3_]) >= 0)
               {
                  (this._cells[int(_loc2_[_loc3_])] as PersonalInfoCell).shine();
               }
               _loc3_++;
            }
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:PersonalInfoCell = null;
         for each(_loc1_ in this._cells)
         {
            (_loc1_ as PersonalInfoCell).stopShine();
         }
         if(this._cardEquipView)
         {
            this._cardEquipView.stopShine();
         }
      }
      
      private function getCellIndex(param1:ItemTemplateInfo) : String
      {
         if(EquipType.isWeddingRing(param1))
         {
            return "9,10,16";
         }
         switch(param1.CategoryID)
         {
            case EquipType.HEAD:
               return "0";
            case EquipType.GLASS:
               return "1";
            case EquipType.HAIR:
               return "2";
            case EquipType.EFF:
               return "3";
            case EquipType.CLOTH:
               return "4";
            case EquipType.FACE:
               return "5";
            case EquipType.ARM:
               return "6";
            case EquipType.ARMLET:
            case EquipType.TEMPARMLET:
               return "7,8";
            case EquipType.RING:
            case EquipType.TEMPRING:
               return "9,10";
            case EquipType.SUITS:
               return "11";
            case EquipType.NECKLACE:
               return "12";
            case EquipType.WING:
               return "13";
            case EquipType.CHATBALL:
               return "14";
            case EquipType.OFFHAND:
               return "15";
            case EquipType.HEALSTONE:
               return "18";
            case EquipType.TEMPWEAPON:
               return "6";
            case EquipType.BADGE:
               return "17";
            default:
               return "-1";
         }
      }
      
      public function get showSelfOperation() : Boolean
      {
         return this._showSelfOperation;
      }
      
      public function set showSelfOperation(param1:Boolean) : void
      {
         this._showSelfOperation = param1;
         this.updateShowOperation();
      }
      
      private function updateShowOperation() : void
      {
         this._honorNameTxt.visible = !this.showSelfOperation;
         this._playerInfoEffortHonorView.visible = this.showSelfOperation;
         this._storeBtn.visible = this._showSelfOperation;
         this._buff.visible = this._showSelfOperation;
         this._achvBtn.visible = this._info && (this._info.ZoneID == 0 || this._info.ZoneID == PlayerManager.Instance.Self.ZoneID) && this._achvEnable;
         if(this._achvBtn.visible && TaskManager.achievementQuest && TaskManager.achievementQuest.data && TaskManager.achievementQuest.data.progress[0] <= 0 && this._info is SelfInfo)
         {
            this._achvLight.play();
         }
         else
         {
            this._achvLight.stop();
         }
         this._buyAvatar.visible = !this._showSelfOperation && this._info != null && (this._info.ZoneID == 0 || this._info.ZoneID == PlayerManager.Instance.Self.ZoneID) && PlayerManager.Instance.Self.Grade > 2 && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.TRAINER && StateManager.currentStateType != StateType.HOT_SPRING_ROOM && StateManager.currentStateType != StateType.CHURCH_ROOM && StateManager.currentStateType != StateType.ROOM_LOADING;
         this._hiddenControlsBg.visible = this._hideGlassBtn.visible = this._hideHatBtn.visible = this._hideSuitBtn.visible = this._hideWingBtn.visible = this._showSelfOperation;
         this._addFriendBtn.visible = !this._showSelfOperation && this._info != null && this._info.ID != PlayerManager.Instance.Self.ID && (this._info.ZoneID == 0 || this._info.ZoneID == PlayerManager.Instance.Self.ZoneID);
		 if(this._showSelfOperation && this._showEquip.visible)
		 {
			 this._openNecklacePtetrochemicalView.visible = true;
		 }
		 else
		 {
			 this._openNecklacePtetrochemicalView.visible = false;
		 }
		 if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
		 {
			 if(this._openNecklacePtetrochemicalView.parent)
			 {
				 this._openNecklacePtetrochemicalView.parent.removeChild(this._openNecklacePtetrochemicalView);
			 }
		 }
		 else
		 {
			 if(!this._openNecklacePtetrochemicalView.parent && PlayerManager.Instance.Self.Bag.items[12])
			 {
				 addChild(this._openNecklacePtetrochemicalView);
			 }
		 }
		 if(!this._info || this._info.ID != PlayerManager.Instance.Self.ID || !this._showSelfOperation)
         {
            this._bagDefinitionBtnI.visible = false;
            this._bagDefinitionBtnII.visible = false;
            return;
         }
         this._bagDefinitionBtnI.visible = true;
         this._bagDefinitionBtnII.visible = true;
         if(this._info)
         {
            if(this._info.IsShowConsortia && this._info.ConsortiaName)
            {
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(!this._info.IsShowConsortia && EffortManager.Instance.getHonorArray().length > 0)
            {
               this._bagDefinitionGroup.selectIndex = 0;
            }
            else if(!this._info.IsShowConsortia && this._info.ConsortiaName)
            {
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(this._info.IsShowConsortia && EffortManager.Instance.getHonorArray().length > 0)
            {
               this._bagDefinitionGroup.selectIndex = 0;
            }
            else
            {
               this._bagDefinitionBtnI.visible = false;
               this._bagDefinitionBtnII.visible = false;
            }
         }
      }
      
      private function getShowAcademyIcon() : Boolean
      {
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(this._info.apprenticeshipState != AcademyManager.NONE_STATE)
            {
               return true;
            }
            return false;
         }
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            return true;
         }
         if(this._info.apprenticeshipState != AcademyManager.NONE_STATE)
         {
            return true;
         }
         return false;
      }
      
      public function setAchvEnable(param1:Boolean) : void
      {
         this._achvEnable = param1;
         this.updateShowOperation();
      }
      
      private function _definitionGroupChange(param1:Event = null) : void
      {
         if(param1 != null)
         {
            SoundManager.instance.play("008");
         }
         var _loc2_:Array = EffortManager.Instance.getHonorArray();
         if(_loc2_.length < 1 && !this._info.ConsortiaName)
         {
            this._bagDefinitionBtnI.visible = false;
            this._bagDefinitionBtnII.visible = false;
            return;
         }
         if(this._bagDefinitionGroup.selectIndex == 0)
         {
            if(_loc2_.length < 1)
            {
               if(param1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagInfo.notDesignation"));
               }
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(param1)
            {
               PlayerManager.Instance.Self.IsShowConsortia = false;
            }
         }
         else if(!this._info.ConsortiaName)
         {
            if(param1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagInfo.notSociaty"));
            }
            this._bagDefinitionGroup.selectIndex = 0;
         }
         else if(param1)
         {
            PlayerManager.Instance.Self.IsShowConsortia = true;
         }
         if(param1)
         {
            SocketManager.Instance.out.sendChangeDesignation(PlayerManager.Instance.Self.IsShowConsortia);
         }
      }
	  
	  private function getList(param1:int) : Vector.<GemstListInfo>
	  {
		  var _loc2_:int = 0;
		  while(_loc2_ < 5)
		  {
			  if(PlayerManager.Instance.gemstoneInfoList[_loc2_])
			  {
				  if(param1 == PlayerManager.Instance.gemstoneInfoList[_loc2_].equipPlace)
				  {
					  return PlayerManager.Instance.gemstoneInfoList[_loc2_].list;
				  }
			  }
			  _loc2_++;
		  }
		  return null;
	  }
	  
	  protected function __openNecklacePtetrochemicalView(param1:MouseEvent) : void
	  {
		  SoundManager.instance.playButtonSound();
		  this._necklacePtetrochemicalView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.necklacePtetrochemicalView");
		  this._necklacePtetrochemicalView.show();
		  this._necklacePtetrochemicalView.addEventListener(FrameEvent.RESPONSE,this.__onNecklacePtetrochemicalClose);
	  }
	  
	  protected function __onNecklacePtetrochemicalClose(param1:FrameEvent) : void
	  {
		  if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
		  {
			  SoundManager.instance.playButtonSound();
			  this._necklacePtetrochemicalView.removeEventListener(FrameEvent.RESPONSE,this.__onNecklacePtetrochemicalClose);
			  ObjectUtils.disposeObject(this._necklacePtetrochemicalView);
			  this._necklacePtetrochemicalView = null;
		  }
	  }
   }
}
