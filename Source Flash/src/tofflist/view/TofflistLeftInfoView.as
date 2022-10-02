package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.club.ClubInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   import tofflist.data.RankInfo;
   
   public class TofflistLeftInfoView extends Sprite implements Disposeable
   {
       
      
      private var _bgImg1:ScaleBitmapImage;
      
      private var _bgImg2:Bitmap;
      
      private var _bgImg3:Bitmap;
      
      private var _levelIcon:LevelIcon;
      
      private var info:RankInfo;
      
      private var _text:TextField;
      
      private var _RankingLiftImg:ScaleFrameImage;
      
      private var _RankingLiftImgTwo:ScaleFrameImage;
      
      private var _resourceArr:Array;
      
      private var _styleLinkArr:Array;
      
      private var _textArr:Array;
      
      private var _updateTimeTxt:FilterFrameText;
      
      private var _tempArr:Vector.<RankInfo>;
      
      public function TofflistLeftInfoView()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         this.removeEvent();
         var _loc2_:uint = 0;
         var _loc3_:uint = this._resourceArr.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._resourceArr[_loc2_].dis;
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            this._resourceArr[_loc2_] = null;
            _loc2_++;
         }
         this._resourceArr = null;
         this._styleLinkArr = null;
         this._textArr = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._bgImg1);
         this._bgImg1 = null;
         ObjectUtils.disposeObject(this._bgImg2);
         this._bgImg2 = null;
         ObjectUtils.disposeObject(this._bgImg3);
         this._bgImg3 = null;
         ObjectUtils.disposeObject(this._updateTimeTxt);
         this._updateTimeTxt = null;
         if(this._RankingLiftImg)
         {
            ObjectUtils.disposeObject(this._RankingLiftImg);
         }
         this._RankingLiftImg = null;
         if(this._RankingLiftImgTwo)
         {
            ObjectUtils.disposeObject(this._RankingLiftImgTwo);
         }
         this._RankingLiftImgTwo = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set resourceLink(param1:String) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc6_:Object = null;
         this._resourceArr = [];
         var _loc3_:Array = param1.replace(/(\s*)|(\s*$)/g,"").split("|");
         var _loc4_:uint = 0;
         var _loc5_:uint = _loc3_.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = {};
            _loc6_.id = _loc3_[_loc4_].split("#")[0];
            _loc6_.className = _loc3_[_loc4_].split("#")[1];
            _loc2_ = ComponentFactory.Instance.creat(_loc6_.className);
            addChild(_loc2_);
            _loc6_.dis = _loc2_;
            this._resourceArr.push(_loc6_);
            _loc4_++;
         }
      }
      
      public function set setAllStyleXY(param1:String) : void
      {
         this._styleLinkArr = param1.replace(/(\s*)|(\s*$)/g,"").split("~");
         this.updateStyleXY();
      }
      
      public function updateStyleXY(param1:int = 0) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:DisplayObject = null;
         _loc3_ = 0;
         var _loc4_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         this._textArr = [];
         var _loc5_:uint = this._resourceArr.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = this._resourceArr[_loc3_].dis;
            _loc2_.visible = false;
            _loc3_++;
         }
         _loc6_ = this._styleLinkArr[param1].split("|");
         _loc5_ = _loc6_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = null;
            _loc7_ = _loc6_[_loc3_].split("#")[0];
            _loc4_ = 0;
            while(_loc4_ < this._resourceArr.length)
            {
               if(_loc7_ == this._resourceArr[_loc4_].id)
               {
                  _loc2_ = this._resourceArr[_loc4_].dis;
                  break;
               }
               _loc4_++;
            }
            if(_loc2_)
            {
               _loc8_ = new Point();
               _loc8_.x = _loc6_[_loc3_].split("#")[1].split(",")[0];
               _loc8_.y = _loc6_[_loc3_].split("#")[1].split(",")[1];
               _loc2_.x = _loc8_.x;
               _loc2_.y = _loc8_.y;
               if(_loc6_[_loc3_].split("#")[1].split(",")[2])
               {
                  _loc2_.width = _loc6_[_loc3_].split("#")[1].split(",")[2];
               }
               if(_loc6_[_loc3_].split("#")[1].split(",")[2])
               {
                  _loc2_.height = _loc6_[_loc3_].split("#")[1].split(",")[3];
               }
               _loc2_.visible = true;
               if(_loc2_ is FilterFrameText)
               {
                  this._textArr.push(_loc2_);
               }
            }
            _loc3_++;
         }
      }
      
      public function get updateTimeTxt() : FilterFrameText
      {
         return this._updateTimeTxt;
      }
      
      private function __tofflistTypeHandler(param1:TofflistEvent) : void
      {
         var _loc2_:SelfInfo = null;
         _loc2_ = PlayerManager.Instance.Self;
         var _loc3_:ClubInfo = PlayerManager.Instance.SelfConsortia;
         this._bgImg2.visible = false;
         this._bgImg3.visible = false;
         this._levelIcon.visible = false;
         this._RankingLiftImg.visible = false;
         this._RankingLiftImgTwo.visible = false;
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(0);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.FightPower;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.FightPower,TofflistModel.Instance.rankInfo.PrevFightPower);
                     }
                     this._textArr[1].text = _loc2_.FightPower;
                     this._textArr[2].text = "";
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(1);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.GP;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPareTwo(TofflistModel.Instance.rankInfo.GP,TofflistModel.Instance.rankInfo.PrevGP);
                     }
                     this._textArr[1].text = _loc2_.GP;
                     this._textArr[2].text = "";
                     this._levelIcon.x = 282;
                     this._levelIcon.y = 34;
                     this._levelIcon.setInfo(_loc2_.Grade,_loc2_.Repute,_loc2_.WinCount,_loc2_.TotalCount,_loc2_.FightPower,_loc2_.Offer,true,false);
                     this._levelIcon.visible = true;
                     this._bgImg3.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this.updateStyleXY(2);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.AchievementPoint;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.AchievementPoint,TofflistModel.Instance.rankInfo.PrevAchievementPoint);
                     }
                     this._textArr[1].text = _loc2_.AchievementPoint;
                     this._textArr[2].text = "";
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(3);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.GiftGp;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.GiftGp,TofflistModel.Instance.rankInfo.PrevGiftGp);
                     }
                     this._textArr[1].text = _loc2_.charmGP;
                     this._textArr[2].text = "";
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this.updateStyleXY(4);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.LeagueAddWeek;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.LeagueAddWeek,TofflistModel.Instance.rankInfo.PrevLeagueAddWeek);
                     }
                     this._textArr[1].text = _loc2_.matchInfo.weeklyScore;
                     this._textArr[2].text = "";
                     this._bgImg2.visible = true;
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(0);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.FightPower;
                     this._textArr[1].text = _loc2_.FightPower;
                     this._textArr[2].text = "";
                     this._textArr[3].text = "";
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(1);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.GP;
                     this._textArr[1].text = _loc2_.GP;
                     this._textArr[2].text = "";
                     this._textArr[3].text = "";
                     this._levelIcon.x = 282;
                     this._levelIcon.y = 34;
                     this._levelIcon.setInfo(_loc2_.Grade,_loc2_.Repute,_loc2_.WinCount,_loc2_.TotalCount,_loc2_.FightPower,_loc2_.Offer,true,false);
                     this._levelIcon.visible = true;
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this.updateStyleXY(2);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.AchievementPoint;
                     this._textArr[1].text = _loc2_.AchievementPoint;
                     this._textArr[2].text = "";
                     this._textArr[3].text = "";
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(3);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.GiftGp;
                     this._textArr[1].text = _loc2_.charmGP;
                     this._textArr[2].text = "";
                     this._textArr[3].text = "";
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this.updateStyleXY(4);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.LeagueAddWeek;
                     this._textArr[1].text = _loc2_.matchInfo.weeklyScore;
                     this._textArr[2].text = "";
                     this._textArr[3].text = "";
                     this._bgImg2.visible = true;
               }
               break;
            case TofflistStairMenu.CONSORTIA:
            default:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(5);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaFightPower;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaFightPower,TofflistModel.Instance.rankInfo.ConsortiaPrevFightPower);
                     }
                     this._textArr[1].text = _loc2_.FightPower;
                     this._textArr[2].text = "";
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(6);
                     if(!_loc3_ || !_loc2_.consortiaInfo.ChairmanName)
                     {
                        this.consortiaEmpty();
                     }
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaLevel;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPareTwo(TofflistModel.Instance.rankInfo.ConsortiaLevel,TofflistModel.Instance.rankInfo.ConsortiaPrevLevel);
                     }
                     this._textArr[1].text = _loc2_.consortiaInfo.Riches;
                     this._textArr[2].text = _loc2_.consortiaInfo.Level;
                     this._bgImg3.visible = true;
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this.updateStyleXY(7);
                     if(!_loc3_ || !_loc2_.consortiaInfo.ChairmanName)
                     {
                        this.consortiaEmpty();
                     }
                     else
                     {
                        this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaRiches;
                        if(TofflistModel.Instance.rankInfo != null)
                        {
                           this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaRiches,TofflistModel.Instance.rankInfo.ConsortiaPrevRiches);
                        }
                        this._textArr[1].text = _loc2_.consortiaInfo.Riches;
                        this._textArr[2].text = "";
                        this._bgImg2.visible = true;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(8);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaGiftGp;
                     if(TofflistModel.Instance.rankInfo != null)
                     {
                        this.onComPare(TofflistModel.Instance.rankInfo.ConsortiaGiftGp,TofflistModel.Instance.rankInfo.ConsortiaPrevGiftGp);
                     }
                     this._textArr[1].text = _loc2_.consortiaInfo.CharmGP;
                     this._textArr[2].text = "";
                     this._bgImg2.visible = true;
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this.updateStyleXY(5);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaFightPower;
                     this._textArr[1].text = _loc2_.FightPower;
                     this._textArr[2].text = "";
                     this._textArr[3].text = "";
                     this._bgImg2.visible = true;
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this.updateStyleXY(6);
                     if(!_loc3_ || !_loc2_.consortiaInfo.ChairmanName)
                     {
                        this.consortiaEmpty();
                     }
                     else
                     {
                        this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaLevel;
                        this._textArr[1].text = _loc2_.consortiaInfo.Riches;
                        this._textArr[2].text = _loc2_.consortiaInfo.Level;
                        this._textArr[3].text = "";
                        this._bgImg2.visible = true;
                     }
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this.updateStyleXY(7);
                     if(!_loc3_ || !_loc2_.consortiaInfo.ChairmanName)
                     {
                        this.consortiaEmpty();
                     }
                     else
                     {
                        this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaRiches;
                        this._textArr[1].text = _loc2_.consortiaInfo.Riches;
                        this._textArr[2].text = "";
                        this._textArr[3].text = "";
                        this._bgImg2.visible = true;
                     }
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this.updateStyleXY(8);
                     this._textArr[0].text = TofflistModel.Instance.rankInfo == null ? "0" : TofflistModel.Instance.rankInfo.ConsortiaGiftGp;
                     this._textArr[1].text = _loc2_.consortiaInfo.Riches;
                     this._textArr[2].text = "";
                     this._textArr[3].text = "";
                     this._bgImg2.visible = true;
               }
         }
      }
      
      private function addEvent() : void
      {
         TofflistModel.addEventListener(TofflistEvent.RANKINFO_READY,this.__rankInfoHandler);
         TofflistModel.addEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,this.__tofflistTypeHandler);
      }
      
      private function __rankInfoHandler(param1:TofflistEvent) : void
      {
         this.__tofflistTypeHandler(null);
      }
      
      private function consortiaEmpty() : void
      {
         this._textArr[0].text = this._textArr[1].text = LanguageMgr.GetTranslation("tank.tofflist.view.TofflistLeftInfo.no");
      }
      
      private function onComPare(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         this._RankingLiftImg.visible = true;
         if(TofflistModel.Instance.rankInfo != null && param1 < param2)
         {
            this._RankingLiftImg.setFrame(1);
            _loc3_ = param2 - param1;
            this._textArr[3].text = _loc3_;
         }
         if(TofflistModel.Instance.rankInfo != null && param1 > param2)
         {
            this._RankingLiftImg.setFrame(2);
            _loc3_ = param1 - param2;
            this._textArr[3].text = _loc3_;
         }
         if(TofflistModel.Instance.rankInfo != null && param1 == param2)
         {
            this._RankingLiftImg.visible = false;
            this._textArr[3].text = "";
         }
      }
      
      private function onComPareTwo(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         this._RankingLiftImgTwo.visible = true;
         if(TofflistModel.Instance.rankInfo != null && param1 < param2)
         {
            this._RankingLiftImgTwo.setFrame(1);
            _loc3_ = param2 - param1;
            this._textArr[3].text = _loc3_;
         }
         if(TofflistModel.Instance.rankInfo != null && param1 > param2)
         {
            this._RankingLiftImgTwo.setFrame(2);
            _loc3_ = param1 - param2;
            this._textArr[3].text = _loc3_;
         }
         if(TofflistModel.Instance.rankInfo != null && param1 == param2)
         {
            this._textArr[3].text = "";
            this._RankingLiftImgTwo.visible = false;
         }
      }
      
      private function init() : void
      {
         this._updateTimeTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.updateTimeTxt");
         addChild(this._updateTimeTxt);
         this._bgImg1 = ComponentFactory.Instance.creatComponentByStylename("toffilist.leftImgBg");
         addChild(this._bgImg1);
         this._bgImg2 = ComponentFactory.Instance.creat("asset.Toffilist.textImgBgAsset");
         addChild(this._bgImg2);
         this._bgImg3 = ComponentFactory.Instance.creat("asset.Toffilist.textImgBgAssetOne");
         addChild(this._bgImg3);
         this._RankingLiftImg = ComponentFactory.Instance.creatComponentByStylename("toffilist.RankingLift");
         addChild(this._RankingLiftImg);
         this._RankingLiftImgTwo = ComponentFactory.Instance.creatComponentByStylename("toffilist.RankingLiftTwo");
         addChild(this._RankingLiftImgTwo);
         this._levelIcon = new LevelIcon();
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._levelIcon.visible = false;
         this._RankingLiftImg.visible = false;
         this._RankingLiftImgTwo.visible = false;
      }
      
      private function removeEvent() : void
      {
         TofflistModel.removeEventListener(TofflistEvent.RANKINFO_READY,this.__rankInfoHandler);
         TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,this.__tofflistTypeHandler);
      }
   }
}
