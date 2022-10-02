package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.GameManager;
   
   public class SmallPlayerTip extends BaseTip implements ITip
   {
      
      private static var _instance:SmallPlayerTip;
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _lv:Bitmap;
      
      private var _winRate:WinRate;
      
      private var _battle:Battle;
      
      private var _tipContainer:Sprite;
      
      private var _nameField:FilterFrameText;
      
      private var _level:int;
      
      private var _reputeCount:int;
      
      private var _win:int;
      
      private var _total:int;
      
      private var _enableTip:Boolean;
      
      private var _tip:Sprite;
      
      private var _tipInfo:Object;
      
      private var _battleNum:int;
      
      private var _exploitValue:int;
      
      private var _bgH:int;
      
      public function SmallPlayerTip()
      {
         if(!_instance)
         {
            super();
            _instance = this;
         }
      }
      
      public static function get instance() : SmallPlayerTip
      {
         if(!instance)
         {
            _instance = new SmallPlayerTip();
         }
         return _instance;
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._tipbackgound = this._bg;
         this._lv = ComponentFactory.Instance.creatBitmap("asset.core.leveltip.LevelTipLv");
         this._lv.x = 4;
         this._lv.y = 28;
         this.createLevelTip();
         super.init();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         this._nameField = ComponentFactory.Instance.creatComponentByStylename("game.smallplayer.NameField");
         addChild(this._nameField);
         addChild(this._lv);
         addChild(this._tipContainer);
         this.updateWH();
      }
      
      public function get txtPos() : Point
      {
         var _loc1_:Point = new Point();
         if(this._lv)
         {
            _loc1_.x = this._lv.x + this._lv.width + 3;
            _loc1_.y = this._lv.y + 4;
         }
         return _loc1_;
      }
      
      override public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1 is LevelTipInfo)
         {
            this.visible = true;
            this.makeTip(param1);
         }
         else
         {
            this.visible = false;
         }
         this._tipInfo = param1;
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      private function createLevelTip() : void
      {
         this._tipContainer = new Sprite();
         this._winRate = new WinRate(this._win,this._total);
         this._battle = new Battle(this._battleNum);
         this._winRate.y = 52;
         this._battle.y = 77;
         this._battle.x = 10;
         this._winRate.x = 10;
         this._tipContainer.addChild(this._winRate);
         this._tipContainer.addChild(this._battle);
      }
      
      private function makeTip(param1:Object) : void
      {
         if(param1)
         {
            this.resetLevelTip(param1.Level,param1.Repute,param1.Win,param1.Total,param1.Battle,param1.exploit,param1.enableTip,param1.team,param1.nickName);
         }
      }
      
      private function resetLevelTip(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:Boolean = true, param8:int = 1, param9:String = "") : void
      {
         this._level = param1;
         this._reputeCount = param2;
         this._win = param3;
         this._total = param4;
         this._exploitValue = param6;
         this._enableTip = param7;
         this._nameField.text = param9;
         this.visible = this._enableTip;
         if(!this._enableTip)
         {
            return;
         }
         this.setRepute(this._level,this._reputeCount);
         this.setRate(param3,param4);
         this.setBattle(param5);
         this.setExploit(this._exploitValue);
         if(this._bgH == 0)
         {
            this._bgH = this._bg.height;
         }
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(param8 != GameManager.Instance.Current.selfGamePlayer.team)
            {
               this._battle.visible = false;
               this._bg.height = this._bgH - 20 - 20;
            }
            else
            {
               this._battle.visible = true;
               this._bg.height = this._bgH - 20;
            }
         }
         else
         {
            this._battle.visible = true;
            this._bg.height = this._bgH - 20;
         }
         this.updateTip();
      }
      
      private function setRepute(param1:int, param2:int) : void
      {
      }
      
      private function setRate(param1:int, param2:int) : void
      {
         this._winRate.setRate(param1,param2);
      }
      
      private function setBattle(param1:int) : void
      {
         this._battle.BattleNum = param1;
      }
      
      private function setExploit(param1:int) : void
      {
      }
      
      private function updateTip() : void
      {
         if(this._tip)
         {
            this.removeChild(this._tip);
         }
         this._tip = new Sprite();
         LevelPicCreater.creatLevelPicInContainer(this._tip,this._level,int(this.txtPos.x),int(this.txtPos.y));
         addChild(this._tip);
         this._bg.width = this._tipContainer.width + 15;
         this.updateWH();
      }
      
      override public function dispose() : void
      {
         if(this._tip)
         {
            if(this._tip.parent)
            {
               this._tip.parent.removeChild(this._tip);
            }
         }
         this._tip = null;
         if(this._tipContainer)
         {
            if(this._tipContainer.parent)
            {
               this._tipContainer.parent.removeChild(this._tipContainer);
            }
         }
         this._tipContainer = null;
         ObjectUtils.disposeObject(this._winRate);
         this._winRate = null;
         ObjectUtils.disposeObject(this._battle);
         this._battle = null;
         if(this._lv)
         {
            ObjectUtils.disposeObject(this._lv);
         }
         this._lv = null;
         ObjectUtils.disposeObject(this);
         _instance = null;
         super.dispose();
      }
   }
}
