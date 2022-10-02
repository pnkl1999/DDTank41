package eliteGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import eliteGame.EliteGameController;
   import eliteGame.EliteGameEvent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EliteGameRuleView extends Sprite implements Disposeable
   {
       
      
      private var _ruleBmp:Bitmap;
      
      private var _btnBG:ScaleBitmapImage;
      
      private var _joinScoreRoom:SimpleBitmapButton;
      
      private var _showRank:SimpleBitmapButton;
      
      public function EliteGameRuleView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._ruleBmp = ComponentFactory.Instance.creatBitmap("EliteGame.ruleBmp");
         this._btnBG = ComponentFactory.Instance.creatComponentByStylename("eliteGame.ruleview.btnBG");
         this._joinScoreRoom = ComponentFactory.Instance.creatComponentByStylename("eliteGame.ruleview.joinRoom");
         this._showRank = ComponentFactory.Instance.creatComponentByStylename("eliteGame.ruleview.showRank");
         addChild(this._ruleBmp);
         addChild(this._btnBG);
         addChild(this._joinScoreRoom);
         addChild(this._showRank);
         this._joinScoreRoom.enable = false;
         this.checkState();
         this._joinScoreRoom.addEventListener(MouseEvent.CLICK,this.__joinHandler);
         this._showRank.addEventListener(MouseEvent.CLICK,this.__showHandler);
         EliteGameController.Instance.addEventListener(EliteGameEvent.ELITEGAME_STATE_CHANGE,this.__stateChangeHandler);
      }
      
      private function checkState() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 30 && PlayerManager.Instance.Self.Grade <= 40 && this.hasState(EliteGameController.SCORE_PHASE_30_40) || PlayerManager.Instance.Self.Grade >= 41 && PlayerManager.Instance.Self.Grade <= 50 && this.hasState(EliteGameController.SCORE_PHASE_41_50))
         {
            this._joinScoreRoom.enable = true;
         }
         else
         {
            this._joinScoreRoom.enable = false;
         }
         if(this.hasState(EliteGameController.CHAMPION_PHASE_30_40) || this.hasState(EliteGameController.CHAMPION_PHASE_41_50))
         {
         }
      }
      
      private function hasState(param1:int) : Boolean
      {
         var _loc2_:Array = EliteGameController.Instance.getState();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function __stateChangeHandler(param1:Event) : void
      {
         this.checkState();
      }
      
      protected function __showHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         EliteGameController.Instance.alertPaarungFrame();
      }
      
      protected function __joinHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         EliteGameController.Instance.joinEliteGame();
      }
      
      public function dispose() : void
      {
         this._joinScoreRoom.removeEventListener(MouseEvent.CLICK,this.__joinHandler);
         this._showRank.removeEventListener(MouseEvent.CLICK,this.__showHandler);
         EliteGameController.Instance.removeEventListener(EliteGameEvent.ELITEGAME_STATE_CHANGE,this.__stateChangeHandler);
         if(this._ruleBmp)
         {
            ObjectUtils.disposeObject(this._ruleBmp);
         }
         this._ruleBmp = null;
         if(this._btnBG)
         {
            ObjectUtils.disposeObject(this._btnBG);
         }
         this._btnBG = null;
         if(this._joinScoreRoom)
         {
            ObjectUtils.disposeObject(this._joinScoreRoom);
         }
         this._joinScoreRoom = null;
         if(this._showRank)
         {
            ObjectUtils.disposeObject(this._showRank);
         }
         this._showRank = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
