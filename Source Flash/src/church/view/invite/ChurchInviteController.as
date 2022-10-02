package church.view.invite
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import consortion.ConsortionModelControl;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class ChurchInviteController
   {
       
      
      private var _view:ChurchInviteView;
      
      private var _model:ChurchInviteModel;
      
      public function ChurchInviteController()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._model = new ChurchInviteModel();
         this._view = ComponentFactory.Instance.creat("church.invite.ChurchInviteView");
         this._view.controller = this;
         this._view.model = this._model;
      }
      
      public function getView() : Sprite
      {
         return this._view;
      }
      
      public function refleshList(param1:int, param2:int = 0) : void
      {
         if(param1 == 0)
         {
            this.setList(0,PlayerManager.Instance.onlineFriendList);
         }
         else if(param1 == 1)
         {
            this.setList(1,ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
         }
      }
      
      private function isOnline(param1:*) : Boolean
      {
         return param1.State == 1;
      }
      
      private function setList(param1:int, param2:Array) : void
      {
         this._model.setList(param1,param2);
      }
      
      public function hide() : void
      {
         this._view.hide();
      }
      
      public function showView() : void
      {
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         this._view.show();
      }
      
      public function dispose() : void
      {
         this._model.dispose();
         this._model = null;
         if(this._view && this._view.parent)
         {
            this._view.parent.removeChild(this._view);
         }
         if(this._view)
         {
            this._view.dispose();
         }
         this._view = null;
      }
   }
}
