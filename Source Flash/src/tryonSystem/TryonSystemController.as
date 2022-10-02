package tryonSystem
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class TryonSystemController
   {
      
      private static var _instance:TryonSystemController;
       
      
      private var _view:Frame;
      
      private var _model:TryonModel;
      
      private var _sumbmitFun:Function;
      
      private var _cancelFun:Function;
      
      public function TryonSystemController()
      {
         super();
      }
      
      public static function get Instance() : TryonSystemController
      {
         if(_instance == null)
         {
            _instance = new TryonSystemController();
         }
         return _instance;
      }
      
      public function get model() : TryonModel
      {
         return this._model;
      }
      
      public function get view() : Frame
      {
         return this._view;
      }
      
      public function show(param1:Array, param2:Function = null, param3:Function = null) : void
      {
         this._model = new TryonModel(param1);
         this._sumbmitFun = param2;
         this._cancelFun = param3;
         if(EquipType.isAvatar(InventoryItemInfo(param1[0]).CategoryID))
         {
            this._view = ComponentFactory.Instance.creatComponentByStylename("tryonSystem.tryonFrame") as TryonPanelFrame;
            TryonPanelFrame(this._view).controller = this;
         }
         else
         {
            this._view = ComponentFactory.Instance.creatComponentByStylename("tryonSystem.ChoosePanelFrame") as ChooseFrame;
            ChooseFrame(this._view).controller = this;
         }
         this._view.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._view.addEventListener(Event.REMOVED_FROM_STAGE,this.__onRemoved);
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      private function __onRemoved(param1:Event) : void
      {
         if(this._view)
         {
            this._view.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         if(this._view)
         {
            this._view.removeEventListener(Event.REMOVED_FROM_STAGE,this.__onRemoved);
         }
         this._view = null;
         if(this._model)
         {
            this._model.dispose();
         }
         this._model = null;
         this._cancelFun = null;
         this._sumbmitFun = null;
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._cancelFun != null)
               {
                  this._cancelFun();
               }
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(!this._model.selectedItem)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.tryonSystem.tryon"));
                  return;
               }
               if(this._sumbmitFun != null)
               {
                  this._sumbmitFun(this._model.selectedItem);
               }
               break;
         }
         if(this._view)
         {
            this._view.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         if(this._view)
         {
            this._view.removeEventListener(Event.REMOVED_FROM_STAGE,this.__onRemoved);
         }
         if(this._view)
         {
            this._view.dispose();
         }
         this._view = null;
         if(this._model)
         {
            this._model.dispose();
         }
         this._model = null;
         this._cancelFun = null;
         this._sumbmitFun = null;
      }
   }
}
