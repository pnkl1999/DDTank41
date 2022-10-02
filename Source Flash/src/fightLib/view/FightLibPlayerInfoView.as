package fightLib.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.utils.PositionUtils;
   import ddt.view.academyCommon.academyIcon.AcademyIcon;
   import ddt.view.buff.BuffControl;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import vip.VipController;
   
   public class FightLibPlayerInfoView extends Sprite implements Disposeable
   {
       
      
      private var _info:PlayerInfo;
      
      private var _nicknameField:FilterFrameText;
      
      private var _vipNameField:GradientText;
      
      private var _consortiaNameField:FilterFrameText;
      
      private var _reputeField:FilterFrameText;
      
      private var _gesteField:FilterFrameText;
      
      private var _figure:ICharacter;
      
      private var _playerContent:Sprite;
      
      private var _levelIcon:LevelIcon;
      
      private var _guildOffset:Point;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _marryIcon:MarriedIcon;
      
      private var _academyIcon:AcademyIcon;
      
      private var _badge:Badge;
      
      private var _iconContainer:VBox;
      
      private var _marryOffset:Point;
      
      private var _buff:BuffControl;
      
      private var _backgournd:Bitmap;
      
      public function FightLibPlayerInfoView()
      {
         super();
         this.configUI();
         this.addEvent();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._nicknameField)
         {
            ObjectUtils.disposeObject(this._nicknameField);
            this._nicknameField = null;
         }
         if(this._consortiaNameField)
         {
            ObjectUtils.disposeObject(this._consortiaNameField);
            this._consortiaNameField = null;
         }
         if(this._reputeField)
         {
            ObjectUtils.disposeObject(this._reputeField);
            this._reputeField = null;
         }
         if(this._gesteField)
         {
            ObjectUtils.disposeObject(this._gesteField);
            this._gesteField = null;
         }
         if(this._figure)
         {
            ObjectUtils.disposeObject(this._figure);
            this._figure = null;
         }
         if(this._levelIcon)
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(this._marryIcon)
         {
            ObjectUtils.disposeObject(this._marryIcon);
            this._marryIcon = null;
         }
         if(this._buff)
         {
            ObjectUtils.disposeObject(this._buff);
            this._buff = null;
         }
         if(this._vipIcon)
         {
            ObjectUtils.disposeObject(this._vipIcon);
            this._buff = null;
         }
         if(this._academyIcon)
         {
            ObjectUtils.disposeObject(this._academyIcon);
            this._academyIcon = null;
         }
         if(this._backgournd)
         {
            ObjectUtils.disposeObject(this._backgournd);
            this._backgournd = null;
         }
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         if(this._info != null)
         {
            if(this._info.ID == param1.ID)
            {
               return;
            }
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChanged);
         }
         this._info = param1;
         this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChanged);
         this.update();
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      private function configUI() : void
      {
         this._backgournd = ComponentFactory.Instance.creatBitmap("fightLib.PlayerInfo.backgournd");
         this._backgournd.x = -8;
         this._backgournd.y = -6;
         addChildAt(this._backgournd,0);
         this._playerContent = new Sprite();
         addChild(this._playerContent);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.fightLibPlayerItem.iconContainer");
         addChild(this._iconContainer);
         this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("fightLib.PlayerInfo.NicknameField");
         this._consortiaNameField = ComponentFactory.Instance.creatComponentByStylename("fightLib.PlayerInfo.ConsortiaNameField");
         addChild(this._consortiaNameField);
         this._reputeField = ComponentFactory.Instance.creatComponentByStylename("fightLib.PlayerInfo.ReputeField");
         addChild(this._reputeField);
         this._gesteField = ComponentFactory.Instance.creatComponentByStylename("fightLib.PlayerInfo.GesteField");
         addChild(this._gesteField);
         this._buff = ComponentFactory.Instance.creatCustomObject("fightLib.PlyerInfo.Buff");
         addChild(this._buff);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("fightLib.PlyerInfo.LevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         addChild(this._levelIcon);
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChanged);
         }
      }
      
      private function __propertyChanged(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Effectiveness"] || param1.changedProperties["DutyLevel"] || param1.changedProperties["ConsortiaName"] || param1.changedProperties["SpouseName"] || param1.changedProperties["Grade"] || param1.changedProperties["Repute"])
         {
            this.update();
         }
      }
      
      private function update() : void
      {
         if(this._vipIcon == null)
         {
            this._vipIcon = ComponentFactory.Instance.creatCustomObject("fightLib.PlayerInfo.VipIcon");
            this._iconContainer.addChild(this._vipIcon);
         }
         this._vipIcon.setInfo(this._info);
         if(this._info.shouldShowAcademyIcon())
         {
            if(this._academyIcon == null)
            {
               this._academyIcon = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibPlayerInfoView.AcademyIcon");
               this._iconContainer.addChild(this._academyIcon);
            }
         }
         else
         {
            if(this._academyIcon)
            {
               this._academyIcon.dispose();
            }
            this._academyIcon = null;
         }
         if(this._info.SpouseName != null && this._info.SpouseName != "")
         {
            if(this._marryIcon == null)
            {
               this._marryIcon = ComponentFactory.Instance.creatCustomObject("fightLib.PlyerInfo.MarriedIcon");
               this._marryIcon.tipData = {
                  "nickName":this._info.SpouseName,
                  "gender":this._info.Sex
               };
               this._iconContainer.addChild(this._marryIcon);
            }
         }
         else
         {
            if(this._marryIcon)
            {
               this._marryIcon.dispose();
            }
            this._marryIcon = null;
         }
         if(this._info.badgeID > 0 && this._info.ConsortiaID > 0)
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
         this._consortiaNameField.text = this._info.ConsortiaName == null ? "" : (this._info.ConsortiaID > 0 ? "<" + this._info.ConsortiaName + ">" : "");
         this._reputeField.text = String(this._info.Repute);
         this._gesteField.text = String(this._info.Offer);
         if(this._figure == null)
         {
            this._figure = CharactoryFactory.createCharacter(this._info,"room");
            this._figure.showGun = true;
            PositionUtils.setPos(this._figure,"fightLib.PlayerInfo.FigurePosition");
            this._figure.show(true,-1);
            this._figure.setShowLight(true,null);
            this._playerContent.addChild(this._figure as RoomCharacter);
         }
         this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
         this._levelIcon.allowClick();
         if(this._academyIcon)
         {
            this._academyIcon.tipData = this._info;
         }
         if(!this._info.IsVIP)
         {
            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._nicknameField.text = this._info.NickName;
            addChild(this._nicknameField);
            DisplayUtils.removeDisplay(this._vipNameField);
         }
         else
         {
            ObjectUtils.disposeObject(this._vipNameField);
            this._vipNameField = VipController.instance.getVipNameTxt(101,this._info.typeVIP);
            this._vipNameField.x = this._nicknameField.x;
            this._vipNameField.y = this._nicknameField.y;
            this._vipNameField.text = this._info.NickName;
            addChild(this._vipNameField);
            DisplayUtils.removeDisplay(this._nicknameField);
         }
      }
   }
}
