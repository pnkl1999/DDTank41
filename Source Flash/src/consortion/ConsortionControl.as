package consortion
{
   import consortion.event.ConsortionEvent;
   import consortion.view.club.ClubView;
   import consortion.view.selfConsortia.SelfConsortiaView;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatInputView;
   import flash.events.Event;
   
   public class ConsortionControl extends BaseStateView
   {
       
      
      private var _club:ClubView;
      
      private var _selfConsortia:SelfConsortiaView;
      
      private var _state:String;
      
      public function ConsortionControl()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         MainToolBar.Instance.show();
         ChatManager.Instance.state = ChatManager.CHAT_CONSORTIA_CHAT_VIEW;
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            ChatManager.Instance.input.savePreChannel();
            ChatManager.Instance.inputChannel = ChatInputView.CONSORTIA;
         }
         SocketManager.Instance.out.sendCurrentState(1);
         this.initEvent();
         this.enterCurrentView();
         addChild(ChatManager.Instance.view);
      }
      
      private function enterCurrentView() : void
      {
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            this.consortiaState = ConsortionModel.SELF_CONSORTIA;
         }
         else
         {
            this.consortiaState = ConsortionModel.CLUB;
         }
      }
      
      private function set consortiaState(param1:String) : void
      {
         if(this._state == param1)
         {
            return;
         }
         this._state = param1;
         if(param1 == ConsortionModel.CLUB)
         {
            if(this._selfConsortia)
            {
               this._selfConsortia.dispose();
            }
            this._selfConsortia = null;
            if(this._club == null)
            {
               this._club = new ClubView();
            }
            this._club.enterClub();
            addChildAt(this._club,0);
         }
         else
         {
            if(this._club)
            {
               this._club.dispose();
            }
            this._club = null;
            if(this._selfConsortia == null)
            {
               this._selfConsortia = new SelfConsortiaView();
            }
            this._selfConsortia.enterSelfConsortion();
            addChildAt(this._selfConsortia,0);
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         super.leaving(param1);
         this._state = "";
         this.removeEvent();
         if(this._club)
         {
            this._club.dispose();
         }
         this._club = null;
         if(this._selfConsortia)
         {
            this._selfConsortia.dispose();
         }
         this._selfConsortia = null;
         MainToolBar.Instance.hide();
         ChatManager.Instance.input.revertChannel();
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.CONSORTIA;
      }
      
      private function initEvent() : void
      {
         ConsortionModelControl.Instance.addEventListener(ConsortionEvent.CONSORTION_STATE_CHANGE,this.____consortiaStateChannge);
      }
      
      private function removeEvent() : void
      {
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.CONSORTION_STATE_CHANGE,this.____consortiaStateChannge);
      }
      
      private function ____consortiaStateChannge(param1:Event) : void
      {
         this.enterCurrentView();
      }
   }
}
