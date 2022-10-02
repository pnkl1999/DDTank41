package tofflist.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaApplyInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   import vip.VipController;
   
   public class TofflistLeftCurrentCharcter extends Sprite implements Disposeable
   {
       
      
      private var _AchievementImg:Bitmap;
      
      private var _EXPImg:Bitmap;
      
      private var _LnTAImg:Bitmap;
      
      private var _NO1Mc:MovieClip;
      
      private var _chairmanNameTxt:FilterFrameText;
      
      private var _chairmanNameTxt2:FilterFrameText;
      
      private var _consortiaName:FilterFrameText;
      
      private var _exploitImg:Bitmap;
      
      private var _fightingImg:Bitmap;
      
      private var _guildImg:Bitmap;
      
      private var _info:PlayerInfo;
      
      private var _levelIcon:LevelIcon;
      
      private var _lookEquip_btn:BaseButton;
      
      private var _effortBtn:BaseButton;
      
      private var _applyJoinBtn:BaseButton;
      
      private var _nameTxt:FilterFrameText;
      
      private var _player:ICharacter;
      
      private var _rankNumber:Sprite;
      
      private var _text1:FilterFrameText;
      
      private var _textBg:ScaleBitmapImage;
      
      private var _textBg2:ScaleBitmapImage;
      
      private var _wealthImg:Bitmap;
      
      private var _vipName:GradientText;
      
      private var _chairmanVipName:GradientText;
      
      private var _scoreImg:Bitmap;
      
      private var _charmvalueImg:Bitmap;
      
      public function TofflistLeftCurrentCharcter()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function dispose() : void
      {
         if(this._player)
         {
            this._player.dispose();
         }
         this._player = null;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._AchievementImg = null;
         this._EXPImg = null;
         this._LnTAImg = null;
         this._NO1Mc = null;
         this._chairmanNameTxt2 = null;
         this._exploitImg = null;
         this._fightingImg = null;
         this._guildImg = null;
         this._levelIcon = null;
         this._lookEquip_btn = null;
         this._effortBtn = null;
         this._applyJoinBtn = null;
         this._nameTxt = null;
         this._rankNumber = null;
         this._text1 = null;
         this._textBg = null;
         this._textBg2 = null;
         this._wealthImg = null;
         this._vipName = null;
         this._chairmanVipName = null;
         this._charmvalueImg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function NO1Effect() : void
      {
         if(TofflistModel.currentIndex == 1)
         {
            this._NO1Mc.visible = true;
            this._NO1Mc.gotoAndPlay(1);
         }
         else
         {
            this._NO1Mc.visible = false;
            this._NO1Mc.gotoAndStop(1);
         }
      }
      
      private function __lookBtnClick(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL && this._info)
         {
            PlayerInfoViewControl.viewByID(this._info.ID);
         }
      }
      
      private function __effortBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(TofflistModel.currentPlayerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            EffortManager.Instance.isSelf = true;
            EffortManager.Instance.switchVisible();
         }
         else
         {
            EffortManager.Instance.lookUpEffort(TofflistModel.currentPlayerInfo.ID);
         }
      }
      
      private function __upCurrentPlayerHandler(param1:TofflistEvent) : void
      {
         this._info = TofflistModel.currentPlayerInfo;
         this.upView();
      }
      
      private function addEvent() : void
      {
         TofflistModel.addEventListener(TofflistEvent.TOFFLIST_CURRENT_PLAYER,this.__upCurrentPlayerHandler);
         this._lookEquip_btn.addEventListener(MouseEvent.CLICK,this.__lookBtnClick);
         this._effortBtn.addEventListener(MouseEvent.CLICK,this.__effortBtn);
         this._applyJoinBtn.addEventListener(MouseEvent.CLICK,this.onApplyJoinClubBtnClick);
      }
      
      private function onApplyJoinClubBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(TofflistModel.currentConsortiaInfo)
         {
            if(PlayerManager.Instance.Self.Grade < 7)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
               return;
            }
            if(!TofflistModel.currentConsortiaInfo.OpenApply)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandler"));
               return;
            }
            this._applyJoinBtn.enable = false;
            SocketManager.Instance.out.sendConsortiaTryIn(TofflistModel.currentConsortiaInfo.ConsortiaID);
         }
      }
      
      private function getRank(param1:int) : void
      {
         var _loc2_:Bitmap = null;
         _loc2_ = null;
         var _loc6_:Point = null;
         if(!this._rankNumber)
         {
            this._rankNumber = new Sprite();
         }
         while(this._rankNumber.numChildren != 0)
         {
            this._rankNumber.removeChildAt(0);
         }
         var _loc3_:String = param1.toString();
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this.getRankBitmap(int(_loc3_.substr(_loc5_,1)));
            _loc2_.x = _loc5_ * 30;
            this._rankNumber.addChild(_loc2_);
            _loc5_++;
         }
         switch(param1)
         {
            case 1:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankSt");
               _loc2_.x = 25;
               _loc2_.y = 8;
               this._rankNumber.addChild(_loc2_);
               break;
            case 2:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNd");
               _loc2_.x = 34;
               _loc2_.y = 8;
               this._rankNumber.addChild(_loc2_);
               break;
            case 3:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankRd");
               _loc2_.x = 30;
               _loc2_.y = 8;
               this._rankNumber.addChild(_loc2_);
               break;
            default:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankTh");
               _loc2_.x = _loc4_ * 30;
               _loc2_.y = 8;
               this._rankNumber.addChild(_loc2_);
         }
         addChild(this._rankNumber);
         _loc6_ = ComponentFactory.Instance.creat("tofflist.rankPos");
         this._rankNumber.x = _loc6_.x;
         this._rankNumber.y = _loc6_.y;
      }
      
      private function getRankBitmap(param1:int) : Bitmap
      {
         var _loc2_:Bitmap = null;
         switch(param1)
         {
            case 0:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum0");
               break;
            case 1:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum1");
               break;
            case 2:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum2");
               break;
            case 3:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum3");
               break;
            case 4:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum4");
               break;
            case 5:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum5");
               break;
            case 6:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum6");
               break;
            case 7:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum7");
               break;
            case 8:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum8");
               break;
            case 9:
               _loc2_ = ComponentFactory.Instance.creatBitmap("asset.Toffilist.PlayerRankNum9");
         }
         return _loc2_;
      }
      
      private function init() : void
      {
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("toffilist.textBg");
         addChild(this._textBg);
         this._textBg2 = ComponentFactory.Instance.creatComponentByStylename("toffilist.textBg2");
         addChild(this._textBg2);
         this._fightingImg = ComponentFactory.Instance.creat("asset.Toffilist.fightingImgAsset1_1");
         addChild(this._fightingImg);
         this._exploitImg = ComponentFactory.Instance.creat("asset.Toffilist.exploitImgAsset1_1");
         addChild(this._exploitImg);
         this._EXPImg = ComponentFactory.Instance.creat("asset.Toffilist.EXPImgAsset1_1");
         addChild(this._EXPImg);
         this._wealthImg = ComponentFactory.Instance.creat("asset.Toffilist.wealthImgAsset1_1");
         addChild(this._wealthImg);
         this._LnTAImg = ComponentFactory.Instance.creat("asset.Toffilist.LnTAImgAsset1_1");
         addChild(this._LnTAImg);
         this._AchievementImg = ComponentFactory.Instance.creat("asset.Toffilist.AchievementImgAsset1_1");
         addChild(this._AchievementImg);
         this._charmvalueImg = ComponentFactory.Instance.creat("asset.Toffilist.charmvalueImgAsset1_1");
         addChild(this._charmvalueImg);
         this._guildImg = ComponentFactory.Instance.creat("asset.Toffilist.guildImgAsset");
         addChild(this._guildImg);
         this._scoreImg = ComponentFactory.Instance.creatBitmap("asset.Toffilist.scoreAsset1");
         addChild(this._scoreImg);
         this._text1 = ComponentFactory.Instance.creatComponentByStylename("toffilist.text1");
         addChild(this._text1);
         this._consortiaName = ComponentFactory.Instance.creatComponentByStylename("toffilist.consortiaName");
         addChild(this._consortiaName);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.nameTxt");
         this._chairmanNameTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.chairmanNameTxt");
         addChild(this._chairmanNameTxt);
         this._chairmanNameTxt2 = ComponentFactory.Instance.creatComponentByStylename("toffilist.chairmanNameTxt2");
         this._lookEquip_btn = ComponentFactory.Instance.creatComponentByStylename("toffilist.lookEquip_btn");
         addChild(this._lookEquip_btn);
         this._effortBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.lookEffort_btn");
         addChild(this._effortBtn);
         this._applyJoinBtn = ComponentFactory.Instance.creatComponentByStylename("toffilist.applyJoinClub_btn");
         addChild(this._applyJoinBtn);
         this._applyJoinBtn.visible = false;
         this._NO1Mc = ComponentFactory.Instance.creat("asset.NO1McAsset");
         this._NO1Mc.gotoAndStop(1);
         this._NO1Mc.visible = false;
         this._NO1Mc.y = -39;
         addChild(this._NO1Mc);
      }
      
      private function refreshCharater() : void
      {
         if(this._player)
         {
            this._player.dispose();
            this._player = null;
         }
         if(this._info)
         {
            this._player = CharactoryFactory.createCharacter(this._info,"room");
            this._player.show(false,-1);
            this._player.showGun = false;
            this._player.setShowLight(true);
            PositionUtils.setPos(this._player,"tofflist.playerPos");
            addChild(this._player as DisplayObject);
         }
      }
      
      private function removeEvent() : void
      {
         TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_CURRENT_PLAYER,this.__upCurrentPlayerHandler);
         this._lookEquip_btn.removeEventListener(MouseEvent.CLICK,this.__lookBtnClick);
         this._applyJoinBtn.removeEventListener(MouseEvent.CLICK,this.onApplyJoinClubBtnClick);
      }
      
      private function upLevelIcon() : void
      {
         if(this._levelIcon)
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(this._info)
         {
            this._levelIcon = new LevelIcon();
            this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false);
            addChild(this._levelIcon);
         }
      }
      
      private function upStyle() : void
      {
         this._text1.text = "";
         this._consortiaName.text = "";
         this._nameTxt.text = "";
         this._chairmanNameTxt.text = "";
         this._chairmanNameTxt2.text = "";
         DisplayUtils.removeDisplay(this._vipName);
         DisplayUtils.removeDisplay(this._chairmanVipName);
         if(!this._info)
         {
            if(this._rankNumber)
            {
               ObjectUtils.disposeObject(this._rankNumber);
               this._rankNumber = null;
            }
            if(this._levelIcon)
            {
               ObjectUtils.disposeObject(this._levelIcon);
               this._levelIcon = null;
            }
            return;
         }
         if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL || TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
         {
            this.upLevelIcon();
            this._nameTxt.text = this._info.NickName;
            this._nameTxt.x = (500 - this._nameTxt.textWidth) / 2;
            if(this._info.IsVIP)
            {
               if(this._vipName)
               {
                  ObjectUtils.disposeObject(this._vipName);
               }
               this._vipName = VipController.instance.getVipNameTxt(390 - this._nameTxt.x,this._info.typeVIP);
               this._vipName.textSize = 18;
               this._vipName.x = this._nameTxt.x;
               this._vipName.y = this._nameTxt.y;
               this._vipName.text = this._nameTxt.text;
               addChild(this._vipName);
               DisplayUtils.removeDisplay(this._nameTxt);
               addChild(this._applyJoinBtn);
            }
            else
            {
               addChild(this._nameTxt);
               DisplayUtils.removeDisplay(this._vipName);
            }
            this._levelIcon.x = this._nameTxt.x - (this._levelIcon.width + 5);
            this._levelIcon.y = this._nameTxt.y - 5;
         }
         else
         {
            if(this._levelIcon)
            {
               this._levelIcon.visible = false;
            }
            this._chairmanNameTxt.text = LanguageMgr.GetTranslation("tank.tofflist.view.TofflistLeftCurrentCharcter.cdr");
            this._chairmanNameTxt2.text = this._info.NickName;
            this._chairmanNameTxt2.x = (500 - this._chairmanNameTxt2.textWidth) / 2;
            this._chairmanNameTxt.x = this._chairmanNameTxt2.x - (this._chairmanNameTxt.textWidth + 5);
            if(this._info.IsVIP)
            {
               if(this._chairmanVipName)
               {
                  ObjectUtils.disposeObject(this._chairmanVipName);
               }
               this._chairmanVipName = VipController.instance.getVipNameTxt(165,this._info.typeVIP);
               this._chairmanVipName.textSize = 18;
               this._chairmanVipName.x = this._chairmanNameTxt2.x;
               this._chairmanVipName.y = this._chairmanNameTxt2.y;
               this._chairmanVipName.text = this._chairmanNameTxt2.text;
               addChild(this._chairmanVipName);
               DisplayUtils.removeDisplay(this._chairmanNameTxt2);
               addChild(this._applyJoinBtn);
            }
            else
            {
               addChild(this._chairmanNameTxt2);
               DisplayUtils.removeDisplay(this._chairmanVipName);
            }
         }
         this._text1.text = String(TofflistModel.currentText);
         this._consortiaName.text = String(TofflistModel.currentPlayerInfo.ConsortiaName);
         this.getRank(TofflistModel.currentIndex);
      }
      
      private function upView() : void
      {
         this._fightingImg.visible = false;
         this._AchievementImg.visible = false;
         this._LnTAImg.visible = false;
         this._wealthImg.visible = false;
         this._EXPImg.visible = false;
         this._exploitImg.visible = false;
         this._charmvalueImg.visible = false;
         this._scoreImg.visible = false;
         this.refreshCharater();
         this.upStyle();
         this.NO1Effect();
         if(this._info && TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
         {
            this._lookEquip_btn.enable = true;
            this._effortBtn.enable = true;
            this._effortBtn.visible = true;
         }
         else
         {
            this._lookEquip_btn.enable = false;
            this._effortBtn.enable = false;
            this._effortBtn.visible = false;
         }
         this.refreshApplyJoinClubBtn();
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._fightingImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._EXPImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.GESTE:
                     this._exploitImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._AchievementImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._charmvalueImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this._scoreImg.visible = true;
               }
               break;
            case TofflistStairMenu.CONSORTIA:
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._fightingImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._wealthImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this._LnTAImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.GESTE:
                     this._exploitImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._charmvalueImg.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._AchievementImg.visible = true;
               }
         }
      }
      
      private function refreshApplyJoinClubBtn() : void
      {
         var _loc1_:int = 0;
         if(TofflistModel.currentConsortiaInfo)
         {
            _loc1_ = TofflistModel.currentConsortiaInfo.ConsortiaID;
         }
         if(this._info && TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA && PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            this._applyJoinBtn.visible = true;
         }
         else
         {
            this._applyJoinBtn.visible = false;
         }
         if(_loc1_ == 0 || !this.hasApplyJoinClub(_loc1_))
         {
            this._applyJoinBtn.enable = true;
         }
         else
         {
            this._applyJoinBtn.enable = false;
         }
      }
      
      private function hasApplyJoinClub(param1:int = 0) : Boolean
      {
         var _loc3_:ConsortiaApplyInfo = null;
         var _loc4_:int = 0;
         var _loc2_:Vector.<ConsortiaApplyInfo> = TofflistModel.Instance.myConsortiaAuditingApplyData;
         if(_loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_];
               if(_loc3_.ConsortiaID == param1)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return false;
      }
   }
}
