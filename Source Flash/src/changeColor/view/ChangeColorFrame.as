package changeColor.view
{
   import changeColor.ChangeColorCellEvent;
   import changeColor.ChangeColorController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.geom.Rectangle;
   
   public class ChangeColorFrame extends Frame
   {
       
      
      private var _changeColorController:ChangeColorController;
      
      private var _changeColorLeftView:ChangeColorLeftView;
      
      private var _changeColorRightView:ChangeColorRightView;
      
      public function ChangeColorFrame()
      {
         super();
      }
      
      public function set changeColorController(param1:ChangeColorController) : void
      {
         this._changeColorController = param1;
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._changeColorLeftView = null;
         this._changeColorRightView = null;
         this._changeColorController.changeColorModel.clear();
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._changeColorLeftView.model = this._changeColorController.changeColorModel;
         this._changeColorRightView.model = this._changeColorController.changeColorModel;
      }
      
      override protected function init() : void
      {
         var _loc1_:Rectangle = null;
         super.init();
         this._changeColorLeftView = new ChangeColorLeftView();
         addToContent(this._changeColorLeftView);
         this._changeColorRightView = new ChangeColorRightView();
         _loc1_ = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewRec");
         ObjectUtils.copyPropertyByRectangle(this._changeColorRightView,_loc1_);
         addToContent(this._changeColorRightView);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._changeColorRightView.addEventListener(ChangeColorCellEvent.CLICK,this.__cellClickHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_CARD,this.__useCardHandler);
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._changeColorController.close();
         }
      }
      
      private function __cellClickHandler(param1:ChangeColorCellEvent) : void
      {
         if(param1.data.itemInfo && param1.data.itemInfo.NeedSex != (this._changeColorController.changeColorModel.self.Sex == true ? 1 : 2))
         {
            SoundManager.instance.play("008");
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.sexAlert"));
         }
         else if(param1.data != null)
         {
            this._changeColorLeftView.setCurrentItem(param1.data);
         }
      }
      
      private function __useCardHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.failed"));
         }
      }
   }
}
