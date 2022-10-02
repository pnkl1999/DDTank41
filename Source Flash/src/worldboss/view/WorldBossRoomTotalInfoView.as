package worldboss.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   import worldboss.player.RankingPersonInfo;
   
   public class WorldBossRoomTotalInfoView extends Sprite implements Disposeable
   {
       
      
      private var _totalInfoBg:ScaleBitmapImage;
      
      private var _totalInfo_time:FilterFrameText;
      
      private var _totalInfo_yourSelf:FilterFrameText;
      
      private var _totalInfo_timeTxt:FilterFrameText;
      
      private var _totalInfo_yourSelfTxt:FilterFrameText;
      
      private var _txtArr:Array;
      
      private var _show_totalInfoBtnIMG:ScaleFrameImage;
      
      private var _open_show:Boolean = true;
      
      private var _show_totalInfoBtn:SimpleBitmapButton;
      
      public function WorldBossRoomTotalInfoView()
      {
         super();
         this._txtArr = new Array();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._totalInfoBg = ComponentFactory.Instance.creat("worldBossRoom.totalInfoBg");
         addChild(this._totalInfoBg);
         this.creatTxtInfo();
         this._show_totalInfoBtn = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.showTotalBtn");
         addChild(this._show_totalInfoBtn);
         this._open_show = true;
         this._show_totalInfoBtnIMG = ComponentFactory.Instance.creatComponentByStylename("asset.worldBossRoom.showTotalBtnIMG");
         this._show_totalInfoBtnIMG.setFrame(1);
         this._show_totalInfoBtn.addChild(this._show_totalInfoBtnIMG);
      }
      
      private function creatTxtInfo() : void
      {
         var _loc2_:FilterFrameText = null;
         this._totalInfo_time = ComponentFactory.Instance.creat("worldBossRoom.totalInfo.time");
         this._totalInfo_yourSelf = ComponentFactory.Instance.creat("worldBossRoom.totalInfo.yourself");
         this._totalInfo_timeTxt = ComponentFactory.Instance.creat("worldBossRoom.totalInfo.timeTxt");
         this._totalInfo_yourSelfTxt = ComponentFactory.Instance.creat("worldBossRoom.totalInfo.yourselfTxt");
         addChild(this._totalInfo_time);
         addChild(this._totalInfo_yourSelf);
         addChild(this._totalInfo_timeTxt);
         addChild(this._totalInfo_yourSelfTxt);
         this._totalInfo_timeTxt.text = LanguageMgr.GetTranslation("worldboss.totalInfo.time");
         this._totalInfo_yourSelfTxt.text = LanguageMgr.GetTranslation("worldboss.totalInfo.yourself");
         var _loc1_:int = 0;
         while(_loc1_ < 20)
         {
            if(_loc1_ < 3)
            {
               _loc2_ = ComponentFactory.Instance.creat("worldBossRoom.rankingTxt.No" + (_loc1_ + 1));
            }
            else if(_loc1_ < 10)
            {
               _loc2_ = ComponentFactory.Instance.creat("worldBossRoom.rankingTxt.NoOtherLeft");
            }
            else if(_loc1_ < 13)
            {
               _loc2_ = ComponentFactory.Instance.creat("worldBossRoom.rankingTxt.No" + (_loc1_ + 1));
            }
            else
            {
               _loc2_ = ComponentFactory.Instance.creat("worldBossRoom.rankingTxt.NoOtherRight");
            }
            _loc2_.y += int(_loc1_ % 10) * 24;
            addChild(_loc2_);
            this._txtArr.push(_loc2_);
            _loc1_++;
         }
         if(WorldBossManager.Instance.bossInfo.fightOver)
         {
            this._txtArr[0].text = LanguageMgr.GetTranslation("worldboss.ranking.over");
         }
         else
         {
            this._txtArr[0].text = LanguageMgr.GetTranslation("worldbossRoom.ranking.proploading");
         }
      }
      
      private function addEvent() : void
      {
         this._show_totalInfoBtn.addEventListener(MouseEvent.CLICK,this.__showTotalInfo);
      }
      
      private function removeEvent() : void
      {
         this._show_totalInfoBtn.removeEventListener(MouseEvent.CLICK,this.__showTotalInfo);
      }
      
      private function __showTotalInfo(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._show_totalInfoBtnIMG.setFrame(!!this._open_show ? int(2) : int(1));
         addEventListener(Event.ENTER_FRAME,this.__totalViewShowOrHide);
      }
      
      private function __totalViewShowOrHide(param1:Event) : void
      {
         if(this._open_show)
         {
            this.x += 20;
            if(this.x >= StageReferance.stageWidth - 25)
            {
               removeEventListener(Event.ENTER_FRAME,this.__totalViewShowOrHide);
               this.x = StageReferance.stageWidth - 46;
               this._open_show = !this._open_show;
            }
         }
         else
         {
            this.x -= 20;
            if(this.x <= StageReferance.stageWidth - this.width)
            {
               removeEventListener(Event.ENTER_FRAME,this.__totalViewShowOrHide);
               this.x = 760;
               this._open_show = !this._open_show;
            }
         }
      }
      
      public function updata_yourSelf_damage() : void
      {
         this._totalInfo_yourSelf.text = PlayerManager.Instance.Self.damageScores.toString();
      }
      
      public function setTimeCount(param1:int) : void
      {
         this._totalInfo_time.text = this.setFormat(int(param1 / 3600)) + ":" + this.setFormat(int(param1 / 60 % 60)) + ":" + this.setFormat(int(param1 % 60));
      }
      
      public function updataRanking(param1:Array) : void
      {
         var _loc3_:RankingPersonInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as RankingPersonInfo;
            this._txtArr[_loc2_].text = _loc2_ + 1 + "." + _loc3_.name;
            this._txtArr[_loc2_ + 10].text = _loc3_.damage;
            _loc2_++;
         }
      }
      
      private function testshowRanking() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this._txtArr[_loc1_].text = _loc1_ + 1 + ".哈王00" + _loc1_;
            this._txtArr[_loc1_ + 10].text = (9 - _loc1_) * 3 * 10000 + "(2.152%)";
            _loc1_++;
         }
      }
      
      public function restTimeInfo() : void
      {
         this._totalInfo_time.text = "00:00:00";
      }
      
      private function setFormat(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         if(param1 < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            this.parent.removeChild(this);
         }
         this._totalInfoBg = null;
         this._totalInfo_time = null;
         this._totalInfo_yourSelf = null;
         this._totalInfoBg = null;
         this._totalInfoBg = null;
         this._show_totalInfoBtn = null;
         this._show_totalInfoBtnIMG = null;
         this._txtArr = null;
      }
   }
}
