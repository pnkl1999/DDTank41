package bagAndInfo
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.bossbox.AwardsView;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class BagAndInfoManager extends EventDispatcher
   {
      
      private static var _instance:BagAndInfoManager;
       
      
      private var _bagAndGiftFrame:BagAndGiftFrame;
      
      private var _frame:BaseAlerFrame;
      
      private var _progress:int = 0;
      
      private var infos:Array;
      
      private var _type:int = 0;
      
      public function BagAndInfoManager(param1:SingletonForce)
      {
         super();
      }
      
      public static function get Instance() : BagAndInfoManager
      {
         if(_instance == null)
         {
            _instance = new BagAndInfoManager(new SingletonForce());
         }
         return _instance;
      }
      
      public function get isShown() : Boolean
      {
         if(!this._bagAndGiftFrame)
         {
            return false;
         }
         return true;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_OPENUP,this.__openPreviewListFrame);
      }
      
      protected function __openPreviewListFrame(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         _loc2_.position = 20;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:int = int(_loc2_.readByte());
         this.infos = [];
         while(_loc2_.bytesAvailable)
         {
            _loc5_ = new InventoryItemInfo();
            _loc5_.TemplateID = _loc2_.readInt();
            _loc5_ = ItemManager.fill(_loc5_);
            _loc5_.Count = _loc2_.readInt();
            _loc5_.IsBinds = _loc2_.readBoolean();
            _loc5_.ValidDate = _loc2_.readInt();
            _loc5_.StrengthenLevel = _loc2_.readInt();
            _loc5_.AttackCompose = _loc2_.readInt();
            _loc5_.DefendCompose = _loc2_.readInt();
            _loc5_.AgilityCompose = _loc2_.readInt();
            _loc5_.LuckCompose = _loc2_.readInt();
            this.infos.push(_loc5_);
         }
         this.showPreviewFrame(_loc3_,this.infos);
      }
      
      public function showPreviewFrame(param1:String, param2:Array) : void
      {
         var _loc3_:AwardsView = new AwardsView();
         _loc3_.goodsList = param2;
         _loc3_.boxType = 4;
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bagAndInfo.itemOpenUp");
         this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame");
         var _loc5_:AlertInfo = new AlertInfo(param1);
         _loc5_.showCancel = false;
         _loc5_.moveEnable = false;
         this._frame.info = _loc5_;
         this._frame.addToContent(_loc3_);
         this._frame.addToContent(_loc4_);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameClose(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SoundManager.instance.play("008");
               _loc2_ = param1.currentTarget as BaseAlerFrame;
               _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               _loc2_.dispose();
               SocketManager.Instance.out.sendClearStoreBag();
         }
      }
      
      private function __createBag(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BAG)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
            this._bagAndGiftFrame = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame");
            this.showBagAndInfo(this._type);
         }
      }
      
      public function showBagAndInfo(param1:int = 0, param2:String = "") : void
      {
         if(this._bagAndGiftFrame == null)
         {
            try
            {
               this._bagAndGiftFrame = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame");
               this._bagAndGiftFrame.show(param1,param2);
               dispatchEvent(new Event(Event.OPEN));
            }
            catch(e:Error)
            {
               UIModuleLoader.Instance.addUIModlue(UIModuleTypes.BAG);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createBag);
            }
         }
         else
         {
            this._bagAndGiftFrame.show(param1);
            dispatchEvent(new Event(Event.OPEN));
         }
      }
      
      public function hideBagAndInfo() : void
      {
         if(this._bagAndGiftFrame)
         {
            this._bagAndGiftFrame.dispose();
            this._bagAndGiftFrame = null;
            dispatchEvent(new Event(Event.CLOSE));
         }
      }
      
      public function clearReference() : void
      {
         this._bagAndGiftFrame = null;
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

class SingletonForce
{
    
   
   function SingletonForce()
   {
      super();
   }
}
