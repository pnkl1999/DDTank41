package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import road7th.comm.PackageIn;
   
   public class TotemMainView extends Sprite implements Disposeable
   {
       
      
      private var _leftView:TotemLeftView;
      
      private var _rightView:TotemRightView;
      
      private var _activateProtectView:TotemActivateProtectView;
      
      public function TotemMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._leftView = ComponentFactory.Instance.creatCustomObject("totemLeftView");
         this._rightView = ComponentFactory.Instance.creatCustomObject("totemRightView");
         this._activateProtectView = new TotemActivateProtectView();
         addChild(this._rightView);
         addChild(this._leftView);
         addChild(this._activateProtectView);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOTEM,this.refresh);
      }
      
      private function refresh(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:PackageIn = param1.pkg;
         _loc3_.readInt();
         PlayerManager.Instance.Self.damageScores = _loc3_.readInt();
         var _loc4_:int = _loc3_.readInt();
         if(_loc4_ == PlayerManager.Instance.Self.totemId)
         {
            _loc2_ = false;
            SoundManager.instance.play("202");
         }
         else
         {
            SoundManager.instance.play("201");
            _loc2_ = true;
            PlayerManager.Instance.Self.totemId = _loc4_;
         }
         this._leftView.refreshView(_loc2_);
         this._rightView.refreshView();
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOTEM,this.refresh);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._leftView = null;
         this._rightView = null;
         this._activateProtectView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
