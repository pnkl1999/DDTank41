package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import tofflist.TofflistController;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   
   public class TofflistRightView extends Sprite implements Disposeable
   {
       
      
      private var _contro:TofflistController;
      
      private var _currentData:Array;
      
      private var _currentPage:int;
      
      private var _gridBox:TofflistGridBox;
      
      private var _pageTxt:FilterFrameText;
      
      private var _pgdn:BaseButton;
      
      private var _pgup:BaseButton;
      
      private var _stairMenu:TofflistStairMenu;
      
      private var _thirdClassMenu:TofflistThirdClassMenu;
      
      private var _totalPage:int;
      
      private var _twoGradeMenu:TofflistTwoGradeMenu;
      
      private var _upDownTextBg:Bitmap;
      
      public function TofflistRightView(param1:TofflistController)
      {
         this._contro = param1;
         super();
         this.init();
         this.addEvent();
      }
      
      public function get gridBox() : TofflistGridBox
      {
         return this._gridBox;
      }
      
      public function dispose() : void
      {
         this._contro = null;
         this._currentData = null;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._gridBox = null;
         this._pageTxt = null;
         this._pgdn = null;
         this._pgup = null;
         this._upDownTextBg = null;
         this._stairMenu = null;
         this._twoGradeMenu = null;
         this._thirdClassMenu = null;
      }
      
      public function get firstType() : String
      {
         return this._stairMenu.type;
      }
      
      public function orderList(param1:Array) : void
      {
         if(!param1)
         {
            return;
         }
         this._currentData = param1;
         this._gridBox.orderList.items(param1);
         this._totalPage = Math.ceil((param1 == null ? 0 : param1.length) / 8);
         if(this._currentData && this._currentData.length > 0)
         {
            this._currentPage = 1;
         }
         else
         {
            this._currentPage = 1;
         }
         this.checkPageBtn();
      }
      
      public function get twoGradeType() : String
      {
         return this._twoGradeMenu.type;
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._stairMenu.type = TofflistStairMenu.PERSONAL;
         this._twoGradeMenu.setParentType(this._stairMenu.type);
      }
      
      private function __menuTypeHandler(param1:TofflistEvent) : void
      {
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._gridBox.updateStyleXY(0);
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._gridBox.updateStyleXY(1);
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._gridBox.updateStyleXY(2);
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._gridBox.updateStyleXY(3);
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this._gridBox.updateStyleXY(4);
               }
               break;
            case TofflistStairMenu.CONSORTIA:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._gridBox.updateStyleXY(5);
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._gridBox.updateStyleXY(6);
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this._gridBox.updateStyleXY(7);
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._gridBox.updateStyleXY(8);
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._gridBox.updateStyleXY(9);
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._gridBox.updateStyleXY(10);
                     break;
                  case TofflistTwoGradeMenu.ACHIEVEMENTPOINT:
                     this._gridBox.updateStyleXY(11);
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._gridBox.updateStyleXY(12);
               }
               break;
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._gridBox.updateStyleXY(13);
                     break;
                  case TofflistTwoGradeMenu.LEVEL:
                     this._gridBox.updateStyleXY(14);
                     break;
                  case TofflistTwoGradeMenu.ASSETS:
                     this._gridBox.updateStyleXY(15);
                     break;
                  case TofflistTwoGradeMenu.CHARM:
                     this._gridBox.updateStyleXY(16);
               }
         }
      }
      
      private function __pgdnHandler(param1:MouseEvent) : void
      {
         if(!this._currentData)
         {
            return;
         }
         SoundManager.instance.play("008");
         ++this._currentPage;
         this._gridBox.orderList.items(this._currentData,this._currentPage);
         this.checkPageBtn();
      }
      
      private function __pgupHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this._currentPage;
         this._gridBox.orderList.items(this._currentData,this._currentPage);
         this.checkPageBtn();
      }
      
      private function __searchOrderHandler(param1:TofflistEvent) : void
      {
         var _loc2_:String = null;
         this._contro.clearDisplayContent();
         if(TofflistModel.firstMenuType == TofflistStairMenu.PERSONAL)
         {
            _loc2_ = "personal";
            if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("personalBattleAccumulate","CelebByDayFightPowerList.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("individualGradeDay","CelebByDayGPList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("individualGradeWeek","CelebByWeekGPList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("individualGradeAccumulate","CelebByGPList.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ACHIEVEMENTPOINT)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("PersonalAchievementPointDay","CelebByAchievementPointDayList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("PersonalAchievementPointWeek","CelebByAchievementPointWeekList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("PersonalAchievementPoint","CelebByAchievementPointList.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.CHARM)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("PersonalCharmvalueDay","CelebByDayGiftGp.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("PersonalCharmvalueWeek","CelebByWeekGiftGp.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("PersonalCharmvalue","CelebByGiftGpList.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.MATCHES)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("personalMatchesWeek","CelebByWeekLeagueScore.xml",_loc2_);
               }
            }
         }
         else if(TofflistModel.firstMenuType == TofflistStairMenu.CONSORTIA)
         {
            _loc2_ = "sociaty";
            if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("consortiaBattleAccumulate","CelebByConsortiaFightPower.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("consortiaGradeAccumulate","CelebByConsortiaLevel.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("consortiaAssetDay","CelebByConsortiaDayRiches.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("consortiaAssetWeek","CelebByConsortiaWeekRiches.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("consortiaAssetAccumulate","CelebByConsortiaRiches.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.CHARM)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("ConsortiaCharmvalueDay","CelebByConsortiaDayGiftGp.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("ConsortiaCharmvalueWeek","CelebByConsortiaWeekGiftGp.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("ConsortiaCharmvalue","CelebByConsortiaGiftGp.xml",_loc2_);
               }
            }
         }
         else if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_PERSONAL)
         {
            _loc2_ = "personal";
            if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerPersonalBattleAccumulate","AreaCelebByDayFightPowerList.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerIndividualGradeDay","AreaCelebByDayGPList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerIndividualGradeWeek","AreaCelebByWeekGPList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerIndividualGradeAccumulate","AreaCelebByGPList.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ACHIEVEMENTPOINT)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerPersonalAchievementPointDay","AreaCelebByAchievementPointDayList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerPersonalAchievementPointWeek","AreaCelebByAchievementPointWeekList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerPersonalAchievementPoint","AreaCelebByAchievementPointList.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.CHARM)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerPersonalCharmvalueDay","AreaCelebByGiftGpDayList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerPersonalCharmvalueWeek","AreaCelebByGiftGpWeekList.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerPersonalCharmvalue","AreaCelebByGiftGpList.xml",_loc2_);
               }
            }
         }
         else if(TofflistModel.firstMenuType == TofflistStairMenu.CROSS_SERVER_CONSORTIA)
         {
            _loc2_ = "sociaty";
            if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.LEVEL)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerConsortiaGradeAccumulate","AreaCelebByConsortiaLevel.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.ASSETS)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerConsortiaAssetDay","AreaCelebByConsortiaDayRiches.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerConsortiaAssetWeek","AreaCelebByConsortiaWeekRiches.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerConsortiaAssetAccumulate","AreaCelebByConsortiaRiches.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.BATTLE)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerConsortiaBattleAccumulate","AreaCelebByConsortiaFightPower.xml",_loc2_);
               }
            }
            else if(TofflistModel.secondMenuType == TofflistTwoGradeMenu.CHARM)
            {
               if(this._thirdClassMenu.type == TofflistThirdClassMenu.DAY)
               {
                  this._contro.loadFormData("crossServerConsortiaCharmvalueDay","AreaCelebByConsortiaDayGiftGp.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.WEEK)
               {
                  this._contro.loadFormData("crossServerConsortiaCharmvalueWeek","AreaCelebByConsortiaWeekGiftGp.xml",_loc2_);
               }
               else if(this._thirdClassMenu.type == TofflistThirdClassMenu.TOTAL)
               {
                  this._contro.loadFormData("crossServerConsortiaCharmvalue","AreaCelebByConsortiaGiftGp.xml",_loc2_);
               }
            }
         }
      }
      
      private function __selectChildBarHandler(param1:TofflistEvent) : void
      {
         this._contro.clearDisplayContent();
         this._thirdClassMenu.selectType(this._stairMenu.type,TofflistModel.secondMenuType);
      }
      
      private function __selectStairMenuHandler(param1:TofflistEvent) : void
      {
         this._contro.clearDisplayContent();
         this._twoGradeMenu.setParentType(TofflistModel.firstMenuType);
      }
      
      private function addEvent() : void
      {
         this._thirdClassMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__searchOrderHandler);
         this._twoGradeMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__selectChildBarHandler);
         this._stairMenu.addEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__selectStairMenuHandler);
         TofflistModel.addEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,this.__menuTypeHandler);
         this._pgup.addEventListener(MouseEvent.CLICK,this.__pgupHandler);
         this._pgdn.addEventListener(MouseEvent.CLICK,this.__pgdnHandler);
         this.addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
      }
      
      private function checkPageBtn() : void
      {
         if(this._currentPage <= 1)
         {
            this._pgup.enable = false;
         }
         else
         {
            this._pgup.enable = true;
         }
         if(this._currentPage < this._totalPage)
         {
            this._pgdn.enable = true;
         }
         else
         {
            this._pgdn.enable = false;
         }
         this._pageTxt.text = String(this._currentPage);
      }
      
      private function init() : void
      {
         this._stairMenu = ComponentFactory.Instance.creatCustomObject("tofflist.stairMenu");
         addChild(this._stairMenu);
         this._twoGradeMenu = ComponentFactory.Instance.creatCustomObject("tofflist.twoGradeMenu");
         addChild(this._twoGradeMenu);
         this._thirdClassMenu = ComponentFactory.Instance.creatCustomObject("tofflist.hirdClassMenu");
         addChild(this._thirdClassMenu);
         this._gridBox = ComponentFactory.Instance.creatCustomObject("tofflist.gridBox");
         addChild(this._gridBox);
         this._pgup = ComponentFactory.Instance.creatComponentByStylename("toffilist.prePageBtn");
         addChild(this._pgup);
         this._pgdn = ComponentFactory.Instance.creatComponentByStylename("toffilist.nextPageBtn");
         addChild(this._pgdn);
         this._upDownTextBg = ComponentFactory.Instance.creat("asset.Toffilist.upDownTextBgImgAsset");
         addChild(this._upDownTextBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("toffilist.pageTxt");
         addChild(this._pageTxt);
      }
      
      private function removeEvent() : void
      {
         this._stairMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__selectStairMenuHandler);
         this._twoGradeMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__selectChildBarHandler);
         this._thirdClassMenu.removeEventListener(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.__searchOrderHandler);
         TofflistModel.removeEventListener(TofflistEvent.TOFFLIST_TYPE_CHANGE,this.__menuTypeHandler);
         this._pgup.removeEventListener(MouseEvent.CLICK,this.__pgupHandler);
         this._pgdn.removeEventListener(MouseEvent.CLICK,this.__pgdnHandler);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
      }
   }
}
