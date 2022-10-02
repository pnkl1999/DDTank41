package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import farm.FarmModelController;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CountdownView extends Sprite
   {
       
      
      private var _fastForward:BaseButton;
      
      private var _fieldID:int;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      public function CountdownView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._fastForward = ComponentFactory.Instance.creatComponentByStylename("farm.fastForwardBtn");
         addChild(this._fastForward);
      }
      
      public function setCountdown(param1:int) : void
      {
         this._fieldID = param1;
      }
      
      public function setFastBtnEnable(param1:Boolean) : void
      {
         this._fastForward.visible = param1;
      }
      
      private function initEvent() : void
      {
         this._fastForward.addEventListener(MouseEvent.CLICK,this.__fastBtnClick);
      }
      
      protected function __fastBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.visible = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.farms.fastForwardInfo",FarmModelController.instance.gropPrice),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         var _loc2_:Boolean = (param1.target as BaseAlerFrame).isBand;
         (param1.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         (param1.target as BaseAlerFrame).dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc3_ = FarmModelController.instance.gropPrice;
            //ConsoleLog.write("gropPrice = " + FarmModelController.instance.gropPrice);
            if(this.checkMoney(false,_loc3_))
            {
               return;
            }
            SocketManager.Instance.out.fastForwardGrop(_loc2_,false,this._fieldID);
         }
      }
      
      public function checkMoney(param1:Boolean, param2:int, param3:Function = null) : Boolean
      {
         this._money = param2;
         this._outFun = param3;
         //ConsoleLog.write("PlayerMoney = " + PlayerManager.Instance.Self.Money);
         //ConsoleLog.write("param2 = " + param2);
         if(PlayerManager.Instance.Self.Money < param2)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      private function remvoeEvent() : void
      {
         this._fastForward.removeEventListener(MouseEvent.CLICK,this.__fastBtnClick);
      }
      
      public function dispose() : void
      {
         this.remvoeEvent();
         if(this._fastForward)
         {
            this._fastForward.dispose();
            this._fastForward = null;
         }
      }
   }
}
